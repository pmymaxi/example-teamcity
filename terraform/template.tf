# Формирование шаблона 
locals {
  declaration_container = {
    for vm_name, vm in local.vm_each :
    vm_name =>  vm.container != null ? templatefile("${path.module}/tpl/declaration.yaml.tftpl", 
  {
    name_container  = vm.container.name
    image_container = vm.container.image
    policy          = vm.container.restartPolicy
    env             = try(vm.container.env, [])
  }) : null
 }
}