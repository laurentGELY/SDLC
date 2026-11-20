Statut : clos — 2026-11-20
# Sprint SDLC-33 — Agrégation des remontées Job search (28/09 → 19/11/2026)
<!-- PDR rédigé le 19/11/2026 en session Claude.ai (projet SDLC) · confronté au dépôt laurentGELY/SDLC @ 012905d · mis à jour le 19/11 avec doc/LESSONS_LEARNED.md v2.0.19 et la table de verdict ELAG-3 de Job search · corrigé le 19/11 en session Claude Code après confrontation au dépôt Job search @ c5378e0 (voir §Corrections du 19/11) · destination : specs/Sprints/sprint-SDLC-33-agregation-remontees-jobsearch.md -->

**Type :** Feature
**Taille :** L — lot 0 préalable (commit de report hors bump, avant l'étape 4a) + 4 lots, un commit par lot, **point de coupe obligatoire après le lot 1** (§Point de coupe)
**Surface :** `01`, `02`, `03` (+ skill vivant), `04`, `04b`, `05`, `07`, `08`, `09` (+ skill vivant), `11`, `13` (nouveau), `sdlc-init.sh`, `sdlc-validate.sh`, `tests/`, `.claude/hooks/pre-tool-bash.sh`, `docs/ROADMAP.md`, `docs/LESSONS_LEARNED.md`, gouvernance (README, CHANGELOG, SPEC, HTML, meta)
**Risque :** Moyen — beaucoup de fichiers partagés, mais aucun code exécuté en production ; chaque lot est fermé par `sdlc-validate.sh` + suite de tests

> Ligne 1 `Statut : ouvert` : cette spec applique déjà le marqueur que le lot 1 introduit (M-PROC-55). Le wrap-up la passera à `Statut : clos — AAAA-MM-JJ`.

---

## Corrections du 19/11 (session Claude Code, dépôt Job search lisible)

La session Claude.ai n'avait pas accès au dépôt Job search ; celle-ci, si. Changements apportés au PDR d'origine :

1. **Le colis du 18/11 existe**, et depuis le 19/11 toutes les remontées ouvertes sont dans une **file unique** `doc/REMONTEE_SDLC.md` (Job search, décision P-20 de la rétro du 19/11). Entrée **E8** ajoutée. Items 18/11-1 à 18/11-4 traités : 18/11-1 **rejetée pour le modèle** (la phrase visée n'a jamais existé dans `03` — `git log -S "prêt à écraser" -- 03-wrap-up-SKILL-TEMPLATE.md` → aucun commit) ; 18/11-2 et 18/11-3 → **ELAG-4** ; 18/11-4 → **ELAG-1b**.
2. **K6 retiré** : `01:263` (R-39, remontée 18/11-2) est réécrit par ELAG-4, qui passe avant les lots 1 à 3 (ordre décidé le 19/11 : lot 0 de SDLC-33 → ELAG-1b → ELAG-4 → lots 1 à 3 de SDLC-33).
3. **K9 et K12 tranchés par ELAG-1b**, qui a maintenant son PDR (`specs/Sprints/sprint-ELAG-1b-fix-bootstrap.md`) : regex du hook réécrite et testée sur 13 cas ; C2 saute le frontmatter avant de chercher la version. Plus de HALT-ARCH possible sur `13`.
4. **Les 10 retraits d'ELAG-3 sont nommés** dans `AUDIT-ELAGAGE-2.md §Verdict ELAG-3` (Job search) ; l'Import élagage n'attend plus de liste et a son PDR (`specs/Sprints/sprint-ELAG-4-import-elagage.md`). Le verdict sur les 7 retraits d'ELAG-1 écrit au lot 0 est corrigé (R-32 a été **retirée**, R-61 et R-91 ont été tranchées le 21/10).
5. **« 12 règles imprécises »** → « 12 règles portant un défaut du prompt-audit » (point 4 du verdict ELAG-3) : c'est ce que dit la source.
6. **19/11-3** : Claude Code remplace `$1`, `$2`… d'un skill par ses arguments. La résolution `MAIN=… | awk 'NR==1{print $2}'` prévue pour `/reprise` aurait ce défaut → `sed -n '1s/^worktree //p'`. ELAG-1b ajoute un test qui refuse tout `$<chiffre>` dans un skill déployé.
7. **File de remontées** (P-20) ajoutée au lot 2 : les templates `wrap-up` et `retrospective` écrivent chaque `[SDLC_CANDIDATE]` dans `docs/REMONTEE_SDLC.md` ; la rétro compte les remontées en attente (`M-PROC-61`).
8. **19/11-2** (chiffres importés = hypothèses) ajoutée au lot 3 (`04`) ; **19/11-1** (règle de chemin vérifiée en session neuve) renvoyée à « Import élagage 2 ».
9. **R-26, R-56, R-57** déplacés de `01` vers `13` au lot 1 : le contrôle de budget d'ELAG-4 (`M-PROC-49`) impose « une entrée, une sortie » à tout ajout dans `01`, et ces règles de reprise ont trouvé leur destination.
10. **R-JS-02** : la prose conditionnelle dans `02` est complétée par un bloc de hook optionnel dans `08` (dans Job search, c'est la règle la plus servie, et elle y est protégée par un hook).
11. **Numéro du contrôle `Statut`** : ELAG-4 prend le prochain numéro libre pour son contrôle de budget ; celui de ce PDR devient `C<n>` (C12 si ELAG-4 est passé). Les critères disent « tous les contrôles OK », pas « 11/11 ».
12. **P-19** (commande multi-ligne → script), non tagué par Job search : adopté par Laurent le 19/11 sous forme adaptée, au lot 3.

---

## Contexte

Le projet Job search (« Projet A ») a produit, entre le 28/09 et le 19/11/2026, des remontées `[SDLC_CANDIDATE]` reportées à la main, plus le retour de clôture d'ELAG-3. Aucune n'est appliquée dans le modèle : `git log` s'arrête à `012905d` (brouillon ELAG-2, octobre). Les remontées touchent les mêmes fichiers (`01`, `03`, `05`, `08`) ; les traiter en sprints séparés ferait repasser trois fois sur les mêmes sections. Elles convergent en outre sur un constat commun : **une règle écrite n'est pas une garde**.

### Registre chronologique des entrées

| # | Date | Source (fichier reçu) | Sujet | Propositions |
|---|------|-----------------------|-------|--------------|
| E1 | 28/09 | `REMONTEE_SDLC_2026-09-28.md` | Dettes « à surveiller » sans propriétaire + rétro S56 | D-1, D-2, D-3 · S56-1, S56-2, S56-3 · règle « config effective » |
| E2 | 20/10 → 19/11 | `a4236032-attachment.txt` (remontée « reprise ») | Mémoire de reprise multi-sprints, décisions D1–D6 tranchées le 19/11 | `reprise.md` + skill `/reprise` + marqueur `Statut` |
| E3 | 20/10 → 21/10, relu 19/11 | `ff6a32bf-…` et `f849642a-…` (**fichiers identiques**, `cmp` OK) = `claude/REPRISE-ELAG-DGOV.md` | Remontée ELAG-2 + D-GOV-01 | diff prêt (annexe A) + §3.3 · D-GOV-01 · 4 décisions en attente |
| E4 | 11/11 | `REMONTEE_SDLC_2026-11-11.md` | Règles de documentation appliquées à la seule clôture + R6 `/sdlc-sync` | D-4, D-5, D-6, D-7 · R6 |
| E5 | 14/11 (transmis 19/11 en conversation) | Retour Laurent, entrée « Sprint ELAG-3 » de `doc/LESSONS_LEARNED.md` Job search | Clôture ELAG-3 | (a) 6 règles `R-JS` à importer · (b) limite de la mesure `M-PROC-50` · 12 règles portant un défaut du prompt-audit · 10 retraits (`7da06ce`) |
| E6 | 01/11 → 19/11 | `LESSONS_LEARNED.md` Job search v2.0.19 (17/11, + entrée Sprint 88 du 19/11) | `[SDLC_CANDIDATE]` des rétros 01/11, 11/11, 14/11 et des sprints 72, 79, 88 | L1 témoin apparié (P-18) · L2 inventaire `--ignored` avant `git worktree remove` · L3 `/reprise` v1.2.0 « même objet » · L4 inventaire des porteurs d'ID avant scission · L5 une surveillance, une source · L6 ligne de log relevée dans le code (⏳) · L7 18/11-5 et 18/11-6 · L8 biais de l'issue par défaut ELAG-3 · L9 faux positif `--force` du hook |
| E7 | 14/11 | `ELAG-3-table-verdict.md` Job search (instantané avant retraits, `808ab05`) | Verdict d'usage par règle | 156 IDs (90 `R-NN` variantes `~` comprises, 66 `R-JS`) sur 166 lignes · servie 17 · non sollicitée 36 · non mesurable 97 · gênante 1 · déjà tranchée 2 · déjà retirée 3 |
| E8 | 18/11 → 19/11 | `doc/REMONTEE_SDLC.md` Job search (file unique depuis le 19/11, `c5378e0`) | Toutes les remontées ouvertes + rétro du 19/11 | 18/11-1 à 18/11-6 · 19/11-1 règle de chemin vérifiée en session neuve · 19/11-2 chiffres importés = hypothèses · 19/11-3 `$<chiffre>` dans un skill · P-20 file unique et procédure de traitement |

**Couverture :** E8 rend caduque la réserve d'origine (colis du 18/11 et remontée du 01/11 non reçus) : la file reprend toutes les remontées ouvertes en texte intégral. Les 10 retraits d'ELAG-3 sont nommés dans `AUDIT-ELAGAGE-2.md §Verdict ELAG-3` (Job search), pas seulement dans le diff `7da06ce`.

---

## Objectif

À la fin du sprint, chaque proposition du registre E1–E8 a une issue vérifiable par `grep` : appliquée dans un template et tracée par une décision `07`, renvoyée vers un autre sprint qui la porte (ELAG-1b, ELAG-4, Import D-GOV-01), rejetée avec sa raison, ou renvoyée vers une ligne ROADMAP qui nomme un déclencheur observable. `bash sdlc-validate.sh` reste vert et la suite de tests passe, cas RED nouveaux compris. Un bilan de report au format de la file est remis à Laurent.

---

## Comportement actuel → cible

- **Actuel :** le modèle connaît deux horizons d'état (session, sprint) et pas le multi-sprints ; une dette « à surveiller » n'a pas de maison ; les règles de documentation ne s'appliquent qu'au `/wrap-up` ; `specs/SPEC.md` est déclarée « exhaustive et toujours à jour » (`01:117`) ; `/sdlc-sync` traite un chemin local (`doc/`, `specs/Sprints/sprint-template.md`) comme un écart ; les `[SDLC_CANDIDATE]` restent dispersés dans les entrées LESSONS des projets ; les remontées ELAG-2/ELAG-3 ne sont tracées ni dans la ROADMAP ni dans LESSONS_LEARNED.
- **Cible :** un skill `/reprise` et un fichier non versionné `.claude/reprise.md` portent le futur de tous les sprints ouverts ; toute dette nomme sa maison et son observateur ; une règle de doc mécanisable est un test pre-commit ; une référence d'architecture « fait foi » et se corrige dans le commit qui l'a fait mentir ; `/sdlc-sync` reconnaît les réglages locaux de chemin ; chaque projet tient une file unique `docs/REMONTEE_SDLC.md` que ce projet vide ; ELAG-2/ELAG-3 sont reportés et l'Import élagage ne dépend plus que d'états observables.

---

## Analyse d'agrégation

### Trois convergences

1. **Une règle écrite n'est pas une garde.** E1 (dette rangée mais non observée), E4 (SPEC dérivée sous règle écrite, docs générés exacts), E3 (R-83 et R-03 : règle présente, défaut passé → MÉCANISER), E5 (R-JS-15 : tout filet est déclenché pour de vrai) et `LL-T15` (hook inerte 2 mois). → Lot 2.
2. **Les chemins réels divergent du modèle, et le modèle les prend pour des écarts.** E2 (`doc/REPRISE.md` au lieu de `.claude/reprise.md`), E4-R6 (`specs/Sprints/sprint-template.md`, `DECISIONS` scindé), E8 (`doc/REMONTEE_SDLC.md`), E3 (PDR ELAG-2 en `docs/` au lieu de `doc/` : **3ᵉ occurrence** du candidat « chemins réels dans les PDR Claude.ai », `docs/LESSONS_LEARNED.md:74`). → Lot 3.
3. **Plusieurs sprints vivent en même temps, souvent dans des worktrees.** E2-D2 (une `sprint-memory.md` par copie de travail), E1-S56-2 et E5-R-JS-02 (développer hors de la copie exécutée par le run planifié), E5-R-JS-06 (rien de durable attaché à la session), E1-S56-3 (boucles `pgrep -f` orphelines 2 j 18 h). → Lot 1.

### Corrections des remontées confrontées au dépôt (`012905d`)

| # | Ce que dit la remontée | Ce que montre le dépôt | Conséquence pour ce PDR |
|---|------------------------|------------------------|-------------------------|
| K1 | E2 : nouvelle décision **M-PROC-49** (« dernier ID observé : M-PROC-48 ») | `M-PROC-48` est bien le dernier ID de `07`, mais `specs/Sprints/AUDIT-ELAGAGE-1.md:432` a déjà rédigé `M-PROC-49`→`54`, `M-ARCH-10`, `M-TMPL-10` (provisoires, référence figée `573d1f3` utilisée par Job search) | **49–54 et M-TMPL-10 sont à ELAG-4, M-ARCH-10 à ELAG-1b.** Ce sprint numérote à partir de **M-PROC-55** |
| K2 | E2 : ajouter `*/.claude/reprise.md` au carve-out M-HOOKS-04 dans `08-hooks-TEMPLATE.md` **et** dans le hook | Le carve-out n'existe que dans `.claude/hooks/pre-tool-bash.sh:52` ; `08` ne l'a jamais reçu (`M-HOOKS-06`, tableau `07:550` : « si M-HOOKS-04 rétro-porté ») | Modifier le **hook vivant seul** ; `08` inchangé sur ce point |
| K3 | E1 : rubrique « DETTE À SURVEILLER », « étape 6 Amorce » | Dans le modèle : bloc `DETTE / EFFETS DE BORD` du bilan `03 §0d` (`03:84`) et Amorce = `§Étape 5` | Numérotation locale à Job search ; D-1 s'applique à `§0d` et `§Étape 5` |
| K4 | E1 : action `Surveiller ⏳`, générateur `gen_etat.py` (D-2) | Aucune occurrence de `Surveiller` dans les templates ; pas de générateur d'état ; l'équivalent d'`ETAT.md` est `ROADMAP §Now`, tenu à la main | D-2 adapté : l'observateur s'écrit dans la colonne Déclencheur de `05` ; les échéances datées vont dans `reprise.md` (R4) |
| K5 | E4-R6 : « le template vit dans `specs/Sprints/` », « `DECISIONS` scindé depuis D-CTX-02 » | Le modèle déploie `specs/sprint-template.md` partout (`sdlc-init.sh:228`, `06:78`, `README.md:134`, `specs/SPEC.md:86`) ; `D-CTX-02` absent du dépôt (`grep -rn` → 0) | Pas un défaut de template : **réglage local de chemin** de Job search → traité par M-PROC-59 (lot 3) |
| K6 | E5 : importer R-JS-04 « ne jamais recréer un fichier existant » | `01:263` prescrit l'inverse : « régénérer le fichier complet depuis le template » | **Transféré à ELAG-4** (réécriture de §Modifications spot, R-37/R-38/R-39, remontée 18/11-2) : ce sprint ne touche pas `01:263` |
| K7 | E2 : C2 tient avec `Statut` en ligne 1 | `check_c2` lit `head -3` ; le titre passe en ligne 2, le commentaire de version en ligne 3 | Confirmé, **marge nulle** → note dans `04` |
| K9 | E6 (S85) : le hook refusait `--force` jusque dans `git worktree remove --force` ; corrigé dans Job search (`b943413`) | La regex du modèle laisse passer 3 poussées forcées et bloque 2 commandes légitimes sur 11 cas (testé le 19/11) | **Porté par ELAG-1b** (lot 1 de son PDR) ; le lot 0 ne fait que pointer la ligne ROADMAP vers ce PDR |
| K10 | E2 : spec du skill `/reprise` arrêtée au 20/10 | Job search en est à `/reprise` v1.2.0 (rétro 01/11, A3) : contrôle « sprints ouverts sur le même objet », qui a détecté au 1er passage le recouvrement Spike 74 / Sprint 75 (E6, Spike 74) | Le lot 1 intègre ce contrôle ; s'il est fourni, le SKILL.md de Job search sert de source, nettoyé du spécifique |
| K11 | E3 : « 87 + 66 = 153 ≠ 166, à faire préciser par ELAG-3 » | E7 : 166 = lignes du tableau de correspondance, 156 = IDs (90 `R-NN` + 66 `R-JS`) ; `AUDIT-ELAGAGE-2.md` : 87 présentes + 6 hors unité de comptage + 41 absentes = 134 | Unités clarifiées dans LESSONS (lot 0) |
| K12 | E2 : SKILL `/reprise` avec frontmatter `name`/`description` | C2 cherche la version dans les 3 premières lignes de tout `NN-*.md` ; un frontmatter la repousse | **Tranché par ELAG-1b** : C2 saute le frontmatter. `13` suit cette convention |
| K13 | — | Le dépôt SDLC est **public** (clone anonyme) et `docs/` est publié (`M-ARCH-09`). Les fichiers Job search contiennent des données personnelles (employeurs, montants, horaires, état de la machine) | Rien de Job search n'est copié tel quel : la table E7 est réduite aux colonnes ID / Verdict / Motif ; `LESSONS_LEARNED.md` et `REMONTEE_SDLC.md` de Job search ne sont jamais copiés |
| K14 | E1-S56-1 : compléter le niveau C | Les niveaux de test sont déjà définis deux fois : `01:448-450` et `02:51-57` | Appliquer D-5, que ce sprint adopte : S56-1 va dans `02` seul ; `01` n'est pas touché (ELAG-4 fond par ailleurs R-63→R-65) |
| K8 | E3 : le diff de l'annexe A s'applique tel quel | `patch -p0 --dry-run` → OK sur `docs/ROADMAP.md` et `docs/LESSONS_LEARNED.md` (19/11) | Mais la ligne ELAG-3 qu'il ajoute en §Later est périmée (ELAG-3 clos le 14/11) → amendement au lot 0 |
| K15 | E8 : 18/11-1 « le template `wrap-up` demande de réécrire les fichiers en entier » (priorité n° 1 de la file) | La phrase n'existe pas dans `03` et n'y a jamais existé (`git log -S`) : divergence locale du skill de Job search, corrigée au S89 | **Rejetée pour le modèle** ; inscrite au bilan de report |
| K16 | E2 : résolution `MAIN=$(git worktree list --porcelain \| awk 'NR==1{print $2}')` | E8-19/11-3 : `$2` est remplacé par l'argument du skill ; avec `/reprise init`, le chemin devenait `/doc/REPRISE.md` dans Job search | `MAIN=$(git worktree list --porcelain \| sed -n '1s/^worktree //p')` ; aucun `$<chiffre>` dans `13` |
| K17 | E8-P-20 : la procédure de la file demande « une entrée D-… » côté SDLC, et nomme `doc/REMONTEE_SDLC.md` | Dans le modèle, les décisions sont des `M-<FAMILLE>-NN` (`07`) ; `D-…` est le préfixe des projets. La convention du modèle est `docs/` | Template : `docs/REMONTEE_SDLC.md`, variante locale `doc/` (M-PROC-59) ; adoption tracée par une entrée `M-…` qui cite l'ID de la remontée et le projet source |

---

## Portée

**Inclus :**

- **Lot 0 — Report ELAG-2 + ELAG-3** (docs seuls, hors bump)
- **Lot 1 — Mémoire de reprise multi-sprints** (E2, + S56-2, R-JS-02, R-JS-06, R-26/R-56/R-57 déplacés)
- **Lot 2 — Des gardes plutôt que des règles écrites, file de remontées** (D-1, D-2, D-3, D-4, D-6, S56-1, S56-3, R-JS-01, R-JS-15, P-20)
- **Lot 3 — Une source par fait, chemins locaux** (D-5, D-7, R6, R-JS-28, 19/11-2, P-19)
- **Lot 4 — Gouvernance, validation, bump `v2.0+SDLC-33`**

**Exclu (explicitement) :**

- **ELAG-1b** — sprint propre, PDR `specs/Sprints/sprint-ELAG-1b-fix-bootstrap.md` : renommage en `CLAUDE.md` et détection de version (`04b:17`, `README.md:96`), hook (regex, source unique), frontmatter et C2, `.gitignore`, `pre-compact.sh`, 18/11-4, garde 19/11-3.
- **ELAG-4 (Import élagage)** — PDR `specs/Sprints/sprint-ELAG-4-import-elagage.md` : retraits et fusions étayés par ELAG-2/3, `M-PROC-49`→`54`, `M-TMPL-10`, contrôle de budget, 18/11-2 (`01:263`), 18/11-3, limite de mesure `M-PROC-50`.
- **D-GOV-01** — sprint Doc S séparé (ligne ROADMAP créée au lot 0). Hypothèse retenue pour ce sprint : le bloc `§Validation` **remplacera** la grille succès/échec de `04:230`. Ce PDR ne touche donc pas `04:230`.
- **Automatisation R1/R2 de `reprise.md`** (hook) — E2-D6 : réouverture via `[HOOK_CANDIDATE]` seulement si un oubli est constaté.
- **18/11-5** (état validé après livraison, cache rejouable) et **18/11-6** (volume d'entrée → durée du pire cas contre le plafond du service) — propres aux pipelines planifiés : ROADMAP §Later, déclencheur « un 2ᵉ projet du modèle tourne en service planifié ».
- **19/11-1** (règle de chemin vérifiée en session neuve, par une lecture réelle) — rattachée à « Import élagage 2 » (adoption de `.claude/rules/`), noté au lot 0.
- **Applications locales Job search** (E1 §4, Sprint 78) — restent dans Job search.
- `specs/Sprints/AUDIT-ELAGAGE-1.md` — **figé** (référence `573d1f3`).

### Point de coupe (après le lot 1)

Le lot 1 (fonction nouvelle, à valider sur le terrain) et les lots 2-3 (règles et prose) n'ont ni le même risque ni le même rythme. Après le commit du lot 1, faire le point dans `sprint-memory.md` :

- **Continuer** si les deux conditions tiennent : moins de la moitié de l'estimation consommée, aucun signal de dégradation observé.
- **Sinon, couper** : SDLC-33 = lot 0 + lot 1 + la gouvernance de `13` (07 `M-PROC-55`, tableau de compatibilité, SPEC §Modules, README, CHANGELOG, HTML C10, `CLAUDE_PROJECT.md`) ; les lots 2-3 et le reste du lot 4 deviennent **SDLC-34**, dont le PDR reprend mot pour mot les sections « Lot 2 » et « Lot 3 » ci-dessous. Noter la coupe dans `.claude/reprise.md` (premier usage réel du skill dans ce dépôt).

---

## Option retenue — alternatives écartées

**Retenue :** un seul PDR, découpé en lots ordonnés, un commit par lot, `sdlc-validate.sh` + suite de tests verts à la fin de chaque lot. Chaque ajout dans `01` (contexte permanent) est compensé par un retrait ou un déplacement de même taille, cité par son `R-NN` : le contrôle de budget d'ELAG-4 (`M-PROC-49`) échoue sinon.

**Écartée(s) :**
- Un sprint par remontée (4 sprints) — repasse 3 fois sur `01`, `03`, `05`, `08` ; recommandation explicite d'E2 §10.
- Fusionner ELAG-1b — taille XL, et ELAG-1b corrige un défaut actif dans tout projet bootstrappé : il ne doit pas attendre.
- Importer les 6 règles `R-JS` mot pour mot dans `01` — 2 portent un défaut du prompt-audit, 1 contredit `01:263` (traitée par ELAG-4), 3 doublonnent une règle existante ou une autre remontée.

**Sacrifices délibérés :** malgré le titre du lot 2, **seuls quatre changements sont de vraies gardes** : `C<n>` (marqueur `Statut`, lot 1), paire C4 de `13`, hook `pkill`/`pgrep` (S56-3), squelette pre-commit de `08` (optionnel, D-4) — plus le bloc de hook optionnel R-JS-02. D-1, D-6, L4-L6, S56-1, R-JS-01 et R-JS-15 restent des règles écrites : aucun signal mécanique simple ne les contrôle dans un projet cible. Elles seront mécanisées si une récidive est constatée (`[HOOK_CANDIDATE]`) ; pas de hook d'écriture de `reprise.md` ; pas de générateur d'état ; pas de test C2 à 4 lignes (seulement la note) ; la validation terrain C1–C4 du skill `/reprise` se fait dans Job search après synchronisation, pas dans ce sprint.

---

## Contraintes techniques / produit

- Toute référence `chemin:ligne` de ce PDR est celle de `012905d`. ELAG-1b et ELAG-4 passent avant les lots 1 à 3 : **re-grep avant chaque édition**, les numéros de ligne auront bougé, et le fichier d'instructions s'appellera `CLAUDE.md`.
- Modifications ciblées : outil `Edit` après lecture, ou `sed` + `grep` de vérification (`§Modifications spot` réécrite par ELAG-4).
- Template modifié → version incrémentée dans les 3 premières lignes après le frontmatter (C2, adapté par ELAG-1b).
- Template de skill modifié → même changement dans `.claude/skills/<skill>/SKILL.md`, même commit (C4).
- Aucun `$<chiffre>` dans un template de skill (19/11-3, test d'ELAG-1b).
- IDs `M-XXXX-NN` vérifiés par `grep` avant écriture (`M-PROC-48`, `LL-T13`/`LL-T14`).
- Pas d'entrée CHANGELOG pour le lot 0 (C1 compare README et 1ʳᵉ entrée CHANGELOG ; précédent `M-PROC-47`).
- **Budget de `01`** : contrôle de budget d'ELAG-4 ; chaque ajout fait au plus 2 lignes dans `01` et se compense ; le détail va dans le skill `13` ou dans `02`. `wc -lc` avant/après rapporté dans §Corrections ajustées.
- **Dépôt public** (K13) : aucun nom d'employeur, montant, horaire personnel ou chemin de données Job search dans un fichier commité.

**Interdit :**
- modifier `specs/Sprints/AUDIT-ELAGAGE-1.md` ;
- utiliser `M-PROC-49`→`54`, `M-ARCH-10` ou `M-TMPL-10` ;
- toucher `01:263` (`§Modifications spot`, ELAG-4) ;
- versionner un fichier `reprise.md` ou en déposer un dans ce dépôt ;
- ajouter une exception à `sdlc-validate.sh` sans renvoi vers une décision `07` ;
- copier `LESSONS_LEARNED.md` ou `REMONTEE_SDLC.md` de Job search, ou la table E7 avec ses colonnes Énoncé et Emplacement.

---

## Dépendances

**Inputs requis :**
- [x] Dépôt à `012905d` ou descendant, `bash sdlc-validate.sh` vert, `bash tests/sdlc-validate-test.sh` vert.
- [x] **ELAG-1b livré** (commit présent dans `git log`) **avant les lots 1 et 2** : ils modifient `sdlc-init.sh` (skills déployés, `.gitignore`) et les hooks, qu'ELAG-1b réécrit.
- [x] **ELAG-4 livré avant les lots 1 à 3** : contrôle de budget en place, `01` allégé, `01:263` réécrit (ordre décidé le 19/11).
- [x] *Lot 0 exécutable sans l'un ni l'autre.* Si ELAG-1b ou ELAG-4 manque au démarrage des lots 1 à 3 → BLOQUANT, signaler et s'arrêter après le lot 0.
- [x] Aval de Laurent sur le lot 0 (décision 1 de `claude/REPRISE-ELAG-DGOV.md §5`).

**Outputs produits :**
- [x] `13-reprise-SKILL-TEMPLATE.md` + déploiement par `sdlc-init.sh`
- [x] décisions `M-PROC-55`→`M-PROC-61` et `M-HOOKS-09` dans `07`, avec lignes du tableau de compatibilité *(M-PROC-55 fait ; 56→61 et M-HOOKS-09 → SDLC-34)*
- [→ SDLC-34] file `docs/REMONTEE_SDLC.md` décrite dans les templates `wrap-up` et `retrospective`
- [x] ROADMAP : « Import élagage » pointé sur ELAG-4 ; « Import D-GOV-01 » en §Later
- [→ SDLC-34] bilan de report au format de la file (§Annexe)

**Règle :** avant de démarrer, vérifier que tous les inputs requis cochés existent et sont dans l'état attendu. Si un input manque ou a changé → signaler comme BLOQUANT avant toute analyse.

---

## Lots — contenu détaillé

### Lot 0 — Report ELAG-2 + ELAG-3 (`docs/` seulement, hors bump)

1. Appliquer le diff de l'annexe A de `claude/REPRISE-ELAG-DGOV.md` (copie dans `/tmp/remontee.diff`) :
   ```bash
   sed -E 's#^(---|\+\+\+) (orig|new)/#\1 docs/#' /tmp/remontee.diff | patch -p0 --dry-run && \
   sed -E 's#^(---|\+\+\+) (orig|new)/#\1 docs/#' /tmp/remontee.diff | patch -p0
   ```
2. Extraire de la table E7 les seules colonnes ID / Verdict / Motif (K13) vers `specs/Sprints/ELAG-3-table-verdict-jobsearch.md` :
   ```bash
   T=/tmp/remontees/ELAG-3-table-verdict.md; O=specs/Sprints/ELAG-3-table-verdict-jobsearch.md
   { echo '# ELAG-3 — verdict par règle (extrait : ID, verdict, motif)'
     echo '<!-- Extrait du 19/11/2026 — origine : Job search specs/Sprints/ELAG-3-table-verdict.md @ 808ab05 (instantané avant retraits). Ne pas éditer. -->'
     echo; echo '| ID | Verdict | Motif |'; echo '|---|---|---|'
     grep -E '^\| R-' "$T" | awk -F'|' '{print "|"$2"|"$3"|"$4"|"}'
     echo; sed -n '/^## Totaux/,$p' "$T"; } > "$O"
   grep -c '^| R-' "$O"   # attendu : 156
   ```
   Relire la colonne Motif avant commit : elle ne doit nommer aucun employeur ni donnée personnelle (K13).
3. Amender (les ajouts §3.3 de la reprise, mis à jour par E5-E8) :
   - **Ligne ELAG-1b (§Next)** : renvoi vers son PDR `specs/Sprints/sprint-ELAG-1b-fix-bootstrap.md` ; ajouter au libellé `· regex push --force (K9, correctif de référence Job search b943413) · garde $<chiffre> dans les skills (19/11-3) · frontmatter sdlc-sync revenu (18/11-4)`.
   - **ROADMAP §Later → §Historique** : retirer la ligne ELAG-3 ajoutée par le diff ; ajouter en tête de §Historique : `ELAG-3 *(externe — exécuté dans Job search)* | Spike | M | ELAG-3 (clos 14/11/2026, pas de 2ᵉ fenêtre) | 15 sprints dont 9 M/L · 156 IDs · 10 retirées, 3 fondues, 6 déplacées · Job search CLAUDE.md v3.19 (7da06ce) · table copiée en specs/Sprints/ELAG-3-table-verdict-jobsearch.md · 2 propositions SDLC : 6 R-JS, limite M-PROC-50 · 12 règles portant un défaut du prompt-audit`.
   - **Ligne Import élagage** : renommée `ELAG-4 — Import élagage`, renvoi vers `specs/Sprints/sprint-ELAG-4-import-elagage.md` ; `Bloqué par` → `ELAG-1b livré` ; `Déclencheur` → `ELAG-1b en §Historique` ; verdicts Job search sur les 7 retraits d'ELAG-1 (source : `AUDIT-ELAGAGE-2.md §Verdict`) : R-13 confirmé provisoire · R-16 gardée (renvoi d'une ligne) · R-32 retirée · R-44 gardée · R-61 gardée telle quelle · R-83 infirmé (règle durcie) · R-91 gardée, `M-TMPL-10` appliquée.
   - **Nouvelle ligne §Later** : `Import élagage 2 — méthode du Sprint 89 de Job search (/demarrage, .claude/rules/, échelle de réponse à un incident, plafonds des skills) · + 19/11-1 (règle de chemin vérifiée en session neuve, par Read ou cat/head d'un fichier couvert) | Doc | M | — | ELAG-4 | surveillance du Sprint 89 close (trace /demarrage aux 2 sprints suivants dans Job search) | —`.
   - **Nouvelle ligne §Later** : `Import D-GOV-01 — proportionner la preuve à l'incertitude (claude/REPRISE-ELAG-DGOV.md §4) : 07 décision effective, 02 règle courte + ligne Tuning (02:33), 04 bloc §Validation 4 champs qui remplace la grille L (04:230) · + P-18 témoin apparié (Job search, rétro 01/11 : écrire avant la mesure ce qui distingue témoin et essai, une seule variable) · + bruit de répétabilité mesuré avant de départager (Job search S75/S84) · règle 7 : l'issue par défaut ne s'appuie jamais sur une mesure d'usage auto-déclarée (ELAG-3 : ~140 retraits à tort, interdictions comprises) | Doc | S | — | — | Exécutable après SDLC-33 (04 touché par les deux) | —`.
   - **Nouvelle ligne §Later** : `18/11-5 et 18/11-6 (Job search) — état durable écrit après la livraison, cache rejouable des étapes coûteuses ; volume d'entrée → durée du pire cas contre le plafond du service | Doc | XS | — | — | un 2ᵉ projet du modèle tourne en service planifié | —`.
   - **LESSONS_LEARNED, entrée « Remontée ELAG-2 »** : ajouter §3.1 (3 motifs faux pour Job search, biais d'origine : 51 règles `aucune (48c7c23)`, 6 des 7 retraits parmi elles) et §3.2 (issue par défaut, désormais historique).
   - **LESSONS_LEARNED, nouvelle entrée « Remontée ELAG-3 (Job search) — 14/11/2026 »** : chiffres ci-dessus, totaux E7 et unités (166 lignes, 156 IDs ; 87 + 6 + 41 = 134 — K11), propositions (a) et (b), renvoi vers SDLC-33 pour (a) et vers ELAG-4 pour (b) ; **biais de l'issue par défaut** : appliquée à la lettre (D-GOV-01 règle 7, §3.2 de la reprise), elle aurait retiré ~140 règles dont les interdictions — tranché avant tout retrait, retraits fondés sur la redondance (`CLAUDE.md` 23 → 18 Ko) ; `LL-T15` +1 occurrence (K9, hook `--force`) ; **observation** sprint 61 Job search sans spec dans le dépôt (E2 §9) → `LL-T05` passe de 2 à 3 occurrences ; le déclencheur de réouverture de `M-TMPL-08` (`07`, « 3e fois malgré… ») est atteint **si M-TMPL-08 était synchronisé dans Job search à ce moment** — à qualifier à la prochaine `/retrospective`, pas dans ce sprint.
4. Vérifier puis rendre la main à Laurent, qui lance `bash sdlc-validate.sh` et committe :
   `docs(sdlc): report remontées ELAG-2 (ebf210d) et ELAG-3 (7da06ce) — hors bump`

### Lot 1 — Mémoire de reprise multi-sprints (E2, décision `M-PROC-55`)

Appliquer le tableau E2 §6, avec les corrections K1, K2, K7, K12, K16. Spec complète du skill : E2 §4 (règles R1–R6, gabarits, résolution du chemin) et §5 (procédure du matin, mode `init`, périmètre du marquage, amorçage d'un projet existant) — **à recopier intégralement** dans `13-reprise-SKILL-TEMPLATE.md`, avec un frontmatter `name: reprise` / `description:` limitée aux déclencheurs (`/reprise`, « quelle est la suite », « où on en est des sprints », ouverture de session sans sprint désigné).

| Fichier | Changement |
|---|---|
| `13-reprise-SKILL-TEMPLATE.md` (**nouveau**) | Frontmatter en ligne 1, puis commentaire de version `<!-- Template SDLC v1.0 · Destination : .claude/skills/reprise/SKILL.md dans le repo cible -->` (convention C2 d'ELAG-1b) · table des 3 mémoires (E2 §3) · R1–R6 · gabarits `## En vol` / `## Sprints ouverts` · résolution `MAIN=$(git worktree list --porcelain \| sed -n '1s/^worktree //p')` (K16 — aucun `$<chiffre>`) · procédure du matin · mode `init` (5 sources) · **ajout R-JS-06** : un processus ou un état qui survit à la session (job en arrière-plan, boucle `until`, minuterie) est inscrit dans `## En vol` avec sa commande d'arrêt, sinon il n'est pas lancé · **ajout L3 (K10)** : étape 4 de la procédure du matin — deux sprints ouverts qui touchent le même objet (mêmes fichiers dans « Reste pour clore » ou même section de ROADMAP) sont signalés, même si « Dépend de : — » · **reçoit R-26, R-56, R-57** de `01` (bloc « mémoire sprint non vide » à 4 options, reconstruction depuis git, trace écrite après compaction) |
| `01-Claude-md-TEMPLATE.md` | (a) `§Démarrage` : étape **4e** — créer le bloc du sprint dans `$REPRISE`, « Reste pour clore » = critères d'acceptation du PDR · (b) `01:173` « Si aucun sprint spec n'est fourni → demander » devient « … → `/reprise` (plan des sprints ouverts), puis demander » · (c) **R-26** (bloc `MÉMOIRE SPRINT NON VIDE`, `01:176-207` environ), **R-56**, **R-57** (`§Mémoire de sprint`) : déplacés dans `13`, remplacés par un renvoi d'une ligne ; l'exception « une `sprint-memory.md` par copie de travail » est écrite dans `13` · (d) `§Mémoire de sprint` : 2 lignes « Le futur de tous les sprints ouverts vit dans `.claude/reprise.md` (non versionné) — voir `/reprise` » · bilan net en lignes rapporté (doit être négatif : `M-PROC-49`) |
| `02-STANDARDS-TEMPLATE.md` | **Option worktree** (fusion S56-2 + R-JS-02, conditionnelle, section `§Types de sprint` ou nouvelle sous-section courte) : « si le dépôt est exécuté par un service planifié, le sprint se développe dans un worktree dédié ; la copie exécutée reste sur la branche de production, on n'y change jamais de branche » |
| `08-hooks-TEMPLATE.md` | Bloc optionnel `[ACTIVER si dépôt exécuté par un service planifié]` : refuser `git switch` / `git checkout <branche>` dans la copie principale (dans Job search : règle la plus servie, 12 sprints sur 15, protégée par hook) ; dans le bloc extrait par `sdlc-init.sh` (marqueurs d'ELAG-1b), commenté par défaut |
| `03-wrap-up-SKILL-TEMPLATE.md` **+** `.claude/skills/wrap-up/SKILL.md` | Écrire `Statut : clos — AAAA-MM-JJ` en ligne 1 de la spec · contrôle de complétude : refuser la clôture si « Reste pour clore » a une case non cochée, sauf confirmation explicite · purger le bloc (R3) · **ajout L2** : sprint mené dans un worktree → avant `git worktree remove`, `git -C <worktree> status --ignored --porcelain` ; tout résultat ignoré par git (banc, sortie de mesure) est versé dans la spec ou déplacé avant suppression · `03:418` « next actions (rôle de `docs/ROADMAP.md §Now`) » → « (rôle de `.claude/reprise.md`, et de `ROADMAP §Now` pour le sprint en exécution) » |
| `04-sprint-PDR-TEMPLATE.md` | Ligne 1 : `Statut : ouvert` ; titre en ligne 2 ; commentaire de version en ligne 3, incrémenté ; commentaire « C2 lit 3 lignes : marge nulle, tout nouveau champ d'en-tête impose d'élargir C2 » |
| `05-ROADMAP-TEMPLATE.md` | `05:12` → « un seul sprint **en exécution** par copie de travail ; un sprint en attente d'un déclencheur reste en §Now avec ⏸ + déclencheur + pointeur `.claude/reprise.md` » |
| `.claude/hooks/pre-tool-bash.sh` (hook vivant seul — K2) | Ajouter `\|\| "$FILE_PATH" == */.claude/reprise.md` à la condition du carve-out (`:52`) |
| `sdlc-init.sh` | Créer `.claude/skills/reprise`, `deploy_copy` de `13` vers `.claude/skills/reprise/SKILL.md`, ligne `.claude/reprise.md` dans le `.gitignore` produit (celui qu'ELAG-1b crée), mention dans le récapitulatif |
| `sdlc-validate.sh` + `tests/sdlc-validate-test.sh` | Paire C4 `13-reprise-SKILL-TEMPLATE.md\|.claude/skills/reprise/SKILL.md` + entrée `C4_EXCEPTIONS` (« skill non installé dans le repo SDLC — M-PROC-55 ») + cas RED · **`C<n>` (nouveau, prochain numéro libre)** : la ligne 1 de chaque `specs/Sprints/sprint-*.md` respecte `^Statut : (ouvert\|clos — [0-9]{4}-[0-9]{2}-[0-9]{2})$` ; correctif affiché : « écrire `Statut : ouvert` (spec active) ou `Statut : clos — AAAA-MM-JJ` (date du commit de wrap-up) en ligne 1 » ; cas RED (spec sans marqueur) et cas vert |
| `specs/Sprints/sprint-*.md` du dépôt SDLC (33 fichiers le 19/11 : 31 à `012905d`, moins le brouillon ELAG-2 supprimé, plus les PDR ELAG-1b, ELAG-4 et SDLC-33) | **Marquage rétroactif**, préalable à `C<n>` (E2 §5, amorçage étape 0) : proposer à Laurent la liste `fichier → statut` avec, pour les clos, la date du dernier commit qui touche le fichier (`git log -1 --format=%cs -- <f>`) ; cas à arbitrer listés à part ; écrire après validation, par script (`sed -i '1i Statut : …'`) |

### Lot 2 — Gardes, règles de clôture et file de remontées (`M-PROC-56`, `M-PROC-57`, `M-PROC-60`, `M-PROC-61`, `M-HOOKS-09`)

*Vraies gardes dans ce lot : S56-3 (hook) et le squelette pre-commit de D-4. Le reste est écrit — voir §Sacrifices délibérés.*

| Prop. | Fichier | Changement |
|---|---|---|
| D-1 (`M-PROC-56`) | `03 §0d` (`03:84`) + skill vivant | Chaque ligne `⚠️` de `DETTE / EFFETS DE BORD` cite sa **maison**, par ordre de préférence : (1) garde automatique (test, hook) qui échoue quand le risque se matérialise ; (2) action de `.claude/reprise.md` avec déclencheur daté et vérifiable (R4) ; (3) ligne ROADMAP avec déclencheur observable **et observateur nommé**. Une dette sans maison, ou dont le déclencheur n'a pas d'observateur, bloque la clôture comme une entrée LESSONS manquante. Même règle rappelée dans le bloc Amorce `§Étape 5` · **L5** : une surveillance s'écrit dans sa seule maison, ailleurs un renvoi ; avant de la clore ou de la reconduire, `grep -rn "<libellé>"` de toutes ses mentions · **L6** (⏳ côté Job search) : un déclencheur qui cite une ligne de log la relève d'abord dans le code (`fichier:ligne`) |
| D-2 adapté (K4) | `05` §Next/§Later | Pas de nouvelle colonne : la colonne Déclencheur s'écrit `<déclencheur> · observé par : <script \| section \| /reprise \| personne>` ; « personne » est autorisé mais visible, et compte comme dette sans maison pour D-1 |
| D-3 (`M-HOOKS-09`) | `09:79-83` + skill vivant | Destination par défaut **C (hook)** quand la dette porte sur une commande dangereuse ou qui consomme une ressource externe ; A/B en complément |
| S56-3 (`M-HOOKS-09`) | `08` + `.claude/hooks/pre-tool-bash.sh` | Bloquer `pkill -f` ; bloquer `pgrep -f` dont le motif n'est pas ancré par `^`. Cas de test : 4 (2 bloqués, 2 passants), exécutés en isolation (M-PROC-30), ajoutés à `tests/sdlc-init-test.sh` d'ELAG-1b ; chaînes construites en deux morceaux (le hook vivant bloque sinon) |
| D-4 (`M-PROC-57`) | `03 §Étape 3` (`03:284`) + `01 §Wrap-up` + `08` (nouvelle section optionnelle « pre-commit git — règles de doc mécanisables ») | Une règle « si X change, mettre à jour Y » dont X est détectable (fichier ajouté, clé modifiée) s'applique par un test pre-commit, pas seulement au wrap-up. Squelette générique : inventaire d'un répertoire comparé à sa liste documentée. Repère terrain : scanner Job search < 0,1 s, 2 écarts trouvés que la revue manuelle avait manqués |
| D-6 + L4 (`M-PROC-57`) | `01 §Modifications spot` (règle « grep final », réécrite par ELAG-4) | Étendre : « …y compris toute référence à une section déplacée, scindée ou renommée : `grep -rn "<ancienne référence>" .claude/ CLAUDE.md STANDARDS.md specs/sprint-template.md` → zéro. Avant une scission ou un déplacement de fichier porteur d'identifiants, inventorier tous les porteurs (`grep -rl "^## [A-Z]-" .`), pas seulement le fichier scindé » |
| S56-1 (`M-PROC-60`) | `02 §Niveaux de test` (`02:57`, ligne C) seul — K14 | C — Intégration : « …et prouve qu'il n'écrit ni ne consomme rien à l'extérieur (messagerie, API, état distant), sinon il passe par un harnais qui remplace la collecte » |
| R-JS-01 + règle Laurent 28/09 (`M-PROC-60`) | `01:18` (fusion, pas d'ajout) | « modifier un fichier de configuration sans noter la valeur précédente **ni vérifier la valeur effective dans un run réel** » |
| R-JS-15 (`M-PROC-60`) | `02 §Definition of Done §Livrable` | « Tout filet de sécurité ajouté ou modifié (hook, garde, test bloquant) a été déclenché pour de vrai et son refus observé. » Forme DoD de `M-ARCH-10` (ELAG-1b) : renvoi, pas doublon |
| P-20 file de remontées (`M-PROC-61`) | `03 §Étape 1` (question rétro, case `[SDLC_CANDIDATE]`) + `09 §Étape 4` (remontées vers le modèle) + skills vivants · `sdlc-init.sh` | Chaque nouveau `[SDLC_CANDIDATE]` s'écrit dans la file `docs/REMONTEE_SDLC.md` (variante locale `doc/`, M-PROC-59) avec l'identifiant `[SDLC_CANDIDATE] JJ/MM-N — titre`, puis 2 à 4 lignes : constat (avec preuve : commit, fichier, incident), fichier cible du modèle, nature (règle, contrôle, procédure), proposition ; l'entrée LESSONS n'en garde qu'un renvoi. La file tient aussi un tableau « Remontées en attente » (statut : à reporter · report à confirmer · non tranché localement) et une section « Décisions demandées au projet SDLC ». À la rétro : compter les remontées en attente (indicateur suivi), inscrire les bilans de report reçus, retirer les remontées traitées. `sdlc-init.sh` crée la file vide avec ses 3 sections |

### Lot 3 — Une source par fait, chemins locaux, chiffres importés (`M-PROC-58`, `M-PROC-59`)

| Prop. | Fichier | Changement |
|---|---|---|
| D-7 (`M-PROC-58`) | `01:117` | « `specs/SPEC.md` fait foi pour l'architecture ; en cas d'écart avec le code, le code prime et la SPEC est corrigée dans le même commit. » |
| D-5 (`M-PROC-58`) | `02` (section documentation la plus proche, ou `§Règles d'archivage` si aucune) | « Un fait d'exploitation (horaire, matériel, modèle, chemin) ou un inventaire s'écrit à un seul endroit ; ailleurs, un renvoi. Un inventaire qu'un script peut produire est généré, jamais recopié. » |
| 19/11-2 (`M-PROC-58`) | `04 §Contexte` (commentaire du gabarit, une ligne) | « Un chiffre repris d'un audit, d'un PDR ou d'une remontée cite sa source et reste une hypothèse : le re-mesurer avant de cadrer, et signaler l'écart avant le plan. » (Job search : 3 chiffres faux en 3 jours venus d'audits ou de PDR, rétro du 19/11) |
| R6 + E2 « divergence assumée » (`M-PROC-59`) | `04b` (étape 0, inventaire `04b:35-41`) | Table « Réglages locaux de chemin » : chemin du modèle → variantes locales acceptées (`docs/`↔`doc/` · `specs/sprint-template.md`↔`specs/Sprints/sprint-template.md` · `docs/DECISIONS.md`↔`doc/DECISIONS.md` + `DECISIONS-<famille>.md` · `.claude/reprise.md`↔`doc/REPRISE.md` · `docs/REMONTEE_SDLC.md`↔`doc/REMONTEE_SDLC.md`). Détection par `ls` ; une variante détectée est consignée comme réglage local dans l'entrée `D-SYNC-XX`, jamais signalée comme écart. Le skill reste « zéro adaptation » |
| R-JS-28 | `01 §Rôle` (après le paragraphe « Toute affirmation factuelle doit être citable », `01:110-113`, ou ce qu'en laisse ELAG-4) | « Un identifiant de règle ou de décision cité à l'humain est suivi d'une courte phrase qui dit ce qu'il impose. » |
| P-19 (Job search, rétro 14/11 — 2 occurrences : S81, 14/11) | `01:122` (`§Rôle`, limites bash) — reformulation, pas d'ajout | « Pour toute action hors portée : fournir la commande exacte prête à copier **sur une ligne**, avec le résultat attendu ; au-delà d'une ligne, un script `~/<nom>.sh` lancé par une seule commande. » Un collage multi-ligne casse (heredoc coupé, unité systemd corrompue). La partie « script système livré avec son annulation et le relevé de l'état d'avant » n'est pas reprise (propre aux scripts système ; `02` si un second projet en a besoin) |

### Lot 4 — Gouvernance, validation, bump

- `07-DECISIONS-SDLC.md` : entrées `M-PROC-55`→`M-PROC-61` et `M-HOOKS-09` au format des entrées existantes (Contexte · Retenu · Écarté · Raison · Déclencheur de réouverture), chacune citant les identifiants des remontées qu'elle adopte et le projet source (K17) + lignes du tableau de compatibilité (`07:495`). Compatibilité :
  - **universel** : marqueur `Statut` et table des 3 mémoires (55), maison des dettes (56), D-4/D-6 (57), D-5/D-7/19/11-2 (58), réglages locaux (59), file de remontées (61), `M-HOOKS-09` ;
  - **conditionnel** : usage actif de `/reprise` (« sprints à déclencheur externe »), option worktree et bloc de hook R-JS-02 (« dépôt exécuté par un service planifié »), S56-1 (« test C qui touche une ressource externe ») ;
  - Déclencheur de réouverture de 55 : tests terrain C1–C4 (E2 §7) non tenus dans Job search après 2 semaines ; de 61 : remontées en attente en hausse sur 2 rétros consécutives.
- `06-PDR-bootstrap.md` (carte des fichiers) · `11-help-SKILL-TEMPLATE.md` (routage `/reprise`, M-TMPL-05) — pas de skill vivant `help` ici (`C4_EXCEPTIONS`).
- `specs/SPEC.md §Modules`, `00-CONTEXT.md §1`, `README.md` (structure + « Version courante : v2.0+SDLC-33 »), `CHANGELOG.md` (entrée `## [v2.0+SDLC-33]`), `docs/meta.json`, `docs/pages/versions.md`, `docs/SPEC.html` + `docs/MODE-OPERATOIRE.html` (C10 : chaque template cité, `13` compris), `docs/CLAUDE_PROJECT.md` (nouveau SKILL.md synchronisé ; `reprise.md` jamais synchronisé ; procédure de traitement de la file, `M-PROC-61`).
- ROADMAP : SDLC-33 en §Historique ; `docs/LESSONS_LEARNED.md` : entrée du sprint + candidat « chemins réels dans les PDR Claude.ai » noté au seuil de graduation.
- **Bilan de report** (Annexe, colonne Issue) remis à Laurent, au format `JJ/MM-N : adoptée (M-…, template X vY) | adaptée (…) | rejetée (raison) | en attente (quoi)`.

---

## Critères d'acceptation

*(La DoD — `STANDARDS.md §Definition of Done` — s'applique en plus.)*

- [x] Lot 0 : `grep -c "Remontée ELAG-3" docs/LESSONS_LEARNED.md` → ≥ 1 · `grep -n "Import D-GOV-01" docs/ROADMAP.md` non vide · `grep -n "Import élagage 2" docs/ROADMAP.md` non vide · `grep -n "ELAG-3-table-verdict" docs/ROADMAP.md` non vide · `awk '/^## 🗂 Later/,/^## §Seuils/' docs/ROADMAP.md | grep -c "^| ELAG-3"` → 0
- [x] `test -f specs/Sprints/ELAG-3-table-verdict-jobsearch.md && grep -c '^| R-' specs/Sprints/ELAG-3-table-verdict-jobsearch.md` → 156 · `grep -cE "sprint-ELAG-1b-fix-bootstrap|sprint-ELAG-4-import-elagage" docs/ROADMAP.md` → ≥ 2 · `grep -n "R-32 retirée" docs/ROADMAP.md` non vide *(vérifié à `ecb1b15` : 156 · 2 · 1 ; depuis, les lignes §Next d'ELAG-1b/ELAG-4 sont passées en §Historique)*
- [x] `grep -n "même objet" 13-reprise-SKILL-TEMPLATE.md` non vide · `grep -n -- "--ignored" 03-wrap-up-SKILL-TEMPLATE.md .claude/skills/wrap-up/SKILL.md` non vide dans les deux
- [x] `grep -nE '\$[0-9]' 13-reprise-SKILL-TEMPLATE.md 03-wrap-up-SKILL-TEMPLATE.md 09-retrospective-SKILL-TEMPLATE.md` → vide · `grep -n "sed -n '1s/^worktree //p'" 13-reprise-SKILL-TEMPLATE.md` non vide
- [x] `head -1 04-sprint-PDR-TEMPLATE.md | grep -E '^Statut : ouvert$'` · `sed -n 3p 04-sprint-PDR-TEMPLATE.md | grep -E '<!--.*v[0-9]+\.[0-9]+'`
- [x] `test -f 13-reprise-SKILL-TEMPLATE.md && grep -c '^- \*\*R[1-6]' 13-reprise-SKILL-TEMPLATE.md` → 6 · `head -1 13-reprise-SKILL-TEMPLATE.md` → `---`
- [x] R-26/R-56/R-57 déplacés : `grep -c "MÉMOIRE SPRINT NON VIDE" 01-Claude-md-TEMPLATE.md` → 0 et ≥ 1 dans `13-reprise-SKILL-TEMPLATE.md`
- [x] `grep -n "reprise.md" .claude/hooks/pre-tool-bash.sh` non vide · `grep -n "reprise" sdlc-init.sh` → déploiement **et** `.gitignore`
- [x] Bootstrap jetable (`git init` + commit vide, puis `bash sdlc-init.sh "Test"`) : `.claude/skills/reprise/SKILL.md` présent, `grep -qx '.claude/reprise.md' .gitignore`, `docs/REMONTEE_SDLC.md` présent avec ses 3 sections *(skill et `.gitignore` vérifiés ; `docs/REMONTEE_SDLC.md` → SDLC-34)*
- [x] Résolution depuis un worktree secondaire (dépôt jetable) : `MAIN` renvoie la copie principale, y compris quand le skill reçoit un argument
- [→ SDLC-34] `grep -n "toujours à jour" 01-Claude-md-TEMPLATE.md` → vide · `grep -n "fait foi" 01-Claude-md-TEMPLATE.md` non vide
- [x] `grep -n "observé par" 05-ROADMAP-TEMPLATE.md` non vide · `grep -n "un seul item actif à la fois" 05-ROADMAP-TEMPLATE.md` → vide *(« un seul item actif » → vide fait ; « observé par » → SDLC-34)*
- [→ SDLC-34] `grep -nE "maison.*(garde|reprise|ROADMAP)" 03-wrap-up-SKILL-TEMPLATE.md .claude/skills/wrap-up/SKILL.md` non vide dans les deux
- [→ SDLC-34] File : `grep -c "REMONTEE_SDLC.md" 03-wrap-up-SKILL-TEMPLATE.md 09-retrospective-SKILL-TEMPLATE.md .claude/skills/wrap-up/SKILL.md .claude/skills/retrospective/SKILL.md` → ≥ 1 dans chacun · `grep -n "remontées en attente" 09-retrospective-SKILL-TEMPLATE.md` non vide
- [→ SDLC-34] `grep -n "hypothèse" 04-sprint-PDR-TEMPLATE.md` non vide (19/11-2)
- [→ SDLC-34] `grep -n "sur une ligne" 01-Claude-md-TEMPLATE.md` non vide et `grep -c "~/<nom>.sh" 01-Claude-md-TEMPLATE.md` → 1 (P-19, sans ligne ajoutée)
- [x] Marqueur sur toutes les specs : `for f in specs/Sprints/sprint-*.md; do head -1 "$f" | grep -qE '^Statut : (ouvert|clos — [0-9]{4}-[0-9]{2}-[0-9]{2})$' || echo "$f"; done` → vide
- [x] Aucun contenu Job search brut commité : `grep -n "Énoncé\|Emplacement actuel" specs/Sprints/ELAG-3-table-verdict-jobsearch.md` → vide
- [x] Budget `01` : contrôle de budget d'ELAG-4 vert ; `wc -lc` du `CLAUDE.md` bootstrappé avant/après consigné, bilan net ≤ 0
- [→ SDLC-34] Hook : `pkill -f foo` → `2` · `pgrep -f '^foo'` → passant (cas de `tests/sdlc-init-test.sh`, chaînes en deux morceaux)
- [→ SDLC-34] `grep -n "Réglages locaux" 04b-sdlc-sync-SKILL-TEMPLATE.md` non vide · `grep -n "REMONTEE_SDLC" 04b-sdlc-sync-SKILL-TEMPLATE.md` non vide
- [x] `grep -cE '^## M-PROC-(55|56|57|58|59|60|61) · ' 07-DECISIONS-SDLC.md` → 7 · `grep -c '^## M-HOOKS-09 · ' 07-DECISIONS-SDLC.md` → 1 *(M-PROC-55 présent ; 56→61 et M-HOOKS-09 → SDLC-34)*
- [x] `git diff --stat 012905d -- specs/Sprints/AUDIT-ELAGAGE-1.md` → vide
- [x] Tests niveau A : `bash sdlc-validate.sh` → tous les contrôles OK (`C<n>` compris) · `bash tests/sdlc-validate-test.sh` et `bash tests/sdlc-init-test.sh` → tous OK, dont les nouveaux cas RED C4 et `C<n>` · `bash -n .claude/hooks/pre-tool-bash.sh`
- [→ SDLC-34] Bilan de report remis (une ligne par proposition de l'Annexe)
- [x] CHANGELOG mis à jour (`v2.0+SDLC-33`), C1 vert

---

## Pas de placeholders

`grep -En "TBD|à implémenter plus tard|gestion d'erreur appropriée|cas limites appropriés|similaire à la tâche" specs/Sprints/sprint-SDLC-33-agregation-remontees-jobsearch.md` → seule la ligne de ce paragraphe correspond (elle cite le motif).

---

## Signaux de dégradation

Si l'un de ces signaux apparaît, checkpoint immédiat dans `sprint-memory.md` et signaler avant de continuer :

- **Silent partial completion** — un lot annoncé fait alors que le skill vivant ou le hook vivant n'a pas reçu le changement (vérifier C4 et `grep` du hook).
- **Increasing vagueness** — le SKILL `/reprise` résume E2 §4-§5 au lieu de le recopier.
- **Skipped steps** — un critère d'acceptation rapporté couvert sans sortie de commande.
- **Budget contourné** — un ajout dans `01` compensé par une compression de texte plutôt que par un retrait ou un déplacement cité par `R-NN`.

---

## Risques

- **Conflit avec ELAG-1b et ELAG-4 sur `sdlc-init.sh`, les hooks et `01`** : probable si l'ordre n'est pas tenu · inputs requis bloquants pour les lots 1 à 3.
- **Fuite de données personnelles dans un dépôt public** (K13) : faible si l'extrait est relu · colonnes réduites + critère `grep`.
- **Gonflement de `01`** (contexte permanent) : faible · contrôle de budget d'ELAG-4 ; R-26/R-56/R-57 déplacés vers `13`.
- **Collision d'ID** avec ELAG-1b et ELAG-4 : écartée par K1 · critères `grep`.
- **Skill `/reprise` déclenché par un « suite » anodin** : moyen · description limitée aux déclencheurs (E2 §8).
- **Arguments de skill** (`$1`, `$2`) qui corrompent une commande : écarté par K16 et le test d'ELAG-1b.
- **La file de remontées n'est pas vidée côté SDLC** : moyen · indicateur « remontées en attente » à chaque rétro du projet source ; déclencheur de réouverture de `M-PROC-61`.

---

## Pre-mortem

> Si ce sprint échoue ou dépasse 2× l'estimation, la cause la plus probable est :

La gouvernance du lot 4 (C10 sur deux HTML, `meta.json`, `versions.md`, tableau de compatibilité) absorbe la fin de session après un lot 1 déjà long ; le sprint se clôt partiellement (P-14, R-83 : wrap-up partiel récurrent). Parade : tenir un commit par lot, et si le lot 2 n'est pas commencé à mi-parcours, basculer sur la découpe SDLC-33a / 33b et le noter dans `.claude/reprise.md` — premier usage réel du skill.

---
<!-- FIN PRD — La section Handoff est complétée par Claude Code en début de session -->

## Handoff Claude Code
*(à compléter en début de session)*

> Ce PDR ne remplace pas `CLAUDE.md §Démarrage` — les 4 étapes (4a créer le
> fichier spec · 4b initialiser la mémoire sprint · 4c charger les fichiers ·
> 4d écrire le §Plan de développement) restent dues même si ce Handoff n'en
> détaille qu'une partie ci-dessous.

**Fichiers — chargement immédiat :**
- ce PDR
- les entrées du registre (`claude/REPRISE-ELAG-DGOV.md`, remontées E1, E2, E4, `LESSONS_LEARNED.md` E6, table E7, file E8, à déposer par Laurent dans `/tmp/remontees/`, ou lues en direct dans le dépôt Job search par `git show <commit>:<fichier>`) — E2 §4-§5 est la spec du lot 1
- *(si disponible)* `.claude/skills/reprise/SKILL.md` de Job search — source préférée pour le lot 1 (K10), nettoyée du spécifique et des `$<chiffre>`
- `01-Claude-md-TEMPLATE.md`, `03-wrap-up-SKILL-TEMPLATE.md`, `09-retrospective-SKILL-TEMPLATE.md`, `.claude/hooks/pre-tool-bash.sh`

**Fichiers — chargement différé :**
- `07-DECISIONS-SDLC.md` (grep l'ID et le tableau `:495`) · `08-hooks-TEMPLATE.md` · `04b-…` · `sdlc-init.sh` · `sdlc-validate.sh`

**Données à collecter avant de coder :**
- dernier ID de chaque famille, état d'ELAG-1b et d'ELAG-4 (grep ci-dessous)
- `wc -lc` du `CLAUDE.md` bootstrappé (référence de taille, plafond du contrôle de budget)

**Instructions spécifiques :**
- Un commit par lot ; `sdlc-validate.sh` + suite de tests verts avant chaque commit.
- Lot 0 : s'arrêter après la vérification et rendre la main pour le commit de Laurent.
- Lot 1 : le SKILL `/reprise` recopie E2 §4-§5 verbatim, avec les corrections K1, K2, K7, K12, K16 et l'ajout R-JS-06.

**Grep de vérification préalable :**
```bash
git log --oneline -5
git log --oneline | grep -i "ELAG-1b" || echo "⚠️ ELAG-1b absent — lots 1-3 BLOQUÉS"
git log --oneline | grep -i "ELAG-4" || echo "⚠️ ELAG-4 absent — lots 1-3 BLOQUÉS"
grep -oE '\bM-PROC-[0-9]+' 07-DECISIONS-SDLC.md | sort -t- -k3n -u | tail -1   # attendu : M-PROC-54 après ELAG-4
grep -oE '\bM-HOOKS-[0-9]+' 07-DECISIONS-SDLC.md | sort -t- -k3n -u | tail -1  # attendu : M-HOOKS-08
grep -oE "^check_c[0-9]+" sdlc-validate.sh | tail -1                           # C<n> = suivant
ls [0-9][0-9]-*.md | tail -1                                                    # attendu : 12-audit-externe-TEMPLATE.md
grep -n "sprint-memory.md ]]" .claude/hooks/pre-tool-bash.sh                     # carve-out M-HOOKS-04
bash sdlc-validate.sh | tail -2 && bash tests/sdlc-validate-test.sh | tail -2 && bash tests/sdlc-init-test.sh | tail -2
```

**Init mémoire sprint :**
```bash
echo "# Sprint SDLC-33 — agregation-remontees-jobsearch · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-SDLC-33-agregation-remontees-jobsearch.md" >> .claude/sprint-memory.md
```

---

## Plan de développement
*(produit par Claude Code après analyse — à compléter en étape 4d, avant tout code)*

*(20/11/2026, session Claude Code, dépôt @ `f3b3b11`)*

**Dépendances vérifiées :**
- [x] Lot 0 livré — `ecb1b15` (ROADMAP §Next)
- [x] ELAG-1b livré — wrap-up intégré à `main` (`docs/SESSION_BRIDGE.md §Actif`)
- [x] ELAG-4 livré — `e18e6c0` (`v2.0+ELAG-4`) ; `check_c11` = budget (`sdlc-validate.sh:432`) → le contrôle `Statut` sera **C12**
- [x] Derniers IDs : `M-PROC-54`, `M-HOOKS-08`, `M-ARCH-10` (grep `07`) → ce sprint numérote `M-PROC-55`→`61`, `M-HOOKS-09`
- [x] Dernier template : `12-audit-externe-TEMPLATE.md` → `13-reprise-SKILL-TEMPLATE.md` libre
- [x] Baseline verte : `sdlc-validate.sh` 11/11 · `tests/sdlc-validate-test.sh` 22/22 · `tests/sdlc-init-test.sh` 49/49
- [x] Budget C11 : `BUDGET_LIGNES=368`, `BUDGET_OCTETS=18099` (`sdlc-validate.sh:30-31`) ; `01` = 368 lignes / 18 172 octets
- [~] **Entrées du registre** : `/tmp/remontees/` absent. Source du lot 1 = `/reprise` **v1.2.1** de Job search (`.claude/skills/reprise/SKILL.md` @ `c5378e0`, source préférée K10, `$2` déjà corrigé) + `specs/Sprints/sprint-66-reprise.md`. La pièce jointe E2 (§4-§5) n'est pas disponible localement → recopie depuis v1.2.1, généricisée (voir Risques)
- [x] Carve-out du hook vivant : `.claude/hooks/pre-tool-bash.sh:52` ; absent de `08` (K2 confirmé)
- [x] 32/33 specs `specs/Sprints/sprint-*.md` sans marqueur `Statut` (seule SDLC-33 l'a)

**Modules touchés :**
- Lot 1 : `13` (nouveau), `01` (R-26 `:114-135`, R-56 `:289-299`, R-57 `:301-305` déplacés ; 4e ; `:111`), `02`, `03` + skill vivant, `04`, `05:12`, `08` (bloc `[ACTIVER si service planifié]`), hook vivant, `sdlc-init.sh` (skill, `.gitignore` `:413`), `sdlc-validate.sh` (C4 + C12, budget abaissé), `tests/sdlc-validate-test.sh`, `tests/sdlc-init-test.sh`, 32 specs (marquage rétroactif)
- Lots 2-3 : `01`, `02`, `03`/`09` + skills vivants, `04`, `04b`, `05`, `08`, hook vivant, `sdlc-init.sh` (file `docs/REMONTEE_SDLC.md`), tests
- Lot 4 : `07`, `06`, `11`, `00-CONTEXT.md`, `specs/SPEC.md`, README, CHANGELOG, `docs/` (meta, versions, 2 HTML, CLAUDE_PROJECT.md), ROADMAP, LESSONS
- **Taille** : cœur L (lot 1 + lots 2-3) ; total XL une fois la gouvernance du lot 4 comptée (`M-PROC-28`) → point de coupe après le lot 1 maintenu

**Risques identifiés :**
- **E2 §4-§5 absente** → « recopier intégralement » impossible tel quel ; v1.2.1 est plus récente qu'E2 (20/10) et intègre L3. Généricisation : `doc/REPRISE.md` → `.claude/reprise.md`, `doc/ETAT.md` → `docs/ROADMAP.md §Now`, retrait des exemples Job search (noms d'employeurs, `data/diag`, section « Contrôles » du mail, « Laurent » → « l'humain ») — K13
- **Critère `grep -c '^- \*\*R[1-6]'` → 6** : v1.2.1 écrit `- R1 — …` sans gras → les règles s'écriront `- **R1 — titre** : …`
- **Skill vivant `wrap-up` adapté** (diff non nul avec `03`) : chaque modification appliquée aux deux, C4 ne compare que les `## `
- **Budget C11** : le déplacement R-26/R-56/R-57 (~38 lignes) laisse `01` bien sous le budget ; abaisser `BUDGET_*` à la mesure (cliquet), et vérifier que les cas C11 de `tests/sdlc-validate-test.sh` suivent
- **Marquage rétroactif** : liste `fichier → statut` à faire valider par l'humain avant écriture (le PDR l'exige) ; specs « suspendues » ou partielles à arbitrer
- **`$<chiffre>`** dans `13` : interdit (test d'ELAG-1b) → `sed -n '1s/^worktree //p'`, aucun `awk '{print $2}'`

**Plan d'exécution :**
1. Lot 1 sur une branche `sdlc-33` : `13` (frontmatter + version, recopie généricisée de v1.2.1 + R-JS-06 + R-26/R-56/R-57 reçus) → `01` (retraits + renvois, 4e, `:111`) → `02` option worktree → `08` bloc optionnel → `03` + skill vivant → `04` en-tête → `05:12` → hook vivant → `sdlc-init.sh` → C4/C12 + tests RED → liste du marquage rétroactif soumise → écriture → budget abaissé → tests → commit lot 1
2. **Point de coupe** consigné dans `sprint-memory.md` (critères §Point de coupe) ; si coupe : gouvernance de `13` puis wrap-up, lots 2-3 → SDLC-34
3. Lot 2 → commit · Lot 3 → commit · Lot 4 (gouvernance, bump `v2.0+SDLC-33`) → `/wrap-up`

**Plan de test :**
- A — Ciblé : `bash sdlc-validate.sh && bash tests/sdlc-validate-test.sh && bash tests/sdlc-init-test.sh && bash -n .claude/hooks/pre-tool-bash.sh` + chaque `grep` des §Critères d'acceptation du lot, sortie relevée
- A — Résolution `MAIN` : dépôt jetable + `git worktree add`, la commande de `13` lancée depuis le worktree renvoie la copie principale
- B — Non-régression : bootstrap jetable `sdlc-init.sh "Test"` (skill `reprise` présent, `.gitignore` complet, CLAUDE.md sous budget) ; hook vivant testé en isolation sur le carve-out `reprise.md` et sur `sprint-memory.md` (inchangé) ; `git diff --stat 012905d -- specs/Sprints/AUDIT-ELAGAGE-1.md` vide
- C — N/A

---

## Corrections ajustées vs spec
*(complété au wrap-up — §Étape 3)*

*(20/11/2026 — wrap-up au périmètre coupé)*

1. **Coupe après le lot 1 (+1b)**, décidée par Laurent au point de coupe : SDLC-33 = lot 0 + lot 1 + lot 1b + gouvernance de `13`. Lots 2, 3 et reste du lot 4 → **SDLC-34** (ROADMAP §Next) ; leurs propositions dans §Annexe restent à l'issue prévue, non appliquées. Les critères d'acceptation des lots 2-4 non cochés passent à SDLC-34.
2. **Source de `13`** : E2 §4-§5 indisponible localement (`/tmp/remontees/` absent) → `/reprise` v1.2.1 de Job search (`c5378e0`, K10), rendu générique (chemins, exemples, « l'humain »).
3. **Lot 1b (hors PDR, demandé par Laurent)** : `/reprise` installé dans ce dépôt (exception C4 retirée), `.gitignore` et `CLAUDE.md` de ce dépôt ; déploiement aux projets mis à jour par `04b` v2.2 et `sdlc-delta.sh`. Le PDR interdisait « un `reprise.md` dans ce dépôt » : levé, le fichier est gitignoré.
4. **`sdlc-delta.sh`** : défaut préexistant corrigé (version tronquée à `v2.0`, tout projet en v2.0+* « déjà à jour »).
5. **Gouvernance de `13` avancée au lot 1** : C6 et C10 rougissaient sans elle (`00-CONTEXT`, `06`, README, `SPEC.md`, 2 HTML).
6. **Critère « `grep -n "sed -n '1s/^worktree //p'"` »** : ne trouve rien sans `-F` (rc=1 sur ligne présente) → vérifié par `grep -F`.
7. **R7/R8/C4** du brouillon `REGLES_SDLC.md` (collé en session, jamais créé dans Job search) repris sans numéro dans §Cycle de vie d'un bloc ; le critère « 6 règles R » tient.
8. **Test du wrap-up** : 4 placeholders de date au lieu de 3 (marqueur `Statut : clos — AAAA-MM-JJ`).
9. **Contrôle « Reste pour clore »** (lot 1) : refusait sur la case `wrap-up` elle-même au premier usage → « autre que `wrap-up` ».
10. **Revue en aveugle** : 7 correctifs (doublon `04b`, consigne `MODE-OPERATOIRE`, exemple `until` → PID, `grep "^### <ID> "`, tests C12 sans nom en dur, garde `08` sur `checkout <ref> --`, sources citées) ; ligne ROADMAP §Later « `CLAUDE.md` de ce dépôt » créée.
11. **Budget `01`** : `wc -lc` 368 l / 18 172 o → 336 l / 16 757 o ; `CLAUDE.md` bootstrappé 336 l / 16 684 o hors ligne de version ; bilan net −32 lignes.

---

## Annexe — Devenir de chaque proposition (sert de bilan de report)

| Entrée | Proposition | Issue | Où |
|---|---|---|---|
| E1 | D-1 aucune dette orpheline | Adoptée | Lot 2 · `03 §0d`, `§Étape 5` · M-PROC-56 |
| E1 | D-2 déclencheurs observables | Adaptée (K4) | Lot 2 · `05` colonne Déclencheur |
| E1 | D-3 garde avant règle | Adoptée | Lot 2 · `09:79-83` · M-HOOKS-09 |
| E1 | S56-1 test C sans effet externe | Adoptée (K14 : `02` seul) | Lot 2 · `02 §Niveaux de test` · M-PROC-60 |
| E1 | S56-2 dépôt exécuté par un service planifié | Fusionnée avec R-JS-02 | Lot 1 · `02` option worktree + bloc de hook optionnel `08` |
| E1 | S56-3 `pkill -f` / `pgrep -f` | Adoptée | Lot 2 · `08` + hook vivant · M-HOOKS-09 |
| E1 | Config vérifiée en run réel | Fusionnée avec R-JS-01 | Lot 2 · `01:18` |
| E1 | Application locale (§4) | Hors périmètre | Job search |
| E2 | `reprise.md` + `/reprise` + marqueur `Statut` | Adoptée, corrigée K1/K2/K7/K12/K16 | Lot 1 · M-PROC-55 |
| E2 | Marqueur vérifiable par regex (D4) | Mécanisé : `C<n>` + marquage rétroactif des specs | Lot 1 · `sdlc-validate.sh` |
| E2 | Hook R1/R2 | Exclue (D6) | `[HOOK_CANDIDATE]` si oubli constaté |
| E2 | Observation « fichier généré modifié à la main » | Hors périmètre (1 occurrence) | LESSONS Job search |
| E2 | Observation sprint 61 sans spec (`LL-T05`) | Tracée | Lot 0 · LESSONS · à qualifier en rétro |
| E3 | Diff annexe A + §3.3 | Appliqué, amendé par E5-E8 | Lot 0 |
| E3 | D-GOV-01 | Sprint séparé (hypothèse) | Lot 0 · ROADMAP §Later |
| E3 | `§Validation` remplace la grille L | Hypothèse retenue | Sprint Import D-GOV-01 |
| E3 | Défauts bootstrap + détection de version `CLAUDE.md` | Portés par ELAG-1b | `specs/Sprints/sprint-ELAG-1b-fix-bootstrap.md` |
| E3 | Lectures R-83/R-03/R-51/R-52/R-92, `M-PROC-50` | Portées par ELAG-4 | `specs/Sprints/sprint-ELAG-4-import-elagage.md` |
| E4 | D-4 règle de doc mécanisable | Adoptée | Lot 2 · `03:284`, `01 §Wrap-up`, `08` · M-PROC-57 |
| E4 | D-5 un fait, une source | Adoptée | Lot 3 · `02` · M-PROC-58 |
| E4 | D-6 référence de section suivie | Adoptée (fusion) | Lot 2 · `01 §Modifications spot` · M-PROC-57 |
| E4 | D-7 « fait foi » | Adoptée | Lot 3 · `01:117` · M-PROC-58 |
| E4 | R6 chemins de `/sdlc-sync` | Adaptée (K5) en réglage local | Lot 3 · `04b` · M-PROC-59 |
| E5 | R-JS-01 config en run réel | Fusionnée | Lot 2 · `01:18` |
| E5 | R-JS-02 espace de travail séparé | Adaptée + fusion S56-2, bloc de hook optionnel | Lot 1 |
| E5 | R-JS-04 ne pas recréer un fichier | Portée par ELAG-4 (K6) | R-39, `§Modifications spot` |
| E5 | R-JS-06 rien de durable attaché à la session | Adoptée | Lot 1 · `13` (`## En vol`) |
| E5 | R-JS-15 filet déclenché pour de vrai | Adoptée | Lot 2 · `02 §DoD` (renvoi `M-ARCH-10`) |
| E5 | R-JS-28 code de décision + phrase | Adoptée | Lot 3 · `01 §Rôle` |
| E5 | (b) limite de la mesure `M-PROC-50` | Portée par ELAG-4 | `M-PROC-50` close |
| E5 | 10 retraits, 12 règles portant un défaut du prompt-audit | Portés par ELAG-4 (retraits) / sprint Fix ultérieur (défauts) | ROADMAP |
| E6 | L1 témoin apparié (P-18) | Sprint Import D-GOV-01 | Lot 0 · ROADMAP §Later |
| E6 | L2 inventaire `--ignored` avant `git worktree remove` | Adoptée | Lot 1 · `03` + skill vivant |
| E6 | L3 `/reprise` « même objet » | Adoptée (K10) | Lot 1 · `13` |
| E6 | L4 inventaire des porteurs d'ID avant scission | Adoptée (fusion D-6) | Lot 2 · `01 §Modifications spot` |
| E6 | L5 une surveillance, une source | Adoptée (avec D-1) | Lot 2 · `03 §0d` |
| E6 | L6 ligne de log relevée dans le code | Incluse, ⏳ côté Job search | Lot 2 · `03 §0d` — retirer si Laurent refuse |
| E6 | L8 biais de l'issue par défaut | Tracé | Lot 0 · LESSONS + ligne Import D-GOV-01 |
| E6 | L9 / K9 regex `--force` du hook | Portée par ELAG-1b | `specs/Sprints/sprint-ELAG-1b-fix-bootstrap.md` |
| E6 | P-19 commandes multi-lignes → script | Adaptée (non tagué, adopté par Laurent le 19/11) : `01:122` reformulée, partie annulation non reprise | Lot 3 · `01 §Rôle` · M-PROC-58 |
| E7 | Table de verdict | Copiée dans le dépôt (3 colonnes) | Lot 0 · `specs/Sprints/ELAG-3-table-verdict-jobsearch.md` |
| E8 | 18/11-1 wrap-up « contenu complet, prêt à écraser » | Rejetée pour le modèle (K15 : phrase absente de `03` depuis toujours) | — |
| E8 | 18/11-2 « Modifications spot » | Portée par ELAG-4 | R-37/R-38/R-39 |
| E8 | 18/11-3 liste « Éviter » en double | Portée par ELAG-4 | R-61, `01:499` |
| E8 | 18/11-4 frontmatter `sdlc-sync` revenu | Portée par ELAG-1b | `M-ARCH-10` |
| E8 | 18/11-5 état validé après livraison | En attente — déclencheur : 2ᵉ projet en service planifié | ROADMAP §Later |
| E8 | 18/11-6 volume d'entrée → durée contre le plafond | En attente — même déclencheur | ROADMAP §Later |
| E8 | 19/11-1 règle de chemin vérifiée en session neuve | En attente — Import élagage 2 | ROADMAP §Later |
| E8 | 19/11-2 chiffres importés = hypothèses | Adoptée | Lot 3 · `04 §Contexte` · M-PROC-58 |
| E8 | 19/11-3 `$<chiffre>` dans un skill | Adoptée (contrôle d'ELAG-1b) + K16 dans `13` | Lot 1 |
| E8 | P-20 file unique de remontées | Adaptée (K17 : `docs/`, décisions `M-…`) | Lot 2 · `03`, `09`, `sdlc-init.sh` · M-PROC-61 |
