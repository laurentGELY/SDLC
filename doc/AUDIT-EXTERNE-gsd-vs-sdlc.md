# Audit externe — GSD (Get Shit Done) vs Modèle SDLC
<!-- Sprint SDLC-Audit-GSD · 24/06/2026 · Mode : Plan (analyse only) -->
<!-- Source auditée : exemples/get-shit-done/ (clone local, v1.42.1) -->
<!-- Note : document reconstruit post-session à partir de l'analyse conversationnelle -->

---

## 1. Cartographie GSD

**Nature :** framework de gestion de projet IA — gouvernance de processus complète (phases, tâches, commits, agents).

**Architecture principale :**

| Composant | Rôle |
|---|---|
| `.planning/` | Persistance cross-session (STATE.md, ROADMAP.md, REQUIREMENTS.md, HANDOFF.json) |
| `gsd-sdk query` | Mutations d'état sécurisées (multi-session safe, safe vs. écriture directe) |
| `gsd-{agent}` | Sous-agents spécialisés (gsd-planner, gsd-executor, gsd-phase-researcher…) |
| Namespace meta-skills | Routeurs (6 ns-* skills), 2150→120 tokens de cold-start |
| PLAN.md (XML) | Prompt exécutable structuré (pas de la documentation) |
| `gsd-validate-commit.sh` | Enforcement des commits atomiques par tâche |

**Concepts clés :**
- **Wave-based parallelism** — vagues de tâches indépendantes, chaque tâche spawne un sous-agent frais (200k tokens)
- **Context rot mitigation** — orchestrateur ~15% du contexte, exécuteurs 100% frais
- **Goal-backward verification** — "What must be TRUE?" not "What was done?" (must_haves.truths)
- **Context budget tiers** — PEAK (0-30%) / GOOD (30-50%) / DEGRADING (50-70%) / POOR (70%+)
- **Graduation system** — clustering Jaccard de LEARNINGS.md sur N phases, promotion HITL vers CLAUDE.md
- **SPIDR splitting** — 5 axes de découpe (Spike/Paths/Interfaces/Data/Rules) pour stories oversized
- **MCP schema cost awareness** — chaque MCP injecte son schéma à chaque tour (peut être 20k+ tokens/turn)
- **Questioning philosophy** — "dream extraction, not requirements gathering"
- **/gsd:fast vs /gsd:quick** — inline pur < 2 min (aucun overhead) vs. sous-agents + STATE.md tracking

**Skills actifs :** 59 skills (après consolidation v1.41.0)

---

## 2. Cartographie SDLC

**Nature :** gouvernance de sprint IA — processus de développement structuré pour projets Claude.ai/Claude Code.

**Architecture principale :**
- Invariants INV-1 à INV-4 (Vérification exécutable / Circuit fermé / Contexte chirurgical / Boucle de rétroaction)
- SESSION_BRIDGE.md + sprint-memory.md (continuité cross-session)
- PreToolUse/PreCompact hooks (guard-rails process)
- LESSONS_LEARNED → /retrospective → hook/DECISIONS.md circuit (INV-4)
- Taille XS/S/M/L pour le sizing des sprints
- §0f Adversarial Review (Blind Hunter / Edge Case Hunter / Acceptance Auditor)
- Deux surfaces : Claude.ai (amont/idéation) + Claude Code (aval/exécution)
- sdlc-init.sh + templates markdown (zéro dépendance npm)

---

## 3. Analyse comparative

### 3.1 GSD fait mieux que SDLC

| Domaine | GSD | SDLC | Écart |
|---|---|---|---|
| Gestion du contexte | Tiers comportementaux + sous-agents frais | Mention token seuil seul | GSD plus précis et outillé |
| Granularité commits | gsd-validate-commit.sh (atomique par tâche) | Aucun enforcement technique | Gap structurel SDLC |
| Persistance cross-session | .planning/ complet (STATE, ROADMAP, HANDOFF.json) | SESSION_BRIDGE (moins structuré) | GSD plus riche |
| Story splitting | SPIDR (5 axes, interactif) | Taille XS-L sans méthode de découpe | Gap SDLC |
| Knowledge promotion | Graduation automatique (clustering Jaccard) | LESSONS_LEARNED manuel | GSD semi-automatique |
| MCP awareness | Pre-Phase MCP Audit documenté | Absent | Gap complet SDLC |

### 3.2 SDLC fait mieux que GSD

| Domaine | SDLC | GSD | Écart |
|---|---|---|---|
| Hooks process | PreToolUse/PreCompact (guard-rails) | Absent (gsd-sdk = autre mécanisme) | SDLC plus contrôlé |
| Adversarial Review | §0f avec 3 rôles distincts | Absent | SDLC plus rigoureux |
| Registre décisions | M-XX/D-XX interrogeable | Absent (DECISIONS.md libre) | SDLC plus traçable |
| Installation | Zero-npm (markdown + shell) | npm + gsd-sdk (Node.js) | SDLC plus simple |
| Deux surfaces | Claude.ai amont / Claude Code aval | Unique surface Claude Code | SDLC plus adapté au flux humain |

### 3.3 Convergences

- Cross-session continuity (SESSION_BRIDGE ≈ STATE.md + HANDOFF.json)
- Scope discipline (§Portée PDR ≈ "Deferred Ideas" discuss-phase)
- Vérification avant clôture (§0f ≈ verification-phase GSD)
- Boucle feedback (INV-4 ≈ Graduation, différentes implémentations)
- Contexte chirurgical (INV-3 ≈ Context budget + frontmatter-only reads)

---

## 4. Propositions

### Proposition A — Agent séparé pour l'exécution (sprints L)

**Principe GSD :** chaque tâche spawne un sous-agent frais (200k tokens), l'orchestrateur ~15%.
**Adaptation SDLC :** pour les sprints L (> 5 fichiers, > 1 domaine), séparer planning et exécution via sous-agent.
**Mode par défaut recommandé :** `--interactive` (séquentiel inline, pas de sous-agents) avec opt-in sous-agent explicite.
**Condition d'activation :** sprints L uniquement — XS/S/M restent en mode inline.

### Proposition B — Hook commit-msg pour la granularité atomique

**Principe GSD :** gsd-validate-commit.sh, un commit par tâche, format structuré.
**Adaptation SDLC :** hook `commit-msg` ou `pre-commit` validant la structure et le scope du commit.
**Bénéfice :** renforce INV-2 (circuit fermé) au niveau technique, pas seulement procédural.

### Proposition C — Goal-backward verification dans le PDR

**Principe GSD :** must_haves.truths — liste de vérités observables que doit satisfaire chaque tâche.
**Adaptation SDLC :** ajouter une section `§Critères d'acceptation must_haves` dans les PDR L, formulée "What must be TRUE?" et non "What was done?".
**Bénéfice :** renforce INV-1 au niveau de la spec, pas seulement à l'exécution.

### Proposition D — Persistance cross-session enrichie

**Principe GSD :** .planning/ avec STATE.md, ROADMAP.md, HANDOFF.json.
**Adaptation SDLC :** enrichir SESSION_BRIDGE avec un bloc `§HANDOFF` structuré (état courant, prochaine action, décisions lockées) en plus du résumé narratif.
**Bénéfice :** SESSION_BRIDGE utilisable par un agent frais sans relire le contexte.

### Proposition E1 — Skill /quick (mode structuré léger)

**Principe GSD :** /gsd:quick spawne gsd-planner + gsd-executor(s), STATE.md tracking, mais sans le poids d'un sprint complet.
**Adaptation SDLC :** mini-PDR + exécution inline + SUMMARY bref. Sous-agents optionnels.
**Cas d'usage :** tâches hors-sprint (corrections urgentes, refactors ponctuels) nécessitant traçabilité.

### Proposition E2 — Skill /fast (mode inline pur)

**Principe GSD :** /gsd:fast — inline pur, aucun overhead, < 2 min, pas de planning, pas de STATE.md.
**Adaptation SDLC :** skill déclaratif "inline" sans artefact produit, pour tâches < 2 min triviales.
**Différence E1/E2 :** E1 trace, E2 n'enregistre rien.

### Proposition F — Graduation system (version simplifiée)

**Principe GSD :** clustering Jaccard des LEARNINGS.md sur N dernières phases, promotion HITL vers CLAUDE.md.
**Adaptation SDLC (simplifiée) :** au /retrospective, proposer un "passage en revue" des LESSONS_LEARNED des K derniers sprints. Si un item apparaît ≥ 3 fois → suggérer promotion vers DECISIONS.md.
**Différence vs. GSD :** manuel (humain détecte la récurrence) vs. semi-automatique (clustering lexical). Version simplifiée = phase 1.

### Proposition G — Guidance contexte dans les PDR L

**Principe GSD :** context-budget.md avec tiers comportementaux (PEAK/GOOD/DEGRADING/POOR).
**Adaptation SDLC :** ajouter une note dans les PDR L — "budget estimé" et comportement recommandé si contexte > 60%.
**Bénéfice :** INV-3 contexte chirurgical avec indicateurs concrets.

---

## 5. Non-propositions

| Concept GSD | Raison de non-adoption |
|---|---|
| PLAN.md exécutable XML | Trop complexe, format étranger au SDLC markdown-natif |
| gsd-sdk tooling complet | Dépendance npm — SDLC est zero-npm par choix délibéré |
| Namespace meta-skills | Overhead d'architecture pour un framework plus simple |
| Workstreams parallèles | SDLC gère déjà les sprints parallèles via ses propres mécanismes |
| /gsd:autonomous (full-auto) | SDLC privilégie la supervision humaine à chaque étape |
| SPIDR splitting interactif | Utile mais complexité > bénéfice à ce stade du SDLC |
| MCP Pre-Phase Audit (comme skill) | La guidance suffit — pas besoin d'un skill dédié |

---

## 6. Verdict synthétique

**Stratégie recommandée :** adoption sélective des principes, pas du framework complet.

GSD est un framework sophistiqué avec des années d'itération visible (v1.42.1, 59 skills). L'adopter en entier demanderait une migration majeure incompatible avec la philosophie SDLC (zero-npm, markdown-natif, simplicité). En revanche, plusieurs principes GSD sont directement exportables et renforcent des invariants SDLC existants.

**Priorité recommandée :**

| Rang | Proposition | Effort | Impact |
|---|---|---|---|
| 1 | C — Goal-backward dans PDR | Faible (ajout template) | INV-1 renforcé |
| 2 | D — SESSION_BRIDGE enrichi avec §HANDOFF | Faible (enrichissement template) | INV-3 renforcé |
| 3 | B — Hook commit-msg | Modéré (script hook) | INV-2 renforcé techniquement |
| 4 | E2 — Skill /fast inline | Modéré (nouveau skill) | Couverture cas XS |
| 5 | E1 — Skill /quick structuré | Élevé (sous-agents + tracking) | Couverture sprints imprévus |
| 6 | A — Agent séparé (sprints L) | Élevé (architecture sous-agents) | Perf sprints L uniquement |
| 7 | F — Graduation simplifié | Élevé (process + tooling) | INV-4 semi-automatisé |

---

## 7. Questions ouvertes — réponses (sprint SDLC-Audit-GSD)

**Q1 — Les sous-agents sont-ils disponibles et stables ?**
Oui. L'outil `Agent` est disponible et stable dans cette version de Claude Code. Le mode `--interactive` (séquentiel inline, pas de sous-agents) constitue un fallback sûr. Recommandation : Proposition A avec `--interactive` par défaut.

**Q2 — Le skill /quick correspond-il à un besoin réel ?**
Oui. L'analyse du clone local révèle que GSD distingue explicitement /gsd:fast (inline pur, < 2 min, zéro overhead) de /gsd:quick (sous-agents + STATE.md tracking). Proposition E scindée en E1 (/quick structuré) et E2 (/fast inline pur).

**Q3 — La granularité des commits est-elle un problème ressenti ?**
Gap structurel confirmé. GSD enforce le commit atomique par tâche via script de validation. SDLC ne fait pas d'enforcement technique — INV-2 est procédural seulement. Proposition B reste recommandée.

**Q4 — Autres éléments GSD dans le clone local ?**
Nombreux concepts non documentés publiquement découverts : Graduation system (clustering Jaccard), SPIDR splitting, Forensics post-mortem, Threads + Seeds (persistance légère), Context budget tiers avec signaux de dégradation comportementale, MCP Pre-Phase Audit, Questioning philosophy formalisée, Closed-Phase Gate, Scope guardrail "Deferred Ideas", Sketch system, Progressive disclosure dans les workflows (budget 500 lignes), Conversational UAT, Planner specificity test. Détail : session SDLC-Audit-GSD.
