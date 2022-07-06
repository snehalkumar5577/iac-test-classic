env_name      = "dev02"
region        = "us-east-2"

tags = {
  env   = "dev02"
  owner = "snehal"
}

vpc = {
  cidr            = "10.1.0.0/16"
  azs             = ["a"]
  private_subnets = ["10.1.1.0/24"]
  public_subnets  = ["10.1.101.0/24"]
}

ec2 = {
  key = "ee"
  public_instance_size = "t2.medium"
  private_instance_size = "t2.micro"
}
