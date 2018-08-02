resource "aws_launch_configuration" "capgem-asg-launch" {
  name_prefix                 = "launchconfig_capgem"
  image_id                    = "${lookup(var.amis, var.region)}"
  instance_type               = "t2.small"
  associate_public_ip_address = true

  key_name = "${aws_key_pair.key.key_name}"

  #security_groups             = ["${aws_security_group.sg_prod_fronttier.id}"]
  #user_data                   = "${data.template_cloudinit_config.cloudinit-fronttier.rendered}"

  user_data = <<EOF
  #!/bin/sh
  yum install -y nginx
  service nginx start
EOF

  #lifecycle {
  #  create_before_destroy = true
  #}
}

resource "aws_autoscaling_group" "capgem-asg" {
  name                 = "autoscaling_capgem"
  vpc_zone_identifier  = ["${aws_subnet.privates.0.id}", "${aws_subnet.privates.1.id}"]
  launch_configuration = "${aws_launch_configuration.capgem-asg-launch.name}"
  min_size             = 2
  max_size             = 2

  #tag {
  #  key                 = "Name"
  #  value               = "fronttier Docker instance"
  #  propagate_at_launch = true
  #}
}
