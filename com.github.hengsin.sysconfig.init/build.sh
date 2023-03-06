#!/bin/bash

script_dir=$(realpath $(dirname "$0"))
if [ -z "$IDEMPIERE_SOURCE" ]; then
   if [[ -f "$script_dir/idempiere_source.properties" ]]; then
       source "$script_dir/idempiere_source.properties"
   fi
fi

if [ -z "$IDEMPIERE_SOURCE" ]; then
    if [ -d "$script_dir/../idempiere/org.idempiere.p2.targetplatform" ]; then
        IDEMPIERE_SOURCE=$(realpath "$script_dir/../idempiere")
    fi 
    if [ -z "$IDEMPIERE_SOURCE" ]; then
	if [ -d "$script_dir/../../idempiere/org.idempiere.p2.targetplatform" ]; then
	    IDEMPIERE_SOURCE=$(realpath "$script_dir/../../idempiere")
        fi	
    fi
fi

if [ -z "$IDEMPIERE_SOURCE" ]; then
    echo "IDEMPIERE_SOURCE environment variable not set"
    exit 1
fi

echo $IDEMPIERE_SOURCE
export IDEMPIERE_SOURCE
mvn verify
