resource "aws_launch_template" "app1_LT" {
  name_prefix   = "app1_LT"
  image_id      = "ami-0cae6d6fe6048ca2c"  # Amazon Linux 2023 in us-east-1
  instance_type = "t2.micro"

  # No key_name needed since SSH is not used
  # key_name = "MyLinuxBox"

  vpc_security_group_ids = [aws_security_group.app1-sg01-servers.id]

  user_data = base64encode(<<-EOT
#!/bin/bash
dnf update -y
dnf install -y httpd
systemctl start httpd
systemctl enable httpd

# Get the IMDSv2 token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Background curl requests
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s \
  http://169.254.169.254/latest/meta-data/local-ipv4 > /tmp/local_ipv4 &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s \
  http://169.254.169.254/latest/meta-data/placement/availability-zone > /tmp/az &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s \
  http://169.254.169.254/latest/meta-data/network/interfaces/macs/ > /tmp/macid &
wait

macid=$(cat /tmp/macid)
local_ipv4=$(cat /tmp/local_ipv4)
az=$(cat /tmp/az)
vpc=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s \
  http://169.254.169.254/latest/meta-data/network/interfaces/macs/$macid/vpc-id)

# Create beautiful HTML page
cat <<HTML > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Cloud Engineer – Tawan Perry</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background: linear-gradient(135deg, #1e3c72, #2a5298);
        color: white;
        margin: 0;
        padding: 0;
    }
    .container {
        max-width: 850px;
        margin: 80px auto;
        background: rgba(255, 255, 255, 0.12);
        padding: 40px;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.3);
        backdrop-filter: blur(10px);
    }
    h1 {
        text-align: center;
        font-size: 42px;
        margin-bottom: 10px;
        font-weight: bold;
    }
    h2 {
        text-align: center;
        font-size: 24px;
        margin-top: 0;
        font-weight: 300;
    }
    .details-box {
        margin-top: 30px;
        background: rgba(0, 0, 0, 0.3);
        padding: 25px;
        border-radius: 8px;
        line-height: 1.8;
        font-size: 18px;
    }
    .label {
        font-weight: bold;
        color: #FFD700;
    }
</style>
</head>
<body>

<div class="container">
    <h1>Tawan Perry</h1>
    <h2>Cloud Engineer</h2>

    <div class="details-box">
        <div><span class="label">Instance ID:</span> $macid</div>
        <div><span class="label">Private IP:</span> $local_ipv4</div>
        <div><span class="label">Availability Zone:</span> $az</div>
        <div><span class="label">VPC ID:</span> $vpc</div>
    </div>
</div>

</body>
</html>
HTML
EOT
  )
}
