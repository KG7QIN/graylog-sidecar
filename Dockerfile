#########################
# graylog sidecar       #
#########################
FROM debian:stretch-slim

LABEL maintainer "Stacy Olivas <kg7qin@arrl.net>"

# Update and install some required dependencies
RUN apt-get update && apt-get install -y openssl libapr1 libdbi1 libexpat1 ca-certificates

# Install Graylog Sidecar (Filebeat included)
ENV SIDECAR_BINARY_URL https://github.com/Graylog2/collector-sidecar/releases/download/0.1.6/collector-sidecar_0.1.6-1_amd64.deb
RUN apt-get install -y --no-install-recommends curl && curl -Lo collector.deb ${SIDECAR_BINARY_URL} && dpkg -i collector.deb && rm collector.deb && apt-get purge -y --auto-remove curl

# Define default environment values
ENV GS_UPDATE_INTERVAL=60 \
    GS_SEND_STATUS="true" \
    GS_LIST_LOG_FILES="[]" \
    GS_COLLECTOR_ID="file:/etc/graylog/collector-sidecar/collector-id" \
    GS_LOG_ROTATION_TIME=86400 \
    GS_LOG_MAX_AGE=604800 \
    GS_TLS_SKIP_VERIFY="false"

ADD ./data /data

CMD /data/start.sh
