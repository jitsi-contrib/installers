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

## Seeing the result

- Join a meeting such as `https://jitsi.yourdomain.com/myroom`, stay for a
  while, then close the browser tab. The dump is completed when the page is
  closed.
- Open `https://jitsi.yourdomain.com/rtcstats-dumps/` and click `View` on a
  dump to see it in the viewer.

The viewer loads its chart library from a CDN, so the browser needs internet
access.

## What to check first

A dump contains one client's view of the meeting. Check it in this order:

1. **Who and which meeting:** the `:jitsi` event shows the room, the meeting
   ID, the participant ID and the display name. The participant ID is the same
   ID used in the Jicofo and JVB logs.
2. **Which connection:** Jitsi uses one connection to JVB and, in a two
   person meeting, may also use a peer-to-peer connection. They are shown as
   separate connections in the viewer.
3. **How it connected:** the ICE and connection states, and the selected
   candidate pair. A `relay` candidate means TURN is used. TCP or TLS instead
   of UDP usually means a restrictive network and worse quality.
4. **Network:** on the selected `candidate-pair`, check
   `availableOutgoingBitrate` (the uplink bandwidth estimate) and
   `currentRoundTripTime`.
5. **Loss and jitter:** `packetsLost` and `jitter` on `inbound-rtp` show the
   receiving side. `remote-inbound-rtp` shows the same for what this client
   sends.
6. **Why the sent video is poor:** `qualityLimitationReason` on the video
   `outbound-rtp` shows `cpu` or `bandwidth` if the sender had to lower the
   quality. Also check `frameWidth`, `frameHeight` and `framesPerSecond`.
7. **What the user saw and heard:** `freezeCount`, `totalFreezesDuration` and
   `framesDropped` on video `inbound-rtp`, and `concealedSamples` on audio
   `inbound-rtp` for choppy audio.
8. **Devices:** `getUserMedia` errors and device changes.

If a user sees or hears another participant badly, open both dumps from the
same meeting ID. The sender's dump shows the uplink side, the receiver's dump
shows the downlink side.
