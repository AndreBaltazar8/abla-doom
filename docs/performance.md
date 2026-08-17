# Performance

`make benchmark` runs 300 unpaced frames through the complete game renderer,
window system, and selected graphics backend. Its timer surrounds only the Abla
application process: compilation and Xvfb startup are excluded, while backend
creation, frame rendering, uploads, presentation, and teardown are included.

## Development baseline

Measured on 2026-08-18 with a 13th Gen Intel Core i9-13900K and the Mesa
software drivers pinned by `shell.nix`:

| Backend | Conservative result |
| --- | ---: |
| OpenGL | 423.0 frames/s |
| Vulkan | 500.8 frames/s |

These are the lowest results from three consecutive 300-frame invocations. The
other runs measured 507.2-810.5 frames/s for OpenGL and 515.2-694.6 frames/s for
Vulkan. Reporting the minimum avoids presenting a warm-cache peak as the
baseline.

This is a small 320x200 homage, not a general-purpose engine benchmark. Results
should be compared only with the same resolution, frame count, driver pin, and
benchmark mode. Run `make benchmark` on a target system instead of assuming the
development-host numbers transfer to it.
