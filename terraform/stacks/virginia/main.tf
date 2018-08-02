module "vpc" {
  source   = "../../modules/network"
  region   = "us-east-1"
  vpc-cidr = "10.20.10.0/24"
}
