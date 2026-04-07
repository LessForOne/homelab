data "xenorchestra_pool" "pool" {
  name_label = "xcp-ng-1"
}

data "xenorchestra_sr" "local_storage" {
  name_label = "NFS-SR-DEBIAN"
  pool_id = data.xenorchestra_pool.pool.id
}

data "xenorchestra_template" "template" {
  name_label = "base-debian12"
}

data "xenorchestra_network" "net" {
  name_label = "Pool-wide network associated with eth0"
}



resource "xenorchestra_vm" "bar" {
    for_each = var.vms
    memory_max = each.value.ram
    cpus = each.value.cpu
    name_label = each.key
    template = data.xenorchestra_template.template.id

    disk {
        sr_id = data.xenorchestra_sr.local_storage.id
        name_label = "${each.key}-disk"
        size = each.value.disk
    }

    network {
        network_id = data.xenorchestra_network.net.id
    }

  }

