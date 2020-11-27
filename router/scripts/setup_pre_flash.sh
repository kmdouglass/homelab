#!/bin/sh

set -o errexit

# Change root password,  enable serial console password, and set hostname
printf "%s\n%s" "${ROOT_PASSWORD}" "${ROOT_PASSWORD}"  | passwd root
uci set system.@system[0].ttylogin="1"
uci set system.@system[0].hostname="${HOSTNAME}"

# /etc/hosts
printf "\n192.168.1.1 %s %s\n" "${HOSTNAME}" "${HOSTNAME_ALIASES}" >> /etc/hosts

# SSH
chmod 700 /etc/dropbear/
chmod 600 /etc/dropbear/authorized_keys
uci set dropbear.@dropbear[0].PasswordAuth="off"
uci set dropbear.@dropbear[0].RootPasswordAuth="off"

uci commit

# Install Opkg packages, such as firmware for wireless cards
# ath9k-htc-firmware  Atheros firmware
# kmod-ath9k          Atheros kernel module
# wpad                WPA2-PSK supplicant
opkg update
opkg install \
     ath9k-htc-firmware \
     kmod-ath9k \
     wpad

# Create directory for the post-flash setup script
mkdir -p "${POST_FLASH_SCRIPTS_DIR}"
