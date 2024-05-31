//====================================================================================================
// Variable to store the YAML file in the configs folder
// This config file contains all the configs that will be pushed to CSE
//====================================================================================================
locals {
    rules_tuning = yamldecode(file("${path.module}/../../../config/rules/tuning.yml"))
}

//====================================================================================================
// Resource that will build out rule tuning expressions
//====================================================================================================
resource "sumologic_cse_tuning_rule" "rules_tuning" {
  for_each = { for rule in local.rules_tuning : rule.index_key => rule }  

  name           = each.value.name
  description    = each.value.description
  expression     = each.value.expression
  enabled        = each.value.enabled
  exclude        = each.value.exclude
  is_global      = each.value.is_global
  rule_ids       = each.value.rule_ids
}
