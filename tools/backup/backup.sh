#!/usr/bin/env bash

#This script backs up all program data file for restorability

## Control File Copy Command
cpycmd="rsync -azvh"

## Set Backup Directory here
backupDir=/opt/backup

## Programs we are backing up data for

# Mono keypairs
prgrmtrgt0=/home/plex/.config/.mono/keypairs/

# Sonarr
prgrmtrgt1=/home/plex/.config/NzbDrone/Backups/scheduled/

# Radarr
prgrmtrgt2=/home/plex/.config/Radarr/Backups/scheduled/

# lidarr
prgrmtrgt3=/home/plex/.config/Lidarr/Backups/scheduled/

# NzbGet
prgrmtrgt4=/opt/nzbget/nzbget.conf

# Deluge
prgrmtrgt5=/home/plex/.config/deluge

# Mylar
prgrmtrgt6=/opt/Mylar/mylar.db
prgrmtrgt6a=/opt/Mylar/config.ini

# Plex
prgrmtrgt7="/var/lib/plexmediaserver/Library/Application Support/Plex Media Server"

# Jackett
prgrmtrgt8=/home/plex/.config/Jackett/ServerConfig.json
progrmtrgt8a=/home/plex/.config/Jackett/Indexers

# Headphones
prgrmtrgt9=/opt/headphones/config.ini

# Entire Config Folder
prgrmdir1=/home/plex/.config/


################## End of Section ################


#Menu options
options[1]="Backup"
options[2]="Restore"


#Actions to take based on selection
function ACTIONS {
    if [[ ${choices[1]} ]]; then
        #Option 2 selected
        echo "Beginning backup"

# Backup predefined folders

# Create backupDir
mkdir $backupDir

# Mono
$cpycmd $prgrmtrgt0 $backupDir/prgrmtrgt0

# Sonarr
$cpycmd $prgrmtrgt1 $backupDir/prgrmtrgt1

# Radarr
$cpycmd $prgrmtrgt2 $backupDir/prgrmtrgt2

# Lidarr
$cpycmd $prgrmtrgt3 $backupDir/prgrmtrgt3

# NzbGet
$cpycmd $prgrmtrgt4 $backupDir/prgrmtrgt4

# Deluge
$cpycmd $prgrmtrgt5 $backupDir/prgrmtrgt5

# Mylar
$cpycmd $prgrmtrgt6 $backupDir/prgrmtrgt6

# Mylar
$cpycmd $prgrmtrgt6a $backupDir/prgrmtrgrt6a

# Plex
$cpycmd $prgrmtrgt7 $backupDir/prgrmtrgt7

# Jackett
$cpycmd $prgrmtrgt8 $backupDir/prgrmtrgt8

# Jackett
$cpycmd $progrmtrgt8a $backupDir/prgrmtrgt8a

# Headphones
$cpycmd $prgrmtrgt9 $backupDir/prgrmtrgt9

# Entire Config Folder
$cpycmd $prgrmdir1 $backupDir/prgrmdir1

fi
################# End Of Section ###################

if [[ ${choices[2]} ]]; then
       #Option 3 selected
       echo "Restoring your data, please wait..."

# Restore Data

# Mono
$cpycmd $backupDir/prgrmtrgt0 $prgrmtrgt0

# Sonarr
$cpycmd $backupDir/prgrmtrgt1 $prgrmtrgt1

# Radarr
$cpycmd $backupDir/prgrmtrgt2 $prgrmtrgt2

# Lidarr
$cpycmd $backupDir/prgrmtrgt3 $prgrmtrgt3

# NzbGet
$cpycmd $backupDir/prgrmtrgt4 $prgrmtrgt4

# Deluge
$cpycmd $backupDir/prgrmtrgt5 $prgrmtrgt5

# Mylarr
$cpycmd $backupDir/prgrmtrgt6 $prgrmtrgt6

# Mylarr
$cpycmd $backupDir/prgrmtrgt6a $prgrmtrgt6a

# Plex
$cpycmd $backupDir/prgrmtrgt7 $prgrmtrgt7

# Jackett
$cpycmd $backupDir/prgrmtrgt8 $prgrmtrgt8

# Jackett
$cpycmd $backupDir/prgrmtrgt8a $prgrmtrgt8a

#Headphones
$cpycmd $backupDir/prgrmtrgt9 $prgrmtrgt9

#Entire Config Folder
$cpycmd $backupDir/prgrmdir1 $prgrmdir1



   fi
}
#Variables
ERROR="Expected Error, please continue"

#Clear screen for menu
clear

#Menu function
function MENU {
    echo "Menu Options"
    for NUM in ${!options[@]}; do
        echo "[""${choices[NUM]:- }""]" $(( NUM+1 ))") ${options[NUM]}"
    done
    echo "$ERROR"
}

#Menu loop
while MENU && read -e -p "Select the desired options using their number (again to uncheck, ENTER when done): " -n1 SELECTION && [[ -n "$SELECTION" ]]; do
    clear
    if [[ "$SELECTION" == *[[:digit:]]* && $SELECTION -ge 1 && $SELECTION -le ${#options[@]} ]]; then
        (( SELECTION-- ))
        if [[ "${choices[SELECTION]}" == "+" ]]; then
            choices[SELECTION]=""
        else
            choices[SELECTION]="+"
        fi
            ERROR=" "
    else
        ERROR="Invalid option: $SELECTION"
    fi
done

ACTIONS
