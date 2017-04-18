// AWS Iam role for cross account access

data "template_file" "aws_iam_assume_role_policy" {
  template = "${file("${path.module}/aws_iam_assume_role_policy.tpl")}"
  vars {
    threatstack_account_id = "${var.threatstack_account_id}"
    threatstack_external_id = "${var.threatstack_external_id}"
  }
}

data "template_file" "aws_iam_role_policy" {
  template = "${file("${path.module}/aws_iam_role_policy.tpl")}"
  vars {
    sqs_queue_arn = "${aws_sqs_queue.sqs.arn}"
    s3_resource = "${aws_sqs_queue.sqs.arn}/*"
  }
}


resource "aws_iam_role" "role" {
  name = "${var.aws_iam_role_name}"
  assume_role_policy = "${data.template_file.aws_iam_assume_role_policy.rendered}"
}

resource "aws_iam_role_policy" "role" {
  name = "${var.aws_iam_role_name}"
  role = "${aws_iam_role.role.id}"

  policy = "${data.template_file.aws_iam_role_policy.rendered}"
}

