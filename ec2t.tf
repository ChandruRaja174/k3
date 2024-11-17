provider "aws" {
  region = "us-west-2"  # Replace with your desired region
}

resource "aws_instance" "k3s_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with a region-appropriate Ubuntu AMI
  instance_type = "t2.medium"
  key_name      = "your-ssh-key"

  tags = {
    Name = "k3s-server"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y python3"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/your-ssh-key.pem")
      host        = self.public_ip
    }
  }
}

output "instance_ip" {
  value = aws_instance.k3s_server.public_ip
}
