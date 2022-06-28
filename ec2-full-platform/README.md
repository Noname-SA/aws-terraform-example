> 🚧 **Warning**
> 
> This example will create resources which cost money. Run `$ terraform destroy` when you don't need these resources.

# Noname AWS EC2 Terraform Example

This terraform script will automatically create a Noname server installed on either Ubuntu (latest), AWS Linux 2 (latest), or RHEL 7 (latest). After instantiating resources, the Noname platform itself will be installed which takes 15-20 minutes at a minimum. You can use `sudo docker ps` to check when the docker images have been fully added; the instance will reboot after completing.

Note: Please remove Elastic IP resource if you are planning to access it using private IP.

## Installation

1. Rename `variables.tf.template` to `variables.tf`
2. Update `variables.tf`
    1. `name_prefix`: All created resources will have a Name tag added using this prefix. EG prefix: `noname-pov`
    2. `package_url`: Noname will have provided a limited-use URL for your on-premise package. Paste the URL in this variable for automatic platform setup.
    3. `os_types`: Which operating system (AMI) to use for the EC2 instance. This terraform script supports `AWS` for the latest AWS Linux 2, `UBUNTU` for the latest LTS version of Ubuntu, and `RHEL` for the latest RHEL 7.
    4. `access_key`: Access key for accessing AWS
    5. `secret_key`: Secret key for accessing AWS
    6. `noname_key_name`: Provide key name which will be used when access Noname EC2 via SSH. This key should already exist in the AWS account.
    7. Edit region/az/CIDR variables if necessary.
3. Run terraform:

```
$ terraform init && terraform apply
```

## Usage

Once your Noname platform is up and running navigate to https://<ec2_DNS_or_IP> and register your first admin account. Please do this immediately!
