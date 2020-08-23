resource "aws_flow_log" "vpc" {
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.vpc_flow_log.arn
  iam_role_arn         = aws_iam_role.vpc_flow_log_writer.arn
  vpc_id               = var.vpc_id
  traffic_type         = "ALL"
  tags                 = var.tags
}

resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  name = "/aws/vpc/${var.vpc_id}"
  tags = var.tags
}

resource "aws_iam_role" "vpc_flow_log_writer" {
  name               = "${var.name}VPCFlowLogWriter"
  assume_role_policy = data.aws_iam_policy_document.assumerole_policy_for_vpc_flow_logs_service.json
  tags               = var.tags
}

data "aws_iam_policy_document" "assumerole_policy_for_vpc_flow_logs_service" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "vpc_flow_log_writer" {
  name   = "${var.name}VPCFlowLogWriter"
  policy = data.aws_iam_policy_document.vpc_flow_log_writer.json
}

data "aws_iam_policy_document" "vpc_flow_log_writer" {
  statement {
    effect = "Allow"
    resources = [
      aws_cloudwatch_log_group.vpc_flow_log.arn
    ]
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "vpc_flow_log_writer" {
  role       = aws_iam_role.vpc_flow_log_writer.name
  policy_arn = aws_iam_policy.vpc_flow_log_writer.arn
}
