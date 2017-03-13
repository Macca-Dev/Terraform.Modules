variable "access" {}
variable "secret" {}
variable "env" {}
variable "app" {}
variable "asg-min" {}
variable "asg-max" {}
variable "asg-desired" {}
variable "keypair-name" {}
variable "instance-profile" {}
variable "user-data" {}

variable "vpc-id" {
    type = "map"
    default = {
        uat = ""
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
        uat = ""
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
        uat = ""
        prod = ""
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
variable "zonie-id" {
    type = "map"
    default = {
        uat = ""
        prod = ""
    }
}
variable "zonie-name" {
    type = "map"
    default = {
        uat = ""
        prod = ""
    }
}

