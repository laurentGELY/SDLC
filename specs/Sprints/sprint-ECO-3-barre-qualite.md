# Sprint ECO-3 — Barre qualité chiffrée et cliquet de contexte

<!-- PDR rédigé par Claude Code depuis specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md §E-03/E-04/E-11 -->
<!-- Destination : specs/Sprints/sprint-ECO-3-barre-qualite.md -->
<!-- Modèle au moment de la rédaction : v2.0+SDLC-26 · dernière décision M-PROC-41 -->

**Type :** Doc
**Taille :** M
**Surface :** `02-STANDARDS-TEMPLATE.md` (+§Barre qualité) · `Claude.md`/`01-Claude-md-TEMPLATE.md` (§Règles absolues) · `06-PDR-bootstrap.md` · `04-sprint-PDR-TEMPLATE.md` · `03-wrap-up-SKILL-TEMPLATE.md`/`.claude/skills/wrap-up/SKILL.md` (§3.5) · `09-retrospective-SKILL-TEMPLATE.md`/`.claude/skills/retrospective/SKILL.md` (§Étape 7) · `07-DECISIONS-SDLC.md`
**Risque :** Faible — ajout de prose et d'une checklist Q/R, même famille que `§Observabilité` déjà en place

---

## Contexte

`specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md §E-03/§E-04/§E-11` documente trois manques
autour de la barre de qualité du modèle. **Vérification factuelle avant rédaction de ce
PDR** (`Claude.md §Analyse`, `M-PROC-41`) — les trois claims de l'ANALYSE ont été
recoupées contre l'état réel du repo avant d'écrire une ligne :

- **`E-03`** — confirmé exact : `02-STANDARDS-TEMPLATE.md` n'a aucune section de seuils
  chiffrés, aucune colonne « vérifié par » systématique, aucun cliquet, aucune table
  d'exceptions datées, et rien n'interdit à un agent d'affaiblir un seuil pour passer au
  vert (`grep -n "affaibl" Claude.md 01-Claude-md-TEMPLATE.md` → vide).
- **`E-04`** — **partiellement inexact**, corrigé avant rédaction. L'ANALYSE affirme que
  la Definition of Done est « éclatée » dans le modèle. Faux : `02-STANDARDS-TEMPLATE.md`
  porte déjà une section `## Definition of Done` consolidée (2 blocs : Livrable/Clôture)
  depuis le tout premier commit du toolkit (`git log --follow` confirmé), et `Claude.md`
  §345 + `01-Claude-md-TEMPLATE.md` §435 la référencent déjà explicitement (« Avant tout
  commit : vérifier la DoD (`STANDARDS.md §Definition of Done`) »). Le « gain double »
  que l'ANALYSE proposait (consolider + référencer plutôt que recopier) est déjà acquis.
  Ce qui manque réellement, et seulement cela : `04-sprint-PDR-TEMPLATE.md` ne rappelle
  nulle part que la DoD s'applique en plus des critères d'acceptation du sprint, et
  l'Étape 3.5 du wrap-up ne cite pas la DoD par son nom dans sa checklist. Portée réduite
  en conséquence — voir §Portée.
- **`E-11`** — confirmé exact : `09-retrospective-SKILL-TEMPLATE.md §Étape 7` mesure M1/M2
  et les compare « au sprint précédent », sans seuil numérique — signal sans déclencheur,
  même défaut que celui déjà corrigé pour `[CONF: FAIBLE]` par `M-PROC-18`.

---

## Objectif

`02-STANDARDS-TEMPLATE.md` porte une §Barre qualité vérifiable par commande (seuils,
plancher non négociable, cliquet, exceptions datées) ; `Claude.md §Règles absolues`
interdit explicitement l'auto-affaiblissement d'un seuil ; le cliquet de contexte
(`M1`, `E-11`) a un seuil de dépassement qui déclenche une action au lieu d'un simple
signal ; la DoD déjà existante est référencée, pas recopiée, aux deux points qui n'en
disposent pas encore.

---

## Comportement actuel → cible

- **Actuel :** aucune barre de qualité chiffrée dans le modèle — la seule checklist du
  même type existante (`§Observabilité`) couvre le logging du projet cible, pas la
  qualité de son code. Rien n'empêche un agent de baisser un seuil pour faire passer un
  changement. `M1`/`M2` sont mesurés en rétrospective mais comparés sans seuil.
- **Cible :** `02-STANDARDS-TEMPLATE.md §Barre qualité` — même famille structurelle que
  `§Observabilité` (Q/R au bootstrap, grep de validation, `[À REMPLIR]` avant le premier
  commit) — avec un tableau à 4 colonnes (Dimension/Règle/Vérifié par/S'exécute à), un
  plancher non négociable, un cliquet horodaté, une table d'exceptions. Ligne
  anti-affaiblissement dans `§Règles absolues`. `M1` a un seuil de croissance (`E-11`)
  qui rend obligatoire une piste d'allègement dans le rapport de rétrospective en cas de
  dépassement.

---

## Portée

**Inclus :**
- `02-STANDARDS-TEMPLATE.md` : nouvelle `## Barre qualité` — tableau 4 colonnes
  (placeholders `[À REMPLIR]`, même convention que `§Observabilité`), plancher (liste
  fixe d'interdits non négociables + ligne anti-affaiblissement), cliquet (incluant la
  ligne « Contexte permanent (M1) » de `E-11`), table d'exceptions (`ID | Règle | Chemin
  | Raison | Propriétaire | Expire le`), 4 questions de cadrage au bootstrap (miroir de
  `§Observabilité`, plafonnées à 4 par la consigne source elle-même)
- `Claude.md` et `01-Claude-md-TEMPLATE.md §Règles absolues` : +1 règle — ne jamais
  affaiblir un seuil de `STANDARDS.md §Barre qualité` (seuil baissé, suppression ajoutée,
  test retiré) pour faire passer un changement, sans passer par la table d'exceptions
  datées
- `06-PDR-bootstrap.md` : +1 étape de bootstrap pour compléter la §Barre qualité (miroir
  de l'étape existante pour §Observabilité), + critère d'acceptation grep
- `04-sprint-PDR-TEMPLATE.md` : +1 ligne rappelant que la DoD (`STANDARDS.md §Definition
  of Done`) s'applique en plus des critères d'acceptation du sprint, jamais recopiée
- `03-wrap-up-SKILL-TEMPLATE.md` + `.claude/skills/wrap-up/SKILL.md §3.5` : +1 ligne de
  checklist citant `STANDARDS.md §Definition of Done` par son nom
- `09-retrospective-SKILL-TEMPLATE.md` + `.claude/skills/retrospective/SKILL.md §Étape
  7` : seuil explicite sur M1 (« ne croît pas de plus de X % entre deux rétrospectives,
  sinon piste d'allègement obligatoire dans le rapport ») — valeur de X fixée par défaut
  raisonnable, ajustable en exception
- Entrée `M-PROC-42` dans `07-DECISIONS-SDLC.md`

**Exclu (explicitement) :**
- Reconstruire la section `## Definition of Done` existante — elle est déjà consolidée
  et déjà référencée, `E-04` est traité par 2 renvois seulement (voir Contexte)
- Remplir le tableau `§Barre qualité` avec des valeurs réelles pour le projet toolkit
  SDLC lui-même — ce PDR touche les **templates génériques**, pas `STANDARDS.md` de ce
  repo (qui n'existe d'ailleurs pas séparément — ce repo est son propre modèle, cf.
  `Claude.md §Rôle`). Un sprint distinct instrumenterait `sdlc-validate.sh` si une
  §Barre qualité est un jour voulue pour le modèle lui-même.
- Contrôle mécanique `C11`/`C12` dans `sdlc-validate.sh` vérifiant la §Barre qualité —
  vague ultérieure (`ECO-1 §Annexe`), pas ce sprint
- `E-12` (revue à deux étages + disjoncteur, débloque `P-21`) — catalogue différent,
  hors périmètre de ce PDR

---

## Option retenue — alternatives écartées

**Retenue :** une seule nouvelle section `§Barre qualité` dans `02-STANDARDS-TEMPLATE.md`,
construite sur le même gabarit que `§Observabilité` déjà en place (Q/R + grep +
`[À REMPLIR]`) plutôt qu'un format inédit — cohérence de lecture pour qui bootstrap un
projet. `E-04` traité par 2 renvois d'une ligne, pas une réécriture.

**Écartée(s) :**
- **`CONSTRAINTS.md` séparé** (proposition source de `E-03`) — écarté : contredirait
  `M-ARCH-01`/`M-ARCH-03` (limiter le nombre de fichiers en contexte permanent). Même
  raison déjà actée pour ne pas créer de fichier séparé pour l'Observabilité.
- **Reconstruire la Definition of Done en 5 blocs/3 grains** (format source de `E-04`) —
  écarté : le format actuel (Livrable/Clôture) fonctionne déjà et est déjà référencé ;
  le remplacer sans défaut constaté serait une réécriture sans preuve.
- **Valeur cible absolue pour M1** (ex. "max 3500 mots") plutôt qu'un cliquet en
  pourcentage — écarté explicitement par la source de `E-11` elle-même : « une valeur
  cible absolue serait arbitraire et se ferait ignorer ».

**Sacrifices délibérés :** le tableau `§Barre qualité` reste à `[À REMPLIR]` dans le
template générique — comme `§Observabilité`, il n'a de sens qu'une fois rempli avec les
dimensions réelles du projet cible.

---

## Contraintes techniques / produit

- Même gabarit Q/R que `§Observabilité` (cohérence de lecture, pas un format inédit)
- Zéro renumérotation de section existante dans les fichiers touchés
- La ligne anti-affaiblissement dans `§Règles absolues` doit être vérifiable par lecture
  humaine (pas de commande possible — c'est une règle de jugement, comme les règles
  absolues existantes)

**Interdit :**
- Reconstruire ou renommer la section `## Definition of Done` existante
- Remplir les placeholders `§Barre qualité` avec des valeurs inventées pour un projet
  qui n'existe pas — rester en `[À REMPLIR]`, cohérent avec `§Observabilité`
- Toucher `sdlc-validate.sh` (aucun contrôle mécanique dans ce sprint)

---

## Dépendances

**Inputs requis** *(ce sprint assume que ces outputs existent et sont valides)* :
- [x] `specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md §E-03/§E-04/§E-11` — présent, vérifié
      contre l'état réel du repo avant rédaction (voir §Contexte — `E-04` corrigé)
- [x] `sdlc-validate.sh`, `M-PROC-40/41` — présents, 8/8 sur l'état actuel
- [x] Dernier ID `M-PROC` attribué — `M-PROC-41` (Sprint SDLC-26), `M-PROC-42` libre

**Outputs produits** *(ce que les sprints suivants pourront utiliser)* :
- [x] `02-STANDARDS-TEMPLATE.md §Barre qualité` — point d'ancrage pour un contrôle
      `sdlc-validate.sh` ultérieur si le modèle instrumente sa propre barre qualité
- [x] Décision `M-PROC-42` dans `07-DECISIONS-SDLC.md`
- [x] Seuil explicite sur M1 — réutilisable par toute future `/retrospective`

**Règle :** avant de démarrer, vérifier que tous les inputs requis cochés existent et
sont dans l'état attendu. Si un input manque ou a changé → signaler comme BLOQUANT avant
toute analyse.

---

## Critères d'acceptation

- [x] `grep -c "^## Barre qualité" 02-STANDARDS-TEMPLATE.md` → `1`
- [x] `grep -A30 "^## Barre qualité" 02-STANDARDS-TEMPLATE.md | grep -c "^|"` → `≥ 4`
      (en-tête + ≥ 3 lignes du tableau à 4 colonnes)
- [x] `grep -A40 "^## Barre qualité" 02-STANDARDS-TEMPLATE.md | grep -c "ne s'affaiblit pas\|affaiblir"`
      → `≥ 1` (plancher anti-affaiblissement présent dans la section elle-même)
- [x] `grep -A50 "^## Barre qualité" 02-STANDARDS-TEMPLATE.md | grep -c "Expire le"` → `1`
      (table d'exceptions présente, en-tête exact — critère corrigé au wrap-up :
      `-A40` était trop court, la table réelle arrive à la ligne +42 ; voir §Corrections
      ajustées vs spec)
- [x] `grep -c "\[À REMPLIR\]" 02-STANDARDS-TEMPLATE.md` → strictement supérieur à sa
      valeur d'avant ce sprint (nouvelles questions de cadrage ajoutées au même format
      que `§Observabilité`, jamais pré-remplies) — confirmé 5 → 10
- [x] `grep -c "affaiblir\|affaiblisse" Claude.md 01-Claude-md-TEMPLATE.md` → `≥ 1` chacun
- [x] `grep -c "§Barre qualité\|Barre qualité" 06-PDR-bootstrap.md` → `≥ 1`
- [x] `grep -c "Definition of Done" 04-sprint-PDR-TEMPLATE.md` → `≥ 1`
- [x] `grep -c "Definition of Done" 03-wrap-up-SKILL-TEMPLATE.md .claude/skills/wrap-up/SKILL.md`
      → `≥ 1` dans chacun
- [x] `grep -A5 "Comparer M1/M2" 09-retrospective-SKILL-TEMPLATE.md .claude/skills/retrospective/SKILL.md | grep -c "%"`
      → `≥ 1` dans chacun (seuil numérique explicite, pas juste "une variation notable")
- [x] `grep -c "M-PROC-42" 07-DECISIONS-SDLC.md` → `≥ 1`
- [x] `grep "M-PROC-42" 07-DECISIONS-SDLC.md` → l'entrée porte les 4 champs du format :
      Retenu · Écarté · Raison · Déclencheur de réouverture
- [x] `bash sdlc-validate.sh` → `8/8 ✅`, exit 0 — non-régression (C2/C4 les plus proches
      de la surface touchée, 09/retrospective et 03/wrap-up sont des paires C4)
- [x] Tests niveau A : `bash sdlc-validate.sh ; echo $?` → `0`
- [x] CHANGELOG mis à jour, ligne `**Tests**` porte le résultat réel de `sdlc-validate.sh`

<!-- Guidance goal-backward : chaque critère est un état observable produit par une
     commande, jamais "la section est écrite" ou "la règle est ajoutée". -->

---

## Risques

- **Le tableau `§Barre qualité` à 4 colonnes copie le vocabulaire source sans
  l'adapter au modèle SDLC** (comme `§5.2` d'`ECO-2` l'a fait pour `E-09`) : *moyen* ·
  utiliser des exemples génériques neutres (couverture de test, secrets, tests
  supprimés) plutôt que des mécanismes SDLC spécifiques — ce tableau est un gabarit pour
  un projet cible, pas une auto-description du modèle
- **Le seuil M1 choisi par défaut (`E-11` ne fixe pas de valeur)** : *faible* · fixer un
  pourcentage raisonnable (proposition : 10 %, cohérent avec la hausse M2 +9,9% déjà
  observée SDLC-26 sans qu'elle ait été jugée problématique) et l'exposer comme
  modifiable via la table d'exceptions, pas comme une constante gravée

---

## Pre-mortem *(obligatoire taille M)*

> Si ce sprint échoue ou dépasse 2× l'estimation, la cause la plus probable est :

Le tableau `§Barre qualité` et ses 4 questions de cadrage dérivent vers une
reformulation complète de `§Observabilité` par souci de symétrie parfaite, alors que les
deux checklists couvrent des dimensions différentes (logging d'exécution vs qualité de
code) et n'ont pas à être identiques au-delà de leur gabarit (Q/R + grep + `[À REMPLIR]`).
**Signal d'alerte :** plus de 15 minutes passées à choisir la formulation exacte d'une
question de cadrage. **Conduite à tenir :** reprendre les 4 questions du gabarit source
(`E-03`) presque verbatim, seulement traduites et génériques — ne pas chercher à les
rendre spécifiques au modèle SDLC, elles sont pour le projet cible.

---

## Handoff Claude Code

**Fichiers — chargement immédiat :**
- `specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md §E-03, §E-04, §E-11` (déjà lus pour rédiger
  ce PDR, y compris la vérification factuelle qui corrige `E-04`)
- `02-STANDARDS-TEMPLATE.md` (fichier complet — déjà lu, 147 lignes)
- `06-PDR-bootstrap.md` (section bootstrap `§Observabilité` comme gabarit à répliquer)
- `04-sprint-PDR-TEMPLATE.md`, `03-wrap-up-SKILL-TEMPLATE.md §3.5`,
  `.claude/skills/wrap-up/SKILL.md §3.5` (déjà lus)
- `09-retrospective-SKILL-TEMPLATE.md §Étape 7`, `.claude/skills/retrospective/SKILL.md
  §Étape 7` (déjà lus, confirmés identiques)
- `Claude.md §Règles absolues`, `01-Claude-md-TEMPLATE.md §Règles absolues`

**Fichiers — chargement différé :**
- `07-DECISIONS-SDLC.md` — grep `^## M-PROC-` pour confirmer le prochain ID, lecture
  complète uniquement pour rédiger `M-PROC-42`

**Données à collecter avant de coder :**
- Déjà collectées lors de la vérification factuelle (§Contexte) : `E-04` corrigé,
  absence de règle anti-affaiblissement confirmée, dernier `M-PROC` confirmé

**Init mémoire sprint :**
```bash
echo "# Sprint ECO-3 — barre-qualite · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-ECO-3-barre-qualite.md" >> .claude/sprint-memory.md
```

---

## Plan de développement
*(produit par Claude Code après analyse — à compléter en étape 4d, avant tout code)*

**Dépendances vérifiées :**
- [x] `E-04` recoupé contre l'état réel — DoD déjà consolidée et déjà référencée,
      portée réduite à 2 renvois
- [x] Absence de règle anti-affaiblissement confirmée (`grep` vide)
- [x] `.claude/skills/retrospective/SKILL.md` confirmé identique au template (même
      §Étape 7, à modifier en miroir)

**Modules touchés :** cf. §Surface

**Risques identifiés :** cf. §Risques et §Pre-mortem

**Plan d'exécution :**
1. `02-STANDARDS-TEMPLATE.md` : rédiger `## Barre qualité` (tableau 4 colonnes,
   plancher + anti-affaiblissement, cliquet incluant M1, exceptions, 4 questions
   `[À REMPLIR]`)
2. `Claude.md` et `01-Claude-md-TEMPLATE.md §Règles absolues` : +1 ligne
   anti-affaiblissement
3. `06-PDR-bootstrap.md` : +1 étape bootstrap (miroir Observabilité) + critère grep
4. `04-sprint-PDR-TEMPLATE.md` : +1 ligne DoD
5. `03-wrap-up-SKILL-TEMPLATE.md` + `.claude/skills/wrap-up/SKILL.md §3.5` : +1 ligne DoD
6. `09-retrospective-SKILL-TEMPLATE.md` + `.claude/skills/retrospective/SKILL.md §Étape
   7` : seuil M1 explicite (10 %)
7. `M-PROC-42` dans `07-DECISIONS-SDLC.md`
8. `bash sdlc-validate.sh` → 8/8 attendu (non-régression)
9. CHANGELOG + wrap-up

**Plan de test :**
- A — Ciblé : `bash sdlc-validate.sh ; echo "exit=$?"`
- B — Non-régression : aucun mécanisme exécutable touché — le test A sert aussi de garde
  non-régression (particulièrement C2/C4 sur les 2 paires skill modifiées)

---

## Corrections ajustées vs spec
*(complété au wrap-up — §Étape 3)*

**Corrections ajustées vs spec :**
- Un critère d'acceptation trop étroit (`grep -A40` au lieu de `-A50` pour repérer la
  table d'exceptions, qui arrive à la ligne +42 de la section) — corrigé en cours
  d'exécution, contenu déjà correct, seule la commande de vérification était mal
  calibrée.
- `06-PDR-bootstrap.md` : pas de nouvelle « étape de bootstrap » créée comme envisagé au
  §Plan d'exécution — vérifié que `§Observabilité` elle-même n'a jamais eu d'étape
  dédiée dans ce fichier (seulement une ligne dans le tableau d'adaptation générique +
  le grep de validation final) ; la même convention légère a été suivie pour `§Barre
  qualité`, sans créer d'étape inédite non justifiée par l'état réel du fichier.
- `§Barre qualité` n'a pas été ajoutée à la `STANDARDS.md` vivante de ce repo (au-delà
  du périmètre déjà exclu dans le PDR) : vérifié que `STANDARDS.md` est l'un des 8
  fichiers contrôlés par `C3` de `sdlc-validate.sh` — y ajouter des `[À REMPLIR]` non
  remplis y aurait cassé `C3`, confirmant a posteriori que l'exclusion de portée du PDR
  était la bonne décision, pas seulement une question de taille de sprint.
