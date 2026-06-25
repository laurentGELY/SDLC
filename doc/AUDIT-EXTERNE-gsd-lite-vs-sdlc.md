# Audit externe — GSD-lite vs Modèle SDLC
<!-- Sprint SDLC-Audit-GSD-lite · 24/06/2026 · Mode : Plan (analyse only) -->
<!-- Source auditée : exemples/gsd-lite/ (clone local, v2.1.0, @luutuankiet/gsd-lite) -->
<!-- Référence : doc/AUDIT-EXTERNE-gsd-vs-sdlc.md pour les propositions A-F -->

---

## 1. Cartographie GSD-lite

**Nature :** protocole de pair programming — gouvernance d'interaction (comment parler à l'agent, comment challenger, comment enseigner). Distinct de GSD-full (gouvernance de processus).

**Auteur :** luutuankiet (distinct de l'auteur GSD-full)
**Version :** 2.1.0
**Install :** `npx @luutuankiet/gsd-lite` (Node.js CLI minimaliste — copie des fichiers template)

**Architecture :**

| Composant | Rôle |
|---|---|
| `.claude/agents/gsd-lite.md` | Protocole principal — chargé comme system prompt via `settings.json` |
| `.claude/settings.json` | `"agent": "gsd-lite"` — activation automatique |
| `.claude/commands/gsd/` | 4 commandes slash |
| `gsd-lite/WORK.md` | Log de session (3 sections : état courant / événements clés / log atomique) |
| `gsd-lite/PROJECT.md` | Vision projet, core value, critères de succès |
| `gsd-lite/ARCHITECTURE.md` | Structure codebase, tech stack, data flow |
| `gsd-lite/INBOX.md` | Idées garées (scope discipline) |
| `gsd-lite/HISTORY.md` | Archive des phases complétées |

**Commandes slash (4) :**

| Commande | Objectif |
|---|---|
| `/gsd learn` | Mode enseignement — explique GSD-lite dans le contexte du projet |
| `/gsd new-project` | Initialisation guidée — crée PROJECT.md par dialogue |
| `/gsd map-codebase` | Découverte codebase — crée ARCHITECTURE.md |
| `/gsd progress` | Rapport d'état — résume l'état courant, tâches, prochaines actions |

**7 Golden Rules :**

1. **No Ghost Decisions** — si absent de WORK.md, ça n'a pas eu lieu
2. **Why Before How** — toujours demander l'intent avant d'exécuter
3. **User Owns Completion** — l'agent signale, l'utilisateur décide de la fin
4. **Artifacts Over Chat** — tout ce qui compte dans les artefacts, pas dans le chat
5. **Echo Before Execute** — confirmer la compréhension avant d'agir
6. **Ask Before Writing** — chaque écriture d'artefact demande l'accord explicite
7. **Batch Over Scatter** — minimiser les allers-retours, grouper reads et writes

**Modèle Driver/Navigator :**

| Driver (Utilisateur) | Navigator (Agent) |
|---|---|
| Apporte le contexte et le domaine | Challenge les hypothèses |
| Prend toutes les décisions clés | Enseigne avec des analogies |
| Possède le raisonnement | Propose des options avec tradeoffs |
| Approuve toutes les écritures | Présente les plans avant d'agir |
| Curation des logs | Over-communicate dans chaque réponse |

---

## 2. Concepts remarquables GSD-lite

### 2.1 Journalism Standard

Critère de qualité des logs cross-session :

> "Could a zero-context agent read this log in 5 minutes and continue safely with zero ambiguity?"

Auto-Fail Conditions (log invalidé si) :
- Pas de preuve concrète dans le log
- Pas de citation (file:line) pour les claims non-triviaux
- `STATELESS HANDOFF` manquant en fin d'entrée
- Un lecteur froid devrait demander "qu'est-ce que vous avez réellement essayé ?"

Structure d'un log conforme :
```
### [LOG-NNN] - [TYPE] - résumé une ligne - Task: TASK-ID
**Timestamp:** YYYY-MM-DD HH:MM

#### Narrative arc
...

STATELESS HANDOFF
**What was decided:** résumé
**Next action:** prochaine étape spécifique
```

**Log type vocabulary :** `[VISION]` `[DECISION]` `[DISCOVERY]` `[PLAN]` `[EXEC]` `[BLOCKER]` `[BUG]` `[PIVOT]` `[BREAKTHROUGH]` `[RESEARCH]`

### 2.2 Constitutional Behaviors (non-négociables)

| ID | Comportement |
|----|---|
| S1 | Response Orientation — chaque réponse a un topic frame (`Working on:` / `High level` / `Low level`) |
| P1 | Why Before How — demander l'intent avant d'exécuter |
| P2 | Ask Before Writing — approbation explicite pour tout artefact |
| P3 | Echo Before Execute — confirmer la compréhension, vérifier |
| J1 | Journalism Standard — logs respectent les critères §2.1 |

### 2.3 Challenge Tone Protocol

4 tons de challenge distincts selon la situation :

| Ton | Quand l'utiliser | Exemple |
|---|---|---|
| Gentle Probe | Préférence sans raisonnement | "What draws you to X here?" |
| Direct Challenge | Enjeu élevé, risque clair | "I'd push back. [Reason]. Let's do Y." |
| Menu + Devil's Advocate | Tradeoff genuinflement difficile | "X vs Y. Tradeoffs: [liste]. Which fits?" |
| Socratic Counter | Angle mort, moment d'enseignement | "If X, what happens when [edge case]?" |

### 2.4 4-question rhythm (anti-checklist)

Pattern de questionnement : poser 4 questions, vérifier "more or proceed?", répéter si nécessaire.
Interdit : parcourir une liste de catégories question par question (checklist walking).

### 2.5 Response Orientation

Chaque réponse commence par un topic frame :
```
Working on: [description plain English de ce sur quoi on travaille]
```

Et se termine par :
```
---
High level (strategic)
- [topic] -- because: [evidence] -- impact: [what this affects]

Low level (tactical)
- [action] -- triggered by: [what surfaced this] -- unblocks: [what this enables]
```

### 2.6 Scope discipline (INBOX.md)

Quand une nouvelle idée émerge mid-task, formule prescrite :

> "[Feature X] sounds like a new capability — want me to capture it to INBOX.md for later? For now, let's focus on [current scope]."

Le concept est identique au "Deferred Ideas" de GSD-full discuss-phase, mais avec INBOX.md comme destination physique.

---

## 3. Delta GSD-lite vs GSD-full

**Point clé : GSD-lite n'est PAS GSD-full simplifié. Ce sont deux produits différents.**

| Dimension | GSD-full | GSD-lite |
|---|---|---|
| Nature | Gouvernance de processus | Gouvernance d'interaction |
| Sous-agents | Oui (wave parallelism) | Non |
| STATE.md / ROADMAP.md | Oui (.planning/) | Non |
| Commit governance | Oui (gsd-validate-commit.sh) | Non |
| gsd-sdk tooling | Oui | Non |
| Graduation / SPIDR / Forensics | Oui | Non |
| Context budget tiers | Oui | Non |
| Skills count | 59 | 4 commandes + 1 agent |
| Protocole d'interaction | Implicite | Explicite (Driver/Navigator, Golden Rules, Constitutional Behaviors) |
| Journalism Standard | Non | Oui |
| Challenge Tone Protocol | Non | Oui |
| Response Orientation | Non | Oui |

**Ce que GSD-lite apporte que GSD-full n'a pas :**
- Driver/Navigator avec responsabilités explicitement détaillées pour chaque rôle
- Journalism Standard (critère de qualité log formalisé et testable)
- Challenge Tone Protocol (playbook positif — "quand Y, utiliser le ton Z")
- 4-question rhythm (technique anti-checklist concrète avec cadence)
- Response Orientation (topic frame obligatoire)
- Constitutional Behaviors (5 comportements non-négociables codifiés)
- Log type vocabulary (taxonomie des événements de session)
- STATELESS HANDOFF obligatoire à chaque entrée de log

---

## 4. Comparaison GSD-lite vs SDLC

### 4.1 GSD-lite fait mieux que SDLC

| Domaine | GSD-lite | SDLC | Écart |
|---|---|---|---|
| Qualité des logs cross-session | Journalism Standard avec critères testables | SESSION_BRIDGE sans critère de qualité explicite | GSD-lite plus concret |
| Protocole d'interaction | Driver/Navigator + Constitutional Behaviors | Aucun protocole d'interaction formalisé | Gap complet SDLC |
| Challenge structuré | Challenge Tone Protocol (4 tons) | Pas de playbook de questionnement positif | Gap SDLC |
| Scope discipline mid-task | INBOX.md avec formule prescrite | §Portée statique dans PDR (pas de capture mid-task) | SDLC fragile sur les dérives |
| Handoff stateless | STATELESS HANDOFF obligatoire en fin de log | Pas de contrainte de qualité au niveau log individuel | Gap SDLC |
| Onboarding artefacts | Boot sequence prescrite (lit PROJECT+ARCH+WORK en premier) | Aucune séquence de démarrage prescrite pour l'agent | SDLC moins fiable |

### 4.2 SDLC fait mieux que GSD-lite

| Domaine | SDLC | GSD-lite | Écart |
|---|---|---|---|
| Gouvernance de processus | Sprints, hooks, CHANGELOG, DECISIONS.md | Absent | GSD-lite ne gère pas le processus |
| Commit governance | INV-2 + CHANGELOG | Absent | Gap GSD-lite |
| Adversarial Review | §0f avec 3 rôles Hunter | Absent | Gap GSD-lite |
| Invariants formels | INV-1 à INV-4 | Absent (Golden Rules couvrent partiellement) | SDLC plus structuré |
| Vérification exécutable | Critères d'acceptation formels | "User Owns Completion" (implicite) | SDLC plus précis |
| Sprints L | Taille L avec adversarial review | Aucun outil | GSD-lite limité aux travaux courts |
| Hooks PreToolUse/PreCompact | Oui | Absent | SDLC plus controllé |

### 4.3 Convergences

| Concept GSD-lite | Équivalent SDLC |
|---|---|
| WORK.md (artefacts > chat) | SESSION_BRIDGE.md (continuité cross-session) |
| INBOX.md (scope discipline) | §Portée PDR (hors-scope explicite) |
| Why Before How (Golden Rule) | §Contexte / Pourquoi dans le PDR |
| Echo Before Execute | §Comportement actuel → cible dans le PDR |
| Artifacts Over Chat | INV-3 (contexte chirurgical) |
| User Owns Completion | INV-1 (vérification exécutable) |
| No Ghost Decisions | DECISIONS.md (tout ce qui est décidé est enregistré) |

---

## 5. Impact sur les propositions A-F (de l'audit GSD-full)

### A — Agent séparé pour l'exécution (sprints L)

**GSD-lite** ne confirme pas la proposition : il n'utilise pas de sous-agents.
**Nuance apportée :** GSD-lite montre qu'un mode inline (sans sous-agents) est viable et même préférable pour les travaux courts. La Proposition A devrait avoir un seuil explicite — applicable aux sprints L uniquement, pas en dessous.

**Statut :** Nuancée — validée pour les sprints L, mais GSD-lite confirme que le mode inline suffit pour S/M.

### B — Hook commit-msg pour la granularité atomique

**GSD-lite** n'adresse pas les commits (protocole d'interaction uniquement).
**Constat :** l'absence de toute gestion de commit dans GSD-lite renforce la nécessité pour le SDLC d'implémenter ce contrôle de son côté. GSD-lite + SDLC partagent le même gap sur ce point.

**Statut :** Confirmée — l'absence dans GSD-lite ne la remet pas en cause.

### C — Goal-backward verification dans le PDR

**GSD-lite** converge via "User Owns Completion" (Constitutional P3) et "Echo Before Execute" (P2) : l'agent présente ce qu'il a compris et attend validation avant d'agir. C'est une version conversationnelle du même principe.

**Statut :** Renforcée — deux frameworks indépendants convergent sur le principe "vérifier que l'état visé est correct avant d'agir".

### D — Persistance cross-session enrichie

**GSD-lite** propose WORK.md avec le Journalism Standard : le critère "Could a zero-context agent continue safely?" est plus exigeant et plus concret que notre SESSION_BRIDGE actuel. L'ajout du STATELESS HANDOFF obligatoire à chaque entrée de log est directement exportable.

**Enrichissement de la proposition :** D doit intégrer le Journalism Standard (ou un sous-ensemble) comme critère de qualité pour le §HANDOFF de SESSION_BRIDGE.

**Statut :** Renforcée et enrichie — GSD-lite apporte un critère de qualité concret absent de GSD-full.

### E — Skill /quick (E1) et /fast (E2)

**GSD-lite** est essentiellement un mode "fast inline complet" : protocole riche, aucun overhead de processus, pas de sous-agents, pas de STATE.md. Il prouve que l'on peut avoir un protocole de qualité sans infrastructure lourde.

**Impact sur E2 (/fast) :** GSD-lite montre que "inline pur" peut être un protocole complet avec ses propres Golden Rules — pas juste une simplification du flux normal. E2 ne devrait pas être "SDLC sans les trucs lourds" mais un protocole propre.

**Statut :** Renforcée — GSD-lite prouve la viabilité et la richesse possible d'un mode inline.

### F — Graduation system (version simplifiée)

**GSD-lite** a HISTORY.md (archivage des phases complétées) et INBOX.md (idées garées). C'est une version minimaliste du circuit de capitalisation : le travail accompli est archivé, les idées capturées. Il n'y a pas de Graduation automatique.

**Signal :** si même GSD-lite (le framework allégé) se contente d'un archivage simple, la Graduation automatique (Jaccard clustering) est peut-être prématurée pour le SDLC. La version simplifiée (HISTORY.md pattern) peut constituer la phase 1.

**Statut :** Nuancée — HISTORY.md pattern = phase 1 raisonnable ; Graduation automatique = phase 2 après maturation.

---

## 6. Concepts GSD-lite exportables vers SDLC

Ces concepts n'ont pas d'équivalent dans le SDLC actuel et sont directement exportables :

| Concept | Exportabilité | Destination SDLC |
|---|---|---|
| **Journalism Standard** | Élevée | Critère de qualité du §HANDOFF dans SESSION_BRIDGE |
| **Constitutional Behaviors** | Élevée | Modèle pour formaliser les comportements non-négociables de l'agent dans CLAUDE.md |
| **STATELESS HANDOFF** | Élevée | Fin de chaque bloc de travail significatif dans SESSION_BRIDGE |
| **Log type vocabulary** | Moyenne | Taxonomie optionnelle pour les logs de sprint |
| **4-question rhythm** | Moyenne | Anti-pattern "checklist walking" — peut enrichir le §0f ou les guidelines amont |
| **Challenge Tone Protocol** | Faible | Intéressant mais relève de la surface Claude.ai (amont), hors portée SDLC |
| **Response Orientation** | Faible | Applicable mais difficile à enforcer via template |
| **Boot sequence prescrite** | Élevée | Séquence de démarrage agent dans CLAUDE.md (`## Démarrage`) |

---

## 7. Verdict GSD-lite

**GSD-lite est un framework orthogonal à GSD-full et au SDLC.** Il n'est pas une alternative — c'est un complément qui adresse une couche différente (interaction quality vs process quality).

**Ce qu'il apporte de plus original :** la formalisation du contrat d'interaction humain-agent. GSD-full et SDLC se focalisent sur le QUOI (processus, phases, commits) ; GSD-lite formalise le COMMENT (questionner, challenger, enseigner, logger).

**Adoption recommandée :**
- Pas d'adoption comme framework à part entière (le SDLC a son propre processus)
- Adoption sélective de 3 concepts haute-valeur : Journalism Standard, STATELESS HANDOFF, Boot sequence prescrite
- Ces 3 concepts enrichissent Proposition D sans en changer la nature
