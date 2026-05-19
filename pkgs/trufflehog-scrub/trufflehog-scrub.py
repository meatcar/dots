#!/usr/bin/env python3
"""Act on trufflehog --json findings read from stdin.

Findings are grouped by a hash of the secret so each unique secret is shown
exactly once. Raw secrets are never written to disk, logs, or summary output;
they only live in memory during the run.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import signal
import sys
from collections import defaultdict
from dataclasses import dataclass, field
from pathlib import Path


@dataclass
class Finding:
    detector: str
    detector_type: str
    decoder: str
    verified: bool
    verification_error: str
    extra_data: dict
    raw: str
    raw_v2: str
    file: str
    line: int


@dataclass
class Location:
    file: str
    line: int        # 0 means unknown
    source: str      # "scan" or "trufflehog"


@dataclass
class Group:
    hash: str
    detector: str
    detector_type: str
    decoder: str
    verified: bool
    verification_error: str
    extra_data: dict
    raw: str
    raw_v2: str
    locations: list[Location]


@dataclass
class Outcome:
    detector: str
    locations: int
    files_changed: list[str] = field(default_factory=list)
    occurrences: int = 0
    action: str = "pending"


class TerminatedBySignal(KeyboardInterrupt):
    pass


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(
        prog="trufflehog-scrub",
        description="Consume trufflehog --json output on stdin and interactively "
        "redact the secrets in the files where they were found.",
        epilog="Example: trufflehog filesystem ./src --json | trufflehog-scrub",
    )
    p.add_argument(
        "--dry-run",
        action="store_true",
        help="list findings only; never modify files",
    )
    p.add_argument(
        "-y", "--yes",
        action="store_true",
        help="auto-approve all redactions (no prompts)",
    )
    p.add_argument(
        "--replacement",
        metavar="TEXT",
        help="replacement string (default: [REDACTED:<DETECTOR>])",
    )
    p.add_argument(
        "--only-verified",
        action="store_true",
        help="ignore unverified findings",
    )
    p.add_argument(
        "--context",
        type=int,
        default=8,
        metavar="N",
        help="lines of file context to show around each finding (default: 8)",
    )
    return p.parse_args()


def secret_hash(s: str) -> str:
    return hashlib.sha256(s.encode("utf-8", "replace")).hexdigest()[:12]


@dataclass
class ReadResult:
    findings: list[Finding]
    nonblank_lines: int
    parse_failures: int


def read_findings(verified_only: bool) -> ReadResult:
    out: list[Finding] = []
    nonblank = 0
    failures = 0
    for raw_line in sys.stdin:
        raw_line = raw_line.strip()
        if not raw_line:
            continue
        nonblank += 1
        try:
            obj = json.loads(raw_line)
        except json.JSONDecodeError:
            failures += 1
            continue
        fs = (
            obj.get("SourceMetadata", {})
            .get("Data", {})
            .get("Filesystem", {})
            or {}
        )
        extra = obj.get("ExtraData") or {}
        if not isinstance(extra, dict):
            extra = {}
        f = Finding(
            detector=str(obj.get("DetectorName") or "unknown"),
            detector_type=str(obj.get("DetectorType") or ""),
            decoder=str(obj.get("DecoderName") or ""),
            verified=bool(obj.get("Verified", False)),
            verification_error=str(obj.get("VerificationError") or ""),
            extra_data=extra,
            raw=str(obj.get("Raw") or ""),
            raw_v2=str(obj.get("RawV2") or ""),
            file=str(fs.get("file") or ""),
            line=int(fs.get("line") or 0),
        )
        if not f.raw or not f.file:
            continue
        if verified_only and not f.verified:
            continue
        out.append(f)
    return ReadResult(findings=out, nonblank_lines=nonblank, parse_failures=failures)


def needles_for(secret: str, secret_v2: str) -> list[bytes]:
    """Candidate byte sequences to search for in source files.

    Trufflehog's `Raw` is sometimes normalized; `RawV2` is sometimes the
    literal string. We also try whitespace-stripped variants since detectors
    occasionally include surrounding quotes or whitespace.
    """
    out: list[bytes] = []
    seen: set[bytes] = set()
    for s in (secret, secret_v2):
        if not s:
            continue
        for candidate in (s, s.strip()):
            if not candidate:
                continue
            b = candidate.encode("utf-8", "replace")
            if b in seen:
                continue
            seen.add(b)
            out.append(b)
    return out


def locate_in_file(file: str, needles: list[bytes]) -> list[int]:
    """1-based line numbers where any needle appears in `file` (byte-level)."""
    if not needles:
        return []
    p = Path(file)
    if not p.is_file():
        return []
    try:
        data = p.read_bytes()
    except OSError:
        return []
    hits: list[int] = []
    for i, line in enumerate(data.split(b"\n"), start=1):
        if any(n in line for n in needles):
            hits.append(i)
    return hits


def build_groups(findings: list[Finding]) -> list[Group]:
    by_hash: dict[str, list[Finding]] = defaultdict(list)
    for f in findings:
        by_hash[secret_hash(f.raw)].append(f)

    out: list[Group] = []
    for h, fs in by_hash.items():
        f0 = fs[0]
        unique_files: list[str] = []
        seen: set[str] = set()
        for f in fs:
            if f.file and f.file not in seen:
                seen.add(f.file)
                unique_files.append(f.file)

        needles = needles_for(f0.raw, f0.raw_v2)
        locations: list[Location] = []
        for fp in unique_files:
            scanned = locate_in_file(fp, needles)
            if scanned:
                for ln in scanned:
                    locations.append(Location(file=fp, line=ln, source="scan"))
            else:
                # Fall back to trufflehog's line(s) for this file, even if 0.
                for f in fs:
                    if f.file == fp:
                        locations.append(
                            Location(file=fp, line=f.line, source="trufflehog")
                        )
                        break

        out.append(Group(
            hash=h,
            detector=f0.detector,
            detector_type=f0.detector_type,
            decoder=f0.decoder,
            verified=any(x.verified for x in fs),
            verification_error=f0.verification_error,
            extra_data=f0.extra_data,
            raw=f0.raw,
            raw_v2=f0.raw_v2,
            locations=locations,
        ))
    return out


def preview(file: str, line: int, context: int) -> list[str]:
    p = Path(file)
    if not p.is_file():
        return [f"(not a regular file: {file})"]
    try:
        text = p.read_text(encoding="utf-8", errors="replace")
    except OSError as e:
        return [f"(could not read: {e})"]
    lines = text.splitlines()
    if not lines:
        return ["(empty file)"]
    if line <= 0:
        return ["(no line number available)"]
    target = line
    start = max(1, target - context)
    end = min(len(lines), target + context)
    width = len(str(end))
    out: list[str] = []
    for i in range(start, end + 1):
        marker = "→" if i == target else " "
        out.append(f"    {marker} {i:>{width}} | {lines[i - 1]}")
    return out


def redact_in_file_multi(file: str, needles: list[bytes], replacement: str) -> int:
    """Replace every occurrence of any needle with `replacement`. Returns total."""
    if not needles:
        return 0
    p = Path(file)
    data = p.read_bytes()
    repl = replacement.encode("utf-8", "replace")
    total = 0
    new = data
    for needle in needles:
        if not needle:
            continue
        c = new.count(needle)
        if c:
            new = new.replace(needle, repl)
            total += c
    if total:
        p.write_bytes(new)
    return total


def render_summary(
    hash_order: list[str],
    outcomes: dict[str, Outcome],
    interrupted: bool,
) -> None:
    print("", file=sys.stderr)
    print("=== summary ===", file=sys.stderr)
    if interrupted:
        print("(interrupted before completion)", file=sys.stderr)
    by_action: dict[str, int] = defaultdict(int)
    files_touched: set[str] = set()
    total_occ = 0
    for h in hash_order:
        o = outcomes[h]
        by_action[o.action] += 1
        files_touched.update(o.files_changed)
        total_occ += o.occurrences
        marker = {
            "redacted": "✓",
            "skipped": "·",
            "skipped (quit)": "·",
            "pending": "?",
            "error": "✗",
        }.get(o.action, "·")
        print(
            f"  {marker} {h}  {o.detector:<24} {o.action}"
            + (f"  ({o.occurrences} occ in {len(o.files_changed)} file(s))"
               if o.action == "redacted" else ""),
            file=sys.stderr,
        )
    print(f"  unique secrets: {len(hash_order)}", file=sys.stderr)
    for action, n in sorted(by_action.items()):
        print(f"    {action}: {n}", file=sys.stderr)
    if total_occ:
        print(
            f"  redacted {total_occ} occurrence(s) across {len(files_touched)} file(s)",
            file=sys.stderr,
        )


def render_detail_block(group: Group) -> list[str]:
    """Trufflehog-style detail block for a grouped secret. Includes the raw value."""
    verified = "VERIFIED" if group.verified else "unverified"
    lines: list[str] = []
    lines.append(f"  Found {verified} result")
    lines.append(f"  Detector:        {group.detector}"
                 + (f" (type {group.detector_type})" if group.detector_type else ""))
    if group.decoder:
        lines.append(f"  Decoder:         {group.decoder}")
    lines.append(f"  Hash:            {group.hash}")
    lines.append(f"  Raw:             {group.raw}")
    if group.verification_error:
        lines.append(f"  Verify error:    {group.verification_error}")
    if group.extra_data:
        for k, v in group.extra_data.items():
            lines.append(f"  {k+':':<17}{v}")
    return lines


def prompt_action(
    tty,
    group: Group,
    replacement: str,
    context: int,
) -> tuple[str, str]:
    """Return (action, replacement). action in {redact, skip, all, quit}."""
    preview_idx = 0
    locs = group.locations
    sources = {loc.source for loc in locs}
    if sources == {"scan"}:
        src_label = "content-scan"
    elif sources == {"trufflehog"}:
        src_label = "trufflehog-reported, lines may be inaccurate"
    else:
        src_label = "mixed"
    while True:
        print("", file=sys.stderr)
        print(
            f"━━━ secret {group.hash} — {len(locs)} location(s) ━━━",
            file=sys.stderr,
        )
        print("", file=sys.stderr)
        for dl in render_detail_block(group):
            print(dl, file=sys.stderr)
        print("", file=sys.stderr)
        print(f"  Locations: ({src_label})", file=sys.stderr)
        for i, loc in enumerate(locs, start=1):
            star = "→" if i - 1 == preview_idx else " "
            line_str = str(loc.line) if loc.line > 0 else "?"
            tag = "" if len(sources) == 1 else f"  [{loc.source}]"
            print(f"    {star} {i:>2}. {loc.file}:{line_str}{tag}", file=sys.stderr)
        print("", file=sys.stderr)
        target = locs[preview_idx]
        t_line_str = str(target.line) if target.line > 0 else "?"
        print(f"  Preview {target.file}:{t_line_str}", file=sys.stderr)
        for pl in preview(target.file, target.line, context):
            print(pl, file=sys.stderr)
        print("", file=sys.stderr)
        print(f"  Replacement:     {replacement}", file=sys.stderr)
        print("", file=sys.stderr)
        print(
            "  [r]edact  [s]kip  [e]dit replacement"
            "  [p N] preview Nth location  [A]ll remaining  [q]uit",
            file=sys.stderr,
        )
        sys.stderr.write("  > ")
        sys.stderr.flush()
        line = tty.readline()
        if not line:
            return "quit", replacement
        ans = line.strip()
        if not ans:
            continue
        head, _, tail = ans.partition(" ")
        head = head.lower()
        if head in ("r", "redact"):
            return "redact", replacement
        if head in ("s", "skip"):
            return "skip", replacement
        if head in ("a", "all"):
            return "all", replacement
        if head in ("q", "quit"):
            return "quit", replacement
        if head in ("e", "edit"):
            sys.stderr.write("  new replacement (blank to keep): ")
            sys.stderr.flush()
            new = tty.readline()
            if new is None:
                continue
            new = new.rstrip("\n")
            if new:
                replacement = new
            continue
        if head in ("p", "preview"):
            try:
                idx = int(tail) - 1
            except ValueError:
                print("  usage: p <N>", file=sys.stderr)
                continue
            if 0 <= idx < len(locs):
                preview_idx = idx
            else:
                print(f"  out of range (1..{len(locs)})", file=sys.stderr)
            continue
        print("  unknown choice", file=sys.stderr)


def main() -> int:
    args = parse_args()
    if args.yes and args.dry_run:
        print("error: --yes is incompatible with --dry-run", file=sys.stderr)
        return 2
    if sys.stdin.isatty():
        print(
            "error: expected trufflehog --json output on stdin; "
            "pipe trufflehog ... --json into this command",
            file=sys.stderr,
        )
        return 2

    result = read_findings(args.only_verified)
    findings = result.findings
    if not findings:
        if result.nonblank_lines > 0 and result.parse_failures == result.nonblank_lines:
            print(
                f"error: received {result.nonblank_lines} non-blank line(s) but none "
                "were JSON. Run trufflehog with --json:\n"
                "       trufflehog filesystem . --json | trufflehog-scrub",
                file=sys.stderr,
            )
            return 2
        if result.parse_failures:
            print(
                f"warning: skipped {result.parse_failures} non-JSON line(s) on stdin",
                file=sys.stderr,
            )
        print("No findings.", file=sys.stderr)
        return 0
    if result.parse_failures:
        print(
            f"warning: skipped {result.parse_failures} non-JSON line(s) on stdin",
            file=sys.stderr,
        )

    groups = build_groups(findings)
    hash_order = [g.hash for g in groups]

    print("", file=sys.stderr)
    print(
        f"Found {len(findings)} finding(s) across "
        f"{len(groups)} unique secret(s):",
        file=sys.stderr,
    )
    print("", file=sys.stderr)
    for g in groups:
        ver = "VERIFIED" if g.verified else "unverified"
        files = {loc.file for loc in g.locations}
        print(
            f"  {g.hash}  [{ver}] {g.detector}  "
            f"{len(g.locations)} location(s) in {len(files)} file(s)",
            file=sys.stderr,
        )
    print("", file=sys.stderr)

    if args.dry_run:
        return 1

    outcomes: dict[str, Outcome] = {
        g.hash: Outcome(detector=g.detector, locations=len(g.locations))
        for g in groups
    }
    interrupted = False

    def on_sigterm(_signum, _frame):
        raise TerminatedBySignal()

    signal.signal(signal.SIGTERM, on_sigterm)

    tty = None
    try:
        if not args.yes:
            try:
                tty = open("/dev/tty", "r")
            except OSError:
                print(
                    "error: no /dev/tty available for prompts; "
                    "use --yes to run non-interactively",
                    file=sys.stderr,
                )
                return 2

        auto = args.yes
        for group in groups:
            h = group.hash
            detector = group.detector
            this_repl = args.replacement or f"[REDACTED:{detector}]"

            if auto:
                action = "redact"
            else:
                assert tty is not None
                action, this_repl = prompt_action(
                    tty, group, this_repl, args.context,
                )
                if action == "all":
                    auto = True
                    action = "redact"
                elif action == "quit":
                    outcomes[h] = Outcome(
                        detector=detector,
                        locations=len(group.locations),
                        action="skipped (quit)",
                    )
                    interrupted = True
                    break

            if action == "skip":
                outcomes[h] = Outcome(
                    detector=detector,
                    locations=len(group.locations),
                    action="skipped",
                )
                continue

            files_changed: list[str] = []
            total_occ = 0
            seen_files: set[str] = set()
            had_error = False
            needles = needles_for(group.raw, group.raw_v2)
            for loc in group.locations:
                fp = loc.file
                if fp in seen_files:
                    continue
                seen_files.add(fp)
                try:
                    n = redact_in_file_multi(fp, needles, this_repl)
                except OSError as e:
                    print(f"  error redacting {fp}: {e}", file=sys.stderr)
                    had_error = True
                    continue
                if n:
                    total_occ += n
                    files_changed.append(fp)
            outcomes[h] = Outcome(
                detector=detector,
                locations=len(group.locations),
                files_changed=files_changed,
                occurrences=total_occ,
                action="error" if had_error and not files_changed else "redacted",
            )
            print(
                f"  → {h}: redacted {total_occ} occurrence(s) "
                f"across {len(files_changed)} file(s)",
                file=sys.stderr,
            )
    except (KeyboardInterrupt, TerminatedBySignal):
        interrupted = True
        print("\n(interrupted)", file=sys.stderr)
    finally:
        if tty is not None:
            tty.close()
        render_summary(hash_order, outcomes, interrupted)

    return 130 if interrupted else 0


if __name__ == "__main__":
    sys.exit(main())
