Statut : ouvert
# Sprint SDLC-34 — Suite de l'agrégation des remontées Job search (lots 2, 3, 4 de SDLC-33)
<!-- PDR repris mot pour mot de specs/Sprints/sprint-SDLC-33-agregation-remontees-jobsearch.md (sections « Lot 2 », « Lot 3 », « Lot 4 », critères d'acceptation [→ SDLC-34], §Annexe) après la coupe du 20/11 · ouvert le 2026-11-20 · dépôt @ e42175f -->

**Type :** Feature
**Taille :** cœur M (lots 2-3 : règles et prose, 2 vraies gardes) · total L une fois la gouvernance du lot 4 comptée (`M-PROC-28`) — un commit par lot
**Surface :** `01`, `02`, `03` (+ skill vivant), `04`, `04b` (+ skill vivant), `05`, `07`, `08`, `09` (+ skill vivant), `11`, `sdlc-init.sh`, `.claude/hooks/pre-tool-bash.sh`, `tests/`, gouvernance (README, CHANGELOG, SPEC, HTML, meta, ROADMAP, LESSONS)
**Risque :** Moyen — fichiers partagés nombreux, aucun code exécuté en production ; chaque lot fermé par `sdlc-validate.sh` + suites de tests

---

## Contexte

SDLC-33 a été coupé après le lot 1b (décision de Laurent au point de coupe, `sprint-SDLC-33 §Corrections ajustées` n°1). Ce sprint porte ce qui n'a pas été appliqué : lots 2 et 3, reste du lot 4, et le bilan de report. Les sections « Lot 2 », « Lot 3 », « Lot 4 » et §Annexe ci-dessous sont recopiées sans modification ; les écarts imposés par la coupe sont listés dans §Adaptations dues à la coupe, et non réécrits dans le texte recopié.

Contraintes, interdits et références `K<n>` : ceux de `sprint-SDLC-33 §Contraintes techniques / produit` et `§Corrections du 19/11` s'appliquent (renvoi, pas de recopie). Rappel des deux qui portent sur ce sprint : **re-grep avant chaque édition** (les `chemin:ligne` sont ceux de `012905d`) ; **budget C11** (`M-PROC-49`) : tout ajout dans `01` est compensé par un retrait ou un déplacement de même taille cité par son `R-NN`.

## Adaptations dues à la coupe

1. **Bump** : `v2.0+SDLC-34` (et non `v2.0+SDLC-33`, déjà publié) ; entrée CHANGELOG `## [v2.0+SDLC-34]`.
2. **`M-PROC-55`** existe déjà (SDLC-33) : le lot 4 crée `M-PROC-56`→`61` et `M-HOOKS-09` ; la ligne « universel » de 55 dans le tableau de compatibilité est à vérifier, pas à recréer.
3. **ROADMAP** : SDLC-34 (et non SDLC-33) passe en §Historique.
4. **`tests/sdlc-init-test.sh`** : livré par ELAG-1b, il existe (52 cas au 20/11).
5. **Écart connu hors PDR** : `CLAUDE.md` de ce dépôt garde R-26/R-56/R-57 en double avec `/reprise` (ROADMAP §Later) — hors périmètre sauf aval.

---

## Lots — contenu détaillé

### Lot 2 — Gardes, règles de clôture et file de remontées (`M-PROC-56`, `M-PROC-57`, `M-PROC-60`, `M-PROC-61`, `M-HOOKS-09`)

*Vraies gardes dans ce lot : S56-3 (hook) et le squelette pre-commit de D-4. Le reste est écrit — voir §Sacrifices délibérés.*

| Prop. | Fichier | Changement |
|---|---|---|
| D-1 (`M-PROC-56`) | `03 §0d` (`03:84`) + skill vivant | Chaque ligne `⚠️` de `DETTE / EFFETS DE BORD` cite sa **maison**, par ordre de préférence : (1) garde automatique (test, hook) qui échoue quand le risque se matérialise ; (2) action de `.claude/reprise.md` avec déclencheur daté et vérifiable (R4) ; (3) ligne ROADMAP avec déclencheur observable **et observateur nommé**. Une dette sans maison, ou dont le déclencheur n'a pas d'observateur, bloque la clôture comme une entrée LESSONS manquante. Même règle rappelée dans le bloc Amorce `§Étape 5` · **L5** : une surveillance s'écrit dans sa seule maison, ailleurs un renvoi ; avant de la clore ou de la reconduire, `grep -rn "<libellé>"` de toutes ses mentions · **L6** (⏳ côté Job search) : un déclencheur qui cite une ligne de log la relève d'abord dans le code (`fichier:ligne`) |
| D-2 adapté (K4) | `05` §Next/§Later | Pas de nouvelle colonne : la colonne Déclencheur s'écrit `<déclencheur> · observé par : <script \| section \| /reprise \| personne>` ; « personne » est autorisé mais visible, et compte comme dette sans maison pour D-1 |
| D-3 (`M-HOOKS-09`) | `09:79-83` + skill vivant | Destination par défaut **C (hook)** quand la dette porte sur une commande dangereuse ou qui consomme une ressource externe ; A/B en complément |
| S56-3 (`M-HOOKS-09`) | `08` + `.claude/hooks/pre-tool-bash.sh` | Bloquer `pkill -f` ; bloquer `pgrep -f` dont le motif n'est pas ancré par `^`. Cas de test : 4 (2 bloqués, 2 passants), exécutés en isolation (M-PROC-30), ajoutés à `tests/sdlc-init-test.sh` d'ELAG-1b ; chaînes construites en deux morceaux (le hook vivant bloque sinon) |
| D-4 (`M-PROC-57`) | `03 §Étape 3` (`03:284`) + `01 §Wrap-up` + `08` (nouvelle section optionnelle « pre-commit git — règles de doc mécanisables ») | Une règle « si X change, mettre à jour Y » dont X est détectable (fichier ajouté, clé modifiée) s'applique par un test pre-commit, pas seulement au wrap-up. Squelette générique : inventaire d'un répertoire comparé à sa liste documentée. Repère terrain : scanner Job search < 0,1 s, 2 écarts trouvés que la revue manuelle avait manqués |
| D-6 + L4 (`M-PROC-57`) | `01 §Modifications spot` (règle « grep final », réécrite par ELAG-4) | Étendre : « …y compris toute référence à une section déplacée, scindée ou renommée : `grep -rn "<ancienne référence>" .claude/ CLAUDE.md STANDARDS.md specs/sprint-template.md` → zéro. Avant une scission ou un déplacement de fichier porteur d'identifiants, inventorier tous les porteurs (`grep -rl "^## [A-Z]-" .`), pas seulement le fichier scindé » |
| S56-1 (`M-PROC-60`) | `02 §Niveaux de test` (`02:57`, ligne C) seul — K14 | C — Intégration : « …et prouve qu'il n'écrit ni ne consomme rien à l'extérieur (messagerie, API, état distant), sinon il passe par un harnais qui remplace la collecte » |
| R-JS-01 + règle Laurent 28/09 (`M-PROC-60`) | `01:18` (fusion, pas d'ajout) | « modifier un fichier de configuration sans noter la valeur précédente **ni vérifier la valeur effective dans un run réel** » |
| R-JS-15 (`M-PROC-60`) | `02 §Definition of Done §Livrable` | « Tout filet de sécurité ajouté ou modifié (hook, garde, test bloquant) a été déclenché pour de vrai et son refus observé. » Forme DoD de `M-ARCH-10` (ELAG-1b) : renvoi, pas doublon |
| P-20 file de remontées (`M-PROC-61`) | `03 §Étape 1` (question rétro, case `[SDLC_CANDIDATE]`) + `09 §Étape 4` (remontées vers le modèle) + skills vivants · `sdlc-init.sh` | Chaque nouveau `[SDLC_CANDIDATE]` s'écrit dans la file `docs/REMONTEE_SDLC.md` (variante locale `doc/`, M-PROC-59) avec l'identifiant `[SDLC_CANDIDATE] JJ/MM-N — titre`, puis 2 à 4 lignes : constat (avec preuve : commit, fichier, incident), fichier cible du modèle, nature (règle, contrôle, procédure), proposition ; l'entrée LESSONS n'en garde qu'un renvoi. La file tient aussi un tableau « Remontées en attente » (statut : à reporter · report à confirmer · non tranché localement) et une section « Décisions demandées au projet SDLC ». À la rétro : compter les remontées en attente (indicateur suivi), inscrire les bilans de report reçus, retirer les remontées traitées. `sdlc-init.sh` crée la file vide avec ses 3 sections |

### Lot 3 — Une source par fait, chemins locaux, chiffres importés (`M-PROC-58`, `M-PROC-59`)

| Prop. | Fichier | Changement |
|---|---|---|
| D-7 (`M-PROC-58`) | `01:117` | « `specs/SPEC.md` fait foi pour l'architecture ; en cas d'écart avec le code, le code prime et la SPEC est corrigée dans le même commit. » |
| D-5 (`M-PROC-58`) | `02` (section documentation la plus proche, ou `§Règles d'archivage` si aucune) | « Un fait d'exploitation (horaire, matériel, modèle, chemin) ou un inventaire s'écrit à un seul endroit ; ailleurs, un renvoi. Un inventaire qu'un script peut produire est généré, jamais recopié. » |
| 19/11-2 (`M-PROC-58`) | `04 §Contexte` (commentaire du gabarit, une ligne) | « Un chiffre repris d'un audit, d'un PDR ou d'une remontée cite sa source et reste une hypothèse : le re-mesurer avant de cadrer, et signaler l'écart avant le plan. » (Job search : 3 chiffres faux en 3 jours venus d'audits ou de PDR, rétro du 19/11) |
| R6 + E2 « divergence assumée » (`M-PROC-59`) | `04b` (étape 0, inventaire `04b:35-41`) | Table « Réglages locaux de chemin » : chemin du modèle → variantes locales acceptées (`docs/`↔`doc/` · `specs/sprint-template.md`↔`specs/Sprints/sprint-template.md` · `docs/DECISIONS.md`↔`doc/DECISIONS.md` + `DECISIONS-<famille>.md` · `.claude/reprise.md`↔`doc/REPRISE.md` · `docs/REMONTEE_SDLC.md`↔`doc/REMONTEE_SDLC.md`). Détection par `ls` ; une variante détectée est consignée comme réglage local dans l'entrée `D-SYNC-XX`, jamais signalée comme écart. Le skill reste « zéro adaptation » |
| R-JS-28 | `01 §Rôle` (après le paragraphe « Toute affirmation factuelle doit être citable », `01:110-113`, ou ce qu'en laisse ELAG-4) | « Un identifiant de règle ou de décision cité à l'humain est suivi d'une courte phrase qui dit ce qu'il impose. » |
| P-19 (Job search, rétro 14/11 — 2 occurrences : S81, 14/11) | `01:122` (`§Rôle`, limites bash) — reformulation, pas d'ajout | « Pour toute action hors portée : fournir la commande exacte prête à copier **sur une ligne**, avec le résultat attendu ; au-delà d'une ligne, un script `~/<nom>.sh` lancé par une seule commande. » Un collage multi-ligne casse (heredoc coupé, unité systemd corrompue). La partie « script système livré avec son annulation et le relevé de l'état d'avant » n'est pas reprise (propre aux scripts système ; `02` si un second projet en a besoin) |

### Lot 4 — Gouvernance, validation, bump

- `07-DECISIONS-SDLC.md` : entrées `M-PROC-55`→`M-PROC-61` et `M-HOOKS-09` au format des entrées existantes (Contexte · Retenu · Écarté · Raison · Déclencheur de réouverture), chacune citant les identifiants des remontées qu'elle adopte et le projet source (K17) + lignes du tableau de compatibilité (`07:495`). Compatibilité :
  - **universel** : marqueur `Statut` et table des 3 mémoires (55), maison des dettes (56), D-4/D-6 (57), D-5/D-7/19/11-2 (58), réglages locaux (59), file de remontées (61), `M-HOOKS-09` ;
  - **conditionnel** : usage actif de `/reprise` (« sprints à déclencheur externe »), option worktree et bloc de hook R-JS-02 (« dépôt exécuté par un service planifié »), S56-1 (« test C qui touche une ressource externe ») ;
  - Déclencheur de réouverture de 55 : tests terrain C1–C4 (E2 §7) non tenus dans Job search après 2 semaines ; de 61 : remontées en attente en hausse sur 2 rétros consécutives.
- `06-PDR-bootstrap.md` (carte des fichiers) · `11-help-SKILL-TEMPLATE.md` (routage `/reprise`, M-TMPL-05) — pas de skill vivant `help` ici (`C4_EXCEPTIONS`).
- `specs/SPEC.md §Modules`, `00-CONTEXT.md §1`, `README.md` (structure + « Version courante : v2.0+SDLC-33 »), `CHANGELOG.md` (entrée `## [v2.0+SDLC-33]`), `docs/meta.json`, `docs/pages/versions.md`, `docs/SPEC.html` + `docs/MODE-OPERATOIRE.html` (C10 : chaque template cité, `13` compris), `docs/CLAUDE_PROJECT.md` (nouveau SKILL.md synchronisé ; `reprise.md` jamais synchronisé ; procédure de traitement de la file, `M-PROC-61`).
- ROADMAP : SDLC-33 en §Historique ; `docs/LESSONS_LEARNED.md` : entrée du sprint + candidat « chemins réels dans les PDR Claude.ai » noté au seuil de graduation.
- **Bilan de report** (Annexe, colonne Issue) remis à Laurent, au format `JJ/MM-N : adoptée (M-…, template X vY) | adaptée (…) | rejetée (raison) | en attente (quoi)`.

---

---

## Critères d'acceptation

*(La DoD — `STANDARDS.md §Definition of Done` — s'applique en plus. Critères `[→ SDLC-34]` de SDLC-33, recopiés ; bump et IDs adaptés par §Adaptations.)*

- [ ] `grep -n "toujours à jour" 01-Claude-md-TEMPLATE.md` → vide · `grep -n "fait foi" 01-Claude-md-TEMPLATE.md` non vide
- [ ] `grep -n "observé par" 05-ROADMAP-TEMPLATE.md` non vide
- [ ] `grep -nE "maison.*(garde|reprise|ROADMAP)" 03-wrap-up-SKILL-TEMPLATE.md .claude/skills/wrap-up/SKILL.md` non vide dans les deux
- [ ] File : `grep -c "REMONTEE_SDLC.md" 03-wrap-up-SKILL-TEMPLATE.md 09-retrospective-SKILL-TEMPLATE.md .claude/skills/wrap-up/SKILL.md .claude/skills/retrospective/SKILL.md` → ≥ 1 dans chacun · `grep -n "remontées en attente" 09-retrospective-SKILL-TEMPLATE.md` non vide
- [ ] Bootstrap jetable (`git init` + commit vide, puis `bash sdlc-init.sh "Test"`) : `docs/REMONTEE_SDLC.md` présent avec ses 3 sections
- [ ] `grep -n "hypothèse" 04-sprint-PDR-TEMPLATE.md` non vide (19/11-2)
- [ ] `grep -n "sur une ligne" 01-Claude-md-TEMPLATE.md` non vide et `grep -c "~/<nom>.sh" 01-Claude-md-TEMPLATE.md` → 1 (P-19, sans ligne ajoutée)
- [ ] Hook : `pkill -f foo` → `2` · `pgrep -f '^foo'` → passant (cas de `tests/sdlc-init-test.sh`, chaînes en deux morceaux)
- [ ] `grep -n "Réglages locaux" 04b-sdlc-sync-SKILL-TEMPLATE.md` non vide · `grep -n "REMONTEE_SDLC" 04b-sdlc-sync-SKILL-TEMPLATE.md` non vide
- [ ] `grep -cE '^## M-PROC-(55|56|57|58|59|60|61) · ' 07-DECISIONS-SDLC.md` → 7 · `grep -c '^## M-HOOKS-09 · ' 07-DECISIONS-SDLC.md` → 1
- [ ] Budget `01` : C11 vert ; `wc -lc` du `CLAUDE.md` bootstrappé avant/après consigné, bilan net ≤ 0
- [ ] `git diff --stat 012905d -- specs/Sprints/AUDIT-ELAGAGE-1.md` → vide
- [ ] Tests niveau A : `bash sdlc-validate.sh` → tous OK · `bash tests/sdlc-validate-test.sh` et `bash tests/sdlc-init-test.sh` → tous OK · `bash -n .claude/hooks/pre-tool-bash.sh`
- [ ] Bilan de report remis (une ligne par proposition de l'Annexe)
- [ ] CHANGELOG mis à jour (`v2.0+SDLC-34`), C1 vert

---

## Pas de placeholders

`grep -En "TBD|à implémenter plus tard|gestion d'erreur appropriée|cas limites appropriés|similaire à la tâche" specs/Sprints/sprint-SDLC-34-suite-agregation-remontees.md` → seule la ligne de ce paragraphe correspond (elle cite le motif).

---

## Signaux de dégradation

Ceux de `sprint-SDLC-33 §Signaux de dégradation` (renvoi) : silent partial completion (skill ou hook vivant non mis à jour), skipped steps, budget contourné par compression plutôt que par retrait cité.

---

## Pre-mortem

> Si ce sprint échoue ou dépasse 2× l'estimation, la cause la plus probable est :

La même que SDLC-33 : la gouvernance du lot 4 absorbe la fin de session. Parade : un commit par lot ; si le lot 4 n'est pas commencé à mi-parcours, couper (lots 2-3 + gouvernance minimale `07` des décisions adoptées) et noter la coupe dans `.claude/reprise.md`.

---
<!-- FIN PRD — La section Handoff est complétée par Claude Code en début de session -->

## Handoff Claude Code

**Fichiers — chargement immédiat :** ce PDR · `sprint-SDLC-33 §Contraintes techniques / produit` et `§Corrections du 19/11` (lignes K<n>)

**Fichiers — chargement différé (grep d'abord) :** `01`, `02`, `03` + skill vivant, `04`, `04b` + skill vivant, `05`, `07` (tableau de compatibilité), `08`, `09` + skill vivant, `11`, `sdlc-init.sh`, `.claude/hooks/pre-tool-bash.sh`, `tests/sdlc-init-test.sh`

**Init mémoire sprint :**
```bash
echo "# Sprint SDLC-34 — suite-agregation-remontees · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-SDLC-34-suite-agregation-remontees.md" >> .claude/sprint-memory.md
```

---

## Plan de développement
*(étape 4d — 20/11/2026, session Claude Code, dépôt @ `e42175f`)*

**Dépendances vérifiées :**
- [x] SDLC-33 clos et intégré (`e42175f` sur `main`, `origin/main...main` → `0 0`)
- [x] Derniers IDs : `M-PROC-55`, `M-HOOKS-08` (grep `07`) → ce sprint numérote `M-PROC-56`→`61`, `M-HOOKS-09`
- [x] Baseline verte : `sdlc-validate.sh` 12/12 · `tests/sdlc-validate-test.sh` 27/27 · `tests/sdlc-init-test.sh` 52/52
- [x] Budget C11 : `BUDGET_LIGNES=336`, `BUDGET_OCTETS=16684` (`sdlc-validate.sh:31-32`) — **marge nulle**
- [x] `docs/REMONTEE_SDLC.md` absent du bootstrap ; hook livré extrait de `08` (`sdlc-init.sh:99-111`, M-ARCH-10) → un seul bloc à modifier dans `08`, testé « livré » et « vivant » par `hook_cases` (`tests/sdlc-init-test.sh:82-127`)
- [x] Skills vivants : `wrap-up`, `retrospective`, `reprise`, `diagnostic` — pas de skill vivant `sdlc-sync` ni `help` (C4_EXCEPTIONS)

**Ancrages relevés (re-grep, l'état `012905d` des tables est périmé) :**
- `01:18` (config) · `01:51` (Citabilité, R-JS-28 en fin de ligne) · `01:55` (« exhaustive et toujours à jour ») · `01:60` (hors portée) · `01:157-161` (§Modifications spot) · `01:308-316` (§Wrap-up)
- `02:14-18` (§DoD §Livrable) · `02:63` (ligne C) · `02:178` (§Règles d'archivage, D-5) · `03:88-89` (DETTE) · `03:174-207` (Étapes 1-2) · `03:369` (Étape 5) · `04:16-19` (§Contexte) · `04b:17-41` (Étape 0/A) · `05:21`, `05:33` (colonnes Déclencheur) · `08:76-160` (blocs stricts) · `09:84-88` (destinations) · `09:166-190` (Étape 4)

**Budget `01` (mesuré, `printf | wc -c`) :** ajouts lots 2-3 = **+2 lignes, +722 octets** (`:18` +51 · `:55` +86 · `:60` +80 · `:51` +107 · §Modifications spot +253/1 l · §Wrap-up +145/1 l). Compensation à trancher (§Demande d'aval) — options mesurées :
- R-49 « Candidat hook » (`01:202-207`, 6 l / 367 o ; audit : MÉCANISER, collecte déjà faite par `03:187`, `03:206`)
- R-35 « Sélection de modèle sous-agent » (5 l / 462 o ; audit : DÉPLACER vers Handoff PDR `04`)
- illustration « Pensée → Réalité » de R-06 (`01:20-24`, 5 l / 541 o ; R-06 « servie » ×2, hook 4a non livré aux projets → à garder)
- R-33 « Oracle en amont » (`01:147`, 1 l / 124 o ; audit : DÉPLACER vers `10`)

**Modules touchés :**
- Lot 2 : `01`, `02`, `03` + skill vivant, `05`, `08`, `09` + skill vivant, hook vivant, `sdlc-init.sh` (file `docs/REMONTEE_SDLC.md`), `tests/sdlc-init-test.sh`
- Lot 3 : `01`, `02`, `04`, `04b`
- Lot 4 : `07`, `06`, `11`, `00-CONTEXT.md`, `specs/SPEC.md`, README, CHANGELOG, `docs/` (meta, versions, 2 HTML, CLAUDE_PROJECT.md), ROADMAP, LESSONS
- **Taille** : cœur M, total L (`M-PROC-28`)

**Risques identifiés :**
- Budget C11 à marge nulle → toute formulation rallongée au codage casse C11 ; mesurer après chaque édition de `01`
- Regex `pgrep -f` non ancré : faux positifs sur `pgrep -f "$VAR"` → cas de test passants explicites
- Skills vivants adaptés : chaque modification de `03`/`09` appliquée aux deux (C4 ne compare que les `## `)
- Version incrémentée pour chaque template touché (C2)
- **Défaut préexistant** (SDLC-33) : `03:280` et skill vivant `:286` — le commentaire `# <ID> = …` avale `2>/dev/null || echo …` sur la même ligne ; le repli ne s'exécute jamais
- Bruit préexistant : `comm: file 1 is not in sorted order` à l'exécution de `sdlc-validate.sh` (`:273`, `:307`) — 12/12 malgré tout ; hors périmètre

**Plan d'exécution :**
1. Lot 2 : `03` + vivant (D-1/L5/L6 au §0d et Étape 5 ; P-20 Étapes 1-2) → `09` + vivant (D-3, P-20 Étape 4 + « remontées en attente ») → `05` (D-2) → `08` (S56-3 dans le bloc hook ; section pre-commit D-4) → hook vivant (S56-3) → `tests/sdlc-init-test.sh` (4 cas, chaînes en deux morceaux) → `sdlc-init.sh` (file vide, 3 sections) → `01` (`:18`, §Modifications spot, §Wrap-up + compensation) → `02` (S56-1, R-JS-15) → tests → commit lot 2
2. Lot 3 : `01` (`:55`, `:51`, `:60`) → `02` (D-5) → `04` (19/11-2) → `04b` (Réglages locaux + `REMONTEE_SDLC`) → tests → commit lot 3
3. Lot 4 : `07` (7 entrées + compatibilité), `06`, `11`, gouvernance, bump `v2.0+SDLC-34` → `/wrap-up` (bilan de report)

**Plan de test :**
- A — Ciblé : `bash sdlc-validate.sh && bash tests/sdlc-validate-test.sh && bash tests/sdlc-init-test.sh && bash -n .claude/hooks/pre-tool-bash.sh` + chaque `grep` de §Critères d'acceptation, sortie relevée
- A — Hook : cas `pkill -f foo` → 2, `pkill foo` → 0, `pgrep -f foo` → 2, `pgrep -f '^foo'` → 0, sur hook livré et vivant
- B — Non-régression : bootstrap jetable `sdlc-init.sh "Test"` (`docs/REMONTEE_SDLC.md` à 3 sections, CLAUDE.md ≤ budget) ; cas hook existants inchangés ; `git diff --stat 012905d -- specs/Sprints/AUDIT-ELAGAGE-1.md` vide
- C — N/A

---

## Corrections ajustées vs spec
*(complété au wrap-up — §Étape 3)*

---

## Annexe — Devenir de chaque proposition (sert de bilan de report)

| Entrée | Proposition | Issue | Où |
|---|---|---|---|
| E1 | D-1 aucune dette orpheline | Adoptée | Lot 2 · `03 §0d`, `§Étape 5` · M-PROC-56 |
| E1 | D-2 déclencheurs observables | Adaptée (K4) | Lot 2 · `05` colonne Déclencheur |
| E1 | D-3 garde avant règle | Adoptée | Lot 2 · `09:79-83` · M-HOOKS-09 |
| E1 | S56-1 test C sans effet externe | Adoptée (K14 : `02` seul) | Lot 2 · `02 §Niveaux de test` · M-PROC-60 |
| E1 | S56-2 dépôt exécuté par un service planifié | Fusionnée avec R-JS-02 | Lot 1 · `02` option worktree + bloc de hook optionnel `08` |
| E1 | S56-3 `pkill -f` / `pgrep -f` | Adoptée | Lot 2 · `08` + hook vivant · M-HOOKS-09 |
| E1 | Config vérifiée en run réel | Fusionnée avec R-JS-01 | Lot 2 · `01:18` |
| E1 | Application locale (§4) | Hors périmètre | Job search |
| E2 | `reprise.md` + `/reprise` + marqueur `Statut` | Adoptée, corrigée K1/K2/K7/K12/K16 | Lot 1 · M-PROC-55 |
| E2 | Marqueur vérifiable par regex (D4) | Mécanisé : `C<n>` + marquage rétroactif des specs | Lot 1 · `sdlc-validate.sh` |
| E2 | Hook R1/R2 | Exclue (D6) | `[HOOK_CANDIDATE]` si oubli constaté |
| E2 | Observation « fichier généré modifié à la main » | Hors périmètre (1 occurrence) | LESSONS Job search |
| E2 | Observation sprint 61 sans spec (`LL-T05`) | Tracée | Lot 0 · LESSONS · à qualifier en rétro |
| E3 | Diff annexe A + §3.3 | Appliqué, amendé par E5-E8 | Lot 0 |
| E3 | D-GOV-01 | Sprint séparé (hypothèse) | Lot 0 · ROADMAP §Later |
| E3 | `§Validation` remplace la grille L | Hypothèse retenue | Sprint Import D-GOV-01 |
| E3 | Défauts bootstrap + détection de version `CLAUDE.md` | Portés par ELAG-1b | `specs/Sprints/sprint-ELAG-1b-fix-bootstrap.md` |
| E3 | Lectures R-83/R-03/R-51/R-52/R-92, `M-PROC-50` | Portées par ELAG-4 | `specs/Sprints/sprint-ELAG-4-import-elagage.md` |
| E4 | D-4 règle de doc mécanisable | Adoptée | Lot 2 · `03:284`, `01 §Wrap-up`, `08` · M-PROC-57 |
| E4 | D-5 un fait, une source | Adoptée | Lot 3 · `02` · M-PROC-58 |
| E4 | D-6 référence de section suivie | Adoptée (fusion) | Lot 2 · `01 §Modifications spot` · M-PROC-57 |
| E4 | D-7 « fait foi » | Adoptée | Lot 3 · `01:117` · M-PROC-58 |
| E4 | R6 chemins de `/sdlc-sync` | Adaptée (K5) en réglage local | Lot 3 · `04b` · M-PROC-59 |
| E5 | R-JS-01 config en run réel | Fusionnée | Lot 2 · `01:18` |
| E5 | R-JS-02 espace de travail séparé | Adaptée + fusion S56-2, bloc de hook optionnel | Lot 1 |
| E5 | R-JS-04 ne pas recréer un fichier | Portée par ELAG-4 (K6) | R-39, `§Modifications spot` |
| E5 | R-JS-06 rien de durable attaché à la session | Adoptée | Lot 1 · `13` (`## En vol`) |
| E5 | R-JS-15 filet déclenché pour de vrai | Adoptée | Lot 2 · `02 §DoD` (renvoi `M-ARCH-10`) |
| E5 | R-JS-28 code de décision + phrase | Adoptée | Lot 3 · `01 §Rôle` |
| E5 | (b) limite de la mesure `M-PROC-50` | Portée par ELAG-4 | `M-PROC-50` close |
| E5 | 10 retraits, 12 règles portant un défaut du prompt-audit | Portés par ELAG-4 (retraits) / sprint Fix ultérieur (défauts) | ROADMAP |
| E6 | L1 témoin apparié (P-18) | Sprint Import D-GOV-01 | Lot 0 · ROADMAP §Later |
| E6 | L2 inventaire `--ignored` avant `git worktree remove` | Adoptée | Lot 1 · `03` + skill vivant |
| E6 | L3 `/reprise` « même objet » | Adoptée (K10) | Lot 1 · `13` |
| E6 | L4 inventaire des porteurs d'ID avant scission | Adoptée (fusion D-6) | Lot 2 · `01 §Modifications spot` |
| E6 | L5 une surveillance, une source | Adoptée (avec D-1) | Lot 2 · `03 §0d` |
| E6 | L6 ligne de log relevée dans le code | Incluse, ⏳ côté Job search | Lot 2 · `03 §0d` — retirer si Laurent refuse |
| E6 | L8 biais de l'issue par défaut | Tracé | Lot 0 · LESSONS + ligne Import D-GOV-01 |
| E6 | L9 / K9 regex `--force` du hook | Portée par ELAG-1b | `specs/Sprints/sprint-ELAG-1b-fix-bootstrap.md` |
| E6 | P-19 commandes multi-lignes → script | Adaptée (non tagué, adopté par Laurent le 19/11) : `01:122` reformulée, partie annulation non reprise | Lot 3 · `01 §Rôle` · M-PROC-58 |
| E7 | Table de verdict | Copiée dans le dépôt (3 colonnes) | Lot 0 · `specs/Sprints/ELAG-3-table-verdict-jobsearch.md` |
| E8 | 18/11-1 wrap-up « contenu complet, prêt à écraser » | Rejetée pour le modèle (K15 : phrase absente de `03` depuis toujours) | — |
| E8 | 18/11-2 « Modifications spot » | Portée par ELAG-4 | R-37/R-38/R-39 |
| E8 | 18/11-3 liste « Éviter » en double | Portée par ELAG-4 | R-61, `01:499` |
| E8 | 18/11-4 frontmatter `sdlc-sync` revenu | Portée par ELAG-1b | `M-ARCH-10` |
| E8 | 18/11-5 état validé après livraison | En attente — déclencheur : 2ᵉ projet en service planifié | ROADMAP §Later |
| E8 | 18/11-6 volume d'entrée → durée contre le plafond | En attente — même déclencheur | ROADMAP §Later |
| E8 | 19/11-1 règle de chemin vérifiée en session neuve | En attente — Import élagage 2 | ROADMAP §Later |
| E8 | 19/11-2 chiffres importés = hypothèses | Adoptée | Lot 3 · `04 §Contexte` · M-PROC-58 |
| E8 | 19/11-3 `$<chiffre>` dans un skill | Adoptée (contrôle d'ELAG-1b) + K16 dans `13` | Lot 1 |
| E8 | P-20 file unique de remontées | Adaptée (K17 : `docs/`, décisions `M-…`) | Lot 2 · `03`, `09`, `sdlc-init.sh` · M-PROC-61 |
