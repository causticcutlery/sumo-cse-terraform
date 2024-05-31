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
resource "sumologic_cse_rule_tuning_expression" "ter-1" {
  name        = "Global Rule"
  description = "I am an example of a global rule"
  expression  = "expression here"
  enabled     = true
  exclude     = true
  is_global   = true
  rule_ids    = []
}

resource "sumologic_cse_rule_tuning_expression" "ter-2" {
  name        = "Non Global Rule"
  description = "I am an example of a non-global rule"
  expression  = "expression here"
  enabled     = true
  exclude     = true
  is_global   = false
  rule_ids    = [
    "RULE-00001",
    "RULE-00002",
    "RULE-00003"
  ]
}
