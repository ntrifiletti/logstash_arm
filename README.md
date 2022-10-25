# Barracuda WAF As A Service Integration with Azure Log Analaytics / Microsoft Sentinel

## Table of contents
1. [Introduction](#introduction)
2. [Deploying the Logstash Server](#deploying-the-logstash-server)
    1. [Deployment Pre-Requisites](#deployment-pre-requisites)
    2. [Deploying the ARM Template](#deploying-the-arm-template)
    3. [WAAS Configuration](#waas-configuration)
    4. [Logstash Server Troubleshooting](#logstash-server-troubleshooting)
    5. [Log events in Azure Log Analytics / Microsoft Sentinel](#log-events-in-azure-log-analytics--microsoft-sentinel)
## Introduction
This repo can be used to deploy a logstash server that can act as a mediator to send logs from one or more WAAS services to Log Analytics and Microsoft Sentinel.

## Deploying the Logstash Server
The [logstash](https://www.elastic.co/guide/en/logstash/current/introduction.html) server can be deployed using the [ARM template](https://raw.githubusercontent.com/aravindan-acct/logstash_arm/main/logstash_arm.json) in this repo. 

Most of the logstash server's settings are already configured. The only inputs for the ARM template deployment are the logstash server `password`, the log analytics `workspace id` and log analytics `workspace key`, which can be updated in the ARM template's [parameters file](https://raw.githubusercontent.com/aravindan-acct/logstash_arm/main/logstash_arm.parameters.json). 

The Logstash configuration can be found here: [Logstash Configuration File](https://github.com/aravindan-acct/logstash_arm/blob/main/scripts/waf.conf)

### Deployment Pre-Requisites

1. Log Analytics Workspace ID and Workspace Key
2. WAAS Account and [Application](https://campus.barracuda.com/doc/77399164/) to send logs to the logstash server

### Deploying the ARM Template

#### Note: Please change the password (serverpassword) in the logstash_arm.parameters.json file before deploying.

To deploy using `Portal`, refer to [Microsoft Documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-portal)

To deploy using `Powershell`, copy the command below:

1. Create a resource group

```powershell
New-AzResourceGroup -Name ExampleResourceGroup -Location "Central US"
```

2. Deploy the template

```powershell
New-AzResourceGroupDeployment -Name ExampleDeployment -ResourceGroupName ExampleResourceGroup `
  -TemplateUri https://raw.githubusercontent.com/ntrifiletti/logstash_arm/main/logstash_arm.json `
  -TemplateParameterUri https://raw.githubusercontent.com/ntrifiletti/logstash_arm/main/logstash_arm.parameters.json
```


### WAAS Configuration
1. Add the export logs component
2. Add the syslog server and set the port as 1514 (UDP)
3. Log format configuration

    3.a For the Syslog Header field, select ArcSight Log Header. The header value format will be auto set as follows:

    ```CEF:0|DeviceVendor|Product|DeviceVersion|SignatureID|Name|Severity|```

    3.b For the Firewall logs and Access logs fields, select Microsoft Azure OMS. The log format will be auto set as follows:
    
    Firewall Logs:
    
    ```%header cat=%lt dst=%ai dpt=%ap act=%at msg=%adl duser=%au src=%ci spt=%cp requestMethod=%m app=%p requestContext=%r rt=%tarc request=%u requestClientApplication=%ua dvchost=%un cn2=%pp cn2Label=ProxyPort cs1=%ri cs1Label=RuleID cs2=%fa cs2Label=FollowUpAction cs3=%rt cs3Label=RuleType cs4=%ag cs4Label=AttackGroup cs5=%px cs5Label=ProxyIP cs6=%sid cs6Label=SessionID destinationServiceName=%sn```

    Access Logs:

    ```%header cat=%lt dvc=%ai duser=%au in=%br out=%bs suser=%cu src=%ci spt=%cp requestCookies=%c dhost=%h outcome=%s suid=%id requestMethod=%m app=%p msg=%q requestContext=%r dst=%si dpt=%sp  rt=%tarc request=%u requestClientApplication=%ua dvchost=%un cs1Label=ClientType cs1=%ct cs2Label=Protected cs2=%pf cs3Label=ProxyIP cs3=%px cs4Label=ProfileMatched cs4=%pmf cs6Label=WFMatched cs6=%wmf cn1Label=ServicePort cn1=%ap cn2Label=CacheHit cn2=%ch cn3Label=ProxyPort cn3=%pp flexNumber1Label=ServerTime(ms) flexNumber1=%st flexNumber2Label=TimeTaken(ms) flexNumber2=%tt flexString1Label=ProtocolVersion flexString1=%v BarracudaWafCustomHeader1=%cs1 BarracudaWafCustomHeader2=%cs2 BarracudaWafCustomHeader3=%cs3 BarracudaWafResponseType=%rtf BarracudaWafSessionID=%sid destinationServiceName=%sn```


![alt text](https://github.com/aravindan-acct/logstash_arm/blob/main/images/waas_export_logs.png?raw=true)

### Logstash Server Troubleshooting

(To login to the server over ssh, use "labuser" as the username)

1. The configuration file, named `waf.conf`is under `/etc/logstash/conf.d/`. Any changes for the logstash input/filter or output section can be made here. Ensure to restart logstash if any changes are made to this file: `sudo systemctl stop logstash` and `sudo systemctl start logstash`.

2. To check if logstash's configuration is working correctly, the file plugin is used to send the processed log events to a file on the server, which is named `output.txt` and can be found under `/home/labuser`.

    2.a. If `output.txt` has no log events, logstash related logs can be checked under `/var/log/logstash/logstash-plain.log`, which captures service and plugin errors if any.

### Log events in Azure Log Analytics / Microsoft Sentinel

The processed logs can be found in a custom log table called `WAAS_MS_Sentinel` in the log analytics workspace. These logs will be the source data based on which visualization / analytics / orchestration tasks can be performed.

### Notes about deployment 

1. The ARM template has the following NSG rules: 
    - Syslog port: UDP 1514
    - SSH Port : TCP 22 
