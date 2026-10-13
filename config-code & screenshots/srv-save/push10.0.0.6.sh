#!/bin/bash

USER_SSH="backupuser"
IP_cible="10.0.0.6"
USER_BDD="sauvegarde_user"
PASS_BDD="tpRT9025"
NOM_BDD="bdd_exemple"
DOSSIER_DEST="/var/stockage/sauvegardes"

cd "$DOSSIER_DEST" || exit 1

IFS=$'\n' read -r -d '' -a FICHIERS < <(ls -t "${NOM_BDD}"_*.sql.gz 2>/dev/null && printf '\0')

echo "Choisir la sauvegarde :"
select CHOIX in "${FICHIERS[@]}" "Quitter"; do
    [ "$CHOIX" = "Quitter" ] && exit 0
    [ -n "$CHOIX" ] && break
done

gunzip -c "$CHOIX" | ssh "${USER_SSH}@${IP_cible}" "mysql -u ${USER_BDD} -p'${PASS_BDD}' ${NOM_BDD}"
RETOURS=( "${PIPESTATUS[@]}" )

if [ "${RETOURS[0]}" -eq 0 ] && [ "${RETOURS[1]}" -eq 0 ]; then
    echo "✅ Restauration réussie"
else
    echo "❌ Erreur lors de la restauration"
fi
