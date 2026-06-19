# SPEC — SDLC Toolkit

---

## §Vue d'ensemble

Le SDLC toolkit est un modèle de gouvernance reproductible pour projets
pilotés par Claude Code : un ensemble de templates numérotés (`01` à `11`)
qui, une fois copiés dans un projet cible, lui donnent des règles
permanentes d'exécution, des skills de clôture/rétrospective/synchronisation,
et une boucle de rétroaction terrain → règle permanente.

**Quatre invariants** (détail complet : `00-CONTEXT.md §3`) :
- **INV-1 · Vérification exécutable** — tout test = une commande exacte, jamais une estimation
- **INV-2 · Circuit fermé** — toute règle implicite devient explicite (hook, `DECISIONS.md`, ou `Claude.md`)
- **INV-3 · Contexte chirurgical** — Claude Code charge uniquement les fichiers listés dans `§Handoff`, pas le repo entier
- **INV-4 · Boucle de rétroaction** — toute observation terrain a un chemin vers une règle permanente

**Découpage à deux surfaces** (M-SCOPE-04, Sprint SDLC-12) :
- **Claude.ai (amont, optionnel)** — idéation, PRD, décisions d'architecture,
  instruit par `10-AMONT-TEMPLATE.md`. Ne vérifie rien contre du code réel —
  ne peut pas, n'a pas accès au repo.
- **Claude Code (aval, gouverné)** — à partir du Sprint 0, seul endroit où
  une hypothèse peut être confrontée au code réel (`HALT-ARCH`,
  `§Dépendances vérifiées`).

---

## §Architecture

Flux complet, du bootstrap à l'évolution du modèle :

```
[Optionnel] Project Claude.ai amont (10-AMONT-TEMPLATE.md)
        ↓ alimente specs/SPEC.md + premier PDR
Sprint 0 — bootstrap (sdlc-init.sh + 06-PDR-bootstrap.md)
        ↓
Claude.md gouverne chaque session (01-Claude-md-TEMPLATE.md §Démarrage)
        ↓
Boucle de sprint : Analyse → Demande d'aval (verdict PASS/CONCERNS/FAIL)
                    → Code → Test → /wrap-up
        ↓
/wrap-up (03-wrap-up-SKILL-TEMPLATE.md) :
  Étape 0 — bilan (0a mémoire sprint → 0c ancrage git → 0d bilan structuré
            → 0e revue objectif → 0f Adversarial Review si Taille M/L)
        ↓
  Étape 1 — question rétrospective → Étape 2 — Lessons Learned
        ↓
  Étape 3 — doc (CHANGELOG, nettoyage artefacts) → Étape 3.5 — vérif pré-commit
        ↓
  Étape 4 — commit → Étape 5 — amorce session suivante → Étape 6 — sync Claude.ai
        ↓ toutes les ~5 sprints ou incident
/retrospective (09-retrospective-SKILL-TEMPLATE.md) :
  Étape 1 — chargement contexte → Étape 2 — analyse patterns internes
        ↓
  Étape 2b — Significant Discovery Alert → Étape 3/4 — actions internes
             + remontées modèle SDLC → Étape 5 — index structuré des patterns
        ↓ quand le modèle SDLC évolue
/sdlc-sync (04b-sdlc-sync-SKILL-TEMPLATE.md) :
  delta version → application sélective → entrée D-SYNC-XX
```

Vérifié contre l'état réel de `01-Claude-md-TEMPLATE.md §Démarrage`,
`03-wrap-up-SKILL-TEMPLATE.md` (étapes 0a-0f, 1-6 confirmées présentes) et
`09-retrospective-SKILL-TEMPLATE.md` (étapes 1-6, dont 2b confirmée
présente) au moment de la rédaction (Sprint SDLC-13, 18/06/2026).

---

## §Modules

Construit depuis `ls *.md` réel à la racine du repo toolkit
(Sprint SDLC-13, 18/06/2026) — aucune divergence trouvée avec le squelette
prévu au PDR de ce sprint.

| Module | Rôle | Dépend de | Utilisé par |
|--------|------|-----------|-------------|
| `01-Claude-md-TEMPLATE.md` | Règles permanentes d'exécution | `02-STANDARDS-TEMPLATE.md` (DoD référencée) | Chaque session Claude Code |
| `02-STANDARDS-TEMPLATE.md` | DoD, types de sprint, niveaux de test | — | `03-wrap-up`, `04-sprint-PDR-TEMPLATE.md` |
| `03-wrap-up-SKILL-TEMPLATE.md` | Clôture de sprint | `02` (DoD), `09` (index patterns) | Fin de chaque sprint |
| `04-sprint-PDR-TEMPLATE.md` | Spec de sprint | `10` (optionnel, si amont utilisé) | Chaque sprint, copié tel quel |
| `04b-sdlc-sync-SKILL-TEMPLATE.md` | Alignement version | Tableau de compatibilité `07-DECISIONS-SDLC.md` | Évolution du modèle |
| `05-ROADMAP-TEMPLATE.md` | Backlog Now/Next/Later | — | `/retrospective`, `/wrap-up` |
| `06-PDR-bootstrap.md` | Guide Sprint 0 | `10` (référencé si phase amont) | Bootstrap initial uniquement |
| `07-DECISIONS-SDLC.md` | Registre décisions sur le modèle | — | *(propre au projet toolkit, jamais copié)* |
| `08-hooks-TEMPLATE.md` | Hooks bash PreToolUse | — | Chaque commande bash en session |
| `09-retrospective-SKILL-TEMPLATE.md` | Analyse patterns | `doc/LESSONS_LEARNED.md` du projet cible | Toutes les ~5 sprints |
| `10-AMONT-TEMPLATE.md` | Phase amont Claude.ai | — | Project Claude.ai dédié, optionnel |
| `11-help-SKILL-TEMPLATE.md` | Recap lecture seule | `.claude/sprint-memory.md`, `doc/ROADMAP.md`, `Claude.md` | À la demande |
| `00-CONTEXT.md` | Contexte Claude.ai — invariants + carte des fichiers | — | Toute évolution du modèle (lu en premier) |
| `README.md` | Pitch + démarrage rapide | — | Première lecture humaine du toolkit |
| `CHANGELOG.md` | Historique des sprints du toolkit lui-même | — | `/wrap-up` (propre au toolkit) |

**Fichiers humains hors Claude.ai** (non listés ci-dessus, non synchronisés —
`doc/SPEC.html`, `doc/MODE-OPERATOIRE.html`, voir `00-CONTEXT.md §1`).
