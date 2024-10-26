## Provision Pritunl EC2 with Ansible

### Run Ansible Playbooks

!!! info "Pre-requisites"
    It seems to be obvious but... you need Ansible installed.

#### Security & Users Ansible Playbook

Optionally (but recommended) utilize the Ansible playbook for initial basic hardening and local user configuration:
https://github.com/binbashar/le-ansible-infra/tree/master/sec-users
To use the Ansible playbook and prepare the `.hosts` and `ansible.cfg` files in an initial configuration, 
use the SSH key generated in the `security-keys` layer of the Shared account (ssh.tf), referenced as infra-key in the
EC2 instance that was deployed as explained at "SSH CONNECTION" section before.
    
#### Pritunl VPN Ansible Playbook

This Ansible repo will be used here: **[>> Pritunl VPN Server Playbook <<](https://github.com/binbashar/le-ansible-infra/tree/master/vpn-pritunl)**

Copy the playbooks into your project repository. (e.g. you can create an `ansible` directory inside your [**binbash Leverage**](https://leverage.binbash.co/) project repository, so all your infraesctructure code is in the same place)

`cd` into the `ansible-pritunl-vpn-server` (or the name you've chosen) directory.

Follow the steps in the repository [**README.md**](https://github.com/binbashar/le-ansible-infra/blob/master/vpn-pritunl/README.md) file to install the server.

!!! warning "Handling Installation Errors" 
    During the installation, you may encounter two errors related to displaying the default generated username and
    password. These can be ignored at this stage; you'll remove them via the command line after the first iteration. 

!!! warning "IMPORTANT CONSIDERATION: Ubuntu LTS 22.04 SUPPORT "
    We recommend using the Ubuntu LTS 22.04 version, as 20.04 has limited support remaining. 
    Please consider updating the MongoDB version as well. We have an open issue in the Ansible Ref Arch to address this [issue link](https://github.com/binbashar/le-ansible-infra/issues/74).
---
!!! note
    This is a **private repository**, please get in touch with us to get access to it!<br />
    
    - [https://www.binbash.co/es/contact](https://www.binbash.co/es/contact){:target="_blank"}
    - [leverage@binbash.co](mailto:leverage@binbash.co)