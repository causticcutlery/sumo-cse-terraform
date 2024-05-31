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
resource "sumologic_cse_match_rule" "mar-1" {
  enabled                = true
  name                   = "Sudo Command Line Detection"
  name_expression        = "Sudo usage detected in command line"
  summary_expression     = "Sudo usage detected on {{device_hostname}}"
  description_expression = "Sudo usage could suggest privilege escalation if performed in an unexpected context"
  expression             = "contains(command_line, 'sudo')"

  entity_selector {
    entity_type = "_hostname"
    expression  = "device_hostname"
  }

  severity_mapping {
    type    = "constant"
    default = 1
  }

  tags = [
    "_mitreAttackTechnique:T1548",
    "_mitreAttackTactic:TA0004"
  ]

  is_prototype = false
}
