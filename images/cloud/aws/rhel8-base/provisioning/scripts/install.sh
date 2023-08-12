#!/usr/bin/env bash

set -x

yum update -y
yum install -y java-11-openjdk-devel
java --version

# Install wget, unzip, git, awscli, nginx
yum install -y wget unzip git awscli nginx

rpm -Uvh https://yum.puppet.com/puppet-tools-release-el-8.noarch.rpm
yum install -y pdk
yum install -y yum-utils

# Install Docker
yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sed -i -e 's/baseurl=https:\/\/download\.docker\.com\/linux\/\(fedora\|rhel\)\/$releasever/baseurl\=https:\/\/download.docker.com\/linux\/centos\/$releasever/g' /etc/yum.repos.d/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io

yum update -y

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum clean packages

# Install Jenkins

#yum install -y jenkins
wget https://get.jenkins.io/redhat-stable/jenkins-2.332.3-1.1.noarch.rpm
rpm -i jenkins-2.332.3-1.1.noarch.rpm

yum install -y rpm-build
git clone https://github.com/aws/efs-utils
cd efs-utils
yum install -y make
make rpm
yum install -y ./build/amazon-efs-utils*rpm

yum clean all

usermod -a -G docker ec2-user
usermod -a -G docker jenkins

wget https://releases.hashicorp.com/terraform/1.4.6/terraform_1.4.6_linux_amd64.zip
unzip terraform_1.4.6_linux_amd64.zip
mv terraform /usr/bin/

sudo sed -i 's,JENKINS_JAVA_OPTIONS="-Djava.awt.headless=true",JENKINS_JAVA_OPTIONS="-Djenkins.install.runSetupWizard=false -Djava.awt.headless=true",g' /etc/sysconfig/jenkins

systemctl enable docker.service
systemctl enable jenkins.service
systemctl enable nginx