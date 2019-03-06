provider "digitalocean" {
  # export DIGITALOCEAN_TOKEN="Your API TOKEN"  #
}

resource "digitalocean_floating_ip" "kafkajs-demo" {
  droplet_id = "${digitalocean_droplet.kafkajs-demo.id}"
  region     = "${digitalocean_droplet.kafkajs-demo.region}"
}

data "template_file" "user-data" {
  template = "${file("./config.ign")}"

  vars {}
}

resource "digitalocean_droplet" "kafkajs-demo" {
  image              = "${var.coreos}"
  name               = "kafkajs-demo"
  region             = "${var.do_ams3}"
  size               = "s-2vcpu-4gb"
  ssh_keys           = [5675195]
  ipv6               = true
  private_networking = true

  user_data = "${data.template_file.user-data.rendered}"

  connection {
    type    = "ssh"
    agent   = true
    user    = "core"
    timeout = "2m"
  }

  provisioner "file" {
    source      = "../testHelpers/kafka/server-jaas.conf"
    destination = "/home/core/server-jaas.conf"
  }

  provisioner "file" {
    source      = "./tokens.conf"
    destination = "/home/core/tokens.conf"
  }
}
