output "antivirus" {
  value = module.security-profiles.created_antivirus_prof
}

output "spyware" {
  value = module.security-profiles.created_spyware_prof
}

output "file_block" {
  value = module.security-profiles.created_file_blocking_prof
}

output "vulnerability" {
  value = module.security-profiles.created_vulnerability_prof
}

output "wildfire" {
  value = module.security-profiles.created_wildfire_prof
}
