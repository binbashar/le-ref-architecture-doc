# Set Up your Leverage project

Up until now we have been taking care of all the prerequisites for a Leverage project, but is time to actually create the Reference Architecture definition for your project. Let's get to it.

## Create the project directory
Each Leverage project must be in its own working directory.

Create the directory for your project.

``` bash
mkdir myexample
cd myexample
```

## Initialize the Leverage project
When setting up a Leverage project the directory where it will reside needs to be initialized

``` bash
leverage project init
```
<pre><code><span class="fsg-timestamp">[09:30:54.027]</span> INFO     No <b>Leverage</b> directory found in user's home. Creating.
<span class="fsg-timestamp">[09:30:54.030]</span> INFO     No project template found. Cloning template.
<span class="fsg-timestamp">[09:30:54.978]</span> INFO     Finished cloning template.
<span class="fsg-timestamp">[09:30:54.981]</span> INFO     Initializing git repository in project directory.
<span class="fsg-timestamp">[09:30:54.990]</span> INFO     No project configuration file found. Dropping configuration template <b>project.yaml</b>.
<span class="fsg-timestamp">[09:30:55.007]</span> INFO     Project initialization finished.
</code></pre>

!!! info "More information on [`project init`](../../user-guide/base-workflow/leverage-cli/reference/project#init)"

Initializing a project creates the global configurations directory for Leverage CLI and downloads the templates used to generate the project's files structure. It then initializes a `git` repository in the working directory, and creates a file called `project.yaml`. Leverage projects are by design repositories to leverage some of the capabilities of `git` and because it is assumed that the code in the project will be versioned.

## Fill in the configuration file

Once the project is initialized you need to fill in the correct information for the project in the configuration file.

After filling in the data you will end up with a configuration file similar to the one below. Indicated by arrows are the fields that were modified.

You can see in the global values, the project name and a short version of it, in the `organization` section, the emails for each account, and further down, in the `accounts` section, the different groups and users for each group in the `management` and `security` accounts.  


???+ note "`project.yaml` for *MyExample* project"
    ```yaml
    project_name: myexample # <--
    short_name: me # <--

    primary_region: us-east-1
    secondary_region: us-west-2

    organization:
      accounts:
      - name: management
        email: myexample-aws@example.com # <--
      - name: security
        email: myexample-aws+security@example.com # <--
      - name: shared
        email: myexample-aws+shared@example.com # <--
      organizational_units:
      - name: security
        policy:
        - aws_organizations_policy.default
        accounts:
        - security
      - name: shared
        policy:
        - aws_organizations_policy.standard
        accounts:
        - shared

    accounts:
      management:
        groups:
        - name: admins # <--
          users:
          - kit.walker
          - natasha.romanoff
          policies:
          - '"arn:aws:iam::aws:policy/AdministratorAccess"'
      security:
        groups:
        - name: admins # <--
          users:
          - natasha.romanoff
        - name: auditors # <--
          users:
          - kit.walker
          policies:
          - aws_iam_policy.assume_auditor_role.arn
        - name: devops # <--
          users:
          - natasha.romanoff
          - edward.stark
          - john.wick
          policies:
          - aws_iam_policy.assume_devops_role.arn
      shared:
        networks:
        - cidr_block: "172.18.0.0/20"
          availability_zones: [a,b]
          private_subnets_cidr: "172.18.0.0/21"
          private_subnets:
          - "172.18.0.0/23"
          - "172.18.2.0/23"
          public_subnets_cidr: "172.18.8.0/21"
          public_subnets:
          - "172.18.8.0/23"
          - "172.18.10.0/23"
    ```
## Set Up the bootstrap credentials
To be able to interact with your AWS environment you first need to configure the credentials to enable AWS CLI to do so. Provide the keys obtained in the previous [account creation step](../aws-account-setup/) to the command by any of the available means.

=== "Manually"
    ``` bash
    leverage credentials configure --type BOOTSTRAP
    ```
    <pre><code><span class="fsg-timestamp">[09:37:17.530]</span> INFO     Loading configuration file.
    <span class="fsg-timestamp">[09:37:18.477]</span> INFO     Loading project environment configuration file.
    <span class="fsg-timestamp">[09:37:20.426]</span> INFO     Configuring <b>bootstrap</b> credentials.
    <span class="fsg-prompt">\></span> <b>Select the means by which you'll provide the programmatic keys: <span class="fsg-userinput">Manually</span></b>
    <span class="fsg-prompt">\></span> <b>Key: <span class="fsg-userinput">AKIAU1OF18IXH2EXAMPLE</span></b>
    <span class="fsg-prompt">\></span> <b>Secret: <span class="fsg-userinput">\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*</span></b>
    <span class="fsg-timestamp">[09:37:51.638]</span> INFO     <b>Bootstrap credentials configured in:</b> <span class="fsg-path">/home/user/.aws/me/credentials</span>
    <span class="fsg-timestamp">[09:37:53.497]</span> INFO     Fetching management account id.
    <span class="fsg-timestamp">[09:37:53.792]</span> INFO     Updating project configuration file.
    <span class="fsg-timestamp">[09:37:55.344]</span> INFO     Skipping assumable roles configuration.
    </code></pre>

=== "File selection"
    ``` bash
    leverage credentials configure --type BOOTSTRAP
    ```
    <pre><code><span class="fsg-timestamp">[09:37:17.530]</span> INFO     Loading configuration file.
    <span class="fsg-timestamp">[09:37:18.477]</span> INFO     Loading project environment configuration file.
    <span class="fsg-timestamp">[09:37:20.426]</span> INFO     Configuring <b>bootstrap</b> credentials.
    <span class="fsg-prompt">\></span> <b>Select the means by which you'll provide the programmatic keys: <span class="fsg-userinput">Path to an access keys file obtained from AWS</span></b>
    <span class="fsg-prompt">\></span> <b>Path to access keys file: <span class="fsg-userinput">../bootstrap_accessKeys.csv</span></b>
    <span class="fsg-timestamp">[09:37:51.638]</span> INFO     <b>Bootstrap credentials configured in:</b> <span class="fsg-path">/home/user/.aws/me/credentials</span>
    <span class="fsg-timestamp">[09:37:53.497]</span> INFO     Fetching management account id.
    <span class="fsg-timestamp">[09:37:53.792]</span> INFO     Updating project configuration file.
    <span class="fsg-timestamp">[09:37:55.344]</span> INFO     Skipping assumable roles configuration.
    </code></pre>

=== "Provide file in command"
    ``` bash
    leverage credentials configure --type BOOTSTRAP --credentials-file ../bootstrap_accessKeys.csv
    ```
    <pre><code><span class="fsg-timestamp">[09:37:17.530]</span> INFO     Loading configuration file.
    <span class="fsg-timestamp">[09:37:18.477]</span> INFO     Loading project environment configuration file.
    <span class="fsg-timestamp">[09:37:20.426]</span> INFO     Configuring <b>bootstrap</b> credentials.
    <span class="fsg-timestamp">[09:37:51.638]</span> INFO     <b>Bootstrap credentials configured in:</b> <span class="fsg-path">/home/user/.aws/me/credentials</span>
    <span class="fsg-timestamp">[09:37:53.497]</span> INFO     Fetching management account id.
    <span class="fsg-timestamp">[09:37:53.792]</span> INFO     Updating project configuration file.
    <span class="fsg-timestamp">[09:37:55.344]</span> INFO     Skipping assumable roles configuration.
    </code></pre>

!!! info "More information on [`credentials configure`](../../user-guide/base-workflow/leverage-cli/reference/credentials#configure)"

During the credentials setup, the AWS account id is filled in for us in the project configuration file.

``` yaml
...
organization:
  accounts:
    - name: management
      email: myexample-aws@example.com
      id: '000123456789'
...
```

## Create the configured project
Now you will finally create all the infrastructure definition in the project.

``` bash
leverage project create
```
<pre><code><span class="fsg-timestamp">[09:40:54.934]</span> INFO     Loading configuration file.
<span class="fsg-timestamp">[09:40:54.950]</span> INFO     Creating project directory structure.
<span class="fsg-timestamp">[09:40:54.957]</span> INFO     Finished creating directory structure.
<span class="fsg-timestamp">[09:40:54.958]</span> INFO     Setting up common base files.
<span class="fsg-timestamp">[09:40:54.964]</span> INFO     Account: Setting up <b>management</b>.
<span class="fsg-timestamp">[09:40:54.965]</span> INFO             Layer: Setting up <b>config</b>.
<span class="fsg-timestamp">[09:40:54.968]</span> INFO             Layer: Setting up <b>base-tf-backend</b>.
<span class="fsg-timestamp">[09:40:54.969]</span> INFO             Layer: Setting up <b>base-identities</b>.
<span class="fsg-timestamp">[09:40:54.984]</span> INFO             Layer: Setting up <b>organizations</b>.
<span class="fsg-timestamp">[09:40:54.989]</span> INFO             Layer: Setting up <b>security-base</b>.
<span class="fsg-timestamp">[09:40:54.990]</span> INFO     Account: Setting up <b>security</b>.
<span class="fsg-timestamp">[09:40:54.991]</span> INFO             Layer: Setting up <b>config</b>.
<span class="fsg-timestamp">[09:40:54.994]</span> INFO             Layer: Setting up <b>base-tf-backend</b>.
<span class="fsg-timestamp">[09:40:54.995]</span> INFO             Layer: Setting up <b>base-identities</b>.
<span class="fsg-timestamp">[09:40:55.001]</span> INFO             Layer: Setting up <b>security-base</b>.
<span class="fsg-timestamp">[09:40:55.002]</span> INFO     Account: Setting up <b>shared</b>.
<span class="fsg-timestamp">[09:40:55.003]</span> INFO             Layer: Setting up <b>config</b>.
<span class="fsg-timestamp">[09:40:55.006]</span> INFO             Layer: Setting up <b>base-tf-backend</b>.
<span class="fsg-timestamp">[09:40:55.007]</span> INFO             Layer: Setting up <b>base-identities</b>.
<span class="fsg-timestamp">[09:40:55.008]</span> INFO             Layer: Setting up <b>security-base</b>.
<span class="fsg-timestamp">[09:40:55.009]</span> INFO             Layer: Setting up <b>base-network</b>.
<span class="fsg-timestamp">[09:40:55.013]</span> INFO     Project configuration finished.
               INFO     Reformatting terraform configuration to the standard style.
<span class="fsg-timestamp">[09:40:55.743]</span> INFO     Finished setting up project.
</code></pre>

!!! info "More information on [`project create`](../../user-guide/base-workflow/leverage-cli/reference/project#create)"

In this step, the directory structure for the project and all definition files are created using the information from the `project.yaml` file and checked for correct formatting.

You will end up with something that looks like this:

???+ note "*MyExample* project file structure"
    <pre><code>📂 <b>myexample</b>
    ├── 📄 build.env
    ├── 📄 project.yaml
    ├── 📂 <b>config</b>
    │   └── 📄 common.tfvars
    ├── 📂 <b>management</b>
    │   ├── 📂 <b>config</b>
    │   │   ├── 📄 account.tfvars
    │   │   └── 📄 backend.tfvars
    |   ├── 📂 <b>global</b>
    |   │   ├── 📂 <b>organizations</b>
    |   │   │   ├── 📄 accounts.tf
    |   │   │   ├── 📄 config.tf
    |   │   │   ├── 📄 delegated_administrator.tf
    |   │   │   ├── 📄 locals.tf
    |   │   │   ├── 📄 organizational_units.tf
    |   │   │   ├── 📄 organization.tf
    |   │   │   ├── 📄 policies_scp.tf
    |   │   │   ├── 📄 policy_scp_attachments.tf
    |   │   │   ├── 📄 service_linked_roles.tf
    |   │   │   └── 📄 variables.tf
    |   │   └── 📂 <b>base-identities</b>
    |   │       ├── 📄 account.tf
    |   │       ├── 📄 config.tf
    |   │       ├── 📄 groups.tf
    |   │       ├── 📄 keys
    |   │       ├── 📄 locals.tf
    |   │       ├── 📄 outputs.tf
    |   │       ├── 📄 roles.tf
    |   │       ├── 📄 users.tf
    |   │       └── 📄 variables.tf
    |   └── 📂 <b>us-east-1</b>
    |       ├── 📂 <b>base-tf-backend</b>
    |       │   ├── 📄 config.tf
    |       │   ├── 📄 locals.tf
    |       │   ├── 📄 main.tf
    |       │   └── 📄 variables.tf
    |       └── 📂 <b>security-base</b>
    |           ├── 📄 account.tf
    |           ├── 📄 config.tf
    |           └── 📄 variables.tf
    ├── 📂 <b>security</b>
    │   ├── 📂 <b>config</b>
    │   │   ├── 📄 account.tfvars
    │   │   └── 📄 backend.tfvars
    │   ├── 📂 <b>global</b>
    |   |   └── 📂 <b>base-identities</b>
    |   │       ├── 📄 account.tf
    |   │       ├── 📄 config.tf
    |   │       ├── 📄 groups_policies.tf
    |   │       ├── 📄 groups.tf
    |   │       ├── 📄 keys
    |   │       ├── 📄 locals.tf
    |   │       ├── 📄 outputs.tf
    |   │       ├── 📄 role_policies.tf
    |   │       ├── 📄 roles.tf
    |   │       ├── 📄 users.tf
    |   │       └── 📄 variables.tf
    │   └── 📂 <b>us-east-1</b>
    |       ├── 📂 <b>base-tf-backend</b>
    |       │   ├── 📄 config.tf
    |       │   ├── 📄 locals.tf
    |       │   ├── 📄 main.tf
    |       │   └── 📄 variables.tf
    |       └── 📂 <b>security-base</b>
    |           ├── 📄 account.tf
    |           ├── 📄 config.tf
    |           ├── 📄 iam_access_analizer.tf
    |           ├── 📄 locals.tf
    │           └── 📄 variables.tf
    └── 📂 <b>shared</b>
        ├── 📂 <b>config</b>
        │   ├── 📄 account.tfvars
        │   └── 📄 backend.tfvars
        ├── 📂 <b>global</b>
        |   └── 📂 <b>base-identities</b>
        |       ├── 📄 account.tf
        |       ├── 📄 config.tf
        |       ├── 📄 locals.tf
        |       ├── 📄 policies.tf
        |       ├── 📄 roles.tf
        |       ├── 📄 service_linked_roles.tf
        |       └── 📄 variables.tf
        └── 📂 <b>us-east-1</b>
            ├── 📂 <b>base-network</b>
            │   ├── 📄 account.tf
            │   ├── 📄 config.tf
            │   ├── 📄 locals.tf
            │   ├── 📄 network.tf
            │   ├── 📄 network_vpc_flow_logs.tf
            │   ├── 📄 outputs.tf
            │   └── 📄 variables.tf
            ├── 📂 <b>base-tf-backend</b>
            │   ├── 📄 config.tf
            │   ├── 📄 locals.tf
            │   ├── 📄 main.tf
            │   └── 📄 variables.tf
            └── 📂 <b>security-base</b>
                ├── 📄 account.tf
                ├── 📄 config.tf
                └── 📄 variables.tf
    </pre></code>

As you can see, it is a structure comprised of directories for each account containing all the definitions for each of the accounts respective layers.

The layers themselves are also grouped based on the region in which they are deployed. The regions are configured through the `project.yaml` file. In the case of the Leverage landing zone, most layers are deployed in the primary region, so you can see the definition of these layers in a `us-east-1` directory, as per the example configuration.

Some layers are not bound to a region because their definition is mainly comprised of resources for services that are global in nature, like IAM or Organizations. These kind of layers are kept in a `global` directory.

## Next steps
You have now created the definition of all the infrastructure for your project and configured the credentials need to deploy such infrastructure in the AWS environment.

Next, you will orchestrate de first and main account of the project, the management account.
