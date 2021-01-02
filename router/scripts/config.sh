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

while uci -q get dhcp.@cname[0]; do
    uci delete dhcp.@cname[0]
done

uci add dhcp cname
uci set dhcp.@cname[-1].cname="grafana.kponics.lan"
uci set dhcp.@cname[-1].target="rpi3.kponics.lan"

uci add dhcp cname
uci set dhcp.@cname[-1].cname="prometheus.kponics.lan"
uci set dhcp.@cname[-1].target="rpi3.kponics.lan"

uci add dhcp cname
uci set dhcp.@cname[-1].cname="mqtt.kponics.lan"
uci set dhcp.@cname[-1].target="rpi3.kponics.lan"

# Restart services
uci commit
/etc/init.d/dnsmasq restart
