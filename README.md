# Collection Augusta Boulay — Site GitHub Pages

Un site web de présentation et de consultation des 149 cartes postales familiales de la collection Augusta Boulay (1910–1940).

## Structure du site

Le site est entièrement autogéré en HTML/CSS/JavaScript et ne nécessite aucun serveur backend. Tous les fichiers peuvent être servés depuis GitHub Pages ou tout serveur HTTP statique.

### Fichiers principaux

- **`index.html`** — Page unique contenant toute la structure, le CSS et le JavaScript
- **`cards_data.js`** — Données de tous les 149 cartes postales (générées depuis le JSON)
- **`cartes_boulay_reference.json`** — Référence JSON complète avec métadonnées, biographies, proches
- **`prepare_images.sh`** — Script pour mapper et copier les images depuis les sources de scan
- **Images** — `boulay_NNN_recto.jpg` et `boulay_NNN_verso.jpg` (NNN = numéro de carte)

## Contenu du site

### Sections

1. **Hero (en-tête)**
   - Titre : "Collection Augusta Boulay"
   - Sous-titre : "Cartes postales familiales — Craon, Mayenne — 1910 à 1940"
   - Statistiques : 149 cartes, 30 ans, 50+ correspondants, 3 générations

2. **Navigation**
   - Introduction
   - Arbre familial
   - Personnages
   - Chronologie
   - Extraits
   - Lieux
   - Catalogue

3. **Introduction**
   - Biographie synthétique d'Augusta Boulay (1907–1993)
   - Contexte familial (père Auguste, mère Émilie)
   - Thèmes majeurs : enfance, Première Guerre mondiale, adolescence, mariage

4. **Arbre familial**
   - Généalogie détaillée depuis François Boulay (1807–1877)
   - Trois générations : parents, enfants (Auguste & Émilie), petits-enfants
   - Mariages et dates clés

5. **Personnages**
   - Six fiches principales : Augusta, Auguste (père), Émilie (mère), Maria, Guy Lemonnier, Tante Blu
   - Biographies courtes, dates, rôles, badges

6. **Chronologie**
   - Timeline de 1807 à 1940
   - Points clés : naissances, mariages, guerre, décès

7. **Extraits**
   - Trois cartes marquantes (1914, 1914, 1914) avec transcriptions
   - Voix directes des expéditeurs

8. **Lieux**
   - Géographie de la collection par thème :
     - Le foyer (Craon, Cossé-le-Vivien, La Roë)
     - Affectations militaires (Bourges, 1915–1916)
     - Études (Laval, Château-Gontier, Angers)
     - Villégiatures et voyages (Paris, Bretagne, Normandie, Vatican, Italie)

9. **Catalogue**
   - Grille de 149 cartes avec **recherche** et **filtres**
   - Visionneuse lightbox avec :
     - Recto (image de la carte)
     - Verso (message écrit)
     - Expéditeur, destinataire, date
     - Transcription complète
     - Notes et contexte
   - Pagination (40 cartes par page)
   - Navigation au clavier (flèches, échap)

## Structure des données

### `cards_data.js`

Contient un tableau `CARDS_DATA` de la forme :

```javascript
const CARDS_DATA = [
  {
    n: 1,              // numéro séquentiel
    exp: "...",        // expéditeur
    dest: "...",       // destinataire
    date: "...",       // date sous forme libre
    trans: "...",      // transcription complète
    notes: ""          // notes contextuelles
  },
  // ... 148 autres
];
```

### Images

Les images sont nommées selon le pattern :
- `boulay_NNN_recto.jpg` — face illustrée de la carte
- `boulay_NNN_verso.jpg` — face message de la carte

(NNN = numéro de carte à trois chiffres : 001, 002, ..., 149)

## Déploiement GitHub Pages

1. Créer un nouveau dépôt GitHub `<username>.github.io` ou ajouter les fichiers dans un dossier `/docs` d'un dépôt existant
2. Copier les fichiers suivants :
   - `index.html`
   - `cards_data.js`
   - Tous les fichiers image `boulay_*.jpg`
3. Pousser vers GitHub
4. Le site sera accessible à `https://<username>.github.io/` (ou au chemin configuré)

## Serveur local pour développement

```bash
# Avec Python 3
python3 -m http.server 8000

# Ou avec Node.js
npx http-server
```

Puis ouvrir `http://localhost:8000` dans le navigateur.

## Caractéristiques du site

### Design
- **Palette de couleurs** : Sépia vintage (thème chaleureux, nostalgique)
- **Typographie** : Playfair Display (titres), Source Sans 3 (corps), Source Serif 4 (citations)
- **Responsive** : Fonctionne sur ordinateur, tablette, mobile

### Interactions
- **Filtrage en temps réel** par expéditeur et recherche textuelle
- **Lightbox full-screen** pour consultation détaillée
- **Navigation au clavier** dans la lightbox (flèches ↔, échap)
- **Zoom sur images** (clic pour zoomer/dé-zoomer)
- **Tri automatique** des cartes par date

### Accessibilité
- Sémantique HTML5 correcte
- Contraste suffisant
- Textes alternatifs sur les images
- Navigation au clavier complète

## Génération des données

Les fichiers `cards_data.js` et `cartes_boulay_reference.json` sont générés à partir du fichier JSON source :

```bash
python3 << 'EOF'
import json

with open('/sessions/bold-focused-darwin/cartes_boulay.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

cartes = data.get('cartes', {})
cartes_list = sorted(cartes.values(), key=lambda x: int(x.get('numero', 0)))

cards_data = [
    {
        'n': card.get('numero'),
        'exp': card.get('expediteur', '').strip(),
        'dest': card.get('destinataire', '').strip(),
        'date': card.get('date', '').strip(),
        'trans': card.get('transcription', '').strip(),
        'notes': card.get('notes', '').strip()
    }
    for card in cartes_list
]

print('const CARDS_DATA = ' + json.dumps(cards_data, ensure_ascii=False, indent=2) + ';')
EOF
```

## Copie des images

Le script `prepare_images.sh` mappe les images source (nommées par date) vers les noms séquentiels attendus par le site :

```bash
bash prepare_images.sh
```

Ce script :
1. Lit le JSON source pour obtenir l'ordre des cartes
2. Localise les images correspondantes dans le répertoire de scan
3. Copie/renomme les images selon le pattern `boulay_NNN_recto/verso.jpg`
4. Génère un log de mapping (`image_mapping.log`)

## Métadonnées et contexte

Le fichier `cartes_boulay_reference.json` contient :

- **`_metadata`** : Titre du projet, période, nombre de cartes, description
- **`biographie`** : Synthèse biographique détaillée d'Augusta Boulay
- **`proches`** : Liste de 30+ personnes mentionnées dans la collection avec descriptions
- **`cartes`** : Dictionnaire de toutes les cartes avec images, transcriptions, notes

## Notes de contribution

Pour enrichir ou corriger le site :

1. Éditer `index.html` pour le contenu de sections (Introduction, Personnages, etc.)
2. Éditer `cards_data.js` pour les métadonnées des cartes (transcriptions, dates, notes)
3. Ajouter des images manquantes via le script `prepare_images.sh`
4. Tester localement avec un serveur HTTP simple
5. Pousser les changements vers GitHub

## Licence

Collection et site : Usage privé/éducatif. Consultez le propriétaire de la collection pour toute utilisation commerciale.

## Crédits

- **Numérisation et transcription** : Krishna Naudin
- **Analyse et génération du site** : Assistée par IA (Claude & Gemini)
- **Design** : Modèle adapté de la Collection Lemonnier-Décré
- **Mise à jour** : Mars 2026

---

**Accès au site** : Ouvrir `index.html` dans un navigateur web.
