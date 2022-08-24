#! /bin/bash

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
sudo apt-get update
sudo apt-get install -y default-jdk
sudo apt-get install -y elasticsearch
sudo apt-get update
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch
sudo apt-get install -y logstash
wget https://raw.githubusercontent.com/aravindan-acct/logstash_arm/main/scripts/waf.conf
sudo mv waf.conf /etc/logstash/conf.d/
<<logstash
sudo systemctl start logstash
sudo systemctl enable logstash
logstash
touch /tmp/test.txt


