output "web_public_ip" {
  value = module.web.public_ip
}

output "web_instance_id" {
  value = module.web.instance_id
}

output "web_sg_id" {
  value = module.web.security_group_id
}
