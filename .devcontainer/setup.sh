#!/bin/bash
set -e

echo "=== FPGA Codespace Setup ==="

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  SUDO="sudo"
fi

# System tools
echo "--- Installing system tools ---"
$SUDO apt-get update -qq
$SUDO apt-get install -y -qq \
  make \
  curl \
  wget \
  git \
  jq

# oss-cad-suite (Yosys, nextpnr, icepack, iceprog)
# Latest release: https://github.com/YosysHQ/oss-cad-suite-build/releases
echo "--- Installing oss-cad-suite ---"
OSS_CAD_DATE="2026-03-07"
OSS_CAD_DATE_COMPACT="20260307"
OSS_CAD_URL="https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${OSS_CAD_DATE}/oss-cad-suite-linux-x64-${OSS_CAD_DATE_COMPACT}.tgz"

cd /opt
echo "  Downloading from ${OSS_CAD_URL}..."
wget -q "${OSS_CAD_URL}" -O oss-cad-suite.tgz || {
  echo "ERROR: Could not download oss-cad-suite"
  echo "Check https://github.com/YosysHQ/oss-cad-suite-build/releases for latest version"
  exit 1
}
echo "  Extracting..."
tar xzf oss-cad-suite.tgz
rm oss-cad-suite.tgz

# Add to PATH for all users
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

# Verify tools
echo "--- Verifying tools ---"
echo -n "  yosys: "; yosys --version 2>/dev/null || echo "NOT FOUND"
echo -n "  nextpnr-ice40: "; nextpnr-ice40 --version 2>/dev/null || echo "NOT FOUND"
echo -n "  icepack: "; which icepack 2>/dev/null || echo "NOT FOUND"
echo -n "  iceprog: "; which iceprog 2>/dev/null || echo "NOT FOUND"

echo "=== FPGA Codespace Setup Complete ==="
