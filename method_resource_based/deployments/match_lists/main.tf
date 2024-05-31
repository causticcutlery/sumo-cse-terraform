//====================================================================================================
// Variable to store the YAML file in the configs folder
// This config file contains all the configs that will be pushed to CSE
//====================================================================================================
locals {
    match_lists_managed = yamldecode(file("${path.module}/../../../config/match_lists/managed.yml"))
}

//====================================================================================================
// Resource that will build out managed match lists
// Unmanaged match lists are ones whose items are not exclusively managed by Terraform
//====================================================================================================
resource "sumologic_cse_match_list" "mml-1" {
  name            = "Global Administrators"
  description     = "List of users with global administrator privilege"
  target_column   = "Username"

  dynamic "items" {
    content {
      description = "Full Time Employee"
      value       = "johndoe"
    }
    content {
      description = "Contractor"
      value       = "bobsmith"
      expiration  = "2025-02-27T04:00:00"
    }
  }
}

resource "sumologic_cse_match_list" "mml-2" {
  name            = "Temporary IP Watch List"
  description     = "List of risky IPs"
  target_column   = "Ip"
  default_ttl     = 2592000

  dynamic "items" {
    content {
      description = "Suspicious scanning"
      value       = "10.1.2.3"
    }
    content {
      description = "Suspicious scanning"
      value       = "10.2.3.4"
    }
  }
}

resource "sumologic_cse_match_list" "uml-2" {
  name            = "VIPs"
  description     = "VIP users"
  target_column   = "Username"
}

resource "sumologic_cse_match_list" "uml-2" {
  name            = "Executives"
  description     = "Executive users"
  target_column   = "Username"
}