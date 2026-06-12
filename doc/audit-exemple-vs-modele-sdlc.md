# Rapport d'audit croisé — `/exemple` ↔ modèle SDLC
<!-- Sprint Audit ad-hoc · 2026-06-11 · Base anti-doublon : 31 entrées M-XXXX (M-PROC-01→17, M-ARCH-01→07, M-HOOKS-01→02, M-TMPL-01→03, M-SCOPE-01→02) -->
<!-- Propositions : M-TMPL-04, M-TMPL-05, M-TMPL-06 — non appliquées, en attente de validation humaine -->

---

## 1. Contexte et périmètre

**Source auditée :** `exemple/harness-skills/` — repo Harness Skills cloné localement.
Contient les skills Claude Code pour l'intégration Harness.io CI/CD (MCP v2).

**Note :** Ce repo est la **même source** que celle ayant produit M-PROC-13 à 17 et M-ARCH-07 lors
du sprint précédent (les `Raison` de ces décisions citent explicitement `incident-response`,
`deployment-readiness`, `dora-metrics`, `sei-analytics` et l'architecture `harness_describe`).
Le taux de DÉJÀ_COUVERT est donc élevé — attendu.

**Base anti-doublon confirmée :** 31 entrées dans `07-DECISIONS-SDLC.md` (fusionné en pré-sprint).
Prochain ID disponible par préfixe : M-TMPL-04, M-PROC-18, M-ARCH-08, M-HOOKS-03, M-SCOPE-03.

---

## 2. Inventaire des fichiers de gouvernance

| # | Chemin (depuis `exemple/harness-skills/`) | Rôle présumé | Périmètre audit |
|---|------------------------------------------|--------------|-----------------|
| 1 | `CLAUDE.md` | Index Claude Code — skills, conventions, workflows | Niveau 1 racine |
| 2 | `AGENTS.md` | Index agents génériques (sous-ensemble de CLAUDE.md) | Niveau 1 racine |
| 3 | `.github/copilot-instructions.md` | Index GitHub Copilot (même contenu que AGENTS.md) | Niveau 2 |
| 4 | `.cursor/rules/harness.mdc` | Règles Cursor AI (même contenu que CLAUDE.md) | Niveau 2 |
| 5 | `CONTRIBUTING.md` | Standards d'authoring et de contribution des skills | Niveau 1 racine |
| 6 | `README.md` | Documentation publique (catalogue + workflows) | Niveau 1 racine — contenu redondant avec CLAUDE.md |
| 7 | `templates/operation-summary.md` | Contrat de sortie partagé pour les skills | Niveau 2 |
| 8 | `references/scope-establishment.md` | Playbook partagé : établissement du périmètre | Niveau 2 |
| 9 | `references/dependency-check-playbook.md` | Playbook partagé : vérification des dépendances | Niveau 2 |
| 10 | `references/scope-establishment.md` | Playbook partagé : boucle schéma + validation | Niveau 2 |
| 11 | `.github/workflows/validate-skills.yml` | CI GitHub Actions — validation des skills | Niveau 2 |
| 12 | `scripts/validate-skills.sh` | Script de validation (invoqué par CI et pré-PR) | Niveau 2 |

**Observation :** Fichiers 1, 2, 3, 4 ont un contenu identique ou quasi-identique —
il s'agit d'un pattern de distribution multi-agents (une source, plusieurs contextes).
Fichier 6 (README.md) est la version publique de CLAUDE.md, sans information gouvernance supplémentaire.

---

## 3. Tableau de classification complet

| ID | Pattern | Source dans `/exemple` | Catégorie | Conf |
|----|---------|------------------------|-----------|------|
| P-01 | Fichiers de contexte multi-agents (CLAUDE.md + AGENTS.md + copilot-instructions.md + .cursor/rules) | CLAUDE.md, AGENTS.md, .github/copilot-instructions.md, .cursor/rules/harness.mdc | HORS_PÉRIMÈTRE | HAUTE |
| P-02 | Frontmatter YAML obligatoire dans les SKILL.md | CONTRIBUTING.md §Frontmatter Fields | ADOPTER | MOY |
| P-03 | Sections H2 obligatoires dans les SKILL.md (Performance Notes + Troubleshooting) | CONTRIBUTING.md §Required Body Sections | ADOPTER | MOY |
| P-04 | Instructions par phases ordonnées nommées | CONTRIBUTING.md §Authoring Standards Rule 1 | DÉJÀ_COUVERT | HAUTE |
| P-05 | Convention de point d'arrêt nommé dans les étapes | CONTRIBUTING.md §Authoring Standards Rule 2 | ADOPTER | MOY |
| P-06 | Lead with recommendation pour les choix présentés | CONTRIBUTING.md §Authoring Standards Rule 3, references/scope-establishment.md §Prompt Pattern | HORS_PÉRIMÈTRE | MOY |
| P-07 | Établissement du périmètre comme contexte obligatoire avant toute écriture | CONTRIBUTING.md §Authoring Standards Rule 4, references/scope-establishment.md | DÉJÀ_COUVERT | HAUTE |
| P-08 | Arrêt sur dépendance manquante + résumé du graphe vérifié | references/dependency-check-playbook.md §Workflow Steps 4–5 | DÉJÀ_COUVERT | HAUTE |
| P-09 | Découverte de schéma à l'exécution + boucle de validation sur erreur API | references/schema-validation-loop.md, CLAUDE.md §Schema Validation Convention | DÉJÀ_COUVERT | HAUTE |
| P-10 | Contrat de sortie structuré (Risks or follow-ups + Recommended next step) | templates/operation-summary.md | À_SURVEILLER | FAIBLE |
| P-11 | Séparation SKILL.md / references/ pour le contenu volumineux | CONTRIBUTING.md §Reference Files | À_SURVEILLER | FAIBLE |
| P-12 | Script de validation + GitHub Actions CI pour les skills | scripts/validate-skills.sh, .github/workflows/validate-skills.yml | HORS_PÉRIMÈTRE | HAUTE |
| P-13 | Bump de version dans le frontmatter sur toute modification de skill | CONTRIBUTING.md §Modifying an Existing Skill | DÉJÀ_COUVERT | HAUTE |
| P-14 | Contraintes qualité de la description (trigger phrases, quand NE PAS utiliser, < 1024 chars) | CONTRIBUTING.md §Description Guidelines | HORS_PÉRIMÈTRE | MOY |
| P-15 | Ne pas répéter le payload/contenu sauf demande explicite | templates/operation-summary.md §Notes | HORS_PÉRIMÈTRE | HAUTE |
| P-16 | Demander uniquement ce qui manque, ne pas inventer de valeurs par défaut | references/scope-establishment.md Rules 3–5 | DÉJÀ_COUVERT | HAUTE |
| P-17 | Résumer le périmètre avant la première opération mutante | references/scope-establishment.md Rule 4 | DÉJÀ_COUVERT | HAUTE |
| P-18 | Sortie structurée en cas d'échec (remplacer "What changed" par "What blocked") | templates/operation-summary.md §Notes | DÉJÀ_COUVERT | HAUTE |

**Compteurs :** ADOPTER 3 · DÉJÀ_COUVERT 8 · HORS_PÉRIMÈTRE 6 · À_SURVEILLER 2

---

## 4. Détail DÉJÀ_COUVERT

| Pattern | Référence M-XXXX existante |
|---------|---------------------------|
| P-04 — Instructions par phases | M-PROC-01 (PDR opérationnel), M-PROC-12 (séquence 4a→4d) |
| P-07 — Périmètre avant écriture | M-ARCH-07 (§Dépendances), M-PROC-12 (§Plan de développement) |
| P-08 — Stop sur dépendance manquante | M-ARCH-07 (§Dépendances — Inputs requis), M-PROC-14 (BLOQUANT + alternative) |
| P-09 — Schéma à l'exécution + boucle validation | M-PROC-16 (§Handoff eager/lazy — grep-first, read only if confirmed) |
| P-13 — Bump de version sur modification | M-PROC-09 (/sdlc-sync gère l'alignement de version) |
| P-16 — Demander seulement ce qui manque | M-PROC-03 (Auto-exécution sans questions sur information accessible) |
| P-17 — Résumer périmètre avant première écriture | M-PROC-12 (§Plan de développement avec liste des fichiers touchés en 4d) |
| P-18 — Sortie structurée en cas d'échec | M-PROC-14 (BLOQUANT + alternative), M-PROC-10 (entrées BLOQUANT dans sprint-memory.md) |

---

## 5. Détail HORS_PÉRIMÈTRE

**P-01 — Fichiers multi-agents** [CONF: HAUTE]
Le pattern CLAUDE.md + AGENTS.md + copilot-instructions.md + .cursor/rules est une distribution
multi-agents : même contenu, contextes différents (Claude Code, agents génériques, GitHub Copilot,
Cursor). Le modèle SDLC cible exclusivement Claude Code. Adopter ce pattern supposerait d'étendre
la cible à d'autres agents — décision de périmètre, pas d'authoring.

**P-06 — Lead with recommendation** [CONF: MOY]
Le pattern "recommander un chemin en premier quand l'utilisateur doit choisir" est pertinent
dans les Harness skills car ceux-ci présentent des choix réels (quel scope, quelle connecteur).
Les SDLC skills sont prescriptifs et exécutent des séquences fixes — il n'y a pas de choix à
présenter à l'humain pendant l'exécution. Le pattern est déjà capturé au niveau PDR via
§Option retenue / alternatives écartées (M-PROC-01).

**P-12 — Script de validation + CI** [CONF: HAUTE]
harness-skills est un repo public collaboratif : la validation automatisée (frontmatter, sections,
word count) y protège contre les contributions non conformes. Le modèle SDLC est privé,
mono-mainteneur ; le coût de maintenance du script est disproportionné. Le test de non-régression
du modèle SDLC (`git diff --stat -- 00-*.md 01-*.md ...`) remplit le même rôle à l'échelle
appropriée (INV-1).

**P-14 — Contraintes qualité description** [CONF: MOY]
Les Harness skills ont une description machine-readable utilisée pour la découverte (Claude choisit
le skill en matching la description). Les SDLC skills sont invoqués par slash command explicite
(`/wrap-up`, `/sdlc-sync`, `/retrospective`), donc la description n'est pas un vecteur de
découverte. Le `when NOT to use` est partiellement couvert par le contenu procédural des skills.

**P-15 — Ne pas répéter le payload** [CONF: HAUTE]
Instruction de verbosité de réponse — déjà couverte au niveau du system prompt Claude Code
("Your responses should be short and concise"). N'a pas à figurer dans les templates SDLC.

---

## 6. Détail À_SURVEILLER

**P-10 — Contrat de sortie structuré** [CONF: FAIBLE]
*Source :* `templates/operation-summary.md` — 5 sections : Operation, What I confirmed,
What changed, Risks or follow-ups, Recommended next step.

*Pourquoi FAIBLE :* le template `03-wrap-up-SKILL-TEMPLATE.md` n'a été lu que partiellement
(40 premières lignes). Il contient un §Bilan structuré (0d) mais l'existence ou l'absence des
sections "Risks or follow-ups" et "Recommended next step" n'a pas été confirmée. Classer ADOPTER
sans relecture complète violerait la règle ADOPTER ⟺ CONF ≥ MOY.

*Condition pour reclassifier :* lire `03-wrap-up-SKILL-TEMPLATE.md` intégralement dans un sprint
ciblé ; si les sections "Risques / suites" et "Prochaine étape recommandée" sont absentes → ADOPTER
(M-TMPL-07 candidat).

**P-11 — Séparation SKILL.md / references/** [CONF: FAIBLE]
*Source :* `CONTRIBUTING.md §Reference Files` — extraire tableaux volumineux et exemples étendus
vers un sous-dossier `references/` pour garder le SKILL.md concis.

*Pourquoi FAIBLE :* les 3 skills SDLC actuels sont de taille modeste ; la mécanique de chargement
différé est déjà couverte par M-PROC-16 (§Handoff eager/lazy). Le gain d'une structure
`references/` interne aux skills n'est tangible qu'au-delà d'un certain volume. Classer ADOPTER
prématurément créerait de la structure sans bénéfice immédiat.

*Condition pour reclassifier :* un skill SDLC atteint > 300 lignes, ou le §Handoff indique
plusieurs fichiers "lazy" internes à un même skill → ADOPTER (M-ARCH-08 candidat).

---

## 7. Propositions M-XXXX-NN (non appliquées — à valider)

### M-TMPL-04 · Frontmatter YAML dans les SKILL.md du modèle
[CONF: MOY — absence confirmée par grep dans les 3 templates ; bénéfice greppable direct,
surcoût d'authoring faible]

**Retenu :** Ajouter un bloc frontmatter YAML en tête de chaque `SKILL.md` template (03, 04b, 09),
avec les champs suivants :
```yaml
---
name: <nom-kebab-case>
description: >-
  <ce que le skill fait, quand l'invoquer, commande déclenchante>
metadata:
  version: 1.0.0
trigger: /<nom-commande>
---
```

**Écarté :**
- Frontmatter complet à 7 champs Harness (`license`, `metadata.mcp-server`, `compatibility`) :
  inutile pour un usage interne sans dépendance MCP externe
- Conserver uniquement le commentaire HTML actuel (`<!-- Template SDLC v1.X -->`) :
  non exploitable par grep, pas de version indépendante par skill

**Raison :** Issu de `CONTRIBUTING.md §Frontmatter Fields` (harness-skills). Un frontmatter
YAML formel rend chaque skill greppable indépendamment (`grep "^name:" .claude/skills/*/SKILL.md`
pour inventarier les skills déployés sans charger chaque fichier). Le champ `metadata.version`
permet de tracer l'évolution d'un skill sans polluer la version globale du modèle — chaque skill
peut évoluer à son rythme. Le champ `trigger` documente explicitement les commandes entrantes,
rendant le catalogue des skills auditable en une ligne de grep. Cohérent avec INV-2 (tout
comportement implicite devient explicite).

**Fichiers cibles :** `03-wrap-up-SKILL-TEMPLATE.md`, `04b-sdlc-sync-SKILL-TEMPLATE.md`,
`09-retrospective-SKILL-TEMPLATE.md`

---

### M-TMPL-05 · Sections Performance Notes et Troubleshooting dans les SKILL.md
[CONF: MOY — les 2 sections sont absentes des 3 templates (confirmé par grep) ;
les 2 sections Harness existantes (Instructions/Examples) sont HORS_PÉRIMÈTRE pour les skills
procéduraux SDLC]

**Retenu :** Ajouter deux sections H2 en queue de chaque `SKILL.md` template :

- `## Performance Notes` : conditions de timing (quand déclencher, quand différer),
  tradeoffs entre options, pièges d'exécution connus.
- `## Troubleshooting` : cas d'erreur documentés (message d'erreur → cause → résolution).

Conserver la structure `## Étape N` pour les instructions procédurales — NE PAS la remplacer
par `## Instructions`. Les sections `## Examples` et `## Instructions` style Harness sont
HORS_PÉRIMÈTRE pour les skills SDLC (invocation par slash command explicite, pas par matching
de description).

**Écarté :**
- Aligner sur les 4 sections Harness (Instructions / Examples / Performance Notes / Troubleshooting) :
  `## Instructions` et `## Examples` sont inadaptées aux skills procéduraux SDLC où les étapes
  sont le contenu, pas un sous-bloc
- Section `## Examples` : triviale pour des skills à slash command fixe — l'utilisateur sait
  déjà quoi taper

**Raison :** Issu de `CONTRIBUTING.md §Required Body Sections` (harness-skills). `## Performance Notes`
capture les conditions de déclenchement et les tradeoffs que l'auteur du skill connaît mais
l'utilisateur ne voit pas (ex: `/retrospective` → ne pas déclencher si LESSONS_LEARNED absent depuis
< 3 sprints — cette règle existe peut-être en prose mais n'est pas dans une section dédiée).
`## Troubleshooting` matérialise directement la boucle INV-4 (observation terrain → règle permanente)
dans le skill lui-même, complémentant LESSONS_LEARNED. Ces deux sections sont actuellement
absentes de tous les templates SDLC.

**Fichiers cibles :** `03-wrap-up-SKILL-TEMPLATE.md`, `04b-sdlc-sync-SKILL-TEMPLATE.md`,
`09-retrospective-SKILL-TEMPLATE.md`

---

### M-TMPL-06 · Marqueur ⏸ STOP dans les étapes de skill
[CONF: MOY — stop conditions existent en prose ("Confirmer à l'humain, s'arrêter",
"Demander à l'utilisateur de coller...") mais sans marqueur visuel unifié ;
cohérence avec M-TMPL-01 (système de marqueurs visuels déjà établi)]

**Retenu :** Introduire le marqueur inline `⏸ STOP — [condition]` dans les étapes des `SKILL.md`
pour signaler les points où Claude doit attendre une entrée humaine avant de continuer. Usage :

```markdown
## Étape 0c — Ancrer sur git

⏸ STOP — demander à l'utilisateur de coller `git diff --stat HEAD && git status`
avant de continuer (source de vérité primaire pour le bilan).
```

Ce marqueur est **déclaratif** (dans la spec du skill) et **complémentaire** au mécanisme
`BLOQUANT` de `sprint-memory.md` (qui est l'état persisté en session). Un `⏸ STOP` dans la
spec signale à l'humain lisant la procédure où Claude s'arrêtera ; un `BLOQUANT` dans sprint-memory.md
signale à Claude en cours d'exécution que la session est bloquée.

**Écarté :**
- Utiliser uniquement le mécanisme `BLOQUANT` en session : réactif (détecté pendant l'exécution),
  pas déclaratif (invisible lors de la relecture de la spec avant le sprint)
- Marqueur `[STOP]` en texte ASCII : moins immédiatement lisible dans une liste d'étapes numérotées,
  risque de confusion avec les placeholders `[→ ADAPTER]` de M-TMPL-01

**Raison :** Issu de `CONTRIBUTING.md §Authoring Standards Rule 2` (harness-skills) :
*"Be explicit about stop conditions — call out when Claude must ask the user before proceeding,
especially when scope, prerequisites, or destructive actions are unclear."* Les SDLC skills
ont des stop conditions implicites — ex: `sdlc-sync` : *"Aucune modification de fichier sans
validation explicite"* ; `wrap-up` : *"Demander à l'utilisateur de coller le résultat de..."*.
Ces arrêts existent mais ne sont pas signalés visuellement. Le marqueur `⏸ STOP` s'inscrit dans
le système de marqueurs visuels du modèle (`[→ ADAPTER]` de M-TMPL-01, `[CONF: HAUTE/MOY/FAIBLE]`
de M-PROC-13) — il donne une grammaire cohérente pour annoter les points critiques de la procédure.

**Fichiers cibles :** `03-wrap-up-SKILL-TEMPLATE.md`, `04b-sdlc-sync-SKILL-TEMPLATE.md`,
`09-retrospective-SKILL-TEMPLATE.md` (et optionnellement `01-Claude-md-TEMPLATE.md §Démarrage`
pour les points d'arrêt en début de session)

---

## 8. Vérification de non-régression

```bash
git diff --stat -- 00-CONTEXT.md 01-*.md 02-*.md 03-*.md 04-*.md 04b-*.md \
  05-*.md 06-*.md 07-*.md 08-*.md 09-*.md README.md
```

→ Résultat attendu : **vide** (zéro ligne modifiée dans les templates).
*Note : `07-DECISIONS-SDLC.md` a été modifié en pré-sprint (fusion de `07-DECISIONS-SDLC-additions.md`),
action autorisée explicitement avant le lancement de ce sprint. Ce diff est attendu et souhaité.*

---

## 9. Récapitulatif exécutif

**Source :** `exemple/harness-skills/` — repo skills Harness.io (même source que M-PROC-13→17 + M-ARCH-07).
**Patterns analysés :** 18 · **ADOPTER :** 3 · **DÉJÀ_COUVERT :** 8 · **HORS_PÉRIMÈTRE :** 6 · **À_SURVEILLER :** 2

**Propositions prêtes pour un sprint Doc d'application :**
- `M-TMPL-04` — Frontmatter YAML (name, description, metadata.version, trigger) dans les 3 SKILL.md
- `M-TMPL-05` — Sections ## Performance Notes + ## Troubleshooting dans les 3 SKILL.md
- `M-TMPL-06` — Marqueur ⏸ STOP dans les étapes des 3 SKILL.md

**Observation de cohérence :** le taux élevé de DÉJÀ_COUVERT (8/18) confirme que la session
précédente (M-PROC-13→17, M-ARCH-07) avait correctement capturé les patterns structurants de
harness-skills. Les 3 ADOPTER sont tous dans le domaine des **standards d'authoring des SKILL.md**
— un domaine que la session précédente n'avait pas couvert car elle était focalisée sur les
patterns d'exécution (confiance, blocage, session tronquée, dépendances inter-sprints).

**Prochaine étape :** sprint Doc — application de M-TMPL-04/05/06 sur les 3 templates de skill,
après validation humaine des 3 propositions ci-dessus.
