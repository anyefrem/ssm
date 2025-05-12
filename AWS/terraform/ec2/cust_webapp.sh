#!/bin/bash

export FQDN="webapp$(hostname -I | tr -d '.' | tr -d ' ').aylab.cloud"
hostnamectl set-hostname $FQDN
echo >> /etc/hosts && echo "# Local hostname" >> /etc/hosts
echo "$(hostname -I | tr -d ' ') $FQDN" >> /etc/hosts
export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get dist-upgrade -y
apt-get install unzip net-tools apache2 -y
echo "<h1>Hello World from $(hostname -f)!</h1>" > /var/www/html/index.html
snap install core
snap install --classic certbot
reboot
