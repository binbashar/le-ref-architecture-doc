# Tech Specifications 

??? important ":checkered_flag: **As Code:** Hundred of thousands lines of code"
    Written in:
    
    - [x] Terraform
    - [x] Groovy (Jenkinsfiles)
    - [x] Ansible
    - [x] Makefiles + Bash 
    - [x] Dockerfiles
    - [x] Helm Charts
        
??? important ":checkered_flag: **Stop reinventing the wheel, automated and fully as code**"
    - :fast_forward: automated (executable from a single source).
    - :fast_forward: as code.
    - :fast_forward: parameterized
        - variables
        - input parameters
        - return / output parameters
    - :fast_forward: _"Stop reinventing the wheel"_
        - avoid re-building the same things more than X times.
        - avoid wasting time.
        - not healthy, not secure and slows us down.

??? important ":checkered_flag: **DoD of a highly reusable, configurable, and composible sub-modules**"      
    Which will be 100%

    - :fast_forward: modular 
        - equivalent to other programming languages functions - Example for terraform -
         [https://www.terraform.io/docs/modules/usage.html](https://www.terraform.io/docs/modules/usage.html) (but can be propagated for other languages and tools):
            1. **inputs, outputs parameters.**
            2. **code reuse (reusable):** consider tf modules and sub-modules approach.
            3. **testable** by module / function.
                1. Since TF is oriented to work through 3rd party API calls, then tests are more likely to be
                 `integration tests` rather than `unit tests`. If we don't allow integration for terraform then we
                  can't work at all.
                    1. This has to be analyzed for every language we'll be using and how we implement it (terraform,
                     cloudformation, ansible, python, bash, docker, kops and k8s kubeclt cmds)
            4. **composition** (composable): have multiple functions and use them together
                2. **eg:** `def_add(x,y){return x+y} ; def_sub(x,y){return x-y}; sub(add(3,4), add(7,5))`
            5. **abstraction** (abstract away complexity): we have a very complex function but we only expose it's
             definition to the API, **eg:** `def_ai_processing(data_set){very complex algorithm here};
              ai_processing([our_data_set_here])`
            6. **avoid inline blocks:** The configuration for some Terraform resources can be defined either as
             inline blocks or as separate resources. For example, the [aws_route_table](https://www.terraform.io/docs/providers/aws/r/route_table.html) 
              resource allows you to define routes via inline blocks. But by doing so, your module become less 
              flexible and configurable. Also, if a mix of both, inline blocks _and_ separate resources, is used,
               errors may arise in which they conflict and overwrite each other. Therefore, you must use one or
                the other (ref: [https://blog.gruntwork.io/how-to-create-reusable-infrastructure-with-terraform-modules-25526d65f73d](https://blog.gruntwork.io/how-to-create-reusable-infrastructure-with-terraform-modules-25526d65f73d))
                <br />As a rule of thumb, when creating a module, separate resources should always be used.
            7. **use module-relative paths: **The catch is that the used file path has to be relative
             (since you could run Terraform on many different computers) — but relative to what? By default,
              Terraform interprets the path as relative to the working directory. That’s a good default for normal
               Terraform templates, but it won’t work if the file is part of a module. 
               <br />To solve this issue, always use a [path variable](https://www.terraform.io/docs/configuration/interpolation.html#path-information)
                in file paths.
                eg: 
                ```
                resource "aws_instance" "example" {
                  ami = "ami-2d39803a"
                  instance_type = "t2.micro"
                  user_data = "${file("${path.module}/user-data.sh")}"
                }
                ```

??? important ":checkered_flag: **Solutions must be versioned**"        
    So as to be able to manage them as a software product with releases and change log. 
    This way we'll be able to know which version is currently deployed in a given client and consider upgrading it.
  

??? important ":checkered_flag: **Env Parity**"      
    Promote immutable, versioned infra modules based across envs. 
     

??? important ":checkered_flag: **Updated**"      
    Continuously perform updates, additions, and fixes to libraries and modules. 

??? important ":checkered_flag: **Orchestrated in automation**"         
    We use the [leverage-cli](../leverage-cli/index.md) for this purpose 
        
??? important ":checkered_flag: **Proven & Tested**"      
    Customers & every commit goes through a suite of automated tests to grant code styling and functional testing.

    *   [x] Develop a wrapper/jobs together with specific testing tools in order to grant the modules are working as expected.
    *   [x] Ansible: 
        *   [Testing your ansible roles w/ molecule](https://www.jeffgeerling.com/blog/2018/testing-your-ansible-roles-molecule)
        *   [How to test ansible roles with molecule on ubuntu](https://www.digitalocean.com/community/tutorials/how-to-test-ansible-roles-with-molecule-on-ubuntu-16-04)
    *   [x] Terraform:
        *   [gruntwork-io/terratest](https://github.com/gruntwork-io/terratest)
    
??? important ":checkered_flag: **Cost savings by design**"      
    The architecture for our Library / Code Modules helps an organization to analyze its current IT and DevSecOps
    Cloud strategy and identify areas where changes could lead to cost savings. <br />For instance, the architecture may show
    that multiple database systems could be changed so only one product is used, reducing software and support costs.
    Provides a basis for reuse. <br />The process of architecting can support both the use and creation of reusable assets.
    Reusable assets are beneficial for an organization, since they can reduce the overall cost of a system and also
    improve its quality, since a reusable asset has already been proven.
    
??? important ":checkered_flag: **Full Code Access & No Lock-In**"      
    You get access to 100% of the code under Open Source license ([https://choosealicense.com/](https://choosealicense.com/)) 
      so If you ever choose to cancel, you keep rights to all the code.
     
??? important ":checkered_flag: **Documented**"       
    Includes code examples, use cases and thorough documentation, such as README.md, 
    --help command, doc-string and in line comments.
     
??? important ":checkered_flag: **Supported  & Customizable**"      
     Commercially maintained and supported by [**_Binbash_**](../../work-with-us/support.md).
