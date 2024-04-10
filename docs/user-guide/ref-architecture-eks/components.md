# Components

## Overview
![leverage-aws-eks](/assets/images/diagrams/ref-architecture-eks.png "Leverage"){: style="width:750px"}
<figcaption style="font-size:15px">
<b>Figure:</b> K8S EKS reference architecture components diagram. (Source: binbash Leverage Confluence Doc, 
<a href="https://binbash.atlassian.net/wiki/external/2001403925/ZjY5ZGU3NDYyODNhNDQzYTkxZDdkYTliNzczODRkY2M?atlOrigin=eyJpIjoiYjNmMzYwMTg2YmMyNDc3ODg4YTAwNDM5MjBiYWQ5ZGUiLCJwIjoiYyJ9">"Implementation Diagrams"</a>, binbash Leverage Doc, accessed January 5th 2022).
</figcaption>

## Components List
![leverage-aws-eks-detailed](/assets/images/diagrams/ref-architecture-eks-components.png "Leverage"){: style="width:750px"}
<figcaption style="font-size:15px">
<b>Figure:</b> K8S EKS reference architecture detailed components diagram. (Source: binbash Leverage Confluence Doc, 
<a href="https://binbash.atlassian.net/wiki/external/2001403925/ZjY5ZGU3NDYyODNhNDQzYTkxZDdkYTliNzczODRkY2M?atlOrigin=eyJpIjoiYjNmMzYwMTg2YmMyNDc3ODg4YTAwNDM5MjBiYWQ5ZGUiLCJwIjoiYyJ9"> "Implementation Diagrams"</a>, binbash Leverage Doc, accessed January 5th 2022).
</figcaption>


Most of these components and services are installed via Helm charts. Usually tweaking these components configuration is done via the input values for their corresponding chart. For detailed information on the different parameters please head to each component public documentation (Links in each section).


### AWS Load Balancer Controller

It automatically provisions AWS Application Load Balancers (ALB) or AWS Network Load Balancers (NLB) in response to the creation of Kubernetes `Ingress` or `LoadBalancer` resources respectively. Automates the routing of traffic to the cluster.

!!! example "Implementation in ref architecture: [/apps-devstg/us-east-1/k8s-eks-demoapps](https://github.com/binbashar/le-tf-infra-aws/blob/master/apps-devstg/us-east-1/k8s-eks-demoapps/k8s-components/networking-ingress.tf#L1-L19)"

!!! abstract "Documentation: [AWS Load Balancer Controller | Kubernetes-sigs](https://kubernetes-sigs.github.io/aws-load-balancer-controller/)"


### NGINX Ingress Controller

It is used to allow for the configuration of NGINX via a system of annotations in Kubernetes resources.

A configuration can be enforced globally, via the `controller.config` variable in the helm-chart, or individually for each application, via annotations in the `Ingress` resource of the application.

!!! example "Implementation in ref architecture: [/apps-devstg/us-east-1/k8s-eks-demoapps](https://github.com/binbashar/le-tf-infra-aws/blob/master/apps-devstg/us-east-1/k8s-eks-demoapps/k8s-components/networking-ingress.tf#L21-L37)"

!!! abstract "Documentation: [NGINX Ingress Controller | Kubernetes](https://kubernetes-sigs.github.io/aws-load-balancer-controller/)"

    _[:material-link: List of global configuration options](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/#configuration-options)_

    _[:material-link: List of annotations for `Ingress` resources](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/#annotations)_


### ExternalDNS

Automatically creates the required DNS records based on the definition of `Ingress` resources in the cluster.

The annotation `kubernetes.io/ingress.class: <class>` defines whether the records are created in the public hosted zone or the private hosted zone for the environment. It accepts one of two values: `public-apps` or `private-apps`.

!!! example "Implementation in ref architecture: [/apps-devstg/us-east-1/k8s-eks-demoapps](https://github.com/binbashar/le-tf-infra-aws/blob/master/apps-devstg/us-east-1/k8s-eks-demoapps/k8s-components/networking-dns.tf)"

!!! abstract "Documentation: [ExternalDNS | Kubernetes-sigs](https://github.com/kubernetes-sigs/external-dns)"


### cert-manager

Automates the management of certificates. The ClusterIssuer resource is needed to generate signed certificates within the cluster.

!!! example "Implementation in ref architecture: [/apps-devstg/us-east-1/k8s-eks-demoapps](https://github.com/binbashar/le-tf-infra-aws/blob/master/apps-devstg/us-east-1/k8s-eks-demoapps/k8s-components/security.tf#L1-L36)"

!!! abstract "Documentation: [cert-manager | cert-manager](https://cert-manager.io/docs/)"


### External Secrets Operator

Automatically fetches secrets and parameters from Parameter Store, AWS Secrets Manager and other sources, and makes them available in the cluster as Kubernetes Secrets.

!!! example "Implementation in ref architecture: [/apps-devstg/us-east-1/k8s-eks-demoapps](https://github.com/binbashar/le-tf-infra-aws/blob/master/apps-devstg/us-east-1/k8s-eks-demoapps/k8s-components/security.tf#L38-L53)"

!!! abstract "Documentation: [External Secrets Operator | External Secrets](https://external-secrets.io/)"


### Cluster Autoscaler

Automatically adjusts the size of the Kubernetes Cluster based on load.

It is configured to automatically detect the limits of the AutoScalingGroup the nodes are into.

!!! example "Implementation in ref architecture: [/apps-devstg/us-east-1/k8s-eks-demoapps](https://github.com/binbashar/le-tf-infra-aws/blob/master/apps-devstg/us-east-1/k8s-eks-demoapps/k8s-components/scaling.tf#L15-L34)"

!!! abstract "Documentation: [Cluster Autoscaler | Kubernetes](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md)"


### Jaeger

Distributed tracing platform.

It is usually configured to funnel traces from all environments to a centralized ElasticSearch/OpenSearch instance in the Shared account.

!!! example "Implementation in ref architecture: [/apps-devstg/us-east-1/k8s-eks-demoapps](https://github.com/artaio/devops-tf-infra/blob/master/apps-prd/us-east-1/k8s-eks/k8s-components/jaeger.tf)"

!!! abstract "Documentation: [Jaeger | JaegerTracing](https://www.jaegertracing.io/docs/)"


### Fluent-Bit

Collects, processes, and forwards logs and metrics. It is highly configurable and performant.

It is usually configured to funnel all pods' logs to a centralized ElasticSearch/OpenSearch instance in the Shared account.

!!! example "Implementation in ref architecture: [/apps-devstg/us-east-1/k8s-eks-demoapps](https://github.com/binbashar/le-tf-infra-aws/blob/master/apps-devstg/us-east-1/k8s-eks-demoapps/k8s-components/monitoring-logging.tf#L1-L20)"

!!! abstract "Documentation: [Fluent-bit | Fluent](https://docs.fluentbit.io/manual/v/2.0/)"


### kube-prometheus-stack

Stack of Kubernetes manifests, monitoring, alerting and visualization applications, rules and dashboards implementing an end-to-end Kubernetes monitoring solution.

!!! example "Implementation in ref architecture: [/apps-devstg/us-east-1/k8s-eks-demoapps](https://github.com/binbashar/le-tf-infra-aws/blob/master/apps-devstg/us-east-1/k8s-eks-demoapps/k8s-components/monitoring-metrics.tf#L40-L59)"

#### Prometheus

Gathers and stores metrics as time series data. Using alerting rules then issues notifications via Alertmanager whenever a rule is triggered.

#### Grafana

Allows for convenient visualization, filtering and querying of the metrics gathered by Prometheus.

!!! abstract "Documentation:"

    [:material-link: kube-prometheus-stack | Prometheus Monitoring Community](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/README.md)

    [:material-link: Prometheus | Prometheus](https://prometheus.io/docs/introduction/overview/)

    [:material-link: Grafana | Grafana Labs](https://grafana.com/docs/grafana/latest/)


### Argo CD

Enables GitOps continuous delivery on Kubernetes clusters.

!!! example "Implementation in ref architecture: [/apps-devstg/us-east-1/k8s-eks-demoapps](https://github.com/binbashar/le-tf-infra-aws/blob/master/apps-devstg/us-east-1/k8s-eks-demoapps/k8s-components/cicd-argo.tf#L1-L105)"

**Two supporting Argo CD components are used:**


#### Argo Rollouts

Provides the capability of using more complex deployment and promotion schemes to eliminate downtime and allow for greater control of the process. Like Blue-Green or Canary deployment.

#### Argo CD Image Updater

Tracks for new images in ECR and updates the applications definition so that Argo CD automatically proceeds with the deployment of such images.

!!! abstract "Documentation:"

    [:material-link: Argo CD | Argo](https://argo-cd.readthedocs.io/en/stable/)
    
    [:material-link: Argo Rollouts | Argo](https://argo-rollouts.readthedocs.io/en/stable/)
    
    [:material-link: Argo CD Image Updater | Argo](https://argocd-image-updater.readthedocs.io/en/stable/)


### Velero

Creates and restores backups, handles disaster recovery and migrations for Kubernetes resources and persistent volumes.

!!! example "Implementation in ref architecture: [/apps-devstg/us-east-1/k8s-eks](https://github.com/binbashar/le-tf-infra-aws/blob/master/apps-devstg/us-east-1/k8s-eks/k8s-components/backup.tf#L1-L20)"


!!! abstract "Documentation: [Velero | VMware Tanzu](https://velero.io/docs/v1.13/)"
