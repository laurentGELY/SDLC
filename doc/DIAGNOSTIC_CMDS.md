# DIAGNOSTIC_CMDS — Projet toolkit SDLC
<!-- Créé Sprint SDLC-14 (self-bootstrap) — voir STANDARDS.md §Règles d'archivage -->

## Symptôme : précondition du PDR présuppose un sprint qui n'existe pas dans le repo
Date : 19/06/2026
Commande : `grep -n "SDLC-14\|Rattrapage" 07-DECISIONS-SDLC.md ; grep -n "SDLC-14" CHANGELOG.md ; git log --oneline --all | head -20`
Résultat observé : zéro occurrence de "SDLC-14" dans `07-DECISIONS-SDLC.md`,
`CHANGELOG.md` ou `git log` — le dernier sprint réel est SDLC-13
(`specs/SPEC.md`, commit `2f303d3`). Le PDR reçu sous le nom "SDLC-15"
présupposait un "Sprint SDLC-14 — Audit et rattrapage gouvernance" déjà
exécuté et fournissait son contenu rétroactif comme un fait acquis.
Conclusion : précondition explicitement demandée par le PDR (§Handoff) a
été vérifiée avant de démarrer plutôt que présumée — gap confirmé.
Décision utilisateur : renumeroter ce sprint en SDLC-14 réel (audit +
rattrapage + bootstrap fusionnés) plutôt que d'écrire une entrée fictive
dans `doc/LESSONS_LEARNED.md`.

## Symptôme : gap de traçabilité (entrées CHANGELOG/DECISIONS manquantes pour des sprints passés)
Date : 19/06/2026
Commande : `grep -n "^## \[" CHANGELOG.md` puis `grep -n "SDLC-0[789]" 07-DECISIONS-SDLC.md`
Résultat observé : `CHANGELOG.md` passe directement de
`[v1.9] — Sprint SDLC-05b` à `[v1.9+SDLC-10]` — aucune entrée dédiée pour
SDLC-07, 08, 09 (SDLC-06 est un Spike, correctement absent de CHANGELOG
par convention §Types de sprint, mais mentionné en bullet dans l'entrée
SDLC-10). `07-DECISIONS-SDLC.md` ne contient aucune entrée dédiée pour
SDLC-07/08/09 (seulement des mentions en passant dans d'autres entrées,
ex. "P-01, SDLC-07").
Conclusion : confirme le pattern `LL-T01` (`doc/LESSONS_LEARNED.md`) — 3
sprints méta sans entrée CHANGELOG/DECISIONS dédiée. Backfill historique
non effectué dans ce sprint (réécrire une séquence de versions déjà
publiée est risqué et hors portée d'un sprint Doc) — reste une action
ouverte, voir `LL-T01`.

## Symptôme : cohérence numérotation des fichiers du modèle
Date : 19/06/2026
Commande : `ls *.md | grep -E "^[0-9]" | sort`
Résultat observé : 12 fichiers `0X-*`/`1X-*` numérotés sans trou ni
doublon (`00-CONTEXT.md` à `11-help-SKILL-TEMPLATE.md`).
Conclusion : aucune incohérence de numérotation au moment du bootstrap
self SDLC-14 — `.claude/skills/diagnostic/SKILL.md` réutilise cette même
commande pour les audits futurs.
