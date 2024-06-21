# Wificuak wifi network auditor

It is an intuitive tool written entirely in Bash that compiles several tools into one to make it easier to exploit APs. It is also compatible with 5GHz, making it more versatile.

This script was only tested on the **Kali Linux** operating system, so on other systems it may contain some unexpected errors. It would be appreciated if any bugs were found if they were reported.

## Features

#### - It is intended to continue increasing and improving the number of functions. - 

▶️ Put interface in monitor mode.

▶️ Put interface in manager mode.

▶️ Get handshake | (airodump-ng).

▶️ Decrypt handshake using own dictionary | (aircrack-ng).

▶️ Get PMKID | (hcxdumptool).

▶️ Decrypt PMKID using own dictionary | (hcxpcapngtool y hashcat).

▶️ Attack on WEP networks | (airodump-ng y aircrack-ng).

▶️ DOS attack | (aireplay-ng).

## In order to use

It's pretty fast:

```bash
sudo git clone https://github.com/N1P0STK4/Wificuak.git && bash Wificuak/wificuak.sh
```

## Demonstration

<img src="https://raw.githubusercontent.com/N1P0STK4/Wificuak/main/images/wificuak.png">

#### To be able to select the network
<img src="https://raw.githubusercontent.com/N1P0STK4/Wificuak/main/images/scaneo.png">
