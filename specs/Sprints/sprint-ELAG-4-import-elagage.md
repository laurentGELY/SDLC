# Sprint ELAG-4 — Import élagage : appliquer au modèle les résultats d'ELAG-2 et ELAG-3
<!-- Template SDLC v2.4 · rédigé le 19/11/2026 en session Claude Code · confronté à SDLC @ 012905d et Job search @ 06a30f7 · destination : specs/Sprints/sprint-ELAG-4-import-elagage.md (ce dépôt) -->
<!-- Entrées : specs/Sprints/AUDIT-ELAGAGE-1.md @ 573d1f3 (grille R-NN, 8 décisions provisoires) · Job search @ 06a30f7 : specs/Sprints/AUDIT-ELAGAGE-2.md, specs/Sprints/ELAG-3-table-verdict.md, specs/Sprints/sprint-89-allegement-regles.md, doc/REMONTEE_SDLC_2026-11-18.md -->

**Type :** Dette (process)
**Taille :** L — 4 lots, un commit par lot, point de coupe après le lot 2
**Surface :** `01-Claude-md-TEMPLATE.md`, `02-STANDARDS-TEMPLATE.md`, `04-sprint-PDR-TEMPLATE.md`, `09-retrospective-SKILL-TEMPLATE.md` (+ skill vivant `retrospective`), `07-DECISIONS-SDLC.md`, `sdlc-validate.sh`, `tests/sdlc-validate-test.sh`, `docs/ROADMAP.md`, `docs/LESSONS_LEARNED.md`, gouvernance (README, CHANGELOG, `docs/` si C9/C10 l'exigent)
**Risque :** Moyen — on retire des règles d'un template diffusé ; chaque retrait est réversible par git et tracé par son `R-NN`
**Règles visées :** R-03, R-07, R-12, R-13, R-14, R-15, R-28, R-29, R-32, R-34, R-36, R-37, R-38, R-39, R-40, R-41, R-42, R-51, R-59, R-61, R-63, R-64, R-65, R-66→R-76, R-91, R-97 (champ prévu par `M-PROC-54`)

---

## Décisions prises avant le handoff (Laurent, 19/11/2026)

1. **Identifiant : `ELAG-4`**, dans la série ELAG dont il importe les résultats (un ID `SDLC-34` pourrait aussi entrer en collision avec la seconde moitié de SDLC-33 s'il est coupé).
2. **`01:499` (liste « Éviter ») est retirée, avec `01:433`** (R-61). Dans le modèle, `01:433` n'est qu'un renvoi, et chacun des 5 interdits de `01:499` est déjà porté par une règle plus précise (R-05, HALT-DEP, §Priorités). Job search avait gardé l'équivalent le 21/10 parce que sa ligne locale était la seule à les énumérer ; son `/doctor prompt-audit` du 18/11 la déclare en double (remontée 18/11-3).
3. **R-91 (DEPENDENCY_MAP, `02:77`) est retirée du template** : le bootstrap ne crée ni le fichier ni son générateur. Le générateur de Job search reste un candidat pour un import ultérieur, mécanisme d'abord.
4. **Ordre : lot 0 de SDLC-33 (docs) → ELAG-1b → ELAG-4 → lots 1 à 3 de SDLC-33.** Ce PDR prend en charge `01:263` (`§Modifications spot`, remontée 18/11-2) ; **la ligne K6 de SDLC-33 (R-JS-04 reformulée) sort de son lot 3.** Si l'ordre change, re-grep de toutes les ancres (§Contraintes).
5. **Pas de palier 350 dans ce sprint : cliquet à la valeur mesurée en fin de lot 3.** Les dispositions étayées retirent environ 120 lignes ; 350 exige les déplacements vers des skills (R-26, R-56, R-57 → `/reprise` de SDLC-33 ; §Démarrage → skill, méthode du Sprint 89). Les paliers 350 puis 200 reviennent aux sprints qui créent ces destinations.

---

## Contexte

ELAG-1 (`573d1f3`) a classé les 134 règles d'un projet bootstrappé et proposé 7 retraits, 23 fusions, 23 déplacements et 20 mécanisations, tous provisoires faute de données d'usage. La mesure a eu lieu dans Job search :

- **ELAG-2** (20/10) : correspondance des règles locales avec la grille. 87 `R-NN` présentes, 6 hors unité de comptage, 41 absentes ; 66 règles locales `R-JS`. Volet absence : 5 groupes de défauts **observés** malgré l'absence de la règle v2.0, 1 **non observé** (reprise après compaction).
- **ELAG-3** (14/11, clos) : 15 sprints dont 9 M/L. Verdicts : 17 servies, 36 non sollicitées, 97 non mesurables, 1 gênante. Laurent a retiré 10 règles, en a fondu 3 et en a déplacé 6, en jugeant sur la **redondance et l'obsolescence**, pas sur la seule absence de trace. Fenêtre 2 refusée : la ligne d'usage mesure ce que l'agent **cite**, pas ce qui sert.
- **Sprint 89** (17/11, **clos le 19/11** — `c5ec95b` ; reste sous surveillance : trace de `/demarrage` aux 2 sprints suivants ; audit des prompts post-S89 fait, `c5378e0`) : `CLAUDE.md` local réécrit de 369 à 92 lignes après un tri règle par règle (I gardée · T déplacée · A protégée par du code · O retirée), avec skill `/demarrage`, `.claude/rules/` à en-tête `paths` et plafonds testés (200 lignes et 8 192 o pour `CLAUDE.md`, 10 240 o par skill).

Rien de cela n'est appliqué au modèle : `01` fait toujours 499 lignes et 25 387 octets (`wc -lc 01-Claude-md-TEMPLATE.md` à `012905d`).

---

## Objectif

Le template `01` (et les règles visées de `02`) applique chaque disposition étayée par Job search, règle par règle et tracée par son `R-NN`. Les 8 décisions provisoires d'ELAG-1 sont tranchées dans `07`, et un contrôle de `sdlc-validate.sh` empêche le `CLAUDE.md` bootstrappé de regrossir.

---

## Comportement actuel → cible

- **Actuel :** les décisions `M-PROC-49`→`54`, `M-ARCH-10` et `M-TMPL-10` n'existent que dans un audit figé ; `01` contient des règles que Job search a retirées sans dommage, des doublons qu'il a fondus, et des résumés de skills qu'il a remplacés par des renvois ; rien n'empêche `01` de grossir.
- **Cible :** `07` dit pour chaque décision d'ELAG-1 : adoptée, adoptée amendée, close ou reportée (avec déclencheur) ; `01` a perdu au moins 100 lignes, et seules les règles listées ont changé dans le comptage (`compter-regles.sh`) ; un contrôle bloque toute croissance du `CLAUDE.md` bootstrappé au-delà de la valeur mesurée.

---

## Critère de disposition

Une règle change dans ce sprint **seulement** si Job search apporte un fait qui le justifie :
- (a) Job search l'a retirée, fondue ou remplacée par un renvoi, et ELAG-3 n'a relevé aucun manque ; ou
- (b) elle est absente de Job search depuis juin, et le volet absence d'ELAG-2 n'a pas trouvé son défaut, ou l'a trouvé sous une forme que la règle n'aurait pas évitée ; ou
- (c) un `/doctor prompt-audit` de Job search la déclare contradictoire ou redondante (remontées 18/11-2 et 18/11-3).

Une règle « non mesurable » ou « non sollicitée » sans autre fait **ne change pas**. Le motif ELAG-1 « aucune décision source (`48c7c23`) » ne suffit jamais seul : il était faux pour R-16 dans Job search.

---

## Dispositions

Emplacements à `012905d`, à re-griller après ELAG-1b. Verdicts Job search : `AUDIT-ELAGAGE-2.md §Verdict` et `ELAG-3-table-verdict.md` @ `06a30f7`.

### Retraits

| R-NN | Emplacement | ELAG-1 | Job search | Critère | Disposition |
|---|---|---|---|---|---|
| R-13 | `01:44-98` (tables Pensée → Réalité, ≈ 55 lignes) | candidat retrait | absente depuis juin ; défauts HALT survenus 2 fois, corrigés par hook et interdictions, pas par des tables ; « confirmé provisoire » | b | **Retirer.** Les 5 HALT (R-08→R-12) restent |
| R-28 | `01:217` « Chargement chirurgical » | fusionner R-24 | non sollicitée, **retirée** (ELAG-3) | a | **Retirer** : R-24 (étape 4c) porte déjà immédiat/différé |
| R-32 | `01:228` « Analyse en une passe » | candidat retrait | non sollicitée, **retirée** | a | **Retirer** |
| R-34 | `01:230` « Batching XS/S » | déplacer | non sollicitée, **retirée** | a | **Retirer** |
| R-59 | `01:428` « Validation incrémentale » | déplacer | non sollicitée, **retirée** | a | **Retirer** |
| R-61 | `01:433` « **Éviter :** voir §Priorités » | candidat retrait | gardée, mais la ligne locale énumère 5 interdits ; dans le modèle c'est un renvoi pur | c (18/11-3) | **Retirer** `01:433` et `01:499` (décision 2) |
| R-91 | `02:77` « Déclencheur DEPENDENCY_MAP » | candidat retrait | gardée parce qu'un générateur local existe (`M-TMPL-10`) | — | **Retirer** (décision 3) |

### Fusions

| R-NN | Emplacement | Job search | Critère | Disposition |
|---|---|---|---|---|
| R-14 → R-01 | `01:99` → `01:15` | toutes deux servies ; fondues dans `CLAUDE.md` v4.0 §Décision et aval | a | Une seule règle : « pas de code avant l'aval explicite ; sans aval, s'arrêter après l'analyse » |
| R-29 → R-24 | `01:218` → §Démarrage 4c | gardée et requalifiée ; une ligne en v4.0 | a | Le grep avant lecture devient une proposition de l'étape 4c |
| R-15, R-40, R-42 → R-62 ; R-03 garde sa ligne | `01:110-113`, `01:280`, `01:283` | défaut observé malgré R-03 en prose ; R-15/40/42 absentes ; une ligne en v4.0 (« toute conclusion cite la commande, sa sortie ou le log ») | a, b | R-03 : une ligne en §Règles absolues · R-62 (§Test) devient l'énoncé unique · R-15 réduit à un renvoi d'une ligne · R-40 et R-42 retirées (`M-PROC-51` (3)) |
| R-41 → R-50 | `01:281` | R-50 : défaut observé en son absence (règle la mieux étayée) | b | La phrase « description de l'utilisateur = hypothèse » entre dans §Vérification factuelle |
| R-51 → R-52 | `01:347-357` → §Demande d'aval | absentes toutes deux ; défaut observé (23 blocs « Corrections ajustées » dans le CHANGELOG local), prévention non mesurable | b | Une seule auto-évaluation avant l'aval, au plus 3 lignes (`M-PROC-51` (2)) |
| R-63, R-64, R-65 → R-48 | `01:447-450` | non sollicitées ; **fondues** en une colonne « KO si » (ELAG-3) | a | Une définition compacte « niveau · OK si · KO si » d'au plus 3 lignes ; le détail reste dans `02 §Niveaux de test` |
| R-07, R-97 → R-92 | `01:26-28`, `02:107` → `02:85` | absentes ; forme bénigne seulement (`E402`) | b | Un seul énoncé dans `02 §Barre qualité` ; R-07 quitte `01` |

### Réécriture et mécanisations

| R-NN | Emplacement | Job search | Critère | Disposition |
|---|---|---|---|---|
| R-37, R-38, R-39 | `01:254-276` §Modifications spot (23 lignes) | R-37 et R-38 **servies** ; R-39 en contradiction avec « ne jamais recréer » (prompt-audit, défaut §0.4) | a, c (18/11-2) | **Réécrire en ≤ 8 lignes** : modification ciblée et vérifiée (R-37, outil libre : `Edit` après lecture, ou `sed`) · grep final, ancien motif → zéro (R-38) · trop complexe → plusieurs éditions ciblées, jamais de régénération complète (R-39 retirée). Absorbe la ligne K6 de SDLC-33 (décision 4) |
| R-66→R-76 | `01:458-474` §Wrap-up (résumés des skills) | non mesurables ; listes **retirées** par Job search (C18), contenu présent dans les skills | a | **Renvoi** : une ligne de déclenchement par skill (`/wrap-up`, `/retrospective`), plus la ligne « Avant tout commit » (R-77, inchangée) — `M-TMPL-10`. Condition : frontmatter des skills livré par ELAG-1b |
| R-12 | `01:39-42` HALT-TIMEOUT | absente ; l'outil Bash a un délai natif | b | **Une ligne** : déclencheur `exit 124` → HALT, renvoi vers `§Limites bash` |
| R-36 | `01:236-240` découpage `.claude/rules/` | absente ; principe appliqué et **mécanisé** par Job search (test de taille, Sprint 89) | a | **Remplacée** par le contrôle de budget (lot 2) et une ligne de renvoi |

### Retraits infirmés — règles gardées

| R-NN | ELAG-1 | Job search | Disposition |
|---|---|---|---|
| R-16 | candidat retrait (« aucune décision source ») | gardée, réduite à un renvoi vers une décision locale ; présente dans `CLAUDE.md` v4.0 | **Garder** (une ligne) |
| R-44 | candidat retrait | gardée (procédure du gabarit d'analyse) | **Garder** |
| R-83 | candidat retrait (« circulaire ») | **infirmé** : wrap-up partiel récurrent (4 occurrences), règle durcie localement | **Garder** |

### Estimation

Environ 120 lignes retirées : R-13 ≈ 55 · §Wrap-up ≈ 15 · §Modifications spot ≈ 15 · R-51 ≈ 9 · groupe R-62 ≈ 8 · R-63→R-65 ≈ 3 · R-12 et R-36 ≈ 7 · lignes isolées ≈ 8. **À mesurer, pas à recopier** (`LL-T14`).

---

## Portée

**Inclus :**
- Lot 1 — décisions `07` (tableau ci-dessous) et lignes ROADMAP des reports
- Lot 2 — contrôle de budget dans `sdlc-validate.sh` + cas RED
- Lot 3 — dispositions dans `01` et `02`, règle par règle
- Lot 4 — `04` (champ « Règles visées », modèle exécutant), `09` + skill vivant (M1 remplacé par le budget, revue au changement de modèle), gouvernance, bump `v2.0+ELAG-4`

**Exclu (explicitement) :**
- **Déplacements vers un skill de reprise** (R-26, R-56, R-57) : la destination `/reprise` naît au lot 1 de SDLC-33, qui les portera (« une entrée, une sortie »).
- **Méthode du Sprint 89** (skill `/demarrage` pour §Démarrage R-20→R-25, `.claude/rules/` pour R-58, R-89, R-93→R-95, R-98, R-99, échelle de réponse à un incident, plafonds des skills) : sprint « Import élagage 2 », déclenché par la clôture du Sprint 89 (§Décisions, `M-PROC-54`).
- **Fusion des couches du wrap-up** (`M-PROC-51` (1) : R-105, R-108, R-109) : aucune capture mesurée dans Job search ; reportée.
- **R-27, R-30, R-31, R-35** : absentes de Job search, mais leur défaut n'a pas été cherché (ni « observé » ni « non observé ») ; pas de fait, pas de changement.
- **`M-PROC-52`** (registre chaud/froid) : interne au repo SDLC, aucune donnée de Job search ; sprint propre.
- **`M-ARCH-10`** et R-55 (`pre-compact.sh`) : portés par ELAG-1b.
- Les 6 règles `R-JS` et les autres remontées : SDLC-33.
- Le `Claude.md` vivant du repo SDLC (384 lignes, v1.9) : hors modèle diffusé ; une ligne ROADMAP le note.
- `specs/Sprints/AUDIT-ELAGAGE-1.md` : **figé**.

---

## Décisions (lot 1)

Format des entrées existantes (`## M-… · titre · version · date`, Contexte · Retenu · Écarté · Raison · Déclencheur de réouverture), plus une ligne dans le tableau de compatibilité (`07:495`).

| Décision | Issue | Contenu |
|---|---|---|
| `M-PROC-49` | **Adoptée, amendée** | Budget absolu du `CLAUDE.md` produit par `sdlc-init.sh`, en lignes **et** en octets (Job search mesure les deux). Cliquet : les constantes valent la mesure de fin de lot 3 ; les baisser est libre, les monter exige une décision `07`. Au-delà, « une entrée, une sortie » citée par `R-NN`. Paliers 350 puis 200 reportés aux sprints de déplacement (décision 5). Remplace le seuil relatif de M1 (`09`, `02 §Cliquet`) pour le contexte permanent |
| `M-PROC-50` | **Close, non reconduite** | Résultat : la ligne d'usage auto-déclarée désigne la dizaine de règles porteuses, mais ne départage pas les autres ; elle ne peut pas juger les interdictions ni les règles mécanisées (appliquée à la lettre, l'issue par défaut aurait retiré environ 140 règles). Son déclencheur (« si les compteurs ont changé une disposition ») n'est pas atteint : ELAG-3 a tranché sur la redondance. Une règle est revue quand un incident la met en cause, pas par une collecte. Emplacement de la ligne (LESSONS, pas `sprint-memory.md`) consigné pour mémoire |
| `M-PROC-51` | **Adoptée en partie** | (2) auto-revue + verdict gate et (3) groupe « conclure sans preuve » : appliqués au lot 3. (1) couches du wrap-up : reportée, déclencheur = une capture tracée ou une absence de capture mesurée sur ces couches |
| `M-PROC-52` | **Reportée** | Sprint propre (ROADMAP §Later) |
| `M-PROC-53` | **Adoptée** | En-tête « modèle exécutant » dans `04` ; `/doctor prompt-audit` (lancé par l'humain) sur un bootstrap neuf à chaque changement de modèle **et** avant tout bump qui modifie `01`. Job search l'a pratiqué le 18/11 : il a trouvé 3 défauts du template (18/11-2, -3, -4) |
| `M-PROC-54` | **Adoptée, amendée** | Retenu tel quel pour ce sprint (règle par règle, champ « Règles visées »). Amendement provisoire : une réécriture d'ensemble est admise **si** une annexe classe chaque règle de l'ancien fichier (I/T/A/O) et que chaque règle T est retrouvée par grep à sa destination (méthode du Sprint 89). Déclencheur : clôture du Sprint 89 de Job search (2 sprints d'observation tenus, prompt-audit « après » sans contradiction) → ouvre « Import élagage 2 » |
| `M-TMPL-10` | **Adoptée** | Appliquée à R-66→R-76, R-12, R-36. Confirmée dans Job search (R-91 → renvoi vers le générateur ; C18) |
| `M-ARCH-10` | Hors sprint | Adoptée par ELAG-1b (input requis) |

---

## Option retenue — alternatives écartées

**Retenue :** importer seulement les dispositions qu'un fait de Job search étaye, règle par règle, et poser le cliquet de budget avant toute nouvelle croissance (SDLC-33 ajoute des règles juste après).

**Écartées :**
- Appliquer toute la grille ELAG-1 (127 dispositions) : 97 règles sont « non mesurables » dans Job search ; les changer reviendrait à décider sans données, ce que M-PROC-50 devait éviter.
- Reproduire tout de suite la refonte du Sprint 89 (`01` à environ 100 lignes) : le Sprint 89 vient d'être clos, mais sa surveillance (le skill `/demarrage` se déclenche-t-il aux 2 sprints suivants ?) n'est pas tenue ; son effet sur l'adhérence n'est pas observé, et `M-PROC-54` interdit encore la réécriture globale.
- Le Sprint 89 seul, sans cet import : laisserait 120 lignes que Job search a déjà jugées inutiles, sous le futur skill `/demarrage`.
- Un plafond sans retrait (le cliquet seul) : Job search l'a écarté (« pousse à compresser le texte, pas à retirer des règles »).

**Sacrifices délibérés :** pas de palier 350 dans ce sprint (décision 5) ; aucune garde au niveau du projet cible (le test de taille de Job search est en pytest, le modèle est agnostique de la stack) ; les skills (`03` : 19 817 o, `09` : 11 781 o, plafond local 10 240 o) sont mesurés, pas plafonnés.

---

## Contraintes techniques / produit

- **Ancres** : tous les `chemin:ligne` sont pris à `012905d`. ELAG-1b les décale : re-grep du texte de chaque règle avant chaque édition.
- **Un commit d'élagage ne touche que les règles listées** dans §Règles visées (`M-PROC-54`). Une règle non listée qui doit changer → `Corrections ajustées vs spec` et aval.
- **Comptage** : `compter-regles.sh` (`AUDIT-ELAGAGE-1.md §1.4` @ `573d1f3`), recopié dans `/tmp`, jamais versionné, adapté à `CLAUDE.md` si ELAG-1b a renommé le fichier.
- **Job search en lecture seule, à commit figé** : `git -C "$JS" show 06a30f7:<fichier> > /tmp/js/<fichier>`. Rien n'est écrit dans Job search.
- **Dépôt public** : on cite des IDs, des verdicts et des commits de Job search ; on ne copie ni énoncé local, ni extrait de LESSONS, ni donnée d'exploitation.
- Template modifié → version incrémentée dans les 3 premières lignes (C2) ; template de skill modifié → skill vivant dans le même commit (C4).
- Chaque chiffre écrit (lignes, octets, comptes) porte sa commande (`LL-T14`).

**Interdit :**
- modifier une règle hors de §Règles visées sans aval ;
- modifier `specs/Sprints/AUDIT-ELAGAGE-1.md` ;
- déplacer une règle vers un fichier que rien ne charge en le présentant comme gardée (`M-PROC-49`, risque) ;
- relever les constantes de budget sans décision `07` ;
- utiliser `M-PROC-55` et suivants (réservés à SDLC-33).

---

## Dépendances

**Inputs requis :**
- [ ] **ELAG-1b livré** : `CLAUDE.md` produit par `sdlc-init.sh`, frontmatter des skills, `M-ARCH-10` dans `07`. Vérifier : `T=$(mktemp -d) && (cd "$T" && git init -q && git -c user.email=t@t -c user.name=t commit -q --allow-empty -m init && bash ~/Downloads/Sandbox/SDLC/sdlc-init.sh "Test" >/dev/null) && ls "$T"/CLAUDE.md && head -1 "$T"/.claude/skills/wrap-up/SKILL.md` → fichier présent et `---`. Absent → **BLOQUANT** (les renvois de `M-TMPL-10` vers des skills sans frontmatter ne se déclenchent pas)
- [ ] Job search lisible à `06a30f7` : `git -C ~/Downloads/Sandbox/JobSearch cat-file -e 06a30f7:specs/Sprints/AUDIT-ELAGAGE-2.md && echo OK`
- [ ] Audit ELAG-1 intact : `git diff --stat 573d1f3 -- specs/Sprints/AUDIT-ELAGAGE-1.md` → vide
- [ ] Rapport `/doctor prompt-audit` « avant » sur un bootstrap neuf, collé par Laurent (Claude ne peut pas lancer la commande)
- [ ] `bash sdlc-validate.sh` et `bash tests/sdlc-validate-test.sh` verts au démarrage

**Outputs produits :**
- [ ] Décisions `M-PROC-49`, `50`, `51`, `53`, `54`, `M-TMPL-10` dans `07` (+ tableau de compatibilité)
- [ ] Contrôle de budget dans `sdlc-validate.sh`
- [ ] ROADMAP : « Import élagage » en §Historique · « Import élagage 2 » (déclencheur : surveillance du Sprint 89 close — `/demarrage` tracé aux 2 sprints suivants dans Job search) · `M-PROC-52` · fusion des couches du wrap-up (`M-PROC-51` (1)) · `Claude.md` vivant du repo SDLC

**Règle :** avant de démarrer, vérifier que tous les inputs requis cochés existent et sont dans l'état attendu. Si un input manque ou a changé → signaler comme BLOQUANT avant toute analyse.

---

## Lots

### Lot 1 — Décisions et ROADMAP
Entrées `07` selon §Décisions ; ROADMAP : lignes des reports avec un déclencheur observable ; LESSONS : entrée « Import élagage » ouverte (complétée au wrap-up).

### Lot 2 — Contrôle de budget
Nouveau contrôle `check_c<n>` (`n` = prochain numéro libre : 11 si SDLC-33 lot 1 n'est pas passé) :
- bootstrap dans `mktemp -d`, `wc -l` et `wc -c` du `CLAUDE.md` produit ;
- comparaison à `BUDGET_LIGNES` et `BUDGET_OCTETS`, constantes en tête du script, commentaire `# M-PROC-49` ;
- message d'échec : la mesure, le plafond et le correctif (« retirer ou déplacer une règle de même taille, citée par son R-NN — M-PROC-49 ») ;
- valeur provisoire au lot 2 = mesure de départ (gel) ; abaissée en fin de lot 3 à la nouvelle mesure ;
- cas RED dans `tests/sdlc-validate-test.sh` : template fixture d'une ligne au-dessus du plafond → échec ; à la mesure exacte → succès (isolation `SDLC_VALIDATE_ROOT`).

**Point de coupe** après le lot 2 : si plus de la moitié de l'estimation est consommée, les lots 3 et 4 deviennent un sprint distinct ; le gel suffit à protéger le modèle en attendant.

### Lot 3 — Dispositions
- Mesure de départ : `T0=$(mktemp -d); (cd "$T0" && git init -q && git -c user.email=t@t -c user.name=t commit -q --allow-empty -m init && bash "$SDLC/sdlc-init.sh" "Test" >/dev/null); wc -lc "$T0"/CLAUDE.md; bash /tmp/compter-regles.sh "$T0" "$SDLC" --liste > /tmp/avant.txt`
- Appliquer les tables de §Dispositions dans l'ordre : retraits → fusions → réécriture/mécanisations. Une édition par règle, vérifiée par grep de son ancre.
- Mesure d'arrivée (`T1`, `/tmp/apres.txt`), puis `diff <(cut -d: -f4- /tmp/avant.txt) <(cut -d: -f4- /tmp/apres.txt)` : chaque ligne du diff est rattachée à un `R-NN` de §Règles visées dans `Corrections ajustées vs spec`.
- Abaisser `BUDGET_LIGNES` et `BUDGET_OCTETS` à la mesure `T1`.

### Lot 4 — Templates de procédure, gouvernance
- `04` : champ `**Règles visées :**` (sprints d'élagage, `M-PROC-54`) et ligne `**Modèle exécutant :**` dans l'en-tête (`M-PROC-53`).
- `09` + skill vivant : §Baseline M1 → renvoi vers le contrôle de budget pour le template, M1 gardé pour le projet cible ; étape conditionnelle « modèle changé depuis la dernière rétro → demander à l'humain un `/doctor prompt-audit` » (`M-PROC-53`).
- `02 §Cliquet` : ligne M1 alignée.
- README (version), CHANGELOG `## [v2.0+ELAG-4]`, `docs/` selon C9/C10, `/doctor prompt-audit` « après » sur un bootstrap neuf, collé par Laurent : aucune contradiction nouvelle par rapport au rapport « avant ».

---

## Critères d'acceptation

*(La Definition of Done — `STANDARDS.md §Definition of Done` — s'applique en plus.)*

- [ ] Retraits : `grep -cE "Rationalisations à reconnaître|Analyse en une passe|Batching XS/S|Chargement chirurgical|Validation incrémentale|^\*\*Éviter :\*\* voir|régénérer le fichier complet|^## Auto-revue du plan|Détection récurrences" 01-Claude-md-TEMPLATE.md` → `0`
- [ ] Gardées : `grep -cE "Source de vérité|Fichiers nécessaires" 01-Claude-md-TEMPLATE.md` → ≥ 2 (R-16, R-44) · `grep -c "wrap-up" 02-STANDARDS-TEMPLATE.md` → inchangé (R-83)
- [ ] HALT conservés : `grep -cE "^- \*\*HALT-(DEP|3X|ARCH|SCOPE|TIMEOUT)\*\*" 01-Claude-md-TEMPLATE.md` → `5`
- [ ] §Modifications spot ≤ 8 lignes : `awk '/^## Modifications spot/{f=1;next} /^## /{f=0} f' 01-Claude-md-TEMPLATE.md | grep -c .` → ≤ 8
- [ ] `02` : `grep -c "Ce fichier ne s'affaiblit pas" 02-STANDARDS-TEMPLATE.md` → `0` ; R-91 : `grep -c "Déclencheur DEPENDENCY_MAP" 02-STANDARDS-TEMPLATE.md` → `0` · `01:499` : `grep -c "^Éviter : complexité prématurée" 01-Claude-md-TEMPLATE.md` → `0`
- [ ] Taille : `wc -l < "$T1"/CLAUDE.md` ≤ `wc -l < "$T0"/CLAUDE.md` − 100 ; les deux mesures (lignes et octets) écrites dans `Corrections ajustées vs spec`
- [ ] Traçabilité : chaque ligne de `diff <(cut -d: -f4- /tmp/avant.txt) <(cut -d: -f4- /tmp/apres.txt)` est rattachée à un `R-NN` de §Règles visées
- [ ] Budget : `bash sdlc-validate.sh` → contrôle de budget OK ; `grep -nE "^BUDGET_(LIGNES|OCTETS)=" sdlc-validate.sh` = la mesure `T1` ; cas RED vert dans `bash tests/sdlc-validate-test.sh`
- [ ] Décisions : `grep -cE "^## M-(PROC-(49|50|51|53|54)|TMPL-10) · " 07-DECISIONS-SDLC.md` → `6` · `grep -cE "^## M-PROC-(52|5[5-9]) · " 07-DECISIONS-SDLC.md` → `0`
- [ ] `04` : `grep -cE "Règles visées|Modèle exécutant" 04-sprint-PDR-TEMPLATE.md` → `2`
- [ ] ROADMAP : `grep -cE "Import élagage 2|M-PROC-52" docs/ROADMAP.md` → ≥ 2
- [ ] Audit figé : `git diff --stat 573d1f3 -- specs/Sprints/AUDIT-ELAGAGE-1.md` → vide
- [ ] Prompt-audit « après » joint, sans contradiction nouvelle
- [ ] Tests niveau A : `bash sdlc-validate.sh` → tous les contrôles OK · `bash tests/sdlc-validate-test.sh` → tous OK
- [ ] CHANGELOG mis à jour (`v2.0+ELAG-4`), C1 vert

---

## Signaux de dégradation

- **Retrait silencieux** : le diff du comptage contient une règle absente de §Règles visées.
- **Compression au lieu de retrait** : des lignes fusionnées en phrases plus longues ; l'octet baisse moins que la ligne (comparer les ratios `T0`/`T1`).
- **Renvoi vers le vide** : un renvoi pointe vers un skill sans frontmatter ou une section absente (`grep` de la cible).

---

## Risques

- **Une règle retirée manque ensuite** : probabilité faible (critère de disposition) · réversible par git ; Job search applique déjà « une règle qui manque revient en garde ou en skill, pas en prose ».
- **Collision avec SDLC-33 sur `01`** : probable si l'ordre de la décision 4 n'est pas tenu · re-grep des ancres ; K6 retiré de SDLC-33.
- **R-07 sort du contexte chargé** (`02` n'est importé par rien) : moyen · forme bénigne seulement dans Job search ; à surveiller à la rétro suivante.
- **Le contrôle de budget ralentit le validateur** (un bootstrap par exécution) : faible · mesurer le temps ; s'il dépasse quelques secondes, réutiliser le bootstrap de C5 si ELAG-1b en crée un.
- **Données de Job search dans un dépôt public** : faible · seuls des IDs, verdicts et commits sont cités.

---

## Pre-mortem

> Si ce sprint échoue ou dépasse 2× l'estimation, la cause la plus probable est :

les ancres décalées par ELAG-1b et SDLC-33, qui transforment chaque édition en recherche. Parade : grep du texte de la règle (colonne Emplacement = indice, pas adresse), et lot 3 commencé par un relevé `R-NN → ligne actuelle` en une seule commande, écrit dans `sprint-memory.md`.

---

## Bilan de report (file `doc/REMONTEE_SDLC.md` de Job search)

À recopier par Laurent dans la file de Job search au wrap-up, avec les IDs de décision et les versions réelles des templates :

- **18/11-2** (« Modifications spot » contredit « ne jamais recréer ») : **adoptée** — R-37/R-38/R-39, `M-PROC-54`, template `01` v….
- **18/11-3** (liste « Éviter » en double) : **adoptée** — R-61 et `01:499` retirées, template `01` v….
- **ELAG-2 — `M-PROC-50` : où écrire la ligne « Usage règles »** : **adoptée pour mémoire** — consignée dans `M-PROC-50`, close sans reconduction.
- **14/11 — limite de la mesure d'usage auto-déclarée** : **adoptée** — motif de clôture de `M-PROC-50`.
- **18/11, apprentissages du Sprint 89** (échelle de réponse à un incident, plafonds testés) : **adaptée** — budget et cliquet adoptés (`M-PROC-49`, contrôle de `sdlc-validate.sh`) ; échelle, `/demarrage` et `.claude/rules/` **en attente** de la surveillance du Sprint 89 (« Import élagage 2 »).
- **18/11, décision 5** (`prompt-audit` avant diffusion d'un template) : **adoptée** — `M-PROC-53`, `04`, `09`.
- **14/11 — 6 règles `R-JS`** : **en attente** — SDLC-33.

---
<!-- FIN PRD — La section Handoff est complétée par Claude Code en début de session -->

## Handoff Claude Code
*(à compléter en début de session)*

> Ce PDR ne remplace pas `Claude.md §Démarrage` — les 4 étapes (4a créer le
> fichier spec · 4b initialiser la mémoire sprint · 4c charger les fichiers ·
> 4d écrire le §Plan de développement) restent dues même si ce Handoff n'en
> détaille qu'une partie ci-dessous.

**Fichiers — chargement immédiat :** ce PDR · `01-Claude-md-TEMPLATE.md` · `AUDIT-ELAGAGE-1.md §1.4` (script) et `§Propositions`

**Fichiers — chargement différé :** `07-DECISIONS-SDLC.md` (grep des IDs, tableau `:495`) · `02`, `04`, `09` · `sdlc-validate.sh`, `tests/sdlc-validate-test.sh` · Job search @ `06a30f7` via `git show` vers `/tmp/js/` (grep seulement)

**Grep de vérification préalable :**
```bash
git log --oneline -5
git log --oneline | grep -i "ELAG-1b" || echo "⚠️ ELAG-1b absent — BLOQUANT"
grep -oE '\bM-PROC-[0-9]+' 07-DECISIONS-SDLC.md | sort -t- -k3n -u | tail -1
grep -oE "^check_c[0-9]+" sdlc-validate.sh | tail -1
wc -lc 01-Claude-md-TEMPLATE.md
```

**Instructions spécifiques :**
- Demande d'aval après le lot 1 (texte des décisions), puis avant le lot 3 (relevé `R-NN → ligne actuelle`), puis avant chaque commit.
- Un commit par lot : `docs(elagage): ELAG-4 lot N — …`.

---

## Plan de développement
*(rédigé le 19/11/2026 en début de session, branche `elag-4` depuis `main` @ `8ca2808`)*

### Inputs vérifiés au démarrage
- ELAG-1b livré : bootstrap jetable → `CLAUDE.md` présent, `head -1 .claude/skills/wrap-up/SKILL.md` → `---` ✓
- Job search lisible : `git -C ~/Downloads/Sandbox/JobSearch cat-file -e 06a30f7:specs/Sprints/AUDIT-ELAGAGE-2.md` → OK ✓
- Audit figé : `git diff --stat 573d1f3 -- specs/Sprints/AUDIT-ELAGAGE-1.md` → vide ✓
- `bash sdlc-validate.sh` → `10/10 ✅` · `bash tests/sdlc-validate-test.sh` → `18/18 cas OK` ✓
- Dernier ID : `M-PROC-48` · dernier contrôle : `check_c10` → le contrôle de budget sera **C11**
- **Manquant : rapport `/doctor prompt-audit` « avant »** (seul l'humain peut le lancer). Il ne conditionne ni le lot 1 ni le lot 2 ; il est exigé **avant la première édition de `01` au lot 3** (il doit porter sur le `01` actuel).

### Mesure de départ (T0)
- Bootstrap neuf : `wc -lc "$T0"/CLAUDE.md` → `499 25376` · `STANDARDS.md` → `192 8991`
- Comptage : `bash compter-regles.sh "$T0" "$SDLC" | wc -l` → `134` (= valeur d'ELAG-1) · script recopié depuis `AUDIT-ELAGAGE-1.md §1.4` dans le scratchpad, `Claude.md` → `CLAUDE.md`, non versionné
- Durée d'un bootstrap : `time bash sdlc-init.sh "Test"` → `0,22 s` (le risque « validateur ralenti » est écarté, pas de réutilisation à prévoir)

### Relevé R-NN → ligne actuelle (ancres de `012905d` re-greppées sur `8ca2808`)
ELAG-1b n'a décalé aucune ancre de `01` : les lignes de la grille et du PDR correspondent au fichier actuel.
| R-NN | `01` / `02` actuel | R-NN | `01` / `02` actuel |
|---|---|---|---|
| R-03 | `01:17` | R-41 | `01:281-282` |
| R-07 | `01:26-28` | R-42 | `01:283-284` |
| R-12 | `01:39-42` | R-48 | `01:313-319` (cible) |
| R-13 | `01:44-93` (+ intro `95-97` gardée) | R-50 | `01:327-345` (cible) |
| R-14 | `01:99` | R-51 | `01:347-356` |
| R-15 | `01:110-113` | R-52 | `01:358-368` (cible) |
| R-24 | `01:160-167` (cible) | R-59 | `01:428-429` |
| R-28 | `01:217` | R-61 | `01:433` + `01:499` |
| R-29 | `01:218` | R-62 | `01:439-445` (cible) |
| R-32 | `01:228` | R-63→R-65 | `01:447-450` |
| R-34 | `01:230` | R-66→R-76 | `01:460-473` |
| R-36 | `01:236-250` | R-77 | `01:475-477` (inchangée) |
| R-37→R-39 | `01:254-273` | R-91 | `02:77` |
| R-40 | `01:280` | R-92 | `02:85-88` (cible) · R-97 `02:107` |

### Modules touchés · risques
- Cœur du changement : `01` (≈ 120 lignes retirées), `02` (2 lignes), `sdlc-validate.sh` (+ C11), `tests/sdlc-validate-test.sh` (+ 2 cas).
- Gouvernance associée : `07` (6 décisions + 6 lignes du tableau de compatibilité), `04`, `09` + skill vivant, ROADMAP, LESSONS, README, CHANGELOG, `docs/` selon C9/C10.
- **Taille : cœur M, totale L** (règle SDLC-11) — conforme au PDR.
- Modules partagés : `01` et `02` sont copiés dans chaque projet bootstrappé → test B = `bash tests/sdlc-init-test.sh` (le test du bootstrap ne doit pas casser).
- Risque écarté : aucun script ne grep le texte retiré — `grep -nE "Rationalisations|Chargement chirurgical|Modifications spot|HALT-TIMEOUT|Éviter|Validation incrémentale|Auto-revue|DEPENDENCY_MAP|ne s'affaiblit" tests/*.sh sdlc-*.sh` → vide (19/11).
- Point à trancher au lot 3 (cf. Demande d'aval) : la « ligne de renvoi » qui remplace R-36 pointe vers `M-TMPL-06` (le contrôle C11 protège le template, pas le `CLAUDE.md` du projet cible).


### Prompt-audit « avant » (Laurent, 19/11/2026 — bootstrap neuf `Test`, modèle Claude Opus 5.5, `01` v2.7 à `1e8a8b9`)
Synthèse : `CLAUDE.md` 499 lignes, 4 skills ; 9 constats, 6 signalements (groupe 2 : 8 constats + 6 signalements ; groupe 1 : 1 + 1 ; groupes 3 et 4 : 0 / N/A). Patch proposé par l'audit non appliqué (`M-PROC-54`).
| # | Emplacement | Constat | Rattachement ELAG-4 |
|---|---|---|---|
| H1 | `CLAUDE.md:21-25` | « Pensée/Réalité » de la règle 4a-4d cite un `DECISIONS.md M-HOOKS-04` absent | hors §Règles visées → report |
| H2 | `CLAUDE.md:351` | renvoi vers `04-sprint-PDR-TEMPLATE.md`, absent du projet (→ `specs/sprint-template.md`) | disparaît avec §Auto-revue (R-51 → R-52) |
| H3 | `CLAUDE.md:39-42` | `[N]` renvoie à §Limites bash, qui ne le définit pas | R-12 : 120 s écrit dans la ligne |
| H4 | `CLAUDE.md:134` | `git pull origin main` échoue sans remote et bloque `git status`/`git log` (`&&`) | hors §Règles visées (§3.3 n° 6 d'ELAG-1) → report |
| M1 | `CLAUDE.md:44-93` | tables de rationalisation « HYPOTHÈSE », redites des HALT | R-13 (retrait) — confirmé |
| M2 | `CLAUDE.md:254-273` | `sed` imposé, « régénérer le fichier complet » | R-37→R-39 (réécriture) — confirmé |
| M3 | `CLAUDE.md:208` | « Mode /fast » entre en collision avec la commande intégrée `/fast` | hors §Règles visées → report |
| M4 | `diagnostic/SKILL.md:6-17` | bloc de placeholders `[→ ADAPTER]` chargé dans le skill | hors §Règles visées → report |
| M5 | `CLAUDE.md:395,397`, `wrap-up` `:52,62`, `retrospective` `:268` | IDs du dépôt SDLC (`M-HOOKS-08`, `M-PROC-10`, `M-PROC-44`, `LL-T08`, `M-PROC-22`) introuvables dans le projet | hors §Règles visées → report |
Signalements : F1 « Mode /fast » contre « jamais sauter l'analyse » (`:15-16` / `:208-211`) · F2 placeholders du rôle et des limites bash chargés à chaque session · F3 hook `PreCompact` dit actif, documenté optionnel · F4 « si une règle n'est pas ici, elle n'existe pas » contre les renvois à `STANDARDS.md` et aux skills · F5 « fait vérifié » d'une source externe non datée (`:236-250`, disparaît avec R-36) · F6 exemples d'un autre projet dans `retrospective` `:114,121` · versions des templates divergentes.

### Plan d'exécution
1. **Lot 1** — `07` : `M-PROC-49`, `50`, `51`, `53`, `54`, `M-TMPL-10` au format des entrées existantes + 6 lignes du tableau de compatibilité · ROADMAP : `M-PROC-52`, fusion des couches du wrap-up (`M-PROC-51` (1)), `CLAUDE.md` vivant du repo SDLC en §Later (« Import élagage 2 » existe déjà, `docs/ROADMAP.md:35`) · LESSONS : entrée « Import élagage » ouverte. **Aval sur le texte des décisions, puis commit.**
2. **Lot 2** — `check_c11` : bootstrap `mktemp -d` depuis `$ROOT/sdlc-init.sh`, `wc -l`/`wc -c` du `CLAUDE.md` produit, constantes `BUDGET_LIGNES=499` / `BUDGET_OCTETS=25376` (gel, `# M-PROC-49`) · cas RED (+1 ligne → ❌ C11) et cas vert (mesure exacte) dans `tests/sdlc-validate-test.sh`. Le cas RED est d'abord vu rouge. **Aval, commit, point de coupe.**
3. **Lot 3** — (prérequis : prompt-audit « avant » reçu) retraits → fusions → réécritures, une édition par règle vérifiée par grep · mesure T1 · diff du comptage rattaché aux R-NN dans §Corrections ajustées · constantes abaissées à T1. **Aval avant de commencer, puis avant le commit.**
4. **Lot 4** — `04` (2 champs), `09` + skill vivant (M1 → renvoi C11 pour le template, étape « modèle changé → prompt-audit »), `02 §Cliquet` ligne M1, versions (C2), README/CHANGELOG `v2.0+ELAG-4`, prompt-audit « après ». **Aval, commit, puis `/wrap-up`.**

### Plan de test
- **A — Ciblé** : les 15 critères d'acceptation du PDR, chacun par sa commande ; plus `bash sdlc-validate.sh` (11/11) et `bash tests/sdlc-validate-test.sh` (tous OK, dont les 2 cas C11).
- **B — Non-régression** : `bash tests/sdlc-init-test.sh` → tous les cas OK (49 à ce jour) ; `diff <(cut -d: -f4- avant.txt) <(cut -d: -f4- apres.txt)` ne contient que des règles de §Règles visées ; HALT : 5 ; `git diff --stat 573d1f3 -- specs/Sprints/AUDIT-ELAGAGE-1.md` vide.
- **C — Intégration** : N/A (pas de système exécutable) ; tient lieu de C : prompt-audit « après » sur un bootstrap neuf, sans contradiction nouvelle.

---

## Corrections ajustées vs spec
*(à compléter au fil de l'exécution)*

- **Lot 1 — taille du `CLAUDE.md` de Job search** : le PDR écrit « réécrit de 369 à 92 lignes » (Sprint 89) ; à `06a30f7`, `git -C "$JS" show 06a30f7:CLAUDE.md | wc -l` → `94`. `M-PROC-54` cite 94 avec sa commande.
- **Lot 1 — C18** : le PDR rattache C18 à la table ELAG-3 ; il est défini dans `AUDIT-ELAGAGE-2.md` (`grep -c C18` → 1 ; 0 dans `ELAG-3-table-verdict.md`), où c'est un compactage en renvoi. `M-TMPL-10` cite la bonne source.
- **Lot 2 — nom du projet dans C11** : la substitution du nom de projet change la taille du fichier (« Budget » donnait 25 378 o contre 25 376 avec « Test ») ; constante `BUDGET_NOM_PROJET="Test"`, le nom de la commande de mesure du PDR.
- **Lot 2 — docs au total figé** : `README.md:5`, `docs/pages/modules.md`, `00-CONTEXT.md:121` disaient « 10 contrôles » ; passés en formulation sans total (`LL-T14`), ligne C11 ajoutée à `modules.md`. Prévu au lot 4 par le PDR, avancé au lot 2 pour qu'aucun commit ne laisse une doc fausse.
- **Lot 3 — mesures** : T0 `wc -lc CLAUDE.md` (bootstrap `Test`) → `499 25376` · T1 → `368 18162` (−131 lignes, −26,3 % ; −7 214 octets, −28,4 % : l'octet baisse plus que la ligne, pas de compression) · `STANDARDS.md` `192 8991` → `190 8823` · comptage `compter-regles.sh` 134 → 107 (dont `check_c11` ajouté au lot 2). `BUDGET_LIGNES=368`, `BUDGET_OCTETS=18162`.
- **Lot 3 — traçabilité du diff du comptage** (`diff <(cut -d: -f4- avant.txt) <(cut -d: -f4- apres.txt)`) : R-01/R-14 (`:15` fusionnée) · R-07 · R-12 · R-13 · R-14 · R-15 · R-28 · R-29 · R-32 · R-34 · R-36 · R-37→R-39 (lignes 1-3 numérotées retirées ; texte réécrit non compté, prose sans puce) · R-40, R-41, R-42 · R-51 · R-59 · R-61 · R-63→R-65 · R-66→R-76 · R-91 · R-97 · `check_c11` (lot 2, `M-PROC-49`). Aucune autre ligne.
- **Lot 3 — cibles de fusion hors §Règles visées, corps modifié, ligne comptée inchangée** : R-62 (phrase « toute conclusion cite… » ajoutée, renvoi circulaire vers §Rôle retiré) · R-50 (phrase R-41 ajoutée) · R-52 (ligne « Auto-évaluation ») · R-24 (commentaire 4c : « jamais de lecture préventive ») · R-92 (parenthèse de R-07) · R-01 (énoncé de R-14 ajouté — sa ligne comptée change).
- **Lot 3 — R-12** : le prompt-audit « avant » (H3) montre que §Limites bash ne définit pas N ; la ligne porte `timeout 120`, sans renvoi.
- **Lot 3 — R-63→R-65** : définition compacte gardée en §Test (là où elle est lue au moment de conclure) plutôt que dans le gabarit d'Analyse (R-48) ; renvoi vers `STANDARDS.md §Niveaux de test`.
