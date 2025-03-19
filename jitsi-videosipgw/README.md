# Jitsi Video-SIP-Gateway Installer

`jitsi-videosipgw-installer` installs a standalone Jitsi server with a built-in
video SIP gateway (_aka `SIP-Jibri`_). This script guides the user during the
installation to avoid potential problems.

## Supported distributions

- Debian 12 Bookworm

The desktop environment must **not be installed** on the server. Otherwise
`jibri` cannot use its own desktop.

## Recommended Specs

- 8 CPU cores
- 8 GB RAM
- No sound card\
  _Otherwise audio device IDs must be updated in `pjsua.conf`_

## Usage

- **Don't run this script on a working production server.**
- **Don't run this script on your desktop machine.**
- Run it on an isolated environment such as a virtual machine or a cloud server.
- Run it as `root`.
- Follow the recommendations during the installation.

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

### other customizations

This setup needs token authentication to get the dial plan.

If you wish to specify the JWT `app_id` and JWT `app_secret` then set the
following environment variables before starting the installer. If you do not
specify them, they will be generated for you.

```bash
export APP_ID=your_app_id
export APP_SECRET=your_app_secret
```

### run the installer

```bash
bash jitsi-videosipgw-installer
```

#### SIP config

Add the following settings into `/etc/jitsi/jibri/pjsua.config` if there is a
SIP server in the environment. Otherwise you can directly call the other SIP
peer if it is in the dial plans.

```
--id "jitsi <sip:SIP_USER@SIP_SERVER_ADDRESS>"
--registrar=sip:SIP_SERVER_ADDRESS
--realm=*
--username=SIP_USER
--password=SIP_PASSWORD
```

#### Dial plans

Update following file for dial plans:

- `/home/jibri/sip-dial-plan/dial-plan.json`
