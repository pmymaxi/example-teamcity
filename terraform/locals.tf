/* Преобразуем each_vm из list в map, так как for_each ожидает map в yandex_compute_instance.vm_db, 
type=list(object({})) определен в задании 2 п.2 */
locals {
  vm_each = {
    for vm in var.each_vm :
    vm.vm_name => vm
  }
}

/*Создаем переменную в которую пробрасываем public key ssh с использованием дополнительной 
функцией pathexpand для определениия полного пути по ~, будем указывать в metadata instance */
locals {
  vms_ssh_public_root_key = file(pathexpand("~/.ssh/id_ed25519.pub"))
}