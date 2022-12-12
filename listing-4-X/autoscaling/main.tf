module "iam_instance_profile" {
  source = "terraform-in-action/iip/aws"
  actions = ["logs:*" , "rds:*"] # The persmissions are too open for a production deployment but good enough for dev
}

data "cloudinit_config" "config" {
  gzip = true
  base64_encode = true
  part {
    content_type "text/cloud-config"
    content = templatefile("${path.module}/cloud.config.yaml" , var.db_config) # Content for the cloud init configuration comes from a template file.
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = " name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

resource "aws_launch_template" "webserver" {
  name_prefix = var.namespace
  image_id = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  user_data = data.cloudinit_config.config.rendered
  key_name = var.ssh_keypair
  iam_instance_profile {
    name = module.iam_instance_profile.name
  }

  vpc_security_group_ids = [var.sg.websvr]

}

resource "aws_autoscaling_group" "webserver"{
  name = "${var.namespace}-asg"
  min_size = 1
  max_size = 3
  vpc_zone_identifier = var.vpc.private_subnets
  target_group_arns = module.alb.target_group_arns
  launch_template {
    id = aws_launch_template.webserver.id
    version = aws_launch_template.webserver.latest
  }
} 

module "alb" {
  source = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"
  name = var.namespace
  load_balancer_type = "application"
  vpc_id = var.vpc.vpc_id
  subnets = var.vpc.public_subnets
  security_groups =  [var.sg.lb]

  http_tcp_listeners = [{
    port = 80 # The load balancer listens on port 80, which is mapped to 80802 on the instance
    protocol = "HTTP"
    target_group_index = 0
  }]

  target_groups = [
    {
      name_prefix = " websrv"
      backend_protocol "HTTP"
      backend_port = 8080
      target_type = "instance"
    }
  ]
}

