# Departure HUD

A retro-terminal SysMon desktop widget for [Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell), styled with the [Departure Mono](https://departuremono.com) pixel font.

![Preview](preview.png)

## What it shows

| Section  | Live source |
| -------- | ----------- |
| CPU      | per-core load + frequency — `/proc/stat`, `/proc/cpuinfo` |
| MEM      | used / cache / swap — `/proc/meminfo` |
| AUDIO    | master volume — `wpctl` (PipeWire) or `pactl` (PulseAudio) |
| DISPLAY  | backlight % — `/sys/class/backlight/*` |
| THERM    | CPU / GPU / SSD / chassis — `/sys/class/hwmon/*` |
| BATT     | charge %, state, rate, time left, cycles — `/sys/class/power_supply/BAT*` |
| DISK     | usage per mount — `df -P` |
| NET      | down/up Mb/s for the busiest interface — `/proc/net/dev` |
| Bottom   | host, kernel, shell, user, load avg, uptime |

Sections without hardware support (e.g. no battery, no backlight) hide automatically.

## Settings

Global plugin settings (`Settings.qml`):

- **Scale** — multiplier for the base `1180×600` layout.
- **Accent / hot / background color** — three hex values that re-skin the HUD.
- **Update interval** — how often to re-poll `/proc` and `/sys` (default `1000 ms`).
- **Disks** — comma-separated list of mount points to show (default `/,/home`).
- **Network interface** — leave blank for auto-detection.
- **CPU / GPU / SSD max temperatures** — used for the red-alert threshold.
- **Scope star count** — `0` disables the warp-speed effect.

Per-widget settings (`DesktopWidgetSettings.qml`) override **scale**, **accent**, and **background** on a single placed instance so you can have e.g. one big HUD on monitor 1 and a small one on monitor 2.

## Font

The widget bundles `Departure Mono Regular` (`fonts/DepartureMono-Regular.otf`) so it renders correctly offline. Departure Mono is © Helena Zhang — see `fonts/LICENSE.txt` and `fonts/NOTICE.md`.

## Dependencies

Only standard Linux: `/proc`, `/sys`, `df`, plus optionally `wpctl` or `pactl` for the volume readout.

## Installation

Either:

1. Install from the **Noctalia Plugins** browser (once merged into `noctalia-dev/noctalia-plugins`).
2. Or drop this directory into `~/.config/noctalia/plugins/departure-hud/`, enable it in Noctalia → Plugins, then add a *Desktop Widget* via Noctalia → Desktop Widgets and pick **Departure HUD**.

## License

MIT for the plugin code.  Departure Mono is bundled under its upstream license (see `fonts/LICENSE.txt`).
