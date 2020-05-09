data "template_file" "cloudinit" {
  template                 = file("${path.module}/templates/cloud-init.tpl")
  systemd_service_file_b64 = base64encode(data.template_file.systemd_service.rendered)
}

data "template_file" "systemd_service" {
  template                = file("${path.module}/templates/systemd-service.tpl")
  docker_compose_file_b64 = base64encode(data.template_file.docker_compose.rendered)
}

data "template_file" "docker_compose" {
  template = file("${path.module}/templates/docker-compose.tpl")
}


