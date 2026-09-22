# ROADMAP — SDLC Toolkit · v1.0

---

## ▶ Now — Sprint actif

| Item | Type | Taille | Statut |
|------|------|--------|--------|
| — | — | — | — En attente |

**Règle :** un seul item actif à la fois dans §Now.

---

## ⏭ Next — Prêt à démarrer

> Items dont les bloquants sont levés et le périmètre est défini.
> Peut démarrer dès que §Now est terminé.

| Item | Type | Taille | Débloque | Bloqué par | Déclencheur |
|------|------|--------|----------|------------|-------------|
| — | — | — | — | — | — En attente |

**Règle de passage Next → Now :** bloquants levés + spec rédigée ou rédigeable en < 30 min.

---

## 🗂 Later — Backlog

> Items identifiés mais non prioritaires ou bloqués.

| Item | Type | Taille | Débloque | Bloqué par | Déclencheur | Expiration |
|------|------|--------|----------|------------|-------------|------------|
| P-08 — Délégation par défaut (Extract, don't ingest) pour sprints L | Spike | S | — | Q1 stratégique (scope amont) | Si le scope du toolkit s'étend vers les phases amont — réévaluer le principe de délégation par défaut | — |
| P-15 — Architecture step-file (wrap-up / retrospective) | Refactor | S | — | Taille fichier | Si `03-wrap-up-SKILL-TEMPLATE.md` ou `09-retrospective-SKILL-TEMPLATE.md` dépasse ~500 lignes mesurées | — |
| P-16 — En-tête d'activation uniforme (6 étapes) | Doc | XS | — | Nouveau skill SDLC | Si un nouveau skill SDLC est créé au-delà de wrap-up / retrospective / sdlc-sync | — |
| P-17 — Dégradation gracieuse documentée (principe rédactionnel) | Doc | XS | — | Skill dépendant d'un script externe | Si un futur skill SDLC dépend d'un script externe (ex : `/diagnostic` outillé) | — |
| P-18 — Sharding `specs/SPEC.md` | Doc | XS | — | Taille SPEC.md | Si `specs/SPEC.md` d'un projet cible dépasse un seuil mesuré (ex : > 500 lignes) | — |
| P-19 — Séparation résumé/détail (roster-like) | Spike | S | — | Q4 stratégique (modes) | Si des "modes" sont formalisés dans `Claude.md §Rôle` (Q4) | — |
| P-21 — Revue mi-parcours par sous-agent dédié (sprints L) | Doc | S | — | Lecture de `code-reviewer.md` (Superpowers, non lu) | Si `code-reviewer.md` est consulté et confirme la pertinence du pattern pour `03-wrap-up-SKILL-TEMPLATE.md §Adversarial Review` | — |
| P-40 — §Lecture code obligatoire dans PDR Feature/Refactor (GSTACK /spec Technical gate — lire ≥ 3 fichiers, citer lignes avant §Plan) | Doc | XS | PDR qualité réelle | — | Exécutable directement — audit GSTACK, Idée 2 | — |
| P-41 — §État technique structuré dans SESSION_BRIDGE §Actif (3 champs : Fichiers modifiés / Décisions lockées / Prochaine action) | Doc | XS | Récupération session | — | Sprint suivant avec rupture de session mid-sprint | — |
| P-42 — Résurgence décisions récentes en début de session (lecture 5 dernières entrées DECISIONS-SDLC.md avant démarrage sprint) | Doc | XS | Cohérence décisions | — | Exécutable directement — audit GSTACK, Idée 1 | — |
| P-43 — Rôles spécialisés distincts dans §0f wrap-up (split Blind Hunter / Edge Case Hunter / Acceptance Auditor en skills séparés) | Spike | S | §0f qualité | — | Si sprint M disponible pour test — audit GSTACK §Rôles spécialisés | — |
| P-44 — Revue cross-modèle optionnelle dans §0f (couche Codex CLI si disponible — vraie indépendance vs simulation) | Doc | S | §0f indépendance | — | Si Codex CLI disponible en session — audit GSTACK §/codex | — |
| P-23 — Résumé compressé auto-généré pour DECISIONS-SDLC.md (texte complet conservé, vue par défaut allégée) | Tuning | S | — | Mesure M3 réelle | ≥ 1 mesure M3 disponible | — |
| P-24 — Taille XS/S/M/L recalibrée avec coût token empirique + signal d'anomalie douce en /retrospective | Tuning | M | — | ≥ 5 sprints mesurés | sdlc-token-usage.sh actif sur ≥ 5 sprints | — |
| P-25 — Dry-run syntaxique de la commande de test avant §Plan d'exécution (4d) | Tuning | XS | — | — | Exécutable directement | — |
| P-26 — Aval unique par sprint (pas par sous-étape) + vérification batching active en §4a | Doc | XS | — | — | Durcissement direct de règle existante | — |
| P-28 — Détection cache_creation anormal en milieu de session (signal expiration TTL liée au délai humain) | Feature | S | — | P-36 (script étendu) | Script de base en place | — |
| P-29 — Ligne de pacing informative en wrap-up §0d ("≈X% d'une tranche typique") — non bloquant | Tuning | S | — | Baseline tranche horaire | Plusieurs sessions mesurées | — |
| P-31 — Évaluer le Mode Plan natif (Shift+Tab) comme remplacement de §4d manuel | Spike | S | — | Vérification doc Claude Code | Interaction avec règle "aval explicite" confirmée | — |
| P-32 — Recommandation "prompt structuré" formalisée dans docs/MODE-OPERATOIRE.html | Doc | XS | — | — | Exécutable directement | — |
| P-33 — Vérification .gitignore ajoutée aux critères d'acceptation du Sprint 0 (06-PDR-bootstrap.md) | Doc | XS | — | — | Pour projets cibles avec code | — |
| P-34 — Calibrage empirique du seuil délégation sous-agent (>5 fichiers / >10K tokens) | Tuning | S | — | Données réelles | sdlc-token-usage.sh actif sur ≥ 5 sprints | — |
| P-35 — Réordonnancement Claude.md pour maximiser cache hit (stable en tête, volatile en fin) | Tuning | S | — | Mesure cache_read réelle | sdlc-token-usage.sh disponible sur ≥ 3 sprints | — |
| P-36 — Extension sdlc-token-usage.sh → package figé (diff + critères) pour Adversarial Review Couche 1 | Feature | S | — | Script de base validé | Sur un sprint Taille M/L réel | — |
| P-37 — 00-CONTEXT.md déclaré Index-guidé formellement (résorbe duplication invariants + carte fichiers) | Doc | S | — | — | Exécutable directement | — |
| P-38 — Déplacer commentaire goal-backward (Prop F) avant le bloc BDD optionnel dans 04-PDR §CA | Doc | XS | — | — | Exécutable directement | — |
| ECO-6 — Lexique ubiquitaire versionné (`E-05`, `specs/SPEC.md §Lexique`) | Doc | S | — | — | Moins urgent qu'ECO-2→4 — pas de déclencheur numérique, priorité éditoriale | — |
| ECO-2b — Frontmatter YAML + `disable-model-invocation: true` sur les 4 templates de skill (`E-16`) | Doc | S | — | Conflit avec C2 de `sdlc-validate.sh` | Différé au wrap-up ECO-2 (03/09/2026) : `---` doit être la 1ère ligne du fichier pour être reconnu par Claude Code, ce qui pousse le marqueur de version (`<!-- Template SDLC vX.Y -->`, actuellement lignes 1-3) au-delà de la fenêtre vérifiée par C2. Nécessite d'ajuster C2 (chercher le marqueur après un éventuel bloc frontmatter) dans le même sprint que le frontmatter — sinon régression sciemment introduite. | — |

**Règle de passage Later → Next :** déclencheur atteint OU décision humaine explicite.
**Renumérotation au merge (wrap-up SDLC-22) :** les items "Sprint Lean" reçus sous P-20/P-21/P-22
collisionnaient avec des IDs déjà attribués à des items différents — renumérotés en P-35/P-36/P-37
sur confirmation explicite. P-30 attribué à l'item §Next "Hook PreCompact" (référencé tel quel par
P-27 dans le contenu reçu, préfixe manquant dans le texte source).

---

## §Seuils métriques déclencheurs

> Seuils quantitatifs qui font passer un item Later → Next automatiquement.
> À définir après le premier sprint de mesure.

- À définir

---

## §Signaux faibles

> Canal informel pour idées non matures. Max 5 lignes.
> Critère de passage vers §Later : idée assez concrète pour écrire un contexte de 3 phrases.

- **Pipeline génération templates** (GSTACK .tmpl→.md) — si templates SDLC commencent à diverger entre versions ou projets, envisager un système de génération (template source → document final). Pas urgent, signal de déclenchement : dérive détectée dans ≥ 2 templates entre deux projets.
- **Diataxis pour documentation externe SDLC** — si le SDLC Toolkit est documenté pour d'autres équipes, structurer en tutorial/how-to/reference/explanation (GSTACK /document-generate). Déclencheur : décision de publication externe.
- **Timeline SDLC (events structurés)** — journal `sdlc-timeline.jsonl` pour trending retro longitudinal (sessions, durée, taille sprint). Déclencheur : cadence > 1 sprint/semaine ou ≥ 10 sprints mesurés.

---

## Tailles de référence

| Taille | Durée estimée | Exemples |
|--------|--------------|---------|
| XS | < 1h | Correction config, ajout d'une règle doc |
| S | 1-3h | Nouveau parseur simple, ajout d'un champ |
| M | 3h-1j | Nouveau module, refactor ciblé, audit |
| L | > 1j | Refonte architecture, nouveau pipeline |

---

## Historique — Sprints complétés

<!-- Déplacer ici les sprints terminés depuis §Now, avec leur tableau de livrables -->

| Item | Type | Taille | Sprint | Livrables |
|------|------|--------|--------|-----------|
| SDLC-32 — Rappel 4a-4d dans le PDR, réévaluation `LL-T05` | Doc | XS | SDLC-32 (22/09/2026) | Encart 4 lignes `04-sprint-PDR-TEMPLATE.md §Handoff` · clôt `SDLC_CANDIDATE` SDLC-16 et `LL-T05` (2 occurrences, résolu sans mécanisation) · `M-TMPL-08` |
| SDLC-31 — `/retrospective` (SDLC-28→SDLC-30) | Revue | S | SDLC-31 (22/09/2026) | `LL-T14` gradué (`M-PROC-48`) · `LL-T05` réévalué · `SDLC_CANDIDATE` SDLC-16/SDLC-18 tranchés (`SD-5`) — sprints Fix dédiés à suivre |
| [SDLC_CANDIDATE] Normalisation `README.md §Structure du repo` — clos, pas repris | Doc | XS | Fix (22/09/2026) | 2 inexactitudes corrigées (scripts groupés, `docs/` résumé, `LICENSE`/`specs/`/`.claude/` ajoutés) · C6 reste à 2 listes, décision tranchée plutôt que 3e liste — contredirait le principe anti-duplication de `00-CONTEXT.md §1` (ECO-2) · `M-PROC-47` |
| SDLC-30 — Rattrapage `SPEC.html` / `MODE-OPERATOIRE.html` (figés à v1.4 depuis 23 versions) | Doc | L | SDLC-30 (21/09/2026) | Marqueur de version + carte des 14 fichiers/5 scripts dans les 2 HTML · contrôle `check_c10` (`M-PROC-46`) — testé sur les 2 HTML d'origine (❌) et 4 fixtures isolées · `SPEC.html` table des 74 décisions remplacée par un résumé de 6 familles renvoyant à `07-DECISIONS-SDLC.md` · rendu vérifié par captures Chromium headless |
| P-22 — `12-audit-externe-TEMPLATE.md` (renuméroté 10→12, collision `10-AMONT-TEMPLATE.md`) | Doc | XS | SDLC-29 (04/09/2026) | 7 sections, tableau 6 axes, verdicts `IMPORTER/REJETER/INVESTIGUER/MERGER` — squelette repris de `docs/AUDIT-EXTERNE-gstack-vs-sdlc.md §7` · `M-TMPL-07` · `00-CONTEXT.md`/`specs/SPEC.md §Modules` mis à jour |
| P-27 — `sprint-memory.md` documenté comme mécanisme de reprise + P-39 (déjà résolu, retiré) | Doc | S | SDLC-28 (04/09/2026) | Correction de 2 citations fautives dans `Claude.md`/`01-Claude-md-TEMPLATE.md §Mémoire de sprint` (`M-HOOKS-XX`→`M-HOOKS-08`, `Étend M-PROC-13`→`M-PROC-10`) · nouvelle carte `docs/MODE-OPERATOIRE.html §Concepts clés` (« Reprise après coupure ») · sous-bloc `→ Mise à jour` sous `M-HOOKS-08` · `P-39` confirmé déjà résolu par la discipline de sync skill/template appliquée depuis GSD-V2, retiré sans code |
| `/retrospective` — Sprints ECO-3→ECO-5 (2 sprints d'écart, déclenchée manuellement) | Revue | S | SDLC-27 (03/09/2026) | Garde-fou traçabilité `sprint-memory.md` (`M-PROC-44`, `LL-T08` gradué 4e occurrence) · rappel fenêtre `grep -A` dans `04-sprint-PDR-TEMPLATE.md` (`LL-T12` nouveau) · index `LESSONS_LEARNED` recompté (`LL-T10` 2e occurrence) · 2 vieux `SDLC_CANDIDATE`/`HOOK_CANDIDATE` clos (SDLC-16/17 hook `SessionStart` invalidé par `ECO-5` ; rationalisations HALT + fusion clause déjà livrées SDLC-19 ; `test -f spec` déjà couvert par `M-HOOKS-04`) |
| P-20 — Hook SessionStart, rescopé en documentation `.claude/rules/` | Doc | S | ECO-5 (03/09/2026) | `01-Claude-md-TEMPLATE.md` v2.4 §Tokens (+bullet `.claude/rules/`, seuil ~200 lignes + frontière `paths:` réelle) · `M-TMPL-06` · hook `SessionStart` et self-split de ce repo écartés après vérification factuelle (`Claude.md` recharge déjà nativement à startup/resume/clear/compact ; aucune frontière `paths:` naturelle dans ce repo) · `LL-T05` non touché (décision utilisateur explicite) |
| ECO-4 — Durcissement PDR (`E-13(b)`+`E-14`+`E-06`+`E-07`) | Doc | S | ECO-4 (03/09/2026) | `04-sprint-PDR-TEMPLATE.md` v2.2 §Pas de placeholders · grep d'enforcement wrap-up étendu (`03-wrap-up-SKILL-TEMPLATE.md` v1.8 + skill vivant) · `01-Claude-md-TEMPLATE.md` v2.3 §Auto-revue du plan + champ `[coût si faux]` + règle de précédence ledger/git · `M-PROC-43` · `E-07` infirmé pour moitié après vérification factuelle · `LL-T07` clos (carve-out `pre-tool-bash.sh` élargi à `sprint-memory.md`, hors PDR initial sur aval explicite) · `LL-T08` seuil de surveillance atteint (3e occurrence) · nouveau `LL-T11` |
| ECO-3 — Barre qualité chiffrée et cliquet de contexte | Doc | M | ECO-3 (03/09/2026) | `02-STANDARDS-TEMPLATE.md` v2.0 §Barre qualité (seuils, plancher anti-affaiblissement, cliquet M1 10%, exceptions) · règle absolue anti-affaiblissement (`Claude.md`/`01-Claude-md-TEMPLATE.md`) · DoD référencée (`04-PDR`, `03-wrap-up`) · `M-PROC-42` · `E-04` infirmé après vérification factuelle |
| `/retrospective` — Sprints SDLC-21→ECO-2 (8 sprints d'écart) | Revue | S | SDLC-26 (03/09/2026) | Index `LESSONS_LEARNED` recompté (`LL-T03` 2→4, `LL-T04` 1→7) · `LL-T04` gradué → `Claude.md §Analyse` + `01-Claude-md-TEMPLATE.md` v2.1 (`M-PROC-41`) · 3 nouveaux patterns `LL-T08/09/10` · `LL-T05`/`LL-T07` différés avec déclencheur nommé · `§Métriques de rétro` (M1/M2/token usage) |
| ECO-2 — Rédaction des templates (description = déclenchement, forme selon type d'échec) | Doc | S | ECO-2 (03/09/2026) | `00-CONTEXT.md` v1.7 §5 (E-08 + E-09, exemples SDLC) · en-tête `04b-sdlc-sync-SKILL-TEMPLATE.md` réécrit · `M-TMPL-05` · ligne `/help` §4 (E-17) · `E-16` écarté après vérification factuelle → `ECO-2b` §Later |
| ECO-1 — `sdlc-validate.sh` — vérification exécutable du modèle (8 contrôles tier 1) | Feature | M | ECO-1 (02/09/2026) | `sdlc-validate.sh` (nouveau, registre extensible) · Étape 3.5 wrap-up (template + skill vivant) · `00-CONTEXT.md` v1.6 · `README.md` (défaut C1 corrigé) · `M-PROC-40` · `specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md` (26 patterns) · ECO-2→4 débloqués §Next, ECO-6 §Later |
| SDLC-25 — Migration `doc/` → `docs/` + publication du site de documentation (GitHub Pages) | Feature | M | SDLC-25 (02/07/2026) | `docs/` (renommage `git mv` + site statique multi-pages) · `M-ARCH-09` · `00-CONTEXT.md` v1.5 · `specs/SPEC.md §Modules` · Adversarial Review wrap-up : 6 défauts corrigés (fidélité historique README, compte fichiers M-ARCH-09, numérotation nav.json, version/historique site) |
| SDLC-Audit-GSTACK — Audit externe GSTACK v1.58.4.0 vs modèle SDLC | Revue | M | SDLC-Audit-GSTACK (25/06/2026) | `docs/AUDIT-EXTERNE-gstack-vs-sdlc.md` (20 recommandations : 4 IMPORTER/7 INVESTIGUER/2 MERGER/7 REJETER) · P-22 §Later→§Next · P-40–P-44 §Later · 3 signaux faibles |
| SDLC-GSD-V2 — Import GSD Vague 2 (graduation auto, hot/cold SESSION_BRIDGE, hypothesis tracking) | Doc | M | SDLC-GSD-V2 (25/06/2026) | `09-retrospective-SKILL-TEMPLATE.md` v1.8 (+GRADUATION auto) · `03-wrap-up-SKILL-TEMPLATE.md` v1.6 (+§Actif/§Archive +archivage conditionnel +hypothesis tracking) · `01-Claude-md-TEMPLATE.md` v2.0 (+awk §Actif) · `M-PROC-39` |
| SDLC-GSD-V1 — Import GSD Vague 1 (6 patterns) | Doc | M | SDLC-GSD-V1 (24/06/2026) | `01-Claude-md-TEMPLATE.md` v1.9 (+/fast) · `03-wrap-up-SKILL-TEMPLATE.md` v1.5 (+STATELESS) · `04-sprint-PDR-TEMPLATE.md` v2.0 (+goal-backward +SPIDR +Signaux L) · `05-ROADMAP-TEMPLATE.md` v1.1 (+Seed) · `M-PROC-38` |
| P-30 — Hook PreCompact × sprint-memory.md | Feature | S | SDLC-23 (21/06/2026) | `.claude/hooks/pre-compact.sh` · 2 entrées `settings.json` (matcher manual/auto) · 7e type `CHECKPOINT` (`Claude.md`, `01-Claude-md-TEMPLATE.md`) · `08-hooks-TEMPLATE.md` v1.3 §PreCompact · `M-HOOKS-08` |
