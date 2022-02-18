################################################################################
# Application Load Balancer
################################################################################

resource "aws_alb_target_group" "alb-tg" {
  name     = "wordpress-tg"
  depends_on  = [aws_alb.alb-main]
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.wordpress-vpc.id}"
  target_type = "instance"
  health_check {    
    healthy_threshold   = 3    
    unhealthy_threshold = 10    
    timeout             = 5    
    interval            = 10    
    path                = "/"    
    port                = "80"  
  }
}

resource "aws_lb_target_group_attachment" "tgr_attachment" {
  count             = length(var.az)
  target_group_arn = aws_alb_target_group.alb-tg.arn
  target_id        = aws_instance.wordpress[count.index].id
  port             = 80
}

resource "aws_alb" "alb-main" {
  name            = "wordpress-alb"
  depends_on      = [aws_vpc.wordpress-vpc]
  subnets         = [aws_subnet.wordpress-subnet[0].id, aws_subnet.wordpress-subnet[1].id]
  security_groups = [aws_security_group.alb-sg.id]
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = "${aws_alb.alb-main.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb-tg.id}"
    type             = "forward"
  }
}
