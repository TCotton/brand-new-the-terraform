module "dynamodb_restaurants_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 4.0"

  name        = "${var.service_name}-restaurants-${var.stage_name}"
  hash_key    = "name"
  attributes  = [
    {
      name = "name"
      type = "S"
    }
  ]
}
