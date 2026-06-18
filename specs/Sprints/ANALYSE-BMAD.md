# ANALYSE-BMAD — Comparaison BMad Method v6 vs SDLC Toolkit v1.9
<!-- Spike SDLC-06 · 18/06/2026 · Source : recherche web + docs officiels bmad-method.org -->
<!-- NOTE : Cette analyse est produite depuis les docs publiques (README, docs.bmad-method.org). -->
<!-- Une analyse complémentaire sur les fichiers du repo cloné (src/, skills/) peut affiner §3. -->

---

## §0 — BMad Method en une page

**Build More Architect Dreams** — framework open-source AI-driven, v6, 48k+ étoiles, MIT.
Cible : projets pilotés par Claude Code, Cursor, Codex CLI, de l'idéation à l'implémentation.

**Architecture (trois couches) :**
```
Skill          → capacité discrète (.claude/skills/{name}/SKILL.md)
Named agent    → persona nommée wrappant plusieurs skills (Mary, John, Winston, Amelia...)
Customisation  → TOML merging : shipped defaults ← team overrides ← personal .user.toml
```

**4 phases de workflow :**
```
Phase 1 — Analysis   : brainstorming, market research, product brief, PRFAQ (optionnel)
Phase 2 — Planning   : PRD (create/update/validate), UX design
Phase 3 — Solutioning: architecture (avec ADRs), epics & stories, implementation readiness gate
Phase 4 — Implementation: sprint planning, story execution, code review, retrospective
```

**Concepts distinctifs :**
- `bmad-help` : skill contextuelle qui sait ce qui est installé et guide l'humain
- Adversarial Review : revue forcée (l'agent DOIT trouver des problèmes)
- Party Mode : plusieurs personas dans une session, débat de perspectives
- Quick Dev : piste parallèle qui bypass les phases 1-3 pour petites tâches
- Implementation Readiness Gate : check PASS/CONCERNS/FAIL avant de coder
- Document sharding : guidance pour fragmenter les grands fichiers de contexte
- `project-context.md` : "constitution" du projet, chargée par tous les agents

**Installer :** `npx bmad-method install` (Node.js 20+, Python 3.10+, uv requis)

---

## §1 — Tableau comparatif des couches architecturales

| Dimension | BMad Method v6 | SDLC Toolkit v1.9 | Avantage |
|-----------|---------------|-------------------|----------|
| **Point d'entrée** | `npx bmad-method install` (npm, Python, uv) | `bash sdlc-init.sh` (bash pur) | SDLC : zéro dépendance |
| **Instructions agent** | Agents nommés avec persona (SKILL.md) | `Claude.md` + §Rôle adapté | BMad : plus naturel à invoquer |
| **Invocation skill** | `bmad-prd`, `bmad-dev-story`, ou "Hey Mary..." | `/wrap-up`, `/retrospective`, `/diagnostic` | BMad : intent-matching naturel |
| **Customisation** | TOML mergé (shipped → team → personal) | Fichiers `.md` adaptés au bootstrap | SDLC : plus simple, moins puissant |
| **Hooks de sécurité** | Aucun (non mentionné dans la doc) | `pre-tool-bash.sh` (PreToolUse) | **SDLC : avantage décisif** |
| **Mémoire de session** | Aucune architecture documentée | `sprint-memory.md` + annotations CONF | **SDLC : avantage décisif** |
| **Boucle rétroaction** | `bmad-retrospective` (léger) | LESSONS_LEARNED → `/retrospective` → hook | **SDLC : circuit plus fermé** |
| **Vérification tests** | Non formalisé (pas d'INV-1 équivalent) | Commande exacte obligatoire (INV-1) | **SDLC : avantage décisif** |
| **Évolution du modèle** | Upgrade npm + CHANGELOG | `/sdlc-sync` + marqueur version + D-SYNC-XX | SDLC : traçabilité > npm |
| **Continuité inter-session** | Non adressé | SESSION_BRIDGE versionné | SDLC : avantage |
| **Registre décisions** | `decision-log.md` par sprint | `DECISIONS.md` global + préfixes M-ARCH/PROC | SDLC : plus structuré |
| **Coverage lifecycle** | Idéation → implémentation | Sprint → wrap-up → amélioration | **BMad : avantage décisif** |
| **Agents spécialisés** | 6 personas (BA, PM, UX, Arch, Dev, Writer) | 1 rôle configurable | **BMad : avantage décisif** |
| **Adversarial Review** | Concept documenté et intégré aux workflows | Absent | **BMad : avantage décisif** |
| **Gestion contexte large** | Document sharding, web bundles | Handoff eager/lazy, grep avant lecture | Équivalent (approches différentes) |
| **Multi-plateforme** | Claude Code, Cursor, Codex CLI | Claude Code uniquement | BMad : avantage |
| **Communauté** | 48k ⭐, Discord, YouTube, modules tiers | Usage privé / équipe restreinte | BMad : non comparable |

---

## §2 — Analyse honnête : forces et faiblesses

### 2a — Ce que BMad fait mieux

**B1 · Coverage upstream du lifecycle**
Notre modèle commence au sprint de code. BMad commence à l'idée. La chaîne
brainstorming → PRD → architecture → stories → implémentation est documentée,
progressive, et chaque phase produit un artefact consommé par la suivante.
Notre SPEC.md est une constitution statique, pas un artefact vivant de phase.

**B2 · Adversarial Review**
"Tu DOIS trouver des problèmes. Zéro finding = re-analyser." Ce pattern est absent
de notre wrap-up et de nos critères d'acceptation. Notre DoD demande si les tests
passent — pas si l'analyse a cherché activement à trouver ce qui cloche.
C'est un angle mort réel, pas théorique.

**B3 · Agents nommés avec intent-matching**
"Hey Mary, brainstormons" est plus naturel que `/retrospective`. L'agent connaît
son domaine, présente son menu, et dispatche directement si l'intention est claire.
Notre modèle demande à l'humain de connaître le nom du skill. BMad inverse ce coût.

**B4 · bmad-help contextuel**
Un skill qui sait ce qui est installé et guide l'humain sur "quoi faire maintenant".
Notre `/diagnostic` est réactif (sur incident). BMad a un guide proactif.

**B5 · Implementation Readiness Gate**
Check formel PASS/CONCERNS/FAIL (notre vocabulaire — BMad utilise READY/NEEDS WORK/NOT READY, sémantiquement équivalent) avant d'écrire la première ligne de code. Notre modèle
a une "Demande d'aval" dans l'analyse, mais elle n'est pas structurée comme un gate
explicite avec résultat binaire documenté.

**B6 · Party Mode**
Plusieurs personas en débat dans une session — Architecte, PM et Dev qui challengent
ensemble une décision. Nous n'avons aucun équivalent. Niche, mais puissant pour
les décisions techniques à fort enjeu.

**B7 · Forensic Investigation**
Workflow dédié au débogage avec findings gradués par niveau de preuve
(3 niveaux de preuve (Confirmed/Deduced/Hypothesized) × statut cycle de vie (Open/Confirmed/Refuted) — 2 axes orthogonaux). Notre `/diagnostic` liste des commandes
mais n'a pas ce modèle d'inférence.

**B8 · Scale-adaptive**
BMad ajuste la profondeur de planification à la complexité. Un bug fix ne passe pas
par PRD → architecture → stories. Notre modèle a les tailles XS/S/M/L mais le PDR
reste structurellement identique quelle que soit la taille.

---

### 2b — Ce que notre modèle fait mieux

**N1 · Hooks de sécurité (avantage décisif)**
`pre-tool-bash.sh` bloque les commandes dangereuses avant exécution — exit 2 avec
message explicite. BMad n'a aucun équivalent documenté. Sans hook, les règles
restent des recommandations que le modèle peut ignorer sous pression conversationnelle.
INV-2 (circuit fermé) n'est pas possible sans mécanisme d'enforcement.

**N2 · Mémoire de sprint avec annotations de confiance**
`sprint-memory.md` + `[CONF: HAUTE/MOY/FAIBLE]` sur les analyses + `[valide jusqu'à: condition]`
sur les décisions. BMad n'a aucun modèle de gestion d'état intra-session documenté.
Une session de 3h sans repère de confiance accumule des décisions dont le poids
est identique quelle que soit la solidité de l'analyse sous-jacente.

**N3 · Vérification exécutable (INV-1)**
Nos tests DOIVENT contenir une commande exacte. "Vérifier que X fonctionne" est
explicitement invalide comme critère de test. BMad ne formalise pas cette contrainte.
Le risque : des "tests" qui sont en réalité des affirmations non vérifiables.

**N4 · Boucle de rétroaction fermée (INV-4)**
LESSONS_LEARNED → [HOOK_CANDIDATE] → `/retrospective` → hook activé → DECISIONS.md.
Chaque observation terrain a un chemin documenté vers une règle permanente.
La rétrospective BMad est plus légère et moins outillée pour détecter les patterns récurrents.

**N5 · Traçabilité de l'évolution du modèle**
`/sdlc-sync` + marqueur `SDLC version : vX.Y` dans Claude.md et STANDARDS.md + entrée
`D-SYNC-XX`. L'upgrade BMad (`npx bmad-method@next install`) peut écraser du tuning local.
Notre approche préserve explicitement le tuning local et trace chaque décision d'alignement.

**N6 · Session Bridge et continuité inter-session**
`doc/SESSION_BRIDGE.md` versionné et accumulatif. BMad ne documente pas comment
le contexte d'une session est transmis à la suivante au-delà des artefacts git commités.

**N7 · Zéro dépendance**
Notre toolkit fonctionne avec bash + git. BMad nécessite Node.js 20+, Python 3.10+, uv.
Pour un projet Python / solo-développeur, ajouter une dépendance npm pour installer
un framework de gouvernance est une friction réelle.

**N8 · DECISIONS.md global structuré**
Notre registre de décisions couvre l'ensemble du projet avec préfixes typés (M-ARCH, M-PROC,
D-HOOK, D-SYNC). BMad génère un `decision-log.md` par workflow — moins de continuité
globale, plus de dispersion.

---

### 2c — Ce que les deux ont comme angle mort commun

**C1 · Gestion d'état multi-agents persistante**
Party Mode de BMad est mono-session. Notre modèle est mono-agent. Aucun des deux
n'adresse la coordination de plusieurs agents avec état partagé persistant.

**C2 · Intégration CI/CD**
Aucun des deux ne s'intègre aux pipelines CI/CD (GitHub Actions, etc.) pour déclencher
automatiquement des vérifications à la PR ou au commit. Tout reste manuel.

**C3 · Observabilité des tokens**
BMad documente le sharding mais ne donne pas de métriques de consommation.
Notre modèle distingue eager/lazy mais sans instrumentation non plus.

---

## §3 — Catalogue de décisions : IMPORTER / ADAPTER / ÉCARTER / SURVEILLER

### ✅ IMPORTER — bénéfice net clair, coût d'intégration faible

| Concept | Source BMad | Destination dans notre modèle | Taille |
|---------|------------|------------------------------|--------|
| **Adversarial Review** | `bmad-code-review`, ADRs, spec validation | Ajouter au §Plan de test du PDR comme étape optionnelle · intégrer en question Étape 1 du wrap-up | S |
| **Forensic Investigation (niveaux de preuve)** | `bmad-investigate` (3 niveaux de preuve (Confirmed/Deduced/Hypothesized) × statut cycle de vie (Open/Confirmed/Refuted) — 2 axes orthogonaux) | Enrichir notre skill `/diagnostic` avec une taxonomie d'inférence | S |
| **Implementation Readiness Gate** | `bmad-check-implementation-readiness` | Formaliser notre "Demande d'aval" en gate PASS/CONCERNS/FAIL (notre vocabulaire — BMad utilise READY/NEEDS WORK/NOT READY, sémantiquement équivalent) dans le PDR | XS |
| **Project Context comme "constitution"** | `project-context.md` | Notre `specs/SPEC.md` joue ce rôle mais pourrait adopter le format + l'idée de le générer depuis le code | XS |
| **ADRs dans le document d'architecture** | `bmad-create-architecture` produit `architecture.md` avec ADRs | Ajouter convention `§ADR-XX` dans notre `doc/DECISIONS.md` pour les décisions architecturales pures | XS |

---

### 🔧 ADAPTER — concept pertinent, mais notre contexte nécessite une reformulation

| Concept | Source BMad | Adaptation proposée | Risque |
|---------|------------|---------------------|--------|
| **bmad-help contextuel** | Skill qui connaît les modules installés et guide proactivement | Créer un skill `/help` dans notre SDLC qui lit le ROADMAP §Now + LESSONS_LEARNED §Index et répond "que faire maintenant ?" | Faible |
| **Scale-adaptive planning** | Ajustement automatique de la profondeur selon complexité | Différencier davantage notre PDR XS/S vs M/L : PDR allégé pour XS/S (sans §Pre-mortem, sans §Dépendances) | Faible |
| **Document sharding guidance** | How-to dédié dans la doc BMad | Ajouter une règle dans `Claude.md §Tokens` : si un fichier dépasse N lignes → fragmenter selon convention | Faible |
| **Agents nommés** | 6 personas avec domaines distincts | Adapter le §Rôle de `Claude.md` pour identifier plus explicitement le "mode" courant (dev, architecte, reviewer...) | Moyen — risque de sur-ingénierie |
| **Sprint Status YAML** | `sprint-status.yaml` généré par `bmad-sprint-planning` | Notre `ROADMAP.md` §Now pourrait adopter un format plus structuré pour les projets multi-sprints | Moyen |

---

### ❌ ÉCARTER — complexité > bénéfice dans notre contexte

| Concept | Raison d'écarter |
|---------|-----------------|
| **TOML customisation system** | Sur-ingéniérie pour solo/petit équipe. Notre SDLC-Sync couvre l'évolution sans résolveur Python. Ajouter Node.js + Python + uv comme dépendances pour gérer des overrides TOML n'est pas justifiable. |
| **Named agents avec noms hardcodés** | "Mary", "John", etc. supposent une convention partagée. Dans nos projets cibles, le rôle de Claude Code est défini par le §Rôle domaine-spécifique. Renommer les agents crée de l'indirection sans valeur. |
| **npm installer** | Notre `sdlc-init.sh` bash pur est plus simple, plus portable, sans dépendance runtime. |
| **Party Mode** | Concept séduisant mais non adressable par Claude Code seul sans orchestration externe. Risque de confusion dans les sessions. À revisiter si Claude Code évolue vers le multi-agent natif. |
| **Phases 1-3 complètes (PRD, UX, Architecture workflows)** | Notre SDLC est un méta-framework de gouvernance de sprint, pas un framework de product management. Importer les workflows PRD/UX/Architecture serait un changement de scope. Ces phases peuvent coexister séparément dans les projets qui en ont besoin. |
| **Module ecosystem (TEA, BMGD, CIS)** | Hors scope. Chaque module est un projet à part entière. |

---

### 👁 SURVEILLER — intéressant, mais trop tôt ou trop instable

| Concept | Raison de surveiller |
|---------|---------------------|
| **BMad Builder** | Créer des agents et modules custom via un framework guidé. Pertinent si nous voulons un day builder pour nos skills SDLC. À regarder en v2. |
| **Test Architect (TEA)** | Framework de test basé sur le risque, qui génère des stratégies de test. Pourrait enrichir notre taxonomie A/B/C. À suivre en parallèle. |
| **Cross-platform (Cursor, Codex)** | Si nos projets cibles évoluent vers Cursor, BMad's approach d'agnosticisme IDE est un modèle à étudier. |
| **Quick Dev track** | Piste governance-light pour les micro-tâches. Nous avons les sprints XS mais pas de fast track documenté. À formaliier si la friction du PDR devient un frein sur les XS. |
| **Forensic Investigation ← checkpoint** | Le pattern "checkpoint preview" de BMad (l'agent montre son travail progressivement avant de terminer) est intéressant pour nos sprints L. |

---

## §4 — Synthèse et recommandation

### Ce que BMad résout que nous n'avons pas besoin de résoudre
BMad est un framework de product management + implémentation. Notre toolkit est un
méta-framework de gouvernance de sprint. Ces deux périmètres sont **complémentaires**,
pas concurrents. BMad peut fonctionner dans un projet qui utilise notre SDLC comme
couche de gouvernance — ils ne s'excluent pas.

### Nos vrais différenciateurs à préserver absolument
Les trois invariants que BMad ne couvre pas et qui sont notre valeur réelle :
1. **Hooks bash** (INV-2 opérationnel) — la seule façon de rendre une règle non-négociable
2. **Sprint memory + CONF** (INV-3 étendu) — l'état de session est un artefact de première classe
3. **Boucle rétroaction fermée** (INV-4) — observations → règles permanentes avec traçabilité

Ces trois éléments ne sont pas présents dans BMad. Les préserver est non-négociable.

### Recommandation d'action immédiate (court terme)

**3 imports à faible risque, haut bénéfice :**
1. **Adversarial Review** → question optionnelle dans §Étape 1 wrap-up + champ dans PDR §Plan de test
2. **Implementation Readiness Gate** → reformuler la "Demande d'aval" en gate structuré PASS/CONCERNS/FAIL
3. **Niveaux de preuve dans `/diagnostic`** → CONFIRMED/PROBABLE/POSSIBLE sur les hypothèses de bug

**1 adaptation à moyen terme :**
4. **PDR allégé pour XS/S** → supprimer §Pre-mortem et §Dépendances si Taille ≤ S

**Ce qui ne change pas :**
Hooks, sprint-memory, INV-1/2/4, sdlc-sync, SESSION_BRIDGE — notre valeur différenciante.

---

## §5 — Questions ouvertes pour la discussion

1. **Scope du SDLC toolkit** : voulons-nous étendre vers le product lifecycle amont
   (phases PRD/architecture) ou rester sur la gouvernance de sprint ?
   → Si oui, BMad Phase 1-3 est un modèle à adapter, pas à copier.

2. **Adversarial Review** : où l'intégrer — dans le PDR §Critères d'acceptation,
   dans le wrap-up §Étape 1, ou comme skill dédié `/review` ?

3. **bmad-help** : notre projet est-il suffisamment complexe pour justifier un skill `/help`
   qui guide en temps réel plutôt qu'une documentation statique ?

4. **Named agents** : la personnalisation du §Rôle dans Claude.md est-elle suffisante,
   ou voyons-nous une valeur à formaliser plusieurs "modes" (stratège, dev, reviewer) ?

5. **Forensic Investigation** : notre `/diagnostic` actuel (liste de commandes)
   est-il suffisant, ou la taxonomie CONFIRMED/PROBABLE/POSSIBLE apporte-t-elle
   une valeur réelle dans nos projets ?

---

## §6 — Sources consultées

- `github.com/bmad-code-org/BMAD-METHOD` — README, structure, 48k+ stars
- `docs.bmad-method.org` — Welcome, Named Agents, Workflow Map, Adversarial Review, Workflow Reference
- `docs.bmad-method.org/reference/agents/` — 6 personas documentées
- Analyse des fichiers SDLC : 00-CONTEXT.md, 01-Claude-md-TEMPLATE.md (v1.8), CHANGELOG.md (v1.9), 07-DECISIONS-SDLC.md

**Limitation :** cette analyse est basée sur la documentation publique, pas sur les fichiers source
du repo cloné (`/exemples/bmad-method/src/`). Une lecture directe des skills `.md` pourrait révéler
des mécaniques non documentées (gestion d'état, enforcement de règles, gestion des tokens).
→ Le PDR `sprint-SDLC-06-bmad-spike.md` guide Claude Code pour approfondir cette lecture si nécessaire.

---
*Spike SDLC-06 · 18/06/2026 · À discuter avant tout import dans les templates*
