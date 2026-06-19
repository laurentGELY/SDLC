# SESSION_BRIDGE — Contexte inter-session
<!-- Accumulatif · entrée la plus récente en tête · nettoyage conditionnel au wrap-up -->

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
