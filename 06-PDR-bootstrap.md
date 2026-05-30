# Sprint 0 — Bootstrap SDLC dans un nouveau projet
<!-- Template SDLC v1.0 · Guide opérationnel pour Claude Code · Pas un template à adapter -->

**Type :** Doc
**Taille :** M
**Surface :** Tous les fichiers de gouvernance — zéro code métier
**Risque :** Faible

---

## Contexte

Nouveau projet Claude Code démarrant sans infrastructure SDLC.
Ce sprint installe la gouvernance complète (Claude.md, STANDARDS, wrap-up, PDR template,
ROADMAP, DECISIONS, LESSONS_LEARNED) avant le premier sprint métier.

Objectif : Claude Code peut démarrer une session, lire `Claude.md`,
et exécuter `/wrap-up` sans ambiguïté à la fin de ce sprint.

---

## Comportement actuel → cible

- **Actuel :** repo vide ou sans gouvernance formalisée
- **Cible :** 8 fichiers permanents + 3 fichiers de processus en place,
  tous adaptés au nouveau domaine

---

## Portée

**Inclus :** installation et adaptation des fichiers de gouvernance listés ci-dessous
**Exclu :** tout code métier, toute spec fonctionnelle du nouveau projet

---

## Sources disponibles

Les templates sont dans le Projet Claude.ai "Modèle SDLC" (fichiers 01 à 05).
Ils contiennent des placeholders `[entre crochets]` et des marqueurs `[→ ADAPTER]`.

---

## Fichiers à créer — carte complète

### Groupe 1 — Racine du repo

| Destination | Source template | Action |
|-------------|-----------------|--------|
| `Claude.md` | `01-Claude-md-TEMPLATE.md` | **Adapter** : §Rôle · §Démarrage §2 · §Limites bash · §Fichier .env |
| `STANDARDS.md` | `02-STANDARDS-TEMPLATE.md` | **Adapter** : §Carte des étapes (vider) · §Modules partagés (vider) |
| `CHANGELOG.md` | *(créer from scratch)* | **Créer** : header + première entrée Sprint 0 uniquement |

### Groupe 2 — Dossier `doc/`

| Destination | Source template | Action |
|-------------|-----------------|--------|
| `doc/ROADMAP.md` | `05-ROADMAP-TEMPLATE.md` | **Adapter** : placer Sprint 1 en §Now, vider §Next et §Later |
| `doc/DECISIONS.md` | *(créer from scratch)* | **Créer** : header + conventions de préfixes, zéro entrée D-XX |
| `doc/LESSONS_LEARNED.md` | *(créer from scratch)* | **Créer** : §Index vide + format entrée sprint, zéro contenu |
| `doc/DIAGNOSTIC_CMDS.md` | *(créer from scratch)* | **Créer** : header + format, zéro entrée |

### Groupe 3 — Dossier `.claude/skills/`

| Destination | Source template | Action |
|-------------|-----------------|--------|
| `.claude/skills/wrap-up/SKILL.md` | `03-wrap-up-SKILL-TEMPLATE.md` | **Adapter** : §Étape 0b (chemins git) · §Étape 6 (nom projet Claude.ai) · déclencheurs §Étape 3 conditionnels |
| `.claude/skills/retrospective/SKILL.md` | `09-retrospective-SKILL-TEMPLATE.md` | **Copier** tel quel — générique, zéro adaptation |
| `.claude/skills/diagnostic/SKILL.md` | *(créer from scratch)* | **Créer** : liste des commandes de diagnostic du nouveau système |

### Groupe 4 — Dossier `specs/`

| Destination | Source template | Action |
|-------------|-----------------|--------|
| `specs/sprint-template.md` | `04-sprint-PDR-TEMPLATE.md` | **Copier** tel quel — générique, zéro adaptation |
| `specs/SPEC.md` | *(créer from scratch)* | **Créer** : structure vide du nouveau domaine (ne pas copier depuis un autre projet) |
| `specs/Sprints/` | — | **Créer** : dossier vide, accueillera les specs de sprints individuels |

### Groupe 5 — Dossier `scripts/` *(optionnel, si Python)*

| Destination | Source | Action |
|-------------|--------|--------|
| `scripts/gen_dependency_map.sh` | Projet A repo | **Copier** tel quel si Python · adapter le glob si autre langage |

### Groupe 6 — Dossier `.claude/hooks/` *(recommandé dès sprint 0)*

| Destination | Source template | Action |
|-------------|-----------------|--------|
| `.claude/hooks/pre-tool-bash.sh` | `08-hooks-TEMPLATE.md` §1 | **Adapter** : activer les sections `[ACTIVER si…]` pertinentes · chmod +x |
| `.claude/settings.json` | `08-hooks-TEMPLATE.md` §2 | **Copier** tel quel |
| `.claude/settings.local.json` | `08-hooks-TEMPLATE.md` §3 | **Créer** vide · ne pas versionner si chemins absolus personnels |

**Règle :** chaque section activée dans `pre-tool-bash.sh` → entrée `doc/DECISIONS.md` §D-HOOK-XX dans le même commit.

---

## Plan d'exécution (ordre important)

```
Étape 1 — Créer le repo, initialiser git
  git init && git commit --allow-empty -m "chore: init repo"

Étape 2 — Créer la structure des dossiers
  mkdir -p doc specs/Sprints .claude/skills/wrap-up .claude/skills/retrospective .claude/skills/diagnostic scripts

Étape 3 — Copier sans modification
  specs/sprint-template.md  (depuis 04-sprint-PDR-TEMPLATE.md)

Étape 4 — Adapter Claude.md
  Source : 01-Claude-md-TEMPLATE.md
  Modifier : §Rôle · §Démarrage §2 · §Limites bash · §Fichier .env
  Grep de validation : grep -i "\[→ adapter\]\|\[nom du projet\]\|\[description\]" Claude.md
  → zéro résultat attendu

Étape 5 — Adapter STANDARDS.md
  Source : 02-STANDARDS-TEMPLATE.md
  Modifier : vider §Carte des étapes système · vider §Modules partagés
  Grep de validation : grep -i "\[→ adapter\]\|\[nom du projet\]" STANDARDS.md
  → zéro résultat attendu

Étape 6 — Adapter wrap-up SKILL
  Source : 03-wrap-up-SKILL-TEMPLATE.md
  Modifier : §Étape 0b (chemins git du projet) · §Étape 6 (nom projet Claude.ai)
             · §Étape 3 conditionnels (déclencheurs spécifiques au domaine)
  Grep de validation : grep "\[→ ADAPTER\]" .claude/skills/wrap-up/SKILL.md
  → zéro résultat attendu

Étape 7 — Créer les fichiers from scratch
  CHANGELOG.md       : header + entrée [1.0] Sprint 0
  doc/DECISIONS.md   : header + tableau conventions préfixes, zéro entrée D-XX
  doc/ROADMAP.md     : depuis 05-ROADMAP-TEMPLATE.md, Sprint 1 en §Now
  doc/LESSONS_LEARNED.md : §Index vide + format (inclure le champ Hook candidat dans le format)
  doc/DIAGNOSTIC_CMDS.md : header + format, zéro entrée
  specs/SPEC.md      : structure vide du domaine (§1 Vue d'ensemble · §2 Architecture · §3 Modules)
  .claude/skills/diagnostic/SKILL.md : commandes de diagnostic du nouveau système

Étape 7b — Configurer les hooks (depuis 08-hooks-TEMPLATE.md)
  mkdir -p .claude/hooks
  Copier pre-tool-bash.sh depuis §1 du template
  Décider des sections [ACTIVER si…] — documenter chaque choix dans doc/DECISIONS.md §D-HOOK-XX
  chmod +x .claude/hooks/pre-tool-bash.sh
  Copier settings.json depuis §2 du template
  Créer settings.local.json vide depuis §3 du template
  Test smoke : echo '{"tool":"bash","input":{"command":"echo ok"}}' | bash .claude/hooks/pre-tool-bash.sh
  → exit 0 attendu
  Grep de validation : grep "\[ACTIVER" .claude/hooks/pre-tool-bash.sh
  → zéro résultat attendu

Étape 8 — Vérification finale
  (voir §Critères d'acceptation)

Étape 9 — Commit
  git add -A
  git diff --stat HEAD   # vérifier la liste
  git commit -m "chore: bootstrap SDLC v1.0"
```

---

## Critères d'acceptation

- [ ] `Claude.md` : zéro placeholder `[entre crochets]`, §Démarrage exécutable dans le terminal
- [ ] `STANDARDS.md` : §Definition of Done lisible, §Types de sprint présents, §Modules partagés vide
- [ ] `specs/sprint-template.md` : identique au template source 04
- [ ] `.claude/skills/wrap-up/SKILL.md` : étapes 0-6 présentes, chemins git adaptés, §Étape 6 nom projet correct
- [ ] `.claude/skills/retrospective/SKILL.md` : étapes 1-6 présentes, seuils de déclenchement lisibles
- [ ] `doc/ROADMAP.md` : §Now contient Sprint 1, §Next et §Later vides ou pertinents
- [ ] `doc/DECISIONS.md` : header + conventions, zéro entrée D-XX
- [ ] `CHANGELOG.md` : entrée [1.0] Sprint 0 présente avec le bon format
- [ ] `.claude/hooks/pre-tool-bash.sh` : chmod +x · zéro `[ACTIVER` non décidé · test smoke exit 0
- [ ] `.claude/settings.json` : hook PreToolUse Bash déclaré
- [ ] Commit propre : `git diff --stat` montre uniquement les fichiers attendus

---

## Risques

**Placeholders oubliés** — des `[entre crochets]` résiduels dans Claude.md ou STANDARDS.md
→ grep de validation obligatoire à l'étape 4 et 5

**Contamination depuis un projet précédent** — termes spécifiques à un domaine
qui traînent dans les fichiers adaptés
→ grep après chaque fichier adapté avec les termes du projet source

**SPEC.md copiée** — tentation de copier la SPEC d'un projet existant
→ la SPEC est entièrement spécifique au domaine, toujours créer from scratch

**Hooks sur-activés au bootstrap** — activer toutes les sections `[ACTIVER si…]` par précaution
→ n'activer que les contraintes réelles et connues dès sprint 0 · les autres émergent via LESSONS_LEARNED

---

## Format CHANGELOG.md — entrée Sprint 0

```markdown
<!-- VERSION : 1.0 | JJ/MM/AAAA | [Nom du projet] -->

# CHANGELOG

Toutes les modifications notables de ce projet sont documentées ici.
Format : Semantic Versioning adapté aux sprints.

---

## [1.0] — AAAA-MM-JJ · Sprint 0 · Bootstrap SDLC

- **`Claude.md` v1.0** : instructions permanentes Claude Code
- **`STANDARDS.md` v1.0** : Definition of Done · types de sprint · niveaux de test
- **`specs/sprint-template.md`** : template PDR générique
- **`.claude/skills/wrap-up/SKILL.md` v1.0** : procédure clôture sprint
- **`.claude/hooks/pre-tool-bash.sh` v1.0** : hook PreToolUse Bash · sections activées documentées dans DECISIONS.md
- **`.claude/settings.json`** : configuration hooks Claude Code
- **`doc/ROADMAP.md` v1.0** : structure Now/Next/Later
- **`doc/DECISIONS.md` v1.0** : registre décisions architecturales
- **`doc/LESSONS_LEARNED.md`** : registre apprentissages
- **`doc/DIAGNOSTIC_CMDS.md`** : archive commandes diagnostic
- **`specs/SPEC.md`** : structure architecture vide
- **Tests** : N/A (bootstrap doc)
```

---

## Format doc/DECISIONS.md — structure initiale

```markdown
<!-- VERSION : 1.0 | JJ/MM/AAAA | [Nom du projet] -->

# DECISIONS

Registre exhaustif des décisions architecturales du projet.
Format : ID · Décision retenue · Alternative écartée · Justification

---

## Conventions

| Préfixe | Domaine |
|---------|---------|
| D-ARCH  | Architecture globale |
| D-PROC  | Procédures développement |
| D-OBS   | Observabilité |
| [ajouter les préfixes pertinents au domaine] |
```

---

## Handoff Claude Code

**Fichiers à lire en priorité :**
- Ce fichier (06-PDR-bootstrap.md) — guide complet
- `01-Claude-md-TEMPLATE.md` — source principale à adapter
- `02-STANDARDS-TEMPLATE.md` — source principale à adapter
- `03-wrap-up-SKILL-TEMPLATE.md` — source à copier + adapter §Étape 0b · §Étape 6

**Instructions spécifiques :**
- Exécuter le plan en ordre strict (étape 1 → 9)
- Grep de validation après chaque fichier adapté
- Ne pas créer `specs/SPEC.md` depuis un template — structure from scratch
- Un seul commit final après validation des 8 critères d'acceptation
- Reporter dans ce fichier tout écart au plan (§Corrections ajustées)
