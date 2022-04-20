# Jitsi-Token Installer

`jitsi-token-installer` installs a standalone Jitsi server with
token authentication. This script guides the user during the
installation to avoid potential problems.

## Supported distributions

- Debian 11 Bullseye
- Ubuntu 20.04 Focal Fossa

## Usage

- Don't use this script on a working production server.
- Run it as `root`
- Follow the recommendations during the installation

### use root account

If you are not already `root`, switch to `root` account. Use one of the
following commands to become `root` according to your system:

_For Ubuntu_

```bash
sudo su -l
```

_For Debian_

```bash
su -l
```

### download installer

```bash
apt-get update
apt-get install wget

wget -O jitsi-token-installer https://raw.githubusercontent.com/jitsi-contrib/installers/main/jitsi-token/jitsi-token-installer
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
bash jitsi-token-installer
```
