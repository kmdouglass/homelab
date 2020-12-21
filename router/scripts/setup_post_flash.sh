#!/bin/sh

# This script is intended to be run on the router after the image is flashed onto its internal
# storage and it boots independently for the first time. It should be run over the serial terminal
# because the LAN interface will be switched to bridge mode.

LAN_IFNAME=eth1 eth2
WAN_IFNAME=eth0

# System
uci set system.@system[0].hostname="srv-20191014"
uci set system.@system[0].ttylogin="1"
uci set system.@system[0].zonename="Europe/Zurich"

# LAN
ifdown lan
uci del network.lan

uci set network.lan=interface
uci set network.lan.type=bridge
uci set network.lan.ifname="${LAN_IFNAME}"
uci set network.lan.proto=static
uci set network.lan.netmask=255.255.255.0
uci set network.lan.ip6assign=60
uci set network.lan.ipaddr=192.168.1.2

uci commit network
ifup lan

# WAN
ifdown wan
uci del network.wan
uci del network.wan6

uci set network.wan=interface
uci set network.wan.proto=dhcp
uci set network.wan.ifname="${WAN_IFNAME}"
uci set network.wan6=interface
uci set network.wan6.proto=dhcpv6
uci set network.wan6.ifname="${WAN_IFNAME}"

uci commit network
ifup wan

# Wireless
uci set wireless.radio0.country="CH"

uci set wireless.@wifi-device[0].disabled=0;
uci set wireless.@wifi-device[0].hwmode="11g"

uci set wireless.@wifi-iface[0].device="radio0"
uci set wireless.@wifi-iface[0].encryption='psk2'
uci set wireless.@wifi-iface[0].network="lan"
uci set wireless.@wifi-iface[0].ssid="kponics"

uci commit wireless
/etc/init.d/network restart
