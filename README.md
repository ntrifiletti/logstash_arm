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

    3.a For the Syslog Header field, select ArcSight Log Header. The header value format will be auto set as follows:

    `CEF:0|DeviceVendor|Product|DeviceVersion|SignatureID|Name|Severity|`

    3.b For the Firewall logs and Access logs fields, select Microsoft Azure OMS. The log format will be auto set as follows:
    
    Firewall Logs:
    
    `%header cat=%lt dst=%ai dpt=%ap act=%at msg=%adl duser=%au src=%ci spt=%cp requestMethod=%m app=%p requestContext=%r rt=%tarc request=%u requestClientApplication=%ua dvchost=%un cn2=%pp cn2Label=ProxyPort cs1=%ri cs1Label=RuleID cs2=%fa cs2Label=FollowUpAction cs3=%rt cs3Label=RuleType cs4=%ag cs4Label=AttackGroup cs5=%px cs5Label=ProxyIP cs6=%sid cs6Label=SessionID destinationServiceName=%sn`

    Access Logs:

    `%header cat=%lt dvc=%ai duser=%au in=%br out=%bs suser=%cu src=%ci spt=%cp requestCookies=%c dhost=%h outcome=%s suid=%id requestMethod=%m app=%p msg=%q requestContext=%r dst=%si dpt=%sp  rt=%tarc request=%u requestClientApplication=%ua dvchost=%un cs1Label=ClientType cs1=%ct cs2Label=Protected cs2=%pf cs3Label=ProxyIP cs3=%px cs4Label=ProfileMatched cs4=%pmf cs6Label=WFMatched cs6=%wmf cn1Label=ServicePort cn1=%ap cn2Label=CacheHit cn2=%ch cn3Label=ProxyPort cn3=%pp flexNumber1Label=ServerTime(ms) flexNumber1=%st flexNumber2Label=TimeTaken(ms) flexNumber2=%tt flexString1Label=ProtocolVersion flexString1=%v BarracudaWafCustomHeader1=%cs1 BarracudaWafCustomHeader2=%cs2 BarracudaWafCustomHeader3=%cs3 BarracudaWafResponseType=%rtf BarracudaWafSessionID=%sid destinationServiceName=%sn`


![alt text](https://github.com/aravindan-acct/logstash_arm/blob/main/images/waas_export_logs.png?raw=true)

## Logstash Server Troubleshooting

1. The configuration file, named waf.conf is under /etc/logstash/conf.d/. Any changes for the logstash input/filter or output section can be made here. Ensure to restart logstash if any changes are made to this file: `sudo systemctl stop logstash` and `sudo systemctl start logstash`

2. To check if logstash's configuration is working correctly, the file plugin is used to send the processed log events to a file on the server, which is named `output.txt` and can be found under `/home/labuser`
    2.a. If `output.txt` has no log events, logstash related logs can be checked under `/var/log/logstash/logstash-plain.log`, which captures service and plugin errors if any

