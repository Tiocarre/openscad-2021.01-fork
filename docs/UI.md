# UI direction

The interface uses a dark technical workstation palette with compact spacing, clear panel boundaries, square corners, and a restrained green accent. Existing OpenSCAD widgets and commands remain in place.

- Main surfaces: `#101419`, `#11171d`, and `#151b22`.
- Editor and input surfaces: `#0d1217`.
- Dividers: `#27313b` to `#35414d`.
- Primary text: `#d4dbe3`; secondary text: `#87939e`.
- Accent: `#71b7a2`; status colors are reserved for functional states.
- UI chrome uses a compact monospace stack (`Consolas`, `Cascadia Mono`, fallback monospace). The editor keeps OpenSCAD's font controls and uses the built-in `Tomorrow Night` syntax and viewport schemes by default.

Use `themes/workstation.qss` for shared Qt styling. Keep component styling tied to object names and avoid replacing functional OpenSCAD widgets for appearance alone. The `AiPanel` is an isolated presentation widget; connecting a future service belongs behind a separate interface and is outside this milestone.
