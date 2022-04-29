### Note that this example may create resources which can cost money. Run `$ terraform destroy` when you don't need these resources.


# Noname AWS EC2 Terraform Example

This terraform script will automatically create a Noname server installed on either Ubuntu (latest), AWS Linux 2 (latest), or RHEL 7 (latest). After instantiating resources, the Noname platform itself will be installed which takes 15-20 minutes at a minimum. You can use `sudo docker ps` to check when the docker images have been fully added; the instance will reboot after completing.

Note: Please remove Elastic IP resource if you are planning to access it using private IP.

## Installation


1. Update `variables.tf`
2. Run terraform:

```
$ terraform init && terraform apply
```

## Usage

Once your Noname platform is up and running navigate to https://<ec2_DNS_or_IP> and register your first admin account. Please do this immediately!
