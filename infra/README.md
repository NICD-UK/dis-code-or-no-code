# Infrastructure for DIS to code or not to code workshop

This folder contains terraform and ansible code which creates a VM with a public IP, installs JupyterHub, and adds a DNS record on cloudflare. Most settings can be updated at the top of [`main.tf`](./main.tf). Cloudflare email address and API key should be included in a file called `secret.auto.tfvars` which is ignored by Git.

Dependencies for JupyterHub can be modified in [`playbook.yaml`](./playbook.yaml). If you want to upload data, it should exist in a zip file called `upload.zip`. If this file is not present then the final ansible task will fail.

## Create Azure resources and DNS record
> [!NOTE]
> [Make sure that you have the correct account selected in the Azure CLI](https://learn.microsoft.com/en-us/cli/azure/manage-azure-subscriptions-azure-cli)
```
az login
terraform init
terraform apply
```

## Install JupyterHub and upload data
```
python3 run_playbook.py
```

## Destroy Azure resources and DNS record
```
terraform destroy
```

## Requirements
> [!NOTE]
> The poetry dev dependencies include ansible

- Terraform
- Azure CLI
- Ansible