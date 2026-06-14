# CLAUDE_PROJECT — SDLC Toolkit
<!-- Versionné · Mis à jour au bootstrap et à chaque sdlc-sync -->
<!-- Source de vérité pour reconstruire le projet Claude.ai si supprimé -->

## Description du projet Claude.ai
Toolkit de gouvernance SDLC pour projets Claude Code : templates (Claude.md, STANDARDS, wrap-up, PDR, sdlc-sync, retrospective, hooks), scripts (sdlc-init.sh, sdlc-project-check.sh) et registre de décisions. Les sprints SDLC font évoluer ce modèle lui-même selon les invariants définis dans 00-CONTEXT.md. Référence canonique pour tout nouveau projet Claude Code utilisant ce modèle.

## Fichiers synchronisés
| Fichier repo | Rôle dans Claude.ai | Synchronisé |
|-------------|---------------------|-------------|
| `00-CONTEXT.md` | Conscience du projet : carte fichiers + invariants — premier fichier lu | ✓ |
| `07-DECISIONS-SDLC.md` | Registre complet des décisions — référence anti-doublon (49 KB) | ✓ |
| `CHANGELOG.md` | Historique des versions et sprints | ✓ |
| `01-Claude-md-TEMPLATE.md` | Template principal Claude.md des projets cibles | ✓ |
| `02-STANDARDS-TEMPLATE.md` | Template STANDARDS (DoD, tests, observabilité) | ✓ |
| `03-wrap-up-SKILL-TEMPLATE.md` | Skill /wrap-up — procédure de clôture de sprint | ✓ |
| `04-sprint-PDR-TEMPLATE.md` | Template spec de sprint (PDR) | ✓ |
| `06-PDR-bootstrap.md` | Guide opérationnel Sprint 0 | ✓ |

## Fichiers exclus (et raison)
| Fichier | Raison d'exclusion |
|---------|-------------------|
| `doc/SESSION_BRIDGE.md` | Contenu éphémère inter-session — inutile dans Claude.ai |
| `doc/EVO.md` | Notes informelles non structurées — pas de valeur contextuelle |
| `doc/audit-exemple-vs-modele-sdlc.md` | Rapport d'audit ponctuel — obsolète après intégration |
| `doc/MODE-OPERATOIRE.html` | HTML — non chargeable comme Project File |
| `doc/SPEC.html` | HTML — non chargeable comme Project File |
| `bak/sdlc-kit-exportable.md` | Archive/backup — redondant avec les fichiers source |
| `sdlc-init.sh` | Script bash — contexte limité dans Claude.ai, 453 lignes |
| `sdlc-project-check.sh` | Script bash — contenu dans 06-PDR-bootstrap.md |
| `04b-sdlc-sync-SKILL-TEMPLATE.md` | Skill secondaire — consulté ponctuellement |
| `05-ROADMAP-TEMPLATE.md` | Template simple, peu de valeur contextuelle permanente |
| `08-hooks-TEMPLATE.md` | Référence hooks — rarement consulté en session SDLC |
| `09-retrospective-SKILL-TEMPLATE.md` | Skill secondaire — consulté ponctuellement |
| `README.md` | Redondant avec 00-CONTEXT.md pour Claude.ai |

## Dernière vérification : 14/06/2026 · sdlc-project-check.sh
