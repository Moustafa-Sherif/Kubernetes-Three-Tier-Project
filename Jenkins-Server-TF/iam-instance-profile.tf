/*IAM instance profiles are a means of securely delivering AWS credentials to EC2 instances. 
They are used to grant permissions to EC2 instances, allowing them to interact with other AWS services. */
resource "aws_iam_instance_profile" "instance-profile" {
  name = "Jenkins-instance-profile"
  role = aws_iam_role.iam-role.name
}