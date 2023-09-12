from create_inventory import get_terraform_output, create_inventory
import os
import subprocess

terraform_output = get_terraform_output()
username = terraform_output['username']['value']

create_inventory(terraform_output)

os.environ['ANSIBLE_HOST_KEY_CHECKING'] = 'False'
subprocess.call(['ansible-playbook', '-i', 'inventory.ini', '-u', username, 'playbook.yaml'])