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
<pre><code><span style="color:gray;">[09:30:54.027]</span> INFO     No <b>.leverage</b> directory found in user's home. Creating.
<span style="color:gray;">[09:30:54.030]</span> INFO     No project template found. Cloning template.
<span style="color:gray;">[09:30:54.978]</span> INFO     Finished cloning template.
<span style="color:gray;">[09:30:54.981]</span> INFO     Initializing git repository in project directory.
<span style="color:gray;">[09:30:54.990]</span> INFO     No project configuration file found. Creating an example config.
</code></pre>

!!! info "More information on [`project init`](../user-guide/base-workflow/leverage-cli/reference/project#init)"

Initializing a project creates the global configurations directory for Leverage CLI and downloads the templates used to generate the project's files structure. It then initializes a `git` repository in the working directory, and creates a file called `project.yaml`. Leverage projects are by design repositories to leverage some of the capabilities of `git` and because it is assumed that the code in the project will be versioned.

## Fill in the configuration file

Once the project is initialized you need to fill in the correct information for the project in the configuration file.

After filling in the data you will end up with a configuration file similar to the one below. Indicated by arrows are the fields that were modified.

You can see in the global values, the project name and a short version of it, in the `organization` section, the emails for each account, and further down, in the `accounts` section, the different groups and users for each group in the `management` and `security` accounts.  

!!! info "[:books: Email setup for a GSuite group using aliases](../user-guide/organization/organization-init/#email-setup-example)"

???+ note "`project.yaml` for *MyExample* project"
    ```yaml
    meta:
      enable_mfa: false

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
          private_subnets:
          - "172.18.0.0/23"
          - "172.18.2.0/23"
          public_subnets:
          - "172.18.6.0/23"
          - "172.18.8.0/23"
    ```
## Set Up the bootstrap credentials
To be able to interact with your AWS environment you first need to configure the credentials to enable AWS CLI to do so. Provide the keys obtained in the previous [account creation step](../aws-account-setup/) to the command by any of the available means.

=== "Manually"
    ``` bash
    leverage credentials create
    ```
    <pre><code><span style="color:grey;">[09:37:17.530]</span> INFO     Loading configuration file.
    <span style="color:grey;">[09:37:18.477]</span> INFO     Configuring default profile information.
    <span style="color:grey;">[09:37:20.424]</span> INFO     <b>Default profile configured in:</b> <span style="color:mediumseagreen;">/home/user/.aws/me/config</span>
    <span style="color:grey;">[09:37:20.426]</span> INFO     Configuring <b>bootstrap</b> credentials.
    <span style="color:mediumseagreen;">\></span> <b>Select the means by which you'll provide the programmatic keys: <span style="color:cornflowerblue;">Manually</span></b>
    <span style="color:mediumseagreen;">\></span> <b>Key: <span style="color:cornflowerblue;">AKIAU1OF18IXH2EXAMPLE</span></b>
    <span style="color:mediumseagreen;">\></span> <b>Secret: <span style="color:cornflowerblue;">\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*</span></b>
    <span style="color:grey;">[09:37:51.638]</span> INFO     <b>Bootstrap credentials configured in:</b> <span style="color:mediumseagreen;">/home/user/.aws/me/credentials</span>
    <span style="color:grey;">[09:37:53.497]</span> INFO     Fetching management account id.
    <span style="color:grey;">[09:37:55.344]</span> INFO     Updating project configuration file.
    <span style="color:grey;">[09:37:55.351]</span> INFO     Finished setting up <b>bootstrap</b> credentials.
    </code></pre>

=== "File selection"
    ``` bash
    leverage credentials create
    ```
    <pre><code><span style="color:grey;">[09:37:17.530]</span> INFO     Loading configuration file.
    <span style="color:grey;">[09:37:18.477]</span> INFO     Configuring default profile information.
    <span style="color:grey;">[09:37:20.424]</span> INFO     <b>Default profile configured in:</b> <span style="color:mediumseagreen;">/home/user/.aws/me/config</span>
    <span style="color:grey;">[09:37:20.426]</span> INFO     Configuring <b>bootstrap</b> credentials.
    <span style="color:mediumseagreen;">\></span> <b>Select the means by which you'll provide the programmatic keys: <span style="color:cornflowerblue;">Path to an access keys file obtained from AWS</span></b>
    <span style="color:mediumseagreen;">\></span> <b>Path to access keys file: <span style="color:cornflowerblue;">../bootstrap_accessKeys.csv</span></b>
    <span style="color:grey;">[09:37:51.638]</span> INFO     <b>Bootstrap credentials configured in:</b> <span style="color:mediumseagreen;">/home/user/.aws/me/credentials</span>
    <span style="color:grey;">[09:37:53.497]</span> INFO     Fetching management account id.
    <span style="color:grey;">[09:37:55.344]</span> INFO     Updating project configuration file.
    <span style="color:grey;">[09:37:55.351]</span> INFO     Finished setting up <b>bootstrap</b> credentials.
    </code></pre>

=== "Provide file in command"
    ``` bash
    leverage credentials create --file ../bootstrap_accessKeys.csv
    ```
    <pre><code><span style="color:grey;">[09:37:17.530]</span> INFO     Loading configuration file.
    <span style="color:grey;">[09:37:18.477]</span> INFO     Configuring default profile information.
    <span style="color:grey;">[09:37:20.424]</span> INFO     <b>Default profile configured in:</b> <span style="color:mediumseagreen;">/home/user/.aws/me/config</span>
    <span style="color:grey;">[09:37:20.426]</span> INFO     Configuring <b>bootstrap</b> credentials.
    <span style="color:grey;">[09:37:51.638]</span> INFO     <b>Bootstrap credentials configured in:</b> <span style="color:mediumseagreen;">/home/user/.aws/me/credentials</span>
    <span style="color:grey;">[09:37:53.497]</span> INFO     Fetching management account id.
    <span style="color:grey;">[09:37:55.344]</span> INFO     Updating project configuration file.
    <span style="color:grey;">[09:37:55.351]</span> INFO     Finished setting up <b>bootstrap</b> credentials.
    </code></pre>

!!! info "More information on [`credentials create`](../user-guide/base-workflow/leverage-cli/reference/credentials#create)"

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
<pre><code><span style="color:grey;">[09:40:54.934]</span> INFO     Loading configuration file.
<span style="color:grey;">[09:40:54.950]</span> INFO     Creating project directory structure.
<span style="color:grey;">[09:40:54.957]</span> INFO     Finished creating directory structure.
<span style="color:grey;">[09:40:54.958]</span> INFO     Setting up common base files.
<span style="color:grey;">[09:40:54.964]</span> INFO     Account: Setting up <b>management</b>.
<span style="color:grey;">[09:40:54.965]</span> INFO             Layer: Setting up <b>config</b>.
<span style="color:grey;">[09:40:54.968]</span> INFO             Layer: Setting up <b>base-tf-backend</b>.
<span style="color:grey;">[09:40:54.969]</span> INFO             Layer: Setting up <b>base-identities</b>.
<span style="color:grey;">[09:40:54.984]</span> INFO             Layer: Setting up <b>organizations</b>.
<span style="color:grey;">[09:40:54.989]</span> INFO             Layer: Setting up <b>security-base</b>.
<span style="color:grey;">[09:40:54.990]</span> INFO     Account: Setting up <b>security</b>.
<span style="color:grey;">[09:40:54.991]</span> INFO             Layer: Setting up <b>config</b>.
<span style="color:grey;">[09:40:54.994]</span> INFO             Layer: Setting up <b>base-tf-backend</b>.
<span style="color:grey;">[09:40:54.995]</span> INFO             Layer: Setting up <b>base-identities</b>.
<span style="color:grey;">[09:40:55.001]</span> INFO             Layer: Setting up <b>security-base</b>.
<span style="color:grey;">[09:40:55.002]</span> INFO     Account: Setting up <b>shared</b>.
<span style="color:grey;">[09:40:55.003]</span> INFO             Layer: Setting up <b>config</b>.
<span style="color:grey;">[09:40:55.006]</span> INFO             Layer: Setting up <b>base-tf-backend</b>.
<span style="color:grey;">[09:40:55.007]</span> INFO             Layer: Setting up <b>base-identities</b>.
<span style="color:grey;">[09:40:55.008]</span> INFO             Layer: Setting up <b>security-base</b>.
<span style="color:grey;">[09:40:55.009]</span> INFO             Layer: Setting up <b>base-network</b>.
<span style="color:grey;">[09:40:55.013]</span> INFO     Project configuration finished.
               INFO     Reformatting terraform configuration to the standard style.
<span style="color:grey;">[09:40:55.743]</span> INFO     Finished setting up project.
</code></pre>

!!! info "More information on [`project create`](../user-guide/base-workflow/leverage-cli/reference/project#create)"

In this step, the directory structure for the project and all definition files are created using the information from the `project.yaml` file and checked for correct formatting.

You will end up with something that looks like this:

???+ note "*MyExample* project file structure"
    <pre><code>📂 <b>myexample</b>
    ├── 📄 build.env
    ├── 📂 <b>config</b>
    │   └── 📄 common.tfvars
    ├── 📂 <b>management</b>
    │   ├── 📂 <b>base-identities</b>
    │   │   ├── 📄 account.tf
    │   │   ├── 📄 config.tf
    │   │   ├── 📄 groups.tf
    │   │   ├── 📄 keys
    │   │   ├── 📄 locals.tf
    │   │   ├── 📄 outputs.tf
    │   │   ├── 📄 roles.tf
    │   │   ├── 📄 users.tf
    │   │   └── 📄 variables.tf
    │   ├── 📂 <b>base-tf-backend</b>
    │   │   ├── 📄 config.tf
    │   │   ├── 📄 locals.tf
    │   │   ├── 📄 main.tf
    │   │   └── 📄 variables.tf
    │   ├── 📂 <b>config</b>
    │   │   ├── 📄 account.tfvars
    │   │   └── 📄 backend.tfvars
    │   ├── 📂 <b>organizations</b>
    │   │   ├── 📄 accounts.tf
    │   │   ├── 📄 config.tf
    │   │   ├── 📄 delegated_administrator.tf
    │   │   ├── 📄 locals.tf
    │   │   ├── 📄 organizational_units.tf
    │   │   ├── 📄 organization.tf
    │   │   ├── 📄 policies_scp.tf
    │   │   ├── 📄 policy_scp_attachments.tf
    │   │   ├── 📄 service_linked_roles.tf
    │   │   └── 📄 variables.tf
    │   └── 📂 <b>security-base</b>
    │       ├── 📄 account.tf
    │       ├── 📄 config.tf
    │       └── 📄 variables.tf
    ├── 📄 project.yaml
    ├── 📂 <b>security</b>
    │   ├── 📂 <b>base-identities</b>
    │   │   ├── 📄 account.tf
    │   │   ├── 📄 config.tf
    │   │   ├── 📄 groups_policies.tf
    │   │   ├── 📄 groups.tf
    │   │   ├── 📄 keys
    │   │   ├── 📄 locals.tf
    │   │   ├── 📄 outputs.tf
    │   │   ├── 📄 role_policies.tf
    │   │   ├── 📄 roles.tf
    │   │   ├── 📄 users.tf
    │   │   └── 📄 variables.tf
    │   ├── 📂 <b>base-tf-backend</b>
    │   │   ├── 📄 config.tf
    │   │   ├── 📄 locals.tf
    │   │   ├── 📄 main.tf
    │   │   └── 📄 variables.tf
    │   ├── 📂 <b>config</b>
    │   │   ├── 📄 account.tfvars
    │   │   └── 📄 backend.tfvars
    │   └── 📂 <b>security-base</b>
    │       ├── 📄 account.tf
    │       ├── 📄 config.tf
    │       ├── 📄 iam_access_analizer.tf
    │       ├── 📄 locals.tf
    │       └── 📄 variables.tf
    └── 📂 <b>shared</b>
        ├── 📂 <b>base-identities</b>
        │   ├── 📄 account.tf
        │   ├── 📄 config.tf
        │   ├── 📄 locals.tf
        │   ├── 📄 policies.tf
        │   ├── 📄 roles.tf
        │   ├── 📄 service_linked_roles.tf
        │   └── 📄 variables.tf
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
        ├── 📂 <b>config</b>
        │   ├── 📄 account.tfvars
        │   └── 📄 backend.tfvars
        └── 📂 <b>security-base</b>
            ├── 📄 account.tf
            ├── 📄 config.tf
            └── 📄 variables.tf
    </pre></code>

As you can see, it is a structure comprised of directories for each account containing all the definitions for each of the accounts respective layers.

## Next steps
You have now created the definition of all the infrastructure for your project and configured the credentials need to deploy such infrastructure in the AWS environment.

Next, you will orchestrate de first and main account of the project, the management account.
