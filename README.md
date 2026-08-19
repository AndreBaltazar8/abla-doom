# Abla Doom

Abla Doom is a small original 2.5D raycasting homage built entirely in
[Abla](https://github.com/AndreBaltazar8/ablac) on
[Abla Graphics](https://github.com/AndreBaltazar8/abla-graphics). It contains
no original DOOM data, art, maps, sounds, or code. The map, palette, HUD, glyphs,
raycaster, input, and framebuffer are original procedural Abla code.

![Abla Doom running](screenshots/abla-doom.png)

The renderer writes a reusable 320x200 affine RGBA8 `PixelBuffer`; Abla Graphics
presents the same frame through either a persistent OpenGL texture/full-screen
`$glsl` program or a Vulkan staging-buffer/image-copy path. Window creation and
events use the direct Abla X11 protocol implementation. There is no C/C++/Rust
implementation source, GLFW, SDL, or native project shim. The game requests an
Abla-created transparent core-X11 cursor so the play window remains clean.
Interactive play uses Abla Graphics' drift-corrected 60 fps monotonic pacer;
test and benchmark modes remain deliberately unpaced.

## Run

Check out `ablac`, `abla-graphics`, and `abla-doom` as sibling directories, then:

```sh
nix-shell --run 'make test'
nix-shell --run 'make build && ./build/abla-doom'
```

Use W/S to move, A/D or the arrow keys to turn, and Escape to quit. Automatic
selection prefers Vulkan and falls back to OpenGL; the smoke suite renders and
presents the procedural scene through both explicit backends.

Measure 300 unpaced, fully rendered and presented frames per backend with the X
server already running, excluding compiler and X-server startup:

```sh
nix-shell --run 'make benchmark'
```

The benchmark reports measured frames per second instead of enforcing a
machine-specific threshold. It uses Mesa's pinned software OpenGL and Vulkan
drivers, so it is also a reproducible CPU-rendering stress test for the complete
Abla path. The conservative development-host baseline and full methodology are
recorded in [docs/performance.md](docs/performance.md).

Regenerate the clean 320x200 proof screenshot from a real software-rendered run:

```sh
nix-shell --run 'make screenshot'
```

The capture gate resolves the `ABLA DOOM` client window by its X identifier,
waits for presented frames, captures that window alone, and rejects any result
that is not exactly 320x200.

## License

Abla Doom is released under the MIT License. “DOOM” is a trademark of its
respective owner; this independent project is not affiliated with or endorsed
by id Software or ZeniMax Media.
