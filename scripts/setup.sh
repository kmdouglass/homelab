#!/bin/sh

set -o errexit

# Change root password,  enable serial console password, and set hostname
printf "%s\n%s" "${ROOT_PASSWORD}" "${ROOT_PASSWORD}"  | passwd root

uci set system.@system[0].ttylogin="1"
uci set system.@system[0].hostname="${HOSTNAME}"
uci commit system

# WAN
uci del network.wan
uci del network.wan6

uci set network.wan=interface
uci set network.wan.proto=dhcp
uci set network.wan.ifname="${WAN_IFNAME}"
uci set network.wan6=interface
uci set network.wan6.proto=dhcpv6
uci set network.wan6.ifname="${WAN_IFNAME}"
uci commit

# /etc/hosts
printf "\n192.168.1.1 %s %s %s\n" \
       "${HOSTNAME}.${DOMAIN}" "${HOSTNAME}" "${HOSTNAME_ALIASES}" >> /etc/hosts
sed -i "/127.0.0.1 localhost/a127.0.1.1 ${HOSTNAME}.${DOMAIN} ${HOSTNAME}" /etc/hosts

# SSH
chmod 700 /etc/dropbear/
chmod 600 /etc/dropbear/authorized_keys

uci set dropbear.@dropbear[0].PasswordAuth="off"
uci set dropbear.@dropbear[0].RootPasswordAuth="off"
uci commit dropbear

# Install Opkg packages, such as firmware for wireless cards
opkg update
opkg install \
     ath9k-htc-firmware \
     kmod-ath9k
