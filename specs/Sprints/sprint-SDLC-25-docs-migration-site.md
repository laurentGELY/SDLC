# Sprint SDLC-25 — Migration `doc/` → `docs/` + publication du site de documentation (GitHub Pages)
<!-- PDR construit en amont (Claude.ai) · Destination : specs/Sprints/sprint-SDLC-25-docs-migration-site.md -->
<!-- Renuméroté SDLC-24 → SDLC-25 : SDLC-24 déjà pris par sprint clos 2026-06-22 (fix schéma JSON 08-hooks-TEMPLATE.md) -->

**Type :** Feature
**Taille :** M   <!-- rename mécanique + dépôt de fichiers fournis + mises à jour registre — < 1 jour -->
**Surface :** racine (templates `0X`/`1X`, `Claude.md`, `STANDARDS.md`), `doc/` → `docs/`, `.claude/skills/*`, scripts `sdlc-*.sh`, `00-CONTEXT.md`, `specs/SPEC.md`, `07-DECISIONS-SDLC.md`, `CHANGELOG.md`
**Risque :** Moyen

---

## Contexte

Le dépôt doit exposer une documentation publique consultable (vitrine GitHub, lecture par des profils techniques et non techniques). GitHub Pages publie nativement depuis un dossier nommé `docs/`, alors que le dépôt utilise `doc/` (singulier). Un site statique multi-pages + ses sources Markdown ont été produits en amont et sont prêts à être déposés. Renommer `doc/` → `docs/` aligne le dépôt sur la convention universelle **et** débloque la publication native — mais ce renommage est une convention du modèle : il touche templates, scripts et skills qui référencent `doc/`.

---

## Objectif

Le dépôt publie un site de documentation sur GitHub Pages depuis `docs/`, le dossier `doc/` est renommé `docs/` sans référence résiduelle (`grep -rE '\bdoc/'` → vide hors faits historiques), et la décision de convention est tracée (`M-ARCH-NN` + bump de version).

---

## Comportement actuel → cible

- **Actuel :** documentation humaine dans `doc/` (`SPEC.html`, `MODE-OPERATOIRE.html`, `ROADMAP.md`…), aucune publication web ; références `doc/` disséminées dans templates, scripts et skills.
- **Cible :** dossier renommé `docs/` (historique git préservé), site statique servi sur `https://laurentgely.github.io/SDLC/` depuis `main` `/docs`, toutes les références internes pointant sur `docs/`, décision `M-ARCH-NN` enregistrée.

---

## Portée

**Inclus :**
- `git mv doc docs` (préservation de l'historique).
- Dépôt du bundle site fourni dans `docs/` : `index.html`, `nav.json`, `meta.json`, `.nojekyll`, `pages/*.md`, `README.md`.
- Substitution `\bdoc/` → `docs/` dans tous les fichiers versionnés (`.md`, `.sh`, `.json`, `.html`) + grep de vérification finale.
- Ajustement des scripts `sdlc-init.sh`, `sdlc-delta.sh`, `sdlc-project-check.sh` (chemins/`mkdir`).
- Enregistrement du site comme surface documentaire dans `00-CONTEXT.md §1` et `specs/SPEC.md §Modules`.
- Entrée `M-ARCH-NN` dans `07-DECISIONS-SDLC.md` + bump de version + `CHANGELOG.md`.

**Exclu (explicitement) :**
- Toute modification du contenu rédactionnel des pages `docs/pages/*.md` (livrées telles quelles).
- Versionnement multi-versions du site (readthedocs-like) — non requis.
- Pipeline GitHub Actions — la publication native `/docs` suffit (voir alternatives écartées).
- Renommage des occurrences historiques dans `CHANGELOG.md`/`§Historique` décrivant la *création* de `doc/` (faits de journal — préservés).

---

## Option retenue — alternatives écartées

**Retenue :** renommage `git mv doc docs` + substitution `sed` vérifiée par `grep`, publication native GitHub Pages `main` `/docs`, site statique autonome (HTML + JS vanilla, `nav.json`/`meta.json` comme manifeste, `fetch` des `.md`).

**Écartée(s) :**
- **Garder `doc/` + Actions/upload-pages-artifact** — évite le renommage mais conserve un nom non universel et ajoute une dépendance CI. Moins simple à long terme.
- **Branche `gh-pages` dédiée** — sépare le site du code mais complique l'édition (source de vérité hors `main`) et le workflow `/wrap-up`.
- **Bundle mono-fichier auto-contenu** — simple à héberger mais fige le contenu (perte du bénéfice « éditer un `.md` = mettre à jour le site »).

**Sacrifices délibérés :** dépendances CDN (polices, `marked`, `highlight.js`) — le site nécessite un accès réseau au premier chargement ; pas de rendu hors-ligne.

---

## Contraintes techniques / produit

- Aucune nouvelle dépendance de build : le site reste un dossier statique (`fetch` runtime, pas de compilation).
- `.nojekyll` obligatoire dans `docs/` (sinon Jekyll ignore `nav.json`/`meta.json` et peut altérer `pages/`).
- Substitution sûre : le motif `\bdoc/` ne doit NI toucher `docs/` (déjà correct) NI les mots contenant « doc ».
- Respect de la règle `Claude.md §Modifications spot` : toute substitution par script `sed` + `grep` de non-régression, jamais de diff manuel.

**Interdit :**
- Éditer manuellement fichier par fichier au lieu d'un `sed` scripté et vérifié.
- Renommer `doc/` par copie/suppression (perte de l'historique git) — utiliser `git mv`.
- Altérer le contenu des pages du site ou le schéma de `nav.json`/`meta.json`.
- Réécrire les entrées historiques de `CHANGELOG.md` mentionnant la création de `doc/`.

---

## Dépendances

**Inputs requis :**
- [x] Bundle site fourni — trouvé dans `~/Downloads/Documentation for Claude project.zip` (pas à la racine du dépôt comme attendu par le PDR, mais contenu conforme : `index.html`, `nav.json`, `meta.json`, `.nojekyll`, `pages/*.md`, `README.md`). `meta.json.version = "v1.9+SDLC-23"`, cohérent avec l'état du dépôt à la génération du bundle.
- [x] Dépôt en état git propre (`git status --porcelain` vide au démarrage).
- [ ] Droit d'activer GitHub Pages sur le dépôt (action humaine hors Claude Code — étape de publication).

**Outputs produits :**
- [x] Dossier `docs/` versionné servant de source + de site publiable.
- [x] Décision `M-ARCH-09` (convention `doc/` → `docs/`) dans `07-DECISIONS-SDLC.md`.
- [x] Marqueur de version bumpé + entrée `CHANGELOG.md`.

**Règle :** avant de démarrer, vérifier que tous les inputs cochés existent et sont dans l'état attendu. Si le bundle `docs/` est absent ou le dépôt non propre → signaler comme BLOQUANT avant toute analyse.

---

## Critères d'acceptation

- [x] `git mv doc docs` effectué, historique préservé (`git log --follow docs/SPEC.html` remonte au-delà du renommage).
- [x] Bundle site présent : `test -f docs/index.html && test -f docs/nav.json && test -f docs/meta.json && test -f docs/.nojekyll && test -d docs/pages` → exit 0.
- [x] Aucune référence résiduelle : `grep -rnE '\bdoc/' --include='*.md' --include='*.sh' --include='*.json' --include='*.html' . | grep -v 'CHANGELOG.md'` → **vide** (hors récits historiques `specs/Sprints/*.md`, `bak/sdlc-kit-exportable.md` — convention target project distincte — et `.claude/settings.local.json`, non versionné).
- [x] Scripts cohérents : `grep -nE '\bdoc/' sdlc-init.sh sdlc-delta.sh sdlc-project-check.sh` → vide.
- [x] `00-CONTEXT.md §1` et `specs/SPEC.md §Modules` listent la surface `docs/` (site) : `grep -c 'docs/' 00-CONTEXT.md specs/SPEC.md` → ≥ 1 chacun.
- [x] Entrée `M-ARCH` présente : `grep -nE 'M-ARCH-[0-9]+.*docs?/' 07-DECISIONS-SDLC.md` → ≥ 1 résultat.
- [x] `CHANGELOG.md` mis à jour (nouvelle version en tête).
- [x] Tests niveau A : `bash -n sdlc-init.sh && bash -n sdlc-delta.sh && bash -n sdlc-project-check.sh` (syntaxe scripts OK) **et** le grep de non-régression ci-dessus vide.
- [x] CHANGELOG mis à jour.

```
Scénario : publication du site depuis docs/
  Étant donné le dépôt sur main avec docs/ peuplé et .nojekyll présent
  Quand GitHub Pages est réglé sur "Deploy from branch → main → /docs"
  Alors https://laurentgely.github.io/SDLC/ affiche le site (sidebar + Vue d'ensemble)
  Et les pages internes se chargent via fetch de docs/pages/*.md sans 404
```

---

## Risques

- **Substitution trop large (`docs/` → `docss/`, mots contenant « doc »)** : Moyen · utiliser `\bdoc/` (ancre de mot + slash), vérifier par `grep` avant/après, relire le `git diff`.
- **Rupture de référence croisée (fichier registre `00-CONTEXT.md`, `07-DECISIONS-SDLC.md`)** : Moyen · niveau de test B obligatoire (`STANDARDS.md §Modules partagés`), Acceptance Auditor en Adversarial Review.
- **Scripts créant encore `doc/` à l'exécution** (`mkdir doc/...`) : Moyen · grep ciblé sur les 3 scripts + `bash -n`.
- **Jekyll masque `nav.json`/`meta.json` sur Pages** : Faible · `.nojekyll` présent (critère d'acceptation).

---

## Pre-mortem *(obligatoire pour taille M et L)*

> Si ce sprint échoue ou dépasse 2× l'estimation, la cause la plus probable est :

Une substitution `sed` mal bornée qui corrompt des chemins voisins (`docs/` redoublé, occurrences dans des blocs de code d'exemple, faits historiques du CHANGELOG écrasés), non détectée faute d'avoir relu le `git diff` complet avant commit. Mitigation : motif `\bdoc/` strict, `grep` de non-régression exhaustif comme critère bloquant, et relecture Blind Hunter du diff en wrap-up.

---
<!-- FIN PRD — La section Handoff est complétée par Claude Code en début de session -->

## Handoff Claude Code
*(à compléter en début de session)*

**Fichiers — chargement immédiat :**
- 07-DECISIONS-SDLC.md (bloc M-ARCH pour connaître le format + prochain numéro)
- 00-CONTEXT.md §1 (carte des fichiers)
- specs/SPEC.md §Modules
- sdlc-init.sh, sdlc-delta.sh, sdlc-project-check.sh
- CHANGELOG.md (en-tête, pour connaître le dernier tag de version)

**Fichiers — chargement différé :**
- Tous les fichiers listés par `grep -rlE '\bdoc/' --include='*.md' --include='*.sh' --include='*.json' --include='*.html' .` — édités par sed scripté, pas lus intégralement un par un.

**Données à collecter avant de coder :**
- Localisation réelle du bundle site (absent de la racine du dépôt — trouvé dans `~/Downloads/Documentation for Claude project.zip`)
- Dernier numéro M-ARCH utilisé (M-ARCH-08) → nouvelle entrée M-ARCH-09
- Dernier tag CHANGELOG (`v2.0+SDLC-Audit-GSTACK`) → nouveau tag `v2.0+SDLC-25`
- Collision de numérotation SDLC-24 déjà pris → renommé SDLC-25 (validé utilisateur)
- `.gitignore` référence `doc/EVO.md` (fichier non versionné) → doit suivre le renommage sinon `docs/EVO.md` redevient visible en `git status`
- `.claude/settings.local.json` contient des refs `doc/` mais n'est PAS versionné (ignoré globalement `~/.config/git/ignore`) → hors périmètre, ne pas toucher

**Instructions spécifiques :**
- CHANGELOG.md est exclu à 100% du sed (fichier journal historique) — seule une nouvelle entrée en tête est ajoutée manuellement
- bak/sdlc-kit-exportable.md est versionné → inclus dans le sed s'il contient `\bdoc/`

**Grep de vérification préalable :**
```bash
# état initial : recenser l'ampleur du renommage avant d'agir
grep -rnE '\bdoc/' --include='*.md' --include='*.sh' --include='*.json' --include='*.html' . | wc -l
git status --porcelain   # doit être vide avant git mv
```

**Init mémoire sprint :**
```bash
echo "# Sprint SDLC-25 — docs-migration-site · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-SDLC-25-docs-migration-site.md" >> .claude/sprint-memory.md
```

---

## Plan de développement
*(produit par Claude Code après analyse — à compléter en étape 4d, avant tout code)*

**Dépendances vérifiées :**
- [x] Bundle `docs/` fourni — état : présent (hors racine dépôt, dans `~/Downloads/Documentation for Claude project.zip`), contenu conforme au schéma attendu
- [x] `git status` propre — état : clean au démarrage (seul le nouveau fichier spec est untracked, créé par cette session)

**Modules touchés :** voir §Plan d'exécution ci-dessous (rempli avant la demande d'aval, dans le message de chat — pas dupliqué ici pour éviter la dérive à deux endroits)

**Risques identifiés :** cf. §Risques ci-dessus, complété par :
- Collision de numérotation SDLC-24/SDLC-25 (résolue)
- `.gitignore` doit suivre le renommage `doc/EVO.md` → `docs/EVO.md`

**Plan d'exécution :**
1. `git mv doc docs`
2. Copier le bundle site extrait dans `docs/` (fichiers déjà nommés `docs/...` dans le zip)
3. Script `sed` de substitution `\bdoc/` → `docs/` sur tous les fichiers versionnés `.md`/`.sh`/`.json`/`.html` + `.gitignore`, à l'exclusion de `CHANGELOG.md`
4. Ajuster `sdlc-init.sh`/`sdlc-delta.sh`/`sdlc-project-check.sh` (déjà couverts par le sed, vérifier `bash -n`)
5. Ajouter surface `docs/` (site) dans `00-CONTEXT.md §1` et `specs/SPEC.md §Modules`
6. Ajouter entrée `M-ARCH-09` dans `07-DECISIONS-SDLC.md` + bump version fichier
7. Nouvelle entrée `CHANGELOG.md` en tête (`v2.0+SDLC-25`)
8. `git add` + tests + demande d'aval finale avant commit

**Plan de test :**
- A — Ciblé : `grep -rnE '\bdoc/' --include='*.md' --include='*.sh' --include='*.json' --include='*.html' . | grep -v 'CHANGELOG.md'`  (attendu : vide)
- **Volumétrie minimum :** ≥ 1 fichier effectivement modifié par le `sed` confirmé dans `git diff --stat`
- B — Non-régression : `bash -n sdlc-init.sh && bash -n sdlc-delta.sh && bash -n sdlc-project-check.sh` · pages `docs/pages/*.md` inchangées (`git diff --stat docs/pages/` → vide)

---

## Corrections ajustées vs spec
*(complété au wrap-up — §Étape 3)*

**Corrections ajustées vs spec** — Adversarial Review au wrap-up (Taille M, 3 couches) a trouvé 6 défauts réels non détectés en session d'exécution, tous corrigés avant commit :
- `README.md §Historique des versions` : le `sed` `\bdoc/`→`docs/` avait corrompu 3 lignes de faits historiques datés (ex. « réorg `doc/` → `specs/Sprints/` » devenu « réorg `docs/` → ... » alors que le dossier s'appelait encore `doc/` à cette date) — alors que `M-ARCH-09` revendique explicitement une exclusion « fidélité historique » identique à celle de `CHANGELOG.md`. Le bloc `§Historique des versions` de `README.md` n'a pas bénéficié de cette exclusion en pratique. Corrigé (3 lignes restaurées).
- `07-DECISIONS-SDLC.md` §M-ARCH-09 : « renommage complet (9 fichiers + historique) » — chiffre faux, le diff contient 12 renommages (`git status --porcelain | grep -c '^R '` → 12). Corrigé.
- `docs/nav.json` : deux groupes de navigation partageaient le badge `"num": "02"` (Concepts clés / Architecture) et deux le badge `"03"` (Skills / Référence), sans jamais atteindre `"04"` — bug d'affichage visible dès publication du site (sidebar avec deux fois « 02 », deux fois « 03 »). Renuméroté 01→05 séquentiellement.
- `docs/pages/intro.md` : bandeau « Version courante : v1.9+SDLC-23 » contredit `docs/meta.json`/`CHANGELOG.md` (`v2.0+SDLC-25`). Mis à jour.
- `docs/pages/versions.md` : page « Historique des versions » du site public s'arrêtait à `+SDLC-23`, n'incluait pas SDLC-24/Audit-GSD-lite/GSD-V1/GSD-V2/Audit-GSTACK/SDLC-25 pourtant documentés dans `CHANGELOG.md`. Section « Les audits externes et le passage à v2.0 (SDLC-24 → 25) » ajoutée.
- `docs/pages/demarrage.md` : tableau « skills disponibles » listait `/sdlc-init` comme une commande slash au même titre que `/sdlc-sync`/`/wrap-up`, alors que c'est le script bash `sdlc-init.sh`. Libellé corrigé.

Décision utilisateur : corriger les 6 points avant commit plutôt que les différer — dépasse légèrement le §Portée initial (« bundle livré tel quel »), acté explicitement.

**Test niveau B exécuté pour de vrai (jamais fait en conditions réelles jusqu'ici)** — a trouvé 2 défauts supplémentaires dans `sdlc-init.sh` :
- Bug préexistant, sans rapport avec ce sprint (confirmé par `git log -p`, ligne inchangée depuis le tout premier commit) : `sed` de `deploy_template()` cassé par la collision délimiteur `/` × date `JJ/MM/AAAA` en remplacement → le script n'avait **jamais** pu bootstrapper un projet avec succès, quel que soit le sprint. Corrigé (délimiteur `#`).
- Régression introduite par ce sprint : `mkdir -p "${TARGET_DIR}/doc"` (littéral suivi d'un guillemet, invisible au grep `\bdoc/`) laissait un dossier `doc/` vide dans chaque projet bootstrappé. Corrigé (`docs/`).

Les deux corrigés et revalidés par ré-exécution complète du script dans un repo git temporaire isolé avant ce commit (sous-shell, `M-PROC-30`). Décision utilisateur : corriger dans ce wrap-up plutôt que différer à un sprint Bug séparé, étant donné la sévérité (bootstrap totalement non fonctionnel) et la découverte incidente via le test B exigé par ce sprint lui-même. Détail : `07-DECISIONS-SDLC.md §M-ARCH-05 → Mise à jour 02/07/2026`.
