# SESSION_BRIDGE — Contexte inter-session
<!-- §Actif : ≤ 3 entrées récentes — chargé automatiquement au §Démarrage -->
<!-- §Archive : entrées plus anciennes — chargé sur demande explicite uniquement -->

## §Actif

### [Sprint SDLC-GSD-V2 — Import GSD Vague 2] · 2026-06-25
**Commit :** 0a3f300
**Bloquants en suspens :** aucun
**Fil fonctionnel :** Trois mécanismes Vague 2 livrés : graduation semi-automatique dans /retrospective (scan §Index, ≥ 3 occurrences/5 sprints → 4 destinations), SESSION_BRIDGE hot/cold (§Actif ≤ 3 / §Archive), hypothesis tracking conditionnel Diagnostic/BUG. Templates SDLC à v2.0 — prochaine action P-39 : sync skills installés (.claude/skills/).

### [Sprint SDLC-GSD-V1 — Import GSD Vague 1] · 2026-06-24
**Commit :** c3abfc1
**Bloquants en suspens :** aucun — 6 props livrées, "all good" rétrospective.
**Fil fonctionnel :** 4 templates SDLC enrichis avec patterns GSD (STATELESS HANDOFF dans wrap-up, guidance goal-backward + SPIDR + signaux Taille L dans PDR, Seeds dans ROADMAP, /fast dans Claude.md). Adversarial Review : 0 finding critique, 1 item cosmétique ajouté en P-38 §Later.

### [Sprint SDLC-22 — instrumentation conso token réelle] · 2026-06-21
**Commit :** 6dcc1f0
**Bloquants en suspens :** aucun — rétrospective utilisateur "all good" (3 volets).
**Fil fonctionnel :** `sdlc-token-usage.sh` (nouveau, racine) mesure les totaux input/output/cache depuis les transcripts JSONL. `09-retrospective-SKILL-TEMPLATE.md` porte une `§Étape 7 — Métriques tokens`. Les deux skills locaux synchronisés avec les templates dans le même commit (`M-PROC-36`).

## §Archive

### [Sprint SDLC-20 — étiquette HYPOTHÈSE sur tables HALT] · 2026-06-20
**Commit :** 51e29bb
**Bloquants en suspens :** aucun — rétrospective utilisateur "all good" (3 volets).
**Fil fonctionnel :** Les 5 tables de rationalisation HALT (`01-Claude-md-TEMPLATE.md`) portent désormais l'étiquette `[HYPOTHÈSE — non confirmée, adaptée de Superpowers]`. `M-PROC-35` clôt un aller-retour à 3 passages. `[HOOK_CANDIDATE]` ouvert (`LL-T07`) : élargir le carve-out M-HOOKS-04 à `sprint-memory.md` lui-même.

### [Sprint SDLC-19 — import-superpowers] · 2026-06-19
**Commit :** ce47424
**Bloquants en suspens :** aucun — rétrospective utilisateur "all good" (3 volets).
**Fil fonctionnel :** `01-Claude-md-TEMPLATE.md` porte désormais 11 paires de rationalisation sous les 5 HALT + la règle 4a/4b/4c/4d. `02-STANDARDS-TEMPLATE.md` reconnaît "Revue" comme type de sprint. SDLC_CANDIDATE #1 (hook SessionStart) et 2 autres items reclassés dans `doc/ROADMAP.md` (P-20/21/22).

### [Sprint SDLC-18 — fix-hooks-m04] · 2026-06-19
**Commit :** 9f6bc73
**Bloquants en suspens :** aucun — incident d'auto-verrouillage de session survenu et résolu dans ce même sprint (cf. `07-DECISIONS-SDLC.md M-HOOKS-04`).
**Fil fonctionnel :** Le hook `PreToolUse` extrait le schéma JSON réel (les blocages `[UNIVERSEL]` étaient silencieusement inopérants depuis SDLC-14, corrigé) et porte désormais M-HOOKS-04 (garde-fou étape 4a, carve-out Write/Edit) + M-HOOKS-06 (allowlist Bash lecture seule).

### [Sprint SDLC-17 — audit-superpowers] · 2026-06-19
**Commit :** 135eb24
**Bloquants en suspens :** aucun — LL-T05 reste ⏳ (réflexion en Claude.ai toujours prévue).
**Fil fonctionnel :** Audit comparatif statique `obra/superpowers` (174k★, 14 skills) vs modèle SDLC produit dans `doc/AUDIT-EXTERNE-superpowers-vs-sdlc.md` — mapping complet, 4 invariants analysés, recommandations étiquetées. Zéro fichier de gouvernance modifié ce sprint.

### [Sprint SDLC-16 — audit-complet] · 2026-06-19
**Commit :** 9f35250
**Bloquants en suspens :** LL-T05 — garde-fou manquant pour `Claude.md §Démarrage` étape 4a ; HOOK_CANDIDATE et SDLC_CANDIDATE notés en `⏳`.
**Fil fonctionnel :** Les 9 sprints SDLC-07→15 sont audités et confirmés contre l'état réel du repo (8 ATTEINT, 1 scindé self-bootstrap/rattrapage). `doc/LESSONS_LEARNED.md` ne contient plus d'affirmation narrative non marquée.

### [Sprint SDLC-05b — gouvernance-observabilite] · 2026-06-14
**Commit :** b3e9f25
**Bloquants en suspens :** aucun
**Fil fonctionnel :** Le toolkit dispose de sdlc-project-check.sh (génère doc/CLAUDE_PROJECT.md versionné), d'une §Observabilité STANDARDS vérifiable par grep (5 Q/R [À REMPLIR]), et d'un champ Volumétrie minimum dans le PDR.

### [Sprint SDLC-05a — wrapup-robustesse] · 2026-06-14
**Commit :** 9e94abb
**Bloquants en suspens :** aucun
**Fil fonctionnel :** Le wrap-up produit désormais un verdict d'objectif (ATTEINT/PARTIEL/NON ATTEINT) ancré sur spec + git diff, et persiste le contexte inter-session dans doc/SESSION_BRIDGE.md versionné.
