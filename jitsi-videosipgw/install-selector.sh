#!/bin/bash
# ------------------------------------------------------------------------------
# This script adds jitsi-component-selector and jitsi-component-sidecar to
# jitsi-videosipgw deployment.
# ------------------------------------------------------------------------------
set -e

apt-get update
apt-get install -y devscripts debhelper
apt-get install -y redis

DOMAIN=$(hocon get -f /etc/jitsi/jicofo/jicofo.conf \
  jicofo.xmpp.client.xmpp-domain | tr -d '"')
KID_SIGNAL="jitsi/default"
KID_SIDECAR="jitsi/default"

# ------------------------------------------------------------------------------
# keys
# ------------------------------------------------------------------------------
mkdir -p /root/keys

if [[ ! -f /root/keys/signal.key ]] || [[ ! -f /root/keys/signal.pem ]]; then
  rm -f /root/keys/signal.{key,pem}

  ssh-keygen -qP '' -t rsa -b 4096 -m PEM -f /root/keys/signal.key
  openssl rsa -in /root/keys/signal.key -pubout -outform PEM \
    -out /root/keys/signal.pem
  rm -f /root/keys/signal.key.pub
fi

if [[ ! -f /root/keys/sidecar.key ]] || [[ ! -f /root/keys/sidecar.pem ]]; then
  rm -f /root/keys/sidecar.{key,pem}

  ssh-keygen -qP '' -t rsa -b 4096 -m PEM -f /root/keys/sidecar.key
  openssl rsa -in /root/keys/sidecar.key -pubout -outform PEM \
    -out /root/keys/sidecar.pem
  rm -f /root/keys/sidecar.key.pub
fi

# ------------------------------------------------------------------------------
# build jitsi-component-selector
# ------------------------------------------------------------------------------
mkdir -p /root/src
rm -rf /root/src/jitsi-component-selector*

cd /root/src
git clone https://github.com/jitsi/jitsi-component-selector.git
cd /root/src/jitsi-component-selector/resources
export DEBFULLNAME="my deb name"
export DEBEMAIL="myemail@mydomain.com"
bash build_deb_package.sh

# ------------------------------------------------------------------------------
# build jitsi-component-sidecar
# ------------------------------------------------------------------------------
mkdir -p /root/src
rm -rf /root/src/jitsi-component-sidecar*

cd /root/src
git clone https://github.com/jitsi/jitsi-component-sidecar.git
cd /root/src/jitsi-component-sidecar/resources
export DEBFULLNAME="my deb name"
export DEBEMAIL="myemail@mydomain.com"
bash build_deb_package.sh

# ------------------------------------------------------------------------------
# install jitsi-component-selector
# ------------------------------------------------------------------------------
apt-get -y purge jitsi-component-selector || true
dpkg -i /root/src/jitsi-component-selector_*.deb
mkdir -p /var/www/asap
mkdir -p /var/www/asap/{clients,server,signal}
touch /var/www/asap/index.html
touch /var/www/asap/{clients,server,signal}/index.html

HASH=$(echo -n "$KID_SIGNAL" | sha256sum | awk '{print $1}')
cp /root/keys/signal.pem $JITSI_ROOTFS/var/www/asap/signal/$HASH.pem

HASH=$(echo -n "$KID_SIDECAR" | sha256sum | awk '{print $1}')
cp /root/keys/sidecar.pem $JITSI_ROOTFS/var/www/asap/server/$HASH.pem

cat >/etc/jitsi/meet/jaas/component-selector.conf <<EOF
# component-selector upstream
set \$component_selector 127.0.0.1:8015;

# component-selector websocket
location ~ /jitsi-component-selector/ws/ {
    proxy_pass http://\$component_selector;
    proxy_http_version 1.1;
    proxy_set_header Host \$http_host;
    proxy_set_header X-Forwarded-For \$remote_addr;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
    tcp_nodelay on;
}

# component-selector
location ~ /jitsi-component-selector/ {
    proxy_pass http://\$component_selector;
    proxy_http_version 1.1;
    proxy_set_header Host \$http_host;
    proxy_set_header X-Forwarded-For \$remote_addr;
    tcp_nodelay on;
}
EOF

cat >/etc/nginx/sites-available/asap.conf <<EOF
server {
    listen 18443 ssl default_server;
    listen [::]:18443 ssl default_server;
    server_name $DOMAIN;

    ssl_certificate /etc/jitsi/meet/$DOMAIN.crt;
    ssl_certificate_key /etc/jitsi/meet/$DOMAIN.key;

    root /var/www/asap;
    index index.html index.htm;
}
EOF
rm -f /etc/nginx/sites-enabled/asap.conf
ln -s /etc/nginx/sites-available/asap.conf /etc/nginx/sites-enabled/
systemctl restart nginx.service

cat >>/etc/jitsi/selector/env <<EOF

SIGNAL_ASAP_BASE_URL_MAPPINGS='[{"kid": "^jitsi/(.*)$", "baseUrl": "https://$DOMAIN:18443/signal"}]'
SYSTEM_ASAP_BASE_URL_MAPPINGS='[{"kid": "^jitsi/(.*)$", "baseUrl": "https://$DOMAIN:18443/server"}]'
JITSI_ASAP_BASE_URL_MAPPINGS='[{"kid": "^jitsi/(.*)$", "baseUrl": "https://$DOMAIN:18433/clients"} ]'
NODE_EXTRA_CA_CERTS=/etc/jitsi/meet/$DOMAIN.crt
EOF
systemctl restart jitsi-component-selector.service

# ------------------------------------------------------------------------------
# install jitsi-component-sidecar
# ------------------------------------------------------------------------------
apt-get -y purge jitsi-component-sidecar || true

debconf-set-selections <<< "\
  jitsi-component-sidecar jitsi-component-sidecar/selector-address \
  string $DOMAIN"
dpkg -i /root/src/jitsi-component-sidecar*.deb

cp /root/keys/sidecar.key /etc/jitsi/sidecar/asap.key
cp /root/keys/sidecar.pem /etc/jitsi/sidecar/asap.pem
chown jitsi-sidecar:jitsi /etc/jitsi/sidecar/*

sed -i "s/WS_SERVER_URL/#WS_SERVER_URL/" /etc/jitsi/sidecar/env
sed -i "s/COMPONENT_TYPE=.*/COMPONENT_TYPE='SIP-JIBRI'/" /etc/jitsi/sidecar/env
cat >>/etc/jitsi/sidecar/env <<EOF

ENABLE_STOP_INSTANCE=true
WS_SERVER_URL='wss://$DOMAIN'
NODE_EXTRA_CA_CERTS=/etc/jitsi/meet/$DOMAIN.crt
EOF
systemctl restart jitsi-component-sidecar.service

# ------------------------------------------------------------------------------
# completed
# ------------------------------------------------------------------------------
echo
echo COMPLETED SUCCESSFULLY
