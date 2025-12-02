# Ansible Known Issues 

## Issues with SSH Keys in `leverage run apply`

When using `leverage run apply`, **Ansible** relies on **SSH keys** for authenticating connections to **EC2 instances**. The command runs Ansible inside a **container**, which can lead to specific issues related to how SSH keys are accessed.

### Key Management and Container Mounting

During the execution of `leverage run apply`, a temporary container is created. The key directory **`~/.ssh/bb`** from your host machine is **mounted** into this container to make your keys available for Ansible.

Two common problems arise when the expected key isn't accessible within the container:

#### 1\. Key Location Mismatch

If you store your project-specific SSH keys in a directory **other than `~/.ssh/bb`** (e.g., a project folder), the keys will **not** be available inside the container because only the `~/.ssh/bb` directory is mounted.

!!! idea "Solution"
      **Copy** the necessary key(s) into the `~/.ssh/bb` directory **before** running the command.


For example, you could copy the key to `~/.ssh/bb/me/aws-instance-ssh-key`.
Then, update your **inventory file** (e.g., `.host`) to reference this new path, ensuring it points to the location **inside the mounted directory**:

```yaml
[infra] vpn-pritunl ansible_host='vpn.aws.domain.com' ansible_user='ubuntu' ansible_ssh_private_key_file='~/.ssh/bb/me/aws-instance-ssh-key' ansible_python_interpreter='/usr/bin/python3'
```

#### 2\. Keys Protected by a Passphrase

Some users create SSH keys with a **passphrase** and then use the **ssh-agent** on their host machine to manage and unlock the key for their shell session.

When `leverage run apply` executes, the **ssh-agent connection** is **not** mounted or forwarded into the container. Consequently, the key remains **locked** inside the container, and Ansible cannot use it.

!!! idea "Solution"
      For SSH keys intended for use with **EC2 instances** via `leverage run apply`, it is recommended to use keys that **do not have a passphrase**.

-----
