//====================================================================================================
// Variable to store the YAML file in the configs folder
// This config file contains all the configs that will be pushed to CSE
//====================================================================================================
locals {
    rules_chain = yamldecode(file("${path.module}/../../../config/rules/chain.yml"))
}

//====================================================================================================
// Resource that will build out chain rules
//====================================================================================================
resource "sumologic_cse_chain_rule" "rules_chain" {
  for_each = { for rule in local.rules_chain : rule.index_key => rule }  

  enabled               = each.value.enabled
  name                  = each.value.name
  summary_expression    = try(each.value.summary_expression, null) //Optional field as defined by the provider
  description           = each.value.description

  dynamic "entity_selectors" {
    for_each = each.value.entity_selectors

    content {
      entity_type   = entity_selectors.value.entity_type
      expression    = entity_selectors.value.expression
    }
  }

  dynamic "expressions_and_limits" {
    for_each = each.value.expressions_and_limits

    content {
      limit         = expressions_and_limits.value.limit
      expression    = expressions_and_limits.value.expression
    }
  }

  group_by_fields   = try(each.value.group_by_fields, null) //Optional field as defined by the provider
  ordered           = try(each.value.ordered, false)
  severity          = each.value.severity
  window_size       = each.value.window_size
  tags              = each.value.tags
  is_prototype      = try(each.value.is_prototype, null) //Optional field as defined by the provider
}
