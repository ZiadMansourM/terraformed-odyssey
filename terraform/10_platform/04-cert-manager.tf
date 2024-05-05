resource "aws_iam_policy" "cert_manager_route53_access" {
  name        = "CertManagerRoute53Access"
  description = "Policy for cert-manager to manage Route53 hosted zone"
  depends_on = [
    aws_route53_zone.public,
    aws_route53_zone.private,
  ]
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "route53:GetChange",
      "Resource": "arn:aws:route53:::change/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/${aws_route53_zone.public.zone_id}",
        "arn:aws:route53:::hostedzone/${aws_route53_zone.private.zone_id}"
      ]
    }
  ]
}
EOF

  # [1]: The first Statement is to be able to get the current state 
  # of the request, to find out if dns record changes have been 
  # propagated to all route53 dns servers. 
  # [2]: The second statement one to update dns records such as txt 
  # for acme challange. We need to replace `<id>` with the hosted zone id.
}

# Create IAM role
resource "aws_iam_role" "cert_manager_acme" {
  name               = "cert-manager-acme"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer, "https://", "")}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${replace(data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer, "https://", "")}:sub": "system:serviceaccount:cert-manager:cert-manager"
        }
      }
    }
  ]
}
EOF
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "cert_manager_acme" {
  role       = aws_iam_role.cert_manager_acme.name
  policy_arn = aws_iam_policy.cert_manager_route53_access.arn
}

resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  namespace        = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "1.14.4"
  timeout          = 300
  atomic           = true
  create_namespace = true

  depends_on = [
    aws_iam_role_policy_attachment.cert_manager_acme,
  ]

  values = [
    <<YAML
installCRDs: true
# Helm chart will create the following CRDs:
# - Issuer
# - ClusterIssuer
# - Certificate
# - CertificateRequest
# - Order
# - Challenge


# Enable prometheus metrics, and create a service
# monitor object
prometheus:
  # Ref: https://github.com/cert-manager/cert-manager/blob/master/deploy/charts/cert-manager/README.template.md#prometheusenabled--bool
  enabled: true
  servicemonitor:
    enabled: true
    # Incase we had more than one prometheus instance
    # prometheusInstance: monitor


# DNS-01 Route53
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: ${aws_iam_role.cert_manager_acme.arn}
extraArgs:
# You need to provide the following to be able to use the IAM role.
# If you are using cluster issuer you need to replace it with:
- --cluster-issuer-ambient-credentials
- --issuer-ambient-credentials
# - --enable-certificate-owner-ref=true
- --dns01-recursive-nameservers-only
- --dns01-recursive-nameservers=8.8.8.8:53,1.1.1.1:53
    YAML
  ]
}

resource "kubectl_manifest" "cert_manager_cluster_issuer_public" {
  depends_on = [
    helm_release.cert-manager
  ]

  yaml_body = yamlencode({
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = "letsencrypt-dns01-production-cluster-issuer-public"
    }
    "spec" = {
      "acme" = {
        "server" = "https://acme-v02.api.letsencrypt.org/directory"
        "email"  = "ziadmansour.4.9.2000@gmail.com"
        "privateKeySecretRef" = {
          "name" = "letsencrypt-production-dns01-public-key-pair"
        }
        "solvers" = [
          {
            "dns01" = {
              "route53" = {
                "region"       = "${var.region}"
                "hostedZoneID" = "${aws_route53_zone.public.zone_id}"
              }
            }
          }
        ]
      }
    }
  })
}

resource "kubectl_manifest" "cert_manager_cluster_issuer_private" {
  depends_on = [
    helm_release.cert-manager
  ]

  yaml_body = yamlencode({
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = "letsencrypt-dns01-production-cluster-issuer-private"
    }
    "spec" = {
      "acme" = {
        "server" = "https://acme-v02.api.letsencrypt.org/directory"
        "email"  = "ziadmansour.4.9.2000@gmail.com"
        "privateKeySecretRef" = {
          "name" = "letsencrypt-production-dns01-private-key-pair"
        }
        "solvers" = [
          {
            "dns01" = {
              "route53" = {
                "region"       = "${var.region}"
                "hostedZoneID" = "${aws_route53_zone.private.zone_id}"
              }
            }
          }
        ]
      }
    }
  })
}
