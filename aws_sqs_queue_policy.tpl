{
	"Id": "TSQueuePolicy",
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Allow-TS-SendMessage",
			"Effect": "Allow",
			"Principal": "*",
			"Action": "sqs:SendMessage",
			"Resource": "*",
			"Condition": {
				"ArnEquals": {
                    "aws:SourceArn": "${sns_arn}"
                }
			}
		}
	]
}
