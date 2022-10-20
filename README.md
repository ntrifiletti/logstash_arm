# Barracuda WAF As A Service Integration with Microsoft Sentinel

This repo can be used to deploy a logstash server that can act as a mediator to send logs from one or more WAAS services to Microsoft Sentinel.

# Deploying the Logstash Server
The server can be deployed using the ARM template in this repo. Most of the settings are already configured. The only inputs for the ARM template deployment are the logstash server password, the log analytics workspace id and log analytics workspace key.

## Deployment Pre-Requisites

1. Log Analytics Workspace
2. WAAS Account and Service to send logs to the logstash server

