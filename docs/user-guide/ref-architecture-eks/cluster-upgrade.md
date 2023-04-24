# Upgrading EKS

## Brief
This guideline includes considerations and steps that should be performed when upgrading a cluster to a newer version.

## General Steps
- General considerations
- Understand what changed
- Plan a maintenance window for the upgrade
- Rehearse on a non-Production cluster first
- Ensure you have proper visibility on the cluster
- Upgrade Control Plane
- Upgrade Managed Node Groups
- Upgrade EKS Add-ons
- Upgrade Cluster AutoScaler version
- Final Steps
- Migration Notes


## Detailed Steps

### General considerations
- Ensure your sensitive workloads are deployed in a highly available manner to reduce downtime as much as possible
- Ensure Pod Disruption Budgets are set in your deployments to ensure your application pods are evicted in a controlled way (e.g. leave at least one pod active at all times)
- Ensure Liveness and Readiness probes are set so that Kubernetes can tell whether your application is healthy to start receiving traffic or needs a restart
- Plan the upgrade during off hours so that unexpected disruptions have even less impact on end-users

### Understand what changed
Here you need to get a good understanding of the things that changed between the current version and the version you want to upgrade to. For that, it is highly recommended to go to the [AWS EKS official documentation](https://docs.aws.amazon.com/eks/latest/userguide/update-cluster.html) as it is frequently being updated.

Another documentation you should refer to is the Kubernetes official documentation, specially the [Kubernetes API Migration Guide](https://kubernetes.io/docs/reference/using-api/deprecation-guide/) which explains in great detail what has been changed.

For instance, typical changes include:
* Removed/deprecated Kubernetes APIs: this one may require that you also upgrade the resources used by your applications or even base components your applications rely on. E.g. cert-manager, external-dns, etc.
* You can use tools such as [kubent](https://github.com/doitintl/kube-no-trouble) to find deprecated API versions. That should list the resources that need to be upgraded however you may still need to figure out if it's an EKS base component or a cluster component installed via Terraform & Helm.
* Base component updates: this is about changes to control plane components. components that run on the nodes. An example of that would be the deprecation and removal of Docker as a container runtime.

### Plan a maintenance window for the upgrade
Keep in mind that, at the very least, you will be upgrading the control plane and the data plane; and in some cases you would also need to upgrade components and workloads. So, although Kubernetes has a great development team and automation; and even though we rely on EKS for which AWS performs additional checks and validations, we are still dealing with a complex, evolving piece of software, so planning for the upgrade is still a reasonable move.

Upgrading the control plane should not affect the workloads but you should still bear in mind that the Kubernetes API may become unresponsive during the upgrade, so anything that talks to the Kubernetes API might experience delays or even timeouts.

Now, upgrading the nodes is the more sensitive task and, while you can use a rolling-update strategy, that still doesn't provide any guarantees on achieving a zero down-time upgrade so, again, planning for some maintenance time is recommended.

### Rehearse on a non-Production cluster first
Perform the upgrade on a non-Production to catch up and anticipate any issues before you upgrade the Production cluster. Also take notes and reflect any important updates on this document.

### Ensure you have proper visibility on the cluster
Monitoring the upgrade is important so make sure you have monitoring tools in-place before attempting the upgrade.
Such tools include the AWS console (via AWS EKS Monitoring section) and also tools like Prometheus/Grafana and ElasticSearch/Kibana. Make sure you are familiar with those before the upgrade.

### Upgrade Control Plane
This is simply about updating the `cluster_version` variable in the `variables.tf` file within the `cluster` layer of the cluster you want to upgrade and then applying that change. However, the current version of the Terraform EKS module, when modifying the cluster version input, it will show that it needs to upgrade the control plane and the nodes which may not follow the expected order (first cluster, then nodes). Another thing that could go wrong is Terraform ending up in an unfinished state due to the upgrade taking too long to complete (or, what happened to me, the cluster gets upgraded but somehow the launch template used for the nodes is deleted and thus the upgraded nodes cannot be spun up).

The alternative to all of that is to perform the upgrade outside Terraform and, after it is complete, to update the `cluster_version` variable in `variables.tf` file. Then you can run a Terraform Plan to verify the output shows no changes. This should be the method that provides a good degree of control over the upgrade.

Having said that, go ahead and proceed with the upgrade, either via [the AWS console, the AWS CLI or the EKS CLI](https://docs.aws.amazon.com/eks/latest/userguide/update-cluster.html) and watch the upgrade as it happens. As it was stated in a previous step, the Kubernetes API may evidence some down-time during this operation so make sure you prepare accordingly.

### Upgrade Managed Node Groups
Once the control plane is upgraded you should be ready to upgrade the nodes. There are 2 strategies you could use here: rolling-upgrade or recreate. The former is recommended for causing the minimal disruption. Recreate could be used in an environment where down-time won't be an issue.

As it was mentioned in the previous step, the recommendation is to trigger the upgrade outside Terraform so please proceed with that and monitor the operation as it happens (via AWS EKS console, via Kubectl, via Prometheus/Grafana).

If you go with the AWS CLI, you can use the following command to get a list of the clusters available to your current AWS credentials:
```
aws eks list-clusters --profile [AWS_PROFILE]
```
Make a note of the cluster name as you will be using that in subsequent commands.

Now use the following command to get a list of the node groups:
```
aws eks list-nodegroups --cluster-name [CLUSTER_NAME] --profile [AWS_PROFILE]
```

After that you need to identify the appropriate release version for the upgrade. Use the official documentation to find that: https://docs.aws.amazon.com/eks/latest/userguide/eks-linux-ami-versions.html

With that information you should be ready to trigger the update with the command below:
```
aws eks update-nodegroup-version \
    --cluster-name [CLUSTER_NAME] \
    --nodegroup-name [NODE_GROUP_NAME] \
    --release-version [RELEASE_VERSION] \
    --force \
    --profile [AWS_PROFILE]
```
The `--force` flag is generally useful to by-pass pod eviction failures.

Once you are done with the upgrade you can continue with the rest of the node groups.

### Upgrade Cluster AutoScaler version
Modify [scaling.tf](https://github.com/binbashar/le-tf-infra-aws/blob/master/apps-devstg/us-east-1/k8s-eks/k8s-components/scaling.tf) per [the official Kubernetes autoscaler chart](https://github.com/kubernetes/autoscaler/tree/master/charts/cluster-autoscaler) and apply with Terraform.
The version of the cluster autoscaler should at least match the cluster version you are moving to. A greater version of the autoscaler might work with earlier version of Kubernetes but the opposite most likely won't be the case.

### Upgrade EKS base components
Namely these components are:
- Kube-Proxy
- CoreDNS
- VPC CNI

In recent versions EKS is able to manage these components as add-ons which makes their upgrades less involved and which can even be performed through a recent version of the Terraform EKS module. However, we are not currently using EKS Add-ons to manage the installation of these components, we are using the so called self-managed approach, so the upgrade needs to be applied manually.

Generally speaking, the upgrade procedure could be summed up as follows:
1. Determine current version
2. Determine the appropriate version you need to upgrade to
3. Upgrade each component and verify

Now, the recommendation is to refer to the following guides which carefully describe the steps that need to be performed:
1. Kube-proxy: https://docs.aws.amazon.com/eks/latest/userguide/managing-kube-proxy.html#updating-kube-proxy-add-on
2. CoreDNS: https://docs.aws.amazon.com/eks/latest/userguide/managing-coredns.html#updating-coredns-add-on
3. VPC CNI: https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html#updating-vpc-cni-add-on

IMPORTANT: be extremely careful when applying these updates, specially with the VPC CNI as the instructions are not easy to follow.

### Closing Steps
Make sure you notify the team about the upgrade result. Also, do not forget about committing/pushing all code changes to the repository and creating a PR for them.

### Migration Notes
If you found any information you consider it should be added to this document, you are welcome to reflect that here.

#### Migration to v1.21

VPC CNI: The latest available version was v1.11.4 but I was only able to upgrade to v1.9.3. I couldn't move further because v1.10.3 wasn't able to run as it keep throwing the following errors:
```
{"level":"info","ts":"2022-10-07T15:42:01.802Z","caller":"entrypoint.sh","msg":"Retrying waiting for IPAM-D"}
panic: runtime error: invalid memory address or nil pointer dereference
[signal SIGSEGV: segmentation violation code=0x1 addr=0x39 pc=0x560d2186d418]
```

Cluster Autoscaler: it is already at v1.23.0. The idea is that this should match with the Kubernetes version but since the version we have has been working well so far, we can keep it and it should cover us until we upgrade Kubernetes to a matching version.

Managed Nodes failures due to PodEvictionFailure: this one happened twice during a Production cluster upgrade. It seemed to be related to Calico pods using tolerations that are not compatible with Kubernetes typical node upgrade procedure. In short, the pods tolerate the NoSchedule taint and thus refuse to be evicted from the nodes during a drain procedure. The workaround that worked was using a forced upgrade. That is esentially a flag that can be passed via Terraform (or via AWS CLI). A more permanent solution would involve figuring out a proper way to configure Calico pods without the problematic toleration; we just need to keep in mind that we are deploying Calico via the Tigera Operator.

#### Migration to v1.22

Control plane and managed nodes: no issues.
Cluster Autoscaler: already at v1.23.0.
Kube-proxy: no issues. Upgraded to v1.22.16-minimal-eksbuild.3.
CodeDNS: no issues. Upgraded to v1.8.7-eksbuild.1.
VPC CNI: no issues. Upgraded to latest version available, v1.12.1.

Outstanding issue: Prometheus/Grafana instance became unresponsive right during the upgrade of the control plane. It was fully inaccessible. A stop and start was needed to bring it back up.
