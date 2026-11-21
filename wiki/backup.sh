#!/usr/bin/env bash
# Nightly database backup for the MeshCape wiki.
# Page content is also mirrored to GitHub by Wiki.js Git storage; this
# backup additionally keeps users, groups, permissions and settings.
#
# Install:  chmod +x backup.sh
#           crontab -e   →   15 2 * * * /opt/meshcape-wiki/backup.sh
set -euo pipefail

cd "$(dirname "$0")"
DEST="${BACKUP_DIR:-$PWD/backups}"
KEEP_DAYS="${KEEP_DAYS:-14}"
mkdir -p "$DEST"

STAMP="$(date +%Y-%m-%d_%H%M)"
docker compose exec -T db pg_dump -U wikijs -d wiki | gzip > "$DEST/wiki_$STAMP.sql.gz"

# Drop backups older than KEEP_DAYS days
find "$DEST" -name 'wiki_*.sql.gz' -mtime "+$KEEP_DAYS" -delete

echo "Backup written: $DEST/wiki_$STAMP.sql.gz"
