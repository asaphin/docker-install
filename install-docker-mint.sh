#!/bin/bash

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do apt-get remove $pkg; done

apt-get update
apt-get install apt-transport-https ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu noble stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

groupadd docker
usermod -a -G docker $USER

systemctl enable docker.service
systemctl enable containerd.service

read -p "You need to reboot your system to changes take effect. Do you want to reboot now? (y/n): " choice

case "$choice" in
  y|Y )
    sudo reboot
    ;;
  n|N )
    echo "You need to reboot your system manually later"
    ;;
  * )
    echo "Invalid option. You need to reboot your system manually later"
    ;;
esac
