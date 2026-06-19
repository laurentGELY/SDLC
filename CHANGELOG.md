# CHANGELOG — SDLC Toolkit

---

## [v1.9+SDLC-16] — 2026-06-19 · Sprint SDLC-16 · Audit complet SDLC-07→15
- **Audit** : verdicts par sprint SDLC-07→15 produits par grep/ls/git diff
  (pas de supposition) — `ATTEINT` confirmé pour SDLC-07→13 et SDLC-15
  (8 sprints), preuve citée pour chacun ; SDLC-14 scindé en 2 volets —
  self-bootstrap `ATTEINT`, "rattrapage 07/08/09" du PDR original confirmé
  non fait mais déjà couvert par `M-PROC-27` (pas un gap ouvert)
- **`07-DECISIONS-SDLC.md`** : M-PROC-29 — audit confirmé, requalification
  narrative actée
- **`doc/LESSONS_LEARNED.md`** : 8 phrases narratives (Sprint SDLC-14, non
  vérifiables depuis git) annotées `(non vérifiable depuis le repo)` en
  place, sur décision explicite de l'utilisateur — aucun retrait, aucune
  confirmation sans preuve · nouveau pattern `LL-T05` (garde-fou
  démarrage 4a manquant), `HOOK_CANDIDATE`/`SDLC_CANDIDATE` notés en `⏳`,
  aucune correction inscrite sur demande explicite de l'utilisateur
  (réflexion prévue en Claude.ai)
- **`specs/Sprints/sprint-SDLC-16-audit-complet.md`** (nouveau, créé
  rétroactivement après l'exécution du sprint)
- **Tests** : grep de validation avant chaque ajout (aucune entrée
  dupliquée — `M-PROC-25/26/27` déjà présents, non réécrits)

**Corrections ajustées vs spec** — fichier spec créé rétroactivement,
après l'exécution du sprint plutôt qu'avant (`Claude.md §Démarrage`
étape 4a sautée, découverte seulement au `/wrap-up`) · pattern `LL-T05`
et candidats associés laissés en décision différée, pas de correction
appliquée ce sprint sur demande explicite de l'utilisateur

---

## [v1.9+SDLC-15] — 2026-06-19 · Sprint SDLC-15 · Première /retrospective
- **`Claude.md`** : nouvelle règle §Analyse — distinguer explicitement la
  taille du « cœur du changement » de la taille de la « gouvernance
  associée » si elles diffèrent (résout l'alerte SD-5, action ⏳ ouverte
  depuis SDLC-11)
- **`07-DECISIONS-SDLC.md`** : M-PROC-27 — backfill historique
  CHANGELOG/DECISIONS pour SDLC-07/08/09 explicitement écarté (`LL-T01`
  clos sans rattrapage)
- **`doc/LESSONS_LEARNED.md`** : index mis à jour (LL-T01 clos, décision
  SDLC-11 actée), entrée Sprint SDLC-15 ajoutée
- **Tests** : grep de validation (voir entrée DECISIONS + index LESSONS_LEARNED)

---

## [v1.9+SDLC-14] — 2026-06-19 · Sprint SDLC-14 · Self-bootstrap + rattrapage gouvernance
- **`Claude.md`**, **`STANDARDS.md`** (nouveaux) : adaptés pour un projet
  de gouvernance de templates (pas de code applicatif)
- **`.claude/skills/{wrap-up,retrospective,diagnostic}/SKILL.md`** (nouveaux)
- **`.claude/hooks/pre-tool-bash.sh`** + **`.claude/settings.json`** (nouveaux,
  blocages universels uniquement)
- **`doc/LESSONS_LEARNED.md`** + **`doc/DIAGNOSTIC_CMDS.md`** (nouveaux,
  8 entrées rétroactives SDLC-07→14)
- **`specs/sprint-template.md`** + **`specs/Sprints/sprint-SDLC-14-self-bootstrap.md`** (nouveaux)
- **`.gitignore`** : ajout `.claude/sprint-memory.md`
- Renuméroté depuis "SDLC-15" — le PDR présupposait un sprint SDLC-14 déjà
  exécuté ; précondition vérifiée, gap confirmé, voir `doc/LESSONS_LEARNED.md`
  (`LL-T04`) et `doc/DIAGNOSTIC_CMDS.md`
- **Tests** : critères d'acceptation vérifiés par grep/diff · smoke test
  hook exit 0 · non-régression confirmée

---

## [v1.9+SDLC-13] — 2026-06-18 · Sprint SDLC-13 · specs/SPEC.md (dogfooding)
- **`specs/SPEC.md`** (nouveau, projet toolkit) : §Vue d'ensemble,
  §Architecture (diagramme de flux), §Modules (vérifié contre l'état réel
  du repo)
- **`00-CONTEXT.md`** : §4 checklist — maintien de `specs/SPEC.md §Modules` ajouté
- **Tests** : N/A (gouvernance uniquement)

---

## [v1.9+SDLC-12] — 2026-06-18 · Sprint SDLC-12 · Phase amont
- **`10-AMONT-TEMPLATE.md`** (nouveau) : instructions Project Claude.ai
  dédié à l'idéation/PRD/architecture — §Brief, §Architecture amont
  (pattern Vérification groupée), §Perspectives, §Passage à Claude Code
- **`00-CONTEXT.md`** : carte des fichiers (ligne 10) + §2 phase amont optionnelle
- **`README.md`** : structure repo + paragraphe découpage amont/aval
- **`07-DECISIONS-SDLC.md`** : M-SCOPE-04 — résout Q1 stratégique, ferme
  explicitement la piste du marqueur de provenance
- **Tests** : N/A (gouvernance uniquement)

---

## [v1.9+SDLC-11] — 2026-06-18 · Sprint SDLC-11 · Skill /help
- **`11-help-SKILL-TEMPLATE.md`** (nouveau) : recap "où on en est / où on
  s'en va / outils disponibles", lecture seule, zéro suggestion
- **`00-CONTEXT.md`** : carte des fichiers — ligne `11` ajoutée
- **`README.md`** : structure repo + tableau skills disponibles mis à jour
- **`06-PDR-bootstrap.md`** : Groupe 3 — ligne `.claude/skills/help/`
- **`07-DECISIONS-SDLC.md`** : M-PROC-26 (M-PROC-25 déjà pris par la
  co-construction PDR SDLC-Sync)
- **Tests** : N/A (gouvernance uniquement)

---

## [v1.9+SDLC-10] — 2026-06-18 · Sprint SDLC-10 · Rangement catalogue BMad
- **`doc/ROADMAP.md`** (créé) : 6 patterns BMad en survol migrés en §Later
  avec déclencheurs (P-08, P-15 à P-19)
- **`specs/Sprints/ANALYSE-BMAD-TACTIQUE.md`** : note de clôture — catalogue
  Spike SDLC-06 clos, 13/19 patterns traités
- **`07-DECISIONS-SDLC.md`** : M-SCOPE-03 — fermeture question "modes
  nommés" (Q4 stratégique)
- **Tests** : N/A (gouvernance uniquement)

---

## [v1.9] — 2026-06-14 · Sprint SDLC-05b · Gouvernance & observabilité : CLAUDE_PROJECT, volumétrie, observabilité actionnable

- **`sdlc-project-check.sh`** (nouveau) : inventorie les fichiers de gouvernance, détecte delta vs `doc/CLAUDE_PROJECT.md`, génère le template versionné avec avis Claude
- **`doc/CLAUDE_PROJECT.md`** (nouveau) : template référence généré par le script — source de vérité pour reconstruire le projet Claude.ai
- **`02-STANDARDS-TEMPLATE.md` v1.9** : §Observabilité remplacé par checklist Q/R 5 questions `[À REMPLIR]` · note anti-faux-positif niveau A ajoutée dans §Niveaux de test
- **`04-sprint-PDR-TEMPLATE.md` v1.9** : champ optionnel `Volumétrie minimum` dans §Plan de test
- **`04b-sdlc-sync-SKILL-TEMPLATE.md` v1.9** : §Étape D4 — vérification CLAUDE_PROJECT delta au sdlc-sync
- **`06-PDR-bootstrap.md`** : §Étape 1b `sdlc-project-check.sh` · `doc/CLAUDE_PROJECT.md` carte §Groupe 2 · critère d'acceptation 10 · §Étape 2 grep étendu à `[À REMPLIR]`
- **`07-DECISIONS-SDLC.md`** : M-PROC-23 (volumétrie) · M-PROC-24 (CLAUDE_PROJECT) · M-ARCH-08 (observabilité Q/R)
- **Tests** : bash -n ✓ · smoke test exit 0 ✓ · greps CA 1.1b/1.2/1.3 (5/5) tous verts ✓
- **Corrections ajustées vs spec** — item 1.4 (`01-Claude-md-TEMPLATE.md`) déjà implémenté en 05a, skip · format `[À REMPLIR]` corrigé (format initial "—" ne matchait pas grep, détecté par CA)

## [v1.8] — 2026-06-14 · Sprint SDLC-05a · Wrap-up robustesse : §0e, signaux rétrospectifs, SESSION_BRIDGE, CLAUDE_PROJECT

- **`03-wrap-up-SKILL-TEMPLATE.md` v1.3** : §0a second output signaux rétrospectifs · §Étape 1 référence §0a synthèse · §0e revue objectif (ATTEINT/PARTIEL/NON ATTEINT) · §Étape 3 grep -En enforcement + 2 conditionnels (SESSION_BRIDGE / CLAUDE_PROJECT) · §Étape 5 réécrite SESSION_BRIDGE accumulatif · §Étape 6 réécrite vérification CLAUDE_PROJECT delta
- **`01-Claude-md-TEMPLATE.md` v1.8** : §Démarrage §2 lecture SESSION_BRIDGE · §Règles absolues sprint-memory.md explicité
- **`06-PDR-bootstrap.md`** : doc/SESSION_BRIDGE.md ajouté carte §Groupe 2
- **`07-DECISIONS-SDLC.md`** : M-PROC-19 à M-PROC-22 (revue objectif · signaux rétrospectifs · enforcement specs · SESSION_BRIDGE + CLAUDE_PROJECT)
- **Tests** : greps critères d'acceptation 1.1/1.5/1.6/1.7/1.8 tous verts ✓
- **Corrections ajustées vs spec** — test `grep -c "^## Étape [1-6]"` → 8 résultats (pas 6) : Étape 2b et 3.5 préexistants, attendu de la spec incorrectement calibré · specs/Sprints/ absent dans ce repo (PDR en conversation)

## [v1.7] — 2026-06-11 · Sprint SDLC-04 · Confiance FAIBLE → vérification externe + PostToolUse Option A/B

- **`01-Claude-md-TEMPLATE.md` v1.7** : §Analyse §Demande d'aval — si confiance FAIBLE, recommander explicitement une vérification externe (Oracle ou revue humaine) avant l'aval (M-PROC-18)
- **`08-hooks-TEMPLATE.md` v1.7** : §PostToolUse restructuré en Option A — lint/format ruff (reformulée, ex-M-HOOKS-01) / Option B — nouveau hook `post-commit-changelog.sh` + snippet `settings.json` + smoke test (M-HOOKS-03)
- **`02-STANDARDS-TEMPLATE.md`** : marqueur `SDLC version` v1.5 → v1.7 (paire avec `01-Claude-md-TEMPLATE.md`, cf. M-PROC-09)
- **`07-DECISIONS-SDLC.md`** : M-PROC-18, M-HOOKS-03
- **Tests** : `post-commit-changelog.sh` — `bash -n` OK · 4 scénarios smoke test (non-commit, --amend, commit avec/sans CHANGELOG.md) ✓

---

## [v1.6] — 2026-06-11 · Sprint SDLC-03 · Annotations sprint-memory + Handoff eager/lazy + index retrospective

- **`01-Claude-md-TEMPLATE.md` v1.6** : §Mémoire de sprint — annotation `[CONF: HAUTE/MOY/FAIBLE — raison]` sur ANALYSE (M-PROC-13) · champ `→ alternative :` sur BLOQUANT (M-PROC-14) · `[valide jusqu'à : condition]` sur DÉCISION (M-PROC-15) ; §Démarrage 4c + §Tokens — distinction Handoff chargement immédiat/différé (M-PROC-16)
- **`04-sprint-PDR-TEMPLATE.md` v1.6** : §Handoff scindé en chargement immédiat / chargement différé (M-PROC-16) · nouvelle section §Dépendances — inputs requis / outputs produits (M-ARCH-07)
- **`09-retrospective-SKILL-TEMPLATE.md` v1.6** : §Index des patterns en tableau structuré + §Métriques de rétro + §Requêtes utiles sur l'index (M-PROC-17)
- **`07-DECISIONS-SDLC.md`** : M-PROC-13, M-PROC-14, M-PROC-15, M-PROC-16, M-PROC-17, M-ARCH-07
- **Tests** : N/A (gouvernance uniquement)

---

## [v1.5] — 2026-06-05 · Sprint SDLC-02 · Init sprint spec + mémoire

- **`01-Claude-md-TEMPLATE.md` v1.5** : §Démarrage étape 4 remplacée par séquence 4a/4b/4c/4d — création spec, init mémoire, lecture, plan de dev ; règle absolue ajoutée
- **`02-STANDARDS-TEMPLATE.md` v1.5** : marqueur SDLC v1.4 → v1.5
- **`03-wrap-up-SKILL-TEMPLATE.md`** : §Étape 3 — bloc `specs/Sprints/sprint-N-slug.md` obligatoire ajouté (vérification existence + §Corrections ajustées vs spec)
- **`04-sprint-PDR-TEMPLATE.md`** : §Plan de développement (4d) + §Corrections ajustées vs spec (wrap-up) ajoutés après §Handoff Claude Code
- **`07-DECISIONS-SDLC.md`** : M-PROC-12 — Init sprint : spec + mémoire + plan de développement
- **Tests** : tous les greps de vérification passent ✓

---

## [v1.4] — 2026-06-04 · Sprint SDLC-01 · Modifications spot sed/grep

- **`01-Claude-md-TEMPLATE.md` v1.3** : §Modifications spot sur fichiers existants ajouté
- **`07-DECISIONS-SDLC.md`** : M-PROC-10 (mémoire de sprint) + M-PROC-11 (modifications spot sed/grep)
- **`02-STANDARDS-TEMPLATE.md` v1.4** : marqueur SDLC v1.3 → v1.4
