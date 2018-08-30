# virtualbox-toolbox
This container provides some tool to automate boring tasks in Linux VirtualBox environment


## force-stop-vm.sh
### Bash script to force stop a hung VirtualBox VM in Linux

**Note**: you must be root to run the script

Sometimes powering off a VM results in a stuck message like "0%...10%...20%..." or whatever.
One easy way to quickly solve is to kill the VM process itself. To find its process PID out, a possibility is to search for the process that is using the VM Log file through lsof.

This script does this steps for you:

* Finds the VM log folder
* Finds the process using the log file
* Kills the process

Usage:
``` bash
./force-stop-vm.sh <vm_user> <vm_name>
```

## backup-vm.sh
### Bash script to sync a copy of a VM in a modification-only way via rsync

One of the easiest way to take a safe full backup of a VM is to turn it down and make a full copy of its folder. This process is quite slow and, if the destination is a remote server, highly bandwith-hungry. Using rsync with inplace modification option activated reduces disk writes and data transfer (although it is a bit more CPU wiping). After the first full copy, then the following ones will transfer and write only modified blocks for each file.

This script does this steps for you:

* Finds the VM folder
* Puts VM in savestate (if it is running)
* Rsync the VM folder to a specified destination (also remote, if pubkey correctly configured on both sides)
* Starts VM (if it was previously running)

Usage
``` bash
./backup-vm.sh <vm_name> <destination_folder>
```

Example (local destination):
``` bash
./backup-vm.sh WindowsXP /media/ext_usb/vm_backups
```

Example (remote destination with pubkey):
``` bash
./backup-vm.sh WindowsXP agardoni@192.168.1.100:/home/agardoni/vm_backups
```
