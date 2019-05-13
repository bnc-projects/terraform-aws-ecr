# terraform-aws-ecr

This module simplifies the creation of an Amazon Elastic Container Registry (ECR) which can be accessed by different AWS accounts. The lifecycle policy rules are turned on by default but can be disabled if required.

## Examples

```
data "aws_iam_role" "ecr" {
  name = "ecr"
}

module "ecr" {
  source                   = "git::https://github.com/bnc-projects/terraform-aws-ecr.git?ref=master"
  allowed_read_principals  = concat("${formatlist("arn:aws:iam::%s:root", var.account_ids)}", ["arn:aws:iam::${var.account_id}:role/TravisCI"])
  allowed_write_principals = ["arn:aws:iam::${var.account_id}:role/TravisCI"]
  ecr_repo_name            = "${var.ecr_repo_name}"
  enable_ecr_lifecycle     = true
  max_images               = 50
  tags                     = "${merge(local.common_tags, var.tags)}"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allowed_read_principals | A list of account ids which are allowed to read from the repository | list | - | yes |
| allowed_write_principals | A list of principals which are allowed to write to the repository | list | - | yes |
| ecr_repo_name | The name of the repository | string | - | yes |
| enable_ecr_lifecycle | Set to false to prevent the module from creating a ECR lifecycle policy | boolean | `true` | no |
| max_images | The maximum number of images to store in the repository | number | `100` | no |
| tags | A map of tags to add to the appropriate resources | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| repository_url | The Elastic Container Registry URL |
