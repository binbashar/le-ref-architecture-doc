# Logs 

## Overview 

!!! abstract "Centralized Logs Solution"
    For this purpose we propose the usage of **Elasticsearch + Kibana** for database and visualization respectively. 
    By deploying the Fluentd daemonset on the Kubernetes clusters we can send all logs from running pods to Elasticsearch, 
    and with ‘beat’ we can send specific logs for resources outside of Kubernetes. There will be many components across the
    environment generating different types of logs: ALB access logs, s3 access logs, cloudfront access logs, application
    request logs, application error logs. Access logs on AWS based resources can be stored in a centralized bucket for that
    purpose, on the security account and given the need these can be streamed to Elasticsearch as well if needed.

![leverage-monitoring](../../../assets/images/diagrams/monitoring-metrics-logs.png "Leverage"){: style="width:750px"}
<figcaption style="font-size:15px">
<b>Figure:</b> Monitoring metrics and log architecture diagram (just as reference).
(Source: Binbash Leverage, 
<a href="https://drive.google.com/file/d/1KYZC-wTXn2PSVIEtikx9PFOwK2SoCxD8/view?usp=sharing">
"AWS Well Architected Reliability Report example"</a>,
Binbash Leverage Doc, accessed November 18th 2020).
</figcaption>

!!! danger "Alerting based on Logs" 
    Certain features that were only available under licence were recently made available by Elastic, and included in the
    open source project of Elasticsearch. [**Elastalert**](https://github.com/Yelp/elastalert) allow us to generate
    alerts based on certain log entries or even after counting a certain amount of a type of entry, providing great
    flexibility.

--

## Alternatives Comparison Table

!!! info "Leverage Confluence Documentation"    
    You'll find [**here**](https://binbash.atlassian.net/wiki/external/1789165573/NGE2N2M5YTVkNTYyNDFjYzljYTY3NjY4MWVmMTEyMWM?atlOrigin=eyJpIjoiYjVhZDJmMTZhNmQxNGQ5NzkyMThmNDg3ZDEyZGVkNzUiLCJwIjoiYyJ9
    ) a detailed comparison table between **EC2 Self-hosted** and **AWS ElasticSearch** Elastic-Kibana Stack.



