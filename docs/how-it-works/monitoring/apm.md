# Application Performance Monitoring (APM) and Business Performance

Custom **Prometheus BlackBox Exporter + Grafana** & 
[**Elastic Application performance monitoring (APM)**](https://www.elastic.co/apm)   delivers real-time and trending
data about your web application's performance and the level of satisfaction that your end users experience. With end to
end transaction tracing and a variety of color-coded charts and reports, APM visualizes your data, down to the deepest
code levels. Your DevOps teams don't need to guess whether a performance blocker comes from the app itself,
CPU availability, database loads, or something else entirely unexpected. With APM, you can quickly identify potential
problems before they affect your end users.

APM's user interface provides both current and historical information about memory usage, CPU utilization, database
query performance, web browser rendering performance, app availability and error analysis, external services, 
and other useful metrics.


## SLIs / KPIs

!!! check "Service Level Indicators (SLIs)"
    * [x] latency
    * [x] throughput
    * [x] availability
    * [x] error rate

!!! example "KPI for business performance"
    * :bar_chart: **General** 
        * DOM readiness 
        * Page render 
        * Apdex 
        * Mobile crash rate
    * :bar_chart: **Web** 
        * Session count
        * Session duration
        * Page views 
        * Error % 
    * :bar_chart: **Mobile** 
        * App launches
        * User counts
        * Load time
        * Crash rates
        * Crash locations 
        * Error rates 
        * API errors

!!! example "KPI for app and infrastructure teams"
    * :bar_chart: **App/Infra** 
        * Availability
        * Throughput 
        * App/Api/Db 
        * Response time 
        * Memory footprint 
        * CPU workload
    * :bar_chart: **DevOps** 
        * Builds 
        * Commits 
        * Deploys 
        * Errors 
        * Support incidents 
        * MTTR 

## Read More

* :ledger: [NewRelic | Optimize customer experience (KPIs)](https://docs.newrelic.com/docs/using-new-relic/welcome-new-relic/plan-your-cloud-adoption-strategy/optimize-customer-experience)