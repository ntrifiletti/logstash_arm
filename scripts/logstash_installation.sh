#! /bin/bash
<<elk
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
sudo apt-get update
sudo apt-get install -y default-jdk
sudo apt-get install -y elasticsearch
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install -y oracle-java8-installer
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch
sudo apt-get install -y logstash

sudo systemctl start logstash
sudo systemctl enable logstash
elk
touch /tmp/test.txt


