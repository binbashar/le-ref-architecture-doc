# High Availability & Helthchecks 

## Recovery from Failures 

!!! attention "Automatic recovery from failure" 
    It keeps an AWS environment reliable. Using logs and metrics from CloudWatch, designing a system where the failures
    themselves trigger recovery is the way to move forward.

![leverage-aws-reliability](../../assets/images/diagrams/aws-reliability-ha-recovery-failure.png "Leverage"){: style="width:750px"}
<figcaption style="font-size:15px">Figure: AWS HA architecture diagrams (just as reference).</figcaption>

## Recovery Procedures 

!!! attention "Test recovery procedures" 
    The risks faced by cloud environment and systems, the points of failure for systems and ecosystems, as well as
    details about the most probable attacks are known and can be simulated. Testing recovery procedures are something
    that can be done using these insights. Real points of failure are exploited and the way the environment reacts to
    the emergency shows just how reliable the system it.

![leverage-aws-reliability](../../assets/images/diagrams/aws-reliability-ha-recovery-procs.png "Leverage"){: style="width:750px"}
<figcaption style="font-size:15px">Figure: AWS HA architecture diagrams (just as reference).</figcaption>

## Scalability and Availability

!!! attention "Scale horizontally to increase aggregate system availability" 
    The cloud environment needs to have multiple redundancies and additional modules as added security
    measures. Of course, multiple redundancies require good management and maintenance for them to remain active through
    the environment’s lifecycle.

![leverage-aws-reliability](../../assets/images/diagrams/aws-reliability-ha-recovery-scaling.png "Leverage"){: style="width:750px"}
<figcaption style="font-size:15px">Figure: AWS HA scalable architecture diagrams (just as reference).</figcaption>

## Helthchecks & Self-healing

### K8s and containers

!!! quote "[K8s readiness and liveness probes](https://cloud.google.com/health-checks-with-readiness-and-liveness-probes)"
    Distributed systems can be hard to manage. A big reason is that there are many moving parts that all need to work
    for the system to function. If a small part breaks, the system has to detect it, route around it, and fix it. 
    And this all needs to be done automatically!
    Health checks are a simple way to let the system know if an instance of your app is working or not working. 
    
    If an instance of your app is not working, then other services should not access it or send a request to it. 
    Instead, requests should be sent to another instance of the app that is ready, or re-tried at a later time. The 
    system should also bring your app back to a healthy state.
    
    By default, Kubernetes starts to send traffic to a pod when all the containers inside the pod start, and restarts
    containers when they crash. While this can be “good enough” when you are starting out, you can make your
    deployments more robust by creating custom health checks. Fortunately, Kubernetes make this relatively
    straightforward, so there is no excuse not to!”    
 
 So aside from the monitoring and alerting that underlying infrastructure will have, application container will have 
 their own mechanisms to determine readiness and liveness. These are features that our scheduler of choice Kubernetes
 natively allows, to read more [click here](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/).