source "qemu" "lvm" {
  boot_command    = [
                    "<wait30>",
                    "<enter><wait5>", # Select English language
                    "<enter><wait5>", # Don't worry about updating the Subiquity installer
                    "<enter><wait5>", # Default keyboard layout
                    "<enter><wait5>", # Default network settings
                    "<enter><wait5>", # Proxy settings
                    "<enter><wait5>", # Mirror address
                    "<down><down><down><down><down><enter><wait5>", #storage layout
                    "<enter><wait5>", # File System Summary
                    "<down><enter><wait5>", # Confirm destructive action (aka install the OS)
                    "${var.ssh_username}<down>joebot01<down>${var.ssh_username}<down>${var.ssh_password}<down>${var.ssh_password}<down><enter><wait5>", # setup account
                    "<enter><tab><tab><enter><wait5>", # Enable OpenSSH
                    "<tab><enter><wait5>", # don't install any dang snaps
                    ]
  boot_wait       = "2s"
  cpus            = 2
  disk_size       = "24G"
  format          = "raw"
  headless        = var.headless
  http_directory  = var.http_directory
  iso_checksum    = "file:http://releases.ubuntu.com/bionic/SHA256SUMS"
  iso_target_path = "packer_cache/ubuntu.iso"
  iso_url         = "https://releases.ubuntu.com/bionic/ubuntu-18.04.6-live-server-amd64.iso"
  memory          = 2048
  qemuargs = [
    ["-vga", "qxl"],
    ["-device", "virtio-blk-pci,drive=drive0,bootindex=0"],
    ["-device", "virtio-blk-pci,drive=cdrom0,bootindex=1"],
    ["-device", "virtio-blk-pci,drive=drive1,bootindex=2"],
    ["-drive", "if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE.fd"],
    ["-drive", "if=pflash,format=raw,file=OVMF_VARS.fd"],
    ["-drive", "file=output-lvm/packer-lvm,if=none,id=drive0,cache=writeback,discard=ignore,format=raw"],
    ["-drive", "file=seeds-lvm.iso,format=raw,cache=none,if=none,id=drive1,readonly=on"],
    ["-drive", "file=packer_cache/ubuntu.iso,if=none,id=cdrom0,media=cdrom"]
  ]
  shutdown_command       = "sudo -S shutdown -P now"
  ssh_handshake_attempts = 500
  ssh_password           = var.ssh_ubuntu_password
  ssh_timeout            = "45m"
  ssh_username           = "ubuntu"
  ssh_wait_timeout       = "45m"
}

build {
  sources = ["source.qemu.lvm"]

  provisioner "file" {
    destination = "/tmp/curtin-hooks"
    source      = "${path.root}/scripts/curtin-hooks"
  }

  provisioner "shell" {
    environment_vars  = ["HOME_DIR=/home/ubuntu", "http_proxy=${var.http_proxy}", "https_proxy=${var.https_proxy}", "no_proxy=${var.no_proxy}"]
    execute_command   = "echo 'ubuntu' | {{ .Vars }} sudo -S -E sh -eux '{{ .Path }}'"
    expect_disconnect = true
    scripts           = ["${path.root}/scripts/curtin.sh", "${path.root}/scripts/networking.sh", "${path.root}/scripts/cleanup.sh"]
  }

  provisioner "file" {
    destination = "/home/ubuntu/src"
    source = "/home/joe/src/sw"
  }

  post-processor "compress" {
    output = "custom-ubuntu-lvm.dd.gz"
  }
}
