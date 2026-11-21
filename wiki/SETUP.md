# MeshCape wiki — setup guide

How to run **wiki.meshcape.io** on an **existing** Linux VM on the home ESXi
host, alongside what already runs there, at zero cost.

```
Internet ──► Cloudflare (wiki.meshcape.io) ══ tunnel ══► cloudflared ──► Wiki.js ──► PostgreSQL
                                                         └──────── existing VM on ESXi ────────┘
```

- **No ports opened** on the home router and the home IP stays hidden — the
  VM makes an outbound connection to Cloudflare.
- **Members sign up on the wiki itself** (email + password). No GitHub,
  Google or other third-party account needed.
- **Every page is mirrored to a GitHub repo** as Markdown, for off-site
  backup and so Claude can read and tidy pages.

> **Blocked until the domain is on Cloudflare.** Parts 1–3 can be done now.
> Part 4 (the tunnel) needs `meshcape.io` active on Cloudflare first.
>
> **Shared VM rule:** every step below either only reads, or only touches
> things named `meshcape-wiki`. Nothing here restarts Docker, changes other
> containers or prunes anything shared.

---

## Part 1 — Pre-flight check on the existing VM (read-only)

The wiki adds three small containers (Wiki.js, PostgreSQL, cloudflared),
capped at about **1.4 GB RAM** and **2.5 CPUs** in total, and needs 3–5 GB of
disk. Before adding anything, check the VM can take it.

1. Take an **ESXi snapshot** of the VM first (host client → the VM →
   *Actions → Snapshots → Take snapshot*, name it `before-meshcape-wiki`).
   It's your one-click undo. Delete it a few days after everything works,
   because snapshots slow a VM down if left for long.
2. SSH in as your normal user and run the check. It installs and changes
   nothing:
   ```sh
   curl -fsSL https://raw.githubusercontent.com/digitalhobo-area51/meshcape/main/wiki/preflight.sh -o /tmp/preflight.sh
   less /tmp/preflight.sh                    # read it first if you like
   bash /tmp/preflight.sh | tee ~/meshcape-preflight-before.txt
   docker ps --format '{{.Names}}' | sort > ~/containers-before.txt   # baseline list
   ```
3. If it ends with **No warnings**, carry on. If there are warnings, send
   the output to Claude before going further. It checks:
   - free memory and disk, and current CPU load
   - whether Docker and `docker compose` are already there and usable
   - which containers are running now (your baseline for afterwards)
   - that nothing called `meshcape` exists yet (no name clashes)
   - that the setup port (3080) is free on the VM
   - firewall state and any failed services (another baseline)

## Part 2 — Docker (only if the pre-flight says it's missing)

**If Docker is already installed, skip this part.** Don't reinstall or
upgrade it: that restarts the Docker service and with it every container on
the VM.

If Docker is missing, stop and check with Claude first. Installing it on a
shared VM adds firewall (iptables) rules and a background service, which can
matter if the VM runs a firewall or other network services. If it's agreed:

```sh
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER
exit   # log out and SSH back in so the group change applies
docker compose version   # should print a version
```

If Docker is installed but you need `sudo` for every command, either keep
using `sudo docker ...` for the steps below, or add yourself to the group
(`sudo usermod -aG docker $USER`, then log out and back in). That changes
nothing for running containers.

## Part 3 — Start Wiki.js (LAN only for now)

Everything goes in its own folder, and Compose names every container, the
network and the volume `meshcape-wiki`, so nothing touches other stacks.

```sh
sudo mkdir -p /opt/meshcape-wiki && sudo chown $USER: /opt/meshcape-wiki
cd /opt/meshcape-wiki
for f in docker-compose.yml docker-compose.lan.yml .env.example backup.sh preflight.sh; do
  curl -fsSLO "https://raw.githubusercontent.com/digitalhobo-area51/meshcape/main/wiki/$f"
done
cp .env.example .env
sed -i "s|^DB_PASSWORD=.*|DB_PASSWORD=$(openssl rand -hex 32)|" .env   # random DB password
```

If the pre-flight said port 3080 is taken, set another free port:
`sed -i 's/^WIKI_LAN_PORT=.*/WIKI_LAN_PORT=3081/' .env`.

Start the database and wiki on your LAN only (no tunnel yet):

```sh
docker compose -f docker-compose.yml -f docker-compose.lan.yml up -d db wiki
docker compose logs -f wiki      # wait for "HTTP Server: [ RUNNING ]", then Ctrl+C
```

**Check nothing else was disturbed:**

```sh
docker ps --format '{{.Names}}' | grep -v meshcape | sort | diff ~/containers-before.txt - \
  && echo "OK: every other container is still running"
docker stats --no-stream         # meshcape-wiki containers stay under their limits
free -m                          # memory still comfortable
```

If `diff` prints anything, a container that was running before isn't
running now: stop here and use the undo below.

Browse to `http://<vm-ip>:3080` and complete the setup screen:
- **Admin email** and a strong password (save it in your password manager)
- **Site URL:** `https://wiki.meshcape.io`
- Untick telemetry if you prefer

### Undo (if anything looks wrong)

This removes only the wiki and its data, nothing else:

```sh
cd /opt/meshcape-wiki
docker compose -f docker-compose.yml -f docker-compose.lan.yml down -v
cd / && sudo rm -rf /opt/meshcape-wiki
```

Or revert to the `before-meshcape-wiki` snapshot in ESXi. Note that this also
rolls back anything else that changed on the VM since the snapshot.

## Part 4 — Cloudflare Tunnel (once meshcape.io is Active)

1. Cloudflare dashboard → **Zero Trust** (first visit asks you to pick a team
   name and the **Free** plan — no card needed for the free tier).
2. **Networks → Tunnels → Create a tunnel** → *Cloudflared* → name it
   `meshcape-wiki`.
3. On the *Install connector* screen choose **Docker**, and copy only the
   long token after `--token`. Paste it as `TUNNEL_TOKEN` in `.env`.
4. Next screen, **Public hostname**:
   - Subdomain: `wiki` · Domain: `meshcape.io`
   - Service type: `HTTP` · URL: `wiki:3000`
5. On the VM, restart without the LAN override (so the wiki is only reachable
   through the tunnel) and start everything:
   ```sh
   cd /opt/meshcape-wiki
   docker compose down
   docker compose up -d
   docker compose ps     # db, wiki and tunnel should all be "running"
   ```
6. Open **https://wiki.meshcape.io**. The tunnel shows *Healthy* in the
   dashboard.

## Part 5 — Configure Wiki.js for the community

All in the **Administration** area (cog icon, top right). Menu names below
are from Wiki.js 2.x.

### Accounts — members sign up on the wiki

*Authentication* → **Local**:
- Enable **Allow self-registration**
- Leave domain whitelist empty (anyone can join)
- **Assign to group:** `Members` (create it first, below)

*Security* → enable any CAPTCHA / bot-protection option offered for login and
registration. On the Cloudflare side, also turn on **Security → Bots → Bot
Fight Mode** for the meshcape.io zone.

*Mail* → configure SMTP if you want verification and password-reset emails
(any free transactional mail service works).

### Groups — who can do what

*Groups* → create:

| Group | Purpose | Page rules |
| --- | --- | --- |
| **Guests** (built-in) | Anyone not logged in | Read pages, read assets, read comments |
| **Members** | Default for new sign-ups | Read + **write pages**, upload assets, comment |
| **Editors** | Trusted regulars | Members + manage/move/delete pages, history |
| **Administrators** (built-in) | Rob | Everything |

Optional: protect a few key pages (for example `/settings/recommended`) by
adding a *Deny write* rule on that path for Members, so only Editors can
change the official preset.

### Licence

*General* → **Content License:** CC BY-SA 4.0. Contributors' edits stay open
and reusable.

### Look and feel

*Theme* → dark/light as preferred. *General* → site title `MeshCape Wiki`,
logo URL `https://meshcape.io/favicon.svg`. *Navigation* → add a link back to
`https://meshcape.io`.

## Part 6 — Mirror pages to GitHub (Git storage)

1. On GitHub create a repo **`meshcape-wiki`** (public or private, empty).
2. Generate a deploy key on the VM:
   ```sh
   ssh-keygen -t ed25519 -N "" -f ~/meshcape-wiki-deploy -C "meshcape-wiki"
   cat ~/meshcape-wiki-deploy.pub
   ```
   GitHub → `meshcape-wiki` → *Settings → Deploy keys → Add* → paste the
   public key, tick **Allow write access**.
3. Wiki.js *Administration → Storage → Git*:
   - Authentication: **SSH** · Repository URI:
     `git@github.com:digitalhobo-area51/meshcape-wiki.git` · Branch: `main`
   - Private key: paste the contents of `~/meshcape-wiki-deploy`
     (the file **without** `.pub`)
   - Sync direction: **Bi-directional** · Schedule: every 5 minutes
   - Default author name/email: `MeshCape Wiki`
   - Save, then **Force Sync**.
4. To load the starter pages: copy the `wiki/seed/` folder's contents into the
   root of `meshcape-wiki`, push, then in Wiki.js *Storage → Git* run
   **Import Everything**.

With bi-directional sync, edits made on the wiki appear in GitHub and changes
pushed to GitHub appear on the wiki.

## Part 7 — Backups and updates

```sh
chmod +x /opt/meshcape-wiki/backup.sh
crontab -e
# add:
15 2 * * * /opt/meshcape-wiki/backup.sh >> /opt/meshcape-wiki/backup.log 2>&1
```

Backups go to `/opt/meshcape-wiki/backups`, and any older than 14 days are
deleted so they can't fill the disk. Also back up the VM from ESXi now and
then. Keep the host on a UPS if you can — the wiki goes offline during
load-shedding otherwise (content is safe in GitHub either way).

Updating Wiki.js and the tunnel:

```sh
cd /opt/meshcape-wiki
./backup.sh
docker compose pull && docker compose up -d   # only recreates meshcape-wiki containers
```

Don't run `docker system prune` or `docker volume prune` on a shared VM: they
act on every stack, not just the wiki.

## Moderation checklist

- Watch **Administration → Pages** / page **History** for recent edits;
  any revision can be restored.
- Remove spam accounts in **Users**; move trusted people to **Editors**.
- Community rule of thumb: no exact home locations, no local IPs or tokens,
  no personal details of other members.
