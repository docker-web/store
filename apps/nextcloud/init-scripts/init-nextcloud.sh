#!/bin/bash
set -e

# -----------------------------
# Nextcloud initialization script
# -----------------------------
# This script enables/disables predefined apps and mounts /mnt/media as external storage.
# By default, external storage is mounted read-only for safety.
# Set MEDIA_RW=true to allow write access.
# -----------------------------

# Define apps
APPS_PRE_INSTALLED="calendar contacts mail notes"
APPS_ENABLED="files_external"
APPS_DISABLED="activity dashboard recommendations"

# Permissions:
# 1 = read-only
# 31 = read/write/delete (full)
if [ "$MEDIA_RW" = "true" ]; then
  MEDIA_PERMS=31
  echo "⚠️  MEDIA_RW=true → External storage will be mounted with read/write permissions!"
else
  MEDIA_PERMS=1
  echo "🔒 MEDIA_RW not set → External storage will be mounted as read-only"
fi

# Enable preinstalled apps
for app in $APPS_PRE_INSTALLED; do
  echo "➡ Enabling preinstalled app: $app"
  php occ app:enable "$app" || true
done

# Enable additional apps
for app in $APPS_ENABLED; do
  echo "➡ Enabling additional app: $app"
  php occ app:enable "$app" || true
done

# Disable apps
for app in $APPS_DISABLED; do
  echo "➡ Disabling app: $app"
  php occ app:disable "$app" || true
done

# Create external storage for /mnt/media mounted at "/"
EXISTS=$(php occ files_external:list | grep -w "/" || true)
if [ -z "$EXISTS" ]; then
  echo "➡ Creating external storage for /mnt/media mounted at /"
  php occ files_external:create "/" local null::null \
    -c datadir="/mnt/media" \
    --permissions $MEDIA_PERMS
else
  echo "✔ External storage for /mnt/media already exists"
fi

echo "✅ Nextcloud initialization completed"
