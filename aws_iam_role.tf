// AWS Iam role for cross account access
local {
  sqs_queue_arn = aws_sqs_queue.sqs.arn
  s3_resource   = var.existing_cloudtrail != null ? var.existing_cloudtrail.s3_bucket_arn : aws_s3_bucket.bucket[0].arn
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.threatstack.account_id}:root"]
    }
    condition {
      test     = "StringEquals"
      values   = "sts:ExternalId"
      variable = var.threatstack.external_id
    }
  }
}

data "aws_iam_policy_document" "role_policy" {
  statement {
    actions = [
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetTrailStatus",
      "cloudtrail:ListPublicKeys",
      "cloudtrail:ListTags",
      "ec2:Describe*",
      "elasticloadbalancing:DescribeInstanceHealth",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeLoadBalancerPolicyTypes",
      "elasticloadbalancing:DescribeLoadBalancerPolicies",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "iam:GenerateCredentialReport",
      "iam:GetAccountPasswordPolicy",
      "iam:GetCredentialReport",
      "iam:GetAccountSummary",
      "iam:ListAttachedUserPolicies",
      "iam:ListUsers",
      "kms:GetKeyRotationStatus",
      "kms:ListKeys",
      "rds:DescribeAccountAttributes",
      "rds:DescribeCertificates",
      "rds:DescribeEngineDefaultClusterParameters",
      "rds:DescribeEngineDefaultParameters",
      "rds:DescribeDBClusterParameterGroups",
      "rds:DescribeDBClusterParameters",
      "rds:DescribeDBClusterSnapshots",
      "rds:DescribeDBClusters",
      "rds:DescribeDBInstances",
      "rds:DescribeDBLogFiles",
      "rds:DescribeDBParameterGroups",
      "rds:DescribeDBParameters",
      "rds:DescribeDBSecurityGroups",
      "rds:DescribeDBSnapshotAttributes",
      "rds:DescribeDBSnapshots",
      "rds:DescribeDBEngineVersions",
      "rds:DescribeDBSubnetGroups",
      "rds:DescribeEventCategories",
      "rds:DescribeEvents",
      "rds:DescribeEventSubscriptions",
      "rds:DescribeOptionGroups",
      "rds:DescribeOptionGroupOptions",
      "rds:DescribeOrderableDBInstanceOptions",
      "rds:DescribePendingMaintenanceActions",
      "rds:DescribeReservedDBInstances",
      "rds:DescribeReservedDBInstancesOfferings",
      "rds:ListTagsForResource",
      "s3:GetBucketAcl",
      "s3:GetBucketPolicy",
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
      "s3:GetBucketLogging",
      "sns:GetEndpointAttributes",
      "sns:GetPlatformApplicationAttributes",
      "sns:GetSMSAttributes",
      "sns:GetSubscriptionAttributes",
      "sns:GetTopicAttributes",
      "sns:ListEndpointsByPlatformApplication",
      "sns:ListPlatformApplications",
      "sns:ListSubscriptions",
      "sns:ListSubscriptionsByTopic",
      "sns:ListTopics"
    ]
    resources = "*"
    sid       = "ThreatStackPermissions"
  }
  statement {
    actions = [
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:DeleteMessage",
      "sqs:ListQueues",
      "sqs:ReceiveMessage"
    ]
    resources = [
      local.sqs_queue_arn
    ]
  }
  statement {
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    resources = [
      local.s3_resource,
      "${local.s3_resource}/*"
    ]
  }
}

resource "aws_iam_role" "role" {
  name = var.iam_role_name
  tags = var.tags

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy" "role" {
  name = var.iam_role_name
  role = aws_iam_role.role.id

  policy = data.aws_iam_policy_document.role_policy.json
}

