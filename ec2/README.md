# AWS EC2 Terraform Script

This terraform script will automatically create a Noname server installed on the latest AWS Linux 2. After instantiating resources, the Noname platform itself will be installed which takes 15-20 minutes at a minimum. You can use `sudo docker ps` to check when the docker images have been fully added; the instance will reboot after completing.

Note: Please remove Elastic IP resource if you are planning to access it using private IP.

Usage
To run this example you need to execute:

1. Update `variables.tf`
2. Run terraform:

```
$ terraform init && terraform apply
```

## Note that this example may create resources which can cost money. Run `$ terraform destroy` when you don't need these resources.
