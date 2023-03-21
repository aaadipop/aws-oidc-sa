# Test AWS EKS OIDC Service Account permissions
Simple k8s deployment with alpine linux and aws cli binded to a service account to test OIDC Role Assume in AWS EKS

Assuming that you have an EKS Cluster with OpenId Connect Provider up and running, replace `cluster_name` in `main.tf`

### Run terraform configs
`terraform apply`

### Test k8s service account
deploy k8s service account and workload
`kubectl apply -f sample.yaml`
