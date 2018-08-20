#!/bin/bash
#title           :force-stop-vm.sh
#description     :This script will force stop a Virtualbox VM
#author          :andrea.gardoni@legolabs.it
#date            :20180820
#version         :0.1
#usage           :bash force-stop-vm.sh <vm_user> <vm_name>
#==============================================================================


USER=$1
VMNAME=$2

printf "\n"


# Check the script is being run by root user
if [[ $EUID -ne 0 ]]; then
  printf "This script must be run as root -> Quitting!\n\n"
  exit 1
fi


# Check arguments
if [ "$#" -ne 2 ]; then
  printf "Invalid number of arguments!\n\nUsage: $0 <vm_user> <vm_name>\n\n"
  exit 3
fi


# Check if user exists
id -u $USER > /dev/null 2>&1

if [ $? -eq 1 ]
then
  printf "User $USER doesn't exists -> Quitting!\n\n"
  exit 2
fi


# Check if VM exists for specified user
printf "Looking for VM \"$VMNAME\" for user \"$USER\"... "
CHECKVM=`sudo -u $USER VBoxManage list vms | grep '"'$VMNAME'"' | head -n 1`

if [ -z "$CHECKVM" ]
then
  printf "Not found! -> Quitting!\n\n"
  exit 4
else
  printf "Found\n"
fi


# Get VDI filename
printf "Searching for first attached disk for %s... " "$VMNAME"
VDI=`sudo -u $USER VBoxManage showvminfo "$VMNAME" | grep " (UUID: " | sed 's/.*): \(.*\) (UUID: .*/\1/;t;d' | head -n 1`

if [ -z "$VDI" ]
then
  printf "Not found! Quitting!\n\n"
  exit 5
else
  printf "Found $VDI\n"
fi


# Get PID of Virtualbox VM which is using VDI
printf "Searching for process using disk... "
PID=`lsof -t "$VDI" | head -n 1`

if [ -z "$PID" ]
then
  printf "Not found! -> Quitting!\n\n"
  exit 6
else
  printf "Found process %s\n" $PID
fi


# Kill process
printf "Killing process %s... " $PID
kill -9 $PID  2> /dev/null

if [ $? -eq 0 ]
then
  printf "Done\n\n"
else
  printf "Failed!\n\n-- Unable to stop process $PID! Try manually, if necessary --\n\n"
  exit 7
fi


# Exiting
exit 0
