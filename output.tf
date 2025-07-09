output "ec2_endpoint_id" {
  value       = aws_ec2_instance_connect_endpoint.blue.id
  description = "EndpointID of the EC2 Instance Connect Endpoint for the blue security group"
}

output "orange_private_ip" {
  value       = aws_instance.orange.private_ip
  description = "Private IP address of the orange EC2 instance"

}