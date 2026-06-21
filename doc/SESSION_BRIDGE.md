# SESSION_BRIDGE — Contexte inter-session
<!-- Accumulatif · entrée la plus récente en tête · nettoyage conditionnel au wrap-up -->

## [Sprint SDLC-22 — instrumentation conso token réelle] · 2026-06-21
**Commit :** 6dcc1f0
**Bloquants en suspens :** aucun — rétrospective utilisateur "all good" (3 volets).
**Fil fonctionnel :** `sdlc-token-usage.sh` (nouveau, racine) mesure les totaux
input/output/cache depuis les transcripts JSONL et les bucketise par étape via
`.claude/sprint-memory.md`. `03-wrap-up-SKILL-TEMPLATE.md §0c` exécute désormais
`git diff`/`status` directement (fallback testé si échec). `09-retrospective-SKILL-TEMPLATE.md`
porte une `§Étape 7 — Métriques tokens` (M1/M2 statique + appel script). Les deux
skills locaux (`.claude/skills/wrap-up`, `.claude/skills/retrospective`) sont
synchronisés avec les templates dans le même commit (`M-PROC-36`).
**Note de continuité :** `doc/CLAUDE_PROJECT.md` n'a pas de ligne pour
`sdlc-token-usage.sh` (ni pour `sdlc-delta.sh`, gap antérieur) — flag levé à ce
wrap-up, décision de classification (synced/exclu) laissée à l'utilisateur.

## [Sprint SDLC-20 — étiquette HYPOTHÈSE sur tables HALT] · 2026-06-20
**Commit :** 51e29bb
**Bloquants en suspens :** aucun — rétrospective utilisateur "all good" (3 volets).
**Fil fonctionnel :** Les 5 tables de rationalisation HALT (`01-Claude-md-TEMPLATE.md`)
portent désormais l'étiquette `[HYPOTHÈSE — non confirmée, adaptée de Superpowers]`
(contenu inchangé), sauf la table 4a/4b/4c/4d (sourcée M-HOOKS-04) qui reste sans
étiquette. `M-PROC-35` clôt un aller-retour à 3 passages sur ce sujet (contenu sans
étiquette SDLC-19 → squelette vide envisagé et abandonné → étiquette retenue).
`[HOOK_CANDIDATE]` ouvert (`LL-T07`) : élargir le carve-out M-HOOKS-04 à
`sprint-memory.md` lui-même.

## [Sprint SDLC-19 — import-superpowers] · 2026-06-19
**Commit :** ce47424
**Bloquants en suspens :** aucun — rétrospective utilisateur "all good" (3 volets).
**Fil fonctionnel :** `01-Claude-md-TEMPLATE.md` porte désormais 11 paires de
rationalisation sous les 5 HALT + la règle 4a/4b/4c/4d (1 sourcée sur l'incident réel
M-HOOKS-04), un renvoi croisé §Rôle/§Test, et une règle de sélection de modèle sous-agent.
`02-STANDARDS-TEMPLATE.md` reconnaît "Revue" comme type de sprint. SDLC_CANDIDATE #1 (hook
SessionStart) et 2 autres items reclassés dans `doc/ROADMAP.md` (P-20/21/22).

## [Sprint SDLC-18 — fix-hooks-m04] · 2026-06-19
**Commit :** 9f6bc73
**Bloquants en suspens :** aucun — incident d'auto-verrouillage de session survenu et
résolu dans ce même sprint (cf. `07-DECISIONS-SDLC.md M-HOOKS-04`). Un `[SDLC_CANDIDATE]`
différé reste ouvert : résolution de chemin absolu fixe dans `pre-tool-bash.sh` (au lieu
de relative au cwd), à remonter en session Claude.ai dédiée.
**Fil fonctionnel :** Le hook `PreToolUse` extrait le schéma JSON réel (les blocages
`[UNIVERSEL]` étaient silencieusement inopérants depuis SDLC-14, corrigé) et porte
désormais M-HOOKS-04 (garde-fou étape 4a, carve-out Write/Edit) + M-HOOKS-06 (allowlist
Bash lecture seule). `08-hooks-TEMPLATE.md` documente la règle d'isolation des tests de
hook bloquant.

## [Sprint SDLC-17 — audit-superpowers] · 2026-06-19
**Commit :** 135eb24
**Bloquants en suspens :** aucun — LL-T05 reste ⏳ (réflexion en Claude.ai
toujours prévue), enrichi de 3 candidats `[SDLC_CANDIDATE]` concrets
(hook SessionStart, tables de rationalisation, fusion clause
anti-complaisance) dans `doc/AUDIT-EXTERNE-superpowers-vs-sdlc.md §8`
**Fil fonctionnel :** Audit comparatif statique `obra/superpowers` (174k★,
14 skills) vs modèle SDLC produit dans `doc/AUDIT-EXTERNE-superpowers-vs-sdlc.md`
— mapping complet, 4 invariants analysés, recommandations étiquetées.
Zéro fichier de gouvernance modifié ce sprint (sprint Revue, décision
d'import différée à validation humaine).

## [Sprint SDLC-16 — audit-complet] · 2026-06-19
**Commit :** 9f35250
**Bloquants en suspens :** LL-T05 (`doc/LESSONS_LEARNED.md`) — garde-fou
manquant pour `Claude.md §Démarrage` étape 4a (création du fichier spec
avant tout travail) ; HOOK_CANDIDATE et SDLC_CANDIDATE notés en `⏳`,
réflexion approfondie prévue par l'utilisateur en session Claude.ai
dédiée avant toute correction
**Fil fonctionnel :** Les 9 sprints SDLC-07→15 sont audités et confirmés
contre l'état réel du repo (8 ATTEINT, 1 scindé self-bootstrap/rattrapage)
— `doc/LESSONS_LEARNED.md` ne contient plus d'affirmation narrative non
marquée comme telle.

## [Sprint SDLC-05b — gouvernance-observabilite] · 2026-06-14
**Commit :** b3e9f25
**Bloquants en suspens :** aucun
**Fil fonctionnel :** Le toolkit dispose de sdlc-project-check.sh (génère doc/CLAUDE_PROJECT.md versionné), d'une §Observabilité STANDARDS vérifiable par grep (5 Q/R [À REMPLIR]), et d'un champ Volumétrie minimum dans le PDR pour protéger contre les faux positifs niveau A.

## [Sprint SDLC-05a — wrapup-robustesse] · 2026-06-14
**Commit :** 9e94abb
**Bloquants en suspens :** aucun
**Fil fonctionnel :** Le wrap-up produit désormais un verdict d'objectif (ATTEINT/PARTIEL/NON ATTEINT) ancré sur spec + git diff, et persiste le contexte inter-session dans doc/SESSION_BRIDGE.md versionné. Les questions rétrospectives sont contextualisées par les signaux de sprint-memory avant d'être posées.
