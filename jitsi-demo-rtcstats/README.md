# Jitsi Installer with RTCStats (demo)

**Demo only, not for production.**

`jitsi-demo-rtcstats-installer` installs a simple standalone Jitsi server
together with [rtcstats](https://github.com/rtcstats/rtcstats) to show what
`rtcstats` collects. This script guides the user during the installation to
avoid potential problems.

The demo setup:

- `rtcstats-server` stores the dumps on the local disk. No S3, no database.
- `rtcstats-js` is loaded into Jitsi Meet without a rebuild.
- `dump-importer` is served as a static page to visualize the dumps.
- There is no authentication. Anyone who knows the URLs can send stats, list
  and download the dumps. IP addresses are obfuscated in the dumps.

## Supported distributions

- Debian 13 Trixie
- Debian 12 Bookworm
- Ubuntu 24.04 Noble Numbat
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

wget -T 10 -O jitsi-demo-rtcstats-installer https://raw.githubusercontent.com/jitsi-contrib/installers/main/jitsi-demo-rtcstats/jitsi-demo-rtcstats-installer
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
bash jitsi-demo-rtcstats-installer
```

## Checking the dumps

- Join a meeting such as `https://jitsi.yourdomain.com/myroom`, stay for a
  while, then close the browser tab. The dump is completed when the page is
  closed.
- Open `https://jitsi.yourdomain.com/rtcstats-dumps/`. There is one dump per
  participant. A participant who reloads the page gets a new dump. The list
  shows when it started and ended, the room, the participant's display name and
  the meeting ID. Dumps with the same meeting ID belong to the same meeting.
- Click `View` to see the dump in the viewer or `Download` to save it.

The viewer loads its chart library from a CDN, so the browser needs internet
access.
