resource "aws_iam_role" "hoangla_ecs_role" {
  name = "hoangla-ecs-role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2008-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ecs-tasks.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_policy" "hoangla_policy" {
  name        = "hoangla-policy"
  description = "An example IAM policy"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "autoscaling-plans:*",
          "application-autoscaling:*",
          "elasticloadbalancing:*",
          "servicediscovery:*",
          "iam:PassRole",
          "codecommit:GitPull",
          "s3:GetObject",
          "s3:PutObject",
          "lambda:UpdateFunctionCode",
          "cloudfront:CreateInvalidation",
          "ecr:PutImage",
          "ecs:UpdateService",
          "ecs:UpdateCapacityProvider",
          "ecs:RegisterTaskDefinition",
          "s3:ListBucket",
          "ecr:GetAuthorizationToken",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:BatchCheckLayerAvailability"
        ],
        Effect   = "Allow",
        Resource = "*",
        Sid      = "VisualEditor0",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "hoangla_att_policy0" {
  policy_arn = aws_iam_policy.hoangla_policy.arn
  role       = aws_iam_role.hoangla_ecs_role.name
}

resource "aws_iam_role_policy_attachment" "hoangla_att_policy1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
  role       = aws_iam_role.hoangla_ecs_role.name
}

resource "aws_iam_role_policy_attachment" "hoangla_att_policy2" {
  role       = aws_iam_role.hoangla_ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "hoangla_att_policy3" {
  role       = aws_iam_role.hoangla_ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}