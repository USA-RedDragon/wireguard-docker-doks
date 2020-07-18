#!/bin/bash

set -xe

if [[ ! -e /sys/module/wireguard ]]; then
    # Install Wireguard. This has to be done dynamically since the kernel
    # module depends on the host kernel version.
    apt-get update
    apt-get install -t stretch-backports -y --no-install-recommends linux-headers-$(uname -r)
    apt-get install -t sid -y --no-install-recommends wireguard-dkms

    modprobe wireguard
fi

# Find a Wireguard interface
interfaces=`find /etc/wireguard -type f`
if [[ -z $interfaces ]]; then
    echo "$(date): Interface not found in /etc/wireguard" >&2
    exit 1
fi

interface=`echo $interfaces | head -n 1`

echo "$(date): Starting Wireguard"
wg-quick up $interface

exit 0