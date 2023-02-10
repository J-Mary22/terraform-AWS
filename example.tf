# this is listing the provider in US region - Provider block
provider "aws" {
  region = "us-east-1"
}

# Resource block - we want a t2. micro instance named "example-instance"
resource "aws_instance" "example" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }
}

# S3 Bucket specifications 
resource "aws_s3_bucket" "example" {
  bucket = "example-bucket"

  tags = {
    Name = "example-bucket"
  }
}

# VPC specification
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "example-vpc"
  }
}

# DB- MySQL with type and version
resource "aws_db_instance" "example" {
  identifier           = "example-db"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "root"
  password             = "password"
  vpc_security_group_ids = [aws_security_group.example.id]
  subnet_group_name    = aws_db_subnet_group.example.name
}

# Security Group (Virtual firewall for this infrastructure) 
resource "aws_security_group" "example" {
  name = "example-security-group"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#2 subnet will be created
resource "aws_db_subnet_group" "example" {
  name        = "example-db-subnet-group"
  subnet_ids = [aws_subnet.example.*.id]
}

resource "aws_subnet" "example" {
  count = 2

  cidr_block = "10.0.0.0/24"
  vpc_id     = aws_vpc.example.id

  tags = {
    Name = "example-subnet-${count.index + 1}"
  }
}

#output defining our variables for infrastructure 

output "instance_id" {
  value = aws_instance.example.id
}

output "bucket_name" {
  value = aws_s3_bucket.example.bucket
}

output "vpc_id" {
  value = aws_vpc.example.id
}

output "db_endpoint" {
  value = aws_db_instance.example.endpoint
}
