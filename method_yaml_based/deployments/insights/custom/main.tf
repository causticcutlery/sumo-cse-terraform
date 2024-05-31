//====================================================================================================
// Variable to store the YAML file in the configs folder
// This config file contains all the configs that will be pushed to CSE
//====================================================================================================
locals {
    custom_insights = yamldecode(file("${path.module}/../../../config/insights/custom.yml"))
}

//====================================================================================================
// Resource that will build out custom insights
//====================================================================================================
resource "sumologic_cse_custom_insight" "custom_insights" {
  for_each = { for insight in local.custom_insights : insight.index_key => insight }  

  enabled         = each.value.enabled
  name            = each.value.name
  description     = each.value.description
  ordered         = each.value.ordered
  rule_ids        = try(each.value.rule_ids, null) //Optional field as defined by the provider
  severity        = each.value.severity

  dynamic "dynamic_severity" {
    # A check to see if dynamic severity (an optional field) has a value present 
    for_each = try(each.value.dynamic_severity != null && length(each.value.dynamic_severity) > 0 ? [each.value.dynamic_severity] : [], [])

    # These convoluted looking allow the YAML file to have these fields in an arbitrary order
    content {
      minimum_signal_severity    = try(dynamic_severity.value[0].minimum_signal_severity, dynamic_severity.value[1].minimum_signal_severity)
      insight_severity           = try(dynamic_severity.value[0].insight_severity, dynamic_severity.value[1].insight_severity)
    }
  }

  signal_names    = try(each.value.signal_names, null) //Optional field as defined by the provider
  tags            = each.value.tags
}

