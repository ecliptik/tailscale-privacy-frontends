# tailscale-privacy-frontends
Privacy Friendly Frontends With Tailscale

## Purpose

[Privacy Friendly Frontends](https://github.com/digitalblossom/alternative-frontends) with Tailscale in Docker Compose.

List of frontends
- [Nitter](https://github.com/zedeus/nitter) - Twitter
- [Teddit](https://github.com/teddit-net/teddit) - Reddit
- [Imgin](https://git.voidnet.tech/kev/imgin.git) - Imgur
- [Scribe](https://git.sr.ht/~edwardloveall/scribe) - Medium
- [SearXNG](https://github.com/searxng/searxng) - Google
- [Invidiuos](https://github.com/iv-org/invidious) - YouTube

Frontends are exposed via [Tailscale](https://tailscale.com/) and only available to devices authorized on a [Tailnet](https://tailscale.com/kb/1136/tailnet/?q=tailnet).

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
1. [Enable HTTPS](https://tailscale.com/kb/1153/enabling-https/)
2. [Reusable Auth Key](https://tailscale.com/kb/1085/auth-keys/?q=authkey)
3. [Tailnet Name](https://tailscale.com/kb/1217/tailnet-name/)

Privacy Stack Configuration
1. Copy `.env.example` to `.env`
2. Update `TS_AUTHKEY`, `TAILNET` variables in `.env`
3. [Generate random key](https://www.random.org/passwords/) for `HMAC_KEY` in `.env`

## Running the Stack

Run with the `start.sh` script.

This script will update `TS_CHANGEME` and `HMACKEY_CHANGEME` in various configurations from the variables in `.env`.

Example output of `start.sh`,

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

## FAQ

**Q: Why?**

**A:** See [Privacy Guide to Frontends](https://www.privacyguides.org/en/frontends/) and [Privacy Frontends](https://www.privacytools.io/privacy-frontends)

**Q: Why not use publicly available frontends?**

**A:** Self-hosting your own frontends can improve performance and gives more control over frontend setup and configuration.

**Q: Doesn't running these yourself make you more visible?**

**A:** This stack can run on a small VPS (tested on a t4.medium) instance to provide an added layer of anonymonity. Layering in a VPN can also help mix traffic.

**Q: Why are there so many containers?**

**A:** Tailscale [Magic DNS](https://tailscale.com/kb/1081/magicdns/) does not currently support wildcard domains, and therefore each frontend needs it's own Tailscale machine so it's hbstname resolves the Tailnet. An alternative is a single hostname to proxy all frontends, but this becomes complicated as almost all frontends assume they are running in their own domain and do not handle relative URL changes easily.

**Q: Why are there so many volumes?**

**A:** The `varlib` volumes allow re-using of an existing Tailscale machine record between container start/stops. Without persisting outside of the container a new Tailscale machine is created every time with an number appended to it, eg `nitter-1`. The `varrun` volume shares the Tailscale socket with Caddy so [Caddy can manage Tailscale HTTPS certificates](https://tailscale.com/blog/caddy/). Instead of volumes, bind mounts could also be used.

**Q: Configuration X makes this insecure, and X should be done instead.

**A:** Probably. This stack is focused on privacy and not security.

## Additional Details

WIP
