# LESSONS_LEARNED — Modèle de gouvernance SDLC (projet toolkit)
<!-- Créé Sprint SDLC-14 (self-bootstrap + rattrapage) — 8 entrées rétroactives SDLC-07→14 -->

## §Index des patterns · mis à jour 20/06/2026 · Sprints SDLC-07→20

| ID | Pattern | Occurrences | Sprints | Statut | Décision |
|----|---------|-------------|---------|--------|----------|
| LL-T01 | Sprint méta sans entrée DECISIONS/CHANGELOG dédiée au commit | 3 | SDLC-07, 08, 09 | Clos — accepté en l'état | Backfill explicitement écarté (`M-PROC-27`, `07-DECISIONS-SDLC.md`, `/retrospective` SDLC-15) — discipline restaurée depuis SDLC-10 jugée suffisante, gap historique accepté sans rattrapage |
| LL-T02 | Vérifier qu'un mécanisme ou une précondition n'est pas déjà couvert/vrai avant de l'ajouter/le présumer | 4 | SDLC-12, SDLC-14, SDLC-18, SDLC-20 | Actif — principe à appliquer systématiquement | Aucune action — vigilance continue |
| LL-T03 | Poser les sous-décisions d'architecture explicitement avant d'écrire un PDR à enjeu | 2 | SDLC-04 (HALT), SDLC-09 (Adversarial Review) | Confirmé | Pattern à reproduire pour tout sprint Taille M/L touchant l'architecture |
| LL-T04 | Vérifier par commande exécutable toute précondition factuelle énoncée par un PDR avant de l'exécuter — y compris du contenu "rétroactif" fourni comme acquis | 1 | SDLC-14 | Nouveau | Appliqué nativement ce sprint (citabilité `Claude.md §Rôle` étendue au contenu du PDR lui-même, pas seulement au code/repo) — à reproduire systématiquement |
| LL-T05 | Les instructions d'init embarquées dans un PDR (§Handoff) peuvent être incomplètes par rapport à la checklist absolue de `Claude.md §Démarrage` (4a-4d) — les traiter comme suffisantes sans les confronter à `Claude.md` fait sauter une étape (ici : 4a, création du fichier spec) sans qu'aucun garde-fou ne le détecte avant le `/wrap-up` | 1 | SDLC-16 | Nouveau — décision différée | ⏳ — réflexion approfondie demandée par l'utilisateur en session Claude.ai dédiée avant toute correction (hook ou modification de procédure) |
| LL-T06 | Tester un mécanisme de blocage global (hook `PreToolUse`) en manipulant l'état réel de la session courante, sans isolation, transforme un bug du mécanisme testé en blocage réel de la session elle-même | 1 | SDLC-18 | Nouveau — corrigé | Règle d'isolation ajoutée à `08-hooks-TEMPLATE.md` (`M-PROC-30`) — appliquée, pas en attente |
| LL-T07 | Le carve-out anti-auto-verrouillage M-HOOKS-04 (`pre-tool-bash.sh`) n'autorise l'écriture que sous `specs/Sprints/*` — il ne couvre pas une correction légitime de `.claude/sprint-memory.md` lui-même (ex: renommage du spec référencé), qui reste bloquée même quand l'action est exactement celle que le carve-out visait à débloquer | 1 | SDLC-20 | Nouveau — décision différée | ⏳ — `[HOOK_CANDIDATE]` à trancher en `/retrospective` : élargir le carve-out pour inclure `sprint-memory.md` lui-même |

## §Entrées par sprint

### Sprint SDLC-23 — 21/06/2026 — Hook PreCompact × sprint-memory.md
**Code :** Bug du PDR initial confirmé et corrigé avant livraison — le PDR affirmait
le payload `PreCompact` "vérifié... zéro Oracle nécessaire" avec un champ `trigger`,
qui n'existe pas. Champ réel `compaction_reason` (+ `context_used_tokens`/
`context_limit_tokens`/`estimated_tokens_freed`, absents du PDR) confirmé par
`WebFetch` verbatim sur la doc officielle avant tout code — script écrit directement
contre le schéma réel, aucun commit contre le schéma erroné.
**Processus :** Un premier `WebFetch` sur la même URL a donné une réponse
contradictoire ("`PreCompact` ne supporte pas `matcher`" — faux) ; une 2e puis 3e
requête avec prompt "citation verbatim" a résolu la contradiction. Leçon outillage :
un résumé de `WebFetch` sur un schéma technique précis n'est pas fiable au premier
passage, recommander verbatim avant d'agir dessus.
**Lien pattern :** confirme `LL-T04` (2e confirmation ce cycle après SDLC-22 — étendu
ici à un schéma de plateforme externe documentée publiquement, pas seulement au
contenu du repo ou d'un PDR).
**Action proposée :** aucune nouvelle — rétrospective utilisateur "all good" sur les
3 volets.

### Sprint SDLC-22 — 21/06/2026 — Instrumentation conso token réelle (sdlc-token-usage.sh)
**Code :** Bug confirmé et corrigé avant livraison — `jq fromdateiso8601` rejette
100% des timestamps de transcript JSONL (`"2026-06-21T13:49:42.450Z"`, fraction de
seconde non gérée par le format attendu). Détecté en testant le filtre `jq` contre un
transcript réel avant de finaliser le script, pas après coup — corrigé par
`sub("\\.[0-9]+Z$"; "Z")` avant parsing (documenté `doc/DIAGNOSTIC_CMDS.md`).
**Processus :** Structure réelle du JSONL (champ `.timestamp`, emplacement de
`.message.usage.*`) vérifiée par inspection directe d'un transcript avant d'écrire
le parsing, plutôt que supposée depuis la documentation publique (non garantie
stable). Synchronisation des skills locaux (`.claude/skills/wrap-up`,
`.claude/skills/retrospective`) en plus des templates numérotés — dogfooding
immédiat du changement plutôt que limité aux futurs projets bootstrappés.
**Lien pattern :** confirme `LL-T04` (vérifier toute précondition factuelle par
commande exécutable avant d'agir, ici étendu au schéma d'un format de données
externe non documenté officiellement).
**Action proposée :** aucune — rétrospective utilisateur "all good" sur les
3 volets.

### Sprint SDLC-20 — 20/06/2026 — Étiquette [HYPOTHÈSE] sur tables HALT (3e révision)
**Code :** N/A — gouvernance/doc uniquement.
**Processus :** PDR reçu en 3e révision d'une même intention de sprint (1e exécutée SDLC-19,
2e rédigée mais jamais committée, mise en pause par l'utilisateur). Avant exécution, vérifié
par grep que la majorité des items du PDR (écrit en partant d'un état greenfield) était déjà
livrée par SDLC-19 — delta réel réduit à l'ajout de 5 étiquettes, évitant une réexécution
intégrale inutile. Incident de session : le garde-fou `M-HOOKS-04` a bloqué la correction de
`sprint-memory.md` après renommage du spec — carve-out trop étroit, contourné par un
placeholder temporaire.
**Lien pattern :** confirme `LL-T02` (4e occurrence) · nouveau `LL-T07` (gap du carve-out
M-HOOKS-04).
**Action proposée :** aucune sur le modèle lui-même — rétrospective utilisateur "all good"
sur les 3 volets.
**Hook candidat :** [HOOK_CANDIDATE] élargir le carve-out M-HOOKS-04 (`pre-tool-bash.sh`) pour
autoriser aussi l'édition directe de `.claude/sprint-memory.md` → ligne bash :
`[[ "$FILE_PATH" == */.claude/sprint-memory.md ]]` (à ajouter à la condition existante,
ligne 51) — décision : en attente, 1 occurrence à ce jour, pas encore récurrent.

### Sprint SDLC-19 — 19/06/2026 — Import sélectif audit Superpowers
**Code :** N/A — gouvernance/doc uniquement.
**Processus :** Import recalibré (pas traduit littéralement) de 4 recommandations d'audit
externe — 1 candidat (anti-complaisance) recalibré à la baisse en vérifiant que 3/4 des
formulations proposées existaient déjà, évitant une duplication. Non-régression vérifiée
par méthode alternative quand le test littéral du PDR donnait un résultat trompeur
(sous-titres de table comptés par le grep non ancré) mais explicable — documenté plutôt
que dissimulé.
**Lien pattern :** aucun nouveau — confirme la discipline déjà établie de vérifier avant
d'importer (cf. `LL-T02`), appliquée ici à un candidat d'audit plutôt qu'à un mécanisme
de code.
**Action proposée :** aucune — sprint clos, rétrospective utilisateur "all good" sur les
3 volets (déroulement, action risquée, évolution du modèle).

### Sprint SDLC-18 — 19/06/2026 — Fix garde-fou M-HOOKS-04 + schéma JSON PreToolUse
**Code :** Bug confirmé (`tool_input` vs `input` supposé) — les blocages `[UNIVERSEL]`
(`git push --force`, `rm -rf`) n'avaient jamais matché quoi que ce soit depuis SDLC-14,
corrigé. Carve-out M-HOOKS-04 implémenté avec un bug non anticipé (chemin absolu vs
relatif) ayant verrouillé la session ~40 min, corrigé et re-testé.
**Processus :** Auto-verrouillage réel de Bash/Edit/Write, débloqué une fois par
intervention humaine hors session. Cause directe : une comparaison de chemin a contredit
une preuve empirique obtenue 5 messages plus tôt dans la même conversation. Cause
aggravante : test du scénario "doit bloquer" réalisé contre le fichier réel qui gate la
session courante, sans isolation — répété une seconde fois sous une autre forme (`cd`
persistant entre appels d'outil) avant correction définitive.
**Lien pattern :** confirme **LL-T02** (deux fois : `settings.json` supposé "déjà élargi"
par le PDR, faux ; comparaison de chemin écrite sans relire la preuve déjà obtenue) ·
nouveau **LL-T06** (tester un mécanisme de blocage global en isolation, jamais contre
l'état réel de la session)
**Action proposée :** règle d'isolation des tests de hook bloquant → `08-hooks-TEMPLATE.md`
— **appliquée ce sprint** (`M-PROC-30`), pas en attente.
**Hook candidat :** allowlist Bash lecture seule pendant blocage M-HOOKS-04 — **appliquée
ce sprint** (`M-HOOKS-06`), scope élargi sur validation explicite de l'utilisateur après
l'incident. Décision : appliquée, pas en attente.
**SDLC candidat :** [SDLC_CANDIDATE] résolution de chemin dans `pre-tool-bash.sh` ancrée
sur un chemin absolu fixe plutôt que relative au cwd du processus (le piège `cd` persistant
documenté en `M-PROC-30` reste possible hors contexte de test) → fichier cible :
`08-hooks-TEMPLATE.md` (script) · nature : règle renforcée — décision : en attente, à
remonter manuellement dans le projet SDLC (Claude.ai)

### Sprint SDLC-17 — 19/06/2026 — Audit externe obra/superpowers
**Code :** N/A — gouvernance/doc uniquement
**Processus :** `Claude.md §Démarrage` exécuté intégralement (1→4a→4b→4c→4d)
avant tout travail sur le livrable, contrairement à SDLC-16. La vérification
de l'étape 4a (créer le fichier spec) a détecté une collision de
numérotation — le PDR portait "Sprint SDLC-06", déjà utilisé par
`sprint-SDLC-06-bmad-spike.md` — interceptée par HALT-ARCH avant création
du fichier, signalée à l'utilisateur, renumérotée en SDLC-17 sur validation
explicite avant de continuer.
**Lien pattern :** confirme LL-T05 évité avec succès cette fois — la
discipline manuelle de relecture de `Claude.md §Démarrage` en tête de
session (plutôt que de partir des seules instructions d'init du PDR) a
suffi à éviter la récurrence du défaut observé en SDLC-16 ; ne change pas
le statut ⏳ de LL-T05 (toujours aucun garde-fou automatique en place)
**Action proposée :** aucune — la vigilance manuelle reste le seul
mécanisme actif, cohérent avec la décision différée de LL-T05
**SDLC candidat :** [SDLC_CANDIDATE] 3 candidats préformatés dans le
livrable `doc/AUDIT-EXTERNE-superpowers-vs-sdlc.md §8` (hook `SessionStart`
injectant automatiquement les règles absolues + HALT en contexte — répond
directement à LL-T05 ; table de rationalisations par HALT ; fusion de la
clause anti-complaisance avec une liste de formulations interdites) →
fichier cible : `08-hooks-TEMPLATE.md`, `01-Claude-md-TEMPLATE.md` ·
nature : nouveau mécanisme (hook) + renforcement de règles existantes —
décision : en attente, à remonter manuellement dans le projet SDLC
(Claude.ai), groupé avec la réflexion déjà prévue pour LL-T05

---

### Sprint SDLC-07 — 18/06/2026 — HALT + Stronghold first + citabilité
**Code :** N/A — gouvernance uniquement
**Processus :** Bon réflexe de proposer deux options (A/B) pour HALT plutôt
que trancher seul *(non vérifiable depuis le repo — audit SDLC-16)*.
Entrée `07-DECISIONS-SDLC.md`/`CHANGELOG.md` manquante
au moment du commit — gap découvert et caractérisé en SDLC-14.
**Lien pattern :** nouveau LL-T01
**Action proposée :** discipline systématique (entrée registre + changelog
dans chaque PDR) → décision : ✅ appliquée depuis SDLC-10

### Sprint SDLC-08 — 18/06/2026 — Qualité & continuité (5 patterns groupés)
**Code :** N/A
**Processus :** Regroupement de 5 patterns par destination commune
(`Claude.md §Tokens/§Test/§Mémoire`, `retrospective §Étape 2b`) en un
seul sprint M a réduit la fragmentation vs 5 sprints XS séparés *(jugement
comparatif non vérifiable depuis le repo — audit SDLC-16)*. Décision
P-10 (absorption dans SD-1/SD-5) documentée dans le PDR lui-même plutôt
que dans le registre central — même gap traçabilité que SDLC-07.
**Lien pattern :** confirme LL-T01
**Action proposée :** aucune nouvelle — déjà couverte par la correction
SDLC-10+ → décision : ✅

### Sprint SDLC-09 — 18/06/2026 — Adversarial Review (3 couches)
**Code :** N/A
**Processus :** 3 sous-décisions d'architecture (où ça vit / profondeur /
cécité du Blind Hunter) posées explicitement en discussion avant
d'écrire le PDR — a évité un PDR à réécrire après coup *(narration de
session de conception, non vérifiable depuis le repo — audit SDLC-16)*.
**Lien pattern :** nouveau LL-T03 (confirme un pattern déjà observé en
amont sur HALT)
**Action proposée :** reproduire ce pattern pour tout sprint M/L à enjeu
architectural → décision : ✅ (appliqué nativement depuis, voir SDLC-12)

### Sprint SDLC-10 — 18/06/2026 — Rangement catalogue BMad + fermeture Q4
**Code :** N/A
**Processus :** Création de `doc/ROADMAP.md` pour le projet toolkit
lui-même (dogfooding) a révélé que le projet n'appliquait pas sa propre
structure à lui-même — point de départ de SDLC-13 et SDLC-14. Une
manipulation `str_replace` a fait disparaître un en-tête de section par
erreur de chevauchement de blocs — corrigé immédiatement après détection
*(anecdote d'édition de session, non vérifiable depuis le repo — un
correctif appliqué avant commit ne laisse aucune trace git ; audit
SDLC-16)*.
**Lien pattern :** aucun nouveau
**Action proposée :** toujours re-vérifier (`view`) un fichier après
`str_replace` avant d'enchaîner une autre édition sur la même zone →
décision : ✅ bonne pratique, pas de mécanisme formel nécessaire

### Sprint SDLC-11 — 18/06/2026 — Skill /help
**Code :** N/A
**Processus :** Taille initialement qualifiée "XS" s'est révélée "S" une
fois la gouvernance comptée (5 fichiers à mettre à jour en plus du
skill). Déclaré honnêtement dans le PDR plutôt que sous-estimé, avec une
option de scope réduit documentée *(narration du calibrage de taille,
non vérifiable depuis le repo — audit SDLC-16)*.
**Lien pattern :** aucun nouveau
**Action proposée :** continuer à distinguer taille du "cœur du
changement" vs taille "gouvernance associée" dans les PDR futurs →
décision : ✅ acté comme règle stable dans `Claude.md §Analyse`
(`M-PROC-28`, `/retrospective` SDLC-15 — alerte `SD-5`, action restée
`⏳` sans déclencheur pendant 3 sprints)

### Sprint SDLC-12 — 18/06/2026 — 10-AMONT-TEMPLATE.md
**Code :** N/A
**Processus :** Conception initiale prévoyait un marqueur de provenance
+ modifications de `Claude.md`/`wrap-up`. Remise en question a révélé que
`HALT-ARCH` et `§Dépendances vérifiées` couvraient déjà le besoin sans
rien ajouter — le marqueur aurait dupliqué un comportement déjà
universel *(narration de session de conception amont, non vérifiable
depuis le repo — audit SDLC-16)*.
**Lien pattern :** nouveau LL-T02
**Action proposée :** vérifier systématiquement qu'un mécanisme proposé
n'est pas déjà couvert avant de l'ajouter, y compris en conception de
gouvernance (pas seulement en diagnostic de code) → décision : ⏳ —
vigilance continue, pas de mécanisme formel possible

### Sprint SDLC-13 — 18/06/2026 — specs/SPEC.md (dogfooding)
**Code :** N/A
**Processus :** Instruction explicite de vérifier `§Modules` contre l'état
réel des fichiers (`ls *.md`) plutôt que recopier le squelette fourni
dans le PDR — applique "Stronghold first" à la documentation du système
par lui-même, pas seulement au diagnostic de code applicatif *(le
déroulement de session n'est pas vérifiable depuis le repo ; la
substance l'est — la table `specs/SPEC.md` recoupe les fichiers réels,
vérifié audit SDLC-16)*.
**Lien pattern :** confirme la valeur de P-13 (Stronghold first, importé
SDLC-07) au-delà de son usage prévu initial
**Action proposée :** aucune — confirmation d'un pattern déjà acquis →
décision : ✅

### Sprint SDLC-14 — 19/06/2026 — Audit du gap SDLC-14 + self-bootstrap (fusionnés)
**Code :** N/A — gouvernance uniquement
**Processus :** Le PDR reçu en conversation (nommé "SDLC-15") présupposait
qu'un sprint SDLC-14 ("Audit et rattrapage gouvernance") avait déjà eu
lieu, et fournissait son contenu rétroactif comme un fait acquis. La
vérification de précondition explicitement demandée par le PDR lui-même
(`grep "M-PROC-26\|Rattrapage" 07-DECISIONS-SDLC.md`) a été exécutée
avant de démarrer plutôt que présumée vraie — elle a révélé que SDLC-14
n'existe ni en commit git, ni en CHANGELOG, ni en DECISIONS. Décision
utilisateur (option choisie) : renuméroter ce sprint en SDLC-14 réel,
fusionnant audit/rattrapage et bootstrap, plutôt que d'écrire une entrée
fictive dans ce fichier.
**Lien pattern :** nouveau LL-T04 (citabilité étendue au contenu du PDR
lui-même, pas seulement au code/repo) · confirme LL-T02 (vérifier avant
de présumer) · caractérise LL-T01 comme partiellement résolu (discipline
oui, backfill historique non — voir `doc/DIAGNOSTIC_CMDS.md`)
**Action proposée :** vérifier toute précondition factuelle explicite
d'un PDR par commande exécutable avant de l'exécuter, y compris le
contenu "rétroactif" fourni comme acquis → décision : ✅ appliqué
nativement ce sprint, à reproduire systématiquement

### Sprint SDLC-15 — 19/06/2026 — Première /retrospective (SDLC-07→14)
**Code :** N/A
**Processus :** Première exécution de `/retrospective` — skill non encore
chargée par la session (créée au sprint précédent) ; procédure suivie
manuellement depuis `.claude/skills/retrospective/SKILL.md` *(fait
d'exécution de session, non vérifiable depuis le repo — audit
SDLC-16)*. Significant
Discovery Alert `SD-5` déclenché : action `⏳` de SDLC-11 ouverte depuis
3 sprints sans déclencheur documenté. Décision utilisateur : acter la
règle (`Claude.md`, `M-PROC-28`) et clore `LL-T01` sans backfill
(`M-PROC-27`) plutôt que de laisser les deux indéfiniment `⏳`.
**Lien pattern :** clôt LL-T01 · résout l'alerte SD-5 (action SDLC-11)
**Action proposée :** aucune nouvelle — décisions actées dans
`07-DECISIONS-SDLC.md` (`M-PROC-27`, `M-PROC-28`) et `Claude.md §Analyse`
→ décision : ✅

### Sprint SDLC-16 — 19/06/2026 — Audit complet SDLC-07→15
**Code :** N/A — gouvernance uniquement
**Processus :** Le sprint a démarré directement depuis le PDR collé en
conversation sans exécuter `Claude.md §Démarrage` étape 4a (création de
`specs/Sprints/sprint-SDLC-16-audit-complet.md`) ni étape 4d (§Plan de
développement écrit avant le travail) — découvert seulement au
`/wrap-up`, à l'étape qui vérifie explicitement l'existence du fichier
spec. Cause racine : les instructions "Init mémoire sprint" données par
le PDR lui-même (qui ne couvrent que la 4b) ont été traitées comme une
procédure de démarrage complète, sans être confrontées à la checklist
réelle de `Claude.md §Démarrage`. Spec créée rétroactivement sur demande
explicite de l'utilisateur. Par ailleurs, le contexte du PDR affirmait
`doc/LESSONS_LEARNED.md` vide (refus correct d'un contenu narratif en
SDLC-15) — l'audit a montré qu'il était déjà entièrement rempli depuis
SDLC-14 ; traité comme le cas alternatif explicitement prévu par le PDR
(audit du contenu existant, proposition à l'utilisateur plutôt qu'action
unilatérale).
**Lien pattern :** nouveau LL-T05 · confirme LL-T04 (vérifier une
précondition du PDR avant d'agir, ici étendu aux instructions d'init
elles-mêmes, pas seulement au contenu factuel)
**Action proposée :** aucune inscrite ce sprint → décision : ⏳ —
réflexion approfondie demandée par l'utilisateur en session Claude.ai
avant de formaliser une correction
**Hook candidat :** [HOOK_CANDIDATE] Règle absolue `Claude.md` ligne 19
("Ne jamais commencer à coder sans avoir exécuté 4a/4b/4c et écrit le
§Plan de développement en 4d") non appliquée automatiquement — violée
sans qu'aucun garde-fou ne le détecte avant le `/wrap-up` → ligne bash
candidate (non validée, à discuter) : `test -f specs/Sprints/sprint-*-*.md
|| echo "BLOCK: aucun fichier spec — exécuter 4a avant de continuer"` —
décision : en attente, à réfléchir en Claude.ai
**SDLC candidat :** [SDLC_CANDIDATE] Le bloc "Handoff Claude Code" d'un
PDR ne devrait peut-être pas pouvoir se substituer silencieusement à
`Claude.md §Démarrage` — questionner si `04-sprint-PDR-TEMPLATE.md`
devrait imposer que tout PDR rappelle explicitement les 4 étapes (4a-4d)
plutôt que de n'en lister qu'une partie → fichier cible :
`04-sprint-PDR-TEMPLATE.md` et/ou `Claude.md §Démarrage` · nature :
règle renforcée ou garde-fou de procédure — décision : en attente, à
remonter manuellement dans le projet SDLC (Claude.ai)

---

## §Métriques (mis à jour Sprint SDLC-16)
- Sprints couverts : SDLC-07 à SDLC-16 (10 sprints)
- Dernière `/retrospective` : 19/06/2026 · Sprints SDLC-07→14
- HOOK_CANDIDATE en attente : 1 (SDLC-16 — garde-fou démarrage 4a, ⏳
  réflexion Claude.ai) · activés ce cycle : 0 · rejetés : 0
- SDLC_CANDIDATE en attente : 1 (SDLC-16 — rappel explicite 4a-4d dans
  tout PDR, ⏳ réflexion Claude.ai)
- Décisions invalidées détectées : 0 (M-PROC-26, M-SCOPE-03/04 vérifiées
  toujours valides — déclencheurs de réouverture non atteints)
- Patterns actifs : LL-T02 (vigilance continue), LL-T03 (à reproduire),
  LL-T04 (à reproduire), LL-T05 (nouveau — décision différée)
- Patterns clos ce cycle : LL-T01 (accepté en l'état, sans backfill)
