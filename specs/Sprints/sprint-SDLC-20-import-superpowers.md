# Sprint SDLC-20 — Doc : import sélectif audit Superpowers
<!-- Numéro assigné en §Démarrage (4a) : PDR reçu avec XX non assigné volontairement.
     Dernier sprint constaté : SDLC-19 (clos, commit ce47424) → assigné SDLC-20.
     Ce PDR est la 3e révision d'une même intention de sprint :
     1e passage (exécuté, SDLC-19) → contenu complet, 2 paires par HALT, sans étiquette.
     2e passage (rédigé, jamais exécuté, mis en pause par l'utilisateur) → squelette vide,
       citant INV-4 à tort (cf. note ci-dessous) — fichier abandonné, jamais committé.
     3e passage (ce PDR) → ni l'un ni l'autre : paires conservées, étiquetées
       `[HYPOTHÈSE — non confirmée, adaptée de Superpowers]`. -->
<!-- RÉVISÉ 2x : 1e revue critique → squelette vide (citant INV-4, à tort — INV-4 garantit qu'une
     observation a un chemin vers une règle, n'interdit pas qu'une règle naisse d'un apport externe).
     2e revue (contre-argument) → squelette retiré : les paires restent, étiquetées
     [HYPOTHÈSE — non confirmée, adaptée de Superpowers] plutôt que vidées. Seule la table
     4a/4b/4c/4d (incident M-HOOKS-04 réel) est pleinement sourcée sans étiquette. -->

**Type :** Doc
**Taille :** S
**Surface :** `01-Claude-md-TEMPLATE.md` (§Règles absolues/HALT, §Test, §Tokens) +
`02-STANDARDS-TEMPLATE.md` (§Types de sprint)
**Risque :** Faible

---

## Contexte

Suite à l'audit externe Superpowers (Sprint SDLC-17, `doc/AUDIT-EXTERNE-superpowers-vs-sdlc.md`)
et à la revue critique qui a suivi : 4 des 6 recommandations ont été validées pour import direct,
recalibrées par rapport à leur formulation d'origine dans l'audit. Ce sprint les implémente
groupées (même nature — Doc, même fichiers en grande partie) :

- **SDLC_CANDIDATE #2** (tables de rationalisation) — **recalibré une 3e fois** : ni contenu
  silencieusement présenté comme équivalent à du vécu, ni squelette vide (qui laisserait 4/5 HALT
  sans aucune garde le temps qu'un incident survienne, potentiellement jamais pour certains comme
  HALT-TIMEOUT). Retenu : 1-2 paires par HALT, étiquetées `[HYPOTHÈSE — non confirmée, adaptée de
  Superpowers]`, mises à jour vers une source réelle (`M-XXX`) si un incident vient un jour les
  confirmer ou les corriger
- **SDLC_CANDIDATE #3** (anti-complaisance) — recalibré à la baisse : 2 des 4 formulations
  proposées existent déjà (dispersées entre §Rôle et §Test), le delta réel est plus petit
- **IDÉE NOUVELLE** (sélection de modèle par sous-agent) — confirmé faisable (`Task` a un
  paramètre `model` natif), prêt à écrire
- **Taxonomie "Revue"** — ferme l'écart entre `Claude.md §Classifier le travail` (qui utilise
  déjà "Revue") et `02-STANDARDS-TEMPLATE.md §Types de sprint` (qui ne l'a jamais eu)

**Explicitement hors de ce sprint** (renvoyés en `ROADMAP.md`, voir §Portée) : SDLC_CANDIDATE #1
(hook SessionStart), REMPLACER (revue mi-parcours), `10-audit-externe-TEMPLATE.md`.

**État réel constaté avant exécution (diffère du PDR reçu, écrit en partant d'un état
greenfield) :** Sprint SDLC-19 a déjà exécuté ce PDR dans sa version d'origine (contenu complet,
sans étiquette) et a été clos avec succès (commit `ce47424`, rétrospective "all good"). Les 3
items SDLC_CANDIDATE #3, IDÉE NOUVELLE et Taxonomie "Revue" sont donc **déjà livrés et
conformes** — vérifié par grep (`§Rôle`/`§Test` croisés présents, "ça a l'air bon" présent,
règle de sélection de modèle présente lignes 216-219, ligne "Revue" présente dans
`02-STANDARDS-TEMPLATE.md`). Le delta réel de ce sprint se limite à **SDLC_CANDIDATE #2** :
ajouter l'étiquette `[HYPOTHÈSE — non confirmée, adaptée de Superpowers]` devant chacune des 5
tables HALT existantes (2 paires chacune, déjà dans la fourchette "1-2" autorisée — pas de
réécriture du contenu des paires) + amender `M-PROC-31` en conséquence.

---

## Objectif

`01-Claude-md-TEMPLATE.md` porte 1-2 paires "pensée → réalité" par HALT (5), étiquetées
`[HYPOTHÈSE — non confirmée, adaptée de Superpowers]`, plus une table complète et sans étiquette
sur la règle absolue "4a/4b/4c/4d", sourcée sur l'incident réel M-HOOKS-04 ; la clause
anti-complaisance et la règle de citabilité sont reliées par renvoi croisé sans duplication ;
`§Tokens` porte une règle de sélection de modèle pour les sous-agents délégués ;
`02-STANDARDS-TEMPLATE.md` reconnaît "Revue" comme type de sprint à part entière.

---

## Comportement actuel → cible

- **Actuel :** chaque HALT porte déjà 2 paires "pensée → réalité" (Sprint SDLC-19), sans
  étiquette de provenance. §Test/§Rôle/§Tokens/STANDARDS déjà conformes à la cible (SDLC-19).
- **Cible :** chaque HALT a ses 2 paires existantes précédées d'une étiquette unique
  `[HYPOTHÈSE — non confirmée, adaptée de Superpowers]` — sauf la règle "4a/4b/4c/4d" qui reste
  une table complète et sans étiquette, sourcée sur l'incident M-HOOKS-04 réel. Aucun autre
  changement (déjà conforme).

---

## Portée

**Inclus :**
- 5 étiquettes `[HYPOTHÈSE — non confirmée sur ce projet, adaptée de Superpowers]`, une par
  table HALT, insérées avant les paires existantes (pas de réécriture du contenu des paires —
  2 par HALT, déjà dans la fourchette 1-2 autorisée)
- Amendement de `M-PROC-31` (`07-DECISIONS-SDLC.md`) documentant l'aller-retour complet
  (contenu sans étiquette → squelette envisagé et abandonné → étiquette retenue) + nouvelle
  entrée `M-PROC-35`
- `CHANGELOG.md` — nouvelle entrée

**Déjà conforme, aucune action requise (vérifié par grep avant §Plan de développement) :**
- §Test ("ça a l'air bon" + renvoi croisé), §Rôle (renvoi croisé), §Tokens (sélection de
  modèle sous-agent), `02-STANDARDS-TEMPLATE.md` (ligne "Revue"), `doc/ROADMAP.md` (P-20/21/22)
  — tous livrés par SDLC-19, aucune divergence avec la cible de ce PDR

**Exclu (explicitement) :**
- SDLC_CANDIDATE #1 (hook SessionStart) → déjà en `ROADMAP.md §Next` (P-20) depuis SDLC-19,
  aucun changement requis
- REMPLACER (revue mi-parcours sous-agent) → déjà en `ROADMAP.md §Later` (P-21)
- `10-audit-externe-TEMPLATE.md` → déjà en `ROADMAP.md §Later` (P-22)
- Toute modification de `08-hooks-TEMPLATE.md` — sprint Fix séparé, fichier différent
- Réécriture du contenu des paires existantes — seule l'étiquette est ajoutée

---

## Option retenue — alternatives écartées

**Retenue (après 3e revue critique) :** garder les paires "pensée → réalité" pour les 5 HALT
(2 chacune, déjà existantes depuis SDLC-19), étiquetées `[HYPOTHÈSE — non confirmée sur ce
projet, adaptée de Superpowers]` — ni squelette vide, ni contenu présenté comme équivalent à du
vécu. L'étiquette se retire et se remplace par une référence `M-XXX` si un incident réel vient
confirmer ou corriger une paire.

**Écartée(s) :**
- *Squelette vide (2e révision de ce PDR, rédigée mais jamais committée)* — écarté : citait
  INV-4 à tort (INV-4 garantit qu'une observation a un chemin vers une règle, n'interdit pas
  qu'une règle naisse d'un apport externe — incohérent avec le fait que le bloc HALT lui-même
  vient de BMad sans incident préalable, Sprint SDLC-07). Coût réel sous-estimé : 4/5 HALT sans
  aucune garde le temps qu'un incident survienne, possiblement jamais pour certains (HALT-TIMEOUT)
- *Contenu complet sans étiquette, comme une règle ordinaire (1e révision, SDLC-19 telle qu'exécutée)*
  — recalibré : risque de donner une fausse impression de couverture — du contenu générique
  adapté de Superpowers, jamais confronté à la réalité de ce projet, présenté avec la même
  autorité qu'une règle sourcée sur incident
- *Traduction littérale des exemples Superpowers (TDD, debugging)* — écarté : jargon spécifique
  au code qui se propagerait vers des projets doc-only via `/sdlc-sync`, perdant sa pertinence
- *Une table de rationalisation unique pour tous les HALT* — écarté : chaque HALT a un mode de
  contournement distinct ; une table générique perdrait la spécificité qui fait la valeur du
  pattern

**Sacrifices délibérés :** pas de remaniement du bloc HALT lui-même (texte des 5 conditions) ni
du contenu des paires existantes — uniquement ajout de l'étiquette en tête de chaque table.
L'étiquette `[HYPOTHÈSE]` reste tant qu'aucun incident ne la confirme — assumé comme un état
normal et potentiellement durable pour certains HALT, pas une tâche en attente de complétion.

---

## Contraintes techniques / produit

- Format de l'étiquette : une ligne unique, identique sur les 5 tables, immédiatement après le
  sous-titre `*HALT-XXX*` et avant la première paire : `*[HYPOTHÈSE — non confirmée sur ce
  projet, adaptée de Superpowers]*`
- Aucune modification du texte des paires existantes (contenu déjà rédigé en langage gouvernance
  générique depuis SDLC-19)
- Toute correction par script `sed`/patch exécutable avec grep de validation finale
- Ne pas toucher §Rôle/§Test/§Tokens/STANDARDS — déjà conformes

**Interdit :**
- Modifier le texte des 5 conditions HALT elles-mêmes ou de la liste "Ne jamais"
- Modifier le contenu des paires "Pensée/Réalité" existantes — seule l'étiquette est ajoutée
- Toucher `08-hooks-TEMPLATE.md`, §Rôle, §Test, §Tokens, `02-STANDARDS-TEMPLATE.md`
- Réécrire `M-PROC-31` en place sans laisser de trace de l'aller-retour — amendement explicite
  requis

---

## Dépendances

**Inputs requis :**
- [x] `01-Claude-md-TEMPLATE.md` état courant — 5 tables HALT confirmées, 2 paires chacune
      (lignes 44-85), table 4a/4b/4c/4d confirmée (lignes 20-25)
- [x] `02-STANDARDS-TEMPLATE.md` — ligne "Revue" confirmée présente (ligne 35)
- [x] Entrée `07-DECISIONS-SDLC.md` `M-PROC-31` accessible (ligne 1282) et `M-HOOKS-04`
      accessible (ligne 1109)
- [x] `00-CONTEXT.md` — définition `INV-4` accessible (ligne 95), utile pour documenter
      pourquoi l'argument du 2e passage était erroné

**Outputs produits :**
- [x] `01-Claude-md-TEMPLATE.md` mis à jour (5 étiquettes ajoutées)
- [x] `07-DECISIONS-SDLC.md` — amendement `M-PROC-31` + nouvelle entrée `M-PROC-35`
- [x] `CHANGELOG.md`

---

## Critères d'acceptation

- [x] 5 étiquettes `[HYPOTHÈSE — non confirmée sur ce projet, adaptée de Superpowers]` présentes,
      une par table HALT, contenu des paires inchangé — `grep -c` → 5
- [x] Table 4a/4b/4c/4d inchangée, toujours sans étiquette (vérifiée par diff)
- [x] `M-PROC-31` amendée avec renvoi explicite vers `M-PROC-35`
- [x] `M-PROC-35` documente l'aller-retour complet (3 passages) avec alternatives écartées
- [x] CHANGELOG mis à jour
- [x] §Rôle/§Test/§Tokens/`02-STANDARDS-TEMPLATE.md`/`doc/ROADMAP.md` : zéro diff (déjà
      conformes depuis SDLC-19) — confirmé par `git diff --stat`

```bash
# Test A — structure
grep -c "\[HYPOTHÈSE — non confirmée" 01-Claude-md-TEMPLATE.md
# → 5 attendu (un par HALT, pas sur la table 4a/4b/4c/4d)

grep -c "Pensée :" 01-Claude-md-TEMPLATE.md
# → 11 attendu (5 HALT × 2 paires inchangées + 1 paire table 4a/4b/4c/4d)

# Test B — non-régression : tout le reste du fichier inchangé
git diff --stat 01-Claude-md-TEMPLATE.md
# → uniquement des lignes ajoutées (+5), zéro ligne supprimée hors des 5 points d'insertion

git diff --stat 02-STANDARDS-TEMPLATE.md
# → absent du diff (0 changement)

git diff 01-Claude-md-TEMPLATE.md | grep -A3 "M-HOOKS-04"
# → aucune ligne supprimée dans le bloc 4a/4b/4c/4d
```

---

## Risques

- **Fausse impression de couverture malgré l'étiquette** : un lecteur pressé peut survoler le
  tag `[HYPOTHÈSE]` et traiter le contenu comme une règle confirmée · mitigation : étiquette en
  tête de chaque table (pas en fin, pas en footnote discrète), formulation identique partout
- **Historique DECISIONS confus après 3 passages sur le même sujet** : probabilité moyenne ·
  mitigation : `M-PROC-35` résume explicitement les 3 passages et leurs raisons respectives,
  `M-PROC-31` renvoie vers elle plutôt que d'être réécrite

---

## Handoff Claude Code

**Fichiers — chargement immédiat :**
- `01-Claude-md-TEMPLATE.md` (lignes 12-90, §Règles absolues/HALT — déjà chargé)
- `07-DECISIONS-SDLC.md` (entrées `M-HOOKS-04` ligne 1109, `M-PROC-31` ligne 1282 — déjà chargées)
- `00-CONTEXT.md` (définition `INV-4`, ligne 95 — déjà chargée)

**Fichiers — chargement différé :** aucun.

**Instructions spécifiques :**
- Ne toucher ni au texte des paires existantes ni aux sections déjà conformes (§Rôle/§Test/
  §Tokens/STANDARDS/ROADMAP) — seule l'étiquette est ajoutée
- Amender `M-PROC-31` plutôt que la réécrire silencieusement

**Init mémoire sprint :** déjà fait (4b) — `.claude/sprint-memory.md` réutilisé, slug mis à jour.

---

## Plan de développement
*(produit par Claude Code après analyse — étape 4d, avant toute écriture du livrable)*

**Dépendances vérifiées :**
- [x] `01-Claude-md-TEMPLATE.md` — 5 tables HALT à 2 paires chacune confirmées (grep, lignes 44-85)
- [x] `M-PROC-31` — accessible, ligne 1282 de `07-DECISIONS-SDLC.md`
- [x] `M-HOOKS-04` — accessible, ligne 1109
- [x] `INV-4` — accessible, ligne 95 de `00-CONTEXT.md`
- [x] §Test/§Rôle/§Tokens/STANDARDS/ROADMAP — déjà conformes, zéro action requise (grep négatif
      sur toute divergence)

**Modules touchés :** `01-Claude-md-TEMPLATE.md` (fichier de gouvernance propagé à tout projet
via `/sdlc-sync`, niveau B implicite), `07-DECISIONS-SDLC.md`.

**Risques identifiés :** cf. §Risques ci-dessus.

**Plan d'exécution :**
1. `01-Claude-md-TEMPLATE.md` : insérer les 5 étiquettes (sed, une ligne après chaque sous-titre
   `*HALT-XXX*`)
2. `07-DECISIONS-SDLC.md` : amender `M-PROC-31` (renvoi vers `M-PROC-35`) + ajouter `M-PROC-35`
3. `CHANGELOG.md` : nouvelle entrée `[v1.9+SDLC-20]`

**Plan de test :**
- A — Ciblé : voir §Critères d'acceptation
- B — Non-régression : `git diff --stat` confirme uniquement +5 lignes sur
  `01-Claude-md-TEMPLATE.md`, zéro diff sur `02-STANDARDS-TEMPLATE.md`, table 4a/4b/4c/4d intacte

---

## Corrections ajustées vs spec
*(complété au wrap-up — §Étape 3)*

Aucune correction ajustée — exécution conforme au plan d'exécution écrit en §Plan de
développement (étapes 1-3 réalisées dans l'ordre, tests A/B passés tels que spécifiés).

Incident de session hors périmètre de la spec (documenté séparément, sans impact sur le
livrable) : le garde-fou `M-HOOKS-04` a bloqué la correction de `.claude/sprint-memory.md`
après le renommage du fichier spec (`halt-squelettes` → `import-superpowers`, décidé avant
l'écriture de cette version finale). Contournement non destructif appliqué — voir
`doc/DIAGNOSTIC_CMDS.md` et `doc/LESSONS_LEARNED.md LL-T07`.
