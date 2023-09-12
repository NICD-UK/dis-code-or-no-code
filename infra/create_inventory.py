import json
import subprocess


def get_terraform_output():
    return json.loads(subprocess.check_output(['terraform', 'output', '-json']))

def create_inventory(terraform_output):
    
    host = terraform_output['instance_ip']['value']
    name = terraform_output['instance_name']['value']
    email = terraform_output['email']['value']

    with open("inventory.ini", 'w') as inv:
        inv.write("[vms]\n")
        inv.write(f'{host} hostname={name}.nicd.app\n\n')
        inv.write('[vms:vars]\n')
        inv.write(f'email={email}')

if __name__ == '__main__':
    create_inventory(get_terraform_output())
