locals {
  url1 = ["/contact-us.html"]
}

resource "aws_wafv2_regex_pattern_set" "path" {
  name        = "path"
  description = "allow"
  scope       = "REGIONAL"
  dynamic "regular_expression" {
    for_each = local.url1
    content {
       regex_string = regular_expression.value
    }
  }
}

# resource "aws_wafv2_regex_pattern_set" "path-CIMB-GPAY-health" {
#   name        = "path-CIMB-GPAY-health"
#   description = "Allow path CIMB GPAY health"
#   scope       = "REGIONAL"
#   dynamic "regular_expression" {
#     for_each = local.url2
#     content {
#        regex_string = regular_expression.value
#     }
#   }
# }