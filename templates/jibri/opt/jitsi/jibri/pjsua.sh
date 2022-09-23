#!/bin/bash
set -e

# push display :0 view to virtual camera 1
ffmpeg -f x11grab -r 30 -i :0.0 -pix_fmt yuv420p -f v4l2 /dev/video1 &
sleep 0.8

# use only parameter $2 which is the remote SIP address
exec /usr/local/bin/pjsua --config-file /etc/jitsi/jibri/pjsua.config "$2" > /dev/null
