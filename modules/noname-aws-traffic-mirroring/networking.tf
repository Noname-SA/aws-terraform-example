############################
# set up traffic mirroring #
############################

# Create target group for noname server
resource "aws_lb_target_group" "nonameserver" {
  name     = "nnw-${var.name_prefix}-ntg"
  port     = 4789
  protocol = "UDP"
  vpc_id   = data.aws_vpc.target.id
  health_check {
    port     = "443"
    protocol = "HTTPS"
    path     = "/engine/health"
  }
}

# Register noname EC2 with target group
resource "aws_lb_target_group_attachment" "nonameserver" {
  target_group_arn = aws_lb_target_group.nonameserver.arn
  target_id        = aws_instance.noname_server.id
  port             = 4789
}

# Create NLB for traffic mirroring session
resource "aws_lb" "noname" {
  name               = "nnw-${var.name_prefix}-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = [var.noname_subnet_id]

  tags               = var.common_tags
}

# Create the NLB listener for traffic mirroring session
resource "aws_lb_listener" "trafficmirroring" {
  load_balancer_arn = aws_lb.noname.arn
  port              = "4789"
  protocol          = "UDP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nonameserver.arn
  }
}

# Create mirroring target
resource "aws_ec2_traffic_mirror_target" "noname" {
  description               = "${var.name_prefix}-tm-target"
  network_load_balancer_arn = aws_lb.noname.arn
  tags                      = var.common_tags
}

# Create mirroring filter
resource "aws_ec2_traffic_mirror_filter" "filter" {
  description      = "${var.name_prefix}-tm-filter"
  network_services = ["amazon-dns"]
  tags             = var.common_tags
}

# Create filter rules (in)
resource "aws_ec2_traffic_mirror_filter_rule" "rulein" {
  description              = "allow in"
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.filter.id
  destination_cidr_block   = "0.0.0.0/0"
  source_cidr_block        = "0.0.0.0/0"
  rule_action              = "accept"
  rule_number              = 1
  traffic_direction        = "ingress"
  protocol                 = 6  # TCP
}

# Create filter rules (out)
resource "aws_ec2_traffic_mirror_filter_rule" "ruleout" {
  description              = "allow out"
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.filter.id
  destination_cidr_block   = "0.0.0.0/0"
  source_cidr_block        = "0.0.0.0/0"
  rule_action              = "accept"
  rule_number              = 1
  traffic_direction        = "egress"
  protocol                 = 6  # TCP
}

# Create mirroring session
resource "aws_ec2_traffic_mirror_session" "session" {
  count                    = length(var.network_interface_ids)
  description              = "${var.name_prefix}-tms-${count.index}"
  network_interface_id     = var.network_interface_ids[count.index]
  session_number           = count.index + 1
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.filter.id
  traffic_mirror_target_id = aws_ec2_traffic_mirror_target.noname.id
  virtual_network_id       = var.virtual_network_id
  tags                     = var.common_tags
}

