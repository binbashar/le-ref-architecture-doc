# Leverage Open Source Modules management.


!!! info "We’ll fork every Infrastructure as Code (IaC) Library dependency repo, why?"
    **Grant full governance over the lib repositories**

    - [x] **Availability:** Because our project resilience and continuity
    (including the clients) depends on these repositories (via requirement files or imports)
    and we want and need total control over the repository used as a dependency.
    **NOTE:** There could be few exceptions when using official open source
    modules makes sense, e.g. the ones shared and maintained by Nginx, Weave, Hashiport, etc.
    - [x] **Reliability (Avoid unforeseen events):** in the event that the original 
    project becomes discontinued while we are still working or depending on it
    (the owners, generally individual maintainers of the original repository, might
    decide to move from github, ansible galaxy, etc. or even close their repo for
    personal reasons).
    - [x] **Stability:** Our forks form modules (ansible roles / terraform / dockerfiles, etc.)
    are always going to be locked to fixed versions for every client so no unexpected behavior will occur.
    - [x] **Projects that don't tag versions:** having the fork protects us against breaking
    changes.
    - [x] **Write access:** to every Leverage library component repository ensuring at all
    times that we can support, update, maintain, test, customize and release a new version
    of this component.
    - [x] **Centralized Org source of truth:** for improved customer experience and keeping
    dependencies consistently imported from binbash repos at [Leverage Github](https://github.com/binbashar)
    - [x] **Scope:** binbash grants and responds for all these dependencies.
    - [x] **Metrics:**  Dashboards w/ internal measurements.
    - [x] **Automation:** We’ll maintain all this workflow cross-tech as standardized and
    automated as possible, adding any extra validation like testing, security check, etc., if
    needed -> [Leverage dev-tools](https://github.com/binbashar/le-dev-tools )
    - [x] **Licence & Ownership:** Since we fork open-source and commercially reusable
    components w/ [MIT and Apache 2.0 license](https://choosealicense.com/licenses/apache-2.0/). 
    We keep full rights to all commercial, modification, distribution, and private use of
    the code (No Lock-In w/ owners) through forks inside our own Leverage Project repos. 
    As a result, when time comes, we can make our libs private at any moment if necessary.
    (for the time being Open Source looks like the best option)

!!! important "Collaborators considerations"
    - We look forward to have every binbash Leverage repo open sourced favoring the 
    collaboration of the open source community. 
    - Repos that are still **private** must not be forked by our internal collaborators
    till we've done a detailed and rigorous review in order to open source them.
    - As a result any person looking forward to use, extend or update Leverage **public repos**,
    could also fork them in its personal or company Github account and create an upstream
    PR to contribute.
