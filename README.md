An example Packer repository for provisioning with Ansible

### Getting started:

#### Editing how the agent's image is provisioned

Add playbooks/roles to the ansible directory.

Add values to your encrypted vault files in ansible/vault - specify your platform teams vault password

### Vault password
This sample repository uses the following:

```
VAULT_PASSWORD=1234

For local execution ensure the following environment variable is set

export VAULT_PASSWORD=1234
```

The vault files are for example purposes only, please include your own encrypted files and set your platform specific password/s.

TBC...
