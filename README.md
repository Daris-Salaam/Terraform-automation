# Terraform-automation
 EC2 Instance Start/Stop Automation

This project provides a solution for automating the start and stop actions of EC2 instances in AWS. By using AWS Lambda functions and CloudWatch rules, 
you can schedule the start and stop operations at specific times, reducing manual effort and cost.

Installation

    Clone this repository to your local machine.
    Install the necessary dependencies.
    Configure your AWS credentials and region in the AWS CLI or by setting environment variables.
    Customize the instance IDs in the Lambda function scripts to match your EC2 instances.

Usage

    Deploy the Lambda functions to AWS using your preferred deployment method.
    Create CloudWatch rules to trigger the Lambda functions at the desired start and stop times.
    Verify that the EC2 instances start and stop automatically based on the scheduled rules.

Configuration

    Modify the schedule expressions in the CloudWatch rules to define the start and stop times.
    Adjust the instance IDs in the Lambda function scripts to target the desired EC2 instances.
    Customize the IAM policies and roles to grant necessary permissions to the Lambda functions.
