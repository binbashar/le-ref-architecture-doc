# Installing Pritunl via Ansible

## Overview

Once you have provisioned the required infrastructure, you'll have to use Ansible to install and configure Pritunl and its dependencies.

## Run the Security & Users Ansible Playbook

Optionally, but recommended, you can use [the Ansible playbook](https://github.com/binbashar/le-ansible-infra/tree/master/sec-users) to centrally manage users and groups, and to perform basic hardening steps on the operating system.

Before you can use the Ansible playbook you need to configure the [.hosts](https://github.com/binbashar/le-ansible-infra/blob/master/sec-users/.hosts.example) and [ansible.cfg](https://github.com/binbashar/le-ansible-infra/blob/master/sec-users/ansible.cfg.example) files. Then, use the SSH key generated in the `security-keys` layer of the Shared account (ssh.tf), referenced as infra-key in the
EC2 instance that was deployed as explained in previous pages of this guide.

## Run the Pritunl VPN Ansible Playbook

This Ansible repo will be used here: **[>> Pritunl VPN Server Playbook <<](https://github.com/binbashar/le-ansible-infra/tree/master/vpn-pritunl)**

Copy the playbooks into your project repository. (e.g. you can create an `ansible` directory inside your [**binbash Leverage**](https://leverage.binbash.co/) project repository, so all your infrastructure code is in the same place)

`cd` into the `ansible-pritunl-vpn-server` (or the name you've chosen) directory.

Follow the steps in the repository [**README.md**](https://github.com/binbashar/le-ansible-infra/blob/master/vpn-pritunl/README.md) file to install the server.

!!! warning "Handling Installation Errors" 
    During the installation, you may encounter two errors related to displaying the default generated username and
    password. These can be ignored at this stage; you'll remove them via the command line after the first iteration. 

!!! info "Important"
    This is a **private repository**, please get in touch with us to get access to it!
    
    - [https://www.binbash.co/es/contact](https://www.binbash.co/es/contact){:target="_blank"}
    - [leverage@binbash.co](mailto:leverage@binbash.co)
