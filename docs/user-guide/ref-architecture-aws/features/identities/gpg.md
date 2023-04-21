# GPG Keys

## Why do we use GPG keys?
By default our [Leverage Reference Architectre base-identities layer](https://github.com/binbashar/le-tf-infra-aws/blob/master/security/global/base-identities/users.tf) 
approach is to use [IAM module](https://github.com/binbashar/terraform-aws-iam/tree/master/modules/iam-user) 
to manage AWS IAM Users credentials with **encryption to grant strong security**. 

This **module** outputs commands and GPG messages which can be decrypted either using command line to get AWS Web Console
user's password and user's secret key.   

!!! warning "Notes for keybase users"
    If possible, always use GPG encryption to prevent Terraform from keeping unencrypted password and access secret key 
    in state file.

!!! check "Keybase pre-requisites"
    When `gpg_key` is specified as `keybase:username`, make sure that the user public key has already been uploaded to 
    the [Reference Architecture base-identities layer `keys` folder](https://github.com/binbashar/le-tf-infra-aws/tree/master/security/global/base-identities/keys) 

## Managing your GPG keys
!!! info "Create a key pair"
    - NOTE: the user for whom this account is being created needs to do this
    - Install `gpg`
    - Run `gpg --version` to confirm
    - Run `gpg --gen-key` and provide "Your Name" and "Your Email" as instructed -- you must also provide a passphrase
    - Run `gpg --list-keys` to check that your key was generated

!!! info "Delete a key pair"
    - Run `gpg --list-keys` to check your key id
    - Run `gpg --delete-secret-keys "Your Name"` to delete your private gpg key
    - Run `gpg --delete-key "Your Name"` to delete your public gpg key

!!! info "Export your public key"
    - NOTE: the user must have created a key pair before doing this
    - Run `gpg --export "Your Name" | base64`
    - Now the user can share her/his public key for creating her/his account

!!! info "Decrypt your encrypted password"
    1. The user should copy the encrypted password from whatever media it was provided to her/him
    2. Run `echo "YOUR ENCRYPTED STRING PASSWORD HERE" | base64 --decode > a_file_with_your_pass`
    ```bash
    $ echo "wcBMA/ujy1wF7UPcAQgASLL/x8zz7OHIP+EHU7IAZfa1A9qD9ScP5orK1M473WlXVgPrded0iHpyZRwsJRS8Xe38AHZ65O6CnywdR522MbD\
    RD6Yz+Bfc9NwO316bfSoTpyROXvMi+cfMEcihInHaCIP9YWBaI3eJ6VFdn90g9of00HYehBux7E2VitMuWo+v46W1p8/pw0b0H5qcppnUYYOjjSbjzzAuMF\
    yNB5M1K8av61bPQPQTxBH3SFaM0B4RNmUl1bHKDIcdESYyIP/PRLQ45Rs5MzGgALIxBy24qdPNjHJQR48/5QV4nzB9qeEe4eWDB4ynSEfLsXggiz8fsbajV\
    gSLNsdpqP9lYaueFdLgAeR6a+EjvqZfq0hZAgoiymsb4Qtn4A7gmeGmNeDE4td1mVfgzuTZ9zhnSbAYlXNIiM4b0MeX4HrjFkT/Aq+A/rvgBeKhszWD4Ibh\
    A4PgC+QPiJRb5kQ/mX8DheQfAHJ24iUZk1jh6AsA" | base64 --decode > encrypted_pass
    ```
    3. Run `gpg --decrypt a_file_with_your_pass` (in the path you've executed 2.) to effectively decrypt your pass using
     your gpg key and its passphrase
    ```bash
    $ gpg --decrypt encrypted_pass
    
    You need a passphrase to unlock the secret key for
    user: "Demo User (AWS org project-user acct gpg key w/ passphrase) <username.lastname@domain.com>"
    2048-bit RSA key, ID 05ED43DC, created 2019-03-15 (main key ID D64DD59F)
    
    gpg: encrypted with 2048-bit RSA key, ID 05ED43DC, created 2019-03-15
          "Demo User (AWS org project-user acct gpg key w/ passphrase) <username.lastname@domain.com>"
    Vi0JA|c%fP*FhL}CE-D7ssp_TVGlf#%
    ```
    :warning: Depending on your shell version an extra `%` character could appear as shown below, you must disregard this
    character since it's not part of the Initial (one time) AWS Web Console password. 
    4. If all went well, the decrypted password should be there

## Workaround for Mac users
There are some situations where gpg keys generated on Mac don't work properly, generating errors like the following:

```bash
╷
│ Error: error encrypting password during IAM User Login Profile (user.lastname) creation: Error encrypting Password: error parsing given PGP key: openpgp: unsupported feature: unsupported oid: 2b060104019755010501
│ 
│   with module.user["user.lastname"].aws_iam_user_login_profile.this[0],
│   on .terraform/modules/user/modules/iam-user/main.tf line 12, in resource "aws_iam_user_login_profile" "this":
│   12: resource "aws_iam_user_login_profile" "this" {
│
```

!!! info ":whale: Docker is required for this workaround."
    If you don't have docker on your PC, don't worry. You can easily install it following the steps on the [official page](https://docs.docker.com/desktop/mac/install/).

In these cases, execute the following steps:

1. Run an interactive console into an ubuntu container mounting your gpg directory.
```bash
docker run --rm -it --mount type=bind,src=/Users/username/.gnupg,dst=/root/.gnupg ubuntu:latest
```

2. Inside the container, install required packages.
```bash
apt update
apt install gnupg
```

2. Generate the key as described in previous sections, running `gpg --gen-key` at the interactive console in the ubuntu container.

3. To fix permissions in your gpg directory, run these commands at the interactive console in the ubuntu container.
```bash
find ~/.gnupg -type f -exec chmod 600 {} \;
find ~/.gnupg -type d -exec chmod 700 {} \;
```

4. Now you should be able to export the gpg key and decode the password from your mac, running `gpg --export "Your Name" | base64`.

5. Finally, decrypt the password in your mac, executing:
```bash
echo "YOUR ENCRYPTED STRING PASSWORD HERE" | base64 --decode > a_file_with_your_pass
gpg --decrypt a_file_with_your_pass
```
