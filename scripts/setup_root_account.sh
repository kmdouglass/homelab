#!/bin/sh

set -o errexit

# Change root password,  enable serial console password, and set hostname
printf "%s\n%s" "${ROOT_PASSWORD}" "${ROOT_PASSWORD}"  | passwd root

uci set system.@system[0].ttylogin="1"
uci set system.@system[0].hostname="${HOSTNAME}"
uci commit system

# /etc/hosts
printf "\n192.168.1.1 %s %s %s\n" \
       "${HOSTNAME}.${DOMAIN}" "${HOSTNAME}" "${HOSTNAME_ALIASES}" >> /etc/hosts
sed -i "/127.0.0.1 localhost/a127.0.1.1 ${HOSTNAME}.${DOMAIN} ${HOSTNAME}" /etc/hosts

# ssh
chmod 700 /etc/dropbear/
chmod 600 /etc/dropbear/authorized_keys

uci set dropbear.@dropbear[0].PasswordAuth="off"
uci set dropbear.@dropbear[0].RootPasswordAuth="off"
uci commit dropbear
