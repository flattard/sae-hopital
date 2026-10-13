#!/bin/bash

USER_SSH="backupuser"
IP_cible="10.0.0.6"
USER_BDD="sauvegarde_user"
PASS_BDD="tpRT9025"
NOM_BDD="bdd_exemple"
DOSSIER_DEST="/var/stockage/sauvegardes"

DATE=$(date +%Y-%m-%d_%H-%M-%S)

mkdir -p "$DOSSIER_DEST"

ssh "${USER_SSH}@${IP_cible}" "mysqldump -u ${USER_BDD} -p'${PASS_BDD}' ${NOM_BDD}" | gzip > "${DOSSIER_DEST}/${NOM_BDD}_${DATE}.sql.gz"

find "$DOSSIER_DEST" -type f -mtime +30 -delete


