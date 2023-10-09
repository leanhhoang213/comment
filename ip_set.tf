resource "aws_wafv2_ip_set" "ip_set" {
  name               = "allow-IP"
  description        = "allow"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["10.12.5.29/32"]
}

# resource "aws_wafv2_ip_set" "ip_set1" {
#   name               = "allow-path-pawn"
#   description        = "allow-path-pawn-follow-ip"
#   scope              = "REGIONAL"
#   ip_address_version = "IPV4"
#   addresses          =  [""]
# }
