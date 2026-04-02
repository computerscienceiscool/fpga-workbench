#!/bin/bash
set -euo pipefail # Make the script exit on errors, undefined variables, and failed pipes

echo "=== FPGA Codespace Setup ==="

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  SUDO="sudo"
fi

# oss-cad-suite (Yosys, nextpnr, icepack, iceprog)
# Latest release: https://github.com/YosysHQ/oss-cad-suite-build/releases
OSS_CAD_DATE="2026-03-07"
OSS_CAD_DATE_COMPACT="20260307"
OSS_CAD_URL="https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${OSS_CAD_DATE}/oss-cad-suite-linux-x64-${OSS_CAD_DATE_COMPACT}.tgz"
OSS_CAD_DIR="/opt/oss-cad-suite"
OSS_CAD_BIN="${OSS_CAD_DIR}/bin"
PROFILE_SCRIPT="/etc/profile.d/oss-cad-suite.sh"

# System tools
echo "--- Installing system tools ---"
$SUDO apt-get update -qq
$SUDO apt-get install -y -qq \
  make \
  curl \
  wget \
  git \
  jq \
  python3-pip


echo "--- Installing oss-cad-suite ---"
if [ -x "${OSS_CAD_BIN}/iverilog" ]; then
  echo "  oss-cad-suite already installed, skipping"
else
  TMP_TGZ="/tmp/oss-cad-suite.tgz"

  echo "  Downloading from ${OSS_CAD_URL}..."
  wget -q "${OSS_CAD_URL}" -O "${TMP_TGZ}" || {
    echo "ERROR: Could not download oss-cad-suite"
    echo "Check https://github.com/YosysHQ/oss-cad-suite-build/releases for latest version"
    exit 1
  }

  echo "  Preparing install location..."
  $SUDO mkdir -p /opt

  echo "  Extracting..."
  $SUDO tar xzf "${TMP_TGZ}" -C /opt
  rm -f "${TMP_TGZ}"
fi

# Add to PATH for all users
echo "--- Configuring PATH ---"

if ! grep -q "oss-cad-suite/bin" /home/vscode/.bashrc; then
  echo 'export PATH="/opt/oss-cad-suite/bin:$PATH"' >> /home/vscode/.bashrc
fi

echo 'export PATH="/opt/oss-cad-suite/bin:$PATH"' | $SUDO tee /etc/profile.d/oss-cad-suite.sh > /dev/null
export PATH="/opt/oss-cad-suite/bin:$PATH"

# Clone OpenCores I2C slave
echo "--- Cloning OpenCores I2C ---"
cd /workspaces
if [ ! -d "i2cslave" ]; then
  # OpenCores uses SVN but has git mirrors; fallback to manual download if needed
  git clone https://github.com/AdrianSuliga/I2C-Slave-Controller.git i2cslave 2>/dev/null || {
    echo "  WARNING: Could not clone I2C reference. See https://opencores.org/projects/i2cslave"
  }
fi

# Python testbench tooling (cocotb)
# cocotb lets you write Verilog/VHDL testbenches in Python using iverilog as the simulator.
# cocotb-bus adds reusable bus interfaces (I2C, SPI, AXI, etc.) for integration tests.
# Versions pinned for reproducible builds per project policy.
echo "--- Installing cocotb ---"
if python3 -c "import cocotb" >/dev/null 2>&1; then
  echo "  cocotb already installed, skipping"
else
  pip install cocotb==2.0.1 cocotb-bus==0.3.0 --break-system-packages
fi

# Verify tools
echo "--- Verifying tools ---"
echo -n "  yosys: "; yosys --version 2>/dev/null || echo "NOT FOUND"
echo -n "  nextpnr-ice40: "; nextpnr-ice40 --version 2>/dev/null || echo "NOT FOUND"
echo -n "  icepack: "; which icepack 2>/dev/null || echo "NOT FOUND"
echo -n "  iceprog: "; which iceprog 2>/dev/null || echo "NOT FOUND"
echo -n "  iverilog: "; iverilog -V 2>/dev/null | head -1 || echo "NOT FOUND"
echo -n "  cocotb: "; cocotb-config --version 2>/dev/null || echo "NOT FOUND"
echo -n "  gtkwave: "; which gtkwave 2>/dev/null || echo "NOT FOUND (optional, VaporView extension is available instead)"

echo "=== FPGA Codespace Setup Complete ==="
