#!/bin/bash

# Configuration de l'application
export APP_NAME="app-name"
export DOMAIN="${APP_NAME}.${MAIN_DOMAIN}"
export PORT=""
export PORT_EXPOSED="80"

# Variables d'environnement supplémentaires
export ENV_VARS=(
  "TZ=Europe/Paris"
  "PUID=1000"
  "PGID=1000"
)
