resource "aws_sns_topic" "sns_topic" {
  name              = "${var.asi}-${var.environment}-${var.sns_topic_name}"
  kms_master_key_id = "alias/aws/sns"
  tags = {
    Terraform   = "true"
    ASI         = "${var.asi}"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
  }
}
