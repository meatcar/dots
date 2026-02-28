#!/usr/bin/env python3
"""Bridge logind Lock/Unlock signals to org.gnome.ScreenSaver.ActiveChanged.

1Password requires this D-Bus interface to support auto-lock on non-GNOME desktops.
"""

import dbus
import dbus.mainloop.glib
import dbus.service
from gi.repository import GLib


class ScreenSaverProxy(dbus.service.Object):
    def __init__(self, bus):
        bus_name = dbus.service.BusName("org.gnome.ScreenSaver", bus)
        super().__init__(bus_name, "/org/gnome/ScreenSaver")
        self._active = False

    @dbus.service.method("org.gnome.ScreenSaver", out_signature="b")
    def GetActive(self):
        return self._active

    @dbus.service.method("org.gnome.ScreenSaver")
    def Lock(self):
        import subprocess

        subprocess.Popen(["loginctl", "lock-session"])

    @dbus.service.signal("org.gnome.ScreenSaver", signature="b")
    def ActiveChanged(self, active):
        pass

    def set_active(self, active):
        if self._active != active:
            self._active = active
            self.ActiveChanged(active)


def main():
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
    session_bus = dbus.SessionBus()
    system_bus = dbus.SystemBus()
    proxy = ScreenSaverProxy(session_bus)

    system_bus.add_signal_receiver(
        lambda: proxy.set_active(True),
        signal_name="Lock",
        dbus_interface="org.freedesktop.login1.Session",
        bus_name="org.freedesktop.login1",
    )
    system_bus.add_signal_receiver(
        lambda: proxy.set_active(False),
        signal_name="Unlock",
        dbus_interface="org.freedesktop.login1.Session",
        bus_name="org.freedesktop.login1",
    )

    GLib.MainLoop().run()


if __name__ == "__main__":
    main()
