#AWS Terraform Project: VPC with EC2 Instances and Application Load Balancer

This Terraform project creates a Virtual Private Cloud (VPC) with public and private subnets across two availability zones, sets up an Internet Gateway, configures route tables, launches web servers (EC2 instances) with a simple HTML page using user data, and creates an Application Load Balancer (ALB) to distribute traffic across these instances.

Project Structure

• main.tf: Defines the AWS resources including VPC, subnets, Internet Gateway, route tables, EC2 instances, and ALB. • variables.tf: Contains input variables used in the project (region, instance type, etc.). • userdata: Contains HTML files used as user data to host a simple web page on the EC2 instances. • outputs.tf: Specifies the outputs to be displayed after Terraform applies the configuration.

Usage

• Clone this repository to your local machine: • Initialise terraform configuration terraform init • Review planned changes terraform plan • Apply the terraform configuration to create infrastructure terraform apply

Accessing the Application Once the Terraform apply is complete, you can access your web application through the URL of the Application Load Balancer. The ALB will distribute traffic evenly across the EC2 instances, providing high availability and fault tolerance for your application.

Clean Up To avoid incurring charges, make sure to destroy the created resources after you are done testing: terraform destroy