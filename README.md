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
2. **(recommended)** Add **tlint.yml**, **"opa.yml"**, and **"validate.yml"** to .github/workflows with changes to file paths in opa.yml and validate.yml depending on the repo.
* **tlint.yml** : checks to see if the Terraform has errors (like illegal instance types) for Major Cloud providers (AWS/Azure/GCP), warns about deprecated syntax, unused declarations, and enforces best practices, naming conventions.
```yaml
name: terraform-lint

on: [push, pull_request]

jobs:
  delivery:

    runs-on: ubuntu-latest

    steps:
    - name: Check out code
      uses: actions/checkout@main
    - name: Lint Terraform
      uses: actionshub/terraform-lint@main

```

* **opa.yml** : checks JSON for duplicate names.
```yaml
name: Check for JSON duplicates
on: [push]

jobs:
  opa_eval:
    runs-on: ubuntu-latest
    name: Open Policy Agent
    steps:
    - name: Checkout
      uses: actions/checkout@v2

    - name: Evaluate OPA Policy w/anti_spyware
      id: opa_eval_antispyware
      uses: migara/test-action@master
      with:
        tests: ./validate/opa/panos.rego
        policy: ./examples/files/json/spyware.json # path to spyware file
        
    - name: Print Results antispyware
      run: |
       echo $opa_results | jq -r '.result[].expressions[].value'
      env:
       opa_results: ${{ steps.opa_eval_antispyware.outputs.opa_results }}

    - name: Evaluate OPA Policy w/antivirus
      id: opa_eval_antivirus
      uses: migara/test-action@master
      with:
        tests: ./validate/opa/panos.rego
        policy: ./examples/files/json/antivirus.json # path to antivirus file
        
    - name: Print Results antivirus
      run: |
       echo $opa_results | jq -r '.result[].expressions[].value'
      env:
       opa_results: ${{ steps.opa_eval_antivirus.outputs.opa_results }}

    - name: Evaluate OPA Policy w/file_blocking
      id: opa_eval_file_blocking
      uses: migara/test-action@master
      with:
        tests: ./validate/opa/panos.rego
        policy: ./examples/files/json/file_blocking.json # path to file-blocking file
        
    - name: Print Results file blocking
      run: |
       echo $opa_results | jq -r '.result[].expressions[].value'
      env:
       opa_results: ${{ steps.opa_eval_file_blocking.outputs.opa_results }}

    - name: Evaluate OPA Policy w/vulnerability
      id: opa_eval_vulnerability
      uses: migara/test-action@master
      with:
        tests: ./validate/opa/panos.rego
        policy: ./examples/files/json/vulnerability.json # path to vulnerability file
      
    - name: Print Results vulnerability
      run: |
       echo $opa_results | jq -r '.result[].expressions[].value'
      env:
       opa_results: ${{ steps.opa_eval_vulnerability.outputs.opa_results }}

    - name: Evaluate OPA Policy w/wildfire
      id: opa_eval_wildfire
      uses: migara/test-action@master
      with:
        tests: ./validate/opa/panos.rego
        policy: ./examples/files/json/wildfire.json # path to wildfire analysis file
    
    - name: Print Results wildfire
      run: |
       echo $opa_results | jq -r '.result[].expressions[].value'
      env:
       opa_results: ${{ steps.opa_eval_wildfire.outputs.opa_results }}
```
* **validate.yml** : checks to see if JSON validates against the provided schemas (located in the validate folder).
```yaml
name: Validate JSONs

on: [pull_request, push]

jobs:
  verify-json-validation:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1

      - name: Validate anti spyware JSON
        uses: nhalstead/validate-json-action@0.1.3
        with:
          schema: ./validate/schemas/anti_spyware_schema.json
          jsons: ./examples/files/json/spyware.json # change this to the anti-spyware JSON path
          
      - name: Validate antivirus JSON
        uses: nhalstead/validate-json-action@0.1.3
        with:
          schema: ./validate/schemas/antivirus_schema.json
          jsons: ./examples/files/json/antivirus.json # change this to the antivirus JSON path

      - name: Validate file blocking JSON
        uses: nhalstead/validate-json-action@0.1.3
        with:
          schema: ./validate/schemas/file_blocking_schema.json
          jsons: ./examples/files/json/file_blocking.json # change this to the file-blocking JSON path

      - name: Validate vulnerability JSON
        uses: nhalstead/validate-json-action@0.1.3
        with:
          schema: ./validate/schemas/vulnerability_schema.json
          jsons: ./examples/files/json/vulnerability.json # # change this to the vulnerability JSON path

      - name: Validate wildfire analysis JSON
        uses: nhalstead/validate-json-action@0.1.3
        with:
          schema: ./validate/schemas/wildfire_schema.json
          jsons: ./examples/files/json/wildfire.json # change this to the wildfire JSON path
```

3. Create a **"main.tf"** with the panos provider and security profile module blocks.
```terraform
provider "panos" {
  hostname = "<panos_address>"
  username = "<admin_username>"
  password = "<admin_password>"
}

module "security-profiles" {
  source = "sarah-blazic/security-profiles/panos"
  version = "0.1.1"

  #for JSON files: try(jsondecode(file("<*.json>")), {})
  #for YAML files: try(yamldecode(file("<*.yaml>")), {})
  antivirus_file     = try(...decode(file("<antivirus JSON/YAML>")), {}) # eg. "antivirus.json"
  file_blocking_file = try(...decode(file("<file-blocking JSON/YAML>")), {})
  wildfire_file      = try(...decode(file("<wildfire analysis JSON/YAML>")), {})
  vulnerability_file = try(...decode(file("<vulnerability JSON/YAML>")), {})
  spyware_file       = try(...decode(file("<anti-spyware JSON/YAML>")), {})
}
```


4. Run Terraform
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
