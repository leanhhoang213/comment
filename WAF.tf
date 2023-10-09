locals {
  cloudwatch_enable_status = true
}

resource "aws_wafv2_web_acl" "this" {
  name  = "hoangla-do-an"
  scope = "REGIONAL"
  visibility_config {
    cloudwatch_metrics_enabled = local.cloudwatch_enable_status
    metric_name                = "hoangla-do-an"
    sampled_requests_enabled   = true
  }
  default_action {
    allow {}
  }

  #Rule AWSManagedRulesBotControlRuleSet
  rule {
    name     = "AWS-AWSManagedRulesBotControlRuleSet"
    priority = 0
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "CategoryAdvertising"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "CategoryArchiver"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "CategoryContentFetcher"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "CategoryEmailClient"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "CategoryHttpLibrary"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "CategoryLinkChecker"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "CategoryMiscellaneous"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "CategoryMonitoring"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "CategoryScrapingFramework"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "CategorySearchEngine"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "CategorySecurity"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "CategorySeo"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "CategorySocialMedia"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "SignalAutomatedBrowser"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "SignalKnownBotDataCenter"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "SignalNonBrowserUserAgent"
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = local.cloudwatch_enable_status
      metric_name                = "AWS-ManagedRulesBotControlRuleSet"
      sampled_requests_enabled   = true
    }
  }

  #Rule AWSManagedRulesAmazonIpReputationList
  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "AWSManagedIPReputationList"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "AWSManagedReconnaissanceList"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "AWSManagedIPDDoSList"
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = local.cloudwatch_enable_status
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  #Rule AWSManagedRulesSQLiRuleSet
  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 2
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "SQLiExtendedPatterns_QUERYARGUMENTS"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "SQLi_QUERYARGUMENTS"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "SQLi_BODY"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "SQLi_URIPATH"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "SQLi_COOKIE"
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = local.cloudwatch_enable_status
      metric_name                = "AWS-AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # allow cho IP 
  rule {
    name     = "white-list-IP"
    priority = 4
    action {
      allow {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = local.cloudwatch_enable_status
      metric_name                = "white_list_IP"
      sampled_requests_enabled   = true
    }
    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ip_set.arn
      }
    }
  }

  # Mở kết nối path cho 1 ip cụ thể
  rule {
    name     = "white-list-Ip-and-Path"
    priority = 5
    action {
      allow {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = local.cloudwatch_enable_status
      metric_name                = "white_list_Ip_and_Path"
      sampled_requests_enabled   = true
    }
    statement {
      and_statement {
        statement {
          regex_pattern_set_reference_statement {
            arn = aws_wafv2_regex_pattern_set.path.arn
            field_to_match {
              single_header {
                name = "reference"
              }
            }
            text_transformation {
              priority = 1
              type     = "NONE"
            }
          }
        }
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.ip_set.arn
          }
        }
      }
    }
  }


  # # Chặn mọi kết nối từ các quốc gia được chỉ định
  #   rule {
  #     name     = "Block-country"
  #     priority = 6

  #     override_action {
  #       count {}
  #     }

  #     visibility_config {
  #       cloudwatch_metrics_enabled = local.cloudwatch_enable_status
  #       metric_name                = "my_web_acl3"
  #       sampled_requests_enabled   = true
  #     }

  #     statement {
  #       managed_rule_group_statement {
  #         name        = "AWSManagedRulesCommonRuleSet"
  #         vendor_name = "AWS"
  #         scope_down_statement {
  #           geo_match_statement {
  #             country_codes = ["US", "NL", "CN"]
  #           }
  #         }
  #       }
  #     }
  # 	}

  # Chặn mọi kết nối từ các quốc gia ngoại trừ quốc gia được cho phép
  rule {
    name     = "rule-country"
    priority = 6

    action {
      block {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = local.cloudwatch_enable_status
      metric_name                = "Rule-filter-country"
      sampled_requests_enabled   = true
    }

    statement {
      not_statement {
        statement {
          geo_match_statement {
            country_codes = ["VN"]
          }
        }
      }
    }
  }
}

# ALB name
locals {
  # nhập tên ALB được đặt
  lb_arn = ["hoangla-alb"]

}

data "aws_lb" "all_alb" {
  for_each = toset(local.lb_arn)
  name     = each.value
}

#Associate the rule with the web ACL
resource "aws_wafv2_web_acl_association" "waf_acl_ass" {
  for_each     = toset(local.lb_arn)
  resource_arn = data.aws_lb.all_alb[each.value].arn
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}

# Create cloudwatch_log_group
resource "aws_cloudwatch_log_group" "cloudwatch_log_group_waf" {
  name              = "aws-waf-logs-test-do-an"
  retention_in_days = 30
}

# ADD waf_logging
resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {
  log_destination_configs = [aws_cloudwatch_log_group.cloudwatch_log_group_waf.arn]
  resource_arn            = aws_wafv2_web_acl.this.arn
  depends_on              = [aws_cloudwatch_log_group.cloudwatch_log_group_waf]
}
