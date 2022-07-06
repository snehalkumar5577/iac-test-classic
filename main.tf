##############################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = var.env_name
  cidr = var.vpc.cidr

  azs                = [for az in var.vpc.azs : "${var.region}${az}"]
  private_subnets    = var.vpc.private_subnets
  public_subnets     = var.vpc.public_subnets
  enable_nat_gateway = true
}

####################  public instance  #############################

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

module "public_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "public-instance"

  ami           = data.aws_ami.amazon_linux.image_id
  instance_type = var.ec2.public_instance_size

  root_block_device = [{
    volume_type = "gp2"
    volume_size = 50
  }]

  monitoring             = false
  vpc_security_group_ids = [module.pub_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  key_name               = var.ec2.key
  user_data              = file("./userData/public_box_setup.sh")
}

module "pub_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "public-sg"
  vpc_id = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-8080-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
}

####################  private instance  #############################
module "private_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "private-instance"

  ami           = data.aws_ami.amazon_linux.image_id
  instance_type = var.ec2.private_instance_size
  monitoring    = false
  root_block_device = [{
    volume_type = "gp2"
    volume_size = 20
  }]
  vpc_security_group_ids = [module.private_sg.security_group_id]
  subnet_id              = module.vpc.private_subnets[0]
  key_name               = var.ec2.key
  user_data              = file("./userData/private_box_setup.sh")
}


module "private_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "private-sg"
  vpc_id = module.vpc.vpc_id

  ingress_cidr_blocks = [var.vpc.cidr]
  ingress_rules       = ["ssh-tcp"]
  egress_rules        = ["all-all"]
}