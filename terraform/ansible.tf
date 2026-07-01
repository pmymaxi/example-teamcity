resource "local_file" "inventory_templatefile_nexus" {
  content = templatefile("${path.module}/tpl/hosts.yml.tftpl",
    {
      ansible_host  = yandex_compute_instance.teamcity-stack["nexus-storage"].network_interface[0].nat_ip_address
      ansible_user = local.vm_each.nexus-storage.user
  })
  filename = "${abspath(path.module)}/ansible/infrastructure/inventory/cicd/hosts.yml"
}

resource "local_file" "vars_templatefile_nexus" {
  content = templatefile("${path.module}/tpl/nexus.yml.tftpl",
    {
      ansible_host  = yandex_compute_instance.teamcity-stack["nexus-storage"].network_interface[0].nat_ip_address
      ansible_user = local.vm_each.nexus-storage.user
      nexus_user_group: local.vm_each["nexus-storage"].group
      nexus_user_name: local.vm_each["nexus-storage"].user
  })
  filename = "${abspath(path.module)}/ansible/infrastructure/inventory/cicd/group_vars/nexus.yml"
}

resource "null_resource" "nexus_hosts_provision" {

  depends_on = [
    yandex_compute_instance.teamcity-stack["nexus-storage"],
    local_file.inventory_templatefile_nexus,
    local_file.vars_templatefile_nexus
    ]


  #Запуск ansible-playbook
  provisioner "local-exec" {
    # without secrets
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${abspath(path.module)}/ansible/infrastructure/inventory/cicd/hosts.yml ${abspath(path.module)}/ansible/infrastructure/site.yml"
    on_failure  = continue #Продолжить выполнение terraform pipeline в случае ошибок
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
  
  }
  triggers = {
    playbook_src_hash = file("${abspath(path.module)}/ansible/infrastructure/site.yml")
  }

}