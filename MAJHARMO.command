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
  # ── 1. Résumé détaillé des fichiers modifiés ─────────────
  echo "╔═══════════════════════════════════════════╗"
  echo "║   FICHIERS MODIFIÉS (avant commit)        ║"
  echo "╚═══════════════════════════════════════════╝"
  echo ""
  git diff --cached --name-status | while IFS=$'\t' read STATUS FILE REST; do
    case "$STATUS" in
      A)  TAG="✚ NOUVEAU" ;;
      M)  TAG="✎ MODIFIÉ" ;;
      D)  TAG="✖ SUPPRIMÉ" ;;
      R*) TAG="↷ RENOMMÉ" ;;
      *)  TAG="? $STATUS" ;;
    esac
    TAILLE=""
    if [ -f "$FILE" ]; then
      B=$(wc -c < "$FILE" | tr -d ' ')
      [ "$B" -ge 1048576 ] && TAILLE="($(( B/1048576 )) Mo)" \
        || [ "$B" -ge 1024 ] && TAILLE="($(( B/1024 )) Ko)" \
        || TAILLE="(${B} o)"
    fi
    echo ""
    echo "  ┌─ $TAG  $FILE  $TAILLE"
    # Lignes modifiées (sans contexte, max 30 lignes par fichier)
    git diff --cached --unified=0 -- "$FILE" \
      | grep -E "^[+\-][^+\-]" \
      | head -30 \
      | while IFS= read -r LINE; do
          FIRST="${LINE:0:1}"
          CONTENT="${LINE:1}"
          # Tronquer les lignes trop longues
          if [ ${#CONTENT} -gt 110 ]; then
            CONTENT="${CONTENT:0:107}..."
          fi
          if [ "$FIRST" = "+" ]; then
            printf "  │  \033[32m+ %s\033[0m\n" "$CONTENT"
          else
            printf "  │  \033[31m- %s\033[0m\n" "$CONTENT"
          fi
        done
    # Compter les lignes réelles +/-
    PLUS=$(git diff --cached --unified=0 -- "$FILE" | grep -c "^+[^+]" 2>/dev/null || echo 0)
    MINUS=$(git diff --cached --unified=0 -- "$FILE" | grep -c "^-[^-]" 2>/dev/null || echo 0)
    echo "  └─ +${PLUS} lignes ajoutées  -${MINUS} lignes supprimées"
  done
  echo ""
  echo "─────────────────────────────────────────────"
  echo "  Résumé des lignes changées :"
  git diff --cached --stat | tail -1
  echo "─────────────────────────────────────────────"
  echo ""

  # ── 2. Commit ────────────────────────────────────────────
  MSG="MAJHARMO — $(date '+%Y-%m-%d %H:%M')"
  git commit -m "$MSG"
  HASH=$(git rev-parse --short HEAD)
  echo ""
  echo "  ✅ Commit créé : [$HASH] $MSG"
  echo ""

  # ── 3. Push verbose ──────────────────────────────────────
  echo "╔═══════════════════════════════════════════╗"
  echo "║   ENVOI VERS GITHUB (détail complet)      ║"
  echo "╚═══════════════════════════════════════════╝"
  echo ""
  GIT_TRACE_PACKET=0 git push --progress --verbose origin main 2>&1
  echo ""
  echo "─────────────────────────────────────────────"
  echo "  ✅ Push terminé → commit $HASH en ligne"
  echo "─────────────────────────────────────────────"
fi

echo ""
echo "✅  OPÉRATION TERMINÉE"
echo "   → https://atoutdunon-ship-it.github.io/harmonia-prod/"
echo ""
read -p "Appuie sur Entrée pour fermer..."
