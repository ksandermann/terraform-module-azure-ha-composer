data "template_file" "cloudinit" {
  template = file("${path.module}/templates/cloud-init.tpl")
  vars = {
    systemd_service_file_b64 = base64encode(data.template_file.systemd_service.rendered)
    docker_compose_file_b64  = var.docker_compose_file_b64
    container_config_files   = var.container_config_files
  }
}

data "template_file" "systemd_service" {
  template = file("${path.module}/templates/systemd-service.tpl")
}

