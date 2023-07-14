resource "aws_instance" "web" {
  ami           = "ami-08ee87f57b38db5af"
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}