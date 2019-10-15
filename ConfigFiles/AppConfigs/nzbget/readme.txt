# This is correct if you left everything default
# Change as necessary

# Paths
MainDir=/DATA/nzbGet
DestDir=${MainDir}/Complete
NzbDir=${MainDir}/NzbDir
QueueDir=${MainDir}/queue
TempDir=${MainDir}/temp
WebDir=${AppDir}/webui
ScriptDir=${MainDir}/scripts
Lockfile=${MainDir}/nzbget.lock
LogFile=${MainDir}/nzbget.log
ConfigTemplate=${AppDir}/webui/nzbget.conf.template
CertStore=${AppDir}/cacert.pem

# Security
DaemonUsername=plex

# Categories
lidarr
/DATA/lidarr/Complete
process.sh

radarr
/DATA/radarr/nzbget
NZBGetPostProcess.py

sonarr
/DATA/sonarr/nzbget
NZBGetPostProcess.py

mylar
/DATA/mylar/nzbget
ComicRN.py

# Extension scripts
Extensions=NZBGetPostProcess.py
ScriptOrder=process.sh, NZBGetPostProcess.py

# NZBGetPostProcess
MP4_Folder=/opt/mp4_automator/
SHOULDCONVERT=True
tag appropriately

#PROCESS.SH
POSTPROCESS_SUCCESS=93
POSTPROCESS=ERROR=94
