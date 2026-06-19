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

## Symptôme : `git log --follow` signale une création de fichier à une date manifestement fausse
Date : 19/06/2026
Commande : `git log --follow --diff-filter=A --format="%ad %s" -- <fichier>`
puis vérifier avec `git show --stat <commit-suspect> -- <fichier>` (chercher
`new file mode` dans le diff)
Résultat observé : `git log --follow` sur `doc/ROADMAP.md` indiquait une
création à l'"Initial commit" (30/05/2026), alors que le fichier a
réellement été créé en `new file` dans le commit `6fe4f4f` (Sprint
SDLC-10, 19/06/2026) — faux positif de détection de renommage sur un
fichier sans rapport.
Conclusion : ne jamais conclure une date de création depuis `--follow`
seul sur ce repo — toujours confirmer par `git show --stat` (présence de
`new file mode` dans le diff du commit concerné).

## Symptôme : un grep hérité d'un script d'audit ne matche rien sur un chemin attendu
Date : 19/06/2026
Commande : `find . -name "<nom-fichier>"` avant de conclure à une absence
Résultat observé : `grep ... doc/ANALYSE-BMAD.md` ne matchait rien — le
fichier avait été déplacé vers `specs/Sprints/ANALYSE-BMAD.md` dès le
commit `28b2415` (Sprint SDLC-07), bien avant l'écriture du script
d'audit SDLC-16 qui référençait encore l'ancien chemin.
Conclusion : un script d'audit hérité d'un PDR antérieur peut référencer
des chemins obsolètes après un renommage/déplacement de fichier — vérifier
le chemin réel (`find`/`ls`) avant de conclure à une absence de contenu.

## Symptôme : besoin de connaître le schéma JSON réel d'un hook PreToolUse sans pouvoir redémarrer la session
Date : 19/06/2026
Commande : instrumenter temporairement un hook déjà actif (ajouter une ligne
`echo "$INPUT" >> /tmp/capture.jsonl` après la lecture de stdin), déclencher
l'action réelle correspondante, lire le fichier, puis retirer la ligne.
Pour Edit/Write sans hook actif sur ces outils : `grep -o '"name":"Edit"[^}]*"input":{[^}]*}'
<transcript_path>` (chemin fourni dans le payload `PreToolUse` lui-même).
Résultat observé : modifier `.claude/settings.local.json` pour ajouter un
nouveau hook `PreToolUse` en cours de session ne prend jamais effet (testé
sur claude 2.1.183) — les hooks sont lus une seule fois au démarrage de
session, pas relus à chaud.
Conclusion : ne jamais supposer qu'un hook nouvellement déclaré s'applique
sans redémarrage. Pour capturer un schéma sans redémarrer, exploiter un hook
déjà actif (instrumentation temporaire) ou le transcript de session
lui-même (`tool_use` réels, déjà au format API exact).

## Symptôme : un hook PreToolUse Bash bloque sa propre commande de test
Date : 19/06/2026
Commande : écrire le payload JSON de test dans un fichier via `Write`, puis
`cat fichier.json | bash .claude/hooks/pre-tool-bash.sh` — jamais le JSON de
test ni le motif recherché en texte littéral dans la commande Bash elle-même
(ni même dans un commentaire/label `echo` de la même commande composée).
Résultat observé : une commande comme
`echo "test git push --force" && cat test.json | bash hook.sh` est bloquée
par le hook qu'on cherche à tester, car `$CMD` extrait correctement
l'intégralité de la commande composée envoyée par l'outil Bash — y compris
le texte du label, pas seulement le payload JSON visé.
Conclusion : isoler tout texte de test contenant un motif `[UNIVERSEL]`
(`git push --force`, `rm -rf ...`) dans un fichier séparé, jamais dans la
commande Bash qui l'invoque.
