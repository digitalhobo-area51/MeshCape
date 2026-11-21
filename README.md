# MeshCape

MeshCore Cape Town Community — the source for [meshcape.io](https://meshcape.io).

The main site is a static [Astro](https://astro.build) site with an engineering-notebook look. Community-written guides live separately on the wiki at [wiki.meshcape.io](https://wiki.meshcape.io), where anyone with a MeshCape account can edit.

## Editing content

Most values that change — the radio preset (Table 1), links, contact details, wiki sections — live in one file:

```
src/data/site.ts
```

Set `radio.confirmed` to `true` once the community preset is agreed; that removes the "still to be agreed" note and enables the **Copy settings** button.

## Project layout

```
src/
  data/site.ts        values used across the site
  layouts/Base.astro  page frame: title-block header, nav, footer
  components/         figures, tables, cards
  pages/              one file per page (index, get-started, settings, home-assistant, links, 404)
  styles/global.css   notebook theme (grid paper, margin rule, drafting borders)
public/               favicon and static files
```

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
