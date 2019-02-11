#!/bin/bash
#
# Creates the solr cores required for Hyrax and friends
# SOLR_HOME = data folder, usually mounted as a volume
# SOLR_CONFIG_DIR = a directory of static solr configuration files baked into the Docker image at build time.

set -e

if [[ "$VERBOSE" = "yes" ]]; then
    set -x
fi

cp /opt/solr/server/solr/solr.xml $SOLR_HOME/

. /opt/docker-solr/scripts/run-initdb

hyrax_created=$SOLR_HOME/hyrax_created

if [ -f $hyrax_created ]; then
    echo "Skipping solr core creation"
else
    echo "Creating solr cores"
    start-local-solr

    if [ ! -f $hyrax_created ]; then
        echo "Creating Hyrax core(s)"
        /opt/solr/bin/solr create -c "hyrax_development" -d "$SOLR_CONFIG_DIR/hyrax_config"
        /opt/solr/bin/solr create -c "hyrax_test" -d "$SOLR_CONFIG_DIR/hyrax_config"
        /opt/solr/bin/solr create -c "hyrax_production" -d "$SOLR_CONFIG_DIR/hyrax_config"
        touch $hyrax_created
    fi

    stop-local-solr
fi

exec solr -f
