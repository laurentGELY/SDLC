# Catalogue des templates

Le détail de chaque template numéroté : son rôle, sa destination, et l'adaptation attendue au bootstrap. Pour la vue synthétique et les dépendances, voir [Carte des fichiers](#modules).

---

## 01 · Claude.md

**Règles permanentes d'exécution** → `Claude.md` à la racine.

Le fichier le plus important : rôle de l'agent, règles absolues, conditions `HALT`, séquence de démarrage de session, gestion des tokens, format de la mémoire de sprint, clause anti-complaisance des tests. Au bootstrap, on adapte `§Rôle`, `§Démarrage` et `§Limites bash` au projet. Voir [Garde-fous](#garde-fous).

## 02 · STANDARDS.md

**DoD, types de sprint, niveaux de test** → `STANDARDS.md`. Au bootstrap, on vide `§Modules partagés` et la carte des étapes pour les remplir au fil du projet. Voir [Standards](#standards).

## 03 · wrap-up (skill)

**Procédure de clôture** → `.claude/skills/wrap-up/SKILL.md`. Séquence stricte en 6 étapes. On adapte `§Étape 0b` (référence de session) et `§Étape 6` (sync). Voir [Le skill /wrap-up](#skill-wrapup).

## 04 · sprint-PDR (template)

**Spec de sprint** → `specs/sprint-template.md`, copié tel quel. Structure d'un PDR : objectif, portée, §Handoff (immédiat/différé), plan de développement, plan de test, dépendances, critères d'acceptation, taille.

## 04b · sdlc-sync (skill)

**Alignement de version** → `.claude/skills/sdlc-sync/SKILL.md`, copié tel quel. Voir [/sdlc-sync](#skill-autres).

## 05 · ROADMAP (template)

**Backlog Now/Next/Later** → `docs/ROADMAP.md`. Sprint 1 placé en `§Now` au bootstrap.

## 06 · PDR-bootstrap

**Guide opérationnel du Sprint 0** — référence d'exécution, *non copié* dans le projet. Le plan étape par étape du tout premier sprint.

## 07 · DECISIONS-SDLC

**Registre des décisions sur le modèle lui-même** — propre au projet toolkit. Format `M-XXXX-NN`. Voir [Registre des décisions](#decisions).

## 08 · hooks (template)

**Hook PreToolUse Bash + settings** → `.claude/hooks/` + `settings.json`. Sections activées à la carte. Voir [Hooks](#hooks).

## 09 · retrospective (skill)

**Analyse de patterns + remontées SDLC** → `.claude/skills/retrospective/SKILL.md`, copié tel quel. Voir [Le skill /retrospective](#skill-retro).

## 10 · AMONT (template)

**Instructions de la phase amont** → Project Knowledge Claude.ai dédié, *hors repo cible*. Idéation, PRD, architecture. Voir [Deux surfaces](#deux-surfaces).

## 11 · help (skill)

**Recap contexte, lecture seule** → `.claude/skills/help/SKILL.md`. Zéro suggestion. Voir [/help](#skill-autres).

---

## Créés from scratch au bootstrap

Certains fichiers ne sont pas des copies de template — ils sont générés vides ou avec un simple en-tête, puis remplis au fil du projet :

`CHANGELOG.md` · `docs/DECISIONS.md` · `docs/LESSONS_LEARNED.md` (§Index vide) · `docs/DIAGNOSTIC_CMDS.md` · `specs/SPEC.md` (structure du domaine) · `.claude/skills/diagnostic/SKILL.md`.
