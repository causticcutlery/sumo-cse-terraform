//====================================================================================================
// Variable to store the YAML file in the configs folder
// This config file contains all the configs that will be pushed to CSE
//====================================================================================================
locals {
    rules_threshold = yamldecode(file("${path.module}/../../../config/rules/threshold.yml"))
}

//====================================================================================================
// Resource that will build out threshold rules
//====================================================================================================
resource "sumologic_cse_threshold_rule" "thr-1" {
  enabled              = true
  name                 = "Excessive Sharepoint Downloads"
  summary_expression   = "{{user_username}} has downloaded a large amount of files"
  description          = "An excessive amount of file downloads could indicate an attempt to exfiltrate data."
  expression           = "metadata_vendor = 'O365' and action = 'download'"

  entity_selector {
    entity_type = "_username"
    expression  = "user_username"
  }

  count_distinct       = false
  count_field          = "filename"
  group_by_fields      = ["user_username"]
  limit                = 1000
  severity             = 5
  window_size          = "T30M"  # 30 minutes

  tags = [
    "_mitreAttackTechnique:T1567"
  ]

  is_prototype = false
}
