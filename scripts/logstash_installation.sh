#! /bin/bash

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update
sudo apt-get install -y default-jdk && sudo apt-get install -y elasticsearch
sudo apt-get update
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch
sudo apt-get install -y logstash
sudo apt-get install -y ruby
wget https://raw.githubusercontent.com/aravindan-acct/logstash_arm/main/scripts/waf.conf
sudo mv waf.conf /etc/logstash/conf.d/
sudo /usr/share/logstash/bin/logstash-plugin install microsoft-logstash-output-azure-loganalytics
touch /tmp/test.txt
touch /home/labuser/output.txt
sudo chmod 666 /home/labuser/output.txt
apt install -y libxml2-utils && apt install -y jq
xmllint --xpath "//*[local-name()='CustomData']" /var/lib/waagent/ovf-env.xml | sed -e 's/ns1:/ /g' | sed -e 's/ //g' > /tmp/file.xml
cat /tmp/file.xml
omsid=$(xmllint --xpath 'string(//CustomData)' /tmp/file.xml | base64 --decode | jq '.OMSWorkspaceID')
omskey=$(xmllint --xpath 'string(//CustomData)' /tmp/file.xml | base64 --decode | jq '.OMSWorkspaceKey')

echo "replacing the waf.conf file contents"

echo "OMS ID: \n"
echo $omsid
if sudo sed -i "s/workspace_id => \"junk\"/workspace_id => $omsid /g" /etc/logstash/conf.d/waf.conf ; then
    echo "Replaced OMS ID"
else
    echo "Error.. please check command"
fi

echo "\nOMS Key: \n"
echo $omskey

if sudo sed -i "s/workspace_key => \"test\"/workspace_key => $omskey /g" /etc/logstash/conf.d/waf.conf ; then
    echo "Replaced OMS Key"
else
    echo "Error replacinig the key.. please check command"
fi
sudo systemctl start logstash

sudo systemctl enable logstash

