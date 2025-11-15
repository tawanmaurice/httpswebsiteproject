resource "aws_launch_template" "app1_LT" {
  name_prefix   = "app1_LT"
  image_id      = "ami-0cae6d6fe6048ca2c"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.app1-sg01-servers.id]

  # rest of your launch template (user_data, etc.) stays the same
}
