FROM solr:7.6-alpine

ENV SOLR_HOME=/solr_home \
    SOLR_CONFIG_DIR=/solr_conf

USER root

# Install japanese fonts to help solr process some pdf files
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk update \
    && apk add font-ipa encodings font-alias fontconfig mkfontdir mkfontscale

#RUN mkdir $SOLR_CONFIG_DIR \
#    && chown -R solr:solr $SOLR_CONFIG_DIR

# The following command is completely pointless when the container is run on
# a different system from the one that built it. In those cases, $SOLR_HOME
# is just replaced by the contents of the volume mounted over it at runtime.
#
# However, on local development machines this command helps re-init a volume
# with the correct permissions after the volume has been deleted and recreated.
# This is despite the fact that obviously everything in this Dockerfile only
# relates to build-time, not run-time. Docker does some permissions and
# ownership munging.
# FIXME how do images like postgres do this and why is it only necessary for Solr?
RUN mkdir -p $SOLR_HOME && chown -R solr:solr $SOLR_HOME

USER $SOLR_USER
ADD config $SOLR_CONFIG_DIR/hyrax_config

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
