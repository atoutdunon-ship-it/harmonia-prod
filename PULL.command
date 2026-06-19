#!/bin/bash
cd "$(dirname "$0")"
echo ""
echo "═══════════════════════════════════════════"
echo "  HARMONIA · Récupérer les modifications"
echo "═══════════════════════════════════════════"
echo ""

# Supprimer les verrous git si présents
rm -f .git/index.lock .git/HEAD.lock .git/objects/maintenance.lock

# Remote et credentials identiques au PUSH
git remote set-url origin "https://github.com/atoutdunon-ship-it/harmonia-prod.git"
git config credential.helper osxkeychain

# Sauvegarder les modifications locales s'il y en a
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "⚠️  Modifications locales détectées — sauvegarde automatique..."
  git add -A
  git stash
  STASHED=1
  echo "✅  Sauvegardées"
  echo ""
fi

echo "🔄  Connexion à GitHub..."
echo "    (Si demandé : login = atoutdunon-ship-it  /  mot de passe = token GitHub)"
echo ""

git fetch origin main

if git merge-base --is-ancestor origin/main HEAD 2>/dev/null; then
  echo "ℹ️   Déjà à jour — aucune modification à récupérer."
else
  git reset --hard origin/main
  echo "✅  Modifications récupérées."
fi

# Restaurer les modifications locales
if [ "${STASHED}" = "1" ]; then
  echo ""
  echo "♻️   Restauration de vos modifications locales..."
  git stash pop
fi

echo ""
echo "✅  SYNCHRONISATION TERMINÉE"
echo "   → Vos fichiers sont à jour avec GitHub"
echo ""
read -p "Appuie sur Entrée pour fermer..."
