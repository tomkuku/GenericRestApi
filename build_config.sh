#!/bin/sh

#  build_config.sh
#  RestAPIManager
#
#  Created by Tomasz Kukułka on 13/01/2022.
#

PLIST_CONFIG_INPUT_FILE_PATH="${SRCROOT}/Configurations/Config-${CONFIGURATION}.plist"
SWIFT_CONFIG_OUTPUT_FILE_PATH="${SRCROOT}/Configurations/Config.swift"

if [ ! -f "$PLIST_CONFIG_INPUT_FILE_PATH" ] ; then
    echo "Config-${CONFIGURATION}.plist file not found!"
    exit 1
fi

spearator="    "

function addToSwiftFile() {
    
    for arg in "$@" ; do
        echo "$arg" >> "$SWIFT_CONFIG_OUTPUT_FILE_PATH"
    done
}

function readLine() {
    # $1 - line
    
    local key=`echo "$1" | cut -d'<' -f2 | cut -d'>' -f1 | tr -d '/'`
    local val=`echo "$1" | cut -d'>' -f2 | cut -d'<' -f1`
    
    case "$key" in
    'key')
        name="$val"
        ;;
    'integer')
        addToSwiftFile "${spearator}static let ${name}: Int = ${val}"
        ;;
    'string')
        addToSwiftFile "${spearator}static let ${name}: String = \"${val}\""
        ;;
    'true' | 'false')
        addToSwiftFile "${spearator}static let ${name}: Bool = ${key}"
        ;;
  esac
}

# Deleting content of file
echo "//" > $SWIFT_CONFIG_OUTPUT_FILE_PATH

addToSwiftFile "//  This file is generated automatically by build_config.sh"
addToSwiftFile "//\n//  ⚠️   Do not modify or commit   ⚠️"
addToSwiftFile "\nstruct Config {"

while read -r line; do
    readLine "$line"
done < $PLIST_CONFIG_INPUT_FILE_PATH

addToSwiftFile "}"

