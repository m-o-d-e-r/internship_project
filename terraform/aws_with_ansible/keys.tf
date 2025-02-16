
resource "aws_key_pair" "instances_key_pair" {
  key_name   = "instances_key"
  public_key = var.vm_public_key
}
