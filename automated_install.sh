#!/usr/bin/env bash

#
# Get Swap Memory Size, if it's less than 510MB, we will create own 512MB a temp swap file
#
create_swapfile()
{
  SWAPSIZE=`free | awk '/Swap/ { printf "%d", $2/1024 }'`
  while [[ "$SWAPSIZE" -lt "511" ]]; do
    echo "=============================================================="
    echo "Create a temporary SWAP file. It will disappear when reboot."
    echo "** Please consier to add a performanant SWAP file/parition. **"
    echo "=============================================================="
    dd if=/dev/zero of=/tmp/swapfile.swp bs=1M count=512 status=progress
    chmod 600 /tmp/swapfile.swp
    sudo mkswap /tmp/swapfile.swp
    sudo swapon /tmp/swapfile.swp
   #sudo swapoff /tmp/swapfile.swp # /var/tmp is remained when reboot
    SWAPSIZE=`free | awk '/Swap/ { printf "%d", $2/1024}'`
  done
  free
}

# Create temporary swpafile (384 MiB) 
create_swapfile

echo "=============================================================="
echo "            AiVA-96 Mycroft Platfrom Installation"
echo "=============================================================="
if [ ! -d mycroft-core ]; then
    git clone -b master https://github.com/MycroftAI/mycroft-core.git
fi

cd mycroft-core
git pull
source ./dev_setup.sh
