#!/bin/bash
#title           :backup-vm.sh
#description     :This script will backup a Virtualbox VM
#author          :Andrea Gardoni @ Legolabs
#date            :20180828
#version         :0.1
#usage           :bash backup-vm.sh <vm_name> <destination_path>
#==============================================================================

printf "\n"


# Check arguments
if [ "$#" -ne 2 ]; then
  printf "Invalid number of arguments!\n\n"
  printf "Usage: $0 <vm_name> <destination_path>\n\n"
  exit 1
fi

VM_NAME=$1
DEST_PATH=$2


# Check if VM exists
printf "Looking for VM \"$VM_NAME\"... "
CHECKVM=`VBoxManage list vms | grep '"'$VM_NAME'"' | head -n 1`

if [ -z "$CHECKVM" ]
then
  printf "Not found! -> Quitting!\n\n"
  exit 2
else
  printf "Found\n"
fi


# Get VM folder
printf "Searching VM folder for %s... " "$VM_NAME"
#VM_FOLDER=`VBoxManage showvminfo "$VM_NAME" | grep "Log folder:" | sed 's/.*Log folder:\(.*\).*/\1/;t;d' | head -n 1 | sed -e 's/^[ \t]*//'`"/VBox.log"
VM_FOLDER=`VBoxManage list systemproperties | grep "Default machine folder:" | sed 's/.*Default machine folder:\(.*\).*/\1/;t;d' | head -n 1 | sed -e 's/^[ \t]*//'`/"$VM_NAME"

if [ -z "$VM_FOLDER" ]
then
  printf "Not found! Quitting!\n\n"
  exit 3
else
  printf "Found $VM_FOLDER\n"
fi


printf "Checking if VM folder exists... "
# Check if source folder exists
if [ ! -d "$VM_FOLDER" ]
then
  printf "Non found! Quitting!\n\n"
  exit 4
else
  printf "Found!\n"
fi


# Check if VM is running
printf "Checking if VM is running... "
VM_RUNNING=`VBoxManage list runningvms | grep '"'$VM_NAME'"' | head -n 1`

if [ -z "$VM_RUNNING" ]
then
  printf "Not running.\n"
else
  printf "Running.\n"
  printf "Trying to stop VM... "
  vboxmanage controlvm "$VM_NAME" savestate

  if [ $? -eq 0 ]
  then
    printf "Done\n"
  else
    printf "Failed! Check VM state ASAP!\n\n"
    exit 5
  fi
fi


# Sends file without compression and replace modified bytes without using temp file
# --delete is needed in order to remove old .sav file
printf "Starting sync with destination... "

rsync -a --inplace --delete "$VM_FOLDER" "$DEST_PATH"

if [ $? -eq 0 ]
then
  printf "Done\n"
else
  printf "Failed! Check backup consistency ASAP!\n"
fi


# Start VM, if it was previously running
if [ -z "$VM_RUNNING" ]
then
  printf "Not starting VM, it was not previously running\n"
else
  printf "Starting VM... "
  vboxmanage startvm "$VM_NAME" --type headless

  if [ $? -eq 0 ]
  then
    printf "Done\n"
  else
    printf "Failed! Check VM state ASAP!\n"
    exit 6
  fi
fi

printf "\nBackup complete!\n\n"


# Calculate and display duration
duration=$SECONDS

printf "\nBackup complete!\n"
printf "Operation took %02d:%02d\n\n" $(($duration / 60)) $(($duration % 60))

exit 0
