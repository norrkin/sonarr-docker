# Base image to be used
FROM debian:stretch

# Tweaked by me
LABEL maintainer "mark <norrkin@icloud.com>"

# Define what release we want to use
ENV sonarr_release 2.0.0.5319

# Adding nzbdrone startup script
COPY entrypoint.sh /usr/bin/entrypoint.sh

# Get sonarr & its dependencies, map user with host & set permissions
RUN apt-get update && apt-get install gnupg -y && \
    apt-key adv --no-tty --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys --batch 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb http://download.mono-project.com/repo/debian stable-stretch main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-key adv --no-tty --keyserver keyserver.ubuntu.com --recv-keys --batch FDA5DFFC && \
    echo "deb http://apt.sonarr.tv/ master main" | tee -a /etc/apt/sources.list && \
    apt-get update -q && \
    apt-get install -qy mono-devel nzbdrone=${sonarr_release} mediainfo --no-install-recommends && \
    apt-get autoremove && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    chmod +x /usr/bin/entrypoint.sh


# Mount volumes
VOLUME ["/config", "/download"]

# Set working directory
WORKDIR /opt/NzbDrone

# Open sonarr port
EXPOSE 8989

# Start sonarr
CMD ["/usr/bin/entrypoint.sh"]
