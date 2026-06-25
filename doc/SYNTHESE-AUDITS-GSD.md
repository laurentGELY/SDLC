# Synthèse consolidée — Audits GSD-full et GSD-lite vs Modèle SDLC
<!-- Produit sprint SDLC-Audit-GSD-lite · 24/06/2026 -->
<!-- Basé sur : doc/AUDIT-EXTERNE-gsd-vs-sdlc.md + doc/AUDIT-EXTERNE-gsd-lite-vs-sdlc.md -->

---

## 1. Tableau de statut des propositions A-F (+ G)

| Prop | Libellé court | Statut | Signal GSD-full | Signal GSD-lite | Décision recommandée |
|------|---|---|---|---|---|
| **A** | Agent séparé (sprints L) | **Nuancée** | Prouvé et détaillé (wave parallelism, fresh 200k) | GSD-lite montre qu'inline suffit pour S/M — A doit avoir seuil taille explicite | Adopter, mais restreindre aux sprints **L uniquement** ; mode `--interactive` par défaut |
| **B** | Hook commit-msg atomique | **Confirmée** | gsd-validate-commit.sh enforce atomicité par tâche | Absence totale confirme que SDLC doit combler ce gap seul | Implémenter hook `commit-msg` ou `pre-commit` |
| **C** | Goal-backward dans PDR | **Renforcée** | must_haves.truths — "What must be TRUE?" par tâche | "User Owns Completion" + Echo Before Execute — deux frameworks convergent | Adopter — ajout template PDR (faible effort, fort impact) |
| **D** | Persistance cross-session enrichie | **Renforcée + enrichie** | .planning/ (STATE, ROADMAP, HANDOFF.json) | Journalism Standard + STATELESS HANDOFF = critère qualité manquant à GSD-full | Adopter D enrichi avec Journalism Standard et STATELESS HANDOFF |
| **E1** | Skill /quick structuré | **Renforcée** | /gsd:quick (gsd-planner + gsd-executor, STATE.md) | GSD-lite prouve qu'un protocole inline complet est viable | Envisager après B et C — effort modéré |
| **E2** | Skill /fast inline pur | **Renforcée** | /gsd:fast (inline, < 2 min, zéro overhead) | GSD-lite **est** ce skill — protocole riche, zéro infrastructure | E2 = GSD-lite pattern adapté ; moins complexe que E1 à implémenter |
| **F** | Graduation system (simplifié) | **Nuancée** | Graduation Jaccard complexe, puissant, semi-automatique | HISTORY.md = archivage simple — si GSD-lite se contente de ça, Graduation auto est prématuré | Phase 1 : HISTORY.md pattern (archivage). Phase 2 : Graduation auto (après maturation) |
| **G** | Guidance contexte dans PDR L | **Confirmée** | Context budget tiers documentés (PEAK/GOOD/DEGRADING/POOR) | Absent de GSD-lite (hors scope) | Note légère dans le template PDR L — effort minimal |

---

## 2. Ordre d'implémentation recommandé

### Rationale de classement

Critères : impact sur invariants SDLC × effort d'implémentation × maturité de la proposition (renforcée > confirmée > nuancée).

| Rang | Proposition | Effort | Impact | Justification |
|------|---|---|---|---|
| **1er** | **C** — Goal-backward verification | Faible | INV-1 renforcé | Un ajout de section dans le template PDR. Deux frameworks convergent — signal fort. |
| **2ème** | **D** — SESSION_BRIDGE enrichi + Journalism Standard | Faible | INV-3 renforcé | Enrichissement du template SESSION_BRIDGE + critère de qualité STATELESS HANDOFF. GSD-lite apporte le critère manquant. |
| **3ème** | **B** — Hook commit-msg | Modéré | INV-2 renforcé techniquement | Script shell + hook git. Enforcement technique vs procédural actuel. |
| **4ème** | **E2** — Skill /fast inline pur | Modéré | Couverture tâches XS | GSD-lite = preuve de concept. Adapter le protocole Driver/Navigator + Journalism Standard en skill SDLC. |
| **5ème** | **G** — Guidance contexte PDR L | Minimal | INV-3 marginal | Note courte dans le template. Effort < 1h. Peut être combiné avec rang 1. |
| **6ème** | **A** — Agent séparé (sprints L) | Élevé | Perf sprints L | Réservé aux sprints L. Architecture sous-agents à tester en conditions réelles d'abord. |
| **7ème** | **E1** — Skill /quick structuré | Élevé | Tâches hors-sprint tracées | Plus complexe que E2. À envisager après validation d'E2. |
| **8ème** | **F-phase1** — HISTORY.md archivage | Faible | INV-4 partiel | Simple ajout de template. Peu de valeur seul — à combiner avec wrap-up enrichi. |
| **Différé** | **F-phase2** — Graduation automatique | Très élevé | INV-4 semi-auto | Après au moins 10 sprints documentés dans LESSONS_LEARNED. |

---

## 3. Ce que GSD-lite change vs GSD-full seul

**3.1 Propositions renforcées grâce à GSD-lite :**
- **C** passe de "confirmée" à "renforcée" — deux frameworks indépendants convergent sur le même principe
- **D** est enrichie — Journalism Standard + STATELESS HANDOFF sont des apports GSD-lite absents de GSD-full
- **E2** est crédibilisée — GSD-lite **est** un mode inline complet, preuve de viabilité

**3.2 Propositions nuancées grâce à GSD-lite :**
- **A** — GSD-lite montre que le mode inline suffit pour S/M, seuil taille devient indispensable
- **F** — si GSD-lite se contente d'un archivage simple, le clustering Jaccard est prématuré

**3.3 Nouveau concept exportable (GSD-lite uniquement) :**

Les concepts ci-dessous ne figuraient pas dans les propositions A-F mais méritent discussion :

| Concept | Source | Destination SDLC envisageable |
|---|---|---|
| **Journalism Standard** (critère log qualité) | GSD-lite §9 | Critère de qualité pour §HANDOFF dans SESSION_BRIDGE |
| **STATELESS HANDOFF** (structure fin de log) | GSD-lite §10 | Requis en fin de bloc de travail dans SESSION_BRIDGE |
| **Boot sequence prescrite** | GSD-lite agent §2 | Séquence démarrage dans CLAUDE.md `## Démarrage` |
| **Constitutional Behaviors** (5 non-négociables) | GSD-lite §12 | Modèle pour formaliser les comportements invariants dans CLAUDE.md |

---

## 4. Ce que SDLC fait déjà mieux

Pour mémoire, les axes où le SDLC n'a pas à s'aligner sur GSD :

| Domaine | Avantage SDLC | Conséquence |
|---|---|---|
| Hooks process | PreToolUse/PreCompact guard-rails | Pas d'équivalent dans GSD (différent paradigme) |
| Adversarial Review | §0f — 3 rôles Hunter distincts | GSD-full a un verifier mais moins structuré |
| Registre décisions | M-XX/D-XX interrogeable | GSD a DECISIONS.md libre, sans numérotation |
| Installation zero-npm | Templates + shell uniquement | Ne pas adopter gsd-sdk ou toute dépendance npm |
| Deux surfaces | Claude.ai amont / Claude Code aval | GSD est mono-surface (Claude Code only) |

---

## 5. Proposition de plan de sprint pour les implémentations

### Sprint immédiat — C + D + G (taille S, 1 session)

**Scope :**
- Ajouter `§Critères must_haves` dans le template PDR (Proposition C)
- Enrichir SESSION_BRIDGE avec `§STATELESS HANDOFF` et critère Journalism Standard (Proposition D enrichie)
- Ajouter note "Budget contexte" dans le template PDR L (Proposition G)

**Critère d'acceptation :** les templates modifiés sont opérationnels sur le prochain sprint L.

---

### Sprint suivant — B (taille M)

**Scope :** hook `commit-msg` validant la structure et le scope atomique.

---

### Sprint à planifier — E2 (taille M)

**Scope :** adapter le protocole Driver/Navigator + Journalism Standard de GSD-lite en skill SDLC `/fast`.

---

### Backlog (pas de sprint immédiat) — A, E1, F

À réévaluer après les sprints C+D+G et B.

---

## 6. Questions ouvertes pour décision

1. **Proposition C — niveau de granularité :** must_haves.truths par tâche (comme GSD-full) ou must_haves au niveau PDR (global) ? Coût vs valeur.

2. **Proposition D — Journalism Standard complet ou sous-ensemble ?** Le standard complet (Narrative arc + Raw evidence + Hypothesis tracking + Decision record + STATELESS HANDOFF) est exigeant. Quel sous-ensemble adopter ?

3. **Proposition E2 — Naming :** `/fast`, `/quick`, `/lite` ? Le naming influence l'usage.

4. **Constitutional Behaviors — pertinence pour SDLC :** formaliser les comportements non-négociables de l'agent dans CLAUDE.md (sur le modèle GSD-lite §12) ? Effort faible, signal fort sur les invariants comportementaux.
