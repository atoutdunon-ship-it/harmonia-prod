# HARMONIA — Contexte projet pour Claude

## IDENTITÉ DU PROJET
Site statique de production musicale Cabo Verde, déployé sur **GitHub Pages**.
- URL production : `https://atoutdunon-ship-it.github.io/harmonia-prod/`
- Dossier local : `/Users/manu/COWORK/Harmonia/`
- Propriétaire : Manu — `atout.dunon@gmail.com`

---

## CONTRAINTE DE SÉCURITÉ ABSOLUE — NE JAMAIS CONTOURNER
> Le compte et profil **super admin (login: PROD)** ne peut PAS être modifié, ni supprimé sans le mot de passe **`Music7`**.
> Cette contrainte est codée dans la fonction de sauvegarde des utilisateurs et doit être préservée dans toutes les modifications.

---

## CHARTE GRAPHIQUE
- Couleurs dominantes : **noir** (`#030d07`) + **bleu Navy** (`#061a10`, `#091f13`, `#0d2618`) + **blanc**
- Accent : `#2ecc80` (vert émeraude), `#1f9e5c` (vert foncé)
- **Pas de couleur dorée** sauf demande explicite
- **Pas de favicon** ni de petites icônes décoratives à l'intérieur du site
- Rendu graphique : qualité pro style grand groupe
- Code niveau **expert**

---

## ARCHITECTURE TECHNIQUE

### Fichiers sources (à éditer)
```
harmonia-shared.src.js   ← source JS principale — TOUJOURS éditer ce fichier
harmonia-shared.src.css  ← source CSS principale — TOUJOURS éditer ce fichier
```

### Fichiers build (NE JAMAIS éditer directement)
```
harmonia-shared.js       ← généré par build.py
harmonia-shared.css      ← généré par build.py
```

### Commandes
```bash
# Builder après modification des sources
cd /Users/manu/COWORK/Harmonia && python3 build.py

# Bumper la version (ex: v77 → v78) dans tous les HTML
sed -i 's/harmonia-shared\.js?v=77/harmonia-shared.js?v=78/g' *.html
sed -i 's/harmonia-shared\.css?v=77/harmonia-shared.css?v=78/g' *.html

# Pusher vers GitHub Pages
./MAJHARMO.command
```

### Version actuelle
**v78** — vérifier avec `grep "v=" artistes.html | head -1`

---

## PAGES DU SITE

| Fichier | Module key | Statut |
|---|---|---|
| `index.html` | — | Toujours actif (page d'accueil) |
| `qui-sommes-nous.html` | `about` | Actif |
| `artistes.html` | `artists` | Actif |
| `cesaria.html` | `cesaria` | Actif |
| `jose-da-silva.html` | `jose` | Actif |
| `musique.html` | `music` | Actif |
| `actualites.html` | `news` | Actif |
| `evenements.html` | `events` | Actif |
| `contact.html` | `contact` | Actif |
| `boutique.html` | `shop` | **DÉSACTIVÉ** (v76) — réactivable admin |
| `panier.html` | `panier` | **DÉSACTIVÉ** (v76) — réactivable admin |
| `mon-compte.html` | `moncompte` | Actif |
| `admin.html` | — | Panneau admin (accès restreint) |

---

## MODÈLE DE DONNÉES (localStorage)

```javascript
DB = {
  users:         [],   // { id, login, email, name, pass, role, permissions }
  artists:       [],   // { id, name, category, photo, bioShort, bioLong, ... }
  tracks:        [],   // { id, title, artist, ... }
  albums:        [],   // { id, title, artist, ... }
  products:      [],   // { id, name, price, ... }
  events:        [],   // { id, title, date, ... }
  news:          [],   // { id, title, content, ... }
  modules:       {},   // { shop: {enabled, mode, label, page}, ... }
  promoArtists:  [],   // [artistId1, artistId2, artistId3] — section promo qui-sommes-nous
  pageTexts:     {},   // textes édités inline par clé + langue
  images:        {},   // images uploadées (base64)
  itemStates:    {},   // états on/off des items (artists, news, events)
  customers:     [],
  paymentLinks:  [],
  musicCategories: [],
}
```

---

## SYSTÈME DE MODULES

```javascript
// defaultModules() dans harmonia-shared.src.js
DB.modules = {
  about:     { enabled:true,  label:'QUI SOMMES-NOUS', page:'qui-sommes-nous.html', group:'nav' },
  cesaria:   { enabled:true,  label:'Cesária Évora',    page:'cesaria.html',          group:'nav' },
  jose:      { enabled:true,  label:'José da Silva',    page:'jose-da-silva.html',    group:'nav' },
  artists:   { enabled:true,  label:'Artistes',         page:'artistes.html',         group:'nav' },
  music:     { enabled:true,  label:'Musique',          page:'musique.html',          group:'nav' },
  shop:      { enabled:false, label:'Boutique',         page:'boutique.html',         group:'nav' }, // DÉSACTIVÉ
  events:    { enabled:true,  label:'Événements',       page:'evenements.html',       group:'nav' },
  news:      { enabled:true,  label:'Actualités',       page:'actualites.html',       group:'nav' },
  contact:   { enabled:true,  label:'Contact',          page:'contact.html',          group:'nav' },
  moncompte: { enabled:true,  label:'Mon Compte',       page:'mon-compte.html',       group:'util' },
  panier:    { enabled:false, label:'Panier',           page:'panier.html',           group:'util' }, // DÉSACTIVÉ
}
```

**Masquage nav** : `data-module-nav="shop"` → caché si `enabled:false`
**Masquage panier** : `#nav-cart-btn` → caché si `shop.enabled:false` (dans `applyModules()`)

---

## RÔLES UTILISATEURS

| Rôle | Accès |
|---|---|
| `superadmin` | Tout — admin complet, modules, users, Music7 |
| `administrateur` | Admin sans gestion users superadmin |
| `editor` | Mode édition inline uniquement |
| `membre` | Compte client, historique commandes |

**Bypass mode maintenance** : rôles `superadmin`, `administrateur`, `editor` voient toutes les pages même désactivées.

---

## INTERNATIONALISATION (i18n)

- 4 langues : **PT** (défaut), **FR**, **EN**, **ES**
- `LANGS{}` objet dans `harmonia-shared.src.js` (lignes 11, 130, 249, 368)
- `T(key)` — traduction courante avec fallback FR
- `setLang(lang)` — change la langue, double-write `sessionStorage` + `localStorage`
- `applyLang()` — applique toutes les traductions au DOM
- **"Choose your language"** toujours en anglais sur index.html (hardcodé + HOME_LANGS)
- Persistance : `localStorage('harmonia_lang')` survit aux kills d'onglet mobile (iOS)

---

## SECTION "ARTISTES EN PROMO" (qui-sommes-nous.html)

- HTML : `<section class="promo-artists-section">` avec `<div id="promo-artists-grid">`
- JS : `renderPromoArtists()` — lit `DB.promoArtists[0..2]`, cherche artiste dans `DB.artists`
- Carte : Photo + Nom + Bouton "Découvrir" → `artistes.html?artist=ID`
- Admin : section "Artistes en Promo" dans Modules → 3 dropdowns → `_saveAllPromoArtists()`

---

## MODE ÉDITION INLINE

- Activation : bouton "Éditer le site" dans l'admin sidebar
- Persistance : `sessionStorage.editMode = '1'` (survit à la navigation inter-pages)
- `_editModeActive` — flag JS
- `data-editable-key="xxx"` — attribut sur éléments éditables
- `data-editable-img="xxx"` — attribut sur images éditables (upload base64)
- Toolbar flottante : police, taille, B/I/U/S/couleur/alignement
- Sauvegarde → `DB.pageTexts[key][lang]` + auto-traduction 4 langues
- Bouton "Quitter Mode éditeur" : `bottom:64px; left:24px; z-index:99999`

---

## GALERIE ARTISTES

- Grille : `.artists-grid` — `gap:16px; padding:16px`
- Aspect ratio carte : `3/4`
- Photo stockée : `DB.artists[i].photo` (clé `IMG_XXX` ou base64)
- `artistImg(artist)` — résout la clé → image base64 ou null

---

## RÉACTIVATION BOUTIQUE

Quand la boutique doit être réactivée, dans `harmonia-shared.src.js` :
1. `defaultModules()` → `shop.enabled: false` → `true`
2. Bloc force permanente → ajouter `'shop'` dans la liste forcée active
3. Supprimer ou inverser : `DB.modules.shop.enabled = false`
4. Supprimer : `DB.modules.panier.enabled = false`
5. Build + bump + push

---

## HISTORIQUE COMPLET
Voir `HARMONIA_CHANGELOG.md` dans ce dossier pour l'historique détaillé v1→v77.

---

## PROCÉDURE TYPE D'UNE MODIFICATION

1. Lire les fichiers concernés avec `Read`
2. Éditer `harmonia-shared.src.js` et/ou `harmonia-shared.src.css`
3. Éditer les HTML si besoin (ne pas éditer `harmonia-shared.js/.css`)
4. `python3 build.py`
5. Bump version dans tous les HTML
6. Vérifier : `grep -c "v=NEW" *.html` et `grep -rl "v=OLD" *.html`
7. Indiquer à Manu de lancer `MAJHARMO.command`

---

*Mis à jour : v78 — Juin 2026*
