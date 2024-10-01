
resource "aws_key_pair" "instances_key_pair" {
  key_name   = "instances_key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAf6V4g7ahli0x4Z8D3cbC3ZeT5li7p63zldIU0Wcijj"
}
