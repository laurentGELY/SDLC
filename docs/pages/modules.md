# Carte des fichiers

Le toolkit est un ensemble de **templates numérotés** (`00` → `11`) plus quelques fichiers propres au projet. Chaque numéro a un rôle et une destination dans le projet cible.

Cette carte est construite depuis l'état réel du repo (`ls *.md`), vérifiée à chaque évolution structurelle (`00-CONTEXT.md §1`).

---

## Les templates

| # | Fichier | Rôle | Destination cible |
|---|---------|------|-------------------|
| 00 | `00-CONTEXT.md` | Contexte Claude.ai — invariants + carte | *(jamais copié)* |
| 01 | `01-Claude-md-TEMPLATE.md` | Règles permanentes d'exécution | `Claude.md` |
| 02 | `02-STANDARDS-TEMPLATE.md` | DoD, types de sprint, niveaux de test | `STANDARDS.md` |
| 03 | `03-wrap-up-SKILL-TEMPLATE.md` | Procédure de clôture de sprint | `.claude/skills/wrap-up/` |
| 04 | `04-sprint-PDR-TEMPLATE.md` | Spec de sprint | `specs/sprint-template.md` |
| 04b | `04b-sdlc-sync-SKILL-TEMPLATE.md` | Skill `/sdlc-sync` | `.claude/skills/sdlc-sync/` |
| 05 | `05-ROADMAP-TEMPLATE.md` | Backlog Now/Next/Later | `docs/ROADMAP.md` |
| 06 | `06-PDR-bootstrap.md` | Guide Sprint 0 | *(référence, non copié)* |
| 07 | `07-DECISIONS-SDLC.md` | Registre des décisions sur le modèle | *(propre au projet)* |
| 08 | `08-hooks-TEMPLATE.md` | Hook PreToolUse Bash + settings | `.claude/hooks/` |
| 09 | `09-retrospective-SKILL-TEMPLATE.md` | Rétrospective + remontées SDLC | `.claude/skills/retrospective/` |
| 10 | `10-AMONT-TEMPLATE.md` | Phase amont Claude.ai | *(Project Knowledge, hors repo)* |
| 11 | `11-help-SKILL-TEMPLATE.md` | Skill `/help` — recap contexte | `.claude/skills/help/` |

## Dépendances entre modules

Certains fichiers en référencent d'autres. Les connaître évite de casser une référence croisée.

| Module | Dépend de | Utilisé par |
|--------|-----------|-------------|
| `01-Claude-md` | `02-STANDARDS` (DoD) | Chaque session |
| `03-wrap-up` | `02` (DoD), `09` (index patterns) | Fin de chaque sprint |
| `04-sprint-PDR` | `10` (si amont utilisé) | Chaque sprint |
| `04b-sdlc-sync` | Tableau de compatibilité `07` | Évolution du modèle |
| `09-retrospective` | `LESSONS_LEARNED.md` du projet | ~5 sprints |
| `11-help` | `sprint-memory`, `ROADMAP`, `Claude.md` | À la demande |

## Les modules partagés

Deux fichiers sont des **registres centraux** — référencés par plusieurs autres. Toute modification de l'un d'eux déclenche un niveau de test B (cohérence des références croisées) dans le même commit :

- **`07-DECISIONS-SDLC.md`** — le registre des décisions structurantes. Voir [Registre des décisions](#decisions).
- **`00-CONTEXT.md`** — la carte des fichiers elle-même.

## Fichiers humains hors Claude.ai

Deux fichiers sont des livrables de lecture humaine, non synchronisés dans Claude.ai (fichiers locaux à ouvrir dans un navigateur) :

- `docs/SPEC.html` — spec fonctionnelle : circuits, invariants, décisions `M-XXXX`.
- `docs/MODE-OPERATOIRE.html` — procédures complètes avec commandes copiables.
