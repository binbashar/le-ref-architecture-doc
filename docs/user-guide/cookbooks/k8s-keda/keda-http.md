# K8s pod autoscaling with KEDA based on HTTP requests 

The KEDA HTTP Add-on allows Kubernetes users to automatically scale their HTTP servers up and down (including to/from zero) based on incoming HTTP traffic. Please see our use cases document to learn more about how and why you would use this project.

## Goal

To configure a KEDA Autoscaler based on HTTP requests to a K8s service.

**Note** for the following example we will be using a Kedacore plugin called **http-add-on**.

!!! Note
    To lear more about KEDA HTTP Add-on read [the official site](https://github.com/kedacore/http-add-on).
    
### Assumptions

We are assuming the [**binbash Leverage**](https://leverage.binbash.co/) [Landing Zone](https://leverage.binbash.co/try-leverage/) is deployed, an account called `apps-devstg` was created and region `us-east-1` is being used. In any case you can adapt these examples to other scenarios.

---

---

## Installation

Note that besides KEDA, the Add-on has to be enabled in the components layer [here](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/k8s-eks/k8s-components).

To do this, same as `enable_keda`, `enable_keda_http_add_on` has to be set to `true`.

To read more on how to enable components see [here](./k8s.md#eks).

## HTTP Requests as a base for escalation

Now, let's create an example so we can show how KEDA Works

### The app to scale

We will deploy a simple NGINX server.

These are the manifests for NGINX.

Let's create a namespace:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: demoapps
  labels:
    name: demoapps
```

This is the `nginx.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: demoapps
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx-container
        image: nginx:latest
```

And this is the `service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
  namespace: demoapps
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

Deploy the resources using `kubectl`.

!!! Info
    Note you can use `kubectl` through [**binbash Leverage**](https://leverage.binbash.co/), for more info read [here](../../leverage-cli/reference/kubectl/).

These are the deployed resources:

```shell
NAME                                    READY   STATUS    RESTARTS   AGE
pod/nginx-deployment-5bb85d69d8-g997n   1/1     Running   0          55s

NAME                TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
service/nginx-svc   NodePort   10.100.222.129   <none>        80:30414/TCP   54s

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-deployment   1/1     1            1           56s

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-deployment-5bb85d69d8   1         1         1       56s
```

### Accessing the app

To try it, create a port-forward to the service and hit it from your browser.

```shell
kubectl port-forward -n demoapps svc/nginx-svc 8080:80
```

Try it!

```shell
curl localhost:8080
```

Now, it has no horizontal autoscaling tool (HPA), so it won't scale. I.e. it always will have one pod (as per the manifests).

### Go for Keda

Let's create then a KEDA autoscaler!

#### The HTTPScaledObject object

This is the manifest:

```yaml
apiVersion: http.keda.sh/v1alpha1
kind: HTTPScaledObject
metadata:
   name: nginx-scaledobject
   namespace: demoapps
spec:
   hosts:
     - "thehostname.internal"
   targetPendingRequests: 100
   scaleTargetRef:
       deployment: nginx-deployment
       service: nginx-svc
       port: 80
   replicas:
       min: 0
       max: 10
```

It can be seen an HPA and a custom resource were created:


```shell
NAME                                                              REFERENCE                     TARGETS               MINPODS   MAXPODS   REPLICAS   AGE
horizontalpodautoscaler.autoscaling/keda-hpa-nginx-scaledobject   Deployment/nginx-deployment   <unknown>/100 (avg)   1         10        0          15s

NAME                 TARGETWORKLOAD                        TARGETSERVICE   MINREPLICAS   MAXREPLICAS   AGE   ACTIVE
nginx-scaledobject   apps/v1/Deployment/nginx-deployment   nginx-svc:80    0             10            52s
```

Note in the HPA no replicas are in place, i.e. no pods for our app. Now if you try:

```shell
kubectl port-forward -n demoapps svc/nginx-svc 8080:80
```

...it will fail, since no pod are available to answer the service.

#### The intercepter

Instead we have to hit a KEDA intercepter, that will route the traffic using the Hosts in the `HTTPScaledObject` object.

We've set `thehostname.internal` as the name, so let's port-forward the intercepter...

```shell
kubectl port-forward -n keda svc/keda-add-ons-http-interceptor-proxy 8080:8080
```

...and hit it with the Host header set:

```shell
curl localhost:8080 -H "Host: thehostname.internal"
```

If you check the HPA now it will have at least one replica.

!!! Note
    Note the first query will have a delay since the pod has to be created.
    
Then if you cancel the port-forward and wait for a while, the deployment will be scaled-down to zero again.

Voilà!

!!! Note
    There are other ways to configure KEDA, e.g. using Prometheus metrics, read more [here](https://keda.sh/docs/2.15/concepts/).
    
## Final thoughts

Given the scale-to-zero feature for pods, KEDA is a great match to Karpenter!
