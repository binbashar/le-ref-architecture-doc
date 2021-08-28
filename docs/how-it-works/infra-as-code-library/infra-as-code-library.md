# Leverage Infrastructure as Code (IaC) Library

## Overview
A collection of reusable, tested, production-ready E2E
infrastructure as code solutions, leveraged by modules written in Terraform, Ansible, Jenkinsfiles, 
Dockerfiles, Helm charts and Makefiles).

### Model

Our development model is strongly based on code reusability 
![infra-as-code-library](../../assets/images/diagrams/infra-as-code-library-specs.png "Leverage"){: style="width:750px"}

### Reusability
High level summary of the the code reusability efficiency  
![infra-as-code-library](../../assets/images/diagrams/infra-as-code-library-reuse.png "Leverage"){: style="width:750px"}


!!! important "Considerations"
    :warning: Above detailed `%` are to be seen as estimates 
    
    - :cloud: :lock: [AWS PCI-DSS Reference article](https://aws.amazon.com/quickstart/architecture/compliance-pci/)
    - :cloud: :lock: [AWS HIPAA Reference article](https://aws.amazon.com/compliance/hipaa-compliance/)
    - :cloud: :lock: [AWS GDPR Reference article](https://aws.amazon.com/compliance/gdpr-center/)

### Modules
Infrastructure as Code (IaC) Library development and implementation workflow  
![infra-as-code-library](../../assets/images/diagrams/infra-as-code-library-workflow.png "Leverage"){: style="width:850px"}


