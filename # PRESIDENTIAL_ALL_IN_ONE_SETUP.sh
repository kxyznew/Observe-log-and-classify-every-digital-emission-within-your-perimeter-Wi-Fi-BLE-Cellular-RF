#!/bin/bash
# PRESIDENTIAL_ALL_IN_ONE_SETUP.sh
# All-in-one installer & deployer for the FULL INTELLIGENCE STACK v1.0
# WARNING: Requires Debian/Ubuntu-based Linux and root privileges.
# Use ethically, legally, and responsibly.

set -euo pipefail

echo "=== PRESIDENTIAL ALL-IN-ONE INTELLIGENCE STACK INSTALL & DEPLOY ==="

# 1. Update & basic tools
echo "[+] Updating system and installing base tools..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y git build-essential cmake libssl-dev libpcap-dev \
                    libffi-dev libtool autoconf automake pkg-config \
                    python3 python3-pip python3-setuptools \
                    libboost-all-dev libnl-3-dev libnl-genl-3-dev \
                    libusb-1.0-0-dev libsqlite3-dev curl wget jq

# 2. Install Wi-Fi tools
echo "[+] Installing Wi-Fi reconnaissance tools..."
sudo apt install -y aircrack-ng iw tshark tcpdump macchanger

# 3. Install Bluetooth tools
echo "[+] Installing Bluetooth tools..."
sudo apt install -y bluez bluez-tools bluetooth

# 4. Install Python Bluetooth libraries
echo "[+] Installing Python Bluetooth libraries..."
pip3 install bluepy bleak

# 5. Install srsRAN (LTE stack)
echo "[+] Installing srsRAN prerequisites..."
sudo apt install -y libfftw3-dev libmbedtls-dev libboost-program-options-dev libconfig++-dev libpcsclite-dev

echo "[+] Cloning and building srsRAN..."
if [ ! -d "srsRAN" ]; then
  git clone https://github.com/srsran/srsRAN.git
fi
cd srsRAN
mkdir -p build && cd build
cmake ../
make -j$(nproc)
sudo make install
sudo ldconfig
cd ../../

# 6. Install Arkime (Moloch) prerequisites and Arkime itself
echo "[+] Installing Arkime (Moloch) prerequisites..."
sudo apt install -y elasticsearch opendjk-11-jdk \
                    nodejs npm \
                    mongodb-org

echo "[+] Downloading Arkime..."
ARKIME_VERSION="3.4.1"
wget https://files.molo.ch/builds/arkime_${ARKIME_VERSION}_amd64.deb
sudo dpkg -i arkime_${ARKIME_VERSION}_amd64.deb || sudo apt-get install -f -y
rm arkime_${ARKIME_VERSION}_amd64.deb

echo "[+] Setting up Elasticsearch and MongoDB services..."
sudo systemctl enable elasticsearch --now
sudo systemctl enable mongod --now

echo "[+] Arkime setup complete. You will need to configure it separately."

# 7. Install Maltego (optional manual step)
echo "[+] For Maltego, download from https://www.maltego.com/downloads/ and install manually."

# 8. Install Python network tools
echo "[+] Installing additional Python network tools..."
pip3 install scapy mitmproxy pyshark

# 9. Enable monitor mode tools (airmon-ng cleanup)
echo "[+] Installing wireless tools for monitor mode..."
sudo apt install -y wireless-tools

# 10. Setup aliases for quick launch
echo "[+] Setting up quick launch scripts..."

cat << 'EOF' > ~/start_wifi_capture.sh
#!/bin/bash
sudo airmon-ng check kill
sudo airmon-ng start wlan0
sudo airodump-ng wlan0mon
EOF
chmod +x ~/start_wifi_capture.sh

cat << 'EOF' > ~/start_srsran_enb.sh
#!/bin/bash
if [ ! -f /usr/local/bin/srsenb ]; then
  echo "srsenb not found! Please build srsRAN first."
  exit 1
fi
sudo srsenb /etc/srsran/enb.conf
EOF
chmod +x ~/start_srsran_enb.sh

# 11. Summary
echo -e "\n=== INSTALLATION COMPLETE ==="
echo "Tools installed: aircrack-ng, tshark, bettercap (install manually), bluez, srsRAN, Arkime, mitmproxy, scapy"
echo "Quick launch scripts created:"
echo "  - ~/start_wifi_capture.sh"
echo "  - ~/start_srsran_enb.sh"
echo "IMPORTANT:"
echo "  - Configure srsRAN / Arkime manually before use."
echo "  - Use Wi-Fi adapters compatible with monitor mode."
echo "  - Ensure you have proper permissions and ethical/legal clearance."

echo -e "\nRun ~/start_wifi_capture.sh to begin Wi-Fi monitoring."
echo "Run ~/start_srsran_enb.sh to launch LTE eNodeB (requires config)."

echo "=== PRESIDENTIAL STACK READY FOR OPERATION ==="
