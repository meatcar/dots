import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

parser = argparse.ArgumentParser(
    description="Exercise khal startup recovery in the real QML backend."
)
parser.add_argument("backend", type=Path)
source = parser.parse_args().backend
quickshell = shutil.which("quickshell")

for scenario in (
    "list-failure",
    "format-failure",
    "healthy",
    "persistent-failure",
    "persistent-list-failure",
):
    with tempfile.TemporaryDirectory() as directory:
        root = Path(directory).resolve()
        for module in ("Common", "Services", "bin", "run"):
            (root / module).mkdir(mode=0o700)
        (root / "CalendarKhalBackend.qml").write_text(
            source.read_text().replace("interval: 30000", "interval: 100")
        )
        (root / "Common/qmldir").write_text(
            "module qs.Common\nsingleton Log 1.0 Log.qml\n"
        )
        (root / "Common/Log.qml").write_text(
            "pragma Singleton\nimport QtQml\nQtObject { function scoped(name) { return { warn: message => console.warn(message) }; } }\n"
        )
        (root / "Services/qmldir").write_text(
            "module qs.Services\nsingleton I18n 1.0 I18n.qml\n"
        )
        (root / "Services/I18n.qml").write_text(
            'pragma Singleton\nimport QtQml\nQtObject { function locale() { return Qt.locale("en_US"); } }\n'
        )
        (root / "shell.qml").write_text("""import QtQuick
import Quickshell
ShellRoot {
    CalendarKhalBackend { id: backend; enabled: true }
    Timer {
        interval: 2000
        running: true
        onTriggered: {
            console.warn("RESULT", JSON.stringify({installed: backend.installed, events: backend.eventsByDate, error: backend.lastError}));
            Qt.quit();
        }
    }
}
""")
        khal = root / "bin/khal"
        khal.write_text(
            f"#!{sys.executable}\n"
            + """import fcntl, json, os, pathlib, sys, time
root = pathlib.Path(__file__).resolve().parents[1]
lock = (root / "lock").open("w")
try:
    fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
except BlockingIOError:
    (root / "overlap").touch()
    sys.exit(2)
scenario = os.environ["TEST_SCENARIO"]
kind = "format" if sys.argv[1] == "printformats" else "events" if "--json" in sys.argv else "list"
with (root / "calls").open("a") as f:
    f.write(kind + "\\n")
calls = (root / "calls").read_text().splitlines()
time.sleep(0.15)
if scenario == "persistent-failure" or (scenario == "persistent-list-failure" and kind == "list") or (scenario == "list-failure" and kind == "list" and calls.count(kind) == 1) or (scenario == "format-failure" and kind == "format" and calls.count(kind) == 1):
    print("fixture: database is locked", file=sys.stderr)
    sys.exit(1)
if kind == "format":
    print("dateformat: 21/12/2013")
elif kind == "events":
    print(json.dumps([{"title": "Fixture event", "start-date": "21/12/2013", "end-date": "21/12/2013", "start-time": "14:00", "end-time": "14:30", "all-day": "False"}]))
"""
        )
        khal.chmod(0o755)
        env = dict(
            PATH=str(root / "bin") + ":" + os.environ["PATH"],
            QT_QPA_PLATFORM="offscreen",
            TEST_SCENARIO=scenario,
            HOME=str(root),
            XDG_RUNTIME_DIR=str(root / "run"),
            TZ="UTC",
        )
        try:
            result = subprocess.run(
                [quickshell, "-p", str(root / "shell.qml")],
                env=env,
                text=True,
                capture_output=True,
                timeout=10,
            )
        except subprocess.TimeoutExpired as error:
            raise AssertionError(str(error.stdout) + str(error.stderr)) from None
        output = result.stdout + result.stderr
        calls = (
            (root / "calls").read_text().splitlines()
            if (root / "calls").exists()
            else []
        )
        assert result.returncode == 0, output
        assert not (root / "overlap").exists(), (
            f"{scenario}: overlapping khal processes"
        )
        results = [
            json.loads(line.split("RESULT ", 1)[1])
            for line in output.splitlines()
            if "RESULT " in line
        ]
        assert len(results) == 1, output
        state = results[0]
        if scenario.startswith("persistent"):
            assert not state["installed"] and state["events"] == {}, state
            assert "fixture: database is locked" in state["error"], state
        else:
            assert state["installed"] and state["error"] == "", state
            assert list(state["events"]) == ["2013-12-21"], state
            events = state["events"]["2013-12-21"]
            assert len(events) == 1, events
            assert events[0]["title"] == "Fixture event", events
            assert events[0]["start"] == "2013-12-21T14:00:00.000Z", events
            assert events[0]["end"] == "2013-12-21T14:30:00.000Z", events
        if scenario == "healthy":
            assert calls == ["format", "list", "events"], calls
        if scenario == "list-failure":
            assert calls == ["format", "list", "format", "list", "events"], calls
        if scenario == "format-failure":
            assert calls == ["format", "format", "list", "events"], calls
        if scenario != "healthy":
            assert "fixture: database is locked" in output, output
        if scenario.startswith("persistent"):
            assert calls.count("format") > 1 and "events" not in calls, calls
            if scenario == "persistent-list-failure":
                assert calls.count("list") > 1, calls
            warnings = [
                line
                for line in output.splitlines()
                if "fixture: database is locked" in line and "RESULT" not in line
            ]
            assert len(warnings) == 1, warnings
        print(f"PASS {scenario}: {calls}")
