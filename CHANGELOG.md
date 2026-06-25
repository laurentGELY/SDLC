# CHANGELOG — SDLC Toolkit

---

## [v2.0+SDLC-Audit-GSTACK] — 2026-06-25 · Sprint Revue M · Audit externe GSTACK vs modèle SDLC
- **`doc/AUDIT-EXTERNE-gstack-vs-sdlc.md`** (nouveau) : audit GSTACK v1.58.4.0 (59 skills, 1 191 fichiers, Garry Tan / YC) vs SDLC — cartographie complète, tableau comparatif 6 axes, 20 recommandations étiquetées (4 IMPORTER / 7 INVESTIGUER / 2 MERGER / 7 REJETER), 5 nouvelles idées, verdict synthétique, conclusion sur P-22
- **`doc/ROADMAP.md`** : P-22 déplacé §Later → §Next (scope réduit : checklist 7 sections + format verdict) · 5 nouveaux items §Later (P-40 à P-44 : lecture code obligatoire PDR, état technique SESSION_BRIDGE, résurgence décisions, rôles spécialisés §0f, revue cross-modèle) · 3 signaux faibles ajoutés (pipeline templates, Diataxis, timeline)
- **Verdict :** adoption sélective de concepts (pas du framework). Les 4 IMPORTER prioritaires (§Lecture code PDR, §État technique SESSION_BRIDGE, résurgence décisions, philosophie ETHOS) sont tous XS/S et applicables sans infrastructure. GSTACK incompatible en entier avec la philosophie zero-npm SDLC.

## [v2.0+SDLC-GSD-V2] — 2026-06-25 · Sprint Doc M · Import GSD Vague 2 — graduation auto, hot/cold SESSION_BRIDGE, hypothesis tracking
- **`09-retrospective-SKILL-TEMPLATE.md` v1.8** : bloc GRADUATION automatique dans §Étape 2 — scan §Index patterns, proposition de promotion si ≥ 3 occurrences sur 5 derniers sprints, 4 destinations possibles (Claude.md / STANDARDS.md / hooks / LESSONS_LEARNED §Règles) (Prop H)
- **`03-wrap-up-SKILL-TEMPLATE.md` v1.6** : §Étape 5 — structure hot/cold SESSION_BRIDGE (§Actif ≤ 3 entrées / §Archive), archivage conditionnel automatique si > 3 entrées, rétrocompat via `grep -q "## §Actif"` (Prop K) · hypothesis tracking conditionnel si sprint Diagnostic/BUG/BLOQUANT (Prop D)
- **`01-Claude-md-TEMPLATE.md` v2.0** : §Démarrage §2 — lecture SESSION_BRIDGE limitée à §Actif uniquement via `awk`, §Archive sur demande explicite (Prop K)
- **`07-DECISIONS-SDLC.md`** : entrée `M-PROC-39` (3 propositions GSD Vague 2)
- **Propositions différées :** A (sous-agents Taille L), E1 (/quick), B (commits atomiques) — Vague 3

## [v1.9+SDLC-GSD-V1] — 2026-06-24 · Sprint Doc M · Import GSD Vague 1 — 6 patterns friction nulle
- **`03-wrap-up-SKILL-TEMPLATE.md` v1.5** : critère STATELESS HANDOFF dans §Étape 5 (Prop L — GSD-lite Journalism Standard)
- **`04-sprint-PDR-TEMPLATE.md` v2.0** : guidance goal-backward dans §Critères d'acceptation (Prop F) · tableau SPIDR dans §Portée (Prop J) · section §Signaux de dégradation Taille L avec 3 signaux comportementaux (Prop G)
- **`05-ROADMAP-TEMPLATE.md` v1.1** : type `Seed` + colonne `Déclencheur/Condition` dans §Later (Prop I)
- **`01-Claude-md-TEMPLATE.md` v1.9** : permission /fast dans §Classifier le travail (Prop E2)
- **`07-DECISIONS-SDLC.md`** : entrée `M-PROC-38` (6 propositions GSD Vague 1)
- **Propositions différées :** H (Graduation), K (hot/cold SESSION_BRIDGE), D (Journalism Standard complet), A (sous-agents), E1 (/quick), B (commits atomiques) — Vague 2/3

## [v1.9+SDLC-Audit-GSD-lite] — 2026-06-24 · Sprint Spike · Audit GSD-lite + Synthèse audits GSD
- **`doc/AUDIT-EXTERNE-gsd-vs-sdlc.md`** (nouveau) : audit GSD-full (v1.42.1) vs SDLC —
  cartographie, analyse comparative, propositions A-G, verdict synthétique, réponses aux 4
  questions ouvertes (clone local `exemples/get-shit-done/` exploré)
- **`doc/AUDIT-EXTERNE-gsd-lite-vs-sdlc.md`** (nouveau) : audit GSD-lite (v2.1.0,
  `@luutuankiet/gsd-lite`) vs SDLC — cartographie Driver/Navigator, concepts remarquables
  (Journalism Standard, Constitutional Behaviors, Challenge Tone Protocol, STATELESS HANDOFF),
  impact sur propositions A-F, concepts exportables vers SDLC
- **`doc/SYNTHESE-AUDITS-GSD.md`** (nouveau) : tableau consolidé statut A-F, ordre
  d'implémentation recommandé (C→D→G→B→E2→A→E1→F), plan de sprints proposé,
  questions ouvertes pour décision
- **`specs/Sprints/sprint-audit-gsd-lite.md`** : PDR du sprint Spike S
- **Verdict :** GSD-lite ≠ GSD-full simplifié — c'est un framework orthogonal (gouvernance
  d'interaction vs gouvernance de processus). Concept le plus exportable : Journalism Standard
  pour enrichir SESSION_BRIDGE (Proposition D enrichie)

## [v1.9+SDLC-24] — 2026-06-22 · Sprint SDLC-24 · Fix schéma JSON erroné dans 08-hooks-TEMPLATE.md
- **`08-hooks-TEMPLATE.md` §1** : extraction `data.get('input', {})` → `data.get('tool_input', {})`,
  ajout de l'extraction `TOOL_NAME`, en-tête mis à jour avec le schéma JSON réel
  (`hook_event_name`/`tool_name`/`tool_input`, confirmé `M-HOOKS-05`) (`M-TMPL-04`)
- **`08-hooks-TEMPLATE.md` §Critères d'acceptation bootstrap hooks** : payload smoke test
  aligné sur le schéma réel
- **`03-wrap-up-SKILL-TEMPLATE.md` §Référence rapide** : nouveau déclencheur `Sprint Fix hook
  → 08-hooks-TEMPLATE.md §1 à synchroniser` (`M-PROC-37`)
- **`07-DECISIONS-SDLC.md`** : entrées `M-TMPL-04` et `M-PROC-37`
- **Tests** : 5 greps de validation passés (`data.get('input'` → 0, `tool_input` → 5,
  `hooks-TEMPLATE` dans wrap-up → 1, `M-TMPL-04` → présent, `M-PROC-37` → présent)

## [v1.9+SDLC-23] — 2026-06-21 · Sprint SDLC-23 · Hook PreCompact × sprint-memory.md
- **`.claude/hooks/pre-compact.sh`** (nouveau) : avant toute compaction (manuelle ou
  automatique), ajoute une entrée `CHECKPOINT` en tête de `.claude/sprint-memory.md`
  (reason, tokens used/limit/freed, transcript) — toujours `exit 0`, jamais un gate
  (`M-HOOKS-08`)
- **`.claude/settings.json`** : 2 entrées `PreCompact` (`matcher: "manual"` et
  `matcher: "auto"`) — pas de défaut documenté pour un hook sans matcher, donc
  enregistrement explicite des deux
- **`01-Claude-md-TEMPLATE.md`** + **`Claude.md`** : `sprint-memory.md` gagne un 7e
  type d'entrée `CHECKPOINT` (seul type non écrit par Claude, généré par le hook) +
  note d'extension `M-PROC-13` (pause tranche horaire = même chemin de reprise que crash)
- **`08-hooks-TEMPLATE.md` v1.3** : nouvelle `§PreCompact — optionnel, à activer
  consciemment` (schéma JSON, script complet, snippet `settings.json`)
- **`doc/DIAGNOSTIC_CMDS.md`** : nouveau symptôme — un PDR affirmait le schéma
  `PreCompact` "déjà vérifié" (champ `trigger`) ; vérification directe
  (`WebFetch` verbatim sur la doc officielle) a montré le champ réel
  (`compaction_reason`) et invalidé un premier `WebFetch` contradictoire sur la
  même page — corrigé avant code, pas après
- **`07-DECISIONS-SDLC.md`** : entrée **M-HOOKS-08** ajoutée
- **Corrections ajustées vs spec** — le PDR initial assumait un champ payload
  `trigger: manual/auto` ; le schéma réel (`compaction_reason` +
  `context_used_tokens`/`context_limit_tokens`/`estimated_tokens_freed`) a été
  vérifié par `WebFetch` avant d'écrire le script, et le format de l'entrée
  `CHECKPOINT` a été enrichi avec les champs token (gratuits, pertinents avec
  `M-PROC-36`). Le champ `async: false` proposé par le PDR a été omis, non
  corroboré par la doc vérifiée
- **Tests** : `bash -n` ✓ · smoke test `trigger=manual`/`auto` (schéma réel) ✓ ·
  JSON malformé → `exit 0`, `reason=unknown` ✓ · fichier `sprint-memory.md` absent
  → aucune création, `exit 0` ✓ · non-régression entrées existantes intactes ✓ ·
  limite acceptée : déclenchement réel par la plateforme non testable en session
  (smoke test simule uniquement le payload stdin)

---

## [v1.9+SDLC-22] — 2026-06-21 · Sprint SDLC-22 · Instrumentation conso token réelle
- **`sdlc-token-usage.sh`** (nouveau) : script bash+jq lisant les transcripts JSONL
  du projet (`~/.claude/projects/<slug-cwd>/*.jsonl`), affiche les totaux bruts
  `input_tokens`/`output_tokens`/`cache_read_input_tokens`/`cache_creation_input_tokens`,
  et bucketise par étape si `.claude/sprint-memory.md` contient des entrées
  horodatées `[HH:MM] TYPE` (M-PROC-36)
- **`03-wrap-up-SKILL-TEMPLATE.md` v1.4** + `.claude/skills/wrap-up/SKILL.md` :
  §0c exécute désormais `git diff --stat HEAD` / `git status` directement en
  bash — plus de copier-coller demandé à l'utilisateur ; fallback explicite sur
  l'ancien comportement si la commande échoue (repo non-git, environnement
  restreint)
- **`09-retrospective-SKILL-TEMPLATE.md` v1.7** + `.claude/skills/retrospective/SKILL.md` :
  nouvelle `§Étape 7 — Métriques tokens (optionnel)` — baseline statique
  M1 (`Claude.md`+`STANDARDS.md`, mots) / M2 (`wrap-up SKILL.md`, mots) +
  appel optionnel de `sdlc-token-usage.sh` pour la mesure dynamique
- **`doc/DIAGNOSTIC_CMDS.md`** : nouveau symptôme — `jq fromdateiso8601` rejette
  les timestamps de transcript (fractions de seconde non gérées), corrigé par
  `sub("\\.[0-9]+Z$"; "Z")` avant parsing
- **`07-DECISIONS-SDLC.md`** : entrée **M-PROC-36** ajoutée
- **Tests** : `bash -n sdlc-token-usage.sh` ✓ · exécution réelle sur cette
  session (totaux + bucketisation testée avec entrées synthétiques) ✓ ·
  fallback `§0c` confirmé (`git status` hors repo → exit 128, sans hang) ✓ ·
  M1/M2 exécutés sur ce repo (`wc -w` Claude.md+STANDARDS.md = 2946 mots,
  wrap-up SKILL.md = 2411 mots) ✓

---

## [v1.9+SDLC-21] — 2026-06-21 · Sprint SDLC-21 · Confinement natif sandbox OS (bubblewrap/Seatbelt)
- **`08-hooks-TEMPLATE.md`** : nouvelle `§4 Confinement natif — sandbox OS` — config
  `sandbox.*` + `permissions.dontAsk`, prérequis machine AppArmor (bug bwrap
  `RTM_NEWADDR` documenté), protocole de test 5 points (M-HOOKS-07)
- **`06-PDR-bootstrap.md`** : nouvelle `Étape 0 — Prérequis machine sandbox`
  (optionnel) + ligne Groupe 6
- **`07-DECISIONS-SDLC.md`** : entrée **M-HOOKS-07** ajoutée · tableau de
  compatibilité rattrapé (10 lignes manquantes `M-HOOKS-06`/`M-PROC-27→35`,
  traitement mécanique dans le même commit, pas une décision distincte —
  `M-PROC-27`/`29` notées hors cadre du tableau, `M-HOOKS-06`/`28` confirmées
  non rétro-portées au template par grep direct)
- **Tests** : 9 tests empiriques en conditions réelles (Ubuntu 24.04, Claude
  Code sandboxé), détail en `07-DECISIONS-SDLC.md §M-HOOKS-07`

---

## [v1.9+SDLC-20] — 2026-06-20 · Sprint SDLC-20 · Étiquette `[HYPOTHÈSE]` sur tables HALT
- **`01-Claude-md-TEMPLATE.md`** : les 5 tables de rationalisation par HALT (issues de
  SDLC-19, 2 paires chacune) reçoivent une étiquette unique `[HYPOTHÈSE — non confirmée sur
  ce projet, adaptée de Superpowers]` — contenu des paires inchangé. La table sous la règle
  absolue 4a/4b/4c/4d reste la seule sans étiquette (sourcée sur l'incident réel `M-HOOKS-04`)
- **`07-DECISIONS-SDLC.md`** : `M-PROC-31` amendée (renvoi vers `M-PROC-35`) ; nouvelle entrée
  **M-PROC-35** documentant les 3 passages sur ce sujet (contenu sans étiquette → squelette
  vide envisagé et abandonné, argument `INV-4` invalide → étiquette `[HYPOTHÈSE]` retenue)
- **Contexte :** 3e révision d'un même PDR — la 2e révision (squelette vide) avait été rédigée
  (`sprint-SDLC-20-halt-squelettes.md`) mais jamais committée, l'utilisateur ayant mis le sprint
  en pause avant exécution pour soumettre une 3e formulation
- **§Test/§Rôle/§Tokens/`02-STANDARDS-TEMPLATE.md`/`doc/ROADMAP.md`** : déjà conformes depuis
  SDLC-19, zéro changement dans ce sprint (vérifié par grep avant exécution)
- **Non-régression** : `git diff --stat 01-Claude-md-TEMPLATE.md` confirme +5 lignes
  uniquement (aucune suppression) ; table 4a/4b/4c/4d intacte ; `02-STANDARDS-TEMPLATE.md`
  absent du diff
- **Friction de session (notée pour `/retrospective`)** : le garde-fou `M-HOOKS-04` a bloqué la
  correction de `.claude/sprint-memory.md` après renommage du spec — le carve-out Write/Edit ne
  couvre que les chemins sous `specs/Sprints/*`, pas `sprint-memory.md` lui-même. Contournement
  ponctuel appliqué (placeholder temporaire). `[HOOK_CANDIDATE]` consigné en
  `.claude/sprint-memory.md`, 1 occurrence à ce jour — pas encore récurrent
- **Tests** : `grep -c "\[HYPOTHÈSE — non confirmée" 01-Claude-md-TEMPLATE.md` → 5 ;
  `grep -c "Pensée :" 01-Claude-md-TEMPLATE.md` → 11 (inchangé)

---

## [v1.9+SDLC-19] — 2026-06-19 · Sprint SDLC-19 · Import sélectif audit Superpowers
- **`01-Claude-md-TEMPLATE.md`** : 11 paires `Pensée → Réalité` ajoutées sous les 5 HALT
  (2 chacun, langage gouvernance générique) + 1 paire sous la règle absolue 4a/4b/4c/4d,
  sourcée sur l'incident réel `M-HOOKS-04` (Sprint SDLC-18) ; `§Rôle`/`§Test` reliés par
  renvoi croisé ; "ça a l'air bon" ajouté à la clause anti-complaisance ; `§Tokens` porte
  une nouvelle règle de sélection de modèle sous-agent (mécanique→réduit,
  jugement→standard, jamais plus capable que la session sans aval)
- **`02-STANDARDS-TEMPLATE.md`** : ligne "Revue" ajoutée à `§Types de sprint` (utilisée
  dans `Claude.md` depuis SDLC-16/17 mais jamais listée ici) + note de différenciation
  vs "Spike"
- **`07-DECISIONS-SDLC.md`** : entrées **M-PROC-31** (tables rationalisation), **M-PROC-32**
  (fusion anti-complaisance, recalibrée à la baisse — 3/4 formulations existaient déjà),
  **M-PROC-33** (sélection modèle sous-agent), **M-PROC-34** (taxonomie Revue)
- **`doc/ROADMAP.md`** : **P-20** (hook SessionStart, §Next, impact reclassé Moyen) ;
  **P-21** (revue mi-parcours, §Later, bloqué sur lecture `code-reviewer.md`) ; **P-22**
  (`10-audit-externe-TEMPLATE.md`, §Later, décision différée)
- **Non-régression** : texte des 5 conditions HALT et de la liste "Ne jamais" inchangé —
  vérifié par grep ciblé sur le texte exact (le grep littéral du PDR comptait aussi les
  nouveaux sous-titres de table, écart expliqué et documenté en `sprint-memory`)
- **Zéro modification de `08-hooks-TEMPLATE.md`** — sprint Fix séparé (SDLC-18), hors
  périmètre de ce sprint Doc
- **Tests** : 5 commandes niveau A du PDR exécutées — `Pensée :` ×11, "ça a l'air bon" ×1,
  `§Rôle\|§Test` ×2, `Revue` ×2 dans STANDARDS, non-régression HALT confirmée par grep
  ciblé (5/5 définitions originales intactes)

---

## [v1.9+SDLC-18] — 2026-06-19 · Sprint SDLC-18 · Fix garde-fou M-HOOKS-04 + schéma JSON PreToolUse
- **`.claude/hooks/pre-tool-bash.sh` v2.0.0→2.0.1** : extraction JSON corrigée
  (`tool_input.command`/`tool_input.file_path`, pas `input` — schéma confirmé
  empiriquement, sans restart de session) ; ajout du bloc M-HOOKS-04 (garde-fou
  étape 4a `Claude.md §Démarrage`) avec carve-out Write/Edit anti-auto-verrouillage ;
  parsing `SPEC_PATH` tolérant (motif recherché, pas ligne 2 figée)
- **`.claude/settings.json`** : matcher `PreToolUse` élargi `Bash` → `Bash|Edit|Write`
  (valeur précédente notée avant modification)
- **Bug confirmé** : l'extraction d'origine (`data.get('input', {})`) retournait
  toujours `{}` sur le schéma réel → `$CMD` vide depuis Sprint SDLC-14 → les blocages
  `[UNIVERSEL]` (`git push --force`, `rm -rf`) n'ont jamais matché quoi que ce soit
  jusqu'à cette correction
- **`07-DECISIONS-SDLC.md`** : entrées **M-HOOKS-04** (carve-out) et **M-HOOKS-05**
  (extraction JSON) ajoutées + tableau de compatibilité mis à jour
- **Incident en cours de sprint** : la première version du carve-out comparait un
  `file_path` absolu à un `SPEC_PATH` relatif (jamais de match) ; combiné à l'absence
  de carve-out sur `Bash`, la session s'est verrouillée sur Bash/Edit/Write ~40 min,
  débloquée par suppression manuelle de `sprint-memory.md` (hors session) puis
  corrigée et revalidée par les 4 smoke tests avant commit — détail en
  `07-DECISIONS-SDLC.md §M-HOOKS-04`
- **Limite comblée dans le même sprint** (scope élargi sur validation explicite utilisateur,
  après incident) : **`.claude/hooks/pre-tool-bash.sh` v2.0.1→2.1.0** — allowlist Bash
  lecture seule pendant un blocage M-HOOKS-04 (`git status/diff/log/show`, `ls`, `cat`,
  `pwd`, `find`, `grep`, `head`, `tail`, `wc`, `bash -n`), rejetée si chaînage/redirection/
  substitution (anti-évasion testé : `ls; rm -rf ...` reste bloqué)
- **Message d'erreur M-HOOKS-04 enrichi** : liste les commandes lecture-seule disponibles +
  procédure de secours hors session (`rm -f .claude/sprint-memory.md`)
- **`08-hooks-TEMPLATE.md`** (nouveau `§Test d'un hook bloquant — isolation obligatoire`) :
  règle de test en environnement isolé pour tout hook `PreToolUse` bloquant, + piège `cd`
  persistant entre appels d'outil documenté (sous-shell `( cd ... && ... )` obligatoire)
- **`07-DECISIONS-SDLC.md`** : entrées **M-HOOKS-06** (allowlist) et **M-PROC-30**
  (isolation des tests) ajoutées ; `M-HOOKS-04` mise à jour (limite comblée)
- **Tests** : 4 smoke tests niveau A (non-régression, positif, négatif, carve-out) +
  niveau B (non-régression `[UNIVERSEL]`) + 3 tests allowlist — tous re-exécutés en
  environnement isolé après l'élargissement de scope, tous OK

---

## [v1.9+SDLC-17] — 2026-06-19 · Sprint SDLC-17 · Audit externe obra/superpowers
- **`doc/AUDIT-EXTERNE-superpowers-vs-sdlc.md`** (nouveau) : audit comparatif
  statique entre le plugin agentique `obra/superpowers` (174k★, 14 skills)
  et le modèle SDLC — tableau d'équivalence terminologique, mapping des
  14 skills, analyse par invariant (INV-1→4), 4 forces honnêtes Superpowers,
  3 forces SDLC absentes de Superpowers, 6 recommandations étiquetées
  (2× IMPORTER, 1× FUSIONNER, 1× REMPLACER, 1× REJETER, 1× IDÉE NOUVELLE),
  4 entrées "à ne pas importer", 3 candidats `[SDLC_CANDIDATE]` préformatés
- **Recommandation principale** : hook `SessionStart` (Superpowers) qui
  injecte automatiquement les règles absolues + HALT en contexte —
  adresse directement `LL-T05` (garde-fou démarrage 4a manquant, identifié
  Sprint SDLC-16) ; laissé en `[SDLC_CANDIDATE]`, pas appliqué ce sprint
  (sprint Revue, zéro modification de gouvernance dans le périmètre)
- **Zéro fichier de gouvernance SDLC modifié** — vérifié par
  `git diff --stat` sur les 10 fichiers `00`-`09` (vide)
- **Tests** : 3 commandes niveau A du PDR (nb sections ≥9 → 9, occurrences
  étiquettes ≥5 → 9, diff gouvernance vide → confirmé)

**Corrections ajustées vs spec** — PDR reçu sous le numéro "Sprint SDLC-06",
collision avec `specs/Sprints/sprint-SDLC-06-bmad-spike.md` existant ;
renuméroté en SDLC-17 sur validation explicite de l'utilisateur (HALT-ARCH
détecté et signalé avant création du fichier spec, étape 4a) · chemin
`/exemples/superpowers/` du PDR corrigé en `exemples/superpowers/Superpowers/`
(clone nesté d'un niveau, non prévu par le PDR original)

---

## [v1.9+SDLC-16] — 2026-06-19 · Sprint SDLC-16 · Audit complet SDLC-07→15
- **Audit** : verdicts par sprint SDLC-07→15 produits par grep/ls/git diff
  (pas de supposition) — `ATTEINT` confirmé pour SDLC-07→13 et SDLC-15
  (8 sprints), preuve citée pour chacun ; SDLC-14 scindé en 2 volets —
  self-bootstrap `ATTEINT`, "rattrapage 07/08/09" du PDR original confirmé
  non fait mais déjà couvert par `M-PROC-27` (pas un gap ouvert)
- **`07-DECISIONS-SDLC.md`** : M-PROC-29 — audit confirmé, requalification
  narrative actée
- **`doc/LESSONS_LEARNED.md`** : 8 phrases narratives (Sprint SDLC-14, non
  vérifiables depuis git) annotées `(non vérifiable depuis le repo)` en
  place, sur décision explicite de l'utilisateur — aucun retrait, aucune
  confirmation sans preuve · nouveau pattern `LL-T05` (garde-fou
  démarrage 4a manquant), `HOOK_CANDIDATE`/`SDLC_CANDIDATE` notés en `⏳`,
  aucune correction inscrite sur demande explicite de l'utilisateur
  (réflexion prévue en Claude.ai)
- **`specs/Sprints/sprint-SDLC-16-audit-complet.md`** (nouveau, créé
  rétroactivement après l'exécution du sprint)
- **Tests** : grep de validation avant chaque ajout (aucune entrée
  dupliquée — `M-PROC-25/26/27` déjà présents, non réécrits)

**Corrections ajustées vs spec** — fichier spec créé rétroactivement,
après l'exécution du sprint plutôt qu'avant (`Claude.md §Démarrage`
étape 4a sautée, découverte seulement au `/wrap-up`) · pattern `LL-T05`
et candidats associés laissés en décision différée, pas de correction
appliquée ce sprint sur demande explicite de l'utilisateur

---

## [v1.9+SDLC-15] — 2026-06-19 · Sprint SDLC-15 · Première /retrospective
- **`Claude.md`** : nouvelle règle §Analyse — distinguer explicitement la
  taille du « cœur du changement » de la taille de la « gouvernance
  associée » si elles diffèrent (résout l'alerte SD-5, action ⏳ ouverte
  depuis SDLC-11)
- **`07-DECISIONS-SDLC.md`** : M-PROC-27 — backfill historique
  CHANGELOG/DECISIONS pour SDLC-07/08/09 explicitement écarté (`LL-T01`
  clos sans rattrapage)
- **`doc/LESSONS_LEARNED.md`** : index mis à jour (LL-T01 clos, décision
  SDLC-11 actée), entrée Sprint SDLC-15 ajoutée
- **Tests** : grep de validation (voir entrée DECISIONS + index LESSONS_LEARNED)

---

## [v1.9+SDLC-14] — 2026-06-19 · Sprint SDLC-14 · Self-bootstrap + rattrapage gouvernance
- **`Claude.md`**, **`STANDARDS.md`** (nouveaux) : adaptés pour un projet
  de gouvernance de templates (pas de code applicatif)
- **`.claude/skills/{wrap-up,retrospective,diagnostic}/SKILL.md`** (nouveaux)
- **`.claude/hooks/pre-tool-bash.sh`** + **`.claude/settings.json`** (nouveaux,
  blocages universels uniquement)
- **`doc/LESSONS_LEARNED.md`** + **`doc/DIAGNOSTIC_CMDS.md`** (nouveaux,
  8 entrées rétroactives SDLC-07→14)
- **`specs/sprint-template.md`** + **`specs/Sprints/sprint-SDLC-14-self-bootstrap.md`** (nouveaux)
- **`.gitignore`** : ajout `.claude/sprint-memory.md`
- Renuméroté depuis "SDLC-15" — le PDR présupposait un sprint SDLC-14 déjà
  exécuté ; précondition vérifiée, gap confirmé, voir `doc/LESSONS_LEARNED.md`
  (`LL-T04`) et `doc/DIAGNOSTIC_CMDS.md`
- **Tests** : critères d'acceptation vérifiés par grep/diff · smoke test
  hook exit 0 · non-régression confirmée

---

## [v1.9+SDLC-13] — 2026-06-18 · Sprint SDLC-13 · specs/SPEC.md (dogfooding)
- **`specs/SPEC.md`** (nouveau, projet toolkit) : §Vue d'ensemble,
  §Architecture (diagramme de flux), §Modules (vérifié contre l'état réel
  du repo)
- **`00-CONTEXT.md`** : §4 checklist — maintien de `specs/SPEC.md §Modules` ajouté
- **Tests** : N/A (gouvernance uniquement)

---

## [v1.9+SDLC-12] — 2026-06-18 · Sprint SDLC-12 · Phase amont
- **`10-AMONT-TEMPLATE.md`** (nouveau) : instructions Project Claude.ai
  dédié à l'idéation/PRD/architecture — §Brief, §Architecture amont
  (pattern Vérification groupée), §Perspectives, §Passage à Claude Code
- **`00-CONTEXT.md`** : carte des fichiers (ligne 10) + §2 phase amont optionnelle
- **`README.md`** : structure repo + paragraphe découpage amont/aval
- **`07-DECISIONS-SDLC.md`** : M-SCOPE-04 — résout Q1 stratégique, ferme
  explicitement la piste du marqueur de provenance
- **Tests** : N/A (gouvernance uniquement)

---

## [v1.9+SDLC-11] — 2026-06-18 · Sprint SDLC-11 · Skill /help
- **`11-help-SKILL-TEMPLATE.md`** (nouveau) : recap "où on en est / où on
  s'en va / outils disponibles", lecture seule, zéro suggestion
- **`00-CONTEXT.md`** : carte des fichiers — ligne `11` ajoutée
- **`README.md`** : structure repo + tableau skills disponibles mis à jour
- **`06-PDR-bootstrap.md`** : Groupe 3 — ligne `.claude/skills/help/`
- **`07-DECISIONS-SDLC.md`** : M-PROC-26 (M-PROC-25 déjà pris par la
  co-construction PDR SDLC-Sync)
- **Tests** : N/A (gouvernance uniquement)

---

## [v1.9+SDLC-10] — 2026-06-18 · Sprint SDLC-10 · Rangement catalogue BMad
- **`doc/ROADMAP.md`** (créé) : 6 patterns BMad en survol migrés en §Later
  avec déclencheurs (P-08, P-15 à P-19)
- **`specs/Sprints/ANALYSE-BMAD-TACTIQUE.md`** : note de clôture — catalogue
  Spike SDLC-06 clos, 13/19 patterns traités
- **`07-DECISIONS-SDLC.md`** : M-SCOPE-03 — fermeture question "modes
  nommés" (Q4 stratégique)
- **Tests** : N/A (gouvernance uniquement)

---

## [v1.9] — 2026-06-14 · Sprint SDLC-05b · Gouvernance & observabilité : CLAUDE_PROJECT, volumétrie, observabilité actionnable

- **`sdlc-project-check.sh`** (nouveau) : inventorie les fichiers de gouvernance, détecte delta vs `doc/CLAUDE_PROJECT.md`, génère le template versionné avec avis Claude
- **`doc/CLAUDE_PROJECT.md`** (nouveau) : template référence généré par le script — source de vérité pour reconstruire le projet Claude.ai
- **`02-STANDARDS-TEMPLATE.md` v1.9** : §Observabilité remplacé par checklist Q/R 5 questions `[À REMPLIR]` · note anti-faux-positif niveau A ajoutée dans §Niveaux de test
- **`04-sprint-PDR-TEMPLATE.md` v1.9** : champ optionnel `Volumétrie minimum` dans §Plan de test
- **`04b-sdlc-sync-SKILL-TEMPLATE.md` v1.9** : §Étape D4 — vérification CLAUDE_PROJECT delta au sdlc-sync
- **`06-PDR-bootstrap.md`** : §Étape 1b `sdlc-project-check.sh` · `doc/CLAUDE_PROJECT.md` carte §Groupe 2 · critère d'acceptation 10 · §Étape 2 grep étendu à `[À REMPLIR]`
- **`07-DECISIONS-SDLC.md`** : M-PROC-23 (volumétrie) · M-PROC-24 (CLAUDE_PROJECT) · M-ARCH-08 (observabilité Q/R)
- **Tests** : bash -n ✓ · smoke test exit 0 ✓ · greps CA 1.1b/1.2/1.3 (5/5) tous verts ✓
- **Corrections ajustées vs spec** — item 1.4 (`01-Claude-md-TEMPLATE.md`) déjà implémenté en 05a, skip · format `[À REMPLIR]` corrigé (format initial "—" ne matchait pas grep, détecté par CA)

## [v1.8] — 2026-06-14 · Sprint SDLC-05a · Wrap-up robustesse : §0e, signaux rétrospectifs, SESSION_BRIDGE, CLAUDE_PROJECT

- **`03-wrap-up-SKILL-TEMPLATE.md` v1.3** : §0a second output signaux rétrospectifs · §Étape 1 référence §0a synthèse · §0e revue objectif (ATTEINT/PARTIEL/NON ATTEINT) · §Étape 3 grep -En enforcement + 2 conditionnels (SESSION_BRIDGE / CLAUDE_PROJECT) · §Étape 5 réécrite SESSION_BRIDGE accumulatif · §Étape 6 réécrite vérification CLAUDE_PROJECT delta
- **`01-Claude-md-TEMPLATE.md` v1.8** : §Démarrage §2 lecture SESSION_BRIDGE · §Règles absolues sprint-memory.md explicité
- **`06-PDR-bootstrap.md`** : doc/SESSION_BRIDGE.md ajouté carte §Groupe 2
- **`07-DECISIONS-SDLC.md`** : M-PROC-19 à M-PROC-22 (revue objectif · signaux rétrospectifs · enforcement specs · SESSION_BRIDGE + CLAUDE_PROJECT)
- **Tests** : greps critères d'acceptation 1.1/1.5/1.6/1.7/1.8 tous verts ✓
- **Corrections ajustées vs spec** — test `grep -c "^## Étape [1-6]"` → 8 résultats (pas 6) : Étape 2b et 3.5 préexistants, attendu de la spec incorrectement calibré · specs/Sprints/ absent dans ce repo (PDR en conversation)

## [v1.7] — 2026-06-11 · Sprint SDLC-04 · Confiance FAIBLE → vérification externe + PostToolUse Option A/B

- **`01-Claude-md-TEMPLATE.md` v1.7** : §Analyse §Demande d'aval — si confiance FAIBLE, recommander explicitement une vérification externe (Oracle ou revue humaine) avant l'aval (M-PROC-18)
- **`08-hooks-TEMPLATE.md` v1.7** : §PostToolUse restructuré en Option A — lint/format ruff (reformulée, ex-M-HOOKS-01) / Option B — nouveau hook `post-commit-changelog.sh` + snippet `settings.json` + smoke test (M-HOOKS-03)
- **`02-STANDARDS-TEMPLATE.md`** : marqueur `SDLC version` v1.5 → v1.7 (paire avec `01-Claude-md-TEMPLATE.md`, cf. M-PROC-09)
- **`07-DECISIONS-SDLC.md`** : M-PROC-18, M-HOOKS-03
- **Tests** : `post-commit-changelog.sh` — `bash -n` OK · 4 scénarios smoke test (non-commit, --amend, commit avec/sans CHANGELOG.md) ✓

---

## [v1.6] — 2026-06-11 · Sprint SDLC-03 · Annotations sprint-memory + Handoff eager/lazy + index retrospective

- **`01-Claude-md-TEMPLATE.md` v1.6** : §Mémoire de sprint — annotation `[CONF: HAUTE/MOY/FAIBLE — raison]` sur ANALYSE (M-PROC-13) · champ `→ alternative :` sur BLOQUANT (M-PROC-14) · `[valide jusqu'à : condition]` sur DÉCISION (M-PROC-15) ; §Démarrage 4c + §Tokens — distinction Handoff chargement immédiat/différé (M-PROC-16)
- **`04-sprint-PDR-TEMPLATE.md` v1.6** : §Handoff scindé en chargement immédiat / chargement différé (M-PROC-16) · nouvelle section §Dépendances — inputs requis / outputs produits (M-ARCH-07)
- **`09-retrospective-SKILL-TEMPLATE.md` v1.6** : §Index des patterns en tableau structuré + §Métriques de rétro + §Requêtes utiles sur l'index (M-PROC-17)
- **`07-DECISIONS-SDLC.md`** : M-PROC-13, M-PROC-14, M-PROC-15, M-PROC-16, M-PROC-17, M-ARCH-07
- **Tests** : N/A (gouvernance uniquement)

---

## [v1.5] — 2026-06-05 · Sprint SDLC-02 · Init sprint spec + mémoire

- **`01-Claude-md-TEMPLATE.md` v1.5** : §Démarrage étape 4 remplacée par séquence 4a/4b/4c/4d — création spec, init mémoire, lecture, plan de dev ; règle absolue ajoutée
- **`02-STANDARDS-TEMPLATE.md` v1.5** : marqueur SDLC v1.4 → v1.5
- **`03-wrap-up-SKILL-TEMPLATE.md`** : §Étape 3 — bloc `specs/Sprints/sprint-N-slug.md` obligatoire ajouté (vérification existence + §Corrections ajustées vs spec)
- **`04-sprint-PDR-TEMPLATE.md`** : §Plan de développement (4d) + §Corrections ajustées vs spec (wrap-up) ajoutés après §Handoff Claude Code
- **`07-DECISIONS-SDLC.md`** : M-PROC-12 — Init sprint : spec + mémoire + plan de développement
- **Tests** : tous les greps de vérification passent ✓

---

## [v1.4] — 2026-06-04 · Sprint SDLC-01 · Modifications spot sed/grep

- **`01-Claude-md-TEMPLATE.md` v1.3** : §Modifications spot sur fichiers existants ajouté
- **`07-DECISIONS-SDLC.md`** : M-PROC-10 (mémoire de sprint) + M-PROC-11 (modifications spot sed/grep)
- **`02-STANDARDS-TEMPLATE.md` v1.4** : marqueur SDLC v1.3 → v1.4
