# MeshCape wiki — setup guide

How to run **wiki.meshcape.io** on a VM on the home ESXi host, at zero cost.

```
Internet ──► Cloudflare (wiki.meshcape.io) ══ tunnel ══► cloudflared ──► Wiki.js ──► PostgreSQL
                                                         └────────── Ubuntu VM on ESXi ──────────┘
```

- **No ports opened** on the home router and the home IP stays hidden — the
  VM makes an outbound connection to Cloudflare.
- **Members sign up on the wiki itself** (email + password). No GitHub,
  Google or other third-party account needed.
- **Every page is mirrored to a GitHub repo** as Markdown, for off-site
  backup and so Claude can read and tidy pages.

> **Blocked until the domain is on Cloudflare.** Parts 1–3 can be done now.
> Part 4 (the tunnel) needs `meshcape.io` active on Cloudflare first.

---

## Part 1 — Create the VM on ESXi

1. Download the **Ubuntu Server 24.04 LTS** ISO and upload it to a datastore
   (ESXi host client → *Storage* → *Datastore browser* → *Upload*).
2. *Virtual Machines* → *Create / Register VM* → *Create a new virtual machine*.
   - Name: `meshcape-wiki`
   - Guest OS: Linux → Ubuntu Linux (64-bit)
   - **2 vCPU, 4 GB RAM, 32 GB disk** (thin provisioned is fine)
   - Network: your LAN port group
   - CD/DVD: *Datastore ISO file* → the Ubuntu ISO, *Connect at power on*
3. Power on, open the console and install Ubuntu:
   - Choose a **static IP** (or set a DHCP reservation on the router)
   - Tick **Install OpenSSH server**
   - Skip the optional snaps
4. After reboot, disconnect the ISO and SSH in from your PC:
   ```sh
   ssh <your-user>@<vm-ip>
   sudo apt update && sudo apt full-upgrade -y
   sudo apt install -y open-vm-tools unattended-upgrades
   sudo timedatectl set-timezone Africa/Johannesburg
   ```

## Part 2 — Install Docker

```sh
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER
exit   # log out and SSH back in so the group change applies
docker compose version   # should print a version
```

## Part 3 — Start Wiki.js (LAN only for now)

```sh
sudo mkdir -p /opt/meshcape-wiki && sudo chown $USER: /opt/meshcape-wiki
cd /opt/meshcape-wiki
```

Copy in `docker-compose.yml`, `.env.example` and `backup.sh` from this folder
of the repo (or `git clone https://github.com/digitalhobo-area51/meshcape.git`
and copy them out of `wiki/`). Then:

```sh
cp .env.example .env
openssl rand -base64 32          # paste the result as DB_PASSWORD in .env
nano .env                         # leave TUNNEL_TOKEN for Part 4
```

For first-time setup before the tunnel exists:

1. In `docker-compose.yml`, uncomment the two `ports:` lines under `wiki`.
2. Start only the database and wiki:
   ```sh
   docker compose up -d db wiki
   docker compose logs -f wiki      # wait for "HTTP Server: [ RUNNING ]", then Ctrl+C
   ```
3. Browse to `http://<vm-ip>:3000` and complete the setup screen:
   - **Admin email** and a strong password (save it in your password manager)
   - **Site URL:** `https://wiki.meshcape.io`
   - Untick telemetry if you prefer

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
5. On the VM, re-comment the `ports:` lines (the wiki should only be reachable
   through the tunnel) and start everything:
   ```sh
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

Also snapshot or back up the VM from ESXi occasionally. Keep the host on a UPS
if you can — the wiki goes offline during load-shedding otherwise (content is
safe in GitHub either way).

Updating Wiki.js and the tunnel:

```sh
cd /opt/meshcape-wiki
./backup.sh
docker compose pull && docker compose up -d
docker image prune -f
```

## Moderation checklist

- Watch **Administration → Pages** / page **History** for recent edits;
  any revision can be restored.
- Remove spam accounts in **Users**; move trusted people to **Editors**.
- Community rule of thumb: no exact home locations, no local IPs or tokens,
  no personal details of other members.
