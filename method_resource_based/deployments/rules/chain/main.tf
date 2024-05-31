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
resource "sumologic_cse_chain_rule" "chr-1" {
  enabled             = true
  name                = "Possible successful brute force"
  summary_expression  = "{{user_username}} has possibly been successfully brute forced"
  description         = "A series of login failures followed by a success, to suggest a successful brute force"

  entity_selector {
    entity_type = "_username"
    expression  = "user_username"
  }

  expressions_and_limit {
    expression = "success = false"
    limit      = 10
  }

  expressions_and_limit {
    expression = "success = true"
    limit      = 1
  }

  group_by_fields      = []
  ordered              = true
  severity             = 5
  window_size          = "T30M"  # Note the uppercase 'M' for minutes

  tags = [
    "_mitreAttackTechnique:T1078",
    "_mitreAttackTactic:TA0001"
  ]

  is_prototype         = false
}

