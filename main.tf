resource "aws_ecr_repository" "default" {
  name  = "${var.ecr_repo_name}"
  tags  = "${var.tags}"
}

resource "aws_ecr_lifecycle_policy" "default" {
  count      = "${var.enable_ecr_lifecycle ? 1 : 0}"
  repository = "${aws_ecr_repository.default.name}"
  policy = <<EOF
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