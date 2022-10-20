# Barracuda WAF As A Service Integration with Microsoft Sentinel

This repo can be used to deploy a logstash server that can act as a mediator to send logs from one or more WAAS services to Log Analytics and Microsoft Sentinel.

# Deploying the Logstash Server
The server can be deployed using the ARM template in this repo. Most of the settings are already configured. The only inputs for the ARM template deployment are the logstash server password, the log analytics workspace id and log analytics workspace key. The Logstash configuration can be found here: [Logstash Configuration File](https://github.com/aravindan-acct/logstash_arm/blob/main/scripts/waf.conf)

## Deployment Pre-Requisites

1. Log Analytics Workspace
2. WAAS Account and Service to send logs to the logstash server

## WAAS Configuration
1. Add the export logs component
2. Add the syslog server and set the port as 1514 (UDP)
3. Log Format

    3.a For the Syslog Header field, select ArcSight Log Header

    3.b For the Firewall logs and Access logs fields, select Microsoft Azure OMS

![alt text](https://github.com/aravindan-acct/logstash_arm/blob/main/images/waas_export_logs.png?raw=true)