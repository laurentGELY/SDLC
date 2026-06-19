# SDLC Toolkit — Gouvernance Claude Code

Modèle de gouvernance reproductible pour projets pilotés par Claude Code.
Bootstrapper un nouveau projet, aligner un projet existant, faire évoluer le modèle.

**Version courante : v1.9+SDLC-13**

---

## Ce que ça fait concrètement

Un projet gouverné par ce toolkit a :

- Un `Claude.md` qui donne à Claude Code des règles permanentes d'exécution (rôle, limites, workflow)
- Un skill `/wrap-up` qui clôture chaque sprint en 6 étapes (bilan → rétro → doc → commit)
- Un skill `/retrospective` qui détecte les patterns récurrents et propose des hooks ou règles
- Un skill `/sdlc-sync` qui aligne le projet sur une version plus récente du modèle sans écraser le tuning local
- Une boucle de rétroaction terrain : incident → `LESSONS_LEARNED` → `/retrospective` → hook ou règle permanente

**Quatre invariants guident toute évolution :**
- **INV-1 · Vérification exécutable** — tout test = une commande exacte, pas une description
- **INV-2 · Circuit fermé** — toute règle implicite devient explicite (hook, `DECISIONS.md`, ou `Claude.md`)
- **INV-3 · Contexte chirurgical** — Claude charge uniquement les fichiers listés dans `§Handoff`, pas le repo entier
- **INV-4 · Boucle de rétroaction** — toute observation terrain a un chemin vers une règle permanente

**Découpage amont / aval :** l'idéation, le cadrage produit et les
décisions d'architecture se font dans un Project Claude.ai dédié
(`10-AMONT-TEMPLATE.md`) — Claude Code prend le relais à partir du
Sprint 0, seul endroit où la vérité du code peut être vérifiée. Cette
phase amont est optionnelle.

---

## Structure du repo

```
sdlc-toolkit/
├── README.md                        # Ce fichier — pitch + démarrage rapide
├── 00-CONTEXT.md                    # Contexte Claude.ai — invariants + carte des fichiers
├── 01-Claude-md-TEMPLATE.md         # → Claude.md du projet cible
├── 02-STANDARDS-TEMPLATE.md         # → STANDARDS.md du projet cible
├── 03-wrap-up-SKILL-TEMPLATE.md     # → .claude/skills/wrap-up/SKILL.md
├── 04-sprint-PDR-TEMPLATE.md        # → specs/sprint-template.md (copie tel quel)
├── 04b-sdlc-sync-SKILL-TEMPLATE.md  # → .claude/skills/sdlc-sync/SKILL.md
├── 05-ROADMAP-TEMPLATE.md           # → doc/ROADMAP.md
├── 06-PDR-bootstrap.md              # Guide opérationnel Sprint 0 (référence, non copié)
├── 07-DECISIONS-SDLC.md             # Registre des décisions sur le modèle lui-même
├── 08-hooks-TEMPLATE.md             # → .claude/hooks/pre-tool-bash.sh + settings.json
├── 09-retrospective-SKILL-TEMPLATE.md  # → .claude/skills/retrospective/SKILL.md
├── 10-AMONT-TEMPLATE.md             # → Project Knowledge Claude.ai (hors repo)
├── 11-help-SKILL-TEMPLATE.md        # → .claude/skills/help/SKILL.md
├── sdlc-init.sh                     # Point d'entrée bootstrap — à lancer en premier
└── doc/
    ├── SPEC.html                    # Spec fonctionnelle du modèle (ouvrir dans un navigateur)
    └── MODE-OPERATOIRE.html         # Procédures complètes (ouvrir dans un navigateur)
```

---

## Démarrage rapide

### Nouveau projet

```bash
# 1. Cloner le toolkit
git clone <ce-repo> sdlc-toolkit

# 2. Depuis la racine du nouveau projet (git init déjà fait)
bash /chemin/vers/sdlc-toolkit/sdlc-init.sh "Nom du projet"

# 3. Ouvrir Claude Code et compléter la gouvernance
# (§Rôle, §Limites bash, SPEC.md, diagnostic skill)
# → voir le prompt exact dans doc/MODE-OPERATOIRE.html §Initialiser
```

### Projet existant à aligner

```bash
# Détecter la situation
grep "SDLC version" Claude.md STANDARDS.md 2>/dev/null || echo "ABSENT"
```

| Résultat | Action |
|----------|--------|
| Aucun fichier | → `sdlc-init.sh` (nouveau projet) |
| `ABSENT` | → `/sdlc-sync` dans Claude Code (delta complet) |
| `SDLC version : vX.Y` | → `/sdlc-sync` dans Claude Code (delta vX.Y → courant) |
| Version courante | Rien à faire ✓ |

```bash
# Dans Claude Code du projet cible
/sdlc-sync
```

---

## Faire évoluer le modèle

1. Lire `00-CONTEXT.md §Invariants` avant toute modification
2. Modifier le(s) template(s) concerné(s) — mettre à jour le numéro de version dans l'en-tête
3. Documenter la décision dans `07-DECISIONS-SDLC.md` (format `M-XXXX-NN`)
4. Mettre à jour `§Historique des versions` ci-dessous
5. Commit `docs(sdlc): description · vX.Y → vZ.W`

> Après une évolution du modèle, tous les projets avec un marqueur de version antérieur sont candidats à un `/sdlc-sync`. Ce n'est pas automatique — décision humaine au cas par cas.

---

## Référence

### Fichiers créés dans le projet cible

| Source (toolkit) | Destination (projet) | Action au bootstrap |
|------------------|----------------------|---------------------|
| `01-Claude-md-TEMPLATE.md` | `Claude.md` | Adapter §Rôle · §Démarrage · §Limites bash |
| `02-STANDARDS-TEMPLATE.md` | `STANDARDS.md` | Vider §Modules partagés · §Carte des étapes |
| `03-wrap-up-SKILL-TEMPLATE.md` | `.claude/skills/wrap-up/SKILL.md` | Adapter §Étape 0b · §Étape 6 |
| `04-sprint-PDR-TEMPLATE.md` | `specs/sprint-template.md` | Copier tel quel |
| `04b-sdlc-sync-SKILL-TEMPLATE.md` | `.claude/skills/sdlc-sync/SKILL.md` | Copier tel quel |
| `05-ROADMAP-TEMPLATE.md` | `doc/ROADMAP.md` | Sprint 1 en §Now |
| `08-hooks-TEMPLATE.md §1` | `.claude/hooks/pre-tool-bash.sh` | Activer les sections pertinentes · `chmod +x` |
| `08-hooks-TEMPLATE.md §2` | `.claude/settings.json` | Copier tel quel |
| `09-retrospective-SKILL-TEMPLATE.md` | `.claude/skills/retrospective/SKILL.md` | Copier tel quel |
| *(from scratch)* | `CHANGELOG.md` | Header + entrée Sprint 0 |
| *(from scratch)* | `doc/DECISIONS.md` | Header + conventions préfixes |
| *(from scratch)* | `doc/LESSONS_LEARNED.md` | §Index vide + format |
| *(from scratch)* | `doc/DIAGNOSTIC_CMDS.md` | Header + format |
| *(from scratch)* | `specs/SPEC.md` | Structure vide du domaine |
| *(from scratch)* | `.claude/skills/diagnostic/SKILL.md` | Commandes de diagnostic |

### Skills disponibles dans Claude Code

| Commande | Quand | Fréquence |
|----------|-------|-----------|
| `/sdlc-init` | Repo vide — bootstrap complet | Une fois par projet |
| `/sdlc-sync` | Aligner sur une version SDLC plus récente | À chaque évolution du modèle |
| `/wrap-up` | Clôture de sprint | Fin de chaque sprint |
| `/retrospective` | Analyse de patterns sur N sprints | Toutes les ~5 sprints ou après incident |
| `/diagnostic` | Bug ou comportement inattendu | Sur incident |
| `/help` | Recap où on en est / où on va / outils disponibles | À la demande, en reprise de session |

### Types de sprint

| Type | Description | Output attendu |
|------|-------------|----------------|
| Feature | Nouvelle fonctionnalité | Code + tests + doc |
| Fix | Correction de bug ou régression | Code corrigé + test non-régression |
| Tuning | Seuils, prompts, paramètres | Mesure avant/après + `DECISIONS.md` |
| Doc | Documentation, process, SDLC | Fichiers doc mis à jour, zéro code |
| Spike | Investigation bornée dans le temps | Décision dans `DECISIONS.md` (pas de code) |
| Dette | Remboursement dette technique | Code nettoyé + test non-régression |
| SDLC-Sync | Alignement sur version SDLC plus récente | Marqueur version à jour + `D-SYNC-XX` |

---

## Documentation

- `doc/SPEC.html` — spec fonctionnelle du modèle : circuits, invariants, décisions M-XXXX
- `doc/MODE-OPERATOIRE.html` — procédures détaillées avec commandes copiables

Ouvrir directement dans un navigateur (fichiers locaux, non synchronisés dans Claude.ai).

---

## Historique des versions

| Version | Date | Changements principaux |
|---------|------|------------------------|
| v1.0 | 29/05/2026 | Bootstrap initial — 7 fichiers |
| v1.1 | 30/05/2026 | Bilan session (Étape 0 wrap-up) · Auto-exécution · Nettoyage artefacts · DIAGNOSTIC_CMDS obligatoire |
| v1.2 | 30/05/2026 | Hooks template · Boucle rétroaction LESSONS_LEARNED → hook · Given/When/Then PDR · Champ Interdit PDR · Vérification exécutable renforcée · Retrospective skill · Circuit remontée SDLC via [SDLC_CANDIDATE] |
| v1.3 | 03/06/2026 | sdlc-sync skill + sprint SDLC-Sync · MODE-OPERATOIRE.html · Mémoire de sprint intra-session |
| v1.4 | 04/06/2026 | Restructuration doc/ : SPEC.html + MODE-OPERATOIRE.html · 00-README.md → 00-CONTEXT.md |
| v1.5 | 05/06/2026 | Init sprint : spec + mémoire + plan de développement — séquence 4a→4d (M-PROC-12) |
| v1.6 | 11/06/2026 | Annotations sprint-memory (CONF/alternative/valide jusqu'à) · Handoff eager/lazy · §Dépendances PDR · index retrospective structuré (M-PROC-13→17, M-ARCH-07) |
| v1.7 | 11/06/2026 | Recommandation vérification externe si CONF FAIBLE · §PostToolUse Option A/B — lint + post-commit-changelog (M-PROC-18, M-HOOKS-03) |
| v1.8 | 14/06/2026 | Sprint SDLC-05a · Wrap-up robustesse : §0e revue objectif sprint, signaux rétrospectifs §0a, SESSION_BRIDGE accumulatif, vérification CLAUDE_PROJECT delta (M-PROC-19→22) |
| v1.9 | 14/06/2026 | Sprint SDLC-05b · CLAUDE_PROJECT versionné (`sdlc-project-check.sh`) · volumétrie minimum §Plan de test · §Observabilité STANDARDS en checklist Q/R actionnable (M-PROC-23/24, M-ARCH-08) |
| v1.9+SDLC-07 | 18/06/2026 | Import patterns BMad tactiques XS — bloc HALT (5 conditions, §Règles absolues), 3 principes anti-biais §Analyse, règle "affirmation citable" §Rôle · réorg `doc/` → `specs/Sprints/` |
| v1.9+SDLC-08 | 18/06/2026 | Import patterns BMad qualité/continuité — modes Index-guidé + seuil délégation sous-agent §Tokens, clause anti-complaisance §Test, reconstruction `sprint-memory.md` perdue · Significant Discovery Alert SD-1→5 (§Étape 2b retrospective) |
| v1.9+SDLC-09 | 18/06/2026 | Import patterns BMad P-04/P-05/P-03 — Adversarial Review 3 couches (§0f wrap-up, Taille M/L), verdict gate PASS/CONCERNS/FAIL (Demande d'aval), grille succès/échec optionnelle PDR taille L · clôture catalogue BMad (Spike SDLC-06) |
| v1.9+SDLC-10 | 18/06/2026 | Rangement catalogue BMad — `doc/ROADMAP.md` créé (6 patterns en survol §Later avec déclencheurs) · M-SCOPE-03 (pas de modes nommés `Claude.md §Rôle`) |
| v1.9+SDLC-11 | 18/06/2026 | Skill `/help` — recap lecture seule (sprint-memory, ROADMAP §Now/§Next, classification `Claude.md`), zéro suggestion (M-PROC-26) |
| v1.9+SDLC-12 | 18/06/2026 | Phase amont — `10-AMONT-TEMPLATE.md`, Project Claude.ai dédié séparé pour idéation/PRD/architecture, zéro marqueur de provenance côté Claude Code (M-SCOPE-04) |
| v1.9+SDLC-13 | 18/06/2026 | `specs/SPEC.md` du toolkit lui-même (dogfooding) — §Vue d'ensemble, §Architecture (diagramme de flux), §Modules vérifié contre l'état réel du repo |
