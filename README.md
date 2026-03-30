# FPGA Development Codespace

Codespace for FPGA development targeting the Lattice ICE40UP5K chip.

## What's Installed

- **oss-cad-suite** (2026-03-07) — Yosys, nextpnr-ice40, icepack, iceprog
- **Verilog HDL extension** for VS Code
- **OpenCores I2C slave** reference — cloned into /workspaces/i2cslave

## Quick Start

1. Create a codespace from this repo
2. Wait for setup to complete (~5-10 min, mostly downloading oss-cad-suite)
3. Write Verilog, synthesize with `yosys`, place & route with `nextpnr-ice40`

## Testbench Plan

- I2C core
- Encoder counter (quadrature decoder)
- Mock encoder to generate high-speed pulses (~500kHz)

## Target Hardware

- ICE40UP5K-SG48 (~1000 LEs needed, 5280 available)
- IceSugar dev board: https://www.tindie.com/products/johnnywu/icesugar-fpga-development-board/

## Tool Versions

To update oss-cad-suite, edit the `OSS_CAD_DATE` variable in `.devcontainer/setup.sh`.
Check for releases at: https://github.com/YosysHQ/oss-cad-suite-build/releases

## References

- oss-cad-suite: https://github.com/YosysHQ/oss-cad-suite-build
- OpenCores I2C: https://opencores.org/projects/i2cslave
- Yosys docs: https://yosyshq.readthedocs.io/
- nextpnr: https://github.com/YosysHQ/nextpnr
- Project IceStorm (ICE40 reverse engineering): https://github.com/YosysHQ/icestorm
