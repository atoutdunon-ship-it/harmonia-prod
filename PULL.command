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

echo "🔄  Connexion à GitHub..."
echo ""

git fetch origin

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" = "$REMOTE" ]; then
  echo "ℹ️   Déjà à jour — aucune modification distante à récupérer."

elif git merge-base --is-ancestor "$LOCAL" "$REMOTE" 2>/dev/null; then
  # Le remote EST en avance sur le local → safe to pull
  echo "✅  Nouvelles modifications détectées depuis GitHub."
  echo "    Mise à jour en cours..."
  echo ""

  # Sauvegarder les modifications locales non commitées s'il y en a
  STASHED=0
  if ! git diff --quiet || ! git diff --cached --quiet || git ls-files --others --exclude-standard | grep -q .; then
    echo "⚠️  Modifications locales détectées — sauvegarde temporaire..."
    git add -A
    git stash push -m "PULL-auto-stash-$(date '+%Y%m%d-%H%M%S')"
    STASHED=1
    echo "✅  Sauvegardées"
    echo ""
  fi

  git reset --hard origin/main
  echo "✅  Fichiers mis à jour depuis GitHub."

  if [ "$STASHED" = "1" ]; then
    echo ""
    echo "♻️   Restauration de vos modifications locales..."
    git stash pop || echo "⚠️  Conflit lors de la restauration — vérifiez manuellement."
  fi

else
  # Local en avance sur le remote (modifications locales non pushées)
  echo "⚠️  Vous avez des modifications locales non encore envoyées."
  echo "    Lancez d'abord PUSH.command pour envoyer vos modifications."
  echo "    Ensuite, PULL récupérera les modifications de votre collaborateur."
fi

echo ""
echo "✅  TERMINÉ"
echo "   → https://atoutdunon-ship-it.github.io/harmonia-prod/"
echo ""
read -p "Appuie sur Entrée pour fermer..."
