resource "aws_iam_role" "ec2-role" {
 name = "ec2-role"

 assume_role_policy =  << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_managed_ec2"{
    role=aws_iam_role.ec2.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2"{
    name="ec2_profile"
    role=aws_iam_role.ec2.name
    tags=var.common_tags
}

resource "aws_instance" "ec2"{
    ami=var.ami
}