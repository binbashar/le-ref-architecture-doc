# Infrastructure Instances Tools 

### Overview 

Apart from the EC2 instances that are part of Kubernetes, there are going to be other instances running tools for 
monitoring, logging centralization, builds/tests, deployment, among others. that are to be defined at this point. 
Some of them can be replaced by managed services, like: CircleCI, Snyk, etc, and this can have cons and pros that will
need to be considered at the time of implementation. Any OS that is provisioned will be completely reproducible as code,
in the event of migration to another vendor.

!!! info  "Other settings for all EC2 instances"
    * [x] Ubuntu 18.04 based (Latest AMI)
    * [x] EBS volumes encrypted: Yes
    * [x] EBS volume type: gp2 (SSD)
    * [x] Termination protection: Yes

!!! example "Infrastructure EC2 instances"
    * [x] **VPN Server**
        * Pritunl (https://vpn.domain.com) 
    * [x] **Monitoring & Alerting**
        * Prometheus (https://prometheus.domain.com)  
        * Grafana (https://grafana.domain.com) 
    * [x] **Centralized Logs**
        * Elasticsearch + Kibana (https://kibana.domain.com)  
    * [x] **CI/CD**
        * Jenkins (https://jenkins.domain.com) 
        * Spinnaker (https://spinnaker.domain.com)
        * Droneci (https://droneci.domain.com)
        * Webhook (https://webhook.domain.com)  
    * [x] **Secret Mgmt**
        * Hashicorp Vault (https://vault.domain.com) 