# Basic CLI features

To view a list of all the available commands and options in your current Leverage version simply run `leverage` or `leverage --help`. You should get an output similar to this:
``` bash
$ leverage
Usage: leverage [OPTIONS] COMMAND [ARGS]...

  Leverage Reference Architecture projects command-line tool.

Options:
  -v, --verbose  Increase output verbosity.
  --version      Show the version and exit.
  --help         Show this message and exit.

Commands:
  aws          Run AWS CLI commands in a custom containerized environment.
  credentials  Manage AWS cli credentials.
  kc           Run Kubectl commands in a custom containerized environment.
  kubectl      Run Kubectl commands in a custom containerized environment.
  project      Manage a Leverage project.
  run          Perform specified task(s) and all of its dependencies.
  shell        Run a shell in a generic container.
  terraform    Run Terraform commands in a custom containerized...
  tf           Run Terraform commands in a custom containerized...
  tfautomv     Run TFAutomv commands in a custom containerized...
```

Similarly, subcommands provide further information by means of the `--help` flag. For example `leverage tf --help`.

## Global options
* `-v` | `--verbose`: Increases output verbosity.  
  When running a command in a container, the tool provides a description of the container's configuration before the execution.  
  This is specially useful if the user were to to have the need of recreating Leverage's behavior by themselves.  
  ``` bash
  $ leverage -v tf plan
  [20:27:44.758] DEBUG    Found config file /home/user/binbash/le-tf-infra-aws/build.env
  [20:27:44.812] DEBUG    Container configuration:
                          {
                            "image": "binbash/leverage-toolbox:1.5.0-0.2.3-1000-1000", #(1)!
                            "command": "",
                            "stdin_open": true,
                            "environment": { #(2)!
                              "COMMON_CONFIG_FILE": "/binbash/config/common.tfvars",
                              "ACCOUNT_CONFIG_FILE": "/binbash/apps-devstg/config/account.tfvars",
                              "BACKEND_CONFIG_FILE": "/binbash/apps-devstg/config/backend.tfvars",
                              "AWS_SHARED_CREDENTIALS_FILE": "/home/leverage/tmp/bb/credentials",
                              "AWS_CONFIG_FILE": "/home/leverage/tmp/bb/config",
                              "SRC_AWS_SHARED_CREDENTIALS_FILE": "/home/leverage/tmp/bb/credentials",
                              "SRC_AWS_CONFIG_FILE": "/home/leverage/tmp/bb/config",
                              "AWS_CACHE_DIR": "/home/leverage/tmp/bb/cache",
                              "SSO_CACHE_DIR": "/home/leverage/tmp/bb/sso/cache",
                              "SCRIPT_LOG_LEVEL": 3,
                              "MFA_SCRIPT_LOG_LEVEL": 3,
                              "SSH_AUTH_SOCK": "/ssh-agent"
                            },
                            "entrypoint": "/bin/terraform",
                            "working_dir": "/binbash/apps-devstg/us-east-1/k8s-eks/identities",
                            "host_config": {
                              "NetworkMode": "default",
                              "SecurityOpt": [
                                "label=disable"
                              ],
                              "Mounts": [ #(3)!
                                {
                                  "Target": "/binbash",
                                  "Source": "/home/user/binbash/le-tf-infra-aws",
                                  "Type": "bind",
                                  "ReadOnly": false
                                },
                                {
                                  "Target": "/home/leverage/tmp/bb",
                                  "Source": "/home/user/.aws/bb",
                                  "Type": "bind",
                                  "ReadOnly": false
                                },
                                {
                                  "Target": "/etc/gitconfig",
                                  "Source": "/home/user/.gitconfig",
                                  "Type": "bind",
                                  "ReadOnly": false
                                },
                                {
                                  "Target": "/ssh-agent",
                                  "Source": "/run/user/1000/keyring/ssh",
                                  "Type": "bind",
                                  "ReadOnly": false
                                }
                              ]
                            }
                          }
  [20:27:44.825] INFO     Checking for local docker image, tag: 1.5.0-0.2.3-1000-1000...
  [20:27:44.851] INFO     ✔ OK

  [20:27:44.853] DEBUG    Checking for layer /home/user/binbash/le-tf-infra-aws/apps-devstg/us-east-1/k8s-eks/identities...
  [20:27:44.875] DEBUG    Checking layer /home/user/binbash/le-tf-infra-aws/apps-devstg/us-east-1/k8s-eks/identities...
  [20:27:44.876] DEBUG    Running command: sh -c 'cat $SSO_CACHE_DIR/token'
  [20:27:47.469] INFO     Attempting to get temporary credentials for shared account.
  [20:27:47.471] DEBUG    Token expiration time: 1740094585.0
                DEBUG    Token renewal time: 1740182267.470991
  [20:27:47.472] DEBUG    Retrieving role credentials for DevOps...
  [20:27:48.558] INFO     Writing binbash-shared-devops profile
  [20:27:48.564] INFO     Credentials for shared account written successfully.
  [20:27:48.567] INFO     Attempting to get temporary credentials for apps-devstg account.
  [20:27:48.570] DEBUG    Token expiration time: 1740094584.0
  [20:27:48.571] DEBUG    Token renewal time: 1740182268.5704691
  [20:27:48.572] DEBUG    Retrieving role credentials for DevOps...
  [20:27:49.171] INFO     Writing binbash-apps-devstg-devops profile
  [20:27:49.177] INFO     Credentials for apps-devstg account written successfully.
  [20:27:49.182] DEBUG    Running command: plan -var-file=/binbash/config/common.tfvars -var-file=/binbash/apps-devstg/config/account.tfvars -var-file=/binbash/apps-devstg/config/backend.tfvars #(4)!
  ...
  ```  

    1. :simple-docker: Docker image being used
    2. Environment variables available in the container
    3. Mapping of the host (`Source`) directories and files into the container (`Target`)
    4. Command being executed (useful when trying to replicate Leverage's behavior by yourself)
