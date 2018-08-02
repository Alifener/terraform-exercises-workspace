module "vpc" {
  source   = "../../modules/network"
  region   = "eu-west-1"
  vpc-cidr = "10.10.10.0/24"
}
