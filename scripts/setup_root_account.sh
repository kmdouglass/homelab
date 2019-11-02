#!/bin/sh

# Change root password
printf "%s\n%s" "$ROOT_PASSWORD" "$ROOT_PASSWORD"  | passwd root

# Enable serial console password
uci set system.@system[0].ttylogin="1"
uci commit system
