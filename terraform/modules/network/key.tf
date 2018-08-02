resource "aws_key_pair" "key" {
  key_name   = "capgemkey"
  public_key = "${file("${var.path_to_public_key}")}"
}
