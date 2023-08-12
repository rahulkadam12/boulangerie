variable "aws_access_key" {}
variable "aws_secret_key" {}

source "amazon-ebs" "autogenerated_1" {
  ami_description = "A RHEL8 AMI for jenkins-master."
  ami_name        = "jenkins-master-{{isotime | clean_ami_name}}"
  ami_regions     = ["us-east-1"]
  instance_type   = "t2.micro"
  region          = "us-east-1"
  source_ami      = "ami-0f5362ba097f1a52e"
  ssh_username    = "ec2-user"
  subnet_id       = "subnet-392cc418"
  vpc_id          = "vpc-46a59b3c"
}
  
build {
  sources = ["source.amazon-ebs.autogenerated_1"]

  provisioner "shell" {
    inline = [
    "echo 'Shell script executed after provisioning'",
    "AMI_ID=$(ec2-metadata -i | cut -d ' ' -f 2)",
    "echo 'AMI ID: $AMI_ID' > ami_id.txt"
    ]
  }
}