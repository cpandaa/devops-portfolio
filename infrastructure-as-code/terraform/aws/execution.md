# cd envs/dev
# export AWS_PROFILE=dev
# aws sso login --profile dev
#
# terraform init
# terraform plan  -var-file=dev.tfvars
# terraform apply -var-file=dev.tfvars
#
# terraform output web_public_ip
#
# terraform destroy -var-file=dev.tfvars
