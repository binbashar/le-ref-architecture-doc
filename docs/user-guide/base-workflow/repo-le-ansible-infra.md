# Workflow

### Makefile
- We rely on `Makefiles` as a wrapper to run terraform commands that consistently use the same config files.
- You are encouraged to inspect those Makefiles to understand what's going on.

### Ansible
1. Get into the folder that you need to work with (e.g. `ansible-playbook-vpn-pritunl`)
2. Run `make init` to get all the necessary Ansible roles based on each `requirements.yml`
3. Run `init-ansible-py` (if necessary)
4. Make whatever changes you need to make as stated in each Playbook Documentation (check Documentation section above)
5. Run `make check` if you only mean to preview those changes
6. Run `make apply` if you want to apply those changes