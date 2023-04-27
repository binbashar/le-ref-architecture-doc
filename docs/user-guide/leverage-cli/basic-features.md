# Basic CLI features

To view a list of all the available commands and options in your current Leverage version simply run `leverage` or `leverage --help`. You should get an output similar to this:
``` bash
$ leverage
Usage: leverage [OPTIONS] COMMAND [ARGS]...

  Leverage Reference Architecture projects command-line tool.

Options:
  -f, --filename TEXT  Name of the build file containing the tasks
                       definitions.  [default: build.py]
  -l, --list-tasks     List available tasks to run.
  -v, --verbose        Increase output verbosity.
  --version            Show the version and exit.
  --help               Show this message and exit.

Commands:
  aws          Run AWS CLI commands in a custom containerized environment.
  credentials  Manage AWS cli credentials.
  kubectl      Run Kubectl commands in a custom containerized environment.
  project      Manage a Leverage project.
  run          Perform specified task(s) and all of its dependencies.
  terraform    Run Terraform commands in a custom containerized...
  tf           Run Terraform commands in a custom containerized...
  tfautomv     Run TFAutomv commands in a custom containerized...
```

Similarly, subcommands provide further information by means of the `--help` flag. For example `leverage tf --help`.

## Global options
* `-f` | `--filename`:  Name of the file containing the tasks' definition. Defaults to `build.py`
* `-l` | `--list-tasks`: List all the tasks defined for the project along a description of their purpose (when available).  
  ```
  Tasks in build file `build.py`:

    clean                  	Clean build directory.
    copy_file              	
    echo                   	
    html                   	Generate HTML.
    images        [Ignored]	Prepare images.
    start_server  [Default]	Start the server
    stop_server            	

  Powered by Leverage 1.9.0
  ```
* `-v` | `--verbose`: Increases output verbosity.  
  When running a command in a container, the tool provides a description of the container's configuration before the execution.  
  This is specially useful if the user were to to have the need of recreating Leverage's behavior by themselves.  
  ``` bash
  $ leverage -v tf plan
  [18:23:22.222] DEBUG    Found config file /home/user/binbash/le-tf-infra-aws/build.env
  [18:23:22.239] DEBUG    Container configuration:
                          {
                            "image": "binbash/leverage-toolbox:1.2.7-0.1.7", #(1)!
                            "command": "",
                            "stdin_open": true,
                            "environment": { #(2)!
                              "COMMON_CONFIG_FILE": "/binbash/config/common.tfvars",
                              "ACCOUNT_CONFIG_FILE": "/binbash/security/config/account.tfvars",
                              "BACKEND_CONFIG_FILE": "/binbash/security/config/backend.tfvars",
                              "AWS_SHARED_CREDENTIALS_FILE": "/root/tmp/bb/credentials",
                              "AWS_CONFIG_FILE": "/root/tmp/bb/config",
                              "SRC_AWS_SHARED_CREDENTIALS_FILE": "/root/tmp/bb/credentials",
                              "SRC_AWS_CONFIG_FILE": "/root/tmp/bb/config",
                              "AWS_CACHE_DIR": "/root/tmp/bb/cache",
                              "SSO_CACHE_DIR": "/root/tmp/bb/sso/cache",
                              "SSH_AUTH_SOCK": "/ssh-agent"
                            },
                            "entrypoint": "/bin/terraform",
                            "working_dir": "/binbash/security/global/base-identities",
                            "host_config": {
                              "NetworkMode": "default",
                              "SecurityOpt": [
                                "label:disable"
                              ],
                              "Mounts": [ #(3)!
                                {
                                  "Target": "/binbash",
                                  "Source": "/home/user/binbash/le-tf-infra-aws",
                                  "Type": "bind",
                                  "ReadOnly": false
                                },
                                {
                                  "Target": "/root/tmp/bb",
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
  [18:23:22.274] DEBUG    Checking for layer /home/user/binbash/le-tf-infra-aws/security/global/base-identities...
  [18:23:22.279] DEBUG    Checking layer /home/user/binbash/le-tf-infra-aws/security/global/base-identities...
  [18:23:22.282] DEBUG    Running command: sh -c 'cat $SSO_CACHE_DIR/token'
  [18:23:22.901] DEBUG    Running with entrypoint: /root/scripts/aws-sso/aws-sso-entrypoint.sh -- /bin/terraform
  [18:23:22.903] DEBUG    Running command: plan -var-file=/binbash/config/common.tfvars -var-file=/binbash/security/config/account.tfvars -var-file=/binbash/security/config/backend.tfvars #(4)!
  ...
  ```  

    1. :simple-docker: Docker image being used
    2. Environment variables available in the container
    3. Mapping of the host (`Source`) directories and files into the container (`Target`)
    4. Command being executed (useful when trying to replicate Leverage's behavior by yourself)
