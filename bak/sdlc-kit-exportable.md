# SDLC Kit — Gouvernance Claude Code
<!-- Extrait du Projet A · Veille Emploi IA · v1.0 · 29/05/2026 -->
<!-- À adapter au domaine cible — retirer toutes les références pipeline -->

Ce document synthétise les pratiques, templates et fichiers de gouvernance développés
sur ~35 sprints. Il est conçu pour bootstrapper un nouveau projet Claude Code
avec le même niveau de maturité SDLC, sans repartir de zéro.

---

## 1. Fichiers à créer dans le nouveau repo

### Fichiers permanents (source de vérité)

| Fichier | Rôle | Priorité |
|---------|------|----------|
| `Claude.md` | Instructions permanentes Claude Code (règles, workflow, démarrage) | P0 — bootstrap |
| `STANDARDS.md` | Référence technique : observabilité, Definition of Done, types de sprint, niveaux de test | P0 — bootstrap |
| `SPEC.md` (ou `specs/SPEC.md`) | Architecture exhaustive du système — toujours à jour | P0 — dès sprint 1 |
| `DECISIONS.md` | Registre des décisions architecturales (ID · retenu · écarté · raison) | P0 — dès sprint 1 |
| `ROADMAP.md` | Backlog structuré Now/Next/Later avec seuils déclencheurs | P1 — sprint 2 |
| `CHANGELOG.md` | Historique des modifications par sprint | P0 — sprint 1 |
| `LESSONS_LEARNED.md` | Index des patterns + entrées rétrospective | P1 — sprint 3 |

### Fichiers de processus (dans `.claude/` ou `doc/`)

| Fichier | Rôle |
|---------|------|
| `.claude/skills/wrap-up/SKILL.md` | Procédure de clôture de sprint (étapes ordonnées) |
| `.claude/skills/diagnostic/SKILL.md` | Procédure de diagnostic pipeline/bug |
| `specs/sprint-template.md` | Template PDR de sprint |
| `doc/DIAGNOSTIC_CMDS.md` | Archive des commandes ayant résolu des problèmes |

### Fichiers utilitaires

| Fichier | Rôle |
|---------|------|
| `scripts/gen_dependency_map.sh` | Génère `doc/DEPENDENCY_MAP.md` depuis les imports Python |
| `doc/DEPENDENCY_MAP.md` | Table module × importe/importé par (17 modules → adapter) |

---

## 2. Template — `Claude.md`

```markdown
# Claude.md — [Nom du projet] · vX.Y

> Règles permanentes d'exécution du dépôt pour Claude Code.
> Ne modifier que si une contrainte est récurrente sur plusieurs sprints.
> Si une règle n'est pas ici, elle n'existe pas opérationnellement.

---

## Règles absolues

**Ne jamais :**
- écrire du code avant l'aval explicite de l'utilisateur
- sauter l'analyse, même pour un petit fix
- conclure sans preuves observables (logs, sorties, commandes)
- modifier un fichier de config sans noter la valeur précédente
- lancer un refactor hors périmètre sans validation explicite

**Si l'aval n'est pas donné → s'arrêter après l'analyse et attendre.**

---

## Rôle

[Description du rôle de Claude Code dans ce projet.]
L'utilisateur est gestionnaire de produit et de projet technique.

**Source de vérité :** le dépôt git. Restaurer depuis git avant tout patch.

**Référence architecturale :** `specs/SPEC.md` — exhaustive et toujours à jour.
Sprint specs individuels dans `specs/Sprints/`.

**Limites bash :** [lister les limites spécifiques à l'environnement]
Pour toute action hors portée : fournir la commande exacte prête à copier.

---

## Démarrage de session

```bash
# 1. Sync et état dépôt
git pull origin main && git status && git log --oneline -5

# 2. État système
[commandes de vérification spécifiques au projet]

# 3. Lire le sprint spec
cat specs/Sprints/sprint-<N>-<slug>.md
```

Si aucun sprint spec n'est fourni → demander avant d'aller plus loin.
Signaler toute anomalie avant de proposer un patch.

**Classifier le travail :**

| Type | Déclencheur | Flux |
|------|-------------|------|
| **Évolution** | Feature, refactor planifié | Analyse → Aval → Code → Test → `/wrap-up` |
| **Bug** | Régression, comportement inattendu | `/diagnostic` → Fix → Test → `/wrap-up` |
| **Tuning** | Seuils, prompts, paramètres | Mesure avant → Patch → Mesure après → `/wrap-up` |
| **Revue** | Audit, backlog | Lecture → Recommandations → `/wrap-up` |

---

## Tokens

- **Chargement chirurgical** : lire uniquement les fichiers listés dans §Handoff
- **Grep avant lecture** : toujours grep avant de charger un fichier entier
- **Analyse en une passe** : formuler toutes les questions avant de modifier
- **Batching XS/S** : signaler les opportunités de merger des items indépendants

---

## Analyse (obligatoire — tous types sauf Revue)

Toujours partir du code réel, pas d'une hypothèse mémoire.

```
## Compréhension
- Objectif :
- Comportement actuel → cible :
- Périmètre inclus / exclu :

## Fichiers nécessaires
- Obligatoire :
- Utile :

## Données collectées (si Tuning — sinon "N/A")
- Baseline mesurée :
- Observation justifiant la demande :
- Critère de succès mesurable avant/après :

## Analyse d'impact
- Modules touchés :
- Modules partagés concernés (→ niveau B obligatoire) :
- Risques de régression :

## Plan d'exécution
1.
2.

## Plan de test
- A — Ciblé : <commande exacte>
- B — Non-régression : <ce qui ne doit pas changer>
- C — Intégration : [si risque élevé]

## Demande d'aval
Résumé 3 lignes · fichiers à modifier · tests prévus
→ J'attends ton aval explicite avant de coder.
```

---

## Code

**Commentaires :** chaque bloc logique commenté. Format : `# raison — décision D-XX si applicable`
Ne pas commenter ce que le code dit déjà — commenter pourquoi.
Documenter les pièges connus et les hypothèses non évidentes.

**Validation incrémentale :** tester chaque modification avant la suivante.
Si un test échoue → `/diagnostic` avant de continuer.

**Modules partagés :** toute modification → vérifier les consommateurs avant de coder.

**Éviter :**
- complexité prématurée
- dépendances sans bénéfice net
- logique implicite
- duplication
- refactor hors périmètre

---

## Test

**Définition "test OK" :**
- **A — Ciblé :** commande exacte produit le résultat attendu, pas d'erreur.
- **B — Non-régression :** modules non touchés se comportent comme avant.
- **C — Intégration :** run complet du système produit un output valide.

Si résultat ambigu → documenter l'observation et demander aval avant de décider.

Si tests OK → `/wrap-up`. Si bug → `/diagnostic`.

---

## Wrap-up et amélioration continue

**`/wrap-up`** — clôture de sprint :
- Question rétrospective avec avis éclairé (lit l'index LL)
- Entrée Lessons Learned (5 lignes)
- CHANGELOG + ROADMAP obligatoires, DECISIONS/SPEC/etc. conditionnels
- Bloc "Corrections ajustées vs spec" dans CHANGELOG si ≥ 1 correction ajustée
- Commit git conforme

**`/retrospective`** — analyse patterns (toutes les ~5 sprints ou sur incident) :
- Lecture index + entrées récentes
- Détection récurrences, aggravations, succès
- Propositions d'actions avec destination
- Validation humaine avant commit

**Avant tout commit :** vérifier la DoD (STANDARDS.md §Definition of Done).
`git diff --stat` — fichiers attendus uniquement.

---

## Priorités d'architecture

Justesse → robustesse → maintenabilité → observabilité → performance.

**Arbitrage :** si deux priorités s'affrontent → expliciter le compromis et demander aval.

Toujours expliciter : solution retenue · alternative écartée · dette créée.
```

---

## 3. Template — `STANDARDS.md`

```markdown
# STANDARDS.md — [Nom du projet] · vX.Y

> Référence technique permanente du dépôt.
> Complémentaire à `Claude.md` — ne contient pas de workflow de sprint.
> Mettre à jour dans le même commit que tout changement architectural.

---

## Definition of Done

### Livrable
- Critères d'acceptation de la spec : passés ou N/A justifié
- Aucun fichier hors portée dans le diff (`git diff --stat`)
- Tests exécutés et passés, ou N/A justifié

### Clôture
- `/wrap-up` terminé (Lessons Learned + CHANGELOG + ROADMAP + commit)
- Commit conforme : `type(module): résumé court` + liste de changements + résultat tests

---

## Types de sprint

| Type | Description | Output attendu |
|------|-------------|----------------|
| **Feature** | Nouvelle fonctionnalité | Code + tests + doc |
| **Fix** | Correction de bug ou régression | Code corrigé + test non-régression |
| **Tuning** | Seuils, prompts, paramètres | Mesure avant/après + décision DECISIONS.md |
| **Doc** | Documentation, process | Fichiers doc mis à jour, zéro code |
| **Spike** | Investigation bornée dans le temps | Décision dans DECISIONS.md (pas du code) |
| **Dette** | Remboursement dette technique | Code nettoyé + test de non-régression |

**Spike :** output = décision documentée, jamais du code partiel.

---

## Niveaux de test

| Niveau | Quand obligatoire | Forme | Critère OK |
|--------|------------------|-------|------------|
| **1 — Unitaire** | Tout sprint touchant un module core | `pytest tests/ -q` | Zéro erreur |
| **2 — Snapshot** | Sprint L touchant output principal | Vérification structure | Structure attendue présente |
| **3 — Golden set** | Sprint L touchant scoring/extraction | Jeu de données réel | Résultat stable vs baseline |

---

## Modules partagés

[Lister ici les modules importés par ≥ 2 autres modules — à maintenir à jour]

| Module | Importé par |
|--------|-------------|
| [module] | [consommateurs] |

Règle : toute modification d'un module partagé → niveau B obligatoire + mise à jour de cette table.

---

## Observabilité

[Adapter aux besoins du projet]

### Règle fondamentale
Toute nouvelle étape doit émettre :
- Message d'entrée avec identifiant
- Message de fin avec compteur et durée

### Format de log recommandé
```
YYYY-MM-DD HH:MM:SS LEVEL [run_id] module.etape message
```

---

## Règles d'archivage

### doc/DIAGNOSTIC_CMDS.md
Toute commande ayant localisé ou résolu un problème → archivée avant le wrap-up.

Format :
```
## Symptôme : <description>
Date : JJ/MM/AAAA
Commande : <commande exacte>
Résultat observé : <ce qu'on a vu>
Conclusion : <ce que ça a confirmé ou infirmé>
```
```

---

## 4. Template — Sprint PDR (`specs/sprint-template.md`)

```markdown
# Sprint N — Titre
**Type :** Feature | Fix | Tuning | Doc | Spike | Dette
**Taille :** XS | S | M | L
**Surface :** modules concernés
**Risque :** Faible | Moyen | Élevé

## Contexte
Symptôme ou opportunité. Pourquoi maintenant.

## Objectif
Une phrase. Critère de réussite mesurable.

## Comportement actuel → cible
- Actuel :
- Cible :

## Portée
- Inclus :
- Exclu :

## Option retenue — alternatives écartées
- Retenue :
- Écartée(s) : (raison en 1 ligne)
- Sacrifices délibérés :

## Contraintes techniques · produit

## Critères d'acceptation
- [ ] ...

## Risques

## Pre-mortem *(M et L uniquement)*
Si ce sprint échoue, la cause la plus probable est...

---
<!-- FIN PRD — complété par Claude Code en session -->

## Handoff Claude Code
Fichiers à inspecter en priorité :
Instructions spécifiques :
```

---

## 5. Template — `ROADMAP.md` (structure Now/Next/Later)

```markdown
# ROADMAP — [Nom du projet] · vX.Y

## ▶ Now — Sprint actif

| Item | Type | Taille | Statut |
|------|------|--------|--------|
| [description] | Feature/Fix/... | S/M/L | En cours |

**Règle de passage Now → Next :** un seul item actif à la fois.
**Règle de passage Next → Now :** critères d'entrée explicites (bloquants levés, baseline disponible).

---

## ⏭ Next — Prêt à démarrer

| Item | Type | Taille | Débloque | Bloqué par | Déclencheur |
|------|------|--------|----------|------------|-------------|

---

## 🗂 Later — Backlog

| Item | Type | Taille | Débloque | Bloqué par | Déclencheur | Expiration |
|------|------|--------|----------|------------|-------------|------------|

---

## §Seuils métriques déclencheurs
[Définir 2-3 seuils quantitatifs qui font passer un item Later → Next automatiquement]

---

## §Signaux faibles
[Canal informel pour idées non matures — max 5 lignes, critères de passage explicites]

---

## Historique — Sprints complétés

[Un tableau par sprint complété avec items et statuts]
```

---

## 6. Template — `DECISIONS.md`

```markdown
# DECISIONS — [Nom du projet] · vX.Y

Registre exhaustif des décisions architecturales.
Format : ID · Décision retenue · Alternative écartée · Justification

---

## Conventions

| Préfixe | Domaine |
|---------|---------|
| D-ARCH  | Architecture globale |
| D-PROC  | Procédures développement |
| [ajouter les préfixes pertinents au domaine] |

---

## D-ARCH-01 · [Titre de la décision] · (Sprint N · JJ/MM/AAAA)

**Retenu :** [solution choisie]
**Écarté :** [alternative]
**Raison :** [justification en 2-3 lignes]
```

---

## 7. Template — `LESSONS_LEARNED.md`

```markdown
# LESSONS LEARNED — [Nom du projet]

## Index des patterns validés

| ID | Résumé | Sprints observés | Statut |
|----|--------|-----------------|--------|
| P-01 | [description courte] | Sprint N, N+2 | 🟡 Actif |
| P-02 | [description courte] | Sprint N | ✅ Résolu |

---

## Entrées par sprint

### Sprint N — JJ/MM/AAAA — [Titre]

**Code :** [observations techniques]
**Processus :** [observations de processus]
**Lien pattern :** [confirme/infirme P-XX ou "aucun"]
**Action proposée :** [action + destination] → décision : [✅/⏳/❌]

---

## Entrées rétrospective

### Rétrospective — JJ/MM/AAAA — Sprints N à M

**Patterns analysés :** N · **Nouveaux :** N · **Clôturés :** N · **Actions :** N

[Synthèse narrative]
```

---

## 8. Template — `wrap-up/SKILL.md`

```markdown
# Wrap-up SKILL — [Nom du projet] · vX.Y

Procédure de clôture de sprint. Exécuter dans l'ordre.

---

## Étape 1 — Question rétrospective

Lire l'index LESSONS_LEARNED.md §Index.
Poser la question : "Qu'est-ce qui s'est bien ou mal passé dans ce sprint ?"
Attendre la réponse avant de continuer.

---

## Étape 2 — Lessons Learned

Ajouter une entrée dans LESSONS_LEARNED.md §Entrées par sprint.
Format : Code · Processus · Lien pattern · Action proposée.
5 lignes maximum.

## Étape 2b — Corrections ajustées vs spec

Si ≥ 1 correction ajustée par rapport à la spec :
Ajouter un bloc "Corrections ajustées vs spec" dans l'entrée CHANGELOG.
Format : "**Corrections ajustées vs spec** — [description]"

---

## Étape 3 — Mise à jour documentation

**Obligatoire à chaque sprint :**
- `CHANGELOG.md` : nouvelle entrée [version] · date · sprint · titre
- `ROADMAP.md` : sprint complété déplacé en §Historique, §Now mis à jour

**Conditionnels :**
- `DECISIONS.md` : si nouvelle décision architecturale
- `SPEC.md` : si comportement système modifié
- `STANDARDS.md` : si module partagé ajouté/supprimé/renommé → même commit
- `doc/DEPENDENCY_MAP.md` : si module partagé ajouté/supprimé/renommé → même commit

---

## Étape 3.5 — Vérification pré-commit

```bash
git diff --stat          # fichiers attendus uniquement
git status               # rien d'oublié, rien d'en trop
```

Vérifier :
- CHANGELOG version cohérente (+0.1 ou sémantique adaptée)
- ROADMAP sans sprint futur écrasé
- Tests passés (niveau A systématique)

---

## Étape 4 — Commit

Format : `type(module): résumé court`
Corps : liste des changements + résultat des tests.

---

## Étape 5 — Sync fichiers projet Claude.ai

Reminder : "Sync now" Project Files dans Claude.ai Projet A.
```

---

## 9. Bonnes pratiques clés (condensé)

### Avant de coder
- **Inspection préalable systématique** — grep/wc/lecture avant toute hypothèse. Pattern P-02 : zéro rollback quand appliqué.
- **Aval explicite obligatoire** — ne jamais commencer sans confirmation.
- **Spike d'abord** si pas de baseline mesurable pour un Fix/Tuning.

### Pendant
- **Validation incrémentale** — tester après chaque modification, pas en bloc.
- **Périmètre strict** — refactor hors portée = stop + demande d'aval.
- **Modules partagés** — vérifier les consommateurs systématiquement.

### Après
- **Definition of Done non-négociable** — critères d'acceptation + DoD STANDARDS.
- **Corrections ajustées documentées** — toute divergence spec → CHANGELOG.
- **DEPENDENCY_MAP régénéré** si module ajouté/supprimé/renommé.

### Gouvernance
- **Rétrospective toutes les ~5 sprints** ou sur incident — pas de dette de processus.
- **ROADMAP Now/Next/Later** — un seul item actif, seuils déclencheurs explicites.
- **Décisions dans DECISIONS.md** — jamais dans les commentaires ou la mémoire.
- **Spike = décision documentée**, jamais du code partiel.

### Signaux d'alerte
- Hypothèse non vérifiée sur le code réel → grep d'abord.
- Effort disproportionné → challenger le périmètre.
- Pas de critère mesurable → Spike ou reporter.
- Deux priorités en conflit → arbitrage explicite + aval.

---

## 10. Workflow de cadrage (Projet A → adapter au contexte)

Pour les décisions non triviales, alterner deux modes jusqu'à consensus :

**◇ Challenge — diverger**
- Est-ce le vrai problème ou un symptôme ?
- La solution demandée est-elle la plus petite qui délivre l'essentiel ?
- Est-ce le bon moment dans la ROADMAP ?
- Règle : au moins une alternative sérieuse avant de converger.

**◆ Cadrage — converger**
- Option MVP : la plus petite qui délivre l'essentiel.
- Évaluer : effort · valeur · risque de régression · cohérence ROADMAP.
- Nommer ce qu'on sacrifie — et pourquoi c'est acceptable.

**Handoff réussi si les trois questions ont une réponse claire :**
1. Pourquoi maintenant ?
2. Pourquoi cette option ?
3. Comment on sait qu'on a réussi ?

---

*Extrait du Projet A — Veille Emploi IA Montréal · ~35 sprints · mai 2026*
*Retirer les références au pipeline avant usage dans un autre contexte.*

---

## 11. PDR — Bootstrap SDLC dans un nouveau projet

> Cette section est destinée à Claude Code du nouveau projet.
> Elle indique quels fichiers récupérer depuis le Projet A, où ils se trouvent,
> et comment les adapter au nouveau contexte.

---

# Sprint 0 — Bootstrap SDLC
**Type :** Doc
**Taille :** M
**Surface :** Tous les fichiers de gouvernance — zéro code métier
**Risque :** Faible

## Contexte
Nouveau projet Claude Code démarrant sans infrastructure SDLC.
Le Projet A (Veille Emploi IA) a capitalisé ~35 sprints de pratiques
éprouvées : workflow spec→code, Definition of Done, rétrospective,
templates PDR, wrap-up structuré.
L'objectif est de récupérer cette infrastructure générique
et de l'adapter au nouveau domaine en une session, sans repartir de zéro.

## Objectif
Disposer d'un repo avec infrastructure SDLC complète et adaptée
avant le premier sprint métier — critère : Claude Code peut démarrer
une session, lire `Claude.md`, et exécuter `/wrap-up` sans ambiguïté.

## Comportement actuel → cible
- Actuel : repo vide ou sans gouvernance formalisée
- Cible : 8 fichiers permanents + 3 fichiers de processus en place,
  tous adaptés au nouveau domaine (zéro référence pipeline veille emploi)

## Portée
- Inclus : fichiers listés dans §Fichiers source ci-dessous, adaptation au domaine
- Exclu : tout code métier, toute spec fonctionnelle du nouveau projet

---

## Fichiers source — Projet A

> Repo Projet A supposé accessible. Adapter les chemins si nécessaire.
> Lire chaque fichier source, identifier les sections spécifiques au pipeline,
> les remplacer par les placeholders du nouveau domaine.

### Groupe 1 — Fichiers permanents à la racine

| Fichier source (Projet A) | Destination (nouveau projet) | Action |
|---------------------------|------------------------------|--------|
| `Claude.md` | `Claude.md` | Adapter : §Rôle, §Démarrage, §Limites bash, commandes état système |
| `STANDARDS.md` | `STANDARDS.md` | Adapter : §Carte des étapes pipeline → remplacer par carte du nouveau système ; §Modules partagés → vider, remplir au fur et à mesure |
| `CHANGELOG.md` | `CHANGELOG.md` | Réinitialiser : garder uniquement le format header + `## [1.0] — date · Sprint 0 · Bootstrap SDLC` |

### Groupe 2 — Fichiers dans `doc/`

| Fichier source (Projet A) | Destination (nouveau projet) | Action |
|---------------------------|------------------------------|--------|
| `doc/DECISIONS.md` | `doc/DECISIONS.md` | Réinitialiser : garder conventions de préfixes, vider toutes les entrées D-XX |
| `doc/ROADMAP.md` | `doc/ROADMAP.md` | Réinitialiser : garder structure Now/Next/Later, vider le contenu, placer Sprint 1 en §Now |
| `doc/LESSONS_LEARNED.md` | `doc/LESSONS_LEARNED.md` | Réinitialiser : garder §Index vide + format entrée sprint, pas d'entrées Projet A |
| `doc/DIAGNOSTIC_CMDS.md` | `doc/DIAGNOSTIC_CMDS.md` | Réinitialiser : garder le format, vider toutes les entrées |

### Groupe 3 — Fichiers de processus dans `.claude/`

| Fichier source (Projet A) | Destination (nouveau projet) | Action |
|---------------------------|------------------------------|--------|
| `.claude/skills/wrap-up/SKILL.md` | `.claude/skills/wrap-up/SKILL.md` | Adapter : §Étape 2 (commandes état système) ; conserver toutes les étapes telles quelles |
| `.claude/skills/diagnostic/SKILL.md` | `.claude/skills/diagnostic/SKILL.md` | Adapter : commandes spécifiques au nouveau système ; conserver la structure |
| `.claude/hooks/pre-tool-bash.sh` | `.claude/hooks/pre-tool-bash.sh` | Adapter : variables d'environnement critiques du nouveau projet (remplacer `.env` Projet A) |

### Groupe 4 — Templates dans `specs/`

| Fichier source (Projet A) | Destination (nouveau projet) | Action |
|---------------------------|------------------------------|--------|
| `specs/sprint-template.md` | `specs/sprint-template.md` | Copier tel quel — générique, zéro adaptation requise |
| `specs/SPEC.md` | `specs/SPEC.md` | Ne pas copier — créer from scratch pour le nouveau domaine |

### Groupe 5 — Scripts utilitaires

| Fichier source (Projet A) | Destination (nouveau projet) | Action |
|---------------------------|------------------------------|--------|
| `scripts/gen_dependency_map.sh` | `scripts/gen_dependency_map.sh` | Copier tel quel si Python — adapter le glob si autre langage |

---

## Plan d'exécution recommandé

```
1. Créer le repo, initialiser git
2. Copier Groupe 3 (.claude/) et Groupe 4 (sprint-template.md) sans modification
3. Copier Groupe 5 (scripts/) sans modification
4. Copier Claude.md → adapter §Rôle + §Démarrage + §Limites bash
5. Copier STANDARDS.md → vider §Carte pipeline + §Modules partagés
6. Réinitialiser CHANGELOG.md, DECISIONS.md, ROADMAP.md, LESSONS_LEARNED.md
7. Créer specs/SPEC.md vide (structure uniquement)
8. Créer doc/DIAGNOSTIC_CMDS.md vide (format uniquement)
9. Commit : "chore: bootstrap SDLC depuis Projet A"
10. Vérification : Claude Code peut lire Claude.md et exécuter /wrap-up sans blocage
```

## Critères d'acceptation
- [ ] `Claude.md` lisible : zéro référence pipeline veille emploi, §Démarrage exécutable
- [ ] `STANDARDS.md` : §Definition of Done opérationnelle, §Types de sprint présents
- [ ] `specs/sprint-template.md` : copie conforme, utilisable immédiatement
- [ ] `.claude/skills/wrap-up/SKILL.md` : toutes les étapes présentes, §Étape 3 adaptée
- [ ] `CHANGELOG.md` : entrée Sprint 0 créée avec format correct
- [ ] `ROADMAP.md` : structure Now/Next/Later, Sprint 1 en §Now
- [ ] Commit propre : `git diff --stat` montre uniquement les fichiers attendus

## Risques
- **Oubli d'adaptation** : des références au pipeline (scorer.py, phi4-mini, etc.) qui traînent dans Claude.md ou STANDARDS.md → grep `scorer\|phi4\|qwen\|digest\|imap\|crawler` après adaptation
- **SPEC.md vide** : tentation de copier la SPEC Projet A — à résister, elle est entièrement spécifique au pipeline

## Handoff Claude Code
Fichiers à inspecter en priorité :
- `Claude.md` (Projet A) — source principale à adapter
- `STANDARDS.md` (Projet A) — source principale à adapter
- `.claude/skills/wrap-up/SKILL.md` (Projet A) — copier, adapter §Étape 2 uniquement

Instructions spécifiques :
- Lire chaque fichier source en entier avant d'écrire la version adaptée
- Grep de validation après chaque fichier adapté : `grep -i "scorer\|pipeline\|digest\|imap\|crawler\|phi4\|qwen" <fichier>`
- Ne pas adapter `specs/SPEC.md` — la créer from scratch avec la structure vide du nouveau domaine
- Commit final unique après validation des 7 critères d'acceptation
