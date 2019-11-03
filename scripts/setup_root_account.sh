#!/bin/sh

set -o errexit

# Change root password and enable serial console password
printf "%s\n%s" "$ROOT_PASSWORD" "$ROOT_PASSWORD"  | passwd root

uci set system.@system[0].ttylogin="1"
uci commit system

# SSH
chmod 700 /etc/dropbear/
chmod 600 /etc/dropbear/authorized_keys

uci set dropbear.@dropbear[0].PasswordAuth="off"
uci set dropbear.@dropbear[0].RootPasswordAuth="off"
uci commit dropbear
