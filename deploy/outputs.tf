output "floating_ip" {
  value = "${digitalocean_floating_ip.kafkajs-demo.ip_address}"
}

output "droplet_ip" {
  value = "${digitalocean_droplet.kafkajs-demo.ipv4_address}"
}
