terraform {
 required_providers {
  yandex = {
   source = "yandex-cloud/yandex"
  }
 }
}
provider "yandex" {
 token = "y0_AgAAAABmE_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx"
 cloud_id = "b1g5d1h1bstlaq9so8fs"
 folder_id = "b1guusc7jkhguhsmba7e"
 zone = "ru-central1-b"
}

resource "yandex_compute_instance" "vm-1"{
  name        = "terraform1"
  zone        = "ru-central1-b"
  hostname    = "nginx-srv"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8emvfmfoaordspe1jr"
      size        = 20
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

}

resource "yandex_compute_instance" "vm-2"{
  name        = "terraform2"
  zone        = "ru-central1-b"
  hostname    = "postgre-srv"

  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8emvfmfoaordspe1jr"
      size        = 20
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

}

resource "yandex_vpc_network" "network-1"{
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1"{
  name           = "subnet1"
  zone           = "ru-central1-b"
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = "${yandex_vpc_network.network-1.id}"
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "internal_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
}

output "external_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
}
