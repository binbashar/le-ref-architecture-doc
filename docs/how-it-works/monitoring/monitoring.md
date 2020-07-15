# SRE & Monitoring: Metrics, Logs & Tracing

## Overview

There are two key approaches that we will cover with the proposed tools, Logs based monitoring and Metrics based monitoring. 

!!! check "**Monitoring tools**" 
    :bar_chart: **Metrics:** [Prometheus](https://prometheus.io/)
        - node-exporter 
        - blackbox-exporter
        - alert-manager 
    
    :bar_chart: **Metrics Dashboard:** [Grafana](https://grafana.com/)
        
    - [x] Data Sources
        - Prometheus 
        - CloudWatch
    - [x] Plugins 
        - piechart-panel 
        - devopsprodigy-kubegraf-app
    
    :bar_chart: **Centralized Logs:** [Elasticsearch-Fluent-Kibana (EFK)](https://www.elastic.co/) 
        
    - [x] Query Logs 
    - [x] Dashboards 
    - [x] Alerts based on logs
    
    :bar_chart: **Distributed Tracing:** [Jaeger](https://www.jaegertracing.io/) + [Opensensus](https://opencensus.io/)
