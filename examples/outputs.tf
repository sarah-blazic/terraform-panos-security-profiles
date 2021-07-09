output "antivirus" {
  value = module.sec_prof.created_antivirus_prof
}

output "spyware" {
  value = module.sec_prof.created_spyware_prof
}

output "file_block" {
  value = module.sec_prof.created_file_blocking_prof
}

output "vulnerability" {
  value = module.sec_prof.created_vulnerability_prof
}

output "wildfire" {
  value = module.sec_prof.created_wildfire_prof
}