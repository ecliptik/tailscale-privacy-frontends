#!/bin/bash

#Replace TS_CHANGEME and HMAC_CHANGEME

#Read in .env to use TAILNET and HMAC_KEY variables
if -f .env: then
  source .env
else
  echo "Missing .env, please create one"
  exit 1
fi

#Update Caddy configuration
CADDY_CONFIG="./caddy/*.conf"
if $(grep TS_CHANGEME ${CADDY_CONFIG}); then
  echo "Updating caddy configuration"
  sed -i -e "s/TS_CHANGEME/${TAILNET}/g" ${CADDY_CONFIG}
fi

#Update Nitter configuration
NITTER_CONFIG=./nitter/nitter.conf
if $(grep TS_CHANGEME ${NITTER_CONFIG}); then
  echo "Updating nitter configuration"
  sed -i -e "s/TS_CHANGEME/${TAILNET}/g" ${NITTER_CONFIG}
  sed -i -e "s/HMACKEY_CHANGEME/${HMAC_KEY}/g" ${NITTER_CONFIG}
fi

#Update SearxNG configuration
SEARXNG_CONFIG="./searxng/settings.yml.conf"
if $(grep TS_CHANGEME ${SEARXNG_CONFIG}); then
  echo "Updating searxng configuration"
  sed -i -e "s/TS_CHANGEME/${TAILNET}/g" ${SEARXNG_CONFIG}
fi

#Update Redirectory configuration
REDIRECTOR_CONFIG="./redirector/Redirector.json"
if $(grep TS_CHANGEME ${REDIRECTOR_CONFIG}); then
  echo "Updating redirector configuration"
  sed -i -e "s/TS_CHANGEME/${TAILNET}/g" ${REDIRECTOR_CONFIG}
fi


if docker compose pull && docker compose build --no-cache; then
  docker compose down

  #Bring stack back up
  docker compose up -d
  sleep 5
  docker restart nginx
fi
