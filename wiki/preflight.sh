#!/usr/bin/env bash
# MeshCape wiki: pre-flight check for an EXISTING VM.
#
# READ-ONLY. This script changes nothing: no installs, no restarts, no files
# written. It only looks at the machine and reports whether the wiki can be
# added without getting in the way of what is already running there.
#
# Run it as your normal user (no sudo needed) and keep the output:
#   bash preflight.sh | tee ~/meshcape-preflight-before.txt
#
# The wiki needs roughly: 1-1.5 GB RAM (capped at 2.2 GB), 3-5 GB disk,
# one free TCP port on the LAN for first-time setup (3080 by default).

PORT="${WIKI_LAN_PORT:-3080}"
WARN=0
ok()   { printf '  [ OK ]  %s\n' "$*"; }
warn() { printf '  [WARN]  %s\n' "$*"; WARN=$((WARN+1)); }
info() { printf '          %s\n' "$*"; }
section() { printf '\n== %s\n' "$*"; }

section "Machine"
if [ -r /etc/os-release ]; then . /etc/os-release; info "OS: ${PRETTY_NAME:-unknown}"; else warn "Can't read /etc/os-release (not a normal Linux install?)"; fi
info "Kernel: $(uname -r)   Arch: $(uname -m)"
case "$(uname -m)" in x86_64|aarch64|arm64) ok "CPU architecture is supported by the wiki images";; *) warn "Unusual CPU architecture: $(uname -m)";; esac
info "CPUs: $(nproc)   Load (1/5/15 min): $(cut -d' ' -f1-3 /proc/loadavg)"
info "Uptime: $(uptime -p 2>/dev/null || uptime)"

section "Memory"
avail_mb=$(awk '/MemAvailable/ {print int($2/1024)}' /proc/meminfo)
total_mb=$(awk '/MemTotal/ {print int($2/1024)}' /proc/meminfo)
info "Total: ${total_mb} MB   Available now: ${avail_mb} MB"
if [ "${avail_mb:-0}" -ge 4096 ]; then ok "Plenty of free memory"
elif [ "${avail_mb:-0}" -ge 2560 ]; then ok "Enough free memory (the wiki is capped at about 2.2 GB)"
else warn "Less than 2.5 GB available: the wiki may squeeze what is already running"; fi
swap_mb=$(awk '/SwapTotal/ {print int($2/1024)}' /proc/meminfo); info "Swap: ${swap_mb} MB"

section "Disk"
df -h / 2>/dev/null | sed 's/^/          /'
root_free_gb=$(df -BG --output=avail / 2>/dev/null | tail -1 | tr -dc '0-9')
if [ -n "$root_free_gb" ] && [ "$root_free_gb" -ge 10 ]; then ok "${root_free_gb} GB free on /"
elif [ -n "$root_free_gb" ] && [ "$root_free_gb" -ge 5 ]; then ok "${root_free_gb} GB free on / (enough, but keep an eye on it)"
else warn "Under 5 GB free on /"; fi

section "Docker"
if command -v docker >/dev/null 2>&1; then
  ok "Docker is installed: $(docker --version 2>/dev/null)"
  if docker compose version >/dev/null 2>&1; then ok "Compose plugin: $(docker compose version --short 2>/dev/null)"
  else warn "'docker compose' (v2 plugin) not found; only the older docker-compose may be present"; fi
  if docker info >/dev/null 2>&1; then
    ok "Your user can talk to Docker without sudo"
    dr=$(docker info --format '{{.DockerRootDir}}' 2>/dev/null); info "Docker data folder: ${dr}"
    info "Containers running now (these must still be running afterwards):"
    docker ps --format '            {{.Names}}  ({{.Image}})  {{.Status}}  {{.Ports}}' 2>/dev/null
    [ -z "$(docker ps -q 2>/dev/null)" ] && info "            (none)"
    info "Compose projects:"; docker compose ls 2>/dev/null | sed 's/^/            /'
    if docker ps -a --format '{{.Names}}' 2>/dev/null | grep -qi 'meshcape'; then warn "Containers with 'meshcape' in the name already exist"; else ok "No existing meshcape containers (no name clashes)"; fi
    if docker volume ls --format '{{.Name}}' 2>/dev/null | grep -qi 'meshcape'; then warn "Docker volumes with 'meshcape' in the name already exist"; else ok "No existing meshcape volumes"; fi
    if docker ps --format '{{.Image}}' 2>/dev/null | grep -qi cloudflared; then info "Note: a cloudflared container is already running here (fine; the wiki gets its own)"; fi
  else
    warn "Docker is installed but your user can't use it without sudo (not in the 'docker' group?)"
  fi
else
  warn "Docker is NOT installed. Installing it adds firewall (iptables) rules and a background service: check with Claude before installing on a shared VM"
  command -v podman >/dev/null 2>&1 && info "Podman is installed: $(podman --version)"
fi

section "Network ports"
if command -v ss >/dev/null 2>&1; then
  if ss -ltnH 2>/dev/null | awk '{print $4}' | grep -Eq "[:.]${PORT}\$"; then warn "TCP port ${PORT} is already in use: pick another with WIKI_LAN_PORT=<port>"
  else ok "TCP port ${PORT} is free for first-time setup"; fi
  if ss -ltnH 2>/dev/null | awk '{print $4}' | grep -Eq '[:.]3000$'; then info "Port 3000 is in use by something else here (that's why the wiki uses ${PORT} on the LAN)"; fi
  info "Listening TCP ports now:"; ss -ltnH 2>/dev/null | awk '{print $4}' | sed 's/.*[:.]//' | sort -n | uniq | tr '\n' ' ' | sed 's/^/            /'; echo
else
  info "'ss' not available; skipping port check"
fi

section "Firewall and services"
for s in ufw firewalld; do systemctl is-active --quiet "$s" 2>/dev/null && info "$s is active (Docker manages its own rules; nothing needs opening for the tunnel)"; done
failed=$(systemctl --failed --no-legend 2>/dev/null | wc -l); info "Failed systemd units right now: ${failed} (baseline, to compare afterwards)"

section "Install folder"
if [ -e /opt/meshcape-wiki ]; then warn "/opt/meshcape-wiki already exists: check what is in it before going on"; else ok "/opt/meshcape-wiki does not exist yet"; fi

section "Result"
if [ "$WARN" -eq 0 ]; then echo "  No warnings. Safe to go ahead with Part 3 of SETUP.md."
else echo "  ${WARN} warning(s) above. Send this output to Claude before going on."; fi
