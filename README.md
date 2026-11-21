# MeshCape

MeshCore Cape Town Community — the source for [meshcape.io](https://meshcape.io).

The main site is a static [Astro](https://astro.build) site with an engineering-notebook look. Community-written guides live separately on the wiki at [wiki.meshcape.io](https://wiki.meshcape.io), where anyone with a MeshCape account can edit.

## Editing content

Most values that change — the radio preset (Table 1), links, contact details, wiki sections — live in one file:

```
src/data/site.ts
```

The radio preset is the South African EU/UK (Narrow) preset — 869.618 MHz, BW 62.5 kHz, SF8, CR8, 10% duty cycle — inside ICASA's licence-free 869.4–869.65 MHz sub-band. Setting `radio.confirmed` to `false` shows a "still to be agreed" note instead and disables **Copy settings**.

`nav` sets the pages listed in the header menu (top right), in order.

## Project layout

```
src/
  data/site.ts        values used across the site
  layouts/Base.astro  page frame: MESHCAPE.IO top bar with dropdown menu, footer
  components/         figures, tables, cards
  pages/              one file per page (index, get-started, settings, home-assistant, community, links, 404)
  styles/global.css   notebook theme (paper colour, drafting borders, callouts)
public/               favicon, social preview image (og.png), robots.txt
wiki/                 wiki.meshcape.io: Docker Compose, setup guide, backups
  seed/               starter wiki pages (Wiki.js Git-storage format)
```

The wiki runs separately (Wiki.js on a home VM behind a Cloudflare Tunnel) — see [wiki/SETUP.md](wiki/SETUP.md).

## Running locally

Requires Node 18.20+ (Node 22 recommended).

```sh
npm install
npm run dev       # http://localhost:4321
npm run build     # outputs to dist/
```

## Deploying (Cloudflare Workers)

The site deploys as a static-assets-only Cloudflare Worker, configured in `wrangler.jsonc` (no server code, no bindings). The Worker `meshcape` is connected to this repo with Workers Builds:

| Setting | Value |
| --- | --- |
| Build command | `npm run build` |
| Deploy command | `npx wrangler deploy` |

Every push to `main` deploys automatically to https://meshcape.digitalhobo.workers.dev. Custom domains (`meshcape.io`, `www.meshcape.io`) are added on the Worker under **Settings → Domains & Routes**.

## Licences

- Code: [MIT](LICENSE)
- Written content on meshcape.io: [CC BY 4.0](LICENSE-CONTENT.md)
