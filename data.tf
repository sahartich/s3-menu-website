data "aws_iam_policy_document" "restrict-ip" {
  statement {
    sid       = "Restrict-S3-Access-Home-IP"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.main.arn}/*"]
    condition {
      test     = "IpAddress"
      variable = "aws:sourceIp"
      values   = ["irrelevant"] # a script is running (refer to my terraform/python/dyndns project) to update this
    }
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

data "aws_route53_zone" "domain" {
  name = "${var.domain_name}."
}