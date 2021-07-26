#antivirus
output "created_antivirus_prof" {
  description = "Shows the antivirus security profiles that were created."
  value       = var.antivirus != "optional" ? { for prof in var.antivirus : prof.name => prof } : tomap({})
}


#anti-spyware
output "created_spyware_prof" {
  description = "Shows the anti-spyware security profiles that were created."
  value       = var.spyware != "optional" ? { for prof in var.spyware : prof.name => prof } : tomap({})
}


#file blocking
output "created_file_blocking_prof" {
  description = "Shows the file-blocking security profiles that were created."
  value       = var.file_blocking != "optional" ? { for prof in var.file_blocking : prof.name => prof } : tomap({})
}


#vulnerability
output "created_vulnerability_prof" {
  description = "Shows the vulnerability security profiles that were created."
  value       = var.vulnerability != "optional" ? { for prof in var.vulnerability : prof.name => prof } : tomap({})
}


#wildfire analysis
output "created_wildfire_prof" {
  description = "Shows the wildfire analysis security profiles that were created."
  value       = var.wildfire != "optional" ? { for prof in var.wildfire : prof.name => prof } : tomap({})
}