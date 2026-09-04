# Sprint ECO-4 — Durcissement PDR

<!-- PDR rédigé par Claude Code depuis specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md §E-06/§E-07/§E-13(b)/§E-14 -->
<!-- Destination : specs/Sprints/sprint-ECO-4-durcissement-pdr.md -->
<!-- Modèle au moment de la rédaction : v2.0+ECO-3 · dernière décision M-PROC-42 -->

**Type :** Doc
**Taille :** S
**Surface :** `04-sprint-PDR-TEMPLATE.md` (+§Pas de placeholders) · `01-Claude-md-TEMPLATE.md` (§Analyse : +§Auto-revue du plan, +champ DÉCISION, +règle de précédence §Mémoire de sprint) · `03-wrap-up-SKILL-TEMPLATE.md`/`.claude/skills/wrap-up/SKILL.md` (§3, grep étendu) · `07-DECISIONS-SDLC.md`
**Risque :** Faible — ajouts de prose/checklist dans des sections existantes, pas de nouvelle section structurelle lourde, pas de mécanisme exécutable modifié en dehors d'un grep déjà présent

---

## Contexte

`specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md §E-06/§E-07/§E-13/§E-14` documente quatre
manques de durcissement du PDR et du cycle Analyse → Aval. `docs/ROADMAP.md §Next`
scope l'item explicitement à **E-13(b)** (liste « Pas de placeholders » seule — ni (a)
Interfaces Consumes/Produces, ni (c) dimensionnement des tâches).

**Vérification factuelle avant rédaction de ce PDR** (`Claude.md §Analyse`,
`M-PROC-41`) — les quatre claims ont été recoupés contre l'état réel du repo :

- **`E-13(b)`** — confirmé exact : `04-sprint-PDR-TEMPLATE.md` n'a aucune section
  bannissant les placeholders de plan (`grep -c "Pas de placeholders"
  04-sprint-PDR-TEMPLATE.md` → `0`), et l'enforcement grep de l'Étape 3 du wrap-up
  (`03-wrap-up-SKILL-TEMPLATE.md:236`) ne couvre que `[À REMPLIR]|[ ]|[→ ADAPTER]`,
  pas les motifs de plan bâclé (« TBD », « cas limites appropriés », etc.).
- **`E-14`** — confirmé exact : `01-Claude-md-TEMPLATE.md §Analyse` enchaîne
  `§Vérification factuelle` → `§Demande d'aval` sans passe de cohérence interne du
  plan lui-même (couverture spec / placeholders / cohérence des références).
- **`E-06`** — confirmé exact : le format `DÉCISION` de `§Mémoire de sprint`
  (`01-Claude-md-TEMPLATE.md:344`) porte déjà `retenu/écarté/raison` (= le
  « quoi/pourquoi » du Ruling Superpowers) et `[valide jusqu'à]`, mais aucun champ
  `[coût si faux]` — l'élément qui manquait explicitement à `M-PROC-13`
  (`grep -c "coût si faux" 01-Claude-md-TEMPLATE.md` → `0`).
- **`E-07`** — **partiellement inexact**, corrigé avant rédaction. L'ANALYSE affirme
  que « la ligne d'identité » manque au ledger. Faux à moitié : `§Démarrage 4b`
  (`01-Claude-md-TEMPLATE.md:156-158`) écrit déjà 2 lignes d'identité
  (`# Sprint <N> — <slug>` + `# Spec : specs/Sprints/sprint-<N>-<slug>.md`), et
  `§Démarrage` porte déjà une clause d'exception qui compare le header du fichier au
  sprint en cours (`01-Claude-md-TEMPLATE.md:197` : « si le header du fichier
  correspond au sprint spec en cours → reprise normale ») — c'est fonctionnellement
  la détection d'orphelin que `E-07` réclame. Ce qui manque réellement, et seulement
  cela : la règle de préséance explicite « ledger + `git log` > souvenir de session »
  après compaction — absente de `§Mémoire de sprint` (`grep -c "précédence"
  01-Claude-md-TEMPLATE.md` → `0`). Portée réduite en conséquence — voir §Portée.

---

## Objectif

`04-sprint-PDR-TEMPLATE.md` bannit explicitement les placeholders de plan (liste
grep-able, reprise dans l'enforcement du wrap-up) ; `01-Claude-md-TEMPLATE.md
§Analyse` porte une auto-revue du plan en 3 passes avant toute Demande d'aval ; le
format `DÉCISION` de `sprint-memory.md` porte un champ `[coût si faux]` ; la règle de
préséance ledger+git > souvenir de session est explicite dans `§Mémoire de sprint`.

---

## Comportement actuel → cible

- **Actuel :** le PDR peut contenir des placeholders de plan non détectés avant le
  commit (seuls `[À REMPLIR]`/`[ ]`/`[→ ADAPTER]` sont grep-és). Le plan n'a pas de
  passe de cohérence interne avant l'aval. Une `DÉCISION` de sprint ne documente pas
  ce qu'une erreur coûterait. Après compaction, aucune règle écrite ne dit
  explicitement de faire confiance au ledger/`git log` plutôt qu'au souvenir de
  session.
- **Cible :** les quatre manques ci-dessus sont fermés par des ajouts de quelques
  lignes chacun, dans des sections existantes, sans réécriture structurelle.

---

## Portée

**Inclus :**
- `04-sprint-PDR-TEMPLATE.md` : nouvelle `## Pas de placeholders` — liste fixe des
  motifs interdits (échecs de plan, pas de style), avec la commande grep de
  vérification citée en tête de section
- `03-wrap-up-SKILL-TEMPLATE.md` + `.claude/skills/wrap-up/SKILL.md §3` : le grep
  d'enforcement placeholders résiduels étendu aux motifs de `§Pas de placeholders`
  (même bloc, une seule commande, pas un second grep séparé)
- `01-Claude-md-TEMPLATE.md §Analyse` : nouvelle sous-section `## Auto-revue du
  plan` (3 passes + règle d'arrêt) insérée entre `§Vérification factuelle` et
  `§Demande d'aval`
- `01-Claude-md-TEMPLATE.md §Mémoire de sprint` : format `DÉCISION` +1 champ `[coût
  si faux]` ; +1 règle de précédence (« ledger + `git log` > souvenir de session »)
  après le bloc « Perte accidentelle en cours de sprint »
- Entrée `M-PROC-43` dans `07-DECISIONS-SDLC.md`

**Exclu (explicitement) :**
- `E-13(a)` — bloc Interfaces Consumes/Produces par tâche (hors scope ROADMAP,
  n'a d'intérêt qu'en taille L/multi-modules selon l'ANALYSE elle-même)
- `E-13(c)` — dimensionnement des tâches par relecteur frais (hors scope ROADMAP,
  n'a d'intérêt que si `E-12`/`P-21` est un jour adopté)
- Réécrire la ligne d'identité de `sprint-memory.md` ou la logique de détection
  d'orphelin en `§Démarrage` — déjà fonctionnellement présentes, voir §Contexte
- `Claude.md` (ce repo) — cohérent avec le précédent établi (SDLC-19 : les tables de
  rationalisation ajoutées au template n'ont jamais été répercutées dans `Claude.md`
  lui-même ; `Claude.md` ne reçoit un changement de `01-Claude-md-TEMPLATE.md` que
  quand il s'agit d'une nouvelle **règle absolue** opérative — ce n'est pas le cas
  ici, ces 4 items enrichissent `§Analyse`/`§Mémoire de sprint`, pas `§Règles
  absolues`)
- `08-hooks-TEMPLATE.md` (condition de `E-06` — « si le hook PreCompact horodate ce
  champ ») — vérifié : `PreCompact` n'écrit que des lignes `CHECKPOINT`, jamais de
  ligne `DÉCISION` ; la condition ne s'applique pas

---

## Option retenue — alternatives écartées

**Retenue :** quatre ajouts ponctuels dans des sections existantes, chacun fermant
un mode d'échec nommé par l'ANALYSE — pas de nouvelle section de gouvernance lourde.

**Écartée(s) :**
- **Importer la posture Superpowers du Ruling (trancher et continuer sans
  humain)** — écarté explicitement par `E-06` lui-même : « adopter le pôle
  Superpowers casserait la thèse du modèle » (« Claude propose, l'humain décide »).
  Seul le format (champ coût-si-faux) est importé, jamais la posture.
- **Réécrire la ligne d'identité de `sprint-memory.md`** — écarté après
  vérification factuelle : déjà présente et déjà fonctionnelle (voir §Contexte,
  `E-07`).
- **Section `## Pas de placeholders` dans `01-Claude-md-TEMPLATE.md` plutôt que
  dans `04-sprint-PDR-TEMPLATE.md`** — écarté : la liste s'applique au contenu d'un
  PDR, donc vit dans le template du PDR (source la plus proche de l'usage), avec un
  simple renvoi depuis `§Auto-revue du plan`.

**Sacrifices délibérés :** aucun — chaque ajout est autonome et ne dépend pas d'un
sprint futur pour être utile immédiatement.

---

## Contraintes techniques / produit

- Une seule commande grep dans le bloc d'enforcement du wrap-up (étendre celle qui
  existe, pas en ajouter une seconde) — cohérent avec `Claude.md §Modifications spot`
  (script `sed`/`grep` exécutable, pas de duplication de mécanisme)
- Zéro renumérotation de section existante dans les fichiers touchés
- Le champ `[coût si faux]` dans `DÉCISION` reste optionnel en formulation libre —
  pas de nouveau format structuré séparé, pour ne pas alourdir une entrée qui doit
  rester rapide à écrire en session

**Interdit :**
- Modifier `Claude.md` (ce repo) ou tout autre fichier hors §Portée
- Rendre le champ `[coût si faux]` obligatoire au sens bloquant (aucune vérification
  exécutable de sa présence n'existe pour les autres champs de `DÉCISION` non plus —
  cohérence de traitement)

---

## Dépendances

**Inputs requis** *(ce sprint assume que ces outputs existent et sont valides)* :
- [x] `specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md §E-06/§E-07/§E-13/§E-14` — présent,
      vérifié contre l'état réel du repo avant rédaction (§Contexte — `E-07` corrigé)
- [x] `docs/ROADMAP.md §Next` — item ECO-4 scopé explicitement à `E-13(b)+E-14+E-06+E-07`
- [x] Dernier ID `M-PROC` attribué — `M-PROC-42` (Sprint ECO-3), `M-PROC-43` libre

**Outputs produits** *(ce que les sprints suivants pourront utiliser)* :
- [x] `04-sprint-PDR-TEMPLATE.md §Pas de placeholders` — référençable par tout futur
      renforcement de `sdlc-validate.sh` (contrôle mécanique sur les specs commitées)
- [x] Décision `M-PROC-43` dans `07-DECISIONS-SDLC.md`

**Règle :** avant de démarrer, vérifier que tous les inputs requis cochés existent et
sont dans l'état attendu. Si un input manque ou a changé → signaler comme BLOQUANT
avant toute analyse.

---

## Critères d'acceptation

- [x] `grep -c "^## Pas de placeholders" 04-sprint-PDR-TEMPLATE.md` → `1`
- [x] `grep -A20 "^## Pas de placeholders" 04-sprint-PDR-TEMPLATE.md | grep -c "^- "`
      → `≥ 6` (liste des motifs interdits) — critère corrigé au wrap-up : `-A10`
      était trop court pour les 6 motifs répartis sur 8 lignes avec renvois à la
      ligne ; voir §Corrections ajustées vs spec
- [x] `grep -c "TBD" 03-wrap-up-SKILL-TEMPLATE.md .claude/skills/wrap-up/SKILL.md`
      → `≥ 1` dans chacun (grep d'enforcement étendu, pas un second bloc)
- [x] `grep -c "^## Pas de placeholders\|^## Auto-revue" 03-wrap-up-SKILL-TEMPLATE.md`
      → `0` (pas de nouvelle section dans le wrap-up — extension du grep existant
      seulement)
- [x] `grep -c "^## Auto-revue du plan" 01-Claude-md-TEMPLATE.md` → `1`
- [x] La section `§Auto-revue du plan` est positionnée entre `§Vérification
      factuelle` et `§Demande d'aval` : `grep -n "^## Vérification factuelle\|^##
      Auto-revue du plan\|^## Demande d'aval" 01-Claude-md-TEMPLATE.md` → 3 lignes,
      dans cet ordre
- [x] `grep -c "coût si faux" 01-Claude-md-TEMPLATE.md` → `≥ 1`
- [x] `grep -c "Précédence après compaction" 01-Claude-md-TEMPLATE.md` → `1`
- [x] `grep -c "M-PROC-43" 07-DECISIONS-SDLC.md` → `≥ 2` (tableau de compatibilité +
      entrée détaillée)
- [x] `grep -A12 "^## M-PROC-43" 07-DECISIONS-SDLC.md | grep -c "Retenu"` → `1` —
      critère corrigé au wrap-up : `-A3` était trop court, le bloc `**Contexte :**`
      fait 9 lignes avant `**Retenu :**` ; voir §Corrections ajustées vs spec
- [x] `bash sdlc-validate.sh` → `8/8 ✅`, exit 0 — non-régression (C2 sur les 2
      templates dont la version est bumpée, C4 sur la paire wrap-up)
- [x] Tests niveau A : `bash sdlc-validate.sh ; echo "exit=$?"` → `0`
- [x] CHANGELOG mis à jour, ligne `**Tests**` porte le résultat réel de
      `sdlc-validate.sh`

<!-- Guidance goal-backward : chaque critère est un état observable produit par une
     commande, jamais "la section est écrite" ou "la règle est ajoutée". -->

---

## Risques

- **Le champ `[coût si faux]` de `DÉCISION` reste théorique tant qu'aucun sprint ne
  l'utilise réellement** : *faible* · c'est un format, pas un mécanisme vérifié
  exécutable — même statut que `[CONF: HAUTE/MOY/FAIBLE]` déjà en place, cohérent
  avec `Claude.md §Contraintes` (pas de champ rendu obligatoire au sens bloquant)
- **Le grep étendu de `§Pas de placeholders` produit des faux positifs sur des mots
  légitimes du français courant** (ex : « cas limites » dans une phrase normale, pas
  un placeholder) : *moyen* · les motifs retenus sont des expressions figées assez
  spécifiques (« cas limites appropriés », pas « cas limites » seul) pour limiter le
  risque — **confirmé au wrap-up** : le grep remonte 5 lignes sur cette spec
  elle-même (§Contexte, §Comportement actuel→cible, un critère d'acceptation citant
  `TBD` dans sa propre commande, §Risques) — toutes des citations méta de la
  convention qu'elle instaure, pas des placeholders de plan non traités. Vérifié
  manuellement ligne par ligne, aucune correction nécessaire. Limite acceptée : un
  PDR qui documente la convention se cite lui-même et déclenchera toujours ce grep
  — cas rare (ce sprint est probablement le seul), pas un défaut du mécanisme sur
  les specs ordinaires qu'il vise réellement.

---

## Handoff Claude Code

**Fichiers — chargement immédiat :**
- `specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md §E-06, §E-07, §E-13, §E-14` (déjà lus
  pour rédiger ce PDR, y compris la vérification factuelle qui corrige `E-07`)
- `04-sprint-PDR-TEMPLATE.md` (déjà lu, 216 lignes)
- `01-Claude-md-TEMPLATE.md` (déjà lu, 462 lignes)
- `03-wrap-up-SKILL-TEMPLATE.md §3`, `.claude/skills/wrap-up/SKILL.md §3` (déjà lus,
  confirmés identiques sur le bloc d'enforcement)

**Fichiers — chargement différé :**
- `07-DECISIONS-SDLC.md` — grep `^## M-PROC-` pour confirmer le prochain ID, lecture
  ciblée du format `M-PROC-42` (gabarit à répliquer) uniquement pour rédiger `M-PROC-43`

**Données à collecter avant de coder :**
- Déjà collectées lors de la vérification factuelle (§Contexte) : `E-07` corrigé,
  absence des 4 mécanismes confirmée par grep, dernier `M-PROC` confirmé

**Init mémoire sprint :**
```bash
echo "# Sprint ECO-4 — durcissement-pdr · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-ECO-4-durcissement-pdr.md" >> .claude/sprint-memory.md
```

---

## Plan de développement
*(produit par Claude Code après analyse — à compléter en étape 4d, avant tout code)*

**Dépendances vérifiées :**
- [x] `E-07` recoupé contre l'état réel — ligne d'identité + détection d'orphelin
      déjà présentes, portée réduite à la seule règle de précédence
- [x] Absence des 4 mécanismes confirmée par grep (§Contexte)
- [x] `.claude/skills/wrap-up/SKILL.md` confirmé identique au template sur le bloc
      d'enforcement §3 (même ligne grep, à étendre en miroir)

**Modules touchés :** cf. §Surface

**Risques identifiés :** cf. §Risques

**Plan d'exécution :**
1. `04-sprint-PDR-TEMPLATE.md` : insérer `## Pas de placeholders` entre le bloc
   `§Critères d'acceptation` (guidance goal-backward) et `## Signaux de dégradation`
   · bump v2.1 → v2.2
2. `03-wrap-up-SKILL-TEMPLATE.md §3` + `.claude/skills/wrap-up/SKILL.md §3` : étendre
   la ligne grep d'enforcement placeholders résiduels aux motifs de l'étape 1 · bump
   template v1.7 → v1.8
3. `01-Claude-md-TEMPLATE.md §Analyse` : insérer `## Auto-revue du plan` entre
   `§Vérification factuelle` et `§Demande d'aval`
4. `01-Claude-md-TEMPLATE.md §Mémoire de sprint` : ajouter `[coût si faux]` au format
   `DÉCISION` ; ajouter la règle de précédence après le bloc « Perte accidentelle » ·
   bump v2.2 → v2.3
5. `M-PROC-43` dans `07-DECISIONS-SDLC.md` (entrée détaillée + ligne tableau de
   compatibilité)
6. `bash sdlc-validate.sh` → 8/8 attendu (non-régression)
7. CHANGELOG + README (`§Historique des versions`, `Version courante`) + wrap-up

**Plan de test :**
- A — Ciblé : `bash sdlc-validate.sh ; echo "exit=$?"`
- B — Non-régression : aucun mécanisme exécutable modifié en dehors du grep étendu
  (test A) — C2 (en-tête de version, 2 templates bumpés) et C4 (parité wrap-up)
  couvrent la surface réelle

---

## Corrections ajustées vs spec
*(complété au wrap-up — §Étape 3)*

**Corrections ajustées vs spec :**
- Deux critères d'acceptation avaient une fenêtre `grep -A` trop courte pour capturer
  le contenu réel (même défaut que rencontré au wrap-up ECO-3, `-A40` au lieu de
  `-A50`) : `-A10` → `-A20` pour `§Pas de placeholders` (6 motifs répartis sur 8
  lignes avec renvois à la ligne, pas 10) ; `-A3` → `-A12` pour `M-PROC-43` (le bloc
  `**Contexte :**` de vérification factuelle fait 9 lignes avant `**Retenu :**`).
  Contenu déjà correct dans les deux cas, seule la commande de vérification était
  mal calibrée — corrigée en cours d'exécution, avant le commit.
- **Ajout hors §Portée initial, sur aval explicite** : `.claude/hooks/pre-tool-bash.sh`
  — carve-out `M-HOOKS-04` élargi à `.claude/sprint-memory.md` lui-même. Ce fichier
  n'était pas dans la §Portée du PDR (vérification factuelle initiale n'avait pas
  couvert `docs/LESSONS_LEARNED.md`, seulement `ANALYSE-SKILLS-ECOSYSTEM.md` et
  `docs/ROADMAP.md`). Repéré en préparant l'Étape 2 du wrap-up :
  `docs/LESSONS_LEARNED.md LL-T07` portait un déclencheur de réouverture nommant
  explicitement ce sprint (« à défaut lors d'ECO-4 ... trancher dans ce sprint plutôt
  que d'ouvrir un item séparé »), manqué à la rédaction du PDR. Traité sur validation
  explicite de l'utilisateur (option « corriger maintenant, hors PDR ») plutôt que
  différé une 3e fois. Détail : `07-DECISIONS-SDLC.md M-HOOKS-04 → Mise à jour
  03/09/2026`, `CHANGELOG.md`.
  - Fichiers à relire dans Claude.ai : `08-hooks-TEMPLATE.md` (référence M-HOOKS-04,
    non touchée — pas de logique de script embarquée à synchroniser)
- **Risque confirmé, sans action corrective** : le grep d'enforcement `§Pas de
  placeholders` (Étape 3 du wrap-up) remonte 5 lignes sur cette spec elle-même —
  vérifié une par une, toutes des citations méta de la convention (voir §Risques),
  aucun vrai placeholder. Documenté dans `docs/DIAGNOSTIC_CMDS.md`.
