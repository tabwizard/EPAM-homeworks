output "ec2_instances_public_ip" {
  value = "${aws_instance.wordpress.*.public_ip}"
}

output "check_server_ip" {
  value = "http://${aws_alb.alb-main.dns_name}/ip.php"
}

output "wordpress_installed_from_instance" {
  value = "http://${aws_alb.alb-main.dns_name}/wp_installed.html"
}

output "application_load_balancer_dns_name" {
  value = "${aws_alb.alb-main.dns_name}"
}

output "keys" {
  value = "Ssh keys are in the \"./keys\" folder.\nFor connect to ec2 instance use \"ssh -i \"./keys/aws.pem\" ubuntu@xxx.xxx.xxx.xxx\"\nwhere \"aws\" - key_name variable from variables.tf\nAfter \"terraform destroy\" keys from folder \"./keys\" will be deleted."
}
