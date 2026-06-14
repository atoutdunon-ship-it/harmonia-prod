#!/bin/bash
# ═══════════════════════════════════════════════
#  HARMONIA — Script de déploiement GitHub Pages
#  Usage : bash ~/COWORK/Harmonia/deploy.sh
# ═══════════════════════════════════════════════

set -e
REPO_NAME="harmonia-prod"
DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "═══════════════════════════════════════════"
echo "  HARMONIA · Déploiement GitHub Pages"
echo "═══════════════════════════════════════════"
echo ""

# ── 1. Vérifier git ──────────────────────────
if ! command -v git &>/dev/null; then
  echo "❌  Git non installé. Installe-le via : xcode-select --install"
  exit 1
fi

cd "$DIR"
echo "📁  Dossier : $DIR"
echo ""

# ── 2. Récupérer le username GitHub ──────────
echo "👤  Entre ton nom d'utilisateur GitHub :"
read -r GH_USER
if [ -z "$GH_USER" ]; then
  echo "❌  Nom d'utilisateur vide."
  exit 1
fi

# ── 3. Initialiser git si besoin ─────────────
if [ ! -d ".git" ]; then
  git init
  git branch -M main
  echo "✅  Git initialisé"
fi

# ── 4. Créer le repo via gh CLI ou instructions ──
REMOTE_URL="https://github.com/$GH_USER/$REPO_NAME.git"

if command -v gh &>/dev/null; then
  echo ""
  echo "🔧  GitHub CLI détecté — création du repo..."
  gh repo create "$REPO_NAME" --public --source=. --remote=origin --push 2>/dev/null || {
    # Repo existe déjà, juste configurer le remote
    git remote remove origin 2>/dev/null || true
    git remote add origin "$REMOTE_URL"
  }
else
  echo ""
  echo "ℹ️   GitHub CLI absent — repo à créer manuellement si pas encore fait."
  echo "     → Va sur : https://github.com/new"
  echo "     → Nom du repo : $REPO_NAME"
  echo "     → Visibilité : Public"
  echo "     → NE PAS initialiser avec README"
  echo ""
  echo "Appuie sur [Entrée] une fois le repo créé sur GitHub..."
  read -r

  # Configurer le remote
  git remote remove origin 2>/dev/null || true
  git remote add origin "$REMOTE_URL"
fi

# ── 5. Commit + Push ─────────────────────────
echo ""
echo "📦  Ajout des fichiers..."
git add -A

# Vérifier s'il y a des changements à committer
if git diff --cached --quiet; then
  echo "ℹ️   Aucun changement depuis le dernier commit."
else
  git commit -m "Harmonia — déploiement $(date '+%Y-%m-%d %H:%M')"
  echo "✅  Commit créé"
fi

echo ""
echo "🚀  Push vers GitHub..."
git push -u origin main

# ── 6. Activer GitHub Pages ──────────────────
if command -v gh &>/dev/null; then
  echo ""
  echo "🌐  Activation GitHub Pages..."
  gh api repos/"$GH_USER"/"$REPO_NAME"/pages \
    --method POST \
    -f source='{"branch":"main","path":"/"}' \
    2>/dev/null || echo "ℹ️   GitHub Pages déjà actif ou à activer manuellement."
fi

# ── 7. Résumé ────────────────────────────────
echo ""
echo "═══════════════════════════════════════════"
echo "  ✅  DÉPLOIEMENT TERMINÉ"
echo ""
echo "  Repo    : https://github.com/$GH_USER/$REPO_NAME"
echo "  Site    : https://$GH_USER.github.io/$REPO_NAME/"
echo ""
echo "  GitHub Pages sera actif dans ~60 secondes."
echo "  Pour les mises à jour suivantes : git add . && git commit -m 'update' && git push"
echo "═══════════════════════════════════════════"
echo ""
