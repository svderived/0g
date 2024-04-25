#!/bin/bash

# Define the URLs of the files you want to download
export URL1="https://raw.githubusercontent.com/svderived/0g/main/0g-installer.sh"
export URL2="https://raw.githubusercontent.com/svderived/0g/main/0g-run.sh"
export URL3="https://raw.githubusercontent.com/svderived/0g/main/0g-wallet.sh"

export FILE1=0g-installer.sh
export FILE2=0g-run.sh
export FILE3=0g-wallet.sh

# Use curl to download the files
curl -L $URL1 -o $FILE1
curl -L $URL2 -o $FILE2
curl -L $URL3 -o $FILE3

# Assign execute permissions to the downloaded files
chmod +x $FILE1
chmod +x $FILE2
chmod +x $FILE3

echo "Files have been downloaded and given execute permissions."
