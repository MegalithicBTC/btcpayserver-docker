#!/usr/bin/env bash
# setup-mainnet.sh – spin up infra-only main-net stack for a *local* BTCPay build

set -eo pipefail                          # fail on errors, but allow unset vars

[[ -f btcpay-setup.sh && -f helpers.sh ]] \
  || { echo "⚠️  ️Run this script from the btcpayserver-docker repo root"; exit 1; }

##############################################################################
#  ENV  –  LOCAL MAIN-NET, NO REVERSE-PROXY, KEEP BTCPay CONTAINER SCALED-OUT
##############################################################################
export BTCPAY_HOST="localhost"            # stays internal because we skip nginx
export NBITCOIN_NETWORK="mainnet"
export BTCPAYGEN_CRYPTO1="btc"
export BTCPAYGEN_LIGHTNING="clightning"

export BTCPAYGEN_REVERSEPROXY="none"      # disable nginx / LE checking
# ⚠️ **DO NOT** exclude the btcpayserver fragment – it also owns NBXplorer!
unset BTCPAYGEN_EXCLUDE_FRAGMENTS

# additional fragments
export BTCPAYGEN_ADDITIONAL_FRAGMENTS="opt-save-storage-s"   # ~6-month prune
export NBXPLORER_EXPOSERPC=1                                # expose :32838

# ---------- “nullable” vars that some helper scripts reference -------------
export LIGHTNING_ALIAS=""
export BTCPAY_ADDITIONAL_HOSTS=""   LETSENCRYPT_EMAIL=""   BTCPAY_LIGHTNING_HOST=""
export DOWNLOAD_ROOT=""             BTCPAY_DOCKER_COMPOSE=""
export BTCPAY_HOST_SSHKEYFILE=""    BTCPAY_HOST_SSHAUTHORIZEDKEYS=""
export BTCPAY_SSHAUTHORIZEDKEYS=""
export BTCPAY_ENABLE_SSH=false
export REVERSEPROXY_HTTP_PORT="80"  REVERSEPROXY_HTTPS_PORT="443"
export REVERSEPROXY_DEFAULT_HOST="none"  NOREVERSEPROXY_HTTP_PORT="80"
export BTCPAYGEN_OLD_PREGEN=false
export BTCPAYGEN_CRYPTO2="" BTCPAYGEN_CRYPTO3="" BTCPAYGEN_CRYPTO4=""
export BTCPAYGEN_CRYPTO5="" BTCPAYGEN_CRYPTO6="" BTCPAYGEN_CRYPTO7=""
export BTCPAYGEN_CRYPTO8="" BTCPAYGEN_CRYPTO9=""
export BTCPAY_IMAGE="" ACME_CA_URI="production" BTCPAY_PROTOCOL="https"
export PIHOLE_SERVERIP="" TOR_RELAY_NICKNAME="" TOR_RELAY_EMAIL=""
export LIBREPATRON_HOST="" ZAMMAD_HOST="" WOOCOMMERCE_HOST=""
export BTCTRANSMUTER_HOST="" CHATWOOT_HOST="" FIREFLY_HOST=""
export BTCPAYGEN_DOCKER_IMAGE=""  EPS_XPUB=""  CLOUDFLARE_TUNNEL_TOKEN=""
##############################################################################

echo "⇒ Generating docker-compose …"
if ! source ./btcpay-setup.sh --install-only; then
  rc=$?
  [[ $rc == 1 ]] || { echo "btcpay-setup.sh failed (rc=$rc)"; exit $rc; }
fi

echo "⇒ Starting services (btcpayserver scaled to 0) …"
docker compose -f Generated/docker-compose.generated.yml \
               up -d --scale btcpayserver=0

cat <<EOF

✅  Infrastructure is now booting:

  • NBXplorer  →  http://localhost:32838/
  • bitcoind RPC → localhost:43782
  • CLN node     → localhost:9735  (P2P)
  • CLN REST     → localhost:3010  (REST API)
  • Postgres     → localhost:5432

ⓘ  Initial main-net sync may take many hours.  Leave the containers running.
EOF