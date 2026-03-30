# FPGA Development Codespace

Codespace for FPGA development targeting the Lattice ICE40UP5K chip.

## What's Installed

- **oss-cad-suite** (2026-03-07) — Yosys, nextpnr-ice40, icepack, iceprog
- **Icarus Verilog** (`iverilog`) — simulation and testbenches (included in oss-cad-suite)
- **GTKWave** — waveform viewer (included in oss-cad-suite)
- **Verilog HDL extension** for VS Code
- **OpenCores I2C slave** reference — cloned into /workspaces/i2cslave

## Quick Start

1. Create a codespace from this repo
2. Wait for setup to complete (~5-10 min, mostly downloading oss-cad-suite)
3. Try the blinky example:

```bash
cd icesugar-blinky
make          # synthesize + place & route + pack bitstream
make sim      # simulate with iverilog, produces blinky_tb.vcd
```

## Example Projects

### `icesugar-blinky/` — Hello World

Classic FPGA hello world: cycles the on-board RGB LED through 8 color
combinations using a free-running counter. Includes a testbench for simulation.

### Ideas for Next Projects

- **PWM LED fader** — smooth brightness/color fading with variable duty cycle
- **Button debouncer** — read DIP switches (pins 18-21), debounce with a shift register
- **UART echo** — receive/echo bytes via the built-in USB-UART bridge (pins 4/6, 115200 baud)

## Flashing the Board

GitHub Codespaces **cannot access USB devices** — you can synthesize in the
cloud but need to flash locally. Two options:

### Option A: Download and flash locally

1. Build the bitstream in the Codespace: `make` in a project directory
2. Download the `.bin` file
3. Flash locally with `iceprog` or copy to the iCELink USB drive

### Option B: Run the devcontainer locally (recommended for hardware work)

Use VS Code Dev Containers with Docker to run this same environment locally
with USB passthrough:

```bash
# Clone the repo and open in VS Code
# VS Code will prompt to "Reopen in Container"
# The IceSugar board's iCELink shows up as a USB mass-storage device
make prog     # copies bitstream to iCELink
```

## Target Hardware

- ICE40UP5K-SG48 (~1000 LEs needed, 5280 available)
- [IceSugar dev board](https://www.tindie.com/products/johnnywu/icesugar-fpga-development-board/)

## Tool Versions

To update oss-cad-suite, edit the `OSS_CAD_DATE` variable in `.devcontainer/setup.sh`.
Check for releases at: https://github.com/YosysHQ/oss-cad-suite-build/releases

## References

- [oss-cad-suite](https://github.com/YosysHQ/oss-cad-suite-build)
- [IceSugar board repo](https://github.com/wuxx/icesugar)
- [OpenCores I2C](https://opencores.org/projects/i2cslave)
- [Yosys docs](https://yosyshq.readthedocs.io/)
- [nextpnr](https://github.com/YosysHQ/nextpnr)
- [Project IceStorm](https://github.com/YosysHQ/icestorm)
