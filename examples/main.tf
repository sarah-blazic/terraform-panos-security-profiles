provider "panos" {
  hostname = var.hostname
  username = var.user
  password = var.password
}

module "security-profiles" {
  source  = "sarah-blazic/security-profiles/panos"
  version = "0.1.0"

  #for JSON files: try(jsondecode(file("<*.json>")), {})
  #for YAML files: try(yamldecode(file("<*.yaml>")), {})
  antivirus     = try(jsondecode(file("./files/json/antivirus.json")), {})
  file_blocking = try(jsondecode(file("./files/json/file_blocking.json")), {})
  wildfire      = try(jsondecode(file("./files/json/wildfire.json")), {})
  vulnerability = try(jsondecode(file("./files/json/vulnerability.json")), {})
  spyware      = try(jsondecode(file("./files/json/spyware.json")), {})
}

