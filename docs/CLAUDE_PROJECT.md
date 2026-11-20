# CLAUDE_PROJECT — SDLC Toolkit
<!-- Versionné · Mis à jour au bootstrap et à chaque sdlc-sync -->
<!-- Source de vérité pour reconstruire le projet Claude.ai si supprimé -->

## Description du projet Claude.ai
Toolkit de gouvernance SDLC pour projets Claude Code : templates (CLAUDE.md, STANDARDS, wrap-up, PDR, sdlc-sync, retrospective, hooks), scripts (sdlc-init.sh, sdlc-project-check.sh) et registre de décisions. Les sprints SDLC font évoluer ce modèle lui-même selon les invariants définis dans 00-CONTEXT.md. Référence canonique pour tout nouveau projet Claude Code utilisant ce modèle.

## Fichiers synchronisés
| Fichier repo | Rôle dans Claude.ai | Synchronisé |
|-------------|---------------------|-------------|
| `00-CONTEXT.md` | Conscience du projet : carte fichiers + invariants — premier fichier lu | ✓ |
| `07-DECISIONS-SDLC.md` | Registre complet des décisions — référence anti-doublon (49 KB) | ✓ |
| `CHANGELOG.md` | Historique des versions et sprints | ✓ |
| `01-Claude-md-TEMPLATE.md` | Template principal CLAUDE.md des projets cibles | ✓ |
| `02-STANDARDS-TEMPLATE.md` | Template STANDARDS (DoD, tests, observabilité) | ✓ |
| `03-wrap-up-SKILL-TEMPLATE.md` | Skill /wrap-up — procédure de clôture de sprint | ✓ |
| `04-sprint-PDR-TEMPLATE.md` | Template spec de sprint (PDR) | ✓ |
| `06-PDR-bootstrap.md` | Guide opérationnel Sprint 0 | ✓ |
| `13-reprise-SKILL-TEMPLATE.md` | Skill /reprise — format de `.claude/reprise.md` et marqueur `Statut` (`M-PROC-55`) | ✓ |

## Traitement des files de remontées (`M-PROC-61`)
Chaque projet du modèle tient `docs/REMONTEE_SDLC.md` (variante `doc/`). Côté SDLC, en session Claude.ai
de conception ou en sprint : lire la file reçue (entrées et tableau « Remontées en attente »), agréger
dans un PDR, puis rendre un **bilan de report**, une ligne par remontée :
`JJ/MM-N : adoptée (M-…, template X vY) | adaptée (…) | rejetée (raison) | en attente (quoi)`.
Le projet source l'inscrit à sa rétro et retire les remontées traitées. La file d'un projet n'est jamais
copiée dans ce dépôt (public).

## Fichiers exclus (et raison)
| Fichier | Raison d'exclusion |
|---------|-------------------|
| `docs/SESSION_BRIDGE.md` | Contenu éphémère inter-session — inutile dans Claude.ai |
| `docs/EVO.md` | Notes informelles non structurées — pas de valeur contextuelle |
| `specs/Sprints/audit-exemple-vs-modele-sdlc.md` | Rapport d'audit ponctuel — obsolète après intégration (déplacé depuis `docs/` — Sprint SDLC-07) |
| `docs/MODE-OPERATOIRE.html` | HTML — non chargeable comme Project File |
| `docs/SPEC.html` | HTML — non chargeable comme Project File |
| `sdlc-init.sh` | Script bash — contexte limité dans Claude.ai (taille : `wc -l sdlc-init.sh`) |
| `sdlc-project-check.sh` | Script bash — contenu dans 06-PDR-bootstrap.md |
| `sdlc-validate.sh` | Script bash — contexte limité dans Claude.ai, sa spec complète est dans `specs/Sprints/sprint-ECO-1-sdlc-validate.md` |
| `tests/sdlc-validate-test.sh` | Script bash — suite de tests du validateur, spec dans `specs/Sprints/sprint-ECO-7-durcissement-validate.md` |
| `tests/sdlc-init-test.sh` | Script bash — test de bout en bout du bootstrap, spec dans `specs/Sprints/sprint-ELAG-1b-fix-bootstrap.md` |
| `04b-sdlc-sync-SKILL-TEMPLATE.md` | Skill secondaire — consulté ponctuellement |
| `05-ROADMAP-TEMPLATE.md` | Template simple, peu de valeur contextuelle permanente |
| `08-hooks-TEMPLATE.md` | Référence hooks — rarement consulté en session SDLC |
| `09-retrospective-SKILL-TEMPLATE.md` | Skill secondaire — consulté ponctuellement |
| `.claude/reprise.md` | État local des sprints ouverts — non versionné (`.gitignore`), jamais synchronisé |
| `.claude/skills/reprise/SKILL.md` | Copie adaptée de `13` (synchronisé) — redondant dans Claude.ai |
| `README.md` | Redondant avec 00-CONTEXT.md pour Claude.ai |

## Dernière vérification : 02/07/2026 · Sprint SDLC-25 wrap-up
Delta vérifié : aucun nouveau fichier de gouvernance nécessitant une entrée « Fichiers synchronisés » — les fichiers créés ce sprint (`docs/index.html`, `docs/nav.json`, `docs/meta.json`, `docs/pages/*.md`, `docs/README.md`, `docs/.nojekyll`) sont le site public, pas du Project Knowledge (même traitement que `docs/SPEC.html`/`docs/MODE-OPERATOIRE.html`, déjà exclus ci-dessus). Fichiers déjà synchronisés renommés `doc/` → `docs/` : re-synchroniser leur contenu dans Claude.ai ("Sync now").

## Dernière vérification : 02/09/2026 · Sprint ECO-1 wrap-up
Delta vérifié : `sdlc-validate.sh` (nouveau) ajouté aux fichiers exclus ci-dessus (même
traitement que les autres scripts). `specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md` et
`specs/Sprints/sprint-ECO-1-sdlc-validate.md` non ajoutés individuellement — cohérent
avec le fait qu'aucun fichier `specs/Sprints/*.md` individuel n'est listé ici. Fichiers
déjà synchronisés modifiés ce sprint (`00-CONTEXT.md`, `07-DECISIONS-SDLC.md`) :
re-synchroniser leur contenu dans Claude.ai ("Sync now").

## Dernière vérification : 23/09/2026 · Sprint ECO-7 wrap-up
Delta vérifié : `tests/sdlc-validate-test.sh` (nouveau) ajouté aux fichiers exclus ci-dessus
(même traitement que les autres scripts). Fichiers déjà synchronisés modifiés ce sprint
(`07-DECISIONS-SDLC.md`) : re-synchroniser leur contenu dans Claude.ai ("Sync now").

## Dernière vérification : 24/09/2026 · Sprint ECO-8 wrap-up
Delta vérifié : aucun nouveau fichier de gouvernance (seul `specs/Sprints/sprint-ECO-8-suite-dans-wrapup.md`, non listé individuellement). Fichiers déjà synchronisés modifiés ce sprint (`00-CONTEXT.md`, `03-wrap-up-SKILL-TEMPLATE.md`, `07-DECISIONS-SDLC.md`) : re-synchroniser leur contenu dans Claude.ai ("Sync now").

## Dernière vérification : 20/11/2026 · Sprint SDLC-33 wrap-up
Delta vérifié : `13-reprise-SKILL-TEMPLATE.md` (nouveau) ajouté aux fichiers synchronisés ; `.claude/reprise.md` (jamais synchronisé) et `.claude/skills/reprise/SKILL.md` ajoutés aux exclus. Fichiers déjà synchronisés modifiés ce sprint (`00-CONTEXT.md`, `01`, `03`, `04`, `06`, `07-DECISIONS-SDLC.md`, `CHANGELOG.md`) : re-synchroniser leur contenu dans Claude.ai ("Sync now").

## Dernière vérification : 20/11/2026 · Sprint SDLC-34 wrap-up
Delta vérifié : aucun nouveau fichier de gouvernance dans ce dépôt (`docs/REMONTEE_SDLC.md` est créé dans les projets, jamais ici) ; section « Traitement des files de remontées » ajoutée. Fichiers déjà synchronisés modifiés ce sprint (`01`, `02`, `03`, `04`, `06`, `07-DECISIONS-SDLC.md`, `CHANGELOG.md`) : re-synchroniser leur contenu dans Claude.ai ("Sync now").
