#!/bin/sh
#
# entrypoint.sh


# create user
printf "Create nzbdrone user/group... "
useradd -M -u ${UID} -g ${GID} nzbdrone -s /bin/sh && \
echo "[DONE]"


# set some permissions
printf "Set permissions... "
chown -R nzbdrone:users /opt/NzbDrone
chown -R nzbdrone:users /config
echo "[DONE]"


handle_signal() {
  PID=$!
  echo "received signal. PID is ${PID}"
  kill -s SIGHUP $PID
}

trap "handle_signal" SIGINT SIGTERM SIGHUP

echo "Starting sonarr..."
su nzbdrone -c 'mono /opt/NzbDrone/NzbDrone.exe --no-browser -data=/config' & wait
echo "Stopping sonarr"