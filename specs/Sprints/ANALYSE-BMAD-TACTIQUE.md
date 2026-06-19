# ANALYSE-BMAD-TACTIQUE — Catalogue de patterns d'implémentation (lecture source)
<!-- Spike SDLC-06 · 18/06/2026 · Source : exemples/bmad-method/src/ (repo cloné, lecture directe des SKILL.md/steps/customize.toml) -->
<!-- Complète doc/ANALYSE-BMAD.md (analyse stratégique sur docs publiques) — ne répète pas son contenu. -->

**Note sur les chemins** : la spec du sprint référençait `/exemples/bmad-method/src/bmad-agent-*`
(absolu, structure plate). Le repo cloné réel est à `exemples/bmad-method/src/` (relatif à la racine
du toolkit) avec une structure en deux familles :
- `src/core-skills/` — skills transverses (help, party-mode, shard-doc, advanced-elicitation, reviews...)
- `src/bmm-skills/{1-analysis,2-plan-workflows,3-solutioning,4-implementation}/` — skills du module BMM (Phases 1-4)

---

## §A — Enforcement & vérification

### P-01 · HALT comme primitive d'arrêt non-négociable
**Source :** `src/bmm-skills/4-implementation/bmad-dev-story/SKILL.md` (lignes 333-335, 456-459)
**Citation :**
> `<action if="new dependencies required beyond story specifications">HALT: "Additional dependencies need user approval"</action>`
> `<action if="3 consecutive implementation failures occur">HALT and request guidance</action>`
> `<action if="definition-of-done validation fails">HALT - Address DoD failures before completing</action>`

**Ce que ça fait :** Le mot-clé `HALT` est une convention textuelle uniforme (33 fichiers `.md` sur l'ensemble du repo) qui marque un point d'arrêt strict — l'agent doit s'arrêter et attendre l'humain, quelle que soit la pression conversationnelle à continuer.
**Pourquoi c'est intéressant :** BMad n'a **aucun hook bash** (confirme N1 de l'analyse stratégique) — l'enforcement est entièrement déclaratif, dans le prompt. Notre hook `pre-tool-bash.sh` est un mécanisme plus robuste (exécution réelle, exit code), mais BMad montre qu'une convention lexicale répétée et systématique (HALT) peut structurer l'arrêt même sans hook.
**Applicable :** OUI avec adaptation
**Proposition :** Introduire le mot-clé `HALT` comme convention explicite dans `Claude.md §Règles absolues` pour les points d'arrêt *non couverts par un hook* (ex : "3 échecs consécutifs d'implémentation" n'est pas détectable par un hook bash mais l'est par convention de prompt). Complémentaire au hook, pas un remplacement.

---

### P-02 · Definition-of-Done avec interdiction explicite de mentir
**Source :** `src/bmm-skills/4-implementation/bmad-dev-story/SKILL.md` (ligne 361)
**Citation :**
> `<critical>NEVER mark a task complete unless ALL conditions are met - NO LYING OR CHEATING</critical>`
> `<action>Verify ALL tests for this task/subtask ACTUALLY EXIST and PASS 100%</action>`
> `<action>Confirm implementation matches EXACTLY what the task/subtask specifies - no extra features</action>`

**Ce que ça fait :** Une clause anti-hallucination de complétude explicite, formulée de façon volontairement crue ("NO LYING OR CHEATING"), suivie de vérifications factuelles (tests existent réellement, pas seulement "devraient passer").
**Pourquoi c'est intéressant :** Notre INV-1 ("vérification exécutable — commande exacte obligatoire") couvre le même angle mort mais formulé neutre. BMad mise sur une formulation à charge émotionnelle pour renforcer le respect de la règle — un choix de prompt engineering différent du nôtre.
**Applicable :** OUI avec adaptation
**Proposition :** Dans `01-Claude-md-TEMPLATE.md §Test`, renforcer la définition "test OK" avec une ligne explicite anti-complaisance : *"Ne jamais marquer un test OK sans avoir vu la sortie de la commande — une supposition n'est pas une vérification."* (déjà partiellement couvert par INV-1, mais sans la mise en garde directe contre l'auto-complaisance).

---

### P-03 · Rubrique SUCCESS/FAILURE METRICS en fin de step
**Source :** `src/bmm-skills/3-solutioning/bmad-check-implementation-readiness/steps/step-06-final-assessment.md` (lignes 113-126)
**Citation :**
> `## 🚨 SYSTEM SUCCESS/FAILURE METRICS`
> `### ✅ SUCCESS: All findings compiled and summarized · Clear recommendations provided...`
> `### ❌ SYSTEM FAILURE: Not reviewing previous findings · Incomplete summary · No clear recommendations`

**Ce que ça fait :** Chaque step se termine par une grille auto-évaluative listant explicitement ce qui constitue un succès vs un échec d'exécution du step — une forme de checklist de validation que l'agent applique à lui-même avant de continuer.
**Pourquoi c'est intéressant :** C'est une variante de notre "Demande d'aval" mais appliquée *à l'exécution du step lui-même*, pas seulement au résultat final. Plus granulaire — chaque étape a son propre critère d'échec, pas seulement le sprint entier.
**Applicable :** OUI avec adaptation
**Proposition :** Pour les PDR de taille L (plan d'exécution multi-étapes), ajouter une grille succès/échec par étape majeure dans `§Plan d'exécution`, pas seulement un critère global en fin de sprint.

---

### P-04 · Adversarial review en 3 couches indépendantes + triage à 4 catégories
**Source :** `src/bmm-skills/4-implementation/bmad-code-review/steps/step-02-review.md` (lignes 10-26) et `step-03-triage.md` (lignes 32-38)
**Citation :**
> `Blind Hunter — receives inline {diff_output} only. No spec, no context docs, no project access.`
> `Edge Case Hunter — receives {diff_output} and read access to the project.`
> `Acceptance Auditor (only if full) — receives {diff_output}, the content of the file at {spec_file}...`
> Triage : `decision_needed` / `patch` / `defer` / `dismiss`

**Ce que ça fait :** Trois reviewers parallèles avec accès à l'information volontairement asymétrique (un n'a *que* le diff, sans contexte — pour forcer une lecture naïve qui détecte ce que la familiarité avec le projet masque). Les findings sont ensuite fusionnés, dédupliqués, et classés dans 4 buckets actionnables.
**Pourquoi c'est intéressant :** Beaucoup plus structuré que ce que B2 (stratégique) laissait supposer — ce n'est pas juste "force-toi à trouver des problèmes", c'est une architecture à accès différencié + un pipeline de triage avec sortie actionnable. Notre wrap-up n'a aucun mécanisme de revue contradictoire, juste une question rétrospective.
**Applicable :** OUI avec adaptation
**Proposition :** Ajouter une option `/review-adversarial` (ou un mode du futur skill review) qui relit le diff du sprint **sans** le contexte de la conversation (simulé : relire uniquement `git diff`, pas le fil de discussion) avant le wrap-up, pour les sprints M/L. Classer les findings en 4 catégories type BMad plutôt qu'une liste plate.

---

### P-05 · Verdict réel de l'Implementation Readiness Gate : READY / NEEDS WORK / NOT READY
**Source :** `src/bmm-skills/3-solutioning/bmad-check-implementation-readiness/steps/step-06-final-assessment.md` (ligne 72)
**Citation :**
> `### Overall Readiness Status`
> `[READY/NEEDS WORK/NOT READY]`

**Ce que ça fait :** Statut ternaire de complétude documentaire avant implémentation.
**Pourquoi c'est intéressant — correction de l'analyse stratégique :** `doc/ANALYSE-BMAD.md` §B5 et §3 supposaient un verdict `PASS/CONCERNS/FAIL`. La lecture source montre le vrai libellé : `READY/NEEDS WORK/NOT READY`. Sémantiquement proche mais formellement différent — à corriger si ce pattern est importé.
**Applicable :** OUI directement (le concept de gate ternaire, avec le bon libellé)
**Proposition :** Reformuler la "Demande d'aval" du PDR en gate explicite à 3 états — garder notre vocabulaire `PASS/CONCERNS/FAIL` (déjà dans le plan d'action stratégique) en notant que BMad utilise `READY/NEEDS WORK/NOT READY` — les deux sont valides, le nôtre est plus court.

---

## §B — Gestion du contexte & des tokens

### P-06 · Triple stratégie de chargement par table déclarative (FULL_LOAD / SELECTIVE_LOAD / INDEX_GUIDED)
**Source :** `src/bmm-skills/4-implementation/bmad-retrospective/SKILL.md` (lignes 84-90, 229)
**Citation :**
> `| epics | ... | SELECTIVE_LOAD |`
> `| architecture | ... | FULL_LOAD |`
> `| document_project | ... | INDEX_GUIDED |`
> `For SELECTIVE_LOAD inputs, load only the epic matching {{epic_number}}. For FULL_LOAD inputs, load the complete document. For INDEX_GUIDED inputs, check the index first and load relevant sections.`

**Ce que ça fait :** Une table déclarative dans chaque SKILL.md mappe chaque type d'input à une stratégie de chargement explicite : chargement complet, chargement sélectif (un seul epic/section), ou guidé par index (lire l'index, puis seulement les sections pertinentes).
**Pourquoi c'est intéressant :** C'est une formalisation plus fine que notre distinction binaire eager/lazy. Notre `Claude.md §Tokens` distingue "immédiat" vs "différé (grep avant lecture)" — BMad ajoute un 3e mode : la lecture guidée par un index pré-généré (pertinent pour les gros documents brownfield).
**Applicable :** OUI avec adaptation
**Proposition :** Dans `Claude.md §Tokens`, ajouter explicitement le mode "index-guidé" pour `specs/SPEC.md` si ce fichier dépasse un seuil de lignes : générer/maintenir une table des matières en tête de fichier, et grep dans cette table avant de charger une section.

---

### P-07 · Seuil quantifié de délégation à un subagent (>10K tokens ou 5+ fichiers)
**Source :** `src/bmm-skills/4-implementation/bmad-investigate/SKILL.md` (lignes 44-45, 129-130)
**Citation :**
> `Delegation discipline. When a step requires reading 5+ files or any file >10K tokens, delegate to a subagent that returns structured JSON only. Cite path:line from the result; don't re-read in the parent.`
> `For any category exceeding ~10K tokens, delegate to a subagent that returns a JSON manifest (paths, sizes, time windows, key fragments cited as path:line).`

**Ce que ça fait :** Seuil numérique explicite et actionnable (pas juste "si c'est gros") pour décider quand sous-traiter une lecture à un agent séparé qui ne renvoie qu'un résumé structuré — la lecture brute ne pollue jamais le contexte parent.
**Pourquoi c'est intéressant :** Notre `Claude.md §Tokens` recommande "grep avant lecture" mais n'a pas de seuil quantifié ni de mécanisme de délégation à un sous-agent qui filtre l'information avant qu'elle n'entre dans le contexte principal. C'est un pattern d'isolation de contexte que nous n'avons pas formalisé.
**Applicable :** OUI avec adaptation
**Proposition :** Ajouter à `Claude.md §Tokens` un seuil explicite ("si lecture > 5 fichiers ou fichier individuel proche de la limite de contexte → déléguer à l'agent Explore/general-purpose qui retourne un résumé structuré, jamais le contenu brut") — formalise une pratique que Claude Code permet déjà via le tool Agent, mais que notre modèle ne rend pas explicite comme règle de sprint.

---

### P-08 · "Extract, don't ingest" — les subagents lisent, le parent assemble
**Source :** `src/bmm-skills/2-plan-workflows/bmad-prd/SKILL.md` (ligne 65)
**Citation :**
> `Extract, don't ingest. Source documents go to subagents for extraction; the parent assembles from extracts. Only load source documents into the parent context wholesale when no subagents are available.`

**Ce que ça fait :** Principe général (pas seulement pour les gros fichiers) : la règle par défaut est que les documents sources passent par un sous-agent qui en extrait l'essentiel ; le contexte principal ne voit jamais les documents bruts sauf en mode dégradé (pas de subagents disponibles).
**Pourquoi c'est intéressant :** C'est une inversion de notre défaut actuel ("lire le fichier, puis grep si trop gros") — BMad part du principe que la délégation est la norme, la lecture directe l'exception. Pour un toolkit mono-agent comme le nôtre, c'est un changement de philosophie, pas juste une règle additionnelle.
**Applicable :** NON directement (trop couplé à un existant subagent-first ; notre modèle est mono-agent par défaut), mais le principe inverse mérite réflexion
**Proposition :** Ne pas importer tel quel. Noter en `§5 Questions ouvertes` de l'analyse stratégique : faut-il que notre modèle adopte "déléguer par défaut" plutôt que "lire par défaut, déléguer en dernier recours" pour les sprints L ?

---

## §C — Boucles de rétroaction & apprentissage

### P-09 · Significant Discovery Alert — détection automatique d'invalidation du plan suivant
**Source :** `src/bmm-skills/4-implementation/bmad-retrospective/SKILL.md` (lignes 1006-1019, 1021-1042)
**Citation :**
> `<action>CRITICAL ANALYSIS - Detect if discoveries require epic updates</action>`
> Liste de 10 déclencheurs : "Architectural assumptions from planning proven wrong", "Major scope changes...", "Technical debt level unsustainable without intervention"...
> `🚨 SIGNIFICANT DISCOVERY ALERT 🚨` ... `Epic Update Required: YES - Schedule epic planning review session`

**Ce que ça fait :** Pendant la rétrospective, l'agent vérifie systématiquement une liste fermée de 10 conditions ("les hypothèses d'architecture se sont révélées fausses", "la dette technique est devenue insoutenable"...). Si une seule est vraie, un bloc d'alerte visuel impose explicitement de ne **pas** démarrer l'epic suivant sans une session de replanification.
**Pourquoi c'est intéressant :** C'est l'équivalent fonctionnel de notre `DÉCISION [valide jusqu'à : condition]` mais **proactif et automatique** plutôt que déclenché manuellement à la prochaine `/retrospective`. Chez nous, une décision invalidée n'est détectée que si quelqu'un pense à vérifier la condition. BMad la véréifie systématiquement à chaque rétro, avec une checklist fermée.
**Applicable :** OUI avec adaptation
**Proposition :** Dans `09-retrospective-SKILL-TEMPLATE.md §Étape 2 Analyse patterns`, ajouter une checklist fermée inspirée de BMad (adaptée à notre contexte : hypothèses techniques invalidées, dette devenue bloquante, dépendance externe rompue, scope dérivé...) à vérifier *systématiquement*, pas seulement sur déclaration spontanée de l'utilisateur.

---

### P-10 · Critical Readiness Exploration — check de production-readiness avant clôture
**Source :** `src/bmm-skills/4-implementation/bmad-retrospective/SKILL.md` (lignes 1113-1282)
**Citation :**
> `"Epic {{epic_number}} is marked complete in sprint-status, but is it REALLY done?"`
> Dimensions explorées : Testing & Quality, Deployment, Stakeholder Acceptance, Technical Health, Unresolved Blockers — chacune avec un dialogue qui creuse, et ajoute au "critical path" si un doute surgit.

**Ce que ça fait :** Avant de clore une rétrospective, l'agent mène un questionnement structuré sur 5 dimensions de complétude réelle (pas juste "les tâches sont cochées") : qualité/tests, déploiement, acceptation stakeholder, santé technique du code, blocages non résolus. Chaque réponse insatisfaisante devient un item de "critical path" bloquant le sprint suivant.
**Pourquoi c'est intéressant :** Notre wrap-up §0e ("Revue objectif sprint" / VERDICT ATTEINT-PARTIEL-NON ATTEINT) est plus statique — il compare critères d'acceptation vs diff git. BMad ajoute une couche orale/interactive sur des dimensions que le diff ne peut pas révéler (acceptation stakeholder, santé perçue du code, dette qui "donne mauvaise impression" sans être un bug).
**Applicable :** OUI avec adaptation
**Proposition :** Dans `03-wrap-up-SKILL-TEMPLATE.md §Étape 0e`, ajouter une checklist courte de 3-4 questions fermées (pas le dialogue complet façon BMad, juste les dimensions) : déploiement nécessaire avant le prochain sprint ? dette qui inquiète sans être bloquante ? validation utilisateur finale obtenue (si applicable) ?

---

### P-11 · `.decision-log.md` — mémoire canonique par espace de travail, pas par sprint
**Source :** `src/bmm-skills/2-plan-workflows/bmad-prd/SKILL.md` (ligne 14, 30, 85)
**Citation :**
> `.decision-log.md is canonical memory and audit trail — every decision, change, and override (including headless overrides) is recorded there as the conversation unfolds.`
> `If .decision-log.md is missing, spawn a one-time bootstrap subagent to reverse-engineer a thin log from the PRD before continuing.`

**Ce que ça fait :** Chaque "workspace" de document (un PRD en cours, par exemple) a son propre journal de décisions, créé dès l'initialisation et alimenté en continu. Si le journal est manquant lors d'une reprise (`Update` intent), un sous-agent reconstitue un journal a minima à partir du document final — dégradation gracieuse plutôt que blocage.
**Pourquoi c'est intéressant — confirme N2 avec nuance :** Notre `sprint-memory.md` est unique et global au sprint courant, détruit après wrap-up. BMad a un journal par document persistant (pas détruit), avec une procédure de reconstruction si le fichier est perdu. C'est un filet de sécurité que nous n'avons pas — si `sprint-memory.md` est supprimé accidentellement (comme observé dans le git status au début de cette session), nous n'avons aucune procédure de reconstruction a posteriori.
**Applicable :** OUI avec adaptation
**Proposition :** Ajouter à `01-Claude-md-TEMPLATE.md §Mémoire de sprint` une clause de dégradation : si `.claude/sprint-memory.md` est absent en cours de sprint (perte accidentelle) alors que le sprint est en cours, reconstruire un résumé a minima depuis `git diff` + la conversation, plutôt que de continuer sans aucune trace.

---

## §D — Formulations prompt remarquables

### P-12 · Niveaux de preuve réels : Confirmed / Deduced / Hypothesized (pas 4 niveaux)
**Source :** `src/bmm-skills/4-implementation/bmad-investigate/SKILL.md` (lignes 28-31)
**Citation :**
> `Confirmed. Directly observed; cite path:line, log timestamp, or commit hash.`
> `Deduced. Logically follows from Confirmed evidence; show the chain.`
> `Hypothesized. Plausible but unconfirmed; state what would confirm or refute it.`

**Ce que ça fait :** Taxonomie à 3 niveaux (pas 4) pour graduer la confiance d'un finding pendant une investigation forensique, complétée par un statut indépendant (`Open / Confirmed / Refuted`) qui suit l'évolution d'une hypothèse dans le temps.
**Pourquoi c'est intéressant — correction de l'analyse stratégique :** `doc/ANALYSE-BMAD.md` §B7 et §3 mentionnent `CONFIRMED/PROBABLE/POSSIBLE/SPECULATIVE` (4 niveaux) — la lecture source montre 3 niveaux de preuve (`Confirmed/Deduced/Hypothesized`) **plus** un statut de cycle de vie séparé (`Open/Confirmed/Refuted`). Ce sont deux axes orthogonaux, pas une seule échelle à 4 crans.
**Applicable :** OUI avec adaptation
**Proposition :** Si `/diagnostic` adopte une taxonomie de preuve (recommandation §3 stratégique), utiliser la formulation correcte : 3 niveaux de preuve (Confirmé / Déduit / Hypothèse) + statut indépendant (Ouvert / Confirmé / Réfuté) sur chaque hypothèse — pas la grille à 4 niveaux supposée initialement.

---

### P-13 · "Stronghold first" — ancrer l'investigation sur une preuve confirmée avant de théoriser
**Source :** `src/bmm-skills/4-implementation/bmad-investigate/SKILL.md` (lignes 32-37)
**Citation :**
> `Stronghold first. Anchor in one Confirmed piece of evidence and expand outward. Never start from a theory and hunt for support.`
> `Challenge the premise. The user's description is a hypothesis, not a fact. Verify independently; if evidence contradicts, say so.`
> `Follow the evidence, not the narrative. When evidence contradicts the working theory, update the theory — never the other way around.`

**Ce que ça fait :** Trois principes anti-biais de confirmation formulés de façon mémorable et actionnable : partir d'un fait vérifié plutôt que d'une théorie, traiter la description utilisateur comme une hypothèse à vérifier (pas une vérité de départ), et mettre à jour la théorie face à des preuves contraires plutôt que l'inverse.
**Pourquoi c'est intéressant :** Notre `/diagnostic` (mentionné dans le wrap-up comme skill réactif) n'a pas de principes anti-biais explicites. Cette formulation est directement réutilisable car elle ne dépend d'aucune mécanique BMad spécifique — c'est une discipline de raisonnement pure.
**Applicable :** OUI directement
**Proposition :** Ajouter ces 3 principes (reformulés en français) en tête du futur skill `/diagnostic` ou de `08-hooks-TEMPLATE.md` si ce skill existe déjà dans le repo cible — vérifier le sprint de référence.

---

### P-14 · Persona ultra-succincte avec vocabulaire imposé ("speaks in file paths and AC IDs")
**Source :** `src/bmm-skills/4-implementation/bmad-agent-dev/customize.toml` (ligne ~40)
**Citation :**
> `communication_style = "Ultra-succinct. Speaks in file paths and AC IDs — every statement citable. No fluff, all precision."`
> `principles = ["No task complete without passing tests.", "Red, green, refactor — in that order.", "Tasks executed in the sequence written."]`

**Ce que ça fait :** Le style de communication n'est pas juste "sois concis" — il prescrit le *type d'unité lexicale* attendue (chemins de fichiers, identifiants de critères d'acceptation) pour que chaque affirmation soit vérifiable par construction.
**Pourquoi c'est intéressant :** Notre `Claude.md` demande déjà `file_path:line_number` dans le système global (pas spécifique SDLC) — mais cette formulation BMad("every statement citable") est une règle de fond plus générale qu'on pourrait expliciter dans nos templates de rôle.
**Applicable :** OUI directement
**Proposition :** Ajouter dans `01-Claude-md-TEMPLATE.md §Rôle` une ligne : *"Toute affirmation factuelle doit être citable (chemin:ligne, commande, log) — éviter les formulations non vérifiables."*

---

## §E — Structure des skills

### P-15 · Architecture "step-file" — un seul fichier de step chargé à la fois
**Source :** `src/bmm-skills/4-implementation/bmad-code-review/SKILL.md` (lignes 66-91) et `src/bmm-skills/3-solutioning/bmad-check-implementation-readiness/SKILL.md` (lignes 19-46)
**Citation :**
> `Micro-file Design: Each step is self-contained and followed exactly`
> `Just-In-Time Loading: Only load the current step file`
> `NEVER load multiple step files simultaneously`
> `ALWAYS halt at checkpoints and wait for human input`

**Ce que ça fait :** Pour les workflows longs, BMad scinde le SKILL.md en plusieurs fichiers `steps/step-NN-nom.md` de taille contenue (~50-250 lignes chacun), chargés un par un, jamais à l'avance — explicitement interdit de "créer une todo-list mentale des steps futurs". Le SKILL.md racine ne contient que l'activation + un pointeur vers le premier step.
**Pourquoi c'est intéressant :** C'est un pattern direct de gestion de contexte token — au lieu de charger un fichier de 1000+ lignes (comme `bmad-retrospective/SKILL.md` qui lui ne suit pas ce pattern), les skills à steps multiples ne paient le coût de lecture que step par step. Notre modèle n'a pas d'équivalent : nos skills (`03-wrap-up`, `09-retrospective`) sont des fichiers uniques, longs mais relus en entier à chaque fois.
**Applicable :** OUI avec adaptation
**Proposition :** Si `03-wrap-up-SKILL-TEMPLATE.md` ou `09-retrospective-SKILL-TEMPLATE.md` continuent de grossir, envisager un découpage en fichiers `wrap-up/step-0-bilan.md`, `wrap-up/step-1-retro.md`, etc. — mais seulement si la taille devient un problème réel mesuré (actuellement 341 et 197 lignes, pas encore critique).

---

### P-16 · Activation en 6 étapes fixes et uniformes sur tous les skills
**Source :** Pattern identique répété dans `bmad-retrospective`, `bmad-dev-story`, `bmad-code-review`, `bmad-check-implementation-readiness`, `bmad-investigate`, `bmad-agent-dev` (ex. `bmad-retrospective/SKILL.md` lignes 35-76)
**Citation :**
> `Step 1: Resolve the Workflow Block` → `Step 2: Execute Prepend Steps` → `Step 3: Load Persistent Facts` → `Step 4: Load Config` → `Step 5: Greet the User` → `Step 6: Execute Append Steps`
> `Activation is complete. ... Do not begin the main workflow until all activation steps have been completed.`

**Ce que ça fait :** Une séquence d'activation strictement identique, mot pour mot, en tête de chaque skill — résolution de la config TOML mergée, chargement de faits persistants, chargement de la config projet, salutation, puis exécution de hooks "append" personnalisables — avant que le contenu métier du skill ne commence.
**Pourquoi c'est intéressant :** C'est un patron de cohérence inter-skills très fort : un utilisateur qui connaît un skill BMad sait à quoi s'attendre de tous les autres dans les 6 premières étapes. Notre modèle n'a pas cette uniformité — chaque skill (`wrap-up`, `retrospective`) a sa propre structure d'entrée.
**Applicable :** OUI avec adaptation (sans le système TOML, écarté en §3 stratégique)
**Proposition :** Si nous créons de nouveaux skills SDLC à l'avenir, adopter un en-tête uniforme minimal : "1) Lire sprint-memory.md si présent, 2) Lire spec sprint, 3) Confirmer périmètre, 4) Exécuter" — formaliser la même prévisibilité sans le mécanisme de merge TOML.

---

## §F — Autres patterns

### P-17 · Dégradation gracieuse systématique si le script Python échoue
**Source :** Répété dans tous les SKILL.md, ex. `bmad-retrospective/SKILL.md` (lignes 39-47)
**Citation :**
> `If the script fails, resolve the workflow block yourself by reading these three files in base → team → user order and applying the same structural merge rules as the resolver: ...`

**Ce que ça fait :** Chaque dépendance à un script externe (`resolve_customization.py`) est accompagnée d'instructions explicites pour que l'agent reproduise manuellement la même logique si le script n'est pas disponible — jamais un simple "si ça échoue, arrête-toi".
**Pourquoi c'est intéressant :** Notre modèle bash pur n'a pas cette classe de problème (pas de script externe requis pour interpréter nos templates), mais le principe — "documenter explicitement le chemin de repli, pas seulement le chemin heureux" — est une discipline de rédaction de skill transférable.
**Applicable :** NON directement (notre dépendance Python n'existe pas), mais le principe de rédaction est à retenir
**Proposition :** Aucune action template — noter le principe rédactionnel pour les futurs skills SDLC qui dépendraient d'un outil externe (ex. si `/diagnostic` venait à dépendre d'un script).

---

### P-18 · Le sharding documentaire passe par un outil externe, pas par l'agent
**Source :** `src/core-skills/bmad-shard-doc/SKILL.md` (ligne 40)
**Citation :**
> `Execute command: npx @kayvan/markdown-tree-parser explode [source-document] [destination-folder]`

**Ce que ça fait :** Le découpage de gros documents en sections est délégué à un outil CLI tiers (Node.js), pas réalisé par l'agent lui-même qui découperait "à la main".
**Pourquoi c'est intéressant :** Confirme l'écart stratégique déjà noté (N7 — zéro dépendance) : même une fonctionnalité simple comme le sharding markdown introduit une dépendance npm. Pour notre toolkit bash-only, ce n'est pas transférable tel quel, mais le sharding lui-même (concept) reste pertinent pour `specs/SPEC.md` si ce fichier grossit trop.
**Applicable :** NON (dépendance npm écartée en §3 stratégique) — mais le besoin métier (sharding) reste valide
**Proposition :** Si `specs/SPEC.md` dépasse un seuil de lignes, le découper manuellement par `##` de niveau 2 (équivalent du résultat de `markdown-tree-parser`) sans outil externe — un script `sed`/`awk` simple suffit pour notre cas d'usage, pas besoin de la dépendance.

---

### P-19 · Roster d'agents déclaré dans module.yaml, persona complète dans customize.toml séparé
**Source :** `src/bmm-skills/module.yaml` (lignes 41-50) et `src/bmm-skills/4-implementation/bmad-agent-dev/customize.toml`
**Citation :**
> `# Agent roster — essence only. External skills (party-mode, retrospective, advanced-elicitation, help catalog) read these descriptors to route, display, and embody agents. Full persona and behavior live in each agent's customize.toml.`

**Ce que ça fait :** Séparation stricte entre le "roster" (liste légère : code, nom, titre, icône, équipe, description — utilisée pour le routage et l'affichage) et la persona complète (rôle, identité, style, principes, menu — dans un fichier séparé par agent). Cela permet à des skills transverses (`bmad-help`, `bmad-party-mode`) de lister tous les agents sans charger leur persona complète.
**Pourquoi c'est intéressant :** C'est un autre exemple du même principe de chargement sélectif (cf. P-06/P-07) appliqué à la définition des agents eux-mêmes plutôt qu'aux documents produits. Notre modèle a un seul rôle (pas de roster), donc moins directement applicable, mais le principe de séparation "résumé léger pour routage" vs "détail complet pour exécution" est généralisable.
**Applicable :** NON (notre modèle n'a pas de roster d'agents — écarté en §3 stratégique "Named agents avec noms hardcodés")
**Proposition :** Aucune action template. Noter pour `§5 Questions ouvertes` (stratégique) : si nous formalisons des "modes" (stratège/dev/reviewer comme évoqué en Q4 stratégique), appliquer ce principe de séparation résumé/détail plutôt que tout charger en permanence.

---

## Top 5 patterns à discuter en priorité

Classés par impact/effort (impact = bénéfice perçu pour notre modèle, effort = coût d'intégration) :

| Rang | Pattern | Impact | Effort | Pourquoi en priorité |
|------|---------|--------|--------|----------------------|
| 1 | **P-09 — Significant Discovery Alert** | Élevé | Faible | Détection automatique d'invalidation de plan — angle mort réel de notre `/retrospective` actuel, qui dépend de la mémoire humaine pour vérifier les conditions `valide jusqu'à`. Checklist fermée = coût d'ajout minime. |
| 2 | **P-07 — Seuil quantifié de délégation subagent (>10K tokens / 5+ fichiers)** | Élevé | Faible | Formalise une pratique déjà permise par Claude Code (tool Agent) mais jamais rendue explicite comme règle dans `Claude.md §Tokens`. Un seuil chiffré est plus actionnable que notre "grep avant lecture" qualitatif. |
| 3 | **P-04 — Adversarial review en 3 couches + triage 4 catégories** | Élevé | Moyen | Comble un angle mort identifié dans l'analyse stratégique (B2) avec un mécanisme concret et reproductible (accès asymétrique + triage), pas juste "pose la question en wrap-up". Effort moyen car nécessite de définir notre propre triple-lecture. |
| 4 | **P-10 — Critical Readiness Exploration (5 dimensions)** | Moyen | Faible | Notre wrap-up §0e vérifie déjà l'objectif vs diff git, mais pas les dimensions hors-code (déploiement, acceptation, perception de dette). Ajout de 3-4 questions fermées, pas un dialogue complet. |
| 5 | **P-11 — Dégradation gracieuse de la mémoire de sprint** | Moyen | Faible | Cette session même a démarré avec `.claude/sprint-memory.md` supprimé sans procédure de reconstruction — incident réel, pas théorique. BMad a un filet de sécurité (`.decision-log.md` reconstruit par sous-agent) que nous n'avons pas formalisé. |

**Corrections factuelles à reporter dans `doc/ANALYSE-BMAD.md` si cette analyse tactique est validée :**
- P-05 : verdict readiness gate = `READY/NEEDS WORK/NOT READY`, pas `PASS/CONCERNS/FAIL`
- P-12 : grading investigation = `Confirmed/Deduced/Hypothesized` (3 niveaux) + statut `Open/Confirmed/Refuted` séparé, pas une échelle unique à 4 niveaux

---
*Spike SDLC-06 · 18/06/2026 · 19 fiches P-XX · Lecture source `exemples/bmad-method/src/` · À discuter avant tout import dans les templates*

---
**Clôture — 18/06/2026**
13/19 patterns traités (SDLC-07, SDLC-08, SDLC-09). 6 patterns restants
(P-08, P-15 à P-19) migrés vers `doc/ROADMAP.md §Later` avec déclencheurs —
voir ce fichier pour leur suivi futur, pas celui-ci.
Catalogue Spike SDLC-06 clos.
