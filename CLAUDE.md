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

# Bumper la version (ex: v81 → v82) dans tous les HTML
OLDV=81; NEWV=82
for f in *.html; do sed -i "s/harmonia-shared\.js?v=${OLDV}/harmonia-shared.js?v=${NEWV}/g; s/harmonia-shared\.css?v=${OLDV}/harmonia-shared.css?v=${NEWV}/g" "$f"; done

# Vérifier : aucun résidu
grep -l "v=${OLDV}" *.html   # doit retourner vide

# Pusher vers GitHub Pages
./MAJHARMO.command
```

### Version actuelle
**v93** — vérifier avec `grep "v=" artistes.html | head -1`

---

## PAGES DU SITE

| Fichier | Module key | Statut |
|---|---|---|
| `index.html` | — | Toujours actif (page d'accueil) |
| `qui-sommes-nous.html` | `about` | Actif — section Artistes en Promo en bas |
| `artistes.html` | `artists` | Actif — galerie + page artiste avec 4 onglets |
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
  artists:       [],   // { id, name, category, photo, bioShort, bioLong, style, origin, instagram, youtube, spotify, youtubeVideos[], discography[] }
  tracks:        [],   // { id, title, artist, album, duration, cover, ytId, style, category }
  albums:        [],   // { id, title, artist, year, cover, genre, label, desc, spotify }
  products:      [],   // { id, name, price, ... }
  events:        [],   // { id, title, date, ... }   ← événements génériques (page événements)
  artistEvents:  [],   // { id, type, title, artists[], dates[], venue, city, country, description, ticketUrl } ← SHOWCO
  news:          [],   // { id, title, content, ... }
  modules:       {},   // { shop: {enabled, mode, label, page}, ... }
  promoArtists:  [],   // [artistId1, artistId2, artistId3] — section promo qui-sommes-nous
  pageTexts:     {},   // textes édités inline par clé + langue
  images:        {},   // images uploadées (base64) — clé 'IMG_XXX', 'disc_id_idx', etc.
  itemStates:    {},   // états on/off des items (artists, news, events)
  customers:     [],
  paymentLinks:  [],
  musicCategories: [],
}
```

### Covers discographie — cascade de résolution
```javascript
// Dans openArtistModal() et openArtistPage() → buildAlbumsHtml()
coverSrc = DB.images['disc_'+artistId+'_'+albumIndex]  // override admin
         || al.cover                                    // URL YouTube thumbnail
         || artistImg(artist)                           // photo artiste (fallback v78)
         || ''                                          // → placeholder ♪
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
**Force permanente** : `['about','artists','cesaria','music','news','contact']` toujours actifs + `shop/panier` toujours désactivés

---

## ARTISTES

12 artistes — 2 catégories :
- **traditional** : Elida Almeida (id:1), Ceuzany (id:2), Lucibela (id:3), Fábio Ramos (id:4), Jenifer Solidade (id:5), Neuza de Pina (id:6)
- **urban** : Elly Paris (id:7), Indira (id:8), Ley Lazz (id:9), Mureno (id:10), Neguinho Tivane (id:11), Sonia Sousa (id:12)

Covers albums : YouTube thumbnail `https://img.youtube.com/vi/YTID/hqdefault.jpg`
Override cover : `DB.images['disc_'+artistId+'_'+albumIndex']`

**Artistes en Promo par défaut** : `DB.promoArtists = [1, 3, 12]` (Elida + Lucibela + Sonia Sousa) — réinitialisé si absent ou tous null

---

## PAGE ARTISTE — 4 ONGLETS (module SHOWCO)

Structure de `openArtistPage(id)` :
1. Hero fixe (photo + nom + bio + réseaux)
2. Barre d'onglets sticky : **Albums | Vidéos | Showcases | Concerts**
3. Panels cachés/affichés via `switchArtistTab(btn, panelId)`

```javascript
// IDs des panels
'ap-tab-albums'    // buildAlbumsHtml() — accordéon par album
'ap-tab-videos'    // grille YouTube
'ap-tab-showcases' // buildArtistEventHtml(evShowcases)
'ap-tab-concerts'  // buildArtistEventHtml(evConcerts)
```

CSS tabs : `.ap-tab-btn` — inactif `rgba(255,255,255,0.65)` / actif `#fff` + border-bottom accent2

---

## MODULE SHOWCO — Showcases & Concerts

**Code nom : SHOWCO** — réimplantable dans d'autres projets.

### Modèle événement
```javascript
DB.artistEvents[] = {
  id:          Number,          // auto-incrémenté
  type:        'showcase'|'concert',
  title:       String,
  artists:     [Number],        // IDs depuis DB.artists
  dates:       ['YYYY-MM-DD'],  // tableau multi-dates
  venue:       String,
  city:        String,
  country:     String,
  description: String,
  ticketUrl:   String
}
```

### Fonctions JS (harmonia-shared.src.js)
- `switchArtistTab(btn, panelId)` — navigation onglets
- `buildArtistEventHtml(events)` — rendu liste (tri : à venir ASC → passés DESC, badge vert/gris)

### Admin (admin.html)
- Section `#sec-showcases` — nav "Showcases / Concerts" dans sidebar groupe Contenu
- `_aeOpenForm(id|null)` — formulaire add/edit
- `_aeSave(id|null)` — sauvegarde avec ID auto
- `_aeDelete(id)` — suppression avec confirmation
- `_aeRenderList()` — tableau trié avec filtre Tous/Showcases/Concerts
- `_aeFilter(type, btn)` — filtrage vue liste
- `_aeAddDateRow()` — ajout dynamique champ date

### Logique affichage
- Événements filtrés par `(ev.artists||[]).indexOf(artistId) !== -1`
- Badge "À venir" vert si `dates[0] >= today`, "Passé" grisé sinon
- `+N dates` affiché si l'événement a plusieurs dates

---

## SECTION "ARTISTES EN PROMO" (qui-sommes-nous.html)

- HTML : `<section class="promo-artists-section">` avec `<div id="promo-artists-grid">`
- JS : `renderPromoArtists()` — lit `DB.promoArtists[0..2]`, cherche artiste dans `DB.artists`
- Carte : Photo + Nom + Bouton "Découvrir" → `artistes.html?artist=ID`
- Admin : section "Artistes en Promo" dans Modules → 3 dropdowns → `_saveAllPromoArtists()`
- Défaut démo : `[1, 3, 12]` — réinitialisé si absent ou tous null; migration auto si `11` encore stocké

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
- Clic carte → `openArtistPage(id)` ou `window.location.href = a.pageLink` si défini

---

## INTERNATIONALISATION (i18n)

- 4 langues : **PT** (défaut), **FR**, **EN**, **ES**
- `LANGS{}` objet dans `harmonia-shared.src.js`
- `T(key)` — traduction courante avec fallback FR
- `setLang(lang)` — change la langue, double-write `sessionStorage` + `localStorage`
- `applyLang()` — applique toutes les traductions au DOM
- **"Choose your language"** toujours en anglais sur index.html (hardcodé + HOME_LANGS)
- Persistance : `localStorage('harmonia_lang')` survit aux kills d'onglet mobile (iOS)
- Cascade lecture : `sessionStorage → localStorage → 'pt'`

---

## RÉACTIVATION BOUTIQUE

Dans `harmonia-shared.src.js`, bloc "Force permanente" :
1. `defaultModules()` → `shop.enabled:false` → `true`
2. Bloc force → ajouter `'shop'` dans liste forcée active
3. Supprimer : `DB.modules.shop.enabled = false`
4. Supprimer : `DB.modules.panier.enabled = false`
5. Build + bump + push

Ou depuis l'admin : **Modules → Boutique → toggle ON** (si le bloc force est retiré).

---

## PROCÉDURE TYPE D'UNE MODIFICATION

1. `Read` les fichiers concernés
2. Éditer `harmonia-shared.src.js` et/ou `harmonia-shared.src.css`
3. Éditer les HTML si besoin (ne jamais éditer `harmonia-shared.js/.css`)
4. `python3 build.py`
5. Bump version dans tous les HTML (voir commande ci-dessus)
6. Vérifier : `grep -l "v=OLDV" *.html` doit retourner vide
7. Indiquer à Manu de lancer `MAJHARMO.command`

---

## HISTORIQUE COMPLET
Voir `HARMONIA_CHANGELOG.md` dans ce dossier — historique détaillé v1→v81.

---

*Mis à jour : v88 — Juin 2026*
