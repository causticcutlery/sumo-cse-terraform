//====================================================================================================
// Variable to store the YAML file in the configs folder
// This config file contains all the configs that will be pushed to CSE
//====================================================================================================
locals {
    tag_schemas = yamldecode(file("${path.module}/../../../config/tags/schema.yml"))
}

//====================================================================================================
// Resource that will build out tag schemas
//====================================================================================================
resource "sumologic_cse_tag_schema" "tag-1" {
  key           = "user_type"
  label         = "User Type"
  content_types = ["entity"]
  free_form     = true

  value_option {
    value = "Normal User"
    label = "Normal User"
  }

  value_option {
    value = "Local Admin"
    label = "Local Admin"
  }

  value_option {
    value = "Global Admin"
    label = "Global Admin"
  }
}
