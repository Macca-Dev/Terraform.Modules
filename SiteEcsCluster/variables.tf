variable "access" {}
variable "secret" {}
variable "env" {}
variable "app" {}
variable "asg-min" {}
variable "asg-max" {}
variable "asg-desired" {}
variable "keypair-name" {
    type = "map"
}
variable "instance-profile" {}
variable "user-data" {}

variable "vpc-id" {
    type = "map"
    default = {
        uat = "vpc-5947393e"
        prod = ""
    }
}

variable "alb-healthcheck-healthy-threshold" {
    default = 3
}
variable "alb-healthcheck-unhealthy-threshold" {
    default = 3
}
variable "alb-healthcheck-timeout" {
    default = 5
}
variable "alb-healthcheck-target" {
  default = "/ping"
}
variable "alb-healthcheck-interval" {
  default = 30
}
variable "alb-subnets" {
    type = "map"
    default = {
        uat = "subnet-40968218,subnet-ae43f0e7,subnet-f968f19e"
        prod = ""
    }
}
variable "ec2-subnet-ids" {
    type = "map"
    default = {
        uat = "subnet-6a41f223,subnet-cb6bf2ac,subnet-4797831f"
        prod = ""
    }
}
variable "alb-listener-port" {
    default = 80
}
variable "alb-listener-protocol" {
    default = "HTTP"
}
variable "ami" {
    type = "map"
    default = {
        uat = "ami-62d35c02"
        prod = "ami-275ffe31"
    }
}
variable "asg-healthcheck-type" {
    default = "EC2"
}
variable "asg-healthcheck-grace-period" {
    default = 1200
}
variable "asg-wait-for-timeout" {
    default = "25m"
}
variable "availability-zones" {
  type = "map"
  default = {
    uat = "us-west-2a,us-west-2b,us-west-2c"
    prod = "us-east-1a,us-east-1b,us-east-1c"
  }
}
variable "instance-type" {
    type = "map"
    default = {
        uat = "t2.small"
        prod = "t2.small"
    }
}
variable "region" {
    type = "map"
    default = {
        uat = "us-west-2"
        prod = "us-east-1"
    }
}
