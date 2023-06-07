#!/bin/bash
sudo apt update -y
sudo ape upgrade -y

sudo apt install python3
python3 -m pip install -U ansible

TEMP="/tmp/wsl_ansible_setup.yml"
curl -o $TEMP https://raw.githubusercontent.com/Reggles44/bash_setup/main/setup.yml
ansible-playbook $TEMP --ask-become-pass
rm $TEMP

git config --global user.name "Reggles"
git config --global user.email "reginaldbeakes@gmail.com"
git config --global credential.helper store

