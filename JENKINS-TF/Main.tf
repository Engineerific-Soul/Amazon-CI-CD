# Define an AWS security group named "Jenkins-sg"
resource "aws_security_group" "Jenkins-sg" {
  # Set the name of the security group
  name        = "Jenkins-Security Group"
  # Provide a description for the security group
  description = "Open 22,443,80,8080,9000"

  # Define ingress (incoming) rules for the security group
  ingress = [
    # Loop over a list of ports and create an ingress rule for each port
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      # Description for the ingress rule
      description      = "TLS from VPC"
      # Start port for the rule
      from_port        = port
      # End port for the rule (same as start port in this case)
      to_port          = port
      # Protocol to allow (TCP in this case)
      protocol         = "tcp"
      # CIDR block to allow traffic from (0.0.0.0/0 means any IP address)
      cidr_blocks      = ["0.0.0.0/0"]
      # Empty list for IPv6 CIDR blocks (not used here)
      ipv6_cidr_blocks = []
      # Empty list for prefix list IDs (not used here)
      prefix_list_ids  = []
      # Empty list for security groups (not used here)
      security_groups  = []
      # Boolean indicating whether to allow traffic from the security group's own instances (false means no)
      self             = false
    }
  ]

  # Define egress (outgoing) rules for the security group
  egress {
    # Allow traffic from any port
    from_port   = 0
    # Allow traffic to any port
    to_port     = 0
    # Allow all protocols
    protocol    = "-1"
    # CIDR block to allow traffic to (0.0.0.0/0 means any IP address)
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Add tags to the security group for identification
  tags = {
    Name = "Jenkins-sg"
  }
}

# Define an AWS EC2 instance resource
resource "aws_instance" "web" {
  # Specify the AMI (Amazon Machine Image) ID to use for the instance
  ami                    = "ami-0f5ee92e2d63afc18"
  # Specify the instance type (t2.large in this case)
  instance_type          = "t2.large"
  # Specify the key pair name to use for SSH access
  key_name               = "Mumbai"
  # Attach the security group created earlier to this instance
  vpc_security_group_ids = [aws_security_group.Jenkins-sg.id]
  # Provide a user data script to run on instance launch (install_jenkins.sh script)
  user_data              = templatefile("./install_jenkins.sh", {})

  # Add tags to the instance for identification
  tags = {
    Name = "Jenkins-sonar"
  }

  # Define the root block device configuration for the instance
  root_block_device {
    # Set the size of the root volume (30 GB in this case)
    volume_size = 30
  }
}

