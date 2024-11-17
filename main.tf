# Terraform script to install k3s on a Linux machine

provider "local" {
  version = "~> 2.1"
}

provider "null" {
  version = "~> 3.1"
}

provider "template" {
  version = "~> 2.2"
}

provider "tls" {
  version = "~> 3.1"
}

# SSH Key generation for the server
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Define the connection
resource "local_file" "private_key" {
  content  = tls_private_key.example.private_key_pem
  filename = "./id_rsa"
}

resource "null_resource" "install_k3s" {
  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | sh -",
      "sudo k3s kubectl get nodes"
    ]

    connection {
      type        = "ssh"
      host        = var.server_ip
      user        = "root"
      private_key = tls_private_key.example.private_key_pem
    }
  }
}

# Define variables for server IP
variable "server_ip" {
  description = "IP address of the server where k3s will be installed"
  type        = string
}

output "k3s_node_status" {
  value = "k3s node installation completed on ${var.server_ip}"
}
