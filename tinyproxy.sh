#!/bin/bash
apt update
apt upgrade
apt install -y git automake build-essential asciidoc xsltproc git
cd /tmp 
if [ ! -d "/tmp/tinyproxy" ] 
then
git clone https://github.com/tinyproxy/tinyproxy.git
fi
cd tinyproxy
chmod -x autogen.sh && chmod 775 autogen.sh
./autogen.sh
chmod -x configure && chmod 775 configure
./configure
chmod -X make && chmod 775 make
make
chmod -x install && chmod 775 install
make install
cd ..
rm tinyproxy -r -d
useradd -M -U -s /bin/false tinyproxy
useradd -M -U -s /bin/false tinyproxy
touch /usr/local/var/log/tinyproxy/tinyproxy.log
chown tinyproxy:root /usr/local/var/log/tinyproxy/tinyproxy.log
mv /usr/local/etc/tinyproxy/tinyproxy.conf /usr/local/etc/tinyproxy/tinyproxy.conf.orig
if [ ! -f "/usr/local/etc/tinyproxy/tinyproxy.conf" ] 
then
wget -O /usr/local/etc/tinyproxy/tinyproxy.conf https://raw.githubusercontent.com/mikelucid15/tiny-proxy-droplet/main/tinyproxy.conf
echo "Allow test test" >> /usr/local/etc/tinyproxy/tinyproxy.conf
fi
echo "ViaProxyName test-nyc-1-1" >> /usr/local/etc/tinyproxy/tinyproxy.conf
pkill -e tinyproxy
if [ ! -f "/etc/systemd/system/tinyproxy.service" ]
then
wget -O /etc/systemd/system/tinyproxy.service https://raw.githubusercontent.com/mikelucid15/tiny-proxy-droplet/main/tinyproxy.service
chmod 755 /etc/systemd/system/tinyproxy.service && chmod -x /etc/systemd/system/tinyproxy.service
fi
systemctl daemon-reload
systemctl enable tinyproxy.service
