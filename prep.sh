#!/bin/bash
FILENAME=prom2v266.zip
#FOLDERNM="Prominence II [RPG] Server Pack v2.4.0"
VARTMP="template.txt"
VARPMT="variables.txt"
PROPTMP="server.properties.tmp"
PROPPMT="server.properties"
URL="https://www.curseforge.com/api/v1/mods/466901/files/5087952/download"

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

#Clean up old files
rm -rf config defaultconfigs mods

#checks if there is a current modpack installation
if [ -f "$FILENAME" ]; then
    echo "Installation Exists"
    rm -rf $VARPMT

    #Ensures there is a valid variable template file
    if [ -f "$VARTMP" ]; then
        cp $VARTMP $VARPMT
    else
        echo "Missing $VARTMP file: Unzipping modpack for replacement"
        unzip_modpack
        cp $VARPMT $VARTMP
    fi

    #Ensures there is a valid server.properties template file
    if [ -f "$PROPTMP" ]; then
        echo "Valid $PROPPMT file"
    else
        echo "Missing $PROPTMP file: Unzipping modpack for replacement"
        unzip_modpack
        cp $PROPPMT $PROPTMP
    fi
else
    
    #If there is no installation, it downloads the modpack and creates the installation
    dl_modpack
    unzip_modpack
    cp $VARPMT $VARTMP
    cp $PROPPMT $PROPTMP
fi

#creates eula.txt file to accept minecraft's EULA
rm -rf eula.txt
echo eula=true > eula.txt

#Sets Variables
echo ""
echo "Variables:"
sed 's%JAVA_ARGS="-Xms1G -Xmx6G %JAVA_ARGS="'"$JAVA_ARGS "'%' $VARPMT
sed -i 's%JAVA_ARGS="-Xms1G -Xmx6G %JAVA_ARGS="'"$JAVA_ARGS "'%' $VARPMT

echo enable-rcon=true>>$PROPPMT
echo rcon.password=$RCON_PASS>>$PROPPMT
echo 'rcon.port=25575'>>$PROPPMT
echo 'broadcast-rcon-to-ops=false'>>$PROPPMT

#Changes permissions and starts server
chmod +x start.sh
source start.sh