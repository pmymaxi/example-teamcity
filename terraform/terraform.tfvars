each_vm = [
  {
    hostname          = "teamcity-server"
    vm_name           = "teamcity-server"
    user              = "ubuntu"
    family            = "container-optimized-image"
    platform_id       = "standard-v3"
    zone              = "ru-central1-a"
    cpu               = 4
    ram               = 4
    core_fraction     = 20
    disk_size         = 15
    disk_type         = "network-hdd"
    disk_auto_delete  = true
    preemptible       = true
    nat               = true
    ip_address        = "10.0.1.7"
    allow_stop_update = true
    container = {
      name = "teamcity-server"
      image = "jetbrains/teamcity-server"
      restartPolicy = "OnFailure"
      env = []
    }
  },
  {
    hostname          = "teamcity-agent"
    vm_name           = "teamcity-agent"
    user              = "ubuntu"
    family            = "container-optimized-image"
    platform_id       = "standard-v3"
    zone              = "ru-central1-a"
    cpu               = 2
    ram               = 4
    core_fraction     = 20
    disk_size         = 15
    disk_type         = "network-hdd"
    disk_auto_delete  = true
    preemptible       = true
    nat               = true
    ip_address        = "10.0.1.9"
    allow_stop_update = true
    container = {
      name = "teamcity-agent"
      image = "jetbrains/teamcity-agent"
      restartPolicy = "OnFailure"
      env = [
        {
          name = "SERVER_URL"
          value = "http://10.0.1.7:8111"
        }
      ]
    }
  },
  {
    hostname          = "nexus-storage"
    vm_name           = "nexus-storage"
    user              = "nexus"
    group             = "nexus"
    family            = "rocky-9-oslogin"
    platform_id       = "standard-v3"
    zone              = "ru-central1-a"
    cpu               = 2
    ram               = 4
    core_fraction     = 20
    disk_size         = 15
    disk_type         = "network-hdd"
    disk_auto_delete  = true
    preemptible       = true
    nat               = true
    ip_address        = "10.0.1.11"
    allow_stop_update = true
  }
]

vms_resources_metadata = {
  metadata = {
    serial-port-enable = "1"
  }
}
