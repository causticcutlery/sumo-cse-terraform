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
resource "sumologic_cse_custom_insight" "cti-1" {
  enabled         = true
  name            = "Example Custom Insight"
  description     = "Example custom insight without dynamic severity"
  ordered         = true
  rule_ids        = ["MATCH-U00001"]
  severity        = "CRITICAL"

  tags            = "custom_insight"
}

resource "sumologic_cse_custom_insight" "cti-2" {
  enabled         = true
  name            = "Example Custom Insight"
  description     = "Example custom insight without dynamic severity"
  ordered         = true
  rule_ids        = ["MATCH-U00001"]
  severity        = "CRITICAL"

  dynamic "dynamic_severity" {
    content {
      minimum_signal_severity    = 8
      insight_severity           = "CRITICAL"
    }
  }

  tags    = "custom_insight"
}