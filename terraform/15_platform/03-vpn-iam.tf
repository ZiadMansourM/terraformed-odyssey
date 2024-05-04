# Steps:
# [1]: Establish trust between the SP and IdP.
#   - AWS IAM Identity Center is the SAML IdP.
#   - AWS Client VPN is the SAML SP.
# [2]: Create and configure Client VPN SAML applications in AWS IAM Identity Center.
#   - AWS Client VPN
#   - AWS Client VPN Self-Service
#   - One Time Configuration "ClickOps"
# [3]: Integrate the Client VPN SAML applications with IAM.
# [4]: Create and configure the Client VPN endpoint.

resource "aws_identitystore_group" "admins" {
  display_name      = "Administrators"
  description       = "Identity store Administrators group"
  identity_store_id = tolist(data.aws_ssoadmin_instances.iam_ic_instance.identity_store_ids)[0]
}

resource "aws_identitystore_user" "omnya" {
  display_name      = "Omnya El Lethy"
  identity_store_id = tolist(data.aws_ssoadmin_instances.iam_ic_instance.identity_store_ids)[0]
  name {
    given_name  = "Omnya"
    family_name = "El Lethy"
  }
  user_name = "el-lethy"
}

resource "aws_identitystore_user" "ziadh" {
  display_name      = "Ziad Hassanin"
  identity_store_id = tolist(data.aws_ssoadmin_instances.iam_ic_instance.identity_store_ids)[0]
  name {
    given_name  = "Ziad"
    family_name = "Hassanin"
  }
  user_name = "ziadh"
}

resource "aws_identitystore_group_membership" "omnya_admin" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.iam_ic_instance.identity_store_ids)[0]
  group_id          = aws_identitystore_group.admins.group_id
  member_id         = aws_identitystore_user.omnya.user_id
}

resource "aws_identitystore_group_membership" "ziadh_admin" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.iam_ic_instance.identity_store_ids)[0]
  group_id          = aws_identitystore_group.admins.group_id
  member_id         = aws_identitystore_user.ziadh.user_id
}

resource "aws_ssoadmin_application_assignment" "aws-client-vpn-developers" {
  application_arn = data.aws_ssoadmin_application.aws-client-vpn.application_arn
  principal_id    = aws_identitystore_group.admins.group_id
  principal_type  = "GROUP"
}

resource "aws_ssoadmin_application_assignment" "aws-client-vpn-self-service-admins" {
  application_arn = data.aws_ssoadmin_application.aws-client-vpn-self-service.application_arn
  principal_id    = aws_identitystore_group.admins.group_id
  principal_type  = "GROUP"
}

resource "aws_iam_saml_provider" "aws-client-vpn" {
  name                   = "aws-client-vpn"
  saml_metadata_document = file("${path.module}/metadata/aws-client-vpn.xml")
}

resource "aws_iam_saml_provider" "aws-client-vpn-self-service" {
  name                   = "aws-client-vpn-self-service"
  saml_metadata_document = file("${path.module}/metadata/aws-client-vpn-self-service.xml")
}
