# Wificuak auditor de redes wi-fi

Es una herramienta intuitiva escrita totalmente en bash que recopila varias herramientas en una sola para que sea mas facil la explotacion de los AP, tambien es compatible con 5ghz haciéndola más versátil.

Este script fue probado solamente en el sistema operativo **Kali linux** por lo que en los demás sistemas puede contener algún error inesperado, sería de agradecer que si se encontrara algún bug/error fuera reportado.

## Funciones

#### - Se pretende seguir aumentando y mejorando el número de funciones. - 

▶️ Poner interfaz en modo monitor.

▶️ Poner interfaz en modo manager.

▶️ Obtener hadshake | (airodump-ng).

▶️ Desencriptar handshake utilizando diccionario propio | (aircrack-ng).

▶️ Obtener PMKID | (hcxdumptool).

▶️ Desencriptar PMKID utilizando diccionario propio | (hcxpcapngtool y hashcat).

▶️ Ataque hacia redes WEP | (airodump-ng y aircrack-ng).

▶️ Ataque DOS | (aireplay-ng).

## Para poder usar

Es bastante rápido:

```bash
sudo git clone https://github.com/N1P0STK4/Wificuak.git && bash Wificuak/wificuak.sh
```

## Demostración

<img src="https://raw.githubusercontent.com/N1P0STK4/Wificuak/main/images/wificuak.png">

#### Para poder seleccionar la red
<img src="https://raw.githubusercontent.com/N1P0STK4/Wificuak/main/images/scaneo.png">
