resource "aws_ecr_repository" "default" {
  name                 = var.ecr_repo_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "default" {
  count      = var.enable_ecr_lifecycle ? 1 : 0
  repository = aws_ecr_repository.default.name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images when there are more than ${var.max_images} container images stored",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": ${var.max_images}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

data "aws_iam_policy_document" "ecs_ecr_read_perms" {
  statement {
    sid    = "ElasticContainerRegistryRead"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
    ]
    principals {
      type = "AWS"

      identifiers = concat(
      var.allowed_read_principals,
      var.allowed_write_principals
      )
    }
  }
}

data "aws_iam_policy_document" "ecr_read_and_write_perms" {
  source_json = data.aws_iam_policy_document.ecs_ecr_read_perms.json
  statement {
    sid    = "ElasticContainerRegistryWrite"
    effect = "Allow"

    actions = [
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]

    principals {
      type        = "AWS"
      identifiers = var.allowed_write_principals
    }
  }
}

resource "aws_ecr_repository_policy" "default" {
  repository = aws_ecr_repository.default.name
  policy     = data.aws_iam_policy_document.ecr_read_and_write_perms.json
}
