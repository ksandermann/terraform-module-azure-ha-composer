# Terraform module
Terraform module to deploy a highly available linux scaleset running stateless docker images using docker-compose.



1. Resource Groups for the loadbalancer and the scaleset. Can be the same.
1. A VNET to place both the loadbalancer and the scaleset.
1. Subnets for the loadbalancer and the scaleset. Can be the same.
1. A Public SSH key for the scaleset admin user.
1. *Optional*: If you choose to opt-in for boot diagnostics for the scaleset, an appropriate storage account is needed.


