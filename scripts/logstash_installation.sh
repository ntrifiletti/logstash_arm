#! /bin/bash

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list
sudo apt-get update
sudo apt-get install -y default-jdk
sudo apt-get install -y elasticsearch
sudo apt-get update
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch
sudo apt-get install -y logstash
wget https://raw.githubusercontent.com/aravindan-acct/logstash_arm/main/scripts/waf.conf
sudo mv waf.conf /etc/logstash/conf.d/
sudo /usr/share/logstash/bin/logstash-plugin install microsoft-logstash-output-azure-loganalytics
touch /tmp/test.txt
apt install -y libxml2-utils
apt install -y jq
xmllint --xpath "//*[local-name()='CustomData']" /var/lib/waagent/ovf-env.xml | sed -e 's/ns1:/ /g' | sed -e 's/ //g' > file.xml
omsid = xmllint --xpath 'string(//CustomData)' file.xml | base64 --decode | jq '.OMSWorkspaceID'
omskey = xmllint --xpath 'string(//CustomData)' file.xml | base64 --decode | jq '.OMSWorkspaceKey'
sudo sed -i "s/workspace_id => \"junk\"/workspace_id => $omsid /g" /etc/logstash/conf.d/waf.conf
sudo sed -i "s/workspace_id => \"test\"/workspace_id => $omskey /g" /etc/logstash/conf.d/waf.conf
<<logstash
sudo systemctl start logstash
sudo systemctl enable logstash
logstash
