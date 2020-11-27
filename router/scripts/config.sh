#!/bin/sh

set -o errexit
set -o nounset

# Software
opkg update
opkg install \
    prometheus-node-exporter-lua \
    prometheus-node-exporter-lua-nat_traffic \
    prometheus-node-exporter-lua-netstat \
    prometheus-node-exporter-lua-openwrt \
    prometheus-node-exporter-lua-wifi \
    prometheus-node-exporter-lua-wifi_stations
uci set prometheus-node-exporter-lua.main.listen_interface='lan'
/etc/init.d/prometheus-node-exporter-lua restart

# DNS
uci set dhcp.@dnsmasq[0].local="/kponics.lan/"
uci set dhcp.@dnsmasq[0].domain="kponics.lan"

# Restart services
uci commit
/etc/init.d/dnsmasq restart
