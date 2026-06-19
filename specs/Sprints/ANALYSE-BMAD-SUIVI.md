# ANALYSE-BMAD — Suivi de synthèse (référence brainstorm)
<!-- Document vivant · créé 18/06/2026 après SDLC-06/07/08 -->
<!-- Objectif : remplacer la relecture de doc/ANALYSE-BMAD.md (289 lignes) +
     ANALYSE-BMAD-TACTIQUE.md (297 lignes) + sprints SDLC-07/08 pour tout futur
     brainstorm sur l'import de patterns BMad. Mettre à jour ce fichier à chaque
     sprint qui importe/écarte/résout un item ci-dessous — ne pas le laisser dériver. -->

**Sources complètes (si le détail path:ligne ou la citation exacte est nécessaire) :**
- `specs/Sprints/ANALYSE-BMAD.md` — analyse stratégique (docs publiques BMad v6)
- `specs/Sprints/ANALYSE-BMAD-TACTIQUE.md` — 19 fiches P-01→P-19 (lecture source `exemples/bmad-method/src/`)
- `specs/Sprints/sprint-SDLC-07-bmad-import-xs.md`, `sprint-SDLC-08-bmad-qualite-continuite.md`

---

## BMad en une ligne

Framework open-source AI-driven (48k★, MIT) couvrant idéation → implémentation
(4 phases : Analysis/Planning/Solutioning/Implementation), agents nommés (Mary,
John...), npm/Python/uv requis. Notre SDLC toolkit est un méta-framework de
**gouvernance de sprint** (bash pur, zéro dépendance) — périmètres complémentaires,
pas concurrents (cf. §4 stratégique).

## Nos 3 différenciateurs non-négociables (à préserver dans tout import)

1. **Hooks bash** (`pre-tool-bash.sh`) — seule façon de rendre une règle non-négociable ; BMad n'a aucun équivalent (tout est déclaratif/prompt).
2. **Sprint memory + annotations CONF** — état de session comme artefact de première classe ; BMad n'a pas de gestion d'état intra-session documentée.
3. **Boucle de rétroaction fermée** (LESSONS_LEARNED → retrospective → hook/règle) — BMad a une rétro plus légère, moins outillée pour détecter les récurrences.

---

## Statut des 19 patterns tactiques (P-01 → P-19)

| ID | Pattern (résumé) | Statut | Détail |
|----|------------------|--------|--------|
| P-01 | HALT comme primitive d'arrêt non-négociable | ✅ **Importé SDLC-07** | `01-Claude-md-TEMPLATE.md §Règles absolues` — bloc 5 conditions HALT-DEP/3X/ARCH/SCOPE/TIMEOUT |
| P-02 | Clause anti-complaisance "test OK" (no lying) | ✅ **Importé SDLC-08** | `01-Claude-md-TEMPLATE.md §Test` — clause anti-complaisance |
| P-03 | Grille succès/échec par étape (pas seulement en fin de sprint) | ⏳ En attente | Proposition : grille par étape majeure dans `§Plan d'exécution` pour PDR taille L |
| P-04 | Adversarial review 3 couches (accès asymétrique) + triage 4 catégories | ⏳ En attente — **priorité 3** | Comble angle mort B2 (stratégique). Effort moyen — nécessite de définir notre triple-lecture |
| P-05 | Readiness gate ternaire — libellé réel `READY/NEEDS WORK/NOT READY` | ⏳ En attente | Correction déjà actée : ne pas utiliser `PASS/CONCERNS/FAIL` (erreur initiale de l'analyse stratégique) |
| P-06 | Triple stratégie de chargement (FULL/SELECTIVE/INDEX_GUIDED) | ✅ **Importé SDLC-08** | `01-Claude-md-TEMPLATE.md §Tokens` — mode "Index-guidé" |
| P-07 | Seuil quantifié délégation subagent (>5 fichiers ou >10K tokens) | ✅ **Importé SDLC-08** | `01-Claude-md-TEMPLATE.md §Tokens` — bullet "Délégation sous-agent" |
| P-08 | "Extract, don't ingest" — délégation par défaut, pas en dernier recours | 🚫 Pas importé | Changement de philosophie trop couplé à un modèle multi-agent natif ; reste en question ouverte (Q. ci-dessous) |
| P-09 | Significant Discovery Alert — checklist fermée d'invalidation du plan | ✅ **Importé SDLC-08** | `09-retrospective-SKILL-TEMPLATE.md §Étape 2b` — SD-1 à SD-5 |
| P-10 | Critical Readiness Exploration (5 dimensions hors-code) | 🔀 **Absorbé, pas importé tel quel** | Décision D-SDLC-08-01 : couvert par SD-1 et SD-5 de la rétro plutôt qu'ajouté au wrap-up §0e (évite la friction sur chaque sprint Doc/Spike) |
| P-11 | Reconstruction sprint-memory si perte accidentelle | ✅ **Importé SDLC-08** | `01-Claude-md-TEMPLATE.md §Mémoire de sprint` — clause "Perte accidentelle en cours de sprint" |
| P-12 | Niveaux de preuve réels : Confirmed/Deduced/Hypothesized + statut Open/Confirmed/Refuted | ⏳ En attente | Correction déjà actée : pas 4 niveaux. Cible probable : futur skill `/diagnostic` (non encore créé dans ce repo) |
| P-13 | "Stronghold first" — 3 principes anti-biais de confirmation | ✅ **Importé SDLC-07** | `01-Claude-md-TEMPLATE.md §Analyse` — "Principes anti-biais (avant toute analyse)" |
| P-14 | Persona ultra-succincte — "toute affirmation citable" | ✅ **Importé SDLC-07** | `01-Claude-md-TEMPLATE.md §Rôle` — règle "affirmation factuelle citable" |
| P-15 | Architecture step-file (un seul fichier de step chargé à la fois) | 👁 Surveiller | Pas critique : `03-wrap-up` (341 lignes) et `09-retrospective` (197+45 lignes post SDLC-08) sous le seuil de douleur. Revisiter si un skill dépasse ~400 lignes |
| P-16 | Activation en 6 étapes fixes et uniformes sur tous les skills | 👁 Surveiller | Pertinent seulement si on crée de nouveaux skills SDLC ; pas de TOML chez nous (écarté) |
| P-17 | Dégradation gracieuse documentée si script externe échoue | 🚫 Non applicable | Pas de dépendance script externe dans notre modèle bash pur. Principe rédactionnel à retenir si un futur skill dépend d'un outil externe |
| P-18 | Sharding documentaire via outil CLI tiers (npm) | 🚫 Non applicable | Dépendance npm écartée (cohérent avec N7 zéro dépendance). Alternative si besoin : découpage manuel `sed`/`awk` par `##` si `specs/SPEC.md` grossit trop |
| P-19 | Roster agents léger (routage) séparé de la persona complète (détail) | 🚫 Non applicable | Notre modèle n'a pas de roster d'agents (cf. "Named agents" écarté en §3 stratégique) |

**Légende :** ✅ Importé · 🔀 Absorbé ailleurs (pas un import standalone) · ⏳ En attente (candidat valide, pas encore fait) · 👁 Surveiller (conditionnel à un seuil futur) · 🚫 Non applicable (décidé, ne pas reproposer sans nouvel élément)

---

## Statut du catalogue stratégique (§3 de ANALYSE-BMAD.md)

### ✅ IMPORTER (bénéfice net clair) — statut réel
| Concept | Statut |
|---------|--------|
| Adversarial Review | ⏳ En attente (= P-04) |
| Forensic Investigation (niveaux de preuve) | ⏳ En attente (= P-12) |
| Implementation Readiness Gate | ⏳ En attente (= P-05) |
| Project Context comme "constitution" | ✅ Déjà couvert — `specs/SPEC.md` joue ce rôle, aucune action |
| ADRs dans le document d'architecture | ⏳ En attente — convention `§ADR-XX` dans `07-DECISIONS-SDLC.md` pas encore ajoutée |

### 🔧 ADAPTER (reformulation nécessaire) — statut réel
| Concept | Statut |
|---------|--------|
| bmad-help contextuel | ⏳ En attente — pas de skill `/help` créé |
| Scale-adaptive planning (PDR XS/S allégé) | ⏳ En attente |
| Document sharding guidance | ⏳ En attente — conditionnel à la taille de `specs/SPEC.md` |
| Agents nommés / "modes" (stratège/dev/reviewer) | ❓ Question ouverte non tranchée — risque de sur-ingénierie noté |
| Sprint Status YAML | ⏳ En attente — format `ROADMAP.md §Now` pas encore structuré |

### ❌ ÉCARTER (décidé, ne pas rouvrir sans fait nouveau)
TOML customisation · Named agents hardcodés · npm installer · Party Mode ·
Phases 1-3 complètes (PRD/UX/Architecture workflows) · Module ecosystem (TEA/BMGD/CIS)

### 👁 SURVEILLER (trop tôt, pas de décision requise)
BMad Builder · Test Architect (TEA) · Cross-platform (Cursor/Codex) ·
Quick Dev track · Forensic checkpoint preview

---

## Questions ouvertes restantes (§5 stratégique — aucune tranchée à ce jour)

1. **Scope du toolkit** : étendre vers le product lifecycle amont (PRD/architecture) ou rester sur la gouvernance de sprint ?
2. **Emplacement Adversarial Review** : PDR §Critères d'acceptation, wrap-up §Étape 1, ou skill dédié `/review` ?
3. **bmad-help** : un skill `/help` proactif est-il justifié pour ce projet, ou la doc statique suffit ?
4. **Named agents / modes** : formaliser plusieurs "modes" dans `§Rôle`, ou rester sur un rôle unique configurable ?
5. **Forensic Investigation** : la taxonomie Confirmed/Deduced/Hypothesized apporte-t-elle une valeur réelle dans `/diagnostic` (qui n'existe pas encore comme skill dans ce repo) ?

---

## Prochain candidat naturel si une suite est voulue

D'après le tableau "Top 5 patterns" de l'analyse tactique, l'ordre de priorité
restant après SDLC-07/08 est : **P-04** (adversarial review, effort moyen) puis
**P-05 + P-12** (gate + taxonomie de preuve, tous deux XS/S, regroupables en un
sprint comme SDLC-07/08 l'ont fait pour leurs groupes respectifs).
