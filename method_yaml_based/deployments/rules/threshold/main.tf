//====================================================================================================
// Variable to store the YAML file in the configs folder
// This config file contains all the configs that will be pushed to CSE
//====================================================================================================
locals {
    rules_threshold = yamldecode(file("${path.module}/../../../config/rules/threshold.yml"))
}

//====================================================================================================
// Resource that will build out threshold rules
//====================================================================================================
resource "sumologic_cse_threshold_rule" "rules_threshold" {
  for_each = { for rule in local.rules_threshold : rule.index_key => rule }  

  enabled               = each.value.enabled
  name                  = each.value.name
  summary_expression    = try(each.value.summary_expression, null) //Optional field as defined by the provider
  description           = each.value.description
  expression            = each.value.expression

  dynamic "entity_selectors" {
    for_each = each.value.entity_selectors

    content {
      entity_type    = entity_selectors.value.entity_type
      expression     = entity_selectors.value.expression
    }
  }

  count_distinct     = try(each.value.count_distinct, null) //Optional field as defined by the provider
  count_field        = try(each.value.count_field, null) //Optional field as defined by the provider
  group_by_fields    = try(each.value.group_by_fields, null) //Optional field as defined by the provider
  limit              = each.value.limit
  severity           = each.value.severity
  window_size        = each.value.window_size
  tags               = try(each.value.tags, null) //Optional field as defined by the provider
  is_prototype       = try(each.value.is_prototype, null) //Optional field as defined by the provider
}
