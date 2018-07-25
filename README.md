# Graylog Sidecar Collector
Docker image for Graylog Sidecar Collector using filebeat

#### NOTE:  This has been updated to use Graylog Sidecar Collector 0.1.6

## Sidecar and collector logging

Sidecar and collectors write log to `/var/log/graylog/collector-sidecar` with
default daily rotation and retention time of 7 days. By default, log directory
is inside the container. Add appropriate volume mount to store logs in host.

## Usage

The container uses environment variables to define the logfiles that are monitored and connection settings to the server running Graylog. Following parameters are available:

- GS_SERVER_URL *(REQUIRED)*
 - Graylog server url to connect to
- GS_NODE_ID *(REQUIRED)*
 - Graylog Sidecar instance name
- GS_TAGS *(REQUIRED)*
 - Tags that are to be monitored (configurations retrieved from Graylog server)
- GS_UPDATE_INTERVAL
 - seconds interval on how often the configuration is retrieved from Graylog server, default is 60
- GS_SEND_STATUS
 - enable sending collector status to server, default is true
- GS_LIST_LOG_FILES
 - list of container paths that contain the log files monitored, listings of these paths are periodically published to server, default is empty
 - Example: GS_LIST_LOG_FILES=['/var/log/apache2','/var/log/mariadb']
- GS_TLS_SKIP_VERIFY
 - Skip verifying TLS, default is false
- GS_LOG_ROTATION_TIME
 - Log rotation period in seconds, default is 86400 (1 day)
- GS_LOG_MAX_AGE
 - Log retention time in seconds, default is 604800 (7 days)

Also, the monitored folder needs to be mounted for the docker container. E.g. if you want to monitor host location /var/log/apache2, you should mount it as follows:

`docker run --env-file ./env.list -v /var/log/apache2:/host/var/log/apache2:ro -d kg7qin/graylog-sidecar`

Example env.list configuration:
```
GS_SERVER_URL=http://graylog2:9000/api/
GS_NODE_ID=apache-server
GS_TAGS=['apache2']
```

Since Graylog Sidecar retrieves its configuration from Graylog server, a matching configuration needs to exist in the server side. In particular, each tag that is configured in the GS_TAGS variable needs to exist in the Graylog server Collectors configuration.
