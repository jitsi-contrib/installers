# Jitsi Video-SIP-Gateway Installer

NOT READY YET

#### installation

```bash
apt-get update
apt-get install wget

wget -T 10 -O jitsi-videosipgw-installer https://raw.githubusercontent.com/jitsi-contrib/installers/main/jitsi-videosipgw/jitsi-videosipgw-installer

export JITSI_HOST=jitsi.yourdomain.com
export TURN_HOST=turn.yourdomain.com

bash jitsi-videosipgw-installer
```

#### SIP config

Add the followings into `/etc/jitsi/jibri/pjsua.config`

```
--id "jitsi <sip:<SIP_USER>@127.0.0.1>"
--registrar=sip:<SIP_SERVER_ADDRESS>
--realm=*
--username=<SIP_USER>
--password=<SIP_PASSWORD>
```

#### Test SIP connectivity

```bash
su -l jibri -s /bin/bash

/usr/local/bin/pjsua --config-file /etc/jitsi/jibri/pjsua.config \
  'sip:<REMOTE_SIP_USER@<SIP_SERVER_ADDRESS>'
```
