
data "aws_vpc" "default" {
  default = true
} 

# SG
resource "aws_security_group" "RoHa_K0s_SG1" {
  name        = "${var.name-for-SG}"
  description = "Allow everything within SG1"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow all within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
    self        = true
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow access to HTTPS GUI"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow access to Kubernetes"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name-for-SG}"
  }
}





######################## 
# MASTERNODES MACHINES
######################## 
resource "aws_instance" "masterserver" {
  count = var.number_of_masternodes
  ami           = var.image_id
  instance_type = var.instance_type
  key_name = var.my_key
  associate_public_ip_address = true
  vpc_security_group_ids =  [aws_security_group.RoHa_K0s_SG1.id]
  #subnet_id      = aws_subnet.RoHa_VPC_sub1_pub.id

  tags          = {
    Name        = "${format("masternodes-%03d", count.index + 1)}"
    Environment = "test"
  }

  root_block_device {
    delete_on_termination = "true"
    volume_size = "200"
  }
}





######################## 
# LOAD BALANCER FOR MASTER NODES
######################## 
resource "aws_elb" "k0s_elb" {
  name               = "${var.clustername}-elb"
  availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  cross_zone_load_balancing   = true
  idle_timeout               = 400
  connection_draining        = true
  connection_draining_timeout = 400
              
  listener {  
    instance_port     = 6443
    instance_protocol = "tcp"
    lb_port           = 6443
    lb_protocol       = "tcp"
  }         
              
  listener {
    instance_port     = 8132
    instance_protocol = "tcp"
    lb_port           = 8132 
    lb_protocol       = "tcp"
  }                 
                    
  listener {      
    instance_port     = 9443
    instance_protocol = "tcp"
    lb_port           = 9443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "TCP:6443"
    interval            = 10
  }

  tags = {
    Name = "${var.clustername}-elb"
  }
}

# ADD MASTER NODES TO LB
resource "aws_elb_attachment" "elb_attachment" {
  count = var.number_of_masternodes
  elb      = aws_elb.k0s_elb.id
  instance = aws_instance.masterserver[count.index].id
}


######################## 
# WORKERNODES MACHINES
######################## 
resource "aws_instance" "workerserver" {
  count = var.number_of_workernodes
  ami           = var.image_id
  instance_type = var.instance_type
  key_name = var.my_key
  associate_public_ip_address = true
  vpc_security_group_ids =  [aws_security_group.RoHa_K0s_SG1.id]

  tags          = {
    Name        = "${format("workernodes-%03d", count.index + 1)}"
    Environment = "test"
  }

  root_block_device {
    delete_on_termination = "true"
    volume_size = "200"
  }
}

# Make all scripts executable
resource "null_resource" "makeX" {
  
  provisioner "local-exec" {
    command = "cd scripts ; chmod 755 *.ksh"
  } 
} 

################
# BUILD CLUSTER YAML FILE FOR BUILD
################
# 0 INITIAL COPY CLUSTER1 template + DNS LB
resource "null_resource" "launchpad0" {
  
  provisioner "local-exec" {
    command = "cd scripts ; ./0init_cluster_yaml.ksh ${aws_elb.k0s_elb.dns_name} ${var.clustername}"
  } 
} 

# 1 Add Master/Controller nodes
resource "null_resource" "launchpad1" {
  count = var.number_of_masternodes
  
  provisioner "local-exec" {
    command = "cd scripts ; ./1addmaster.ksh ${aws_instance.masterserver[count.index].private_ip} ${var.full_key-path}"
  } 
} 

# 2 Add Worker nodes
resource "null_resource" "launchpad2" {
  count = var.number_of_workernodes
  
  provisioner "local-exec" {
    command = "cd scripts ; ./2addworker.ksh ${aws_instance.workerserver[count.index].private_ip} ${var.full_key-path}"
  } 
} 

# 3 Run Install
resource "null_resource" "launchpad3" {
  depends_on = [
    null_resource.launchpad1,
    null_resource.launchpad2
  ]
  
  provisioner "local-exec" {
    command = "cd scripts ; ./3startinstall.ksh"
  } 
} 

