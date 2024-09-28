
resource "aws_vpc" "schedule_vpc" {
  provider = aws.eu-north-1

  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "schedule-vpc"
  }
}


resource "aws_internet_gateway" "schedule_igw" {
  vpc_id = aws_vpc.schedule_vpc.id

  tags = {
    Name = "schedule-igw"
  }
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.schedule_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.schedule_igw.id
  }

  tags = {
    Name = "schedule-route-table"
  }
}


resource "aws_security_group" "schedule_security_group" {
  name = "schedule_group"

  vpc_id = aws_vpc.schedule_vpc.id
}


resource "aws_security_group_rule" "ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.schedule_security_group.id
}


resource "aws_security_group_rule" "ingress_http_api" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.schedule_security_group.id
}


resource "aws_security_group_rule" "ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.schedule_security_group.id
}


resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.schedule_security_group.id
}
