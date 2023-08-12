#!/bin/bash


# Remove git credential helper
echo "# ---------------------------------------------------------------------------------"
echo "#  post_ansible_provisioning.sh | Remove git credential helper"
echo "# ---------------------------------------------------------------------------------"

# Unset git credential helper configuration
git config --global --unset credential.helper

# remove git config directory
rm -r $HOME/.config/git


# Remove ansible requirements file & roles
echo "# ---------------------------------------------------------------------------------"
echo "#  post_ansible_provisioning.sh | Remove ansible requirements file & roles"
echo "# ---------------------------------------------------------------------------------"

# remove ansible requirements file
rm $HOME/requirements.yml

# Remove ansible roles
ansible-galaxy role remove RHEL-CIS


# Remove ansible
echo "# ---------------------------------------------------------------------------------"
echo "# post_ansible_provisioning.sh | Remove ansible & git"
echo "# ---------------------------------------------------------------------------------"

yum remove -y ansible git


# Remove leaf packages
echo "# ---------------------------------------------------------------------------------"
echo "# post_ansible_provisioning.sh | Remove leaf packages"
echo "# ---------------------------------------------------------------------------------"

yum autoremove -y


# Clean history
echo "# ---------------------------------------------------------------------------------"
echo "#  post_ansible_provisioning.sh | Clean history"
echo "# ---------------------------------------------------------------------------------"

history -c