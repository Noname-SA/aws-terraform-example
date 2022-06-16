data "aws_lb" "alb_to_mirror" {
  # ARN of ALB that you will mirror
  arn = var.alb_arn
}

data "aws_network_interfaces" "network_interfaces_to_mirror" {
  filter {
    name = "description"
    # Assumes the description has not been manually modified
    values = ["ELB ${data.aws_lb.alb_to_mirror.arn_suffix}"]
  }
}

# ALBs always have a minimum of two network interfaces. creating the sessions:
resource "aws_ec2_traffic_mirror_session" "session" {
  count                    = length(data.aws_network_interfaces.network_interfaces_to_mirror.ids)
  description              = "${var.prefix}-nn-tms-${count.index}"
  network_interface_id     = tolist(data.aws_network_interfaces.network_interfaces_to_mirror.ids)[count.index]
  session_number           = count.index + 1
  traffic_mirror_filter_id = var.tmf_id
  traffic_mirror_target_id = var.tmt_id
  virtual_network_id       = var.vxlanid # set the VXLAN ID so that Noname properly identifies the source
  tags = {
    Name = "${var.prefix}-tms-${count.index}"
  }
}

output "session_ids" {
  value = [ "${aws_ec2_traffic_mirror_session.session.*.id}" ]
}

output "session_arns" {
  value = [ "${aws_ec2_traffic_mirror_session.session.*.arn}" ]
}
