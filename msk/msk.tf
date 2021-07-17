
resource "aws_msk_cluster" "msk" {
  cluster_name           = var.cluster_name
  kafka_version          = var.cluster_version
  number_of_broker_nodes = length(aws_subnet.msk)

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    ebs_volume_size = 32
    client_subnets  = aws_subnet.msk.*.id
    security_groups = [aws_security_group.msk.id]
  }

  configuration_info {
    arn      = aws_msk_configuration.msk.arn
    revision = aws_msk_configuration.msk.latest_revision
  }

  #client_authentication {
  #  sasl {
  #    scram = true
  #  }
  #}

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.msk.arn
  }

  depends_on = [
    aws_kms_key.msk,
    aws_msk_configuration.msk,
  ]
}

resource aws_msk_configuration "msk" {
  name = var.cluster_name
  kafka_versions = [
    var.cluster_version
  ]

  server_properties = <<-EOT
    auto.create.topics.enable = true
    #auto.leader.rebalance.enable = true
    delete.topic.enable = true
    default.replication.factor = ${min(2, length(aws_subnet.msk))}
    num.partitions = 1
    num.io.threads = 4
    num.network.threads = 4
    num.replica.fetchers = 2
    #offsets.topic.num.partitions = 10
    offsets.topic.replication.factor = ${min(2, length(aws_subnet.msk))}
    offsets.retention.minutes = 1440
    #transaction.state.log.num.partitions = 10
    transaction.state.log.replication.factor = ${min(2, length(aws_subnet.msk))}
    unclean.leader.election.enable = true
  EOT
}

#resource "aws_msk_scram_secret_association" "msk" {
#  cluster_arn     = aws_msk_cluster.msk_cluster_scram.arn
#  secret_arn_list = [
#    aws_secretsmanager_secret.msk_user.arn
#  ]
#
#  depends_on = [
#    aws_secretsmanager_secret_version.msk_user
#  ]
#}
#
#resource "aws_secretsmanager_secret" "msk_user" {
#  name       = "MSK user credentials"
#  kms_key_id = aws_kms_key.msk.key_id
#}
#
#resource "aws_secretsmanager_secret_version" "msk_user" {
#  secret_id     = aws_secretsmanager_secret.msk_user.id
#  secret_string = jsonencode({
#    username = var.msk_username,
#    password = var.msk_password,
#  })
#}
#
#resource "aws_secretsmanager_secret_policy" "msk" {
#  secret_arn = aws_secretsmanager_secret.msk_user.arn
#  policy = jsonencode({
#    "Version" : "2012-10-17",
#    "Statement" : [
#      {
#        Sid : "AWSKafkaResourcePolicy",
#        Effect : "Allow",
#        Principal : {
#          "Service" : "kafka.amazonaws.com"
#        },
#        Action : "secretsmanager:getSecretValue",
#        Resource : aws_secretsmanager_secret.msk_user.arn
#    }]
#  })
#}

output "bootstrap_servers" {
  value = aws_msk_cluster.msk.bootstrap_brokers_tls
}