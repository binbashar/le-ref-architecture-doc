# VPN Server

### To securely and scalable privately access AWS Cross Organization resources we’ll implement [Pritunl VPN Server](https://pritunl.com/)


!!! danger "Security Directives"
    1. **Private HTTP endpoints** for Applications (FrontEnd + APIs), SSH, monitoring & logging (UI / Dashboards) among others. Eg: Jenkins, DroneCI, EFK, Prometheus, Spinnaker, Grafana.
    2. **K8s API via kubectl private endpoint** eg: avoiding emergency K8s API vulnerability patching. 
    3. **Limit exposure:** Limit the exposure of the
    [workload](https://wa.aws.amazon.com/wat.concept.workload.en.html) to the internet and internal
    networks by only allowing minimum required access -> Avoiding exposure for Dev/QA/Stg http
    endpoints
    
        1. The Pritunl OpenVPN Linux instance is hardened and only runs this VPN solution. All other ports/access is restricted.
        2. Each VPN user can be required to use MFA to connect via VPN (as well as strong passwords). This combination makes almost impossible for an outsider to gain access via VPN.
        3. Centralized access and audit logs.
   
![leverage-vpn](../../assets/images/diagrams/ref-architecture-vpn.png "Leverage"){: style="width:650px"}


### Read More
- [x] [Pritunl - Open Source Enterprise Distributed OpenVPN, IPsec and WireGuard Server Specifications](https://drive.google.com/file/d/1piF0pZSTwcV4oHTIh_VsqZzEWTK5_zlv/view?usp=sharing) :cloud: :lock: