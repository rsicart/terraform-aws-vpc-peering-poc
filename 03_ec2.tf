resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDcjPZ4DTmMkczaGbJNXCjMBCdaV+ghp2XdQbxHWMUJ4EVFv6jRAmeQpI08mMT6h7qHjEJdGO/KFzTFG4N3KGIxEUJntfSjGn5UsHSyzlTAIAuupXdXZOFwY5ALA8WYIM+0vZPAFHC5M9Gf5ZEiJd16f0g86VKhLMvew43jTnWNof5NDn7VOJU1KnVthHugF4NBtvtDyQVwgbjXGvcGxfBidFqUyNwREzWdFCkWI7s7RpBoY2lB93IDX8DbrhL7RnBCvKVzWK51bQp9YpMu/7JwC827Dw7FNMx+hVUg+O2KeTDoErhNNVAC8VanqtPsr9L0bddIEuOjS3JkXu0MBElE6VbAQt9xIJCjxw8ZvSNDDAK0/C07m2QIuZfsb19euogaNo1ZVIiAMi78SioAfnP/raN9zqxe1tElMGr9oXxDeZab4h+UKBCGFJHfPWA+B67aB6UpgfT4mpGoc3YL2r8DRbi+fUWi1RRlDjPoNZnaocCOhhOlQBxJHrxTbGxTBFBWWkCszqVYXvmr6zNbXYneHKzbB3rov6xb3xS3j+czqRQT0qgSsJV3f4Q/Exk+xFF6kbZr7xIuaiL6WvPehZTI4zrnD4w6vSykNcSSF8B9/L+iv2a5ToUfqYPJ+xRQOz+N8YeyDUAVgufx0ghkOiGSSrvZf817jS7hiRJSoUnm7Q== parra@terraform-aws"
}

#
# vpc a
#
resource "aws_instance" "www-01" {
    ami = "ami-e79f8781"
    instance_type = "${var.instance_type_micro}"
    availability_zone = "${var.region}a"
    subnet_id = "${aws_subnet.a_public_subnet.id}"
    vpc_security_group_ids = [
	"${aws_security_group.allow_home_a.id}"
    ]
    key_name = "${aws_key_pair.deployer.key_name}"
    tags {
	Name = "www-01"
    }
}

resource "aws_eip" "eip_www-01" {
    instance = "${aws_instance.www-01.id}"
    vpc = true
}

#
# vpc b
#
resource "aws_instance" "www-02" {
    ami = "ami-e79f8781"
    instance_type = "${var.instance_type_micro}"
    availability_zone = "${var.region}a"
    subnet_id = "${aws_subnet.b_public_subnet.id}"
    vpc_security_group_ids = [
	"${aws_security_group.allow_home_b.id}"
    ]
    key_name = "${aws_key_pair.deployer.key_name}"
    tags {
	Name = "www-02"
    }
}

resource "aws_eip" "eip_www-02" {
    instance = "${aws_instance.www-02.id}"
    vpc = true
}
