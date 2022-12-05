provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "ubuntu" { # Declares an aws_ami data source with the name "ubuntu"
  most_recent = true

  filter { #Sets a filter to select all AMI's with the name mathing this regex expression
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]

  }

  owners = ["099720109477"] # Canonical Ubuntu AWS account id 
}


resource "aws_instance" "helloworld" {
  ami           = data.aws_ami.ubuntu.id # Chains resources together
  instance_type = "t2.micro"
  tags = {
    name = "HelloWorld"
  }
}

