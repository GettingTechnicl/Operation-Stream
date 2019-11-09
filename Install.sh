#!/bin/bash

## Set your root download path here (ex. rootpath=/DATA)
rootpath=/DATA

## Set the drive path to a secondary drive, fuse, raid. On my setup this is a raid, and the purpose of This
## Is so when rclone downloads files they go to this drive, sparing needless writes on my ssd.
## This also benefits by allowing my torrents to continue seeding on this larger raid.
## (ex. driveArray=/RAID
driveArray=/RAID

## Set the user that EVERYTHING will run under here (ex. user=plex)
user=plex

## Set the location you want the applications to be installed in, I recommend
## /opt... (ex. app_Dir=/opt)
app_Dir=/opt

## Set the temporary Download location here (ex. /home/$user/Downloads)
dl_Dir=/home/$user/Downloads

## Set Logfile here (ex. )
Logfile=target_PWD/debug.log
## Don't touch this one
target_PWD=$(readlink -f .)
##############################  End Of Section ################################

######### Set Remote backup Info here ########

## Backup Local to Remote here
sshPort2="-e 'ssh -p 477'"
remSrc2=user@192.168.20.5

## Backup Remote to Local here
sshPort="-e 'ssh -p 478'"
remSrc=user@xxx.xxx.xxx.xxx
remDest=~/backup

############# End Section ###############

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

# Program Download links, for easier managment

dl_Mylar="https://github.com/evilhero/mylar -b development"

dl_Rclone=https://downloads.rclone.org/rclone-current-linux-amd64.zip

dl_Nzbget=https://nzbget.net/download/nzbget-latest-bin-linux.run

dl_Lidarr=https://github.com/lidarr/Lidarr/releases/download/v0.6.2.883/Lidarr.develop.0.6.2.883.linux.tar.gz

dl_Radarr="-L -O $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 )"

dl_Jackett=https://github.com/Jackett/Jackett/releases/download/v0.11.659/Jackett.Binaries.LinuxAMDx64.tar.gz

dl_Ombi=https://github.com/tidusjar/Ombi/releases/download/v3.0.4680/linux.tar.gz
##############################  End Of Section ################################

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
    options=("Install Applications ${opts[1]}" "Install Apache2 ${opts[2]}" "Create Backup ${opts[3]}" "Restore Backup ${opts[4]}" "Reboot ${opts[5]}" "Done ${opts[6]}" "Stop Services ${opts[7]}" "Start Services ${opts[8]}" "Sync 2 Remote${opts[9]}" "Sync 2 Local${opts[10]}")
    select opt in "${options[@]}"
    do
        case $opt in
            "Install Applications ${opts[1]}")
                choice 1
## Menu Functions END, choice 1 continues ##




## This section installs depencdencies for all applications
sudo apt update
sudo apt install gnupg ca-certificates -y
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF -y
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list -y
sudo apt update

sudo apt-get install unzip python3-pip python-setuptools python3 sqlite3 libsqlite3-dev python python-cherrypy git mergerfs libmono-cil-dev curl mediainfo liblttng-ust0 libcurl4 libssl1.0.0 libkrb5-3 zlib1g libicu60 libunwind8 libuuid1 -y
sudo apt-get upgrade python3 -y

python -m pip3 install --upgrade pip3 setuptools
pip3 install requests
pip3 install requests[security]
pip3 install requests-cache
pip3 install babelfish
pip3 install "guessit<2"
pip3 uninstall stevedore -y
pip3 install stevedore==1.19.1
pip3 install "subliminal<2"
pip3 install python-dateutil
pip3 install deluge-client
pip3 install qtfaststart
pip3 install python-qbittorrent



##############################  End Of Section ################################


## This section establishes the locations needed for the applications
sudo mkdir $rootpath
sudo chown -R $user.$user $rootpath
sudo chmod -R 755 $rootpath
cd $rootpath
mkdir FUSE lazylibrarian nzbGet sonarr deluge lidarr mylar radarr
cd FUSE
mkdir Rclone
cd $rootpath/lazylibrarian
mkdir deluge
cd $rootpath/nzbGet
mkdir Complete NzbDir queue temp Downloads scripts
cd $rootpath/sonarr
mkdir deluge nzbget
cd $rootpath/deluge
mkdir autoadd Completed Downloading Downloads_Inprogress torrent_history
cd $rootpath/lidarr
mkdir nzbget deluge
cd $rootpath/mylar
mkdir nzbget deluge
cd $rootpath/radarr
mkdir nzbget deluge


## Now we create application directories
sudo chown -R $user.$user $app_Dir
sudo chmod -R 755 $app_Dir
cd $app_Dir
mkdir Lidarr mp4_automator nzbget Mylar Ombi Radarr Jackett NzbDrone


## Now supplemental directories are created
sudo mkdir $driveArray
sudo chown -R $user.$user $driveArray
sudo chmod -R 755 $driveArray
cd $driveArray
mkdir FUSE tempStorage
cd FUSE
mkdir mergerfs
cd mergerfs
mkdir gdrive tmp_upload
cd $driveArray/tempStorage
mkdir deluge lazylibrarian lidarr radarr rclone_tmp_upload Sonarr

## Create symbolic links, maintaining organization and putting everything deluged
## On to your $driveArray

ln -s $driveArray/tempStorage/lazylibrarian $rootpath/lazylibrarian/deluge
ln -s $driveArray/tempStorage/sonarr $rootpath/sonarr/deluge
ln -s $driveArray/tempStorage/lidarr $rootpath/lidarr/deluge
ln -s $driveArray/tempStorage/mylar $rootpath/mylar/deluge
ln -s $driveArray/tempStorage/radarr $rootpath/radarr/deluge
ln -s $driveArray/tempStorage/deluge $rootpath/deluge/Completed

##############################  End Of Section ################################


## Now we need to install the applications

# Download and install Rclone
# https://rclone.org/install/
cd $dl_Dir
wget $dl_Rclone
unzip rclone-current-linux-amd64.zip
cd rclone-*-linux-amd64
sudo cp rclone /usr/bin/ -A
sudo chown root:root /usr/bin/rclone
sudo chmod 755 /usr/bin/rclone
sudo mkdir -p /usr/local/share/man/man1
sudo cp rclone.1 /usr/local/share/man/man1/ -A
sudo mandb
#rclone config
cd $dl_Dir
rm -rf *.zip


# Download and install lazylibrarian
# https://github.com/lazylibrarian/LazyLibrarian
cd $dl_Dir
git clone https://github.com/lazylibrarian/LazyLibrarian.git $app_Dir/lazylibrarian/


# Download and install nzbGet
# https://nzbget.net/
cd $dl_Dir
wget $dl_Nzbget
sh nzbget-latest-bin-linux.run --destdir /$app_Dir/nzbget


# Download and install sonarr
# https://github.com/Sonarr/Sonarr/wiki
cd $dl_Dir
rm -rf nzb*
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0xA236C58F409091A18ACA53CBEBFF6B99D9B78493
echo "deb http://apt.sonarr.tv/ master main" | sudo tee /etc/apt/sources.list.d/sonarr.list
sudo apt update
sudo apt install nzbdrone -y


# Download and install deluge
# https://dev.deluge-torrent.org
sudo add-apt-repository ppa:deluge-team/stable -y
sudo apt-get update
sudo apt-get install deluged deluge-web deluge-console -y


# Download and install lidarr
# https://github.com/Lidarr/Lidarr/wiki/Installation
wget $dl_Lidarr
tar -xzvf Lidarr.develop.0.6.2.883.linux.tar.gz -C $app_Dir/
rm -rf *.gz


# Download and install Mylar
# https://github.com/evilhero/mylar
cd $dl_Dir
git clone $dl_Mylar /$app_Dir/Mylar


# Download and install Radarr
# https://github.com/Radarr/Radarr
curl $dl_Radarr
tar -xzvf Radarr.develop.*.linux.tar.gz -C $app_Dir/
rm -rf *.gz


# Download and install sickbeard_mp4_automator
# https://github.com/mdhiggins/sickbeard_mp4_automator
cd $dl_Dir
git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git $app_Dir/mp4_automator


# Download and install mergerfs
sudo apt-get install mergerfs -y


# Download and install Jackett
wget $dl_Jackett
tar -xzvf Jackett.Binaries.LinuxAMDx64.tar.gz -C $app_Dir/
rm -rf *.gz
sudo $app_dir/Jackett/install_service_systemd.sh


# Download and install Ombi
wget $dl_Ombi
tar -xzf linux.tar.gz -C $app_Dir/Ombi/
rm -rf *.gz
##############################  End Of Section ################################

## Reset folder permissions to $user
sudo chown -R $user.$user $rootpath
sudo chown -R $user.$user $app_Dir
sudo chown -R $user.$user $driveArray

sudo chmod -R 755 $rootpath
sudo chmod -R 755 $app_Dir
sudo chmod -R 755 $driveArray

##############################  End Of Section ################################

## Current setup is temporary, in the future it will write the script utilizing
## Your designated $user

## Move service files and enable them
cd $target_PWD
sudo cp ConfigFiles/systemd_Services/* /etc/systemd/system/ -A

sudo systemctl enable DATA-FUSE-Rclone.mount
sudo systemctl enable deluge-web.service
sudo systemctl enable deluged.service
sudo systemctl enable jackett.service
sudo systemctl enable lidarr.service
sudo systemctl enable media.service
sudo systemctl enable nzbget.service
sudo systemctl enable ombi.service
sudo systemctl enable radarr.service
sudo systemctl enable rclone.service

sudo cp ConfigFiles/init.d_Services/* /etc/init.d/

sudo chmod +x /etc/init.d/lazylibrarian
sudo chmod +x /etc/init.d/mylar
sudo chmod +x /etc/init.d/nzbdrone

sudo update-rc.d lazylibrarian defaults
sudo update-rc.d mylar defaults
sudo update-rc.d nzbdrone defaults

sudo update-rc.d lazylibrarian enable
sudo update-rc.d mylar enable
sudo update-rc.d nzbdrone enable

sudo cp ConfigFiles/etc-default_Services/* /etc/default/ -A

## Everything is completed, reboot and all will be working upon startup.

break
;;
##############################  End Of Section ################################



          "Create Backup ${opts[3]}")

# Create backupDir
mkdir $backupDir

# Mono
$cpycmd $prgrmtrgt0/ $backupDir/prgrmtrgt0 > $Logfile

# Sonarr
$cpycmd $prgrmtrgt1/$(ls -1t | head -1) $backupDir/prgrmtrgt1 > $Logfile

# Radarr
$cpycmd $prgrmtrgt2/$(ls -1t | head -1) $backupDir/prgrmtrgt2 > $Logfile

# Lidarr
$cpycmd $prgrmtrgt3/$(ls -1t | head -1) $backupDir/prgrmtrgt3 > $Logfile

# NzbGet
$cpycmd $prgrmtrgt4 $backupDir/prgrmtrgt4 > $Logfile

# Deluge
$cpycmd $prgrmtrgt5/ $backupDir/prgrmtrgt5 > $Logfile

# Mylar
$cpycmd $prgrmtrgt6 $backupDir/prgrmtrgt6 > $Logfile
$cpycmd $prgrmtrgt6a $backupDir/prgrmtrgrt6a > $Logfile

# Plex
$cpycmd $prgrmtrgt7 $backupDir/prgrmtrgt7 > $Logfile

# Jackett
$cpycmd $prgrmtrgt8 $backupDir/prgrmtrgt8 > $Logfile
$cpycmd $progrmtrgt8a/ $backupDir/prgrmtrgt8a > $Logfile

# Headphones
$cpycmd $prgrmtrgt9 $backupDir/prgrmtrgt9 > $Logfile

# Entire Config Folder
$cpycmd $prgrmdir1/ $backupDir/prgrmdir1 > $Logfile
break
;;

################# End Of Section ###################
             "Restore Backup ${opts[4]}")



#Entire Config Folder
$cpycmd $backupDir/prgrmdir1/ $prgrmdir1 -A > $Logfile

# Mono
$cpycmd $backupDir/prgrmtrgt0/ $prgrmtrgt0 -A > $Logfile

# Sonarr
unzip $backupDir/prgrmtrgt1/$(ls -1t | head -1) -d $bkupprgrmtrgt1 -A > $Logfile

# Radarr
unzip $backupDir/prgrmtrgt2/$(ls -1t | head -1) -d $bkupprgrmtrgt2 -A > $Logfile

# Lidarr
unzip $backupDir/prgrmtrgt3/$(ls -1t | head -1) -d $bkupprgrmtrgt3 -A > $Logfile

# NzbGet
$cpycmd $backupDir/prgrmtrgt4 $prgrmtrgt4 -A > $Logfile

# Deluge
$cpycmd $backupDir/prgrmtrgt5/ $prgrmtrgt5 -A > $Logfile

# Mylarr
$cpycmd $backupDir/prgrmtrgt6 $prgrmtrgt6 -A > $Logfile
$cpycmd $backupDir/prgrmtrgt6a $prgrmtrgt6a -A > $Logfile

# Plex
$cpycmd $backupDir/prgrmtrgt7 $prgrmtrgt7 -A > $Logfile

# Jackett
$cpycmd $backupDir/prgrmtrgt8 $prgrmtrgt8 -A > $Logfile
$cpycmd $backupDir/prgrmtrgt8a/ $prgrmtrgt8a -A > $Logfile

break
;;

########## Section completed ##########

"Install Apache2 ${opts[2]}")
sudo add-apt-repository ppa:ondrej/apache2 -y
sudo apt update
sudo apt install apache2 -y
sudo apt install php7.2 -y
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_balancer
sudo a2enmod lbmethod_byrequests
sudo a2enmod headers
sudo a2enmod rewrite
sudo a2enmod php7.2
sudo a2enmod cache_disk
sudo a2enmod expires
sudo a2enmod ssl
suo a2dissite 000-default*
sudo cp $target_PWD/ConfigFiles/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf -A
sudo a2ensite 000-default*
sudo systemctl restart apache2

########### End Section ##############

break
;;
"Reboot ${opts[5]}")
sudo reboot now
    break
    ;;

############# End Section #############
"Done ${opts[6]}")
break 2
;;

########### End Section ##########

"Stop Services ${opts[7]}")
sudo service nzbdrone stop > $Logfile
sudo service radarr stop > $Logfile
sudo service lidarr stop > $Logfile
sudo service nzbget stop > $Logfile
sudo service deluged stop > $Logfile
sudo service deluge-web stop > $Logfile
sudo service mylar stop > $Logfile
sudo service plexmediaserver stop > $Logfile
sudo service jackett stop > $Logfile
sudo service headphones stop > $Logfile
break
;;
########### Section Completed #########

"Start Services ${opts[8]}")
sudo service nzbdrone start > $Logfile
sudo service radarr start > $Logfile
sudo service lidarr start > $Logfile
sudo service nzbget start > $Logfile
sudo service deluged start > $Logfile
sudo service deluge-web start > $Logfile
sudo service mylar start > $Logfile
sudo service plexmediaserver start > $Logfile
sudo service jackett start > $Logfile
sudo service headphones start > $Logfile
break
;;

############ End Section ############

"Sync 2 Local${opts[9]}")
$cpycmd $sshPort $remSrc:$remDest/ $backupDir > $Logfile
break
;;

############# End Section ##########

"Sync 2 Remote${opts[10]}")
$cpycmd $sshPort2 $backupDir/ $remSrc2:$remDest > $Logfile
break
;;

############# End Section ############


*) printf '%s\n' 'invalid option';;
esac
done
done


printf '%s\n' 'Options chosen:'
for opt in "${!opts[@]}"
do
if [[ ${opts[opt]} ]]
then
printf '%s\n' "Option $opt"
fi
done
