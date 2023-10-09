resource "aws_ecr_repository" "hoangla-ecr" {
  name = "hoangla-ecr"
  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Name        = "hoangla-ecr"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}