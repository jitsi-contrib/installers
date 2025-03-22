# Jitsi Dev Installer

`jitsi-dev-installer` installs a simple standalone Jitsi server for `jitsi-meet`
developers. This script guides the user during the installation to avoid
potential problems.

## Supported distributions

- Debian 12 Bookworm
- Ubuntu 22.04 Jammy Jellyfish

There should be at least `12 GB` reserved RAM.

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

wget -T 10 -O jitsi-dev-installer https://raw.githubusercontent.com/jitsi-contrib/installers/main/jitsi-dev/jitsi-dev-installer
```

### host addresses

For development environment, you don't need real DNS records for Jitsi and TURN
domains but client machines need to be able to resolve their IP addresses. So,
add them to `/etc/hosts` or do the equivalent depending on the client machine's
OS.

These domains have to point the IP address of Jitsi server (or virtual machine).

- Create a local `DNS A record` for Jitsi that all clients can resolve.\
  For example `jitsi.yourdomain.com`
- Create a local `DNS A record` for TURN that all clients can resolve.\
  For example `turn.yourdomain.com`
- Jitsi address and TURN address must be different and don't use an IP as the
  host address
- Set related environment variables before starting the installer

```bash
export JITSI_HOST=jitsi.yourdomain.com
export TURN_HOST=turn.yourdomain.com
```

### run the installer

```bash
bash jitsi-dev-installer
```
