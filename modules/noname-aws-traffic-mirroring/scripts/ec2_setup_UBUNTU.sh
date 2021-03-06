#! /bin/bash
#sudo apt-get update -y
#sudo apt-get install wget -y
sudo mkdir -p /opt/noname
sudo wget -O nonamesecurity.tar.gz ${package_url}
sudo tar -zxf nonamesecurity.tar.gz -C /opt/noname
cd /opt/noname
sudo ./install.sh --engine-with-mongo --management-ip ${noname_management_host} --collector-name ${remote_engine_name} --collector-urls ${remote_engine_urls} --noninteractive --force
sleep 10s
sudo reboot
