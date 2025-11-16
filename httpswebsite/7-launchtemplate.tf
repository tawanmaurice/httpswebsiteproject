resource "aws_launch_template" "app1_LT" {
  name_prefix   = "app1_LT"
  image_id      = "ami-0cae6d6fe6048ca2c" # Amazon Linux 2 in us-east-1
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.app1-sg01-servers.id]

  # Install Apache, start it, and write a simple page
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd

    systemctl enable httpd
    systemctl start httpd

    cat << 'HTML' > /var/www/html/index.html
    <!doctype html>
    <html>
      <head>
        <title>Samurai Katana</title>
      </head>
      <body>
        <h1>Samurai Katana – Tawan Perry, Cloud Engineer</h1>
        <p>Served from $(hostname -f)</p>
      </body>
    </html>
    HTML
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "app1-instance"
      Project = "httpswebsite"
      Owner   = "Tawan"
    }
  }
}
