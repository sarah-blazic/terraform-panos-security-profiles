Palo Alto Networks Panorama Security Profiles Module for Policy as Code
---
This Terraform module allows users to configure security profiles (Antivirus, Anti-Spyware, File-Blocking, Vulnerability, and Wildfire-Analysis) with Palo Alto Networks **PAN-OS** based PA-Series devices.

Feature
---
This module supports the following:
* Create, update, and delete security profiles based on a JSON/YAML document.

What is Policy as Code?
---
Policy as Code is a way to configure Palo Alto Networks’ Next Generation Firewalls and Panoramas without needing to use the GUI.

![PolicyAsCode](https://i.imgur.com/hSWGYuL.png)

* Policy as Code executes Terraform that will create a variety of resources based on the file input. 
* Terraform is the underlying automation tool, therefore it utilizes the Terraform provider ecosystem to drive relevant change to the network infrastructure.
* All Policy as Code is written as a compatible **Terraform module** using resources for the underlying network infrastructure provider.

Requirements
---
* Terraform 0.13+

Providers
---
Name | Version
-----|------
panos | 1.8.3

Compatibility
---
This module is meant for use with **PAN-OS >= 8.0** and **Terraform >= 0.13**

Permissions
---
* In order for the module to work as expected, the hostname, username, and password to the **panos** Terraform provider.

Caveats
---
* Security profiles can be associated to one or more polices on a PAN-OS device. Once a security profile is associated to a policy, it can only be deleted if there are no policies associated with that security profiles. If the users tries to delete a security profile that is associated with any policy, they will encounter an error. This is a behavior on a PAN-OS device. This module creates, updates and deletes security profiles with Terraform. If a tag associated to a security profile is deleted from the panorama, the module will throw an error when trying to create the profile. This is the correct and expected behavior as the profile is being used in a policy.

Usage
---
1. Create a JSON/YAML file to config one or more security profile. Please note that the file(s) must adhere to its respective schema.

Below is an example of a JSON file to create a File-Blocking security profile.
```json
[
  {
    "name": "ex1",
    "device_group": "AWS",
    "description": "ex1 file blocking security profile",
    "rule": [
      {
        "name": "rule1",
        "direction": "upload",
        "applications": [
          "any"
        ],
        "file_types": [
          "msp"
        ]
      }
    ]
  }
]
```

Below is an example of a YAML file to create a File-Blocking security profile.
```yaml
---
- name: ex1
  device_group: AWS
  description: ex1 file blocking security profile
  rule:
  - name: rule1
    direction: upload
    applications:
    - any
    file_types:
    - msp
```

2. Create a **"main.tf"** with the panos provider and security profile module blocks.
```terraform
provider "panos" {
  hostname = "<panos_address>"
  username = "<admin_username>"
  password = "<admin_password>"
}

module "sec_prof" {
  source = "sarah-blazic/sec_profiles"
  version = "0.1.0"

  antivirus_file     = "<antivirus JSON/YAML>" # eg. antivirus.json
  file_blocking_file = "<file-blocking JSON/YAML>"
  wildfire_file      = "<wildfire analysis JSON/YAML>"
  vulnerability_file = "<vulnerability JSON/YAML>"
  spyware_file       = "<anti-spyware JSON/YAML>"
}
```

3. Run Terraform
```
terraform init
terraform apply
terraform output -json
```

Cleanup
---
```
terraform destroy
```

Inputs
---
Name | Description | Type | Default | Required
-----|-----|-----|-----|-----
antivirus_file | (optional) Creates antivirus security profiles. |`string`|n/a|no
file_blocking_file | (optional) Creates file-blocking security profiles. | `string` | n/a | no
vulnerability_file | (optional) Creates vulnerability security profiles. |`string`|n/a|no
wildfire_file | (optional) Creates wildfire analysis security profiles. |`string`|n/a|no

* each input will create a resource based off of the JSON/YAML file given

Outputs
---
Name | Description
-----|-----
created_antivirus_prof | Shows the antivirus security profiles that were created.
created_spyware_prof |Shows the anti-spyware security profiles that were created.
created_file_blocking_prof |Shows the file blocking security profiles that were created.
created_vulnerability_prof |Shows the vulnerability security profiles that were created.
created_wildfire_prof |Shows the wildfire analysis security profiles that were created.
