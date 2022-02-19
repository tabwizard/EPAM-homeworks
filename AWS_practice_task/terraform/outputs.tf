output "ec2_instances_public_ip" {
  value = "${aws_instance.wordpress.*.public_ip}"
}

output "application_load_balancer_dns_name" {
  value = aws_alb.alb-main.dns_name
}

output "keys" {
  value = "Ssh keys are in the \"./keys\" folder.\nFor connect to ec2 instance use \"ssh -i \"./keys/aws.pem\" ubuntu@xxx.xxx.xxx.xxx\"\nwhere aws - key_name variable from variables.tf\nAfter \"terraform destroy\" folder ./keys will be deleted."
}
