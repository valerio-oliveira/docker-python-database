# variable "filename" {
#   default = "./templates/hosts_ident1.txt" # format("%s/%s", var.ansible_inventories, "hosts_ident")
# }

resource "local_file" "hosts_addresses" {
  content  = <<EOF
[all:vars]
main_db_private_dns     = ${module.main.database_data["private_dns"]}
main_db_private_ip      = ${module.main.database_data["private_ip"]}
main_db_public_dns      = ${module.main.database_data["public_dns"]}
main_db_public_ip       = ${module.main.database_data["public_ip"]}
main_app_private_dns    = ${module.main.application_data["private_dns"]}
main_app_private_ip     = ${module.main.application_data["private_ip"]}
main_app_public_dns     = ${module.main.application_data["public_dns"]}
main_app_public_ip      = ${module.main.application_data["public_ip"]}
replica_db_private_dns  = ${module.replica.database_data["private_dns"]}
replica_db_private_ip   = ${module.replica.database_data["private_ip"]}
replica_db_public_dns   = ${module.replica.database_data["public_dns"]}
replica_db_public_ip    = ${module.replica.database_data["public_ip"]}
replica_app_private_dns = ${module.replica.application_data["private_dns"]}
replica_app_private_ip  = ${module.replica.application_data["private_ip"]}
replica_app_public_dns  = ${module.replica.application_data["public_dns"]}
replica_app_public_ip   = ${module.replica.application_data["public_ip"]}

[being practical here]
ssh -i ${replace(var.ssh_public_key, ".pub", "")} admin@${module.main.database_data["public_ip"]}
ssh -i ${replace(var.ssh_public_key, ".pub", "")} admin@${module.main.application_data["public_ip"]}
ssh -i ${replace(var.ssh_public_key, ".pub", "")} admin@${module.replica.database_data["public_ip"]}
ssh -i ${replace(var.ssh_public_key, ".pub", "")} admin@${module.replica.application_data["public_ip"]}
EOF
  filename = format("%s/%s", var.ansible_inventories, "hosts_addresses")
}

resource "local_file" "hosts_ident" {
  content  = <<EOF
[database-main]
${module.main.database_data["public_ip"]}

[application-main]
${module.main.application_data["public_ip"]}

[database-replica]
${module.replica.database_data["public_ip"]}

[application-replica]
${module.replica.application_data["public_ip"]}

[application-all]
${module.main.application_data["public_ip"]}
${module.replica.application_data["public_ip"]}
EOF
  filename = format("%s/%s", var.ansible_inventories, "hosts_ident")
}
