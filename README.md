# virtualbox-force-stop-vm

### Bash script to force stop a hung Virtualbox VM in Linux

**Note**: you must be root to run the script

Sometimes powering off a VM results in a stuck message like "10%... 20%..." or whatever.
One easy way to get rid of the problem is to kill the VM process itself. To find its process PID out, a possibility is to check for the process that is using the VM virtual disk through lsof.

This script does this steps for you:

* Finds the first disk attached to VM
* Finds the process using that disk
* Kills the process

Usage:
``` bash
./force-stop.sh <vm_user> <vm_name>
```
