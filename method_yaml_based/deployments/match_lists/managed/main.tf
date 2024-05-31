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
resource "sumologic_cse_match_list" "match_lists_managed" {
  for_each = {for match_list in local.match_lists_managed : match_list.index_key => match_list }

  name            = each.value.name
  description     = each.value.description
  target_column   = each.value.target_column
  default_ttl     = try(each.value.default_ttl, null) //Optional field as defined by the provider

  dynamic "items" {
    for_each = try(reach.value.items, [])

    content {
      description = items.value.description
      value       = try(items.value.value, null) //Optional field as defined by the provider
      expiration  = try(items.value.expiration, null) //Optional field as defined by the provider
    }
  }
}
