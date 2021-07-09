provider "panos" {
  hostname = var.hostname
  username = var.user
  password = var.password
}

module "sec_prof" {
  source = "sarah-blazic/sec_profiles/panos"

  #for yaml file "./examples/yaml/..."
  antivirus_file     = "./files/json/antivirus.json"
  file_blocking_file = "./files/json/file_blocking.json"
  wildfire_file      = "./files/json/wildfire.json"
  vulnerability_file = "./files/json/vulnerability.json"
  spyware_file       = "./files/json/spyware.json"
}


