# LESSONS_LEARNED — Modèle de gouvernance SDLC (projet toolkit)
<!-- Créé Sprint SDLC-14 (self-bootstrap + rattrapage) — 8 entrées rétroactives SDLC-07→14 -->

## §Index des patterns · mis à jour 22/09/2026 · Sprints SDLC-07→SDLC-31

| ID | Pattern | Occurrences | Sprints | Statut | Décision |
|----|---------|-------------|---------|--------|----------|
| LL-T01 | Sprint méta sans entrée DECISIONS/CHANGELOG dédiée au commit | 3 | SDLC-07, 08, 09 | Clos — accepté en l'état | Backfill explicitement écarté (`M-PROC-27`, `07-DECISIONS-SDLC.md`, `/retrospective` SDLC-15) — discipline restaurée depuis SDLC-10 jugée suffisante, gap historique accepté sans rattrapage |
| LL-T02 | Vérifier qu'un mécanisme ou une précondition n'est pas déjà couvert/vrai avant de l'ajouter/le présumer | 4 | SDLC-12, SDLC-14, SDLC-18, SDLC-20 | Actif — principe à appliquer systématiquement | Aucune action — vigilance continue |
| LL-T03 | Poser les sous-décisions d'architecture explicitement avant d'écrire un PDR à enjeu | 4 | SDLC-04 (HALT), SDLC-09 (Adversarial Review), GSD-V1 (3e), GSD-V2 (4e) | Confirmé | Pattern à reproduire pour tout sprint Taille M/L touchant l'architecture — PDR à contenu prescrit = exécution fluide sans aller-retour |
| LL-T04 | Vérifier par commande exécutable ou recherche dédiée toute précondition factuelle avant de l'écrire dans une analyse/PDR — y compris un mécanisme de plateforme externe ou du contenu fourni comme acquis | 7 | SDLC-14 (origine), SDLC-16, SDLC-22, SDLC-23, SDLC-25, ECO-1, ECO-2 | **Gradué `/retrospective` 03/09/2026** | Promu en règle permanente — `Claude.md §Analyse` (nouveau bloc "Vérification factuelle") + `01-Claude-md-TEMPLATE.md` (même bloc, générique). *Correction de comptage : SDLC-25 et ECO-1 avaient été classées "nouveau" à l'exécution — ce sont en réalité des confirmations de ce pattern, reclassées ici sans réécrire leurs entrées sources.* |
| LL-T05 | Les instructions d'init embarquées dans un PDR (§Handoff) peuvent être incomplètes par rapport à la checklist absolue de `Claude.md §Démarrage` (4a-4d) — les traiter comme suffisantes sans les confronter à `Claude.md` fait sauter une étape (ici : 4a, création du fichier spec) sans qu'aucun garde-fou ne le détecte avant le `/wrap-up` | 2 | SDLC-16, SDLC-Audit-GSTACK | **Résolu — Sprint SDLC-32** | Encart 4 lignes en tête de `04-sprint-PDR-TEMPLATE.md §Handoff` rappelant les 4 étapes et renvoyant à `Claude.md §Démarrage` (`M-TMPL-08`). Pas de mécanisation — garde-fou de rédaction jugé suffisant ; réouverture si une 3e occurrence survient malgré le rappel. |
| LL-T06 | Tester un mécanisme de blocage global (hook `PreToolUse`) en manipulant l'état réel de la session courante, sans isolation, transforme un bug du mécanisme testé en blocage réel de la session elle-même | 1 | SDLC-18 | Nouveau — corrigé | Règle d'isolation ajoutée à `08-hooks-TEMPLATE.md` (`M-PROC-30`) — appliquée, pas en attente |
| LL-T07 | Le carve-out anti-auto-verrouillage M-HOOKS-04 (`pre-tool-bash.sh`) n'autorise l'écriture que sous `specs/Sprints/*` — il ne couvre pas une correction légitime de `.claude/sprint-memory.md` lui-même (ex: renommage du spec référencé), qui reste bloquée même quand l'action est exactement celle que le carve-out visait à débloquer | 2 | SDLC-20, ECO-4 | **Clos — résolu** | Carve-out élargi à `.claude/sprint-memory.md` (`07-DECISIONS-SDLC.md M-HOOKS-04 → Mise à jour 03/09/2026`). Déclencheur nommé pour `ECO-4` manqué à la rédaction du PDR (parti de l'ANALYSE/ROADMAP, pas de ce fichier) — repéré en préparant l'Étape 2 du wrap-up, traité hors PDR sur aval explicite plutôt que différé une 3e fois. |
| LL-T08 | `sprint-memory.md` réduit à son en-tête pour un sprint au diff substantiel, malgré des décisions réelles arbitrées en conversation et jamais tracées en DÉCISION/TEST | 6 | SDLC-25, ECO-1, ECO-4, ECO-5, SDLC-28, SDLC-29 | Gradué — garde-fou ajouté (`/retrospective` SDLC-27, 03/09/2026) | `M-PROC-44` — avertissement non bloquant dans le Bilan §0d du wrap-up si `sprint-memory.md` = en-tête seul et diff ≥ 3 fichiers/50 lignes. Déclenché 2 fois consécutives (SDLC-28, SDLC-29) — signalé les 2 fois, escalade explicitement déclinée par l'utilisateur (`RAS`) et non silencieusement ignorée. Distinction actée : le garde-fou fonctionne (surfacé + décision humaine informée), ce n'est pas le cas « ignoré » que son propre déclencheur visait. Pas de réouverture unilatérale. |
| LL-T09 | Une règle actée pour un fichier nommément désigné (ex. fidélité historique pour `CHANGELOG.md`) n'est pas généralisée aux blocs de même nature ailleurs dans le repo (`README.md §Historique`) | 1 | SDLC-25 | Nouveau — surveillé | Aucune action — 1 occurrence, pas encore récurrent |
| LL-T10 | Un Blind Hunter délégué à un sous-agent sans accès au repo produit des hypothèses non vérifiables à côté de vrais défauts | 2 | ECO-1 (2 faux positifs sur 4 findings), ECO-3 (3 défauts réels, 0 faux positif signalé) | Confirmé — surveillé | Aucune action — proportion à mesurer sur plusieurs sprints avant d'ajuster `03-wrap-up-SKILL-TEMPLATE.md §0f` ; correction d'index `/retrospective` SDLC-27 (2e occurrence non reportée à l'exécution ECO-3) |
| LL-T11 | La vérification factuelle pré-PDR (`Claude.md §Analyse`, `M-PROC-41`/`LL-T04`) recoupe systématiquement l'ANALYSE source et `docs/ROADMAP.md`, mais pas `docs/LESSONS_LEARNED.md` — alors que ce fichier peut porter un déclencheur de réouverture nommant explicitement un sprint donné | 1 | ECO-4 (`LL-T07`, déclencheur manqué à la rédaction du PDR, repéré seulement au wrap-up) | Nouveau — surveillé | Aucune action — 1 occurrence, pas encore récurrent ; surveiller si une 2e survient avant de proposer d'étendre `§Vérification factuelle` |
| LL-T12 | Un critère d'acceptation utilisant `grep -A<N>` dimensionne `N` sur une estimation plutôt que le contenu réel du fichier cible — la commande de vérification échoue alors qu'un contenu correct existe | 2 | ECO-3 (`-A40`→`-A50`), ECO-4 (`-A10`→`-A20`, `-A3`→`-A12`, 2 critères) | Nouveau — corrigé | Rappel ajouté à `04-sprint-PDR-TEMPLATE.md §Critères d'acceptation` (`/retrospective` SDLC-27, 03/09/2026) — compter les lignes réellement couvertes avant d'écrire `-A<N>` |
| LL-T13 | Un identifiant `M-XXXX-NN` cité dans une règle de gouvernance (`Claude.md`/template) peut rester incorrect indéfiniment — `sdlc-validate.sh C3` ne détecte que 3 motifs de placeholder littéraux (`[→ ADAPTER]`/`[À REMPLIR]`/`[Nom du projet]`), pas une référence `M-XXXX-XX` non résolue ou erronée | 1 | SDLC-28 (`M-HOOKS-XX` jamais résolu + `Étend M-PROC-13` erroné, tous deux introduits SDLC-23, non détectés pendant 5 sprints) | Nouveau — surveillé | Aucune action — 1 occurrence ; extension de `C3` à envisager si une 2e survient |
| LL-T14 | Un total, comptage ou identifiant écrit de mémoire dans un livrable/commentaire/décision (pas dans une analyse) dérive du réel, distinct de `LL-T04` par le moment (rédaction, pas analyse) | 3 | SDLC-28 (`LL-T13`), SDLC-29 (nom de fichier planifié non confronté au disque), SDLC-30 (4 comptages faux : blocs de commandes, templates, version en commentaire, nombre de sprints) | **Gradué `/retrospective` 22/09/2026** | `M-PROC-48` — extension de `Claude.md §Analyse §Vérification factuelle` (+ `01-Claude-md-TEMPLATE.md` v2.6) : tout total écrit dans un livrable vérifié par commande, préférer `N/M` à un nombre figé quand il peut changer |

## §Métriques de rétro · 22/09/2026 (SDLC-31)

- Sprints couverts : SDLC-28 → SDLC-30 (3 sprints, + 2 fix ad-hoc hors wrap-up ; dernière rétro SDLC-27 le 03/09/2026 — sous le seuil de 5, déclenchée manuellement sur accumulation de candidats)
- M1 (`wc -w Claude.md STANDARDS.md`) : 3171 mots (vs 3171 à SDLC-27, +0% — sous le seuil cliquet 10%, aucune action requise)
- M2 (`wc -w .claude/skills/wrap-up/SKILL.md`) : 2777 mots (vs 2778 à SDLC-27, -0,04% — négligeable)
- `sdlc-token-usage.sh` : cache_read 704 683 979 · cache_creation 9 420 184 · output 1 967 925 (totaux bruts cumulés projet — pas de bucketisation, aucun `sprint-memory.md` actif au moment de la mesure)
- HOOK_CANDIDATE en attente : 0 · activés ce cycle : 0 · rejetés ce cycle : 0
- SDLC_CANDIDATE en attente : 1 (ECO-1, Blind Hunter délégué — lié `LL-T10`, pas encore à 3 occurrences) · tranchés ce cycle : 2 (SDLC-18 résolution de chemin, SDLC-16 rappel 4a-4d — `SD-5`, sprints Fix dédiés à suivre plutôt qu'un nouveau report)
- Décisions invalidées détectées : 0
- Patterns nouveaux : 1 (`LL-T14`) · patterns gradués : 1 (`LL-T14` → `M-PROC-48`, extension `§Vérification factuelle`)
- Significant Discovery Alert : `SD-5` — 2 `SDLC_CANDIDATE` (SDLC-16, SDLC-18) restés sans déclencheur nommé > 2 sprints, tranchés ce cycle plutôt que reconduits
- Dernière `/retrospective` : 22/09/2026 · Sprints SDLC-28→SDLC-30 (SDLC-31)

## §Métriques de rétro · 03/09/2026 (SDLC-27)

- Sprints couverts : ECO-3 → ECO-5 (3 sprints ; dernière rétro SDLC-26 le 03/09/2026 — sous le seuil de 5, déclenchée manuellement)
- M1 (`wc -w Claude.md STANDARDS.md`) : 3171 mots (vs 3028 à SDLC-26, +4,7% — sous le seuil cliquet 10%, aucune action requise)
- M2 (`wc -w .claude/skills/wrap-up/SKILL.md`) : 2778 mots (vs 2650 à SDLC-26, +4,8% — garde-fou traçabilité `M-PROC-44` ajouté ce cycle)
- `sdlc-token-usage.sh` : cache_read 502 177 232 · cache_creation 4 918 031 · output 1 116 879 (totaux bruts cumulés projet, mesurés avant le commit ECO-5 — pas de bucketisation, `sprint-memory.md` sans entrée horodatée)
- HOOK_CANDIDATE en attente : 0 (`LL-T05` SessionStart rejeté, `LL-T07`/carve-out et le `test -f spec` de SDLC-16 déjà implémentés — champs décision mis à jour) · activés ce cycle : 0 · rejetés ce cycle : 1
- SDLC_CANDIDATE en attente : 2 (SDLC-18 résolution de chemin dans `pre-tool-bash.sh`, SDLC-16 restatement 4a-4d dans `04-sprint-PDR-TEMPLATE.md`) · résolus ce cycle : 1 (cluster hook `SessionStart` + rationalisations HALT + fusion clause anti-complaisance, ces 2 dernières déjà livrées SDLC-19)
- Décisions invalidées détectées : 1 (SDLC-16/17 — hook `SessionStart` répond à `LL-T05` : invalidée par vérification factuelle ECO-5, `Claude.md` recharge déjà nativement)
- Patterns nouveaux : 1 (`LL-T12`) · patterns confirmés : 1 (`LL-T10`, 2e occurrence) · patterns gradués : 1 (`LL-T08` → garde-fou `M-PROC-44`)
- Dernière `/retrospective` : 03/09/2026 · Sprints ECO-3→ECO-5 (SDLC-27)

## §Entrées par sprint

### Sprint SDLC-30 — 21/09/2026 — Rattrapage `SPEC.html` / `MODE-OPERATOIRE.html` + contrôle C10 (M-PROC-46)
**Code :** N/A — sprint de gouvernance, zéro code applicatif. `bash sdlc-validate.sh` → 10/10, exit 0.
**Processus :** Vérification factuelle avant PDR a trouvé un retard structurel (2 HTML figés à v1.4 depuis 23 versions, invisible faute de contrôle) — même famille que `M-PROC-45`. En session, 4 chiffres écrits à la main ont dérivé du réel avant d'être corrigés : « 31 blocs de commandes » cité au plan (réel : 8 blocs, 5 copiables — confondu avec un compte de lignes `grep`), « 13 templates » (réel : 14), « ~25 versions » dans un commentaire de `check_c10` (réel : 23), « 29 sprints » dans le README (c'est le 30e). Tous trouvés par la revue adverse ou l'utilisateur, aucun resté en l'état.
**Lien pattern :** confirme `LL-T04` (vérification factuelle) sur un axe nouveau — pas seulement une précondition d'analyse, mais tout chiffre écrit à la main dans un livrable (compte de fichiers, de blocs, de sprints) dérive de la même façon qu'une version non contrôlée. Proche de `LL-T13` (identifiant erroné qui reste incorrect faute de contrôle) mais porte sur des comptages, pas des références.
**Action proposée :** candidat pour `/retrospective` — évaluer si un motif générique (« ne jamais écrire un total sans `grep -c` à l'appui, y compris en commentaire de code ») mérite sa propre entrée d'index plutôt que de rester sous `LL-T04`.

### Sprint SDLC-29 — 04/09/2026 — `12-audit-externe-TEMPLATE.md` (P-22)
**Code :** N/A — sprint de gouvernance, zéro code applicatif. `bash sdlc-validate.sh` → 8/8, exit 0.
**Processus :** Vérification factuelle avant PDR a trouvé une collision de numérotation réelle (`10-audit-externe-TEMPLATE.md` prévu, `10-AMONT-TEMPLATE.md` déjà présent) jamais détectée par 6 fichiers historiques l'ayant mentionné — renuméroté `12-` avant tout code. Contenu non inventé : repris du squelette déjà écrit dans `docs/AUDIT-EXTERNE-gstack-vs-sdlc.md §7`. `sprint-memory.md` de nouveau réduit à son en-tête — `M-PROC-44` s'est déclenché pour la **2e fois consécutive** depuis son introduction hier ; signalé explicitement dans le Bilan, escalade proposée puis déclinée par l'utilisateur (RAS).
**Lien pattern :** confirme `LL-T08` (6e occurrence) — nuance actée dans l'index : signalé + décision humaine informée n'est pas « ignoré », le garde-fou fonctionne comme prévu.
**Action proposée :** aucune — pas de réouverture unilatérale de `M-PROC-44` sur un déclin explicite de l'utilisateur.

### Sprint SDLC-28 — 04/09/2026 — `sprint-memory.md` = mécanisme de reprise (P-27) + clôture P-39
**Code :** N/A — sprint de gouvernance, zéro code applicatif. `bash sdlc-validate.sh` → 8/8, exit 0.
**Processus :** Vérification factuelle avant PDR a trouvé `P-39` déjà résolu (parité skill↔template déjà totale — retiré sans code) et `P-27` partiellement fait : le paragraphe `CHECKPOINT` existait depuis SDLC-23 mais citait `M-HOOKS-XX` (placeholder jamais résolu) et `Étend M-PROC-13` (référence erronée — la bonne origine est `M-PROC-10`), non détectés pendant 5 sprints. `sprint-memory.md` réduit à son en-tête malgré 7 fichiers touchés — **le garde-fou `M-PROC-44` (ajouté hier, SDLC-27) s'est déclenché pour la 1ère fois**, exactement comme conçu.
**Lien pattern :** nouveau `LL-T13` (identifiant `M-XXXX-NN` erroné non détecté par `sdlc-validate.sh C3`) · confirme `LL-T08` (`M-PROC-44` fonctionne — 5e occurrence de fond, mais 1ère fois où le garde-fou lui-même est observé en action).
**Action proposée :** `LL-T13` — étendre `C3` si une 2e occurrence survient, pas d'action immédiate.

### Sprint ECO-5 — 03/09/2026 — Pattern `.claude/rules/` documenté (rescopé depuis P-20)
**Code :** N/A — sprint de gouvernance, zéro code applicatif. `bash sdlc-validate.sh` → 8/8, exit 0.
**Processus :** Deux pistes évaluées et écartées avant d'écrire le plan, chacune vérifiée par recherche externe citée plutôt que présumée : hook `SessionStart` (aucune garantie de conformité que `Claude.md` n'a pas déjà, `Claude.md` rechargeant nativement à `startup`/`resume`/`clear`/`compact`) puis self-split de `Claude.md` via `.claude/rules/` proposé en session par l'utilisateur (aucune frontière `paths:` naturelle dans ce repo — contenu 100% transverse au processus, pas de fault-line par répertoire de code). `.claude/sprint-memory.md` de nouveau réduit à son en-tête malgré 2 pivots réels arbitrés en conversation — **4e occurrence consécutive de `LL-T08`** (`SDLC-25, ECO-1, ECO-4, ECO-5`).
**Lien pattern :** confirme `LL-T04` (vérification factuelle avant PDR — appliquée 2 fois dans le même sprint, sur 2 pistes différentes, chacune infirmée) · `LL-T08` 4e occurrence — seuil déjà dépassé, garde-fou tranché en `/retrospective` (même session, `M-PROC-44`).
**Action proposée :** aucune nouvelle — `LL-T08` traité dans la `/retrospective` en cours (session).

### Sprint ECO-4 — 03/09/2026 — Durcissement PDR
**Code :** N/A — sprint de gouvernance, zéro code applicatif. `bash sdlc-validate.sh` → 8/8 confirmé, exit 0. Smoke tests positif/négatif sur le carve-out `pre-tool-bash.sh` élargi.
**Processus :** Vérification factuelle avant rédaction du PDR (`M-PROC-41`) a partiellement infirmé `E-07` (la ligne d'identité du ledger existait déjà) — portée réduite en conséquence, exécution propre sans aller-retour. Deux critères d'acceptation avaient une fenêtre `grep -A` trop courte (contenu déjà correct, commande mal calibrée) — même défaut que le wrap-up `ECO-3`, corrigé en session avant commit. Miss réel repéré seulement en préparant l'Étape 2 du wrap-up : `docs/LESSONS_LEARNED.md LL-T07` portait un déclencheur de réouverture nommant explicitement ce sprint — non lu à la rédaction du PDR (vérification factuelle limitée à `ANALYSE-SKILLS-ECOSYSTEM.md`/`ROADMAP.md`, pas étendue à `LESSONS_LEARNED.md`). Traité hors PDR sur aval explicite de l'utilisateur plutôt que différé une 3e fois.
**Lien pattern :** confirme `LL-T04` (vérification factuelle avant PDR — nouvelle application sur `E-07`). Nouveau `LL-T11` : la vérification factuelle pré-PDR ne couvre systématiquement que la source de l'ANALYSE et le ROADMAP, jamais `LESSONS_LEARNED.md` lui-même — alors que ce fichier peut porter des déclencheurs de réouverture nommant un sprint précis. `LL-T07` clos (2e occurrence, résolu). `LL-T08` atteint son seuil de surveillance nommé (3e occurrence : `SDLC-25`, `ECO-1`, `ECO-4`) — `sprint-memory.md` de ce sprint réduit à son en-tête malgré 4 décisions de portée réelles arbitrées en conversation.
**Action proposée :** `LL-T08` — décider d'un garde-fou (ex : seuil `git diff --stat` vs nombre d'entrées `sprint-memory.md`) à la prochaine `/retrospective`, la 3e occurrence nommée étant atteinte → décision : en attente. `LL-T11` — 1 occurrence, surveillé, aucune action immédiate.

### Sprint ECO-3 — 03/09/2026 — Barre qualité chiffrée et cliquet de contexte
**Code :** N/A — sprint de gouvernance, zéro code applicatif. `bash sdlc-validate.sh` → 8/8 confirmé (non-régression, 2 paires C4 modifiées).
**Processus :** Vérification factuelle avant rédaction du PDR (`M-PROC-41`, appliquée nativement) a infirmé `E-04` de l'ANALYSE : la Definition of Done n'était pas « éclatée » comme affirmé — déjà consolidée et déjà référencée depuis l'origine du toolkit. Portée réduite à 2 renvois d'une ligne plutôt qu'une reconstruction de section, évitant un travail inutile. Le Blind Hunter (sous-agent, diff seul) a néanmoins trouvé 3 défauts réels après coup, malgré cette vérification en amont : un doublon exact de phrase entre deux sous-sections d'un même bloc nouvellement écrit, une justification de seuil (M1 10%) qui citait en réalité la croissance d'une autre métrique (M2 +9,9%) sans le dire, et une affirmation de version (« Claude.md v2.2 ») non prouvée par le diff — `Claude.md` n'a pas de marqueur de version incrémenté par édition, seul `01-Claude-md-TEMPLATE.md` l'a. Les trois corrigés avant commit.
**Lien pattern :** confirme `LL-T10` (2e occurrence — ECO-1 puis ECO-3 : le Blind Hunter délégué trouve systématiquement des défauts réels malgré une analyse et une vérification factuelle soignées en amont). Nouveau signal, pas encore un pattern à part : une vérification factuelle en amont (`LL-T04`) et une revue adversariale en aval (`LL-T10`) attrapent des classes d'erreurs différentes et complémentaires, pas redondantes — la première sur les préconditions du PDR, la seconde sur la rédaction du diff produit.
**Action proposée :** aucune nouvelle — `LL-T10` reste en observation, sa 3e occurrence (si elle survient) sera le bon moment pour juger le rapport valeur/coût de la délégation systématique en Taille M/L.

### Sprint ECO-2 — 03/09/2026 — Rédaction des templates (description = déclenchement, forme selon échec)
**Code :** N/A — sprint de gouvernance, zéro code applicatif. `bash sdlc-validate.sh` → 8/8 confirmé après coup (non-régression).
**Processus :** Avant de rédiger le PDR, vérification factuelle du mécanisme `disable-model-invocation` (E-16) auprès de la doc officielle Claude Code plutôt que de faire confiance à la source externe (`mattpocock/skills`) — a révélé un conflit réel avec C2 de `sdlc-validate.sh` (frontmatter YAML exige `---` en 1ère ligne, ce qui aurait poussé le marqueur de version hors de la fenêtre vérifiée par C2). E-16 écarté du périmètre avant tout code, sur cette base. Seul défaut : un critère d'acceptation que j'ai moi-même mal formulé dans le PDR (`grep -c "Principe d'exécution" → 0`), détecté seulement à l'exécution — corrigé.
**Lien pattern :** confirme `LL-T04` (vérifier par commande/recherche exécutable toute précondition factuelle avant de l'inclure dans un PDR — ici étendu à un mécanisme de plateforme externe, avant rédaction plutôt qu'après). **Note pour `/retrospective` :** les entrées SDLC-25 et ECO-1 (immédiatement précédentes) relèvent très probablement du même pattern LL-T04 mais ont été classées `nouveau` à tort plutôt que `confirme` — l'index `§Index des patterns` sous-compte donc LL-T04 d'au moins 2 occurrences récentes (SDLC-25 : vérification de la fidélité historique avant sed de masse ; ECO-1 : dry-run manuel des 8 commandes avant codage). 3 confirmations consécutives (SDLC-25, ECO-1, ECO-2) du même principe justifient une revue de l'index à la prochaine `/retrospective`.
**Action proposée :** `/retrospective` reclasse les entrées SDLC-25/ECO-1 comme confirmations de `LL-T04` (pas de nouveaux patterns), et évalue si 3 confirmations consécutives + les 4 antérieures (SDLC-14/20/22/23) justifient une graduation de LL-T04 vers une règle permanente explicite (`Claude.md §Analyse` ou `04-sprint-PDR-TEMPLATE.md`) plutôt qu'un pattern surveillé → décision : en attente.

### Sprint ECO-1 — 02/09/2026 — `sdlc-validate.sh` — vérification exécutable du modèle
**Code :** Script bash (308 lignes), 8 contrôles structurels en registre extensible. Le dry-run manuel des 8 commandes sur le repo réel avant tout code a trouvé 3 écarts entre le PDR et l'état réel du repo (bug de regex C1, faux positifs C3, 2 des 4 paires C4 sans skill installée) — tous tranchés avec l'utilisateur avant la première ligne de script. La revue adversariale (Blind Hunter, sous-agent en cécité) a ensuite trouvé 2 défauts réels malgré ce dry-run : un pré-vol de commandes (`awk`/`wc` jamais utilisés, `tr`/`head`/`basename`/`date`/`ls` réellement utilisés mais absents de la liste) et une phrase auto-référentielle fausse dans `00-CONTEXT.md` ("les 8 contrôles ci-dessus" ne renvoyait à rien). Les deux corrigés avant commit.
**Processus :** `.claude/sprint-memory.md` de nouveau réduit à son en-tête pour un sprint substantiel (décisions C1-C4/C6 arbitrées en conversation, jamais tracées en DÉCISION/TEST) — même lacune que SDLC-25. Le dry-run manuel avant codage (exécuter chaque commande candidate à la main sur le repo réel avant de l'intégrer au script) a payé : sans lui, C1/C3/C4 auraient probablement produit des faux positifs/négatifs découverts seulement en session de test, plus tard et plus cher.
**Lien pattern :** nouveau — un dry-run manuel des commandes d'un contrôle structurel avant de les coder dans le script attrape des écarts qu'aucune relecture de PDR ne peut voir (le PDR ne peut pas tester ses propres commandes sur l'état réel du repo au moment où il est écrit).
**Action proposée :** généraliser le dry-run manuel comme étape obligatoire avant d'écrire tout script de contrôle structurel (`sdlc-validate.sh` vagues 2/3, ou tout script similaire futur) → décision : en attente.
**SDLC candidat :** [SDLC_CANDIDATE] Le Blind Hunter délégué à un sous-agent sans accès au repo a produit 2 faux positifs sur 4 findings (hypothèses non vérifiables faute d'accès aux fichiers cités) à côté de 2 défauts réels confirmés — proportion à surveiller sur plusieurs sprints avant de juger le rapport valeur/coût de la délégation systématique en Taille M/L. → fichier cible : `03-wrap-up-SKILL-TEMPLATE.md §0f` · nature : donnée à accumuler, pas encore une règle — décision : en attente.

### Sprint SDLC-25 — 02/07/2026 — Migration `doc/` → `docs/` + publication du site de documentation
**Code :** N/A — sprint de gouvernance, zéro code applicatif.
**Processus :** Exécution mécanique propre (renommage + substitution `sed` + décision `M-ARCH-09`), mais `.claude/sprint-memory.md` ne contenait qu'une seule entrée pour un diff de 60 fichiers / 1804 insertions — traçabilité intra-sprint minimale. Wrap-up réalisé un mois après l'exécution (sprint-memory resté non vidé, commit non fait), déclenché par le démarrage du sprint suivant (`Claude.md` a correctement bloqué sur la règle "mémoire non vide, header différent du sprint en cours"). L'Adversarial Review du wrap-up (Taille M, 3 couches) a trouvé 6 défauts réels invisibles en session d'exécution : `README.md §Historique des versions` avec 3 lignes de faits datés falsifiées par le `sed` (le principe "fidélité historique" était explicitement acté pour `CHANGELOG.md`/`specs/Sprints/*.md` dans `M-ARCH-09` mais pas appliqué au bloc historique équivalent de `README.md`) ; un compte de fichiers erroné dans l'entrée `M-ARCH-09` elle-même (9 au lieu de 12) ; un bug de numérotation de sidebar dans `docs/nav.json` (deux fois "02", deux fois "03", jamais "04") ; un bandeau de version et une page d'historique du site désynchronisés de `meta.json`/`CHANGELOG.md` ; un tableau présentant `sdlc-init.sh` comme un skill. Tous corrigés avant commit, sur décision explicite de l'utilisateur de dépasser le §Portée initial ("bundle livré tel quel").
**Lien pattern :** nouveau — volumétrie `sprint-memory.md` sans rapport avec l'ampleur du diff (1 entrée pour 60 fichiers/1804 insertions), distinct de LL-T05 (ici la spec et la mémoire ont bien été créées en §Démarrage — c'est leur contenu qui est resté minimal pendant l'exécution) · nouveau pattern également : une règle de fidélité historique actée pour un fichier nommément désigné (`CHANGELOG.md`) n'est pas généralisée aux blocs de même nature ailleurs dans le repo (`README.md §Historique des versions`) — le principe existe mais sa portée n'est pas explicite.
**Action proposée :** généraliser la règle "fidélité historique" (`Claude.md §Modifications spot sur fichiers existants` ou `00-CONTEXT.md §Invariants`) à tout bloc de récit daté, pas seulement à `CHANGELOG.md` nommément → décision : en attente.
**SDLC candidat :** [SDLC_CANDIDATE] les défauts trouvés ici (versions désynchronisées entre README/CHANGELOG/site, comptage erroné dans une décision, données de structure incohérentes) sont exactement la classe de problème que `sdlc-validate.sh` (sprint ECO-1, déjà planifié au moment de ce wrap-up) vise à détecter mécaniquement — renforce la justification du sprint · fichier cible : `sdlc-validate.sh` (nouveau contrôle) · nature : nouveau contrôle — décision : ✅ traité — `sdlc-validate.sh` livré Sprint ECO-1 (02/09/2026), `M-PROC-40` (mis à jour `/retrospective` 03/09/2026).

### Sprint SDLC-Audit-GSTACK — 25/06/2026 — Audit externe GSTACK v1.58.4.0 vs modèle SDLC
**Code :** N/A — sprint Revue pur, zéro code métier.
**Processus :** Sprint Revue M sans étape de démarrage formelle — PDR fourni directement dans le message utilisateur. Spec sprint non créée en §4a, créée lors du wrap-up en Adversarial Review Couche 2. 2e occurrence de LL-T05. RAS par l'utilisateur en rétrospective.
**Lien pattern :** confirme LL-T05 (2e occurrence — sprint lancé sans §Démarrage = spec non créée au bon moment).
**Action proposée :** aucune — LL-T05 toujours en décision différée (réflexion Claude.ai en attente).

### Sprint SDLC-GSD-V2 — 25/06/2026 — Import GSD Vague 2 (graduation auto, hot/cold SESSION_BRIDGE, hypothesis tracking)
**Code :** N/A — sprint Doc pur, zéro code métier.
**Processus :** PDR prescrit ligne par ligne, exécution séquentielle propre. Hook PreToolUse a bloqué au démarrage (sprint-memory créé avant le fichier spec) — déblocage immédiat par création du fichier spec. Signal utile : le hook fonctionne correctement, la séquence §Démarrage reste critique.
**Lien pattern :** confirme LL-T03 (4e occurrence — PDR à contenu prescrit = exécution fluide sans aller-retour).
**Action proposée :** aucune — pattern déjà capturé (LL-T03).

### Sprint SDLC-GSD-V1 — 24/06/2026 — Import GSD Vague 1 (6 patterns friction nulle)
**Code :** N/A — sprint Doc pur, zéro code métier.
**Processus :** PDR pré-rempli avec contenu exact ligne par ligne (texte verbatim à insérer,
ancres textuels précis, ordre d'exécution) → zéro ambiguïté d'implémentation, zéro aller-retour
de clarification. Les 6 props ont été appliquées séquentiellement sans bloquer.
Confirme que le modèle "Driver prescrit, Navigator exécute" est le mode optimal pour les sprints Doc.
**Lien pattern :** confirme LL-T03 (3e occurrence — PDR à contenu prescrit = sous-décisions résolues avant exécution).
**Action proposée :** aucune — pattern déjà capturé.

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
`sub("\\.[0-9]+Z$"; "Z")` avant parsing (documenté `docs/DIAGNOSTIC_CMDS.md`).
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
ligne 51) — décision : **implémenté** — ECO-4 (03/09/2026), carve-out élargi
(`07-DECISIONS-SDLC.md M-HOOKS-04 → Mise à jour 03/09/2026`), champ mis à jour
`/retrospective` SDLC-27.

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
`08-hooks-TEMPLATE.md` (script) · nature : règle renforcée — décision : **tranché**
`/retrospective` 22/09/2026 (`SD-5`, ouvert 3 mois sans déclencheur) — sprint Fix dédié à
suivre, testé en isolation (`M-PROC-30`).

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
livrable `docs/AUDIT-EXTERNE-superpowers-vs-sdlc.md §8` (hook `SessionStart`
injectant automatiquement les règles absolues + HALT en contexte — répond
directement à LL-T05 ; table de rationalisations par HALT ; fusion de la
clause anti-complaisance avec une liste de formulations interdites) →
fichier cible : `08-hooks-TEMPLATE.md`, `01-Claude-md-TEMPLATE.md` ·
nature : nouveau mécanisme (hook) + renforcement de règles existantes —
décision : **tranché** `/retrospective` SDLC-27 (03/09/2026) — hook
`SessionStart` **rejeté** (vérification factuelle ECO-5 : `Claude.md`
recharge déjà nativement à startup/resume/clear/compact, aucune garantie de
conformité ajoutée) ; table de rationalisations HALT et fusion de la clause
anti-complaisance **déjà livrées** Sprint SDLC-19 (`01-Claude-md-TEMPLATE.md
§Règles absolues`, `M-PROC-32`)

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
**Processus :** Création de `docs/ROADMAP.md` pour le projet toolkit
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
oui, backfill historique non — voir `docs/DIAGNOSTIC_CMDS.md`)
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
`docs/LESSONS_LEARNED.md` vide (refus correct d'un contenu narratif en
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
décision : **implémenté sous une forme équivalente** — `pre-tool-bash.sh`
`M-HOOKS-04` (Sprint SDLC-18) bloque Bash/Edit/Write si `sprint-memory.md`
référence un spec absent du disque, même principe que la ligne bash
candidate ici. Champ mis à jour `/retrospective` SDLC-27.
**SDLC candidat :** [SDLC_CANDIDATE] Le bloc "Handoff Claude Code" d'un
PDR ne devrait peut-être pas pouvoir se substituer silencieusement à
`Claude.md §Démarrage` — questionner si `04-sprint-PDR-TEMPLATE.md`
devrait imposer que tout PDR rappelle explicitement les 4 étapes (4a-4d)
plutôt que de n'en lister qu'une partie → fichier cible :
`04-sprint-PDR-TEMPLATE.md` et/ou `Claude.md §Démarrage` · nature :
règle renforcée ou garde-fou de procédure — décision : **implémenté**
— Sprint SDLC-32 (22/09/2026), encart 4 lignes en tête de `§Handoff Claude Code`
(`M-TMPL-08`) — referme aussi `LL-T05`.

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
