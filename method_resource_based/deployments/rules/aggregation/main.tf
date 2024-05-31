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
resource "sumologic_cse_aggregation_rule" "agr-1" {
  enabled                = true
  name                   = "Multiple IPs authenticating to a single account"
  name_expression        = "Multiple IPs authenticating to single account"
  summary_expression     = "{{account_name}} has been authenticated to from {{ip_count}} unique IP addresses"
  description_expression = "Could suggest a possible compromise of this account, if the authenticated source IPs are not expected behavior from the user"
  match_expression       = "metadata_product = 'auth_logs'"

  aggregation_function {
    name      = "ip_count"
    function  = "count_distinct"
    arguments = ["src_ip"]
  }

  trigger_expression   = "ip_count > 10"

  entity_selector {
    entity_type = "_account_name"
    expression  = "account_name"
  }

  group_by_entity      = true
  group_by_fields      = ["account_name"]

  severity_mapping {
    type    = "fieldValueMapping"
    default = 2
    value {
      type = "greaterThan"
      from = 20
      to   = 5
    }
    value {
      type = "greaterThan"
      from = 40
      to   = 10
    }
  }

  window_size          = "CUSTOM"
  window_size_millis   = 2592000 # 30 days

  tags = [
    "_mitreAttackTechnique:T1078",
    "_mitreAttackTactic:TA0001"
  ]

  is_prototype         = false
}