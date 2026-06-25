# HARMONIA — Historique des modifications
### Site : https://atoutdunon-ship-it.github.io/harmonia-prod/
### Fichiers sources : harmonia-shared.src.js · harmonia-shared.src.css · build.py
### Déploiement : MAJHARMO.command → GitHub Pages

---

## GUIDE DE VERSION
- Sources éditables : `harmonia-shared.src.js` / `harmonia-shared.src.css`
- Commande build : `python3 build.py` → génère `harmonia-shared.js` + `harmonia-shared.css`
- Bump version : `sed -i 's/v=XX/v=YY/g' *.html`
- Push : `MAJHARMO.command`

---

## CONTRAINTE DE SÉCURITÉ PERMANENTE
> Le compte et profil **super admin (PROD)** ne peut pas être modifié, ni supprimé sans le mot de passe **`Music7`**

---

## JOURNAL DES VERSIONS

---

### v1–v10 — Fondations du site statique
**Demandes :**
- Création du site HARMONIA — maison de production musicale Cabo Verde
- Page d'accueil avec sélecteur de langue (PT / FR / EN / ES)
- Charte graphique : noir dominant, bleu Navy, blanc — sans favicon ni icônes décoratives
- Structure multi-pages : qui-sommes-nous, artistes, cesaria, contact, musique, boutique, actualités

**Éléments codés :**
- `index.html` — page d'accueil plein écran, médaillon Cesária, drapeaux langue, footer fixe
- `harmonia-shared.src.js` — base JS partagée (DB localStorage, navigation, i18n)
- `harmonia-shared.src.css` — charte graphique complète (--navy, --accent2, --dark)
- `build.py` — script de build + minification JS/CSS
- `MAJHARMO.command` — script bash de push GitHub

---

### v11–v20 — Système d'administration & rôles
**Demandes :**
- Ajouter un rôle **superadmin** et promouvoir le compte PROD
- Créer un **système de modules** : activer/désactiver les sections du site
- Système **RBAC** (4 rôles) : superadmin, administrateur, editor, membre
- Authentification email + mot de passe + rôle membre
- Protection **Music7** : compte superadmin non modifiable/supprimable sans ce mot de passe

**Éléments codés :**
- `admin.html` — panneau administration complet (sidebar, sections, toggles modules)
- `harmonia-shared.src.js` :
  - `DB.users[]` — structure utilisateurs avec rôles et permissions
  - `defaultUsers()` — utilisateurs par défaut dont PROD/superadmin
  - `doLogin()` / `doLogout()` — authentification
  - `isSuperAdmin()` / `isEditor()` / `isAdmin()` — vérifications de rôles
  - `defaultModules()` — config modules nav + utilitaires
  - `applyModules()` — affichage/masquage items nav selon `enabled`
  - Protection Music7 : vérification mot de passe avant toute modif superadmin

---

### v21–v30 — Contenu dynamique & DB
**Demandes :**
- Ajouter champ `active` aux données (events, products, artists, news)
- Implémenter les **toggles on/off** en mode édition sur les cartes
- Masquer les éléments désactivés pour les visiteurs publics
- Module **PANIER** — sessionStorage + mini-cart + panier.html
- Déployer Harmonia sur **GitHub Pages**

**Éléments codés :**
- `harmonia-shared.src.js` :
  - `DB.artists[]`, `DB.events[]`, `DB.products[]`, `DB.news[]` — champ `active`
  - `isItemActive()` — vérification visibilité publique
  - `renderArtists()`, `renderNews()`, `renderShop()` — masquage si `!active`
  - Système panier : `addToCart()`, `openMiniCart()`, `cartTotal()`
  - `sessionStorage` panier entre pages
- `panier.html` — page panier complète avec récapitulatif et checkout
- `.github/workflows/` — déploiement GitHub Pages automatique

---

### v31–v40 — Mode Édition inline
**Demandes :**
- **Mode Édition persistant** — reste actif entre les pages (sessionStorage)
- Bouton "Éditer le site" dans la sidebar admin
- Import image artiste en Mode Édition (upload base64)
- Réécriture complète **Mode Édition v2**
- Toolbar flottante : police, taille, B/I/U/S, couleur, alignement

**Éléments codés :**
- `harmonia-shared.src.js` :
  - `_editModeActive` — flag persistant sessionStorage
  - `toggleEditMode()` — activation/désactivation avec barre de contrôle
  - `_showFloatingToolbar()` — toolbar WYSIWYG sur clic élément éditable
  - `injectAdminReturnBtn()` — bouton retour admin en mode édition
  - `data-editable-key` — attribut sur éléments éditables
  - Import image : `<input type="file">` → base64 → `DB.images[key]`
  - `applyImages()` — restauration images sauvegardées

---

### v41–v54 — Traduction & styles inline
**Demandes :**
- Étendre le modèle de données pour **sauvegarder les styles inline** (police, couleur…)
- **Traduction automatique multi-langues** lors de la sauvegarde
- Tester et valider le mécanisme de traduction

**Éléments codés :**
- `harmonia-shared.src.js` :
  - `DB.pageTexts{}` — stockage textes édités par langue et par clé
  - `applyPageTexts()` — restauration styles et textes au chargement
  - `_autoTranslate()` — traduction automatique PT/FR/EN/ES à la sauvegarde
  - `LANGS{}` — dictionnaires complets 4 langues (11, 130, 249, 368 lignes src)
  - `T(key)` — fonction de traduction avec fallback français

> **Version v54 — premier push stable multi-langues**

---

### v55–v62 — Fix mode édition + persistence
**Demande :**
- Fix edit mode persistence sur toutes les sous-pages
- Bouton "Quitter Mode éditeur" repositionné pour ne pas chevaucher la barre

**Éléments codés :**
- `harmonia-shared.src.js` :
  - `injectAdminReturnBtn()` : `bottom:64px` (au-dessus de la barre éditeur h=52px), `z-index:99999`
  - Auto-activation mode édition si `sessionStorage.editMode = '1'`
  - Bypass admin dans `applyMaintenanceMode()` étendu au rôle `'editor'`
  - Dual-check : `currentUser` + `sessionStorage.getItem('harmonia_user')` (timing fix)

---

### v63–v69 — Artistes URBAN + biographies
**Demandes :**
- Rechercher et intégrer les **artistes URBAN** (catégorie)
- Rechercher biographies et discographies — 3 nouveaux artistes

**Éléments codés :**
- `harmonia-shared.src.js` — `defaultArtists()` enrichi :
  - Elida Almeida, Ceuzany, Lucibela, Fábio, Jenifer, Neuza, Elly, Indira, Ley Lazz, Mureno, Neguinho, Sonia Sousa
  - Biographies longues (bioShort + bioLong) + discographies + liens Spotify/YouTube/Instagram
  - Catégories : `traditional` / `urban`
  - `renderArtistsByCategory()` — affichage par groupe

---

### v70 — Fix cache + modules hidden/maintenance
**Demandes :**
- Le bouton "Quitter Mode éditeur" ne fonctionne plus
- La page "Qui sommes-nous" reste visible après désactivation

**Causes racines :**
- HTML sur `?v=67` → navigateur chargeait ancienne version du JS (commit d74fe37)
- `applyMaintenanceMode()` ne gérait pas le mode `hidden` (seulement `maintenance`)

**Éléments codés :**
- `harmonia-shared.src.js` :
  - `applyMaintenanceMode()` : redirect non-admins vers index.html pour pages `hidden`
  - Mode `hidden` : `window.location.href = 'index.html'` si non-admin
  - Mode `maintenance` : overlay avec message
- Bump HTML v67 → v70 (force rechargement JS propre)

---

### v71–v72 — MAJHARMO.command amélioré
**Demande :**
- Afficher point par point les mises à jour poussées vers GitHub
- Voir les fichiers modifiés, les lignes changées, le détail du push

**Éléments codés :**
- `MAJHARMO.command` — réécriture complète section push :
  - Liste fichiers avec tags ✚ NOUVEAU / ✎ MODIFIÉ / ✖ SUPPRIMÉ / ↷ RENOMMÉ
  - Taille fichier en Ko/Mo
  - Lignes modifiées en couleur (vert `+` / rouge `-`) via `git diff --cached --unified=0`
  - Compteurs `+N ajoutées / -N supprimées` par fichier
  - Hash du commit affiché
  - `git push --progress --verbose origin main 2>&1`

---

### v73 — Corrections visuelles majeures
**Demandes :**
- "Choose your language" toujours en anglais pour tous les visiteurs
- Lisibilité et organisation des menus en vue mobile — amélioration pro
- Logos de bas de page alignés au milieu sur toutes les pages
- Bas de page de `contact.html` doit correspondre aux autres pages

**Éléments codés :**
- `index.html` :
  - `<span>Choose your language</span>` — attribut `data-i18n-home` retiré (toujours anglais)
  - `HOME_LANGS{}` — toutes les langues retournent `choose_lang:'Choose your language'`
- `harmonia-shared.src.css` :
  - `.footer-logo` : `display:flex; justify-content:center; width:100%`
  - `.footer-logo img` : `margin:0 auto; display:block`
  - Menu mobile (≤900px) : hamburger animé, slide-down avec backdrop-filter blur(20px)
  - Items nav mobile : padding 18px 28px, font 11px, letter-spacing 3px
  - Page active : `border-left:2px solid #2ecc80`
  - Bouton Connect : pleine largeur, vert, bas du menu
  - Small mobile (≤640px) : sections, hero, titres, CTA, cards artistes adaptés
- `contact.html` : image footer `cartes-iles.png` → `logo-base.png` (height:40px)
- `mon-compte.html` : référence CSS corrompue `?v=73?v=46` → `?v=73`

---

### v74 — Section "Artistes en Promo" + galerie espacée
**Demandes :**
- 3 emplacements en bas de "Qui sommes-nous" pour artistes en promo
- Module admin "Artistes en promo" — sélection depuis la liste existante
- Photos de la galerie artistes ne doivent pas être collées

**Éléments codés :**
- `harmonia-shared.src.css` :
  - `.artists-grid` : `gap:3px` → `gap:16px` + `padding:16px`
  - `.promo-artist-card`, `.promo-artist-photo`, `.promo-artist-info`, `.promo-artist-btn` — nouveaux styles
  - `.promo-artist-slot-empty` — emplacement vide stylé
  - Responsive promo : 3 colonnes desktop → 1 colonne ≤640px
- `harmonia-shared.src.js` :
  - `DB.promoArtists = [null, null, null]` — init si absent
  - `renderPromoArtists()` — rendu 3 cartes depuis `DB.promoArtists[]`
  - Appel `try { renderPromoArtists(); } catch(e) {}` dans init global
- `qui-sommes-nous.html` :
  - `<section class="promo-artists-section">` avec `<div id="promo-artists-grid">`
- `admin.html` :
  - `<div id="promo-artists-admin">` dans la section Modules
  - `_renderPromoArtistsAdmin()` — 3 dropdowns listant `DB.artists`
  - `_saveAllPromoArtists()` — sauvegarde dans `DB.promoArtists`
  - Affiché automatiquement après `_renderModulesCustom()`

---

### v75 — Fix persistance langue + "Choose your language" visible
**Demandes :**
- La langue choisie sur la page d'accueil doit impacter tout le site
- Vérifier la continuité en vue normale et vue GSM
- "Choose your language" doit apparaître sur la page d'accueil

**Problèmes identifiés :**
- `sessionStorage` seul → perd la langue si l'onglet est tué en arrière-plan (iOS)
- `.home-flags-line span` à `opacity:0.3` → quasi invisible

**Éléments codés :**
- `harmonia-shared.src.js` :
  - `currentLang` — lecture cascade : `sessionStorage → localStorage → 'pt'`
  - `setLang()` — double-write `sessionStorage` + `localStorage`
  - `initLang()` — cascade + resynchronisation sessionStorage depuis localStorage
- `index.html` :
  - `defaultLang` — cascade `sessionStorage → localStorage → 'pt'`
  - `enterSite()` — double-write `sessionStorage` + `localStorage`
  - `.home-flags-line span` : `color:rgba(255,255,255,0.3)` → `rgba(255,255,255,0.72)`
  - Mobile ≤600px : lisibilité renforcée sur tous les textes (0.78 → 0.82 selon élément)

---

### v76 — Désactivation module Boutique
**Demande :**
- Désactiver le module Boutique sans le supprimer, pour le réactiver plus tard
- Ne pas l'afficher dans le menu

**Éléments codés :**
- `harmonia-shared.src.js` :
  - `defaultModules()` : `shop.enabled:true` → `shop.enabled:false`
  - Bloc force permanente : `'shop'` retiré de la liste des modules forcés actifs
  - Nouveau bloc force : `DB.modules.shop.enabled = false` à chaque chargement
  - `DB.modules.panier.enabled = false` — panier aussi désactivé

---

### v77 — Masquage complet Boutique + Panier (nav + bouton)
**Demandes :**
- Le menu ne doit pas afficher la boutique
- Masquer aussi le bouton PANIER de la navigation

**Problème identifié :**
- `applyModules()` masquait `[data-module-nav="shop"]` mais pas `#nav-cart-btn`

**Éléments codés :**
- `harmonia-shared.src.js` — `applyModules()` :
  - Ajout : `var cartBtn = document.getElementById('nav-cart-btn'); if (cartBtn) cartBtn.style.display = shopOn ? '' : 'none';`
  - Bloc force : `DB.modules.panier.enabled = false` ajouté

---

### v78 — Fallback cover → photo artiste pour toute la discographie
**Demande :**
- Afficher les covers des albums pour tous les artistes
- Quand aucune cover n'est disponible, utiliser la photo de l'artiste à la place du ♪

**Éléments codés :**
- `harmonia-shared.src.js` — 2 emplacements :
  - `openArtistModal()` (modal discographie) : cascade `DB.images[coverKey] → al.cover → artistImg(a) → ♪`
  - `openArtistPage()` → `buildAlbumsHtml()` (vue plein écran) : cascade `al.cover → artistImg(a) → ♪`
- Bénéficie à tous les artistes dont les singles n'ont pas encore de cover dédiée (ex: Neguinho Tivane)

---

## FICHIERS CLÉS DU PROJET

| Fichier | Rôle |
|---|---|
| `harmonia-shared.src.js` | Source JS — à éditer, jamais le `.js` compilé |
| `harmonia-shared.src.css` | Source CSS — à éditer, jamais le `.css` compilé |
| `harmonia-shared.js` | Build output (ne pas éditer) |
| `harmonia-shared.css` | Build output (ne pas éditer) |
| `build.py` | Compile src → output + minification |
| `MAJHARMO.command` | Script bash : add + commit + push GitHub détaillé |
| `admin.html` | Panneau d'administration complet |
| `index.html` | Page d'accueil (sélecteur langue, médaillon Cesária) |
| `qui-sommes-nous.html` | About + section Artistes en Promo |
| `artistes.html` | Galerie artistes avec modal fiche |
| `contact.html` | Page contact |
| `boutique.html` | Boutique (désactivée v76-77, réactivable depuis admin) |
| `panier.html` | Page panier (désactivée v76-77) |

---

## PROCÉDURE DE MISE À JOUR

```bash
# 1. Éditer les sources
nano harmonia-shared.src.js
nano harmonia-shared.src.css

# 2. Builder
python3 build.py

# 3. Bumper la version (ex: v77 → v78)
sed -i 's/harmonia-shared\.js?v=78/harmonia-shared.js?v=79/g' *.html
sed -i 's/harmonia-shared\.css?v=78/harmonia-shared.css?v=79/g' *.html

# 4. Pusher
./MAJHARMO.command
```

---

## RÉACTIVATION BOUTIQUE (quand prêt)

Dans `harmonia-shared.src.js`, bloc "Force permanente" :
1. Changer `DB.modules.shop.enabled = false` → `true`
2. Changer `DB.modules.panier.enabled = false` → `true`
3. Remettre `'shop'` dans la liste des modules forcés actifs
4. Changer `defaultModules()` : `shop.enabled:false` → `true`
5. Build + bump + push

Ou depuis l'admin : **Modules → Boutique → toggle ON** (si le bloc force est retiré).

---

*Dernière mise à jour : v78 — Juin 2026*
