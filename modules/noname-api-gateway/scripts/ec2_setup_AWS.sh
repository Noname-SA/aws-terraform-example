#! /bin/bash
sudo yum update -y
sudo yum install wget -y
sudo mkdir -p /opt/noname
sudo wget -O nonamesecurity.tar.gz ${package_url}
sudo tar -zxf nonamesecurity.tar.gz -C /opt/noname
cd /opt/noname
sudo ./install.sh --engine-mongo-platform --management-ip ${management_ip} --collector-name ${collector_name} --collector-urls ${collector_urls} --remote_keys "${remote_keys}" --noninteractive --force
sleep 10s
sudo reboot
