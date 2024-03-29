

resource "aws_iam_role" "ec2_s3_role" {
  name               = "EC2_S3_Access_Role"
  assume_role_policy = <<EOF
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

resource "aws_iam_policy" "s3_read_policy" {
  name        = "S3_Read_Policy"
  description = "Allows read access to S3 buckets and objects"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3:Describe*",
                "s3-object-lambda:Get*",
                "s3-object-lambda:List*"
            ],
            "Resource": "arn:aws:s3:::my-springboot-artifact/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3_read_attachment" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}

resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = "EC2_S3_Instance_Profile"
  role = aws_iam_role.ec2_s3_role.name
}


