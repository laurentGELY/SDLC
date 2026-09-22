# Sprint SDLC-30 — Rattrapage `SPEC.html` / `MODE-OPERATOIRE.html` + contrôle C10

**Type :** Doc
**Taille :** L
**Sprint :** SDLC-30 (21/09/2026)

---

## §Contexte

Les deux livrables HTML de lecture humaine (`docs/SPEC.html`,
`docs/MODE-OPERATOIRE.html`) ne suivent plus le modèle depuis v1.4
(04/06/2026). Le rattrapage du site `docs/pages/` (commit `c47b9c0`,
`M-PROC-45`) a laissé ces deux fichiers hors périmètre.

**Vérification factuelle avant rédaction du plan (mesures du 21/09/2026) :**

1. **`SPEC.html`** — « Les 10 fichiers du modèle » (13 templates `00`→`12` sur
   disque) · « 19 décisions » (74 entrées `^## M-` dans le registre) · table
   des décisions arrêtée à v1.4 · 0 occurrence de `sdlc-validate`, `Barre
   qualité`, `12-audit`, `Vérification factuelle`, `Auto-revue`.
2. **`MODE-OPERATOIRE.html`** — mêmes 0 occurrence ; versions citées : v1.3,
   v1.4 seulement.
3. **Ils ne sont pas redondants avec le site** : `README.md`, `00-CONTEXT.md`,
   `06-PDR-bootstrap.md`, `01-`/`02-*-TEMPLATE.md` renvoient à
   `MODE-OPERATOIRE.html §Initialiser` ; le prompt exact à donner à Claude Code après
   le bootstrap et le format `D-SYNC-XX` n'existent pas dans `docs/pages/`
   (0 occurrence de « Complète la gouvernance » et de « Appliqués »). Les supprimer casserait 5 fichiers vivants.
4. **Cause structurelle** — aucun contrôle ne les surveille (même défaut que
   `M-PROC-45` pour le site) → C10.

---

## §Portée

**Inclus :**
- `docs/MODE-OPERATOIRE.html` : structure du repo (13 templates + 5 scripts),
  bootstrap, sync, évolution du modèle (`meta.json`/`versions.md`, C9/C10),
  carte des fichiers, skills ; concepts clés manquants (vérification
  factuelle, auto-revue, barre qualité, `sdlc-validate`)
- `docs/SPEC.html` : 10 → 13 fichiers ; circuits et workflow (vérification
  factuelle, auto-revue, `sdlc-validate`) ; table des décisions remplacée par
  un résumé (6 familles, total, décisions structurantes) renvoyant à
  `07-DECISIONS-SDLC.md`
- `sdlc-validate.sh` : contrôle C10 ; `07-DECISIONS-SDLC.md` : `M-PROC-46`
- Bump `v2.0+SDLC-30` : `README.md`, `CHANGELOG.md`, marqueurs `01-`/`02-`,
  `00-CONTEXT.md`, `docs/meta.json`, `docs/pages/versions.md`
- `docs/pages/modules.md` : rôle de la ligne 12 raccourci (rendu du tableau)

**Exclu :**
- Recopie des 74 décisions dans `SPEC.html` (reproduirait la dérive — le
  registre reste la source)
- Refonte graphique ou de la structure des deux HTML — classes CSS existantes
  réutilisées
- `P-32` (recommandation « prompt structuré », `docs/ROADMAP.md §Later`) —
  hors scope, non demandé

---

## §Critères d'acceptation

- [ ] `grep -c "Les 10 fichiers\|19 décisions" docs/SPEC.html` → `0`
- [ ] `grep -c "sdlc-validate" docs/SPEC.html docs/MODE-OPERATOIRE.html` → ≥ 1 sur chaque fichier
- [ ] `grep -c "12-audit-externe" docs/SPEC.html docs/MODE-OPERATOIRE.html` → ≥ 1 sur chaque fichier
- [ ] `grep -c "Barre qualité" docs/SPEC.html docs/MODE-OPERATOIRE.html` → ≥ 1 sur chaque fichier
- [ ] `grep -c "Vérification factuelle" docs/SPEC.html docs/MODE-OPERATOIRE.html` → ≥ 1 sur chaque fichier
- [ ] `grep -c "SDLC version : v2.0+SDLC-30" docs/SPEC.html docs/MODE-OPERATOIRE.html` → `1` sur chaque fichier
- [ ] `grep -c "check_c10" sdlc-validate.sh` → ≥ 2
- [ ] `grep -c "^## M-PROC-46" 07-DECISIONS-SDLC.md` → `1`
- [ ] Équilibre des balises HTML : script `html.parser` → 0 balise non fermée sur chaque fichier
- [ ] `bash sdlc-validate.sh` → 10/10, exit code 0
- [ ] C10 observé ❌ sur 3 fixtures isolées (marqueur périmé, template absent de `SPEC.html`, template absent de `MODE-OPERATOIRE.html`) puis ✅ sur le repo
- [ ] Rendu : captures Chromium headless de `SPEC.html` et `MODE-OPERATOIRE.html` relues, sans débordement ni bloc cassé

---

## §Plan de développement

1. Lire les deux HTML en entier (structure, classes CSS réutilisables).
2. `MODE-OPERATOIRE.html` : mise à jour section par section.
3. `SPEC.html` : mise à jour section par section ; table des décisions → résumé.
4. `sdlc-validate.sh` : `check_c10` (marqueur de version + présence de chaque template `NN-*.md` dans les deux HTML) ; ajout aux `CHECKS`.
5. `07-DECISIONS-SDLC.md` : `M-PROC-46` + tableau de compatibilité.
6. Bump `v2.0+SDLC-30` (fichiers listés en §Portée) ; `docs/pages/modules.md` ligne 12.
7. Vérification : critères ci-dessus, fixtures C10, captures Chromium.
8. `/wrap-up` — **Adversarial Review obligatoire (taille L)**.

---

## §Risques

- **~950 lignes de HTML écrites à la main par fichier** — risque de balise
  cassée ou de bloc hors style. Mitigé par le script d'équilibre des balises
  et les captures Chromium relues.
- **Le résumé des décisions remplace une table** — choix de contenu validé en
  amont (aval du 21/09/2026). Le registre `07-DECISIONS-SDLC.md` reste la
  source ; le résumé ne contient aucun identifiant recopié hors des
  décisions structurantes citées.
- **C10 vérifie la présence de noms de fichiers, pas la justesse du texte** —
  limite assumée et documentée dans `M-PROC-46` (même famille que C9).

---

## §Corrections ajustées vs spec

- **Chiffre de fichiers** — le §Contexte affirmait « 13 templates » ; le compte réel
  (`ls [0-9][0-9]*.md`) donne 14 fichiers (00→12 + 04b). Les deux HTML ont été
  rédigés sur le chiffre réel, pas sur celui du plan.
- **Chiffre de commandes copiables** — le §Contexte et `M-PROC-46` affirmaient
  « 31 blocs de commandes copiables absents du site », déduit d'un `grep -c` sur
  des lignes plutôt que d'un décompte. Réel : 8 blocs `<pre>`, 5 boutons Copier
  dans `MODE-OPERATOIRE.html` d'origine. Reformulé sur ce qui manque
  réellement au site : le prompt exact du bootstrap et le format `D-SYNC-XX`
  (0 occurrence vérifiée dans `docs/pages/`).
- **Marqueurs `01`/`02` non bumpés** — §Portée prévoyait de les inclure dans le
  bump ; aucun template n'a changé ce sprint (seuls les 2 HTML et
  `sdlc-validate.sh`), donc leur marqueur de version — qui suit le contenu du
  template, pas la version globale — n'avait pas à bouger. Retiré du §Portée
  a posteriori, non fait consciemment plutôt qu'oublié.
- **Commentaire `check_c10`** — un chiffre approximatif (« ~25 versions ») avait
  glissé dans un commentaire de code lors de la correction d'un finding de
  revue adverse ; corrigé en chiffre exact (23) au même moment.
