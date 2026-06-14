#!/bin/bash
# Double-cliquer ce fichier dans Finder pour déployer sur GitHub Pages

cd "$(dirname "$0")"

echo ""
echo "═══════════════════════════════════════════"
echo "  HARMONIA · Déploiement GitHub Pages"
echo "═══════════════════════════════════════════"
echo ""

# Vérifier git
if ! command -v git &>/dev/null; then
  echo "❌  Git non installé."
  echo "    Lance : xcode-select --install"
  read -p "Appuie sur Entrée pour quitter..."
  exit 1
fi

# Username GitHub
echo "👤  Entre ton nom d'utilisateur GitHub :"
read -r GH_USER
if [ -z "$GH_USER" ]; then
  echo "❌  Nom d'utilisateur vide."
  read -p "Appuie sur Entrée pour quitter..."
  exit 1
fi

REPO_NAME="harmonia-prod"
REMOTE_URL="https://github.com/$GH_USER/$REPO_NAME.git"

# Init git
if [ ! -d ".git" ]; then
  git init
  git branch -M main
  echo "✅  Git initialisé"
fi

# Remote
git remote remove origin 2>/dev/null || true
git remote add origin "$REMOTE_URL"

# Commit
git add -A
if git diff --cached --quiet 2>/dev/null && git log --oneline -1 &>/dev/null; then
  echo "ℹ️   Aucun changement à committer."
else
  git commit -m "Harmonia — $(date '+%Y-%m-%d %H:%M')"
  echo "✅  Commit créé"
fi

echo ""
echo "🚀  Push vers GitHub..."
echo "    (GitHub va te demander ton mot de passe ou token)"
echo ""
git push -u origin main

echo ""
echo "═══════════════════════════════════════════"
echo "  ✅  FICHIERS ENVOYÉS SUR GITHUB"
echo ""
echo "  → Va sur : https://github.com/$GH_USER/$REPO_NAME"
echo "  → Settings → Pages → Deploy from branch → main → Save"
echo ""
echo "  Ton site sera en ligne à :"
echo "  https://$GH_USER.github.io/$REPO_NAME/"
echo "═══════════════════════════════════════════"
echo ""
read -p "Appuie sur Entrée pour fermer..."
