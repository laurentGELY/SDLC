# Carte des fichiers

Le toolkit est un ensemble de **templates numérotés** (`00` → `12`) plus quelques fichiers propres au projet. Chaque numéro a un rôle et une destination dans le projet cible.

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
| 12 | `12-audit-externe-TEMPLATE.md` | Gabarit d'audit d'un framework tiers | *(guide toolkit, non copié)* |

## Les scripts

Cinq scripts bash à la racine, chacun autonome :

| Script | Rôle |
|--------|------|
| `sdlc-init.sh` | Bootstrap mécanique d'un nouveau projet — lancé depuis la racine du projet cible |
| `sdlc-validate.sh` | Vérifie la cohérence du modèle lui-même (10 contrôles) — lecture seule, exit 0 si tout est ✅ (`M-PROC-40`) |
| `sdlc-delta.sh` | Pré-calcule l'écart de version d'un projet cible pour co-construire le PDR de `/sdlc-sync` (`M-PROC-25`) |
| `sdlc-project-check.sh` | Génère ou met à jour `docs/CLAUDE_PROJECT.md` (fichiers de gouvernance à synchroniser dans Claude.ai) |
| `sdlc-token-usage.sh` | Mesure la consommation de tokens réelle depuis les transcripts Claude Code (`M-PROC-36`) |

### Les 10 contrôles de `sdlc-validate.sh`

| # | Contrôle |
|---|----------|
| C1 | Version `README.md` ↔ dernière entrée `CHANGELOG.md` |
| C2 | En-tête de version sur chaque template |
| C3 | Aucun placeholder résiduel hors fichiers de référence |
| C4 | Parité structurelle template ↔ skill vivant |
| C5 | Parité du schéma JSON du hook, template ↔ hooks actifs |
| C6 | Carte des fichiers : disque ↔ `00-CONTEXT.md` |
| C7 | Unicité des identifiants `M-XXXX-NN` |
| C8 | Syntaxe de tous les scripts shell |
| C9 | Site `docs/` à jour : `meta.json` ↔ `README.md`, `versions.md` (`M-PROC-45`) |
| C10 | Livrables HTML à jour : marqueur de version et carte des templates de `SPEC.html` et `MODE-OPERATOIRE.html` (`M-PROC-46`) |

Le script est un **registre** : ajouter un contrôle = une fonction `check_cN` et une ligne dans `CHECKS=(…)`.

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
