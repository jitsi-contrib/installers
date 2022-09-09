#!/bin/bash
set -e

# kill old ffmpeg processes if exist
pkill -U jibri -f ffmpeg || true
sleep 0.2

# push desktop views to virtual cameras
ffmpeg -f x11grab -r 30 -i :0.0 -pix_fmt yuv420p -f v4l2 /dev/video1 &
ffmpeg -f x11grab -r 30 -i :1.0 -pix_fmt yuv420p -f v4l2 /dev/video0 &
sleep 0.8

# use only parameter $2 which is the remote SIP address
exec /usr/local/bin/pjsua --config-file /etc/jitsi/jibri/pjsua.config "$2" > /dev/null
