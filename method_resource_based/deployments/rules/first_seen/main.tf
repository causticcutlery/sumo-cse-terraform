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
resource "sumologic_cse_first_seen_rule" "fsr-1" {
  enabled               = true
  name                  = "First seen IP for user login"
  name_expression       = "First seen IP for user login"
  summary_expression    = "{{src_ip}} was seen for the first time logging into {{user_username}}"
  description_expression = "{{src_ip}} was seen for the first time logging into {{user_username}} in a 30 day baseline"
  baseline_type         = "PER_ENTITY"
  filter_expression     = "metadata_product = 'auth_logs'"
  group_by_fields       = []

  entity_selector {
    entity_type = "_username"
    expression  = "user_username"
  }

  entity_selector {
    entity_type = "_ip"
    expression  = "src_ip"
  }

  severity              = 1
  baseline_window_size  = 2592000000  # 30 days
  retention_window_size = 7776000000  # 90 days
  value_fields          = ["src_ip"]

  tags = [
    "_mitreAttackTechnique:T1078",
    "_mitreAttackTactic:TA0001"
  ]

  is_prototype          = false
}

