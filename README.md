# Hide and Shoot

A first-person 3D game prototype built in **Godot 4.3** with GDScript. The setting is a dark, PSX-style forest that you explore with a flashlight.

> 🚧 **Work in progress.** Movement, camera and environment are in place; combat and menus come next.

<!-- Add a GIF of gameplay here -->

## What's implemented

- **First-person controller** (`Scripts/Player.gd`): WASD movement, sprinting, jumping and gravity, with ground and air control tuned separately.
- **Camera feel:** head bob, FOV that widens with speed, and mouse look clamped to ±90°.
- **Lagging flashlight:** the hand-held spotlight trails the camera slightly, so the beam sweeps instead of snapping.
- **Procedural environment:** trees, rocks, grass and props scattered across the map with the [ProtonScatter](https://github.com/HungryProton/scatter) addon.

## Controls

| Key | Action |
|---|---|
| W / A / S / D | Move |
| Shift | Sprint |
| Space | Jump |
| Mouse | Look |
| Esc | Release the mouse |

## Roadmap

- [ ] Weapons (revolver, machete)
- [ ] Melee/stab action
- [ ] Main menu
- [ ] Finish the map layout

## Running it

1. Install [Godot 4.3](https://godotengine.org/download).
2. Open Godot, click **Import** and select `project.godot`.
3. Press **F5** to run.

## Credits

- [ProtonScatter](https://github.com/HungryProton/scatter) by HungryProton (MIT)
- Low-poly / PSX-style models: see `assets/models/`
