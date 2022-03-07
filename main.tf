resource "aws_default_vpc" "default" {}


####create sg group prod-web-servers  for port 80 and 443 (Q-A)

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

####Private Subnet create 

resource "aws_subnet" "private_subnet" {
vpc_id            = aws_default_vpc.default.id
  cidr_block        = "172.31.0.0/24"
  availability_zone = "ap-south-1a"
}


#### 2 EC2 instances creation (Q-E) and attachment to sg(Q-D) and subnet (Q-B)
resource "aws_instance" "prod-web-server-1" {
  ami                    = "ami-0c293f3f676ec4f90"
  count                  = 1
  key_name               = "terraform"
  instance_type          = "t3.large"
  vpc_security_group_ids = [aws_security_group.prod-web-servers-sg.id]
  subnet_id              = aws_subnet.private_subnet.id
  tags= {
    Name = "prod-web-servers-2"
 }
}
resource "aws_instance" "prod-web-server-2" {
  ami           = "ami-0c293f3f676ec4f90"
  key_name = "terraform"
  instance_type = "t3.large"
  vpc_security_group_ids = [aws_security_group.prod-web-servers-sg.id]
  subnet_id              = aws_subnet.private_subnet.id
  tags= {
    Name = "prod-web-servers-1"
  }

}