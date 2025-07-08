# Popsicle EC2

A simple (and minimal!) terraform to :

- provision two EC2 instances named "blue" and "orange", using the latest stable Ubuntu 24.04 AMI.
- "blue" can SSH into "orange" but not the other way around.
- no VM is exposed directly on the internet
- code can be ran into any account, region, and VPC.


## Assumptions 

- provided VPC does not contain any subnets
- instances do not need to reach the internet 
- a proxy to test the setup is allowed

## Demo

- `tf init`
- modify `variables.tf` file for your own default variables, or provide them on plan
- terraform apply
- open AWS management console, EC2, instances
- select the `blue` EC2 instance
- connect, use private ip, use the VPC endpoint with the outputed ID
- once web terminal is up, `ssh ubuntu@<outputted orange IP>`
- choose yes when asked if key is trustable
- once in the orange instance, `ssh ubuntu@<blue IP>` will not work

## Possible improvements

- store the SSH private key in an AWS Secret
- more complex subnetwork setup to separate blue and orange even better
- add a public subnet in the VPC, to host a NAT gateway and allow blue and orange instances outbound internet access