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
resource "sumologic_cse_schema_rule" "tag_schemas" {
  for_each = { for tag_schema in local.tag_schemas : tag_schema.index_key => tag_schema }  

  key              = each.value.key
  label            = each.value.label
  content_types    = each.value.content_types
  free_form        = each.value.free_form

  dynamic "value_options" {
    for_each = each.value.value_options

    content {
      value    = value_options.value.value
      label    = value_options.value.label
      link     = try(value_options.value.link, null) //Optional field as defined by the provider
    }
  }
}
