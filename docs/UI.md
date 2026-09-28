# UI direction

The interface uses a dark technical workstation palette with compact spacing, clear panel boundaries, square corners, and a restrained green accent. Existing OpenSCAD widgets and commands remain in place.

- Surfaces: `#101419` base, `#11171d` chrome, `#151b22` panels, `#0d1217` editor and inputs.
- Dividers: `#27313b` to `#35414d`; compact 3–12 px spacing; square corners.
- Text: `#d4dbe3` primary, `#87939e` secondary; accent `#71b7a2`. Functional states alone use status colors.
- UI chrome uses `Consolas`, `Cascadia Mono`, or the system monospace fallback. Existing editor font controls remain; `Tomorrow Night` is the default editor syntax and viewport palette.

`themes/workstation.qss` styles the main window, menus, toolbars, dock titles, tabs, controls, scrollbars, status bar, and console. The existing editor and viewport use OpenSCAD's own color schemes. The separate `AiPanel` is an offline presentation widget. Existing functional OpenSCAD widgets and commands stay in place.
