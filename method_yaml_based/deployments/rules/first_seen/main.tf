//====================================================================================================
// Variable to store the YAML file in the configs folder
// This config file contains all the configs that will be pushed to CSE
//====================================================================================================
locals {
    rules_first_seen = yamldecode(file("${path.module}/../../../config/rules/first_seen.yml"))
}

//====================================================================================================
// Resource that will build out chain rules
//====================================================================================================
resource "sumologic_cse_first_seen_rule" "rules_first_seen" {
  for_each = { for rule in local.rules_first_seen : rule.index_key => rule }  

  index_key                 = each.value.index_key
  enabled                   = each.value.enabled
  name                      = each.value.name
  name_expression           = each.value.name_expression
  summary_expression        = try(each.value.summary_expression, null) //Optional field as defined by the provider
  description_expression    = each.value.description_expression
  baseline_type             = each.value.baseline_type
  filter_expression         = each.value.filter_expression
  group_by_fields           = try(each.value.group_by_fields, null) //Optional field as defined by the provider

  dynamic "entity_selectors" {
    for_each = each.value.entity_selectors

    content {
      entity_type   = entity_selectors.value.entity_type
      expression    = entity_selectors.value.expression
    }
  }

  severity                 = each.value.severity
  baseline_window_size     = each.value.baseline_window_size
  retention_window_size    = each.value.retention_window_size
  value_fields             = each.value.value_fields
  tags                     = try(each.value.tags, null) //Optional field as defined by the provider
  is_prototype             = try(each.value.is_prototype, null) //Optional field as defined by the provider
}
