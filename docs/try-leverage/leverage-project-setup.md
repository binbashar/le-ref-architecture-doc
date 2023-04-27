# Create a Leverage project
A Leverage project starts with a simple project definition file that you modify to suit your needs. That file is then used to render the initial directory layout which, at the end of this guide, will be your reference architecture. Follow the sections below to begin with that.

The account's name will be given by your project's name followed by `-management`, since Leverage uses a suffix naming system to differentiate between the multiple accounts of a project. For this guide we'll stick to calling the project `MyExample` and so, the account name will be `myexample-management`. 

Along the same line, we'll use the `example.com` domain for the email address used to register the account. Adding a `-aws` suffix to the project's name to indicate that this email address is related to the project's AWS account, we end up with a registration email that looks like `myexample-aws@example.com`.

!!! info "Email addresses for AWS accounts."
        Each AWS account requires having a unique email address associated to it. The Leverage Reference Architecture for AWS makes use of multiple accounts to better manage the infrastructure, as such, you will need different addresses for each one. Creating a new email account for each AWS is not a really viable solution to this problem, a better approach is to take advantage of mail services that support aliases. For information regarding how this works: [:books: Email setup for your AWS account.](/user-guide/ref-architecture-aws/features/organization/configuration/#pre-requisites)

## Create the project directory
Each Leverage project lives in its own working directory. Create a directory for your project as follows:
``` bash
mkdir myexample
cd myexample
```

## Initialize the project
Create the project definition file by running the following command:
``` bash
$ leverage project init
[18:53:24.407] INFO     Project template found. Updating.                                                                                              
[18:53:25.105] INFO     Finished updating template.                                                                                                    
[18:53:25.107] INFO     Initializing git repository in project directory.                                                                              
[18:53:25.139] INFO     No project configuration file found. Dropping configuration template project.yaml.                                             
[18:53:25.143] INFO     Project initialization finished.
```

The command above should create the project definition file (`project.yaml`) and should initialize a `git` repository in the current working directory. This is important because Leverage projects by-design rely on specific `git` conventions and also because it is assumed that you will want to keep your infrastructure code versioned.

## Modify the project definition file
Open the `project.yaml` file and fill in the required information.

!!! info "Typically the placeholder values between `<` and `>` symbols are the ones you would want to edit however you are welcome to adjust any other values to suit your needs."

For instance, the following is a snippet of the `project.yaml` file in which the values for `project_name` and `short_name` have been set to `example` and `ex` respectively:
```
project_name: example
short_name: ex
primary_region: us-east-1
secondary_region: us-west-2
...
```

Another example is below. Note that the `management`, `security`, and `shared` accounts have been updated with slightly different email addresses (actually `aws+security@example.com` and `aws+shared@example.com` are email aliases of `aws@example.com` which is a convenient trick in some cases):
```
...
organization:
  accounts:
  - name: management
    email: aws@example.com
  - name: security
    email: aws+security@example.com
  - name: shared
    email: aws+shared@example.com
...
```

Finally, here's another example snippet that shows how you can define users and assign them to groups:
```
...
users:
- first_name: Jane
  last_name: Doe
  email: jane.doe@example.com
  groups:
  - administrators
  - devops
- first_name: Foo
  last_name: Bar
  email: foo.bar@example.com
  groups:
  - devops
...
```

!!! info "The project definition file includes other entries but the ones shown above are the most frequently updated."

## Configure "bootstrap" credentials
To be able to interact with your AWS environment you first need to configure the credentials to enable AWS CLI to do so. Provide the keys obtained in the previous [account creation step](/try-leverage/aws-account-setup/) to the command by any of the available means.

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

!!! info "More information on [`credentials configure`](/user-guide/leverage-cli/reference/credentials/#configure)"

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

!!! info "More information on [`project create`](/user-guide/leverage-cli/reference/project#create)"

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
    |           ├── 📄 iam_access_analyzer.tf
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
