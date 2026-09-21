<!-- Ce README documente le site de documentation. Il ne remplace pas le README.md racine du dépôt. -->

# Documentation SDLC Toolkit — `docs/`

Ce dossier contient **le site de documentation** (front-end statique) et ses **sources Markdown** éditables. Il est conçu pour être publié tel quel via **GitHub Pages** (dossier `/docs`).

```
docs/
├── index.html         ← le site (point d'entrée Pages)
├── nav.json           ← manifeste de navigation (groupes, pages, niveaux)
├── meta.json          ← { version, updated } — badge de version du site
├── .nojekyll          ← désactive Jekyll (sert les .json et /pages sans surprise)
├── pages/*.md         ← le contenu, SOURCE DE VÉRITÉ éditable
└── README.md          ← ce fichier
```

Le site charge les `.md` à la volée (`fetch`) : **modifier le contenu = éditer un fichier dans `pages/`**, aucun build.

---

## Éditer

- **Changer un texte** → éditer `pages/<id>.md`. Les liens internes entre pages : `[texte](#id-de-page)`.
- **Ajouter une page** → 1) créer `pages/<id>.md`, 2) ajouter une entrée `{ "id", "title" }` dans le groupe voulu de `nav.json`. Le sommaire, le routage, le fil précédent/suivant et le badge de niveau se génèrent seuls.
- **Changer la version affichée** → éditer `meta.json` (`version`). À faire lors de tout `/sdlc-sync` ou bump de version du modèle, avec une ligne dans `pages/versions.md` — `bash sdlc-validate.sh` (C9) échoue si l'un des deux est oublié.

## Lancer en local

Le site fait des `fetch` : il faut un serveur HTTP (pas d'ouverture en `file://`).

```bash
cd docs && python3 -m http.server 8000
# http://localhost:8000/
```

## Publier sur GitHub Pages

1. Pousser ce dossier `docs/` sur `main`.
2. **Settings ▸ Pages ▸ Build and deployment ▸ Source : Deploy from a branch**.
3. Branche `main`, dossier **`/docs`**. Enregistrer.
4. URL : `https://laurentgely.github.io/SDLC/`.

Le `.nojekyll` garantit que `nav.json`, `meta.json` et `pages/` sont servis tels quels.

> Dépendances externes (CDN) : polices Google, `marked`, `highlight.js`. Le site a besoin d'un accès réseau au premier chargement.

---

## Renommage `doc/` → `docs/` (migration du dépôt)

Ce site adopte le nom universel `docs/` (attendu par GitHub Pages). Renommer le dossier `doc/` historique du dépôt est une **décision de convention du modèle** : elle touche les templates, les scripts et les skills qui référencent `doc/`. Par cohérence avec `Claude.md`, la faire par script `sed` avec vérification `grep`, et la tracer (`M-ARCH-NN` dans `07-DECISIONS-SDLC.md` + bump de version).

```bash
# 1. Renommer le dossier en préservant l'historique git
git mv doc docs

# 2. Adapter toutes les références « doc/ » → « docs/ »
#    (\bdoc/ ne touche NI docs/ NI les mots contenant "doc")
grep -rlE '\bdoc/' --include='*.md' --include='*.sh' --include='*.json' \
  --include='*.html' . \
  | xargs sed -i -E 's#\bdoc/#docs/#g'

# 3. Vérification exécutable (INV-1) : plus aucune référence « doc/ »
grep -rnE '\bdoc/' --include='*.md' --include='*.sh' --include='*.json' \
  --include='*.html' . \
  && echo "⚠️  références résiduelles à corriger" \
  || echo "✅ aucune référence doc/ restante"
```

Points de vigilance après le `sed` :
- `CHANGELOG.md` / historique : une entrée décrit la *création* de `doc/` (fait historique) — la laisser telle quelle si vous voulez préserver la vérité du journal.
- `sdlc-init.sh`, `sdlc-delta.sh`, `sdlc-project-check.sh` : vérifier que les `mkdir`/chemins pointent bien sur `docs/`.
- `00-CONTEXT.md §1`, `specs/SPEC.md §Modules` : ajouter `docs/` (site) à la carte des fichiers.
- `Claude.md §Démarrage` : les lectures `docs/ROADMAP.md` / `docs/SESSION_BRIDGE.md` doivent être cohérentes.

> Enregistrer le site dans `00-CONTEXT.md §1` comme surface documentaire humaine (au même titre que `SPEC.html` / `MODE-OPERATOIRE.html`) — sinon c'est une surface non tracée, contraire à INV-2.
