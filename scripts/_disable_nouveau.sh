#!/bin/bash

touch '/etc/modprobe.d/blacklist-nouveau.conf'
echo -e "blacklist nouveau\nblacklist lbm-nouveau\noptions nouveau modeset=0" > /etc/modprobe.d/blacklist-nouveau.conf
update-initramfs -u
