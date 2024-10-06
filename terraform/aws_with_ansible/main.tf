terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

module "schedule_web" {
  source              = "./modules/ec2_instance"
  ami                 = "ami-0b45ae66668865cd6"
  instance_type       = "t2.micro"
  subnet_id           = aws_subnet.instances_subnet.id
  key_name            = aws_key_pair.instances_key_pair.key_name
  security_group_ids  = [aws_security_group.dbs_security_group.id]
  instance_name       = "schedule-web"
}

module "schedule_api" {
  source              = "./modules/ec2_instance"
  ami                 = "ami-0b45ae66668865cd6"
  instance_type       = "t2.micro"
  subnet_id           = aws_subnet.instances_subnet.id
  key_name            = aws_key_pair.instances_key_pair.key_name
  security_group_ids  = [aws_security_group.dbs_security_group.id]
  instance_name       = "schedule-api"
}

module "schedule_dbs" {
  source              = "./modules/ec2_instance"
  ami                 = "ami-0b45ae66668865cd6"
  instance_type       = "t2.micro"
  subnet_id           = aws_subnet.dbs_subnet.id
  key_name            = aws_key_pair.instances_key_pair.key_name
  security_group_ids  = [aws_security_group.dbs_security_group.id]
  instance_name       = "schedule-dbs"
}
