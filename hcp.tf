#Configure core HCP components (HVN)

resource "hcp_hvn" "vault-hvn" {
    hvn_id = "vault-train-demo-hvn"
    cloud_provider = "aws"
    region = var.awsregion
    cidr_block = "172.25.16.0/20"
}

resource "hcp_aws_transit_gateway_attachment" "vault-hcp-tgwa" {
  depends_on = [
    aws_ram_principal_association.vault-ram-prin-assoc,
    aws_ram_resource_association.vault-ram-rec-assoc
  ]

  hvn_id = hcp_hvn.vault-hvn.hvn_id
  transit_gateway_attachment_id = "vault-train-tgw-attachment"
  transit_gateway_id = aws_ec2_transit_gateway.vault-tgw.id
  resource_share_arn = aws_ram_resource_share.vault-resource-share.arn
}

resource "hcp_hvn_route" "vault-hvn-route" {
  hvn_link = hcp_hvn.vault-hvn.self_link
  hvn_route_id = "hvn-tgw-route"
  destination_cidr = aws_vpc.vault-vpc.cidr_block
  target_link = hcp_aws_transit_gateway_attachment.vault-hcp-tgwa.self_link
}