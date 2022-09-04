# Jitsi Video-SIP-Gateway Installer

Not ready yet

#### SIP config

Add the followings into `/etc/jitsi/jibri/pjsua.config`

```
--id "jitsi <sip:jitsi@127.0.0.1>"
--registrar=sip:<SIP_SERVER_ADDRESS>
--realm=*
--username=<SIP_USER>
--password=<SIP_PASSWORD>
```

#### Test SIP connectivity

```bash
su -l jibri -s /bin/bash

/usr/local/bin/pjsua --config-file /etc/jitsi/jibri/pjsua.config \
  --id='jitsi <sip:<SIP_USER>@127.0.0.1>' \
  'sip:<REMOTE_SIP_USER@<SIP_SERVER_ADDRESS>'
```
