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

Les templates sont dans le Projet Claude.ai "Modèle SDLC" (fichiers 01 à 09).
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
| `doc/SESSION_BRIDGE.md` | `03-wrap-up-SKILL-TEMPLATE.md` §Étape 5 | **Créé automatiquement** au premier `/wrap-up` — format accumulatif, entrées en tête |

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

## Plan d'exécution — 9 étapes

### Étape 1 — Cloner et préparer

```bash
git clone <sdlc-toolkit-repo> sdlc-toolkit
cd <nouveau-projet>
bash /chemin/vers/sdlc-toolkit/sdlc-init.sh "Nom du projet"
```

### Étape 2 — Vérifier les placeholders résiduels

```bash
grep "\[→ ADAPTER\]\|\[Nom du projet\]" Claude.md STANDARDS.md
# → zéro résultat attendu pour les placeholders mécaniques
```

### Étape 3 — Ouvrir Claude Code et compléter la gouvernance

Prompt à utiliser :

```
Le bootstrap mécanique est fait. Complète la gouvernance :
- §Rôle dans Claude.md
- §Limites bash dans Claude.md
- §Démarrage §2 : commandes d'état du système
- specs/SPEC.md : structure du domaine
- .claude/skills/diagnostic/SKILL.md : commandes de diagnostic
- Sections [ACTIVER si…] dans .claude/hooks/pre-tool-bash.sh
  → décider lesquelles activer
  → documenter chaque choix dans doc/DECISIONS.md §D-HOOK-XX

Grep de validation final :
grep "\[→ ADAPTER\]" Claude.md STANDARDS.md .claude/hooks/pre-tool-bash.sh
→ zéro résultat attendu avant le commit.
```

### Étapes 4-9 — Validation et commit

Voir `doc/MODE-OPERATOIRE.html §Initialiser` pour le détail complet
(vérifications, smoke test du hook, commit final).

---

## Critères d'acceptation (8)

1. `grep "SDLC version" Claude.md STANDARDS.md` → affiche vX.Y
2. `grep "\[→ ADAPTER\]" Claude.md STANDARDS.md` → vide
3. `echo '{"tool":"bash","input":{"command":"echo ok"}}' | bash .claude/hooks/pre-tool-bash.sh` → exit 0
4. `CHANGELOG.md` contient une entrée Sprint 0
5. `doc/ROADMAP.md` contient Sprint 1 en §Now
6. `doc/DECISIONS.md` existe avec header
7. `.claude/skills/wrap-up/SKILL.md` existe
8. `specs/SPEC.md` existe (structure vide du domaine)

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

---

## Mise à jour sur projet existant — Sprint SDLC-Sync

> Ce guide est la référence du skill `/sdlc-sync` (`.claude/skills/sdlc-sync/SKILL.md`).
> Pour l'exécution interactive, lancer `/sdlc-sync` dans Claude Code depuis le projet cible.
> Pour le détail opérationnel humain, voir `doc/MODE-OPERATOIRE.html §Mettre à jour un projet existant`.

### Principe

Les projets antérieurs au modèle SDLC générique ont une gouvernance plus riche en tuning
local mais moins complète structurellement. Ce n'est pas une divergence intentionnelle —
le modèle n'existait pas encore. Le SDLC-Sync apporte les sections manquantes sans écraser
le tuning local. **Le tuning local prime toujours.**

### Détection de version

```bash
grep "SDLC version" Claude.md STANDARDS.md 2>/dev/null || echo "ABSENT"
```

| Résultat | Situation | Approche |
|----------|-----------|----------|
| `<!-- SDLC version : vX.Y -->` | Projet versionné | Delta vX.Y → courant via tableau compatibilité `07-DECISIONS-SDLC.md` |
| `ABSENT` | Projet antérieur au modèle générique | Delta complet depuis zéro — même règle de tri |

### Règle de tri (étape B du skill)

| Situation | Action |
|-----------|--------|
| Section absente, universelle | Ajouter |
| Section absente, conditionnelle | Vérifier la contrainte, ajouter si pertinent |
| Section présente, formulée différemment | Comparer : migrer si bénéfice net, sinon laisser |
| Tuning local sans équivalent SDLC | Laisser intact — noter comme candidat remontée |

### Traçabilité obligatoire

Entrée `D-SYNC-XX` dans `doc/DECISIONS.md` du projet cible :

```markdown
## D-SYNC-01 · Alignement SDLC vX.Y (ou "antérieur") → vZ.W · [date]

Appliqués    : [liste des sections ajoutées/migrées]
Ignorés      : [liste + raison : contrainte absente / non pertinent]
Laissés      : [tuning local conservé + description]
Remontées ?  : [candidats SDLC_CANDIDATE si trouvés]
```

Puis apposer le marqueur dans `Claude.md` et `STANDARDS.md` :
```
<!-- SDLC version : vZ.W · aligné le JJ/MM/AAAA -->
```
