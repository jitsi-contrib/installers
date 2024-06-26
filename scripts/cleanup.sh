#!/bin/bash
set -e

# -----------------------------------------------------------------------------
# remove the old installation if exists
# -----------------------------------------------------------------------------
systemctl stop virtual-camera-0.service || true
systemctl stop virtual-camera-1.service || true
systemctl stop excalidraw.service || true
systemctl stop jitsi-component-selector.service || true
systemctl stop jitsi-component-sidecar.service || true
systemctl stop sip-dial-plan.service || true
systemctl stop sip-xorg.service || true
systemctl stop jibri-xorg.service || true
systemctl stop jigasi.service || true
systemctl stop jitsi-videobridge2.service || true
systemctl stop jicofo.service || true
systemctl stop prosody.service || true
systemctl stop coturn.service || true
systemctl stop nginx.service || true
systemctl stop certbot.timer || true
systemctl stop certbot.service || true
systemctl stop redis.service || true

apt-mark unhold 'jitsi-*' || true
apt-mark unhold jicofo || true
apt-mark unhold jibri || true
apt-mark unhold jigasi || true
apt-mark unhold google-chrome-stable || true

apt-get -y purge jibri || true
apt-get -y purge jigasi || true
apt-get -y purge 'jitsi-*' || true
apt-get -y purge jicofo || true
apt-get -y purge prosody || true
apt-get -y purge 'prosody-*' || true
apt-get -y purge coturn || true
apt-get -y purge nginx || true
apt-get -y purge 'nginx-*' || true
apt-get -y purge 'libnginx-*' || true
apt-get -y purge 'openjdk-*' || true
apt-get -y purge 'lua*' || true
apt-get -y purge 'liblua*' || true
apt-get -y purge 'adoptopenjdk-*' || true
apt-get -y purge certbot || true
apt-get -y purge ffmpeg || true
apt-get -y purge redis || true
apt-get -y purge nodejs || true
apt-get -y purge chromium chromium-common chromium-driver || true
apt-get -y purge chromium-browser chromium-chromedriver || true
apt-get -y purge chromium-codecs-ffmpeg chromium-codecs-ffmpeg-extra || true
apt-get -y purge google-chrome-stable || true
apt-get -y purge va-driver-all vdpau-driver-all || true
apt-get -y purge "v4l2loopback-*" || true
apt-get -y purge devscripts debhelper || true
apt-get -y purge build-essential || true
apt-get -y purge alsa-utils unclutter x11vnc || true
apt-get -y purge libv4l-dev libsdl2-dev libavcodec-dev libavdevice-dev \
  libavfilter-dev libavformat-dev libavutil-dev libswscale-dev libasound2-dev \
  libopus-dev libvpx-dev libssl-dev || true
apt-get -y autoremove --purge

deluser excalidraw || true
delgroup excalidraw || true
deluser jibri || true
delgroup jibri || true

rm -rf /home/excalidraw
rm -rf /home/jibri
rm -rf /etc/chromium
rm -rf /etc/jitsi
rm -rf /etc/prosody
rm -rf /etc/coturn
rm -rf /etc/nginx
rm -rf /etc/opt/chrome
rm -rf /etc/systemd/system/jibri*
rm -rf /etc/systemd/system/sip-*
rm -rf /etc/systemd/system/certbot.service.d
rm -rf /etc/systemd/system/nginx.service.d
rm -rf /etc/systemd/system/prosody.service.d
rm -rf /etc/systemd/system/virtual-camera-*
rm -rf /opt/google
rm -rf /opt/jitsi
rm -rf /root/src/jitsi-component-selector*
rm -rf /root/src/jitsi-component-sidecar*
rm -rf /usr/lib/node_modules
rm -rf /usr/local/share/nginx
rm -rf /usr/share/jitsi-meet
rm -rf /usr/share/jitsi-videobridge
rm -rf /usr/share/jicofo
rm -rf /var/lib/prosody
rm -rf /var/www/asap
rm -f  /etc/apt/sources.list.d/jitsi-stable.list
rm -f  /etc/apt/sources.list.d/google-chrome.list
rm -f  /etc/apt/sources.list.d/nodesource.list
rm -f  /etc/apt/sources.list.d/prosody.list
rm -f  /etc/modprobe.d/alsa-loopback.conf
rm -f  /etc/modprobe.d/v4l2loopback.conf
rm -f  /etc/sudoers.d/jibri
rm -f  /usr/local/bin/chromedriver
rm -f  /usr/local/bin/google-chrome
rm -f  /usr/local/bin/pjsua

find /usr/local/share/ca-certificates -xtype l -delete
rmdir /root/src || true


# -----------------------------------------------------------------------------
# completed
# -----------------------------------------------------------------------------
echo
echo COMPLETED SUCCESSFULLY
