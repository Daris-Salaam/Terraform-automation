
resource "aws_iam_policy" "lambda-policy" {
  name = "lambda-ec2-stop-start-new"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ec2:StartInstances",
          "ec2:StopInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "lambda-role" {
  name = "ec2-stop-start-new"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "lambda-ec2-role"
  }
}

resource "aws_iam_role_policy_attachment" "lambda-ec2-policy-attach" {
  role       = aws_iam_role.lambda-role.name
  policy_arn = aws_iam_policy.lambda-policy.arn
}

resource "aws_lambda_function" "ec2-stop" {
  filename      = "lambdastop.zip"
  function_name = "lambda-stop"
  role          = aws_iam_role.lambda-role.arn
  handler       = "lambdastop.lambda_handler"

  source_code_hash = filebase64sha256("lambdastop.zip")

  runtime = "python3.7"
  timeout = 63
}

resource "aws_cloudwatch_event_target" "lambda-stop-func" {
  rule      = aws_cloudwatch_event_rule.ec2-stop-rule.name
  target_id = "lambda-stop"
  arn       = aws_lambda_function.ec2-stop.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_stop" {
  statement_id  = "AllowExecutionFromCloudWatchStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2-stop.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2-stop-rule.arn
}

resource "aws_cloudwatch_event_rule" "ec2-stop-rule" {
  name                = "ec2-stop-rule"
  description         = "Trigger Stop Instance at 4:48pm "
  schedule_expression = "cron(18 11 * * ? *)"        #Scheduled at require intervals
  
}

resource "aws_lambda_function" "ec2-start" {
  filename      = "lambdastart.zip"
  function_name = "lambda-start"
  role          = aws_iam_role.lambda-role.arn
  handler       = "lambdastart.lambda_handler"

  source_code_hash = filebase64sha256("lambdastart.zip")

  runtime = "python3.7"
  timeout = 63
}

resource "aws_cloudwatch_event_target" "lambda-start-func" {
  rule      = aws_cloudwatch_event_rule.ec2-start-rule.name
  target_id = "lambda-start"
  arn       = aws_lambda_function.ec2-start.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_start" {
  statement_id  = "AllowExecutionFromCloudWatchStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2-start.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2-start-rule.arn
}

resource "aws_cloudwatch_event_rule" "ec2-start-rule" {
  name                = "ec2-start-rule"
  description         = "Trigger Start Instance at 4:51 pm"
  schedule_expression = "cron(21 11 * * ? *)"      #Scheduled at require intervals
  
}

