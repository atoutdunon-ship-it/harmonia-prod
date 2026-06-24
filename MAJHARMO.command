#!/bin/bash
cd "$(dirname "$0")"
echo ""
echo "═══════════════════════════════════════════"
echo "  HARMONIA · Mise à jour GitHub"
echo "═══════════════════════════════════════════"
echo ""

# Supprimer les verrous git si présents
rm -f .git/index.lock .git/HEAD.lock .git/objects/maintenance.lock

# Remote et credentials
git remote set-url origin "https://github.com/atoutdunon-ship-it/harmonia-prod.git"
git config credential.helper osxkeychain
git config user.email "atout.dunon@gmail.com"
git config user.name "Harmonia"

# ── PULL : récupérer les dernières modifications ─────────────
echo "🔄  Récupération des modifications en cours..."
git fetch origin

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" != "$REMOTE" ]; then
  git reset --hard origin/main
  echo "✅  Fichiers mis à jour depuis GitHub"
else
  echo "ℹ️   Déjà à jour"
fi

echo ""

# ── PUSH : envoyer vos modifications ────────────────────────
git add -A

if git diff --cached --quiet; then
  echo "ℹ️   Aucune modification locale à envoyer."
else
  # ── Liste détaillée des fichiers à pousser ───────────────
  echo "📋  Fichiers inclus dans ce push :"
  echo "───────────────────────────────────"
  git diff --cached --name-status | while IFS=$'\t' read STATUS FILE; do
    case "$STATUS" in
      A) LABEL="[NOUVEAU ]" ;;
      M) LABEL="[MODIFIÉ ]" ;;
      D) LABEL="[SUPPRIMÉ]" ;;
      R*) LABEL="[RENOMMÉ ]" ;;
      *) LABEL="[$STATUS      ]" ;;
    esac
    SIZE=""
    if [ -f "$FILE" ]; then
      BYTES=$(wc -c < "$FILE" | tr -d ' ')
      if [ "$BYTES" -ge 1024 ]; then
        KB=$(( BYTES / 1024 ))
        SIZE="  (${KB} Ko)"
      else
        SIZE="  (${BYTES} o)"
      fi
    fi
    echo "  $LABEL  $FILE$SIZE"
  done
  echo "───────────────────────────────────"
  TOTAL=$(git diff --cached --name-only | wc -l | tr -d ' ')
  echo "  Total : $TOTAL fichier(s)"
  echo ""

  git commit -m "MAJHARMO — $(date '+%Y-%m-%d %H:%M')"
  echo ""
  echo "🚀  Envoi vers GitHub..."
  echo "    (Si demandé : login = atoutdunon-ship-it"
  echo "                  mot de passe = token GitHub personnel)"
  echo ""
  git push --progress origin main 2>&1
  echo ""
  echo "✅  Modifications envoyées"
fi

echo ""
echo "✅  OPÉRATION TERMINÉE"
echo "   → https://atoutdunon-ship-it.github.io/harmonia-prod/"
echo ""
read -p "Appuie sur Entrée pour fermer..."
