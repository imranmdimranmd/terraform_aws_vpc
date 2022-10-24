# # **AWS Infrastructure**
This project is useful to create an AWS infrastucture 

## key pair creation

```
ssh-keygen -t ed25519
```
## variable using and its preference
```
terraform console
terraform apply -replace aws_instance.main
terraform console -var="host_os=unix"
terraform console -var-file="dev.tfvars"
terraform console -var="host_os=windows"
```