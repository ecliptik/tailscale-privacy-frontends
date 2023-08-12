# privacy-stack
Privacy Friendly Frontends With Tailscale

## Purpose

This is a [Privacy Friendly Frontend](https://www.privacytools.io/privacy-frontends) [Docker Compose Stack](https://docs.docker.com/compose/) made up of the following frontends,

- [Nitter](https://github.com/zedeus/nitter) - Replaces Twitter
- [Teddit](https://github.com/teddit-net/teddit) - Repleaces Reddit
- [Imgin](https://git.voidnet.tech/kev/imgin.git) - Replaces Imgur
- [Scribe](https://git.sr.ht/~edwardloveall/scribe) - Replaces Medium
- [SearXNG](https://github.com/searxng/searxng) - Replaces Google
- [Invidiuos](https://github.com/iv-org/invidious) - Replaces YouTube

These frontends are then exposed via [Tailscale](https://tailscale.com/) and only available to devices authrorized on to [Tailnet](https://tailscale.com/kb/1136/tailnet/?q=tailnet).

All frontends are secured over `https` with [Caddy](https://caddyserver.com/).

## Requirements

- [Tailscale Account](Account)
- [Docker](https://www.docker.com/) (or any OCI container runtime)
- [Docker Compose](https://docs.docker.com/compose/) (or any `docker-compose` compatible tool)

## Quickstart

1. Update `TS_AUTHKEY`, `TAILNET`, and `HMAC_KEY` variables in `.env`
2. Run `start.sh`

## Configuration

Tailscale Configuration
1. [Enable HTTPS](https://tailscale.com/kb/1153/enabling-https/) on your Tailnet
2. Generate a reusable [Reusable Auth Key](https://tailscale.com/kb/1085/auth-keys/?q=authkey)¬for your Tailnet
3. Note your [Tailnet Name](https://tailscale.com/kb/1217/tailnet-name/)

Privacy Stack Configuration
1. Copy `.env.example` to `.env`
2. Update the `TS_AUTHKEY`, `TAILNET` variables from above in `.env`
3. [Generate a random HMAC Key](https://www.random.org/passwords/) for `HMAC_KEY` in `.env`

## Running the Stack

Run the stack with the `start.sh` script.

This script will update `TS_CHANGEME` and `HMACKEY_CHANGEME` in various configurations from the variables in `.env`.

Example output of `start.sh`

```
~/privacy-stack$ ./start.sh
Updating caddy configuration
Updating nitter configuration
Updating redirector configuration
Starting privacy-stack
```

## Verifying the Stack

Verify the frontends come up by checking your Tailnet machines and six new names will appear (nitter, imgin, scribe, teddit, searxng, invidious).

If they do not appear, check the `docker compose logs` for errors.

## Accessing Privacy Frontendsh From Tailscale

With the stack running, access the services at the `name.tailnet`.

For example, with a Tailnet name of `tailfe8c.ts.net`, the frontends are at these addresses,

- https://nitter.tailfe8c.ts.net
- https://teddit.tailfe8c.ts.net
- https://imgin.tailfe8c.ts.net
- https://scribe.tailfe8c.ts.net
- https://teddit.tailfe8c.ts.net
- https://searxng.tailfe8c.ts.net
- https://invidious.tailfe8c.ts.net

## Redirector Plugin

The [Redirector Plugin](https://github.com/einaregilsson/Redirector) can modify a link to the upstream site to the appropriate privacy frontend, including all relevant URL information. This makes using a privacy frontend seamless and the default.

For example any links that go to twitter.com will automatically redirect to https://nitter.tailfe8c.ts.net, passing along the rest of the URL so any links transparency show up in the target privacy frontend.

The `redirector` directory contains an example Redirector configuration file to use.

## Additional Details

WIP
