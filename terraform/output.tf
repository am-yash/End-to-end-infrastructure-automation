output "dev_ips" {
  value = module.dev-infrapp.public_ips
}

output "stg_ips" {
  value = module.stg-infra.public_ips
}

output "prd_ips" {
  value = module.prd-infrapp.public_ips
}