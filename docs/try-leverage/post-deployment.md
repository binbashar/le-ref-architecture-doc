# Post-deployment steps
At this point the landing zone should be ready.

The bootstrap user can now be deleted.

## Delete the bootstrap user

- Log into your `sso_start_url` address with your SSO user
- Select the `management` account and log into the `Management console`
- Go to IAM
- Delete the user `mgmt-org-admin`


## Next steps
Now you not only have a fully functional landing zone configuration deployed, but also are able to interact with it using your own AWS SSO credentials.

For more detailed information on the **binbash Leverage Landing Zone**, visit the links below.

- [X] :books: [How it works](/user-guide/ref-architecture-aws/overview/)
- [X] :books: [User guide](/user-guide/)
