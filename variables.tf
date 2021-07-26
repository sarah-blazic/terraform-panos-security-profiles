#Validation checks:
#1) if the var is on default (aka not being used)
#2) a. if the file exists/not empty
#   b. if the file can be decoded by jsondecode or yamldecode (the 2 file input options)


#antivirus
variable "antivirus" {
  type        = any
  description = "jsondecode and yamldecode with path to JSON/YAML file that will supply the proper parameters to create antivirus profiles."
  default     = "optional"

  validation {
    condition     = var.antivirus == "optional" || (var.antivirus != {} && can(var.antivirus))
    error_message = "Not a valid input to read."
  }
}

#file blocking
variable "file_blocking" {
  type        = any
  description = "jsondecode and yamldecode with path to JSON/YAML file that will supply the proper parameters to create antivirus profiles."
  default     = "optional"

  validation {
    condition     = var.file_blocking == "optional" || (var.file_blocking != {} && can(var.file_blocking))
    error_message = "Not a valid input to read."
  }
}

#anti-spyware
variable "spyware" {
  type        = any
  description = "jsondecode and yamldecode with path to JSON/YAML file that will supply the proper parameters to create antivirus profiles."
  default     = "optional"

  validation {
    condition     = var.spyware == "optional" || (var.spyware != {} && can(var.spyware))
    error_message = "Not a valid input to read."
  }
}

#vulnerability
variable "vulnerability" {
  type        = any
  description = "jsondecode and yamldecode with path to JSON/YAML file that will supply the proper parameters to create antivirus profiles."
  default     = "optional"

  validation {
    condition     = var.vulnerability == "optional" || (var.vulnerability != {} && can(var.vulnerability))
    error_message = "Not a valid input to read."
  }
}

#wildfire analysis
variable "wildfire" {
  type        = any
  description = "jsondecode and yamldecode with path to JSON/YAML file that will supply the proper parameters to create antivirus profiles."
  default     = "optional"

  validation {
    condition     = var.wildfire == "optional" || (var.wildfire != {} && can(var.wildfire))
    error_message = "Not a valid input to read."
  }
}