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

## Don't touch this one
target_PWD=$(readlink -f .)

##############################  End Of Section ################################
# Program Download links, for easier managment

dl_Rclone=https://downloads.rclone.org/rclone-current-linux-amd64.zip

dl_Nzbget=https://nzbget.net/download/nzbget-latest-bin-linux.run

dl_Lidarr=https://github.com/lidarr/Lidarr/releases/download/v0.6.2.883/Lidarr.develop.0.6.2.883.linux.tar.gz

dl_Radarr="-L -O $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 )"

dl_Jackett=https://github.com/Jackett/Jackett/releases/download/v0.11.659/Jackett.Binaries.LinuxAMDx64.tar.gz

dl_Ombi=https://github.com/tidusjar/Ombi/releases/download/v3.0.4680/linux.tar.gz
##############################  End Of Section ################################
## This section installs depencdencies for all applications
sudo apt update
sudo apt install gnupg ca-certificates -y
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
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
mkdir Lidarr mp4_automator nzbget Mylar Ombi Radarr jackett NzbDrone


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
sudo cp rclone /usr/bin/
sudo chown root:root /usr/bin/rclone
sudo chmod 755 /usr/bin/rclone
sudo mkdir -p /usr/local/share/man/man1
sudo cp rclone.1 /usr/local/share/man/man1/
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
sudo add-apt-repository ppa:deluge-team/stable
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
git clone https://github.com/evilhero/mylar -b development /$app_Dir/Mylar


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
sudo cp ConfigFiles/systemd_Services/* /etc/systemd/system/

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

sudo cp ConfigFiles/etc-default_Services/* /etc/default/

##############################  End Of Section ################################

## Everything is completed, reboot and all will be working upon startup.

#sudo reboot now
