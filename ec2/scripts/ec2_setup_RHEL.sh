#! /bin/bash
sudo yum update
sudo yum install wget -y
sudo mkdir /opt/noname
sudo wget -O nonamesecurity.tar.gz ${package_url}
sudo tar -zxf nonamesecurity.tar.gz -C /opt/noname
cd /opt/noname
sudo ./install.sh --noninteractive
sleep 10s
sudo reboot