
#!/bin/sh

echo "----------------------------------------"
echo "KIPR Controller Flasher"
echo "Author Zachary Sasser (zsasser@kipr.org)"
echo "----------------------------------------"

echo "Flashing: " $IMG

#Where is the image?
IMG="/home/lab/Desktop/Wombat/Wombat-25.8.img"

#Exclude this drive(s). Most systems will have sda as the primary drive, if this is on a system with multiple drives (that matter), modify this.
EXCLUDE="sda"

SIZE=$(du $IMG -h | grep -o "\b\w*\.\w*G\b")

echo "Pulling Devices and Filtering..."
#Pull the devices that aren't excluded
DEVICES=$(lsblk -l | grep -o "\bsd\w\b" | grep -v ${EXCLUDE})


#Get the number of devices pulled for progress update
NUM=$(lsblk -l | grep -o "\bsd\w\b" | grep -v -c ${EXCLUDE})
echo $NUM " devices pulled..."


#Make the program exit if we get any errors
set -o errexit


echo --------------
echo SETUP COMPLETE
echo --------------

#For every device that is plugged in
for DEVICE in ${DEVICES}
do
	echo "Writing to " $DEVICE " (in background)"
	(dd bs=4M if=$IMG oflag=direct iflag=direct of=/dev/$DEVICE && echo $DEVICE " Finished") &
done; wait

echo --------------------------
echo FINISHED WRITING TO DRIVES
echo --------------------------
