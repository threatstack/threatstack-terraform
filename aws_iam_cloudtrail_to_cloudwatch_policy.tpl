{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailCreateLogStream",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream"
      ],
      "Resource": [
        "arn:aws:logs:${aws_region}:${aws_account_id}:log-group:/aws/cloudtrail/${aws_cloudtrail_name}:log-stream:${aws_account_id}_CloudTrail_${aws_region}*"
      ]
    },
    {
      "Sid": "AWSCloudTrailPutLogEvents",
      "Effect": "Allow",
      "Action": [
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:${aws_region}:${aws_account_id}:log-group:/aws/cloudtrail/${aws_cloudtrail_name}:log-stream:${aws_account_id}_CloudTrail_${aws_region}*"
      ]
    }
  ]
}
