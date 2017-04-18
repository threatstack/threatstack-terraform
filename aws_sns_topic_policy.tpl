{
	"Id": "TSTopicPolicy",
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "AWSCloudTrailSNSPolicy",
			"Action": "SNS:Publish",
            "Effect": "Allow",
            "Principal": {
            	"Service": "cloudtrail.amazonaws.com"
			},
			"Resource": "*"
        }
    ]
}
