# SESSION_BRIDGE — Contexte inter-session
<!-- §Actif : ≤ 3 entrées récentes — chargé automatiquement au §Démarrage -->
<!-- §Archive : entrées plus anciennes — chargé sur demande explicite uniquement -->

## §Actif

### [Sprint ECO-1 — sdlc-validate.sh] · 2026-09-02
**Commit :** 720f2be
**Bloquants en suspens :** aucun
**Fil fonctionnel :** `sdlc-validate.sh` (nouveau, racine) vérifie 8 aspects structurels du modèle en registre extensible, appelé à l'Étape 3.5 du wrap-up. 8/8 sur le repo actuel. Adversarial Review a trouvé et corrigé 2 défauts (pré-vol de commandes désaligné, phrase auto-référentielle fausse dans `00-CONTEXT.md`). ECO-2/3/4 débloqués en `docs/ROADMAP.md §Next` (rédaction templates, barre qualité, durcissement PDR — catalogue complet dans `specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md`, 26 patterns). `[SDLC_CANDIDATE]` ouvert : proportion faux positifs/vrais défauts du Blind Hunter délégué à surveiller sur plusieurs sprints.

### [Sprint SDLC-25 — Migration doc/ → docs/ + site de documentation] · 2026-07-02
**Commit :** 831b60d
**Bloquants en suspens :** activation GitHub Pages ("Deploy from branch → main → /docs") — action humaine hors Claude Code, non exécutée
**Fil fonctionnel :** `docs/` remplace `doc/` partout (git mv + sed vérifié), site statique multi-pages prêt à publier (`docs/index.html` + `nav.json`/`meta.json` + 18 pages). Adversarial Review au wrap-up a trouvé et corrigé 6 défauts du bundle livré (historique README falsifié, compte fichiers M-ARCH-09, numérotation sidebar, version/historique du site désynchronisés) + 2 défauts dans `sdlc-init.sh` (bug sed préexistant rendant le bootstrap non fonctionnel depuis l'origine, et un dossier `doc/` résiduel introduit par ce sprint) — les deux corrigés et revalidés. Prochaine action prévue : Sprint ECO-1 (`sdlc-validate.sh`, contrôle exécutable du modèle) déjà en PDR — plusieurs défauts trouvés ici (versions désynchronisées, comptages erronés) sont exactement ceux que ce script vise à automatiser.

### [Sprint SDLC-Audit-GSTACK — Audit externe GSTACK] · 2026-06-25
**Commit :** d857b22
**Bloquants en suspens :** aucun
**Fil fonctionnel :** Audit GSTACK v1.58.4.0 (Garry Tan / YC) — 20 recommandations (4 IMPORTER / 7 INVESTIGUER / 2 MERGER / 7 REJETER). Verdict : adoption sélective, pas d'intégration globale. P-22 déplacé §Later→§Next. Nouveaux items ROADMAP : P-40–P-44 (§Lecture code PDR, §État technique SESSION_BRIDGE, résurgence décisions, rôles §0f, cross-modèle). Prochaine action : P-39 (sync skills) ou P-22 (template audit) ou P-40/P-42 (XS immédiats).

## §Archive

### [Sprint SDLC-GSD-V2 — Import GSD Vague 2] · 2026-06-25
**Commit :** 0a3f300
**Bloquants en suspens :** aucun
**Fil fonctionnel :** Trois mécanismes Vague 2 livrés : graduation semi-automatique dans /retrospective (scan §Index, ≥ 3 occurrences/5 sprints → 4 destinations), SESSION_BRIDGE hot/cold (§Actif ≤ 3 / §Archive), hypothesis tracking conditionnel Diagnostic/BUG. Templates SDLC à v2.0.

### [Sprint SDLC-GSD-V1 — Import GSD Vague 1] · 2026-06-24
**Commit :** c3abfc1
**Bloquants en suspens :** aucun — 6 props livrées, "all good" rétrospective.
**Fil fonctionnel :** 4 templates SDLC enrichis avec patterns GSD (STATELESS HANDOFF dans wrap-up, guidance goal-backward + SPIDR + signaux Taille L dans PDR, Seeds dans ROADMAP, /fast dans Claude.md). Adversarial Review : 0 finding critique, 1 item cosmétique ajouté en P-38 §Later.

### [Sprint SDLC-22 — instrumentation conso token réelle] · 2026-06-21
**Commit :** 6dcc1f0
**Bloquants en suspens :** aucun — rétrospective utilisateur "all good" (3 volets).
**Fil fonctionnel :** `sdlc-token-usage.sh` (nouveau, racine) mesure les totaux input/output/cache depuis les transcripts JSONL. `09-retrospective-SKILL-TEMPLATE.md` porte une `§Étape 7 — Métriques tokens`. Les deux skills locaux synchronisés avec les templates dans le même commit (`M-PROC-36`).

### [Sprint SDLC-20 — étiquette HYPOTHÈSE sur tables HALT] · 2026-06-20
**Commit :** 51e29bb
**Bloquants en suspens :** aucun — rétrospective utilisateur "all good" (3 volets).
**Fil fonctionnel :** Les 5 tables de rationalisation HALT (`01-Claude-md-TEMPLATE.md`) portent désormais l'étiquette `[HYPOTHÈSE — non confirmée, adaptée de Superpowers]`. `M-PROC-35` clôt un aller-retour à 3 passages. `[HOOK_CANDIDATE]` ouvert (`LL-T07`) : élargir le carve-out M-HOOKS-04 à `sprint-memory.md` lui-même.

### [Sprint SDLC-19 — import-superpowers] · 2026-06-19
**Commit :** ce47424
**Bloquants en suspens :** aucun — rétrospective utilisateur "all good" (3 volets).
**Fil fonctionnel :** `01-Claude-md-TEMPLATE.md` porte désormais 11 paires de rationalisation sous les 5 HALT + la règle 4a/4b/4c/4d. `02-STANDARDS-TEMPLATE.md` reconnaît "Revue" comme type de sprint. SDLC_CANDIDATE #1 (hook SessionStart) et 2 autres items reclassés dans `docs/ROADMAP.md` (P-20/21/22).

### [Sprint SDLC-18 — fix-hooks-m04] · 2026-06-19
**Commit :** 9f6bc73
**Bloquants en suspens :** aucun — incident d'auto-verrouillage de session survenu et résolu dans ce même sprint (cf. `07-DECISIONS-SDLC.md M-HOOKS-04`).
**Fil fonctionnel :** Le hook `PreToolUse` extrait le schéma JSON réel (les blocages `[UNIVERSEL]` étaient silencieusement inopérants depuis SDLC-14, corrigé) et porte désormais M-HOOKS-04 (garde-fou étape 4a, carve-out Write/Edit) + M-HOOKS-06 (allowlist Bash lecture seule).

### [Sprint SDLC-17 — audit-superpowers] · 2026-06-19
**Commit :** 135eb24
**Bloquants en suspens :** aucun — LL-T05 reste ⏳ (réflexion en Claude.ai toujours prévue).
**Fil fonctionnel :** Audit comparatif statique `obra/superpowers` (174k★, 14 skills) vs modèle SDLC produit dans `docs/AUDIT-EXTERNE-superpowers-vs-sdlc.md` — mapping complet, 4 invariants analysés, recommandations étiquetées. Zéro fichier de gouvernance modifié ce sprint.

### [Sprint SDLC-16 — audit-complet] · 2026-06-19
**Commit :** 9f35250
**Bloquants en suspens :** LL-T05 — garde-fou manquant pour `Claude.md §Démarrage` étape 4a ; HOOK_CANDIDATE et SDLC_CANDIDATE notés en `⏳`.
**Fil fonctionnel :** Les 9 sprints SDLC-07→15 sont audités et confirmés contre l'état réel du repo (8 ATTEINT, 1 scindé self-bootstrap/rattrapage). `docs/LESSONS_LEARNED.md` ne contient plus d'affirmation narrative non marquée.

### [Sprint SDLC-05b — gouvernance-observabilite] · 2026-06-14
**Commit :** b3e9f25
**Bloquants en suspens :** aucun
**Fil fonctionnel :** Le toolkit dispose de sdlc-project-check.sh (génère docs/CLAUDE_PROJECT.md versionné), d'une §Observabilité STANDARDS vérifiable par grep (5 Q/R [À REMPLIR]), et d'un champ Volumétrie minimum dans le PDR.

### [Sprint SDLC-05a — wrapup-robustesse] · 2026-06-14
**Commit :** 9e94abb
**Bloquants en suspens :** aucun
**Fil fonctionnel :** Le wrap-up produit désormais un verdict d'objectif (ATTEINT/PARTIEL/NON ATTEINT) ancré sur spec + git diff, et persiste le contexte inter-session dans docs/SESSION_BRIDGE.md versionné.
