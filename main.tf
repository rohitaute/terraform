terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.53.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "devops-tf"
}
/*

resource "aws_iam_user" "demo" {
  name = "mahesh"

}

resource "aws_iam_user" "demo1" {
  name = "salonie"
}

resource "aws_iam_user" "demo2" {
  name = "ankita"
}

resource "aws_iam_group" "grp" {
  name = "team-dev"
}

resource "aws_iam_user_group_membership" "grpadd" {
   user = aws_iam_user.demo1.name
   
   groups = [
          aws_iam_group.grp.name
         ]
}
resource "aws_iam_user_group_membership" "grpadd2" {
   user = aws_iam_user.demo2.name

   groups = [
          aws_iam_group.grp.name
         ]
}
resource "aws_iam_user_group_membership" "grpadd3" {
   user = aws_iam_user.demo.name
   groups = [
         aws_iam_group.grp.name
       ]
}


# code for creating s3 bucket
resource "aws_s3_bucket" "bucket-1" {
  bucket = "mangesh-baltiwala"
   
}
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket =aws_s3_bucket.bucket-1.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "achal" {
  bucket = aws_s3_bucket.bucket-1.id
  acl = "private"
} 
*/
#vpc
resource "aws_vpc" "vpc-0" {
  cidr_block = "192.168.0.0/16"

  tags = {
    name = "vpc-tf"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc-0.id
  cidr_block        = "192.168.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    name = "public-subnet"
  }
}

resource "aws_internet_gateway" "igw-tf" {
  vpc_id = aws_vpc.vpc-0.id
}
resource "aws_route_table" "rt-tf" {
  vpc_id = aws_vpc.vpc-0.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-tf.id

  }
}

resource "aws_route_table_association" "rt-sub" {
  route_table_id = aws_route_table.rt-tf.id
  subnet_id      = aws_subnet.public.id
}
#end

resource "aws_security_group" "tf-sg" {
  name        = "devops-demo-sg"
  description = "allow ssh"
  vpc_id      = aws_vpc.vpc-0.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "pub-vm" {
  ami                    = "ami-08a0d1e16fc3f61ea"
  instance_type          = "t2.micro"
  key_name               = "aws-key"
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = [aws_security_group.tf-sg.id]


  tags = {
    name = "public-instance"
  }
}



output "instance_id" {
  description = "print instance id"
  value       = aws_instance.pub-vm.id
}

output "instance_public_ip" {
  description = "print public ip"
  value       = aws_instance.pub-vm.public_ip
}
