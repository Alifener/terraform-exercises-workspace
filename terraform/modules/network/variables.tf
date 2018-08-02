variable "region" {}

variable "vpc-cidr" {}

variable "amis" {
  type = "map"

  default = {
    us-east-1 = "ami-e7d6c983"
    eu-west-1 = "ami-1a962263"
  }
}

variable "path_to_public_key" {
  default = "../keys/capgemkey.pub"
}

#variable "subnet-cidr-a" {}


#variable "subnet-cidr-b" {}


#variable "subnet-cidr-c" {}

