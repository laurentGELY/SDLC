# SESSION_BRIDGE — Contexte inter-session
<!-- §Actif : ≤ 3 entrées récentes — chargé automatiquement au §Démarrage -->
<!-- §Archive : entrées plus anciennes — chargé sur demande explicite uniquement -->

## §Actif

### [Sprint ECO-7 — durcissement-validate] · 2026-09-23
**Commit :** 437ca42
**Bloquants en suspens :** aucun
**Fil fonctionnel :** `sdlc-validate.sh` a sa suite de tests (`bash tests/sdlc-validate-test.sh` → 15/15 : chaque contrôle C1→C10 vu rouge sur un défaut injecté dans une copie du dépôt, via `SDLC_VALIDATE_ROOT`), et C3 lit ligne par ligne — l'exemption de 3 fichiers entiers est remplacée par une exception de ligne sur le motif `M-TMPL-01` (`M-PROC-40` → Mise à jour : exception au grain ligne + cas RED obligatoire pour tout nouveau contrôle). La suite n'est pas encore appelée par l'Étape 3.5 du wrap-up ni couverte par C8 — `SDLC_CANDIDATE` ouvert dans `docs/LESSONS_LEARNED.md` ; `sdlc-validate.sh` 10/10.

### [Sprint SDLC-Import-Strands-Harness — import R3 + R4 (P-45)] · 2026-09-23
**Commit :** b898daa
**Bloquants en suspens :** aucun
**Fil fonctionnel :** Audit Strands intégré et clos : `02-STANDARDS-TEMPLATE.md` v2.1 porte des exemples d'observabilité agent/LLM (`M-TMPL-09`), `08-hooks-TEMPLATE.md` v1.4 un tableau du rôle de chaque hook ; l'erreur « `exit 1` bloque » (fausse depuis ≥ SDLC-18, seul `exit 2` bloque) est corrigée dans le template et le hook actif. Seed P-46 (HALT-TIMEOUT) en §Later, 2 `SDLC_CANDIDATE` ouverts dans `docs/LESSONS_LEARNED.md` (chemins réels dans les PDR Claude.ai · source datée pour tout comportement Claude Code) ; `sdlc-validate.sh` 10/10.

### [Sprint SDLC-Audit-Strands-Harness — audit externe Strands Harness] · 2026-09-23
**Commit :** daa5b9c
**Bloquants en suspens :** aucun
**Fil fonctionnel :** `docs/AUDIT-EXTERNE-strands-harness-vs-sdlc.md` livré, 1er audit au gabarit 12 : Strands Harness est un runtime d'agent (concurrent de Claude Code), pas une gouvernance — 3 recommandations sur 5 rejetées comme runtime, 1 IMPORTER (exemples observabilité agent/LLM dans `02-STANDARDS-TEMPLATE.md`, `M-TMPL-09` rédigé mais non reporté) et 1 ADAPTER (rôle des hooks dans `08-hooks-TEMPLATE.md`), aucun template modifié. Import R3+R4 inscrit en `P-45` (`docs/ROADMAP.md §Later`, déclencheur = décision humaine) ; verdict `ADAPTER` hors gabarit 12, 1ʳᵉ occurrence. `sdlc-validate.sh` 10/10.

## §Archive

### [Sprint SDLC-30 — Rattrapage SPEC.html/MODE-OPERATOIRE.html + C10] · 2026-09-21
**Commit :** c00fac9
**Bloquants en suspens :** aucun
**Fil fonctionnel :** Les deux livrables HTML de lecture humaine, figés à v1.4 depuis 23 versions (invisible faute de contrôle), sont remis à v2.0+SDLC-30 : carte complète des 14 fichiers et 5 scripts, vérification factuelle, auto-revue, barre qualité, `sdlc-validate.sh` désormais documentés ; table des 74 décisions de `SPEC.html` remplacée par un résumé renvoyant à `07-DECISIONS-SDLC.md`. Contrôle `check_c10` (`M-PROC-46`) les surveille désormais, testé sur les 2 HTML d'origine (❌ confirmé) et 4 fixtures isolées. `sdlc-validate.sh` 10/10. Prochaine action : `docs/ROADMAP.md §Next` est vide — prochain choix depuis `§Later`, ou candidat `/retrospective` sur le motif « chiffres figés dérivent » relevé ce sprint (`docs/LESSONS_LEARNED.md` Sprint SDLC-30).

### [Sprint SDLC-29 — 12-audit-externe-TEMPLATE.md] · 2026-09-04
**Commit :** 74cabd8
**Bloquants en suspens :** aucun
**Fil fonctionnel :** `12-audit-externe-TEMPLATE.md` livré (7 sections, tableau 6 axes, verdicts `IMPORTER/REJETER/INVESTIGUER/MERGER`) — squelette repris de `docs/AUDIT-EXTERNE-gstack-vs-sdlc.md §7`, renuméroté 10→12 sur collision détectée avant code (`10-AMONT-TEMPLATE.md` déjà présent). `M-TMPL-07`. `docs/ROADMAP.md §Next` est maintenant **vide** — aucun item prêt à démarrer, prochain choix à faire depuis `§Later`. `LL-T08` 6e occurrence, `M-PROC-44` déclenché 2 fois consécutives (SDLC-28, SDLC-29) — signalé les 2 fois, escalade explicitement déclinée par l'utilisateur, pas de réouverture. `sdlc-validate.sh` 8/8.

### [Sprint SDLC-28 — sprint-memory.md = mécanisme de reprise] · 2026-09-04
**Commit :** 90dc3e1
**Bloquants en suspens :** aucun
**Fil fonctionnel :** `Claude.md`/`01-Claude-md-TEMPLATE.md §Mémoire de sprint` corrigés — 2 citations fautives introduites SDLC-23 (`M-HOOKS-XX`→`M-HOOKS-08`, `Étend M-PROC-13`→`M-PROC-10`), non détectées pendant 5 sprints. `docs/MODE-OPERATOIRE.html` reçoit une carte « Reprise après coupure » (mécanisme absent jusqu'ici de toute doc humaine). `P-39` vérifié déjà résolu (parité skill↔template déjà totale) et retiré sans code. Nouveau `LL-T13` (résidu `M-XXXX-NN` non détecté par `sdlc-validate.sh C3`, 1 occurrence). `M-PROC-44` (garde-fou traçabilité, créé hier) s'est déclenché pour la 1ère fois ce sprint — fonctionne comme prévu. `sdlc-validate.sh` 8/8. Prochaine action : `docs/ROADMAP.md §Next` ne porte plus que `P-22` (template audit externe, XS) — voir aussi `LL-T13` (surveiller si 2e occurrence) et les 2 `SDLC_CANDIDATE` encore ouverts (SDLC-18 résolution de chemin, SDLC-16 restatement 4a-4d PDR).

### [Sprint ECO-5 — Pattern .claude/rules/ documenté] · 2026-09-03
**Commit :** 7a96829
**Bloquants en suspens :** aucun
**Fil fonctionnel :** `01-Claude-md-TEMPLATE.md §Tokens` documente `.claude/rules/` (seuil ~200 lignes + frontière `paths:` réelle) pour les projets cibles — `M-TMPL-06`. `P-20` (hook `SessionStart`) et un self-split de ce repo écartés après vérification factuelle (`Claude.md` recharge déjà nativement à startup/resume/clear/compact ; aucune frontière `paths:` naturelle ici). `LL-T05` non touché (décision utilisateur explicite). `LL-T08` atteint sa 4e occurrence consécutive — garde-fou en cours de décision dans une `/retrospective` lancée en cours de session (couvre `ECO-3→ECO-4`, `LL-T08` et 2 vieux `SDLC_CANDIDATE` liés à `LL-T05` à trancher). `sdlc-validate.sh` 8/8. Prochaine action : terminer la `/retrospective` en cours (garde-fou `LL-T08`, clôture `SDLC_CANDIDATE` SDLC-16/17, nouveau pattern `LL-T12` grep -A mal calibré) avant tout nouveau sprint.

### [Sprint ECO-4 — Durcissement PDR] · 2026-09-03
**Commit :** b0e7f3b
**Bloquants en suspens :** aucun
**Fil fonctionnel :** `04-sprint-PDR-TEMPLATE.md §Pas de placeholders` (6 motifs interdits + grep, repris dans l'enforcement du wrap-up), `01-Claude-md-TEMPLATE.md §Analyse §Auto-revue du plan` (3 passes avant l'aval), champ `[coût si faux]` sur `DÉCISION`, règle de précédence ledger/`git log` après compaction (`M-PROC-43`). Vérification factuelle avant PDR a infirmé `E-07` pour moitié (ligne d'identité déjà présente) — portée réduite. Miss réel repéré au wrap-up : `LL-T07` (déclencheur nommé pour ce sprint dans `LESSONS_LEARNED.md`) non lu à la rédaction du PDR — traité hors PDR sur aval explicite (carve-out `pre-tool-bash.sh` élargi à `sprint-memory.md`). `LL-T08` atteint son seuil de surveillance (3e occurrence : `sprint-memory.md` réduit à son en-tête) — décision de garde-fou différée à `/retrospective`. Nouveau `LL-T11`. `sdlc-validate.sh` 8/8. Prochaine action : `ECO-5`/`P-20` (hook SessionStart) ou `LL-T08` (garde-fou traçabilité sprint-memory) — voir `docs/ROADMAP.md §Next` et prochaine `/retrospective`.

### [Sprint ECO-3 — Barre qualité et cliquet de contexte] · 2026-09-03
**Commit :** 6670581
**Bloquants en suspens :** aucun
**Fil fonctionnel :** `02-STANDARDS-TEMPLATE.md §Barre qualité` (seuils, plancher anti-affaiblissement, cliquet M1 10%, exceptions datées), règle absolue anti-affaiblissement, DoD référencée aux 2 points qui n'en disposaient pas. Vérification factuelle avant PDR (`M-PROC-41`) a infirmé `E-04` de l'ANALYSE (DoD déjà consolidée) — portée réduite en conséquence. Adversarial Review a trouvé et corrigé 3 défauts (doublon de phrase, confusion M1/M2 dans une justification, version affirmée sans preuve). `LL-T10` confirmé (2e occurrence). `sdlc-validate.sh` 8/8. Prochaine action : `ECO-4` (durcissement PDR) ou `ECO-5`/`P-20` (hook SessionStart) — les deux en `docs/ROADMAP.md §Next`.

### [Sprint ECO-2 — Rédaction des templates] · 2026-09-03
**Commit :** 26dfb79
**Bloquants en suspens :** aucun
**Fil fonctionnel :** `00-CONTEXT.md §5` pose 2 règles de rédaction (description=déclenchement E-08, forme selon échec E-09), en-tête `04b-sdlc-sync-SKILL-TEMPLATE.md` réécrit. `E-16` (frontmatter + `disable-model-invocation`) vérifié factuellement puis écarté — conflit réel avec C2 de `sdlc-validate.sh` (frontmatter exige `---` en 1ère ligne) — différé en `ECO-2b §Later`. `sdlc-validate.sh` 8/8, non-régression confirmée. `docs/LESSONS_LEARNED.md` note pour `/retrospective` : 3 confirmations consécutives de `LL-T04` (SDLC-25/ECO-1/ECO-2) sous-comptées dans l'index, à reclasser et évaluer pour graduation. Prochaine action : `ECO-3` (barre qualité) ou `ECO-4` (durcissement PDR) — les deux débloqués en `docs/ROADMAP.md §Next`.

### [Sprint ECO-1 — sdlc-validate.sh] · 2026-09-02
**Commit :** 720f2be
**Bloquants en suspens :** aucun
**Fil fonctionnel :** `sdlc-validate.sh` (nouveau, racine) vérifie 8 aspects structurels du modèle en registre extensible, appelé à l'Étape 3.5 du wrap-up. 8/8 sur le repo actuel. Adversarial Review a trouvé et corrigé 2 défauts (pré-vol de commandes désaligné, phrase auto-référentielle fausse dans `00-CONTEXT.md`). ECO-2/3/4 débloqués en `docs/ROADMAP.md §Next` (rédaction templates, barre qualité, durcissement PDR — catalogue complet dans `specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md`, 26 patterns). `[SDLC_CANDIDATE]` ouvert : proportion faux positifs/vrais défauts du Blind Hunter délégué à surveiller sur plusieurs sprints.

### [Sprint SDLC-25 — Migration doc/ → docs/ + site de documentation] · 2026-07-02
**Commit :** 831b60d
**Bloquants en suspens :** activation GitHub Pages ("Deploy from branch → main → /docs") — action humaine hors Claude Code, non exécutée
**Fil fonctionnel :** `docs/` remplace `doc/` partout (git mv + sed vérifié), site statique multi-pages prêt à publier (`docs/index.html` + `nav.json`/`meta.json` + 18 pages). Adversarial Review au wrap-up a trouvé et corrigé 6 défauts du bundle livré (historique README falsifié, compte fichiers M-ARCH-09, numérotation sidebar, version/historique du site désynchronisés) + 2 défauts dans `sdlc-init.sh` (bug sed préexistant rendant le bootstrap non fonctionnel depuis l'origine, et un dossier `doc/` résiduel introduit par ce sprint) — les deux corrigés et revalidés. Prochaine action prévue : Sprint ECO-1 (`sdlc-validate.sh`, contrôle exécutable du modèle) déjà en PDR — plusieurs défauts trouvés ici (versions désynchronisées, comptages erronés) sont exactement ceux que ce script vise à automatiser.

### [Sprint SDLC-Audit-GSTACK — Audit externe GSTACK] · 2026-06-25
**Commit :** d857b22
**Bloquants en suspens :** aucun
**Fil fonctionnel :** Audit GSTACK v1.58.4.0 (Garry Tan / YC) — 20 recommandations (4 IMPORTER / 7 INVESTIGUER / 2 MERGER / 7 REJETER). Verdict : adoption sélective, pas d'intégration globale. P-22 déplacé §Later→§Next. Nouveaux items ROADMAP : P-40–P-44 (§Lecture code PDR, §État technique SESSION_BRIDGE, résurgence décisions, rôles §0f, cross-modèle). Prochaine action : P-39 (sync skills) ou P-22 (template audit) ou P-40/P-42 (XS immédiats).

### [Sprint SDLC-GSD-V2 — Import GSD Vague 2] · 2026-06-25
**Commit :** 0a3f300
**Bloquants en suspens :** aucun
**Fil fonctionnel :** Trois mécanismes Vague 2 livrés : graduation semi-automatique dans /retrospective (scan §Index, ≥ 3 occurrences/5 sprints → 4 destinations), SESSION_BRIDGE hot/cold (§Actif ≤ 3 / §Archive), hypothesis tracking conditionnel Diagnostic/BUG. Templates SDLC à v2.0.

### [Sprint SDLC-GSD-V1 — Import GSD Vague 1] · 2026-06-24
**Commit :** c3abfc1
**Bloquants en suspens :** aucun — 6 props livrées, "all good" rétrospective.
**Fil fonctionnel :** 4 templates SDLC enrichis avec patterns GSD (STATELESS HANDOFF dans wrap-up, guidance goal-backward + SPIDR + signaux Taille L dans PDR, Seeds dans ROADMAP, /fast dans Claude.md). Adversarial Review : 0 finding critique, 1 item cosmétique ajouté en P-38 §Later.

### [Sprint SDLC-22 — instrumentation conso token réelle] · 2026-06-21
**Commit :** 6dcc1f0
**Bloquants en suspens :** aucun — rétrospective utilisateur "all good" (3 volets).
**Fil fonctionnel :** `sdlc-token-usage.sh` (nouveau, racine) mesure les totaux input/output/cache depuis les transcripts JSONL. `09-retrospective-SKILL-TEMPLATE.md` porte une `§Étape 7 — Métriques tokens`. Les deux skills locaux synchronisés avec les templates dans le même commit (`M-PROC-36`).

### [Sprint SDLC-20 — étiquette HYPOTHÈSE sur tables HALT] · 2026-06-20
**Commit :** 51e29bb
**Bloquants en suspens :** aucun — rétrospective utilisateur "all good" (3 volets).
**Fil fonctionnel :** Les 5 tables de rationalisation HALT (`01-Claude-md-TEMPLATE.md`) portent désormais l'étiquette `[HYPOTHÈSE — non confirmée, adaptée de Superpowers]`. `M-PROC-35` clôt un aller-retour à 3 passages. `[HOOK_CANDIDATE]` ouvert (`LL-T07`) : élargir le carve-out M-HOOKS-04 à `sprint-memory.md` lui-même.

### [Sprint SDLC-19 — import-superpowers] · 2026-06-19
**Commit :** ce47424
**Bloquants en suspens :** aucun — rétrospective utilisateur "all good" (3 volets).
**Fil fonctionnel :** `01-Claude-md-TEMPLATE.md` porte désormais 11 paires de rationalisation sous les 5 HALT + la règle 4a/4b/4c/4d. `02-STANDARDS-TEMPLATE.md` reconnaît "Revue" comme type de sprint. SDLC_CANDIDATE #1 (hook SessionStart) et 2 autres items reclassés dans `docs/ROADMAP.md` (P-20/21/22).

### [Sprint SDLC-18 — fix-hooks-m04] · 2026-06-19
**Commit :** 9f6bc73
**Bloquants en suspens :** aucun — incident d'auto-verrouillage de session survenu et résolu dans ce même sprint (cf. `07-DECISIONS-SDLC.md M-HOOKS-04`).
**Fil fonctionnel :** Le hook `PreToolUse` extrait le schéma JSON réel (les blocages `[UNIVERSEL]` étaient silencieusement inopérants depuis SDLC-14, corrigé) et porte désormais M-HOOKS-04 (garde-fou étape 4a, carve-out Write/Edit) + M-HOOKS-06 (allowlist Bash lecture seule).

### [Sprint SDLC-17 — audit-superpowers] · 2026-06-19
**Commit :** 135eb24
**Bloquants en suspens :** aucun — LL-T05 reste ⏳ (réflexion en Claude.ai toujours prévue).
**Fil fonctionnel :** Audit comparatif statique `obra/superpowers` (174k★, 14 skills) vs modèle SDLC produit dans `docs/AUDIT-EXTERNE-superpowers-vs-sdlc.md` — mapping complet, 4 invariants analysés, recommandations étiquetées. Zéro fichier de gouvernance modifié ce sprint.

### [Sprint SDLC-16 — audit-complet] · 2026-06-19
**Commit :** 9f35250
**Bloquants en suspens :** LL-T05 — garde-fou manquant pour `Claude.md §Démarrage` étape 4a ; HOOK_CANDIDATE et SDLC_CANDIDATE notés en `⏳`.
**Fil fonctionnel :** Les 9 sprints SDLC-07→15 sont audités et confirmés contre l'état réel du repo (8 ATTEINT, 1 scindé self-bootstrap/rattrapage). `docs/LESSONS_LEARNED.md` ne contient plus d'affirmation narrative non marquée.

### [Sprint SDLC-05b — gouvernance-observabilite] · 2026-06-14
**Commit :** b3e9f25
**Bloquants en suspens :** aucun
**Fil fonctionnel :** Le toolkit dispose de sdlc-project-check.sh (génère docs/CLAUDE_PROJECT.md versionné), d'une §Observabilité STANDARDS vérifiable par grep (5 Q/R [À REMPLIR]), et d'un champ Volumétrie minimum dans le PDR.

### [Sprint SDLC-05a — wrapup-robustesse] · 2026-06-14
**Commit :** 9e94abb
**Bloquants en suspens :** aucun
**Fil fonctionnel :** Le wrap-up produit désormais un verdict d'objectif (ATTEINT/PARTIEL/NON ATTEINT) ancré sur spec + git diff, et persiste le contexte inter-session dans docs/SESSION_BRIDGE.md versionné.
