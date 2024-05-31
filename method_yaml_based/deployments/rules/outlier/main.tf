
//====================================================================================================
// Variable to store the YAML file in the configs folder
// This config file contains all the configs that will be pushed to CSE
//====================================================================================================
locals {
    rules_outlier = yamldecode(file("${path.module}/../../../config/rules/outlier.yml"))
}

//====================================================================================================
// Resource that will build out outlier rules
//====================================================================================================
resource "sumologic_cse_outlier_rule" "rules_outlier" {
  for_each = { for rule in local.rules_outlier : rule.index_key => rule }  

  name                      = each.value.name
  enabled                   = each.value.enabled
  name_expression           = each.value.name_expression
  summary_expression        = try(each.value.summary_expression, null) //Optional field as defined by the provider
  description_expression    = each.value.description_expression
  match_expression          = each.value.match_expression

  dynamic "aggregation_functions" {
    for_each = each.value.aggregation_functions

    content {
      name         = aggregation_functions.value.name
      function     = aggregation_functions.value.function
      arguments    = aggregation_functions.value.arguments
    }
  }

  dynamic "entity_selectors" {
    for_each = each.value.entity_selectors

    content {
      entity_type    = entity_selectors.value.entity_type
      expression     = entity_selectors.value.expression
    }
  }

  floor_value              = each.value.floor_value
  group_by_fields          = try(each.value.group_by_fields)
  severity                 = each.value.severity
  window_size              = each.value.window_size
  baseline_window_size     = each.value.baseline_window_size
  retention_window_size    = each.value.retention_window_size
  deviation_threshold      = each.value.deviation_threshold
  tags                     = try(each.value.tags)
  is_prototype             = try(each.value.is_prototype, null) //Optional field as defined by the provider
}
