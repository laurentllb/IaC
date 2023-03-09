module "my_host" {
  # Available inputs: https://github.com/futurice/terraform-utils/tree/master/docker_compose_host#inputs
  # Check for updates: https://github.com/futurice/terraform-utils/compare/v11.0...master
  source = "git::ssh://git@github.com/futurice/terraform-utils.git//aws_ec2_ebs_docker_host?ref=v11.0"

  hostname             = "my-docker-host"
  ssh_private_key_path = "~/.ssh/id_rsa"
  ssh_public_key_path  = "~/.ssh/id_rsa.pub"
  allow_incoming_http  = true
  reprovision_trigger  = "${module.my_docker_compose.reprovision_trigger}"
}

module "my_docker_compose" {
  # Available inputs: https://github.com/futurice/terraform-utils/tree/master/docker_compose_host#inputs
  # Check for updates: https://github.com/futurice/terraform-utils/compare/v11.0...master
  source = "git::ssh://git@github.com/futurice/terraform-utils.git//docker_compose_host?ref=v11.0"

  public_ip          = "${module.my_host.public_ip}"
  ssh_username       = "${module.my_host.ssh_username}"
  ssh_private_key    = "${module.my_host.ssh_private_key}"
  docker_compose_yml = "${file("./docker-compose.yml")}"
}

output "test_link" {
  value = "http://${module.my_host.public_ip}/"
}
