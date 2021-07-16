#antivirus
output "created_antivirus_prof" {
  description = "Shows the antivirus security profiles that were created."
  value = var.antivirus_file != "optional" ? { for prof in var.antivirus_file : prof.name => prof } : tomap({})
}


#anti-spyware
output "created_spyware_prof" {
  description = "Shows the anti-spyware security profiles that were created."
  value = var.spyware_file != "optional" ? { for prof in var.spyware_file : prof.name => prof } : tomap({})
}


#file blocking
output "created_file_blocking_prof" {
  description = "Shows the file-blocking security profiles that were created."
  value = var.file_blocking_file != "optional" ? { for prof in var.file_blocking_file : prof.name => prof } : tomap({})
}


#vulnerability
output "created_vulnerability_prof" {
  description = "Shows the vulnerability security profiles that were created."
  value = var.vulnerability_file != "optional" ? { for prof in var.vulnerability_file : prof.name => prof } : tomap({})
}


#wildfire analysis
output "created_wildfire_prof" {
  description = "Shows the wildfire analysis security profiles that were created."
  value = var.wildfire_file != "optional" ? { for prof in var.wildfire_file : prof.name => prof } : tomap({})
}