# Jitsi Base Installer

`jitsi-base-installer` installs a simple standalone Jitsi server. This script
guides the user during the installation to avoid potential problems.

## Supported distributions

- Debian 12 Bookworm
- Ubuntu 20.04 Focal Fossa
- Ubuntu 22.04 Jammy Jellyfish

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

### download installer

```bash
apt-get update
apt-get install wget

wget -T 10 -O jitsi-base-installer https://raw.githubusercontent.com/jitsi-contrib/installers/main/jitsi-base/jitsi-base-installer
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
bash jitsi-base-installer
```
