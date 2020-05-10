#cloud-config
package_upgrade: true
packages:
  - docker
  - docker-compose
write_files:
  - path: /etc/systemd/system/composer.service
    encoding: b64
    content: ${systemd_service_file_b64}
  - path: /etc/composer/docker-compose.yml
    encoding: b64
    content: ${docker_compose_file_b64}
  %{ for configfile in container_config_files ~}
  - path: ${configfile.hostpath}
    encoding: b64
    content: ${configfile.file_content_b64}
  %{ endfor ~}
runcmd:
  - systemctl daemon-reload
  - systemctl enable composer.service
  - systemctl start composer.service




