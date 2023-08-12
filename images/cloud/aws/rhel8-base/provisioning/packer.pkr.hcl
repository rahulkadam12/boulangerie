variable "aws_access_key" {}
variable "aws_secret_key" {}

build "amazon-ebs" {
  type          = "amazon-ebs"
  access_key    = var.aws_access_key
  secret_key    = var.aws_secret_key
  region        = "us-east-1"
  source_ami    = "ami-0f5362ba097f1a52e"
  instance_type = "t2.micro"
  ssh_username  = "ec2-user"
  ami_name      = "my-ami ${timestamp}"
  subnet_id     = "subnet-392cc418"
  vpc_id        = "vpc-46a59b3c"
}

provisioner "shell" {
  inline = [
    "echo 'Shell script executed after provisioning'",
    "AMI_ID=$(ec2-metadata -i | cut -d ' ' -f 2)",
    "echo 'AMI ID: $AMI_ID' > ami_id.txt"
  ]
}
