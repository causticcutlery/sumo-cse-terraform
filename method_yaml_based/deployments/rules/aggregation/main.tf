# terraform {
  
#     required_providers {
#         sumologic = {
#             source = var.sumo_source
#             version = var.sumo_source
#         }
#     }
# }
terraform {
  source = "..."
  // Other Terraform configurations
  
  # Get variables from common.hcl
  extra_arguments "common" {
    commands = get_local("common")
  }
}


provider "sumologic" {
    access_id   = "aaa"
    access_key  = "aaaa"
    environment = var.sumo_source
}

//====================================================================================================
// Variable to store the YAML file in the configs folder
// This config file contains all the configs that will be pushed to CSE
//====================================================================================================
locals {
    rules_aggregation = yamldecode(file("${path.module}/../../../config/rules/aggregation.yml"))
}

//====================================================================================================
// Resource that will build out aggregation rules
//====================================================================================================
resource "sumologic_cse_aggregation_rule" "rules_aggregation" {
  for_each = { for rule in local.rules_aggregation : rule.index_key => rule }  

  enabled                   = each.value.enabled
  name                      = each.value.name
  name_expression           = each.value.name_expression
  summary_expression        = each.value.summary_expression
  description_expression    = each.value.description_expression
  match_expression          = each.value.match_expression

  dynamic "aggregation_functions" {
    for_each = each.value.aggregation_functions

    content {
      name       = aggregation_functions.value.name
      function   = aggregation_functions.value.function
      arguments  = aggregation_functions.value.arguments
    }
  }

  trigger_expression    = each.value.trigger_expression

  dynamic "entity_selectors" {
    for_each = each.value.entity_selectors

    content {
      entity_type   = entity_selectors.value.entity_type
      expression    = entity_selectors.value.expression
    }
  }

  group_by_entity   = try(each.value.group_by_entity) //Optional field as defined by the provider
  group_by_fields   = try(each.value.group_by_fields) //Optional field as defined by the provider

  dynamic "severity_mapping" {
    for_each = each.value.severity_mapping

    content {
      type     = severity_mapping.value.type
      default  = try(severity_mapping.value.default, null) //Optional field as defined by the provider
      field    = try(severity_mapping.value.field, null) //Optional field as defined by the provider
      
      dynamic "mapping" {
        for_each = try(severity_mapping.value.mapping, [])

        content {
          type  = mapping.value.type
          from  = mapping.value.from
          to    = mapping.value.to
        }
      }
    }
  }

  window_size           = each.value.window_size
  window_size_millis    = try(each.value.window_size_millis, null) //Optional field as defined by the provider
  tags                  = each.value.tags
  is_prototype          = try(each.value.is_prototype) //Optional field as defined by the provider
}
