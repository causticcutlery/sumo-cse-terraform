
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
resource "sumologic_cse_outlier_rule" "olr-1" {
  index_key              = "olr-1"
  enabled                = true
  name                   = "Spike in Login Failures from a User"
  name_expression        = "Spike in Login Failures from a User"
  summary_expression     = "Excessive count of failure login events identified for user: {{user_username}} based on daily historic activity"
  description_expression = "Exceeded a normal baseline of login failures could indicate an attempt to brute force the account"
  match_expression       = "objectType = 'Authentication' AND normalizedAction = 'logon' AND success = false"

  aggregation_function {
    name      = "current"
    function  = "count"
    arguments = ["true"]
  }

  entity_selector {
    entity_type = "_username"
    expression  = "user_username"
  }

  floor_value            = 10
  group_by_fields        = ["user_username"]
  severity               = 4
  window_size            = "T24H"  # 24 hours
  baseline_window_size   = 604800000   # 7 days
  retention_window_size  = 7776000000  # 90 days
  deviation_threshold    = 2

  tags = [
    "_mitreAttackTactic:TA0006",
    "_mitreAttackTechnique:T1110"
  ]

  is_prototype = false
}
