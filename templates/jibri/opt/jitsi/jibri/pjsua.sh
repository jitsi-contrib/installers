#!/bin/bash
set -e

# push display :0 view to virtual camera 1
sudo systemctl start virtual-camera-1
sleep 0.8

REGISTRAR=$(echo "$@" | egrep -o "..registrar=sip:[^ ]" || true)
AUTO_ANSWER=$(echo "$@" | \
    egrep -o "..auto-answer-timer=[0-9]+ ..auto-answer=[0-9]+" || true)

# if auto-answer is set but there is no registrar, then this should be a direct
# incoming call. Use the customized command in this case.
if [[ -z "$REGISTRAR" && -n "$AUTO_ANSWER" ]]; then
    exec /usr/local/bin/pjsua --config-file /etc/jitsi/jibri/pjsua.config \
        "$AUTO_ANSWER" >/dev/null
else
    exec /usr/local/bin/pjsua --config-file /etc/jitsi/jibri/pjsua.config \
        "$@" >/dev/null
fi
