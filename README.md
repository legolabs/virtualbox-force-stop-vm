# virtualbox-force-stop-vm

### Bash script to force stop a hung Virtualbox VM in Linux

**Note**: you must be root to run the script

Sometimes powering off a VM results in a stuck message like "0%...10%...20%..." or whatever.
One easy way to get rid of the problem is to kill the VM process itself. To find its process PID out, a possibility is to check for the process that is using the VM Log file through lsof.

This script does this steps for you:

* Finds the VM log folder
* Finds the process using the log file
* Kills the process

Usage:
``` bash
./force-stop-vm.sh <vm_user> <vm_name>
```
