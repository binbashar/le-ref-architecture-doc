![binbash-logo](../assets/images/logos/binbash.png "Binbash"){: style="width:250px"}
![binbash-leverage-tf](../assets/images/logos/binbash-leverage-terraform.png#right "Leverage"){: style="width:130px"}

# Introduction

The objective of this guide is to introduce the user to our
[**Binbash Leverage Reference Architecture for AWS**](../../how-it-works/) workflow 
through the complete deployment of a basic landing zone configuration.

The Leverage landing zone is the smallest possible fully functional configuration. 
It lays out the base infrastructure required to manage the environment: billing and
financial management, user management, security enforcement, and shared services and
resources. Always following the best practices layed out by the
[AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html) 
to ensure quality and to provide a solid base to build upon. This is the starting point from which
any Leverage user can and will develop all the features and capabilities they may require to satisfy
their specific needs.

</br>
![leverage-landing-zone](../assets/images/diagrams/leverage-landing-zone.png "Leverage Landing Zone"){: style="width: 650px"}
<figcaption style="font-size:15px">
<b>Figure:</b> Leverage Landing Zone configuration diagram.
</figcaption>

On this guide you will learn how to:

- [X] Create and configure your AWS account.
- [X] Work with the Leverage CLI to manage your credentials, infrastructure and the whole Leverage stack.
- [X] Prepare your local environment to manage a Leverage project.
- [X] Orchestrate the project's infrastructure.
- [X] Configure your users' credentials to interact with the project.

Upon completion of this guide you will gain an understanding of the structure of a project as well as familiarity with the tooling used to manage it.

To begin your journey into creating your first Leverage project, continue to the next section of the guide where you will start by setting up your AWS account.
