#!/usr/bin/env bash

#This script backs up all program data file for restorability
##### Backup Variables ##########
##### Backup Variables ##########
## Control File Copy Command
cpycmd="rsync -razvh"

## Set Backup Directory here
backupDir=/home/plex/backup
## Programs we are backing up data for

# Mono keypairs
prgrmtrgt0=/home/plex/.config/.mono/keypairs

# Sonarr
prgrmtrgt1=/home/plex/.config/NzbDrone/Backups/scheduled/
bkupprgrmtrgt1=/home/plex/.config/NzbDrone

# Radarr
prgrmtrgt2=/home/plex/.config/Radarr/Backups/scheduled/
bkupprgrmtrgt2=/home/plex/.config/Radarr

# lidarr
prgrmtrgt3=/home/plex/.config/Lidarr/Backups/scheduled/
bkupprgrmtrgt3=/home/plex/.config/Lidarr

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
prgrmdir1=/home/plex/.config



################## End of Section ################


#Menu options

## Menu Functions
choice () {
    local choice=$1
    if [[ ${opts[choice]} ]] # toggle
    then
        opts[choice]=
    else
        opts[choice]=+
    fi
}

PS3='Please enter your choice: '
while :
do
    clear
    options=("Backup ${opts[1]}" "Restore ${opts[2]}" "Option 3 ${opts[3]}" "Done")
    select opt in "${options[@]}"
    do
        case $opt in
            "Backup ${opts[1]}")
                choice 1
## Menu Functions END ##

# Create backupDir
mkdir $backupDir

# Mono
$cpycmd $prgrmtrgt0/ $backupDir/prgrmtrgt0

# Sonarr
$cpycmd $prgrmtrgt1/$(ls -1t | head -1) $backupDir/prgrmtrgt1

# Radarr
$cpycmd $prgrmtrgt2/$(ls -1t | head -1) $backupDir/prgrmtrgt2

# Lidarr
$cpycmd $prgrmtrgt3/$(ls -1t | head -1) $backupDir/prgrmtrgt3

# NzbGet
$cpycmd $prgrmtrgt4 $backupDir/prgrmtrgt4

# Deluge
$cpycmd $prgrmtrgt5/ $backupDir/prgrmtrgt5

# Mylar
$cpycmd $prgrmtrgt6 $backupDir/prgrmtrgt6
$cpycmd $prgrmtrgt6a $backupDir/prgrmtrgrt6a

# Plex
$cpycmd $prgrmtrgt7 $backupDir/prgrmtrgt7

# Jackett
$cpycmd $prgrmtrgt8 $backupDir/prgrmtrgt8
$cpycmd $progrmtrgt8a/ $backupDir/prgrmtrgt8a

# Headphones
$cpycmd $prgrmtrgt9 $backupDir/prgrmtrgt9

# Entire Config Folder
$cpycmd $prgrmdir1/ $backupDir/prgrmdir1
break
;;
################# End Of Section ###################
          "Restore ${opts[2]}")


#Entire Config Folder
#$cpycmd $backupDir/prgrmdir1 $prgrmdir1 -A

# Mono
$cpycmd $backupDir/prgrmtrgt0/ $prgrmtrgt0 -A

# Sonarr
unzip $backupDir/prgrmtrgt1/$(ls -1t | head -1) -d $bkupprgrmtrgt1 -A

# Radarr
unzip $backupDir/prgrmtrgt2/$(ls -1t | head -1) -d $bkupprgrmtrgt2 -A

# Lidarr
unzip $backupDir/prgrmtrgt3/$(ls -1t | head -1) -d $bkupprgrmtrgt3 -A

# NzbGet
$cpycmd $backupDir/prgrmtrgt4 $prgrmtrgt4 -A

# Deluge
$cpycmd $backupDir/prgrmtrgt5/ $prgrmtrgt5 -A

# Mylarr
$cpycmd $backupDir/prgrmtrgt6 $prgrmtrgt6 -A
$cpycmd $backupDir/prgrmtrgt6a $prgrmtrgt6a -A

# Plex
$cpycmd $backupDir/prgrmtrgt7 $prgrmtrgt7 -A

# Jackett
$cpycmd $backupDir/prgrmtrgt8 $prgrmtrgt8 -A
$cpycmd $backupDir/prgrmtrgt8a/ $prgrmtrgt8a -A

break
;;


            "Option 3 ${opts[3]}")
                choice 3
                break
                ;;
            "Option 4 ${opts[4]}")
                choice 4
                break
                ;;
            "Done")
                break 2
                ;;
            *) printf '%s\n' 'invalid option';;
        esac
    done                                                                                                                done

printf '%s\n' 'Options chosen:'
for opt in "${!opts[@]}"
do
    if [[ ${opts[opt]} ]]
    then
        printf '%s\n' "Option $opt"
    fi
done
