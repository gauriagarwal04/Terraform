# provider "aws" {
#   alias = "accepter"

#   # Accepter's credentials.
# }

# data "aws_caller_identity" "peer" {
#   provider = aws.accepter
# }

resource "aws_vpc_peering_connection" "owner" {
    
    
    vpc_id = aws_vpc.vpc.id
    peer_vpc_id=aws_vpc.vpc-B.id
    #peer_owner_id = local.accepter_account_id
    auto_accept = true
    tags = {
        Name="peering_conn_A&B"
    }
    
}

# data "aws_caller_identity" "peer" {
#   provider = aws.accepter
# }

# # Requester's side of the connection.
# resource "aws_vpc_peering_connection" "peer" {
#   provider = aws.requester

#   vpc_id        = aws_vpc.main.id
#   peer_vpc_id   = aws_vpc.peer.id
#   peer_owner_id = data.aws_caller_identity.peer.account_id
#   auto_accept   = false

#   tags = {
#     Side = "Requester"
#   }
# }

# # Accepter's side of the connection.
# resource "aws_vpc_peering_connection_accepter" "peer" {
#   provider = aws.accepter

#   vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
#   auto_accept               = true

#   tags = {
#     Side = "Accepter"
#   }
# }

resource "aws_vpc_peering_connection" "owner_A-C" {
    
    
    vpc_id = aws_vpc.vpc.id
    peer_vpc_id=aws_vpc.vpc_c.id
    #peer_owner_id = local.accepter_account_id
    auto_accept = true
    tags = {
        Name="peering_conn_A&C"
    }
    
}