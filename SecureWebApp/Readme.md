### To Deploy The Architecture Using Terraform

1. Ensure Terraform is installed
2. Clone repository and CD into SecureWebApp directory
3. Create `terraform.tfvars` with the following values for your own Azure Subscription:
```
subscription_id = ""
client_id       = ""
client_secret   = ""
tenant_id       = ""
vm_username     = "mamamia"
vm_password     = "P@ssw0rd1234"
```
4. Run `Terraform init`
5. Run `Terraform apply --auto-approve`
6. After Deploying it will print out the Application Gateway Public IP Address

Accessing the APP Gateway public ip over HTTP should bring up the Microsoft IIS Page

### Things Not Yet Done & Exploring

* Figuring out how to safely get SSL Certificate into Azure safely
