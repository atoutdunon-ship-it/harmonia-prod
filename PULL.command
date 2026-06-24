#!/bin/bash
cd "$(dirname "$0")"
echo ""
echo "═══════════════════════════════════════════"
echo "  HARMONIA · Récupérer les modifications"
echo "═══════════════════════════════════════════"
echo ""

# Supprimer les verrous git si présents
rm -f .git/index.lock .git/HEAD.lock .git/objects/maintenance.lock

# Remote et credentials
git remote set-url origin "https://github.com/atoutdunon-ship-it/harmonia-prod.git"
git config credential.helper osxkeychain

# Sauvegarder les modifications locales s'il y en a
STASHED=0
if ! git diff --quiet || ! git diff --cached --quiet || git ls-files --others --exclude-standard | grep -q .; then
  echo "⚠️  Modifications locales détectées — sauvegarde automatique..."
  git add -A
  git stash push -m "PULL-auto-stash-$(date '+%Y%m%d-%H%M%S')"
  STASHED=1
  echo "✅  Sauvegardées"
  echo ""
fi

echo "🔄  Connexion à GitHub..."
echo "    (Si demandé : login = atoutdunon-ship-it  /  mot de passe = token GitHub)"
echo ""

# fetch origin (sans préciser main = met à jour origin/main correctement)
git fetch origin

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" = "$REMOTE" ]; then
  echo "ℹ️   Déjà à jour — aucune modification à récupérer."
else
  git reset --hard origin/main
  echo "✅  Modifications récupérées depuis GitHub."
fi

# Restaurer les modifications locales
if [ "$STASHED" = "1" ]; then
  echo ""
  echo "♻️   Restauration de vos modifications locales..."
  git stash pop
fi

echo ""
echo "✅  SYNCHRONISATION TERMINÉE"
echo "   → Vos fichiers sont à jour avec GitHub"
echo ""
read -p "Appuie sur Entrée pour fermer..."
