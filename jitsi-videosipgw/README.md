# Jitsi Video-SIP-Gateway Installer

`jitsi-videosipgw-installer` installs a standalone Jitsi server with a built-in
video SIP gateway. This script guides the user during the installation to avoid
potential problems.

## Supported distributions

- Debian 11 Bullseye

The desktop environment must **not be installed** on the server. Otherwise
`jibri` cannot use its own desktop.

## Usage

- Don't use this script on a working production server.
- Run it as `root`
- Follow the recommendations during the installation

### use root account

If you are not already `root`, switch to `root` account. Use one of the
following commands to become `root` according to your system:

```bash
sudo su -l
```

or

```bash
su -l
```

### kernel

Use the latest stable kernel from the official Debian repo.

```bash
apt-get update
apt-get dist-upgrade
```

If there is a kernel update, please reboot to switch to the latest kernel.

### download installer

```bash
apt-get update
apt-get install wget

wget -T 10 -O jitsi-videosipgw-installer https://raw.githubusercontent.com/jitsi-contrib/installers/main/jitsi-videosipgw/jitsi-videosipgw-installer
```

### host addresses

- Create a `DNS A record` for Jitsi. For example `jitsi.yourdomain.com`
- Create a `DNS A record` for TURN. For example `turn.yourdomain.com`
- Jitsi address and TURN address must be different and don't use an IP as the
  host address
- Set related environment variables before starting the installer

```bash
export JITSI_HOST=jitsi.yourdomain.com
export TURN_HOST=turn.yourdomain.com
```

### run the installer

```bash
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

#### Dial plans

Update following files for dial plans:

- `/home/jibri/sip-dial-plan/dial-plan-owner.json`\
  For `moderator` users

- `/home/jibri/sip-dial-plan/dial-plan-member.json`\
  For normal users
