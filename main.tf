provider "aws" {
  region = "us-east-1"
  
}


resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "myvpc"
  }
}

resource "aws_subnet" "sub1" {
  cidr_block           = var.subnet1_cidr_block
  vpc_id               = aws_vpc.myvpc.id
  availability_zone    = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "sub1"
  }
}

resource "aws_subnet" "sub2" {
  cidr_block           = var.subnet2_cidr_block
  vpc_id               = aws_vpc.myvpc.id
  availability_zone    = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "sub2"
  }
}
resource "aws_internet_gateway" "ig1" {

    vpc_id = aws_vpc.myvpc.id
  
}
resource "aws_route_table" "rt" {

    vpc_id = aws_vpc.myvpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ig1.id
    }
  
}
resource "aws_route_table_association" "rta" {

    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.rt.id
  
}
resource "aws_route_table_association" "rta1" {

    subnet_id = aws_subnet.sub2.id
    route_table_id = aws_route_table.rt.id
  
}
resource "aws_security_group" "sg" {

    name = "Mysg"
    vpc_id = aws_vpc.myvpc.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}
resource "aws_instance" "webserver1" {
    ami                    = var.ami_id
    instance_type          = "t2.micro"
    vpc_security_group_ids = [aws_security_group.sg.id]
    subnet_id = aws_subnet.sub1.id
    user_data = base64encode(file("userdata1.sh"))
  
}
resource "aws_instance" "webserver2" {
    ami                    = "ami-0261755bbcb8c4a84"
    instance_type          = "t2.micro"
    vpc_security_group_ids = [aws_security_group.sg.id]
    subnet_id = aws_subnet.sub2.id
    user_data = base64encode(file("userdata2.sh"))
  
}
resource "aws_lb" "myalb" {
  name               = "myalb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.sg.id]
  subnets         = [aws_subnet.sub1.id, aws_subnet.sub2.id]

  tags = {
    Name = "web"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "myTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver2.id
  port             = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }
}



