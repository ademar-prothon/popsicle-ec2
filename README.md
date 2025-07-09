# Popsicle EC2

A simple (and minimal!) terraform to :

- provision two EC2 instances named "blue" and "orange", using the latest stable Ubuntu 24.04 AMI.
- "blue" can SSH into "orange" but not the other way around.
- no VM is exposed directly on the internet
- code can be ran into any account, region, and VPC.


## Assumptions 

- provided VPC does not contain any subnets
- instances do not need to reach the internet 
- a proxy to test the setup is allowed (EC2 instance connect)
- user has AdministratorAccess permission set on an AWS account configured on the runing machine 

## Demo

- `terraform init`
- modify `variables.tf` file for your own default variables, or provide them on plan
- `terraform apply`
- open AWS management console, EC2, instances
- select the `blue` EC2 instance
- click up right yellow button `Connect`, `EC2 instance Connect`, `Connect using a Private IP`, use the VPC endpoint with the outputed ID, leave Username `ubuntu`
- once web terminal is up, `ssh ubuntu@<outputted orange IP>`
- choose yes when asked if key is trustable
- once SSHed in the orange instance, `ssh ubuntu@<blue IP>` will not work

## Possible improvements

- store the SSH private key in an AWS Secret
- more complex subnetwork setup for a blue subnet and an orange subnet 
- add a public subnet in the VPC, to host a NAT gateway and allow blue and orange instances outbound internet access
- a CI pipeline
- host the terraform state in a S3 bucket