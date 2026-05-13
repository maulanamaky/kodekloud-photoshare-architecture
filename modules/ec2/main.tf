resource "aws_instance" "photoshare_ec2" {
  ami                    = var.ami
  instance_type          = var.type
  subnet_id              = var.public_subnet_ids[0]
  iam_instance_profile   = aws_iam_instance_profile.photoshare_ec2_iam_profile.name
  vpc_security_group_ids = [aws_security_group.photoshare_ec2_securitygroup.id]

  associate_public_ip_address = var.associate_public_ip_address
  user_data_replace_on_change = var.user_data_replace_on_change

  key_name = aws_key_pair.photoshare_ec2_key.key_name

  tags = {
    Name = var.instance_name
  }

  user_data = var.user_data
}

resource "aws_iam_instance_profile" "photoshare_ec2_iam_profile" {
  name = "ec2-role-profile"
  role = var.ec2_iam_role
}

resource "aws_key_pair" "photoshare_ec2_key" {
  key_name   = var.key_pair_name
  public_key = var.pub_key
}
