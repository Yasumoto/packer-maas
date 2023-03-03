#!/bin/sh

set -eux

export DEBIAN_FRONTEND=noninteractive

sudo apt-get -y install ansible
cd $rSW_DIR/ops
ansible-playbook -i dev.inv -l my_computer provision.yml --ask-become-pass
