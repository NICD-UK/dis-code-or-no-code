## Reset filesystem so you can upload a new zip

WARNING: This will delete all user files

On the vm:

```
sudo userdel -r jupyter-*
```

```
sudo rm /etc/skel/*
```

Then on your machine rerun the ansible playbook


## Add a new file to everyone work space

Add it to the zip and rerun the ansible playbook

then run 

```
for user_dir in /home/jupyter-*; do
    # Extract the username from the directory path
    user=$(basename "$user_dir")

    # Copy the file to the user's home directory
    sudo cp /etc/skel/trip_data_dictionary.pdf "$user_dir/"

    # Change the ownership of the copied file to the user
    sudo chown "$user":"$user" "$user_dir/trip_data_dictionary.pdf"
done
```

scp files to the server

scp <file> adminuser@51.142.122.23:~/

for user_dir in /home/jupyter-*; do
    # Extract the username from the directory path
    user=$(basename "$user_dir")

    # Copy the file to the user's home directory
    sudo cp ~/README.md "$user_dir/"

    # Change the ownership of the copied file to the user
    sudo chown "$user":"$user" "$user_dir/trip_data_dictionary.pdf"
done


