#!/bin/bash
FILENAME=prom2v285.zip
#FOLDERNM="Prominence II [RPG] Server Pack v2.8.5"
VARIABLES="variables.txt"
PROPTMP="server.properties.tmp"
PROPERTIES="server.properties"
URL="https://www.curseforge.com/api/v1/mods/466901/files/5380858/download"

#Function to download modpack
dl_modpack() {
    curl -L $URL -o $FILENAME
}

unzip_modpack() {
    unzip $FILENAME
    #mv "$FOLDERNM"/* .
    rm -rf "$FOLDERNM"
}

#Moves into data directory
cd /data

#checks if there is a current modpack installation
if [ -f "$FILENAME" ]; then
    echo "Installation Exists"

    #Ensures there is a valid server.properties template file
    if [ -f "$PROPTMP" ]; then
        echo "Valid $PROPERTIES file"
    else
        echo "Missing $PROPTMP file: Unzipping modpack for replacement"
        unzip_modpack
        cp $PROPERTIES $PROPTMP
    fi
else
    #Clean up old files
    rm -rf config defaultconfigs mods

    #If there is no installation, it downloads the modpack and creates the installation
    dl_modpack
    unzip_modpack
    cp $PROPERTIES $PROPTMP
fi

#creates eula.txt file to accept minecraft's EULA
rm -rf eula.txt
echo eula=true > eula.txt

#Sets Variables
OLDVARS=$(cat $VARIABLES | grep JAVA_ARGS)
echo ""
echo "Variables:"
sed "s%$OLDVARS%JAVA_ARGS=\"$JAVA_ARGS\"%" $VARIABLES
sed -i "s%$OLDVARS%JAVA_ARGS=\"$JAVA_ARGS\"%" $VARIABLES

echo enable-rcon=true>>$PROPERTIES
echo rcon.password=$RCON_PASS>>$PROPERTIES
echo 'rcon.port=25575'>>$PROPERTIES
echo 'broadcast-rcon-to-ops=false'>>$PROPERTIES

#Changes permissions and starts server
chmod +x start.sh
source start.sh