provider "aws" {
  access_key = "${var.access}"
  secret_key = "${var.secret}"
  region     = "${lookup(var.region, var.env)}"
}

resource "aws_autoscaling_group" "asg" {
  name                 = "${var.env}-${var.app}"
  launch_configuration = "${aws_launch_configuration.lc.name}"
  target_group_arns    = ["${aws_alb_target_group.targetgroup.arn}"]
  min_size             = "${var.asg-min}"
  max_size             = "${var.asg-max}"
  availability_zones   = "${split(",", lookup(var.availability-zones, var.env))}"
  vpc_zone_identifier  = "${split(",", lookup(var.ec2-subnet-ids, var.env))}"
  termination_policies = ["OldestLaunchConfiguration", "OldestInstance"]

  wait_for_capacity_timeout = "${var.asg-wait-for-timeout}"

  health_check_type         = "${var.asg-healthcheck-type}"
  health_check_grace_period = "${var.asg-healthcheck-grace-period}"

  tag {
    key                 = "app"
    value               = "${var.env}-${var.app}"
    propagate_at_launch = true
  }

  tag {
    key                 = "env"
    value               = "${var.env}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "lc" {
  image_id             = "${lookup(var.ami, var.aws-account)}"
  instance_type        = "${lookup(var.instance-type, var.env)}"
  key_name             = "${lookup(var.keypair-name, var.env)}"
  name_prefix          = "${var.env}-${var.app}"
  iam_instance_profile = "${var.instance-profile}"
  user_data            = "${var.user-data}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb" "alb" {
  name            = "${var.env}-${var.app}"
  subnets         = "${split(",", lookup(var.alb-subnets, var.env))}"

  tags {
    app       = "${var.env}-${var.app}"
    env       = "${var.env}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_target_group" "targetgroup" {
  name     = "${var.env}-${var.app}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${lookup(var.vpc-id, var.env)}"

  health_check {
    healthy_threshold   = "${var.alb-healthcheck-healthy-threshold}"
    unhealthy_threshold = "${var.alb-healthcheck-unhealthy-threshold}"
    timeout             = "${var.alb-healthcheck-timeout}"
    path                = "${var.alb-healthcheck-target}"
    interval            = "${var.alb-healthcheck-interval}"
  }
}

resource "aws_alb_listener" "alblistener" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "${var.alb-listener-port}"
  protocol          = "${var.alb-listener-protocol}"
  
  default_action {
    target_group_arn = "${aws_alb_target_group.targetgroup.arn}"
    type             = "forward"
  }
}

output "alb-dns-name" {
  value = "${aws_alb.alb.dns_name}"
}

output "alb-zone-id" {
  value = "${aws_alb.alb.zone_id}"
}

resource "aws_route53_record" "dns" {
  zone_id = "${lookup(var.zone-id, var.env)}"
  name    = "${var.app}${lookup(var.zone-name, var.env)}"
  type    = "A"

  alias {
    name                   = "${aws_alb.alb.dns_name}"
    zone_id                = "${aws_alb.alb.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_ecs_cluster" "ecscluster" {
  name = "${var.app}"
}