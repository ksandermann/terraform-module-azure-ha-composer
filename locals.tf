locals {
  systemd_svc_rendered = templatefile("${path.module}/templates/systemd-service.tmpl", {})
  cloud_init_rendered = templatefile("${path.module}/templates/cloud-init.tmpl",
    {
      systemd_service_file_b64 = base64encode(local.systemd_svc_rendered)
      docker_compose_file_b64  = var.docker_compose_file_b64
      container_config_files   = var.container_config_files
    }
  )
}
