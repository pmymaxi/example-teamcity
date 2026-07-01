# Выполняем через for_each, чтобы vm определили свой boot
data "yandex_compute_image" "container-optimized" {
  for_each = local.vm_each
  family   = each.value.family
}

resource "yandex_compute_instance" "teamcity-stack" {

  for_each = local.vm_each

  allow_stopping_for_update = each.value.allow_stop_update

  hostname    = each.value.hostname
  name        = each.value.vm_name
  platform_id = each.value.platform_id
  zone        = each.value.zone

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized[each.key].image_id
      size     = each.value.disk_size
      type     = each.value.disk_type
    }
    auto_delete = each.value.disk_auto_delete
  }

  scheduling_policy {
    preemptible = each.value.preemptible
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.develop.id
    ip_address = each.value.ip_address
    nat        = each.value.nat
  }

  metadata = merge(
    var.vms_resources_metadata.metadata,
    {
      ssh-keys = "${each.value.user}:${local.vms_ssh_public_root_key}"
      docker-container-declaration = local.declaration_container[each.key]
  })

}