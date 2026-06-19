# Sprint SDLC-14 — Bootstrap adapté du projet toolkit + rattrapage gouvernance
<!-- Template SDLC v1.9 · specs/Sprints/sprint-SDLC-14-self-bootstrap.md -->
<!-- Renuméroté depuis "SDLC-15" — voir §Corrections ajustées vs spec -->

**Type :** Doc
**Taille :** L
**Surface :** `Claude.md` · `STANDARDS.md` · `.claude/skills/wrap-up/SKILL.md` ·
`.claude/skills/retrospective/SKILL.md` · `.claude/skills/diagnostic/SKILL.md` ·
`.claude/hooks/pre-tool-bash.sh` · `.claude/settings.json` · `.gitignore` ·
`doc/LESSONS_LEARNED.md` · `doc/DIAGNOSTIC_CMDS.md` · `specs/sprint-template.md`
**Risque :** Faible

---

## Contexte

Le projet toolkit a accumulé 8 sprints (SDLC-06 à SDLC-13) sans appliquer
à lui-même le cycle complet qu'il impose aux projets cibles : pas de
`/wrap-up`, pas de `/retrospective` (seuil de déclenchement `> 5 sprints`
**dépassé**), pas de `doc/LESSONS_LEARNED.md`. SDLC-10 et SDLC-13 ont
commencé le dogfooding (`doc/ROADMAP.md`, `specs/SPEC.md`) sans aller
jusqu'au cycle de sprint complet.

Ce sprint n'est pas un bootstrap générique (`sdlc-init.sh` à l'identique)
— ce projet a déjà des mécanismes propres (`07-DECISIONS-SDLC.md`,
`CHANGELOG.md`, `README.md §Faire évoluer le modèle`) qu'il ne faut pas
dupliquer. Bootstrap **adapté** : réutiliser l'existant, combler les trous
réels.

**Exclusion délibérée, documentée pour ne pas être reproposée plus tard :**
`.claude/skills/sdlc-sync/SKILL.md` n'est pas créé — ce projet est la
source du modèle, il n'y a aucune version externe vers laquelle se
synchroniser. `doc/DECISIONS.md` générique n'est pas créé —
`07-DECISIONS-SDLC.md` en tient lieu.

---

## Objectif

Le projet toolkit dispose du cycle de sprint complet adapté à sa propre
nature (gouvernance de templates, pas de code applicatif) : `Claude.md`,
`STANDARDS.md`, `/wrap-up`, `/retrospective`, `/diagnostic`,
`doc/LESSONS_LEARNED.md` avec 8 entrées rétroactives (SDLC-07 à 14) et un
§Index des patterns initial.

---

## Portée

**Inclus :**
- `Claude.md` (adapté depuis `01-Claude-md-TEMPLATE.md`)
- `STANDARDS.md` (adapté depuis `02-STANDARDS-TEMPLATE.md`)
- `.claude/skills/wrap-up/SKILL.md` (adapté depuis `03-wrap-up-SKILL-TEMPLATE.md`)
- `.claude/skills/retrospective/SKILL.md` (copié depuis
  `09-retrospective-SKILL-TEMPLATE.md` — générique, s'applique tel quel)
- `.claude/skills/diagnostic/SKILL.md` (créé from scratch, léger)
- `.claude/hooks/pre-tool-bash.sh` + `.claude/settings.json` (blocages
  universels uniquement)
- `.gitignore` — ajout `.claude/sprint-memory.md` (Claude.md le déclare
  non versionné, le `.gitignore` ne l'excluait pas encore)
- `doc/LESSONS_LEARNED.md` (nouveau, 8 entrées rétroactives + index)
- `doc/DIAGNOSTIC_CMDS.md` (nouveau)
- `specs/sprint-template.md` (copie de `04-sprint-PDR-TEMPLATE.md`)
- Ce fichier (`specs/Sprints/sprint-SDLC-14-self-bootstrap.md`)

**Exclu :**
- `.claude/skills/sdlc-sync/SKILL.md` — non applicable
- `doc/DECISIONS.md` générique — `07-DECISIONS-SDLC.md` en tient lieu
- `doc/CLAUDE_PROJECT.md` / `sdlc-project-check.sh` — concerne la sync
  Project Files Claude.ai d'un projet *cible*, pas le repo toolkit
- Toute modification des templates `01-12` eux-mêmes
- Backfill historique des entrées CHANGELOG/DECISIONS manquantes pour
  SDLC-07/08/09 (`LL-T01`) — risque de réécrire une séquence de versions
  déjà publiée, hors portée d'un sprint Doc ; reste une action ouverte

---

## Critères d'acceptation

- [x] `Claude.md` existe, `grep "exécutes les PDR de sprint" Claude.md` → présent
- [x] `STANDARDS.md` existe, `grep "N/A — projet de gouvernance" STANDARDS.md` → présent
- [x] `.claude/skills/wrap-up/SKILL.md` existe
- [x] `.claude/skills/retrospective/SKILL.md` existe
- [x] `.claude/skills/diagnostic/SKILL.md` existe
- [x] `ls .claude/skills/sdlc-sync/` → échoue (absence confirmée, exclusion volontaire)
- [x] `.claude/hooks/pre-tool-bash.sh` existe, exécutable (`-x`)
- [x] `echo '{"tool":"bash","input":{"command":"echo ok"}}' | bash .claude/hooks/pre-tool-bash.sh` → exit 0
- [x] `doc/LESSONS_LEARNED.md` existe, `grep -c "^### Sprint SDLC-" doc/LESSONS_LEARNED.md` → `8`
- [x] `grep "LL-T01\|LL-T02\|LL-T03" doc/LESSONS_LEARNED.md` → présent dans l'index
- [x] `specs/sprint-template.md` existe, identique à `04-sprint-PDR-TEMPLATE.md` (`diff` vide)
- [x] `doc/DIAGNOSTIC_CMDS.md` existe
- [x] `git diff --stat 07-DECISIONS-SDLC.md CHANGELOG.md README.md doc/ROADMAP.md specs/SPEC.md` → vide

---

## Corrections ajustées vs spec

- **Renumérotation SDLC-15 → SDLC-14.** Le PDR reçu présupposait qu'un
  sprint SDLC-14 ("Audit et rattrapage gouvernance") avait déjà eu lieu
  et fournissait son contenu rétroactif comme un fait. La vérification
  de précondition demandée par le PDR lui-même (`grep "M-PROC-26\|Rattrapage"
  07-DECISIONS-SDLC.md`) a montré que SDLC-14 n'existe ni en commit, ni
  en CHANGELOG, ni en DECISIONS — le dernier sprint réel est SDLC-13.
  Question posée à l'utilisateur, qui a choisi de renuméroter ce sprint
  en SDLC-14 réel plutôt que d'exécuter tel quel ou d'investiguer plus
  loin. Voir `doc/DIAGNOSTIC_CMDS.md` et `doc/LESSONS_LEARNED.md` (entrée
  SDLC-14, pattern `LL-T04`).
- **`doc/LESSONS_LEARNED.md` §Sprint SDLC-14** réécrit pour décrire ce qui
  s'est réellement passé dans cette session (découverte du gap +
  renumérotation + bootstrap) plutôt que le récit fictif fourni par le
  PDR initial.
- **`LL-T01`** déclaré "Partiellement résolu" (pas "Résolu") : la
  discipline CHANGELOG/DECISIONS est bien restaurée depuis SDLC-10
  (vérifié), mais le backfill des entrées manquantes pour SDLC-07/08/09
  n'a pas été fait dans ce sprint — reste une action ouverte.
- **`.gitignore`** : ajout non listé dans la Surface initiale du PDR —
  `Claude.md §Mémoire de sprint` déclare `.claude/sprint-memory.md`
  "non versionné (gitignore)" mais le fichier `.gitignore` ne l'excluait
  pas. Corrigé dans le même sprint pour cohérence immédiate.
- **Nombre de fichiers créés** : 11 (pas 9 comme indiqué dans le PDR
  initial — décompte du PDR ne correspondait pas à sa propre liste
  `§Surface`, qui en énumère 10 ; +1 pour ce fichier spec lui-même,
  requis par `Claude.md §Démarrage` étape 4a).
