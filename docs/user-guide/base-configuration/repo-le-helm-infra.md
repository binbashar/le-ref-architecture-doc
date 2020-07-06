# Configuration: le-helm-infra

## Overview
This repository holds infrastructure that we deploy to our clusters via Helm + Helmsman.

## Files and Directories

Environment directories contain the Helmsman's desired state file that define what charts are deployed to each environment

```bash
.
├── @bin                    => Binaries, scripts and helpers used across the repository
...
├── devstg
│   ├── aws-eks             => Components of the 'devstg' EKS cluster
│   └── aws-kops            => Components of the 'devstg' Kops cluster
├── @doc
│   └── figures
├── LICENSE.md
├── localdev                => Components of the 'local' Kind cluster
│   ├── helmsman.yaml       => The desired state file used by Helmsman to install/remove cluster components
│   ├── fluentd-daemonset   => Custom values for the fluentd-daemonset chart (equivalent for other components)
...
│   ├── Makefile            => A helper to run typical commands
...
└── README.md
```
 
## Requirements
* Docker >= v18.09
* Helm and Helmsman are provided via docker image

