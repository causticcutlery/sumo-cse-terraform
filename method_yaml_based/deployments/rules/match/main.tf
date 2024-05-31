//====================================================================================================
// Variable to store the YAML file in the configs folder
// This config file contains all the configs that will be pushed to CSE
//====================================================================================================
locals {
    rules_match = yamldecode(file("${path.module}/../../../config/rules/match.yml"))
}

//====================================================================================================
// Resource that will build out match rules
//====================================================================================================
resource "sumologic_cse_match_rule" "rules_match" {
  for_each = { for rule in local.rules_match : rule.index_key => rule } 

  enabled                 = each.value.enabled
  name                    = each.value.name
  name_expression         = each.value.name_expression
  summary_expression      = try(each.value.summary_expression, null) //Optional field as defined by the provider
  description_expression  = each.value.description_expression
  expression              = each.value.expression

  dynamic "entity_selectors" {
    for_each = each.value.entity_selectors

    content {
      entity_type    = entity_selectors.value.entity_type
      expression     = entity_selectors.value.expression
    }
  }

  dynamic "severity_mapping" {
      for_each = each.value.severity_mapping

      content {
        type       = severity_mapping.value.type
        default    = try(severity_mapping.value.default, null) //Optional field as defined by the provider
        field      = try(severity_mapping.value.field, null) //Optional field as defined by the provider
        
        dynamic "mapping" {
          for_each = try(severity_mapping.value.mapping, []) //Optional field as defined by the provider

          content {
            type    = mapping.value.type
            from    = mapping.value.from
            to      = mapping.value.to
          }
        }
      }
    }

  tags            = try(each.value.tags, null) //Optional field as defined by the provider
  is_prototype    = try(each.value.is_prototype, null) //Optional field as defined by the provider
}
