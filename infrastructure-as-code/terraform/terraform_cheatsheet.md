# Terraform CLI Command Cheat Sheet (AWS + SSO + Enterprise)

---

## SECTION 1: AWS AUTHENTICATION (SSO / PROFILES)

### Configure AWS SSO profiles
aws configure sso --profile dev  
aws configure sso --profile test  
aws configure sso --profile prod  

### Login using SSO
aws sso login --profile dev  
aws sso login --profile test  

### Select AWS profile for Terraform
export AWS_PROFILE=dev  
export AWS_SDK_LOAD_CONFIG=1  

### Verify identity
aws sts get-caller-identity  

---

## SECTION 2: TERRAFORM INITIALIZATION & VALIDATION

terraform init  
terraform init -reconfigure  
terraform init -upgrade  

terraform validate  

terraform fmt  
terraform fmt -recursive  

---

## SECTION 3: PLAN / APPLY / DESTROY

terraform plan  
terraform plan -out=tfplan  

terraform apply  
terraform apply tfplan  
terraform apply -auto-approve  

terraform destroy  
terraform destroy -auto-approve  

---

## SECTION 4: VARIABLES & TFVARS

terraform apply -var="env=dev" -var="instance_type=t3.micro"  

terraform apply -var-file=dev.tfvars  

export TF_VAR_env=dev  
export TF_VAR_instance_type=t3.micro  

---

## SECTION 5: TARGETED OPERATIONS

terraform apply -target=aws_instance.web  

terraform apply -target=module.vpc.aws_subnet.private[0]  

---

## SECTION 6: STATE MANAGEMENT

terraform state list  

terraform state show aws_instance.web  

terraform state rm aws_instance.web  

terraform state pull  

terraform state push terraform.tfstate  

---

## SECTION 7: IMPORT EXISTING RESOURCES

terraform import aws_instance.web i-0abc123456789  

terraform import module.app.aws_lb.this arn:aws:elasticloadbalancing:...  

terraform import 'aws_instance.web[0]' i-abc123  

terraform import 'aws_s3_bucket.this["logs"]' my-logs-bucket  

---

## SECTION 8: WORKSPACES

terraform workspace list  

terraform workspace new dev  

terraform workspace select prod  

terraform workspace show  

---

## SECTION 9: REFRESH & DRIFT

terraform apply -refresh-only  

(terraform refresh – legacy)  

---

## SECTION 10: OUTPUTS

terraform output  

terraform output web_public_ip  

terraform output -json  

---

## SECTION 11: DEBUGGING & INSPECTION

export TF_LOG=DEBUG  
terraform plan  

unset TF_LOG  

terraform providers  

terraform version  

---

## SECTION 12: LOCKING & RECOVERY

terraform force-unlock LOCK_ID  

---

## SECTION 13: GRAPH & CONSOLE (ADVANCED)

terraform graph | dot -Tpng > graph.png  

terraform console  

---

## SECTION 14: MODULE MANAGEMENT

terraform get  

terraform init -upgrade  

---

## SECTION 15: CI / ENTERPRISE COMMANDS

terraform plan -out=tfplan  

terraform apply tfplan  

terraform plan -refresh-only  

---

## SECTION 16: COMMON ENVIRONMENT VARIABLES

AWS_PROFILE  
AWS_REGION  
AWS_SDK_LOAD_CONFIG  
TF_VAR_*  
TF_LOG  
TF_CLI_ARGS  

---

## SECTION 17: PARALLELISM & PERFORMANCE

### Default parallelism
(Default is 10 concurrent operations)

### Increase parallelism
terraform apply -parallelism=20  
terraform plan -parallelism=20  

### Reduce parallelism 
terraform apply -parallelism=2  

### Use in CI carefully
terraform apply -parallelism=10  
---

## FINAL NOTE

Terraform should be executed via CI/CD pipelines using:
- IAM Roles / AssumeRole
- Remote State + Locking
- Approved plans
- Least privilege access

