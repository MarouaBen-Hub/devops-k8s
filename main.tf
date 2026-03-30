terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# ── Génération de la clé SSH ──────────────────────────────────────────────────
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my_key" {
  key_name   = "my-key-terraform"
  public_key = tls_private_key.my_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.my_key.private_key_pem
  filename        = "${path.module}/my-key-terraform.pem"
  file_permission = "0400"
}

# ── Security Group Kubernetes ─────────────────────────────────────────────────
resource "aws_security_group" "k8s_sg" {
  name        = "k8s-security-group"
  description = "Security group pour cluster Kubernetes"

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Kubernetes API Server
  ingress {
    description = "Kubernetes API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # etcd (communication interne master)
  ingress {
    description = "etcd server client API"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Flannel VXLAN (réseau CNI)
  ingress {
    description = "Flannel VXLAN"
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Kubelet API
  ingress {
    description = "Kubelet API"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # kube-scheduler & kube-controller-manager
  ingress {
    description = "kube-scheduler et controller-manager"
    from_port   = 10251
    to_port     = 10252
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # NodePort – accès à l'application Flask
  ingress {
    description = "NodePort application"
    from_port   = 30000
    to_port     = 30000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tout le trafic sortant autorisé
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s-sg"
  }
}

# ── Instances EC2 ─────────────────────────────────────────────────────────────
resource "aws_instance" "master" {
  ami                    = "ami-0866a3c8686eaeeba"  # Ubuntu 22.04 us-east-1
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]

  tags = {
    Name = "k8s-master"
    Role = "master"
  }
}

resource "aws_instance" "worker" {
  ami                    = "ami-0866a3c8686eaeeba"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]

  tags = {
    Name = "k8s-worker"
    Role = "worker"
  }
}

# ── Outputs ───────────────────────────────────────────────────────────────────
output "master_ip" {
  description = "IP publique du Master Node"
  value       = aws_instance.master.public_ip
}

output "worker_ip" {
  description = "IP publique du Worker Node"
  value       = aws_instance.worker.public_ip
}
