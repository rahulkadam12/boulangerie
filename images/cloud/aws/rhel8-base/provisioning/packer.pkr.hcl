variable "aws_access_key" {}
variable "aws_secret_key" {}

source "amazon-ebs" "vm" {
  ami_description = "A RHEL8 AMI for jenkins-master."
  ami_name        = "jenkins-master-{{timestamp}}"
  ami_regions     = ["us-east-1"]
  instance_type   = "t2.micro"
  region          = "us-east-1"
  source_ami      = "ami-0f5362ba097f1a52e"
  ssh_username    = "ec2-user"
  subnet_id       = "subnet-0e466ce5813dedaec"
  vpc_id          = "vpc-00f81ded507c54218"
}
  
build {
  sources = ["source.amazon-ebs.vm"]
  
  provisioner "file" {
    destination = "/tmp/jenkins_install.sh"
    source      = "../images/cloud/aws/rhel8-base/provisioning/scripts/install.sh"
  }

  provisioner "file" {
    destination = "/tmp/nginx.conf"
    source      = "../images/cloud/aws/rhel8-base/provisioning/scripts/nginx.conf.tmpl"
  }

  provisioner "shell" {
    inline = [
    "sudo chmod +x /tmp/jenkins_install.sh",  # Make the script executable (if needed)
    "sudo /tmp/jenkins_install.sh",
    "sudo jenkins --version"
    ] 
  }

}
 
