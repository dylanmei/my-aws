my-aws
------

My own private EKS and other things.

## Steps

- Install [`aws-iam-authenticator`](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
- Copy `auto.tfvars.example` to `.auto.tfvars` and edit
- Execute `terraform apply` and 🤞️

## Notes

EKS Adapted from:
- https://learnk8s.io/terraform-eks
- https://github.com/k-mitevski/terraform-k8s
- https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html