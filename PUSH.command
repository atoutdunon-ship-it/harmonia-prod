#!/bin/bash
cd "$(dirname "$0")"
echo ""
echo "═══════════════════════════════════════════"
echo "  HARMONIA · Push vers GitHub Pages"
echo "═══════════════════════════════════════════"
echo ""

# S'assurer que le remote est correct (sans token)
git remote set-url origin "https://github.com/atoutdunon-ship-it/harmonia-prod.git"

# Commit automatique si des changements existent
git add -A
if git diff --cached --quiet; then
  echo "ℹ️   Aucun changement à committer."
else
  git commit -m "Harmonia — $(date '+%Y-%m-%d %H:%M')"
  echo "✅  Commit créé"
fi

echo ""
echo "🚀  Push en cours..."
echo "    (Si demandé : login = atoutdunon-ship-it / mot de passe = ton token GitHub)"
echo ""

git push -u origin main

echo ""
echo "✅  PUSH TERMINÉ"
echo "   → https://atoutdunon-ship-it.github.io/harmonia-prod/"
echo ""
read -p "Appuie sur Entrée pour fermer..."
