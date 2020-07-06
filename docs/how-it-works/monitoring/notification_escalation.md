# Notification & Escalation Procedure

## Overview

<table>
  <tr>
   <td><strong>Urgency</strong>
   </td>
   <td><strong>Service Notification Setting</strong>
   </td>
   <td><strong>Use When</strong>
   </td>
   <td><strong>Response</strong>
   </td>
  </tr>
  <tr>
   <td>High 24/7
   </td>
   <td>High-priority PagerDuty Alert 24/7/365
   </td>
   <td>
<ul>

<li> 
Issue is in Production

<li>Or affects the applications/services and in turn affects the normal operation of the clinics

<li>Or prevents clinic patients to interact with the applications/services
</li>
</ul>
   </td>
   <td>
<ul>

<li> 
Requires immediate human action

<li>Escalate as needed

<li>The engineer should be woken up
</li>
</ul>
   </td>
  </tr>
  <tr>
   <td>High during support hours
   </td>
   <td>High-priority Slack Notifications during support hours
   </td>
   <td>
<ul>

<li> 
Issue impacts development team productivity

<li>Issue impacts the normal business operation
</li>
</ul>
   </td>
   <td>
<ul>

<li> 
Requires immediate human action ONLY during business hours
</li>
</ul>
   </td>
  </tr>
  <tr>
   <td>Low
   </td>
   <td>Low Priority Slack Notification
   </td>
   <td>
<ul>

<li> 
Any issue, on any environment, that occurs during working hours
</li>
</ul>
   </td>
   <td>
<ul>

<li> 
Requires human action at some point

<li>Do not escalate

<li>An engineer should not be woken up
</li>
</ul>
   </td>
  </tr>
</table>

# Service Notification Settings

<table>
  <tr>
   <td><strong>Service Notification Setting</strong>
   </td>
   <td><strong>Description</strong>
   </td>
  </tr>
  <tr>
   <td>High-priority PagerDuty Alert 24/7/365
   </td>
   <td>
<ul>

<li> \
Notify on-call engineers \
--- At first, notify via SMS/Push \
--- Notify via Phone Call if after 10 minutes the previous has not acknowledged

<li>Notify person X (this is a person who needs to be aware of any of these issues always)

<li>Notify to Slack => engineering-urgent-alerts channel
</li>
</ul>
   </td>
  </tr>
  <tr>
   <td>High-priority Slack Notifications during support hours
   </td>
   <td>
<ul>

<li> \
Notify to Slack => engineering-alerts channel
</li>
</ul>
   </td>
  </tr>
  <tr>
   <td>Low Priority Slack Notification
   </td>
   <td>
<ul>

<li> \
Notify to Slack => engineering-alerts channel
</li>
</ul>
   </td>
  </tr>
</table>


# Alert Types

!!! danger "**UpTimeRobot (black box)**" 
    * [https://uptimerobot.com/](https://uptimerobot.com/)
    * Sites or APIs are down

!!! danger "**Prometheus Alert Manager (black box, metrics-based)**"
    * [http://prometheus.aws.domain.com/](http://prometheus.aws.domain.com/)
    * Clusters issues (masters/nodes high resources usage)
    * Instance issues (Pritunl VPN, Jenkins, Spinnaker, Grafana, Kibana, etc)
    * Alerts from Prometheus Blackbox Exporter

!!! danger "**Kibana ElastAlert (black box, logs-based)**"
    *   Intended for applications/services logs
    *   Applications/services issues (frontends, backend services)
    *   Cluster components issues (nginx-ingress, cert-manager, linkerd, etc)

!!! danger "**PagerDuty**"
    *   [https://domain.pagerduty.com/](https://domain.pagerduty.com/)
    *   Incident management


# Implementation Reference Example

!!! tip "**Slack**"
    All alerts are sent to #engineering-urgent-alerts channel. Members that are online can have visibility from there.
    AlertManager takes care of sending such alerts according to the rules defined here: **TODO**
    
    **Note:** there is a channel named `engineering-alerts` but is used for Github notifications. It didn’t make sense to
    mix real alerts with that, that is why a new `engineering-urgent-alerts` channel was created. As a recommendation,
    Github notifications should be sent to a channel named like #engineering-notifications and leave
    `engineering-alerts` for real alerts.

!!! tip "**PagerDuty**"
    AlertManager only sends to PagerDuty alerts that are labeled as **severity: critical**. PagerDuty is configured to 
    turn these into [incidents](https://domain.pagerduty.com/incidents) according to the settings
    defined [here](https://domain.pagerduty.com/service-directory) for the
    [Prometheus Critical Alerts service](https://domain.pagerduty.com/service-directory). The aforementioned
    service uses [HiPriorityAllYearRound escalation policy](https://domain.pagerduty.com/escalation_policies)
    to define who gets notified and how.
    
    **Note:** currently only the TechOwnership role gets notified as we don’t have agreements or rules about on-call 
    support but this can be easily changed in the future to accommodate business decisions.

!!! tip "**UpTimeRobot**"
    We are doing basic http monitoring on the following sites:
    *   www.domain_1.com
    *   www.domain_2.com
    *   www.domain_3.com

    **Note:** a personal account has been set up for this. As a recommendation, an new account should be created using
     an email account that belongs to Veev project.
