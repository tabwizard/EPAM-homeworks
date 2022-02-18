output "public_ip" {
  value = "${aws_instance.wordpress.*.public_ip}"
}

output "alb_dns_name" {
  value = aws_alb.alb-main.dns_name
}
