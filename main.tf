locals {
  cluster_name = "cluster_name"
  namespace    = "default"
  sa_name      = "satest"
}

# 1.get EKS OIDC arn
data "aws_eks_cluster" "this" {
  name = local.cluster_name
}

# 2. define the trust relation between the role and service account
data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub"
      values   = ["system:serviceaccount:${local.namespace}:${local.sa_name}"]
    }

    principals {
      identifiers = [data.aws_eks_cluster.this.identity[0].oidc[0].issuer]
      type        = "Federated"
    }
  }
}

# 3. create a role for our test service account
resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.this.json
  name               = var.sa_name
}

# 4. create a permission policy
resource "aws_iam_policy" "this" {
  policy = file("./iam_policy.json")
  name   = "AWSTestCustomPolicy"
}

# 5. bind the policy to role
resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

# 6. get the role arn
output "role_arn" {
  value = aws_iam_role.this.arn
}
