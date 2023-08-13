variable "aws_access_key" {}
variable "aws_secret_key" {}

source "amazon-ebs" "vm" {
  ami_description = "A RHEL8 AMI for jenkins-master."
  ami_name        = "jenkins-master-mytestvm"
  ami_regions     = ["us-east-1"]
  instance_type   = "t2.micro"
  region          = "us-east-1"
  source_ami      = "ami-0a84d0474804020fe"
  ssh_username    = "ec2-user"
  subnet_id       = "subnet-392cc418"
  vpc_id          = "vpc-46a59b3c"
}
  
build {
  sources = ["source.amazon-ebs.vm"]
  
  provisioner "shell" {
    inline = [
    "echo 'Shell script executed after provisioning'",
    "AMI_ID=$(ec2-metadata -i | cut -d ' ' -f 2)",
    "echo 'AMI ID: $AMI_ID' > ami_id.txt"
    ]
  }
}