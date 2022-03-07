resource "aws_default_vpc" "default" {}

resource "aws_security_group" "prod-web-servers-sg" {
  name        = "prod-web-servers-sg"
  description = "security group for terraform"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Subnet

resource "aws_subnet" "private_subnet" {
vpc_id            = aws_default_vpc.default.id
  cidr_block        = "172.31.0.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_instance" "prod-terraform-server" {
  ami                    = "ami-0c293f3f676ec4f90"
  count                  = 2
  key_name               = "terraform"
  instance_type          = "t3.large"
  vpc_security_group_ids = [aws_security_group.prod-web-servers-sg.id]
  subnet_id              = aws_subnet.private_subnet.id                  
  tags= {
    Name = "test-instance"
 }
}

####create network loadbalancer

resource "aws_lb" "nlb" {
    name               = "test-nlb-tf"
    internal           = false
    load_balancer_type = "network"
    subnets            = ["{aws_subnet.private_subnet.id}"] 
}


#####create target group

resource "aws_lb_target_group" "nlb_tg" {
    name         = "tf-example-nlb-tg"
    port         = 80
    protocol     = "TCP"
    vpc_id       = "vpc-08744290560b05b14"
    target_type  = "instance"
}



####attach nlb to ec2 instances
resource "aws_alb_target_group_attachment" "test-hosts-tg-hosts" {
  target_group_arn = "${aws_lb_target_group.nlb_tg.arn}"
 target_id        = ["${aws_instance.prod-terraform-server.*.id}"]
}