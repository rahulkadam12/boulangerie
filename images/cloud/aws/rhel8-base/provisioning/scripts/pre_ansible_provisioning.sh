#!/bin/bash

# Install ansible
echo "# -----------------------------------------------------------------------------------------------------------------------------------"
echo "# pre_ansible_provisioning.sh | Install ansible & git"
echo "# -----------------------------------------------------------------------------------------------------------------------------------"
yum install -y ansible git


# Git credential helper
echo "# -----------------------------------------------------------------------------------------------------------------------------------"
echo "# pre_ansible_provisioning.sh | Git credential helper"
echo "# -----------------------------------------------------------------------------------------------------------------------------------"

# create git config directory
mkdir -p $HOME/.config/git

# create git credential helper
cat << EOF > $HOME/.config/git/git_credentials.sh
#!/bin/bash
echo host="$git_url"
echo username="$git_user"
echo password="$git_pass"
EOF

# set permissions
chmod u+x "$HOME/.config/git/git_credentials.sh"

# configure git to use credential helper
git config --global credential.helper "$HOME/.config/git/git_credentials.sh"


echo "# -----------------------------------------------------------------------------------------------------------------------------------"
echo "# pre_ansible_provisioning.sh | Download required ansible roles"
echo "# -----------------------------------------------------------------------------------------------------------------------------------"

# Create ansible-galaxy requirements file
cat << EOF > $HOME/requirements.yml
- name: RHEL-CIS
  src: git+https://gitlab.wirecard-cloud.com/linux-engineering/configuration-management/ansible/getnet/rhel-cis.git
  version: v1.1.0
EOF

# Install required ansible roles
ansible-galaxy install -r $HOME/requirements.yml