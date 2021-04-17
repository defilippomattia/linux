locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "example" {
  access_key                    = "#"
  secret_key                    = "#"
  region                        = "#"
  source_ami                    = "#" # redhat linux
  ssh_username                  = "ec2-user"
  instance_type                 = "t2.micro"
  ami_name                      = "packer example ${local.timestamp}"
}

build {
  sources = ["source.amazon-ebs.example"]

  provisioner "file" {
    source        = "myscript.sh"
    destination   = "/tmp/myscript.sh"
  }

  provisioner "file" {
    source        = "myscript.service"
    destination ="/tmp/myscript.service"
  }

  provisioner "file" {
    source        = "myscript.timer"
    destination ="/tmp/myscript.timer"
  }

  provisioner "shell" {
    pause_before = "5s"
    inline = [
        "sudo chmod +x /tmp/myscript.sh",
        "sudo cp /tmp/myscript.service /etc/systemd/system/myscript.service",
        "sudo cp /tmp/myscript.timer /etc/systemd/system/myscript.timer",
    ]
}

  provisioner "shell" {
    pause_before = "5s"
    inline = [
        "sudo systemctl daemon-reload",
        "sudo systemctl enable myscript.timer",
    ]
}

}