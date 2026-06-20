# Sprint SDLC-19 — Doc : import sélectif audit Superpowers
<!-- Numéro assigné en §Démarrage (4a) : PDR reçu avec XX non assigné volontairement.
     Dernier sprint constaté : SDLC-18 → assigné SDLC-19. -->

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

- **SDLC_CANDIDATE #2** (tables de rationalisation) — recalibré : sourcé sur nos propres
  incidents documentés quand ils existent (M-HOOKS-04), en langage gouvernance générique plutôt
  que traduit du jargon TDD/debugging de Superpowers
- **SDLC_CANDIDATE #3** (anti-complaisance) — recalibré à la baisse : 2 des 4 formulations
  proposées existent déjà (dispersées entre §Rôle et §Test), le delta réel est plus petit
- **IDÉE NOUVELLE** (sélection de modèle par sous-agent) — confirmé faisable (`Task` a un
  paramètre `model` natif), prêt à écrire
- **Taxonomie "Revue"** — ferme l'écart entre `Claude.md §Classifier le travail` (qui utilise
  déjà "Revue") et `02-STANDARDS-TEMPLATE.md §Types de sprint` (qui ne l'a jamais eu)

**Explicitement hors de ce sprint** (renvoyés en `ROADMAP.md`, voir §Portée) : SDLC_CANDIDATE #1
(hook SessionStart), REMPLACER (revue mi-parcours), `10-audit-externe-TEMPLATE.md`.

---

## Objectif

`01-Claude-md-TEMPLATE.md` porte une table de rationalisation par HALT (5) sourcée en langage
gouvernance générique, plus une enrichie sur l'incident réel M-HOOKS-04 ; la clause
anti-complaisance et la règle de citabilité sont reliées par renvoi croisé sans duplication ;
`§Tokens` porte une règle de sélection de modèle pour les sous-agents délégués ;
`02-STANDARDS-TEMPLATE.md` reconnaît "Revue" comme type de sprint à part entière.

---

## Comportement actuel → cible

- **Actuel :** les règles absolues et HALT sont énoncées comme conditions logiques sans
  anticiper les formulations par lesquelles un agent pourrait s'en convaincre. La liste de
  formulations interdites anti-complaisance est dispersée entre deux sections sans lien explicite.
  La délégation sous-agent ne dit rien sur le choix du modèle délégué. "Revue" est utilisé dans
  `Claude.md §Classifier le travail` mais absent de `STANDARDS §Types de sprint`.
- **Cible :** chaque HALT a 2-4 paires "pensée → réalité" écrites en langage gouvernance, pas en
  jargon code. La règle "4a/4b/4c/4d" a au moins une paire sourcée sur l'incident M-HOOKS-04 réel.
  §Test et §Rôle se renvoient explicitement l'un à l'autre. §Tokens précise le critère de choix de
  modèle pour toute délégation. La table `Types de sprint` a une ligne "Revue" différenciée de
  "Spike".

---

## Portée

**Inclus :**
- 5 tables de rationalisation (HALT-DEP, HALT-3X, HALT-ARCH, HALT-SCOPE, HALT-TIMEOUT), 2-4
  paires chacune, langage gouvernance générique (pas de vocabulaire test/code spécifique)
- 1 paire supplémentaire sous la règle absolue "4a/4b/4c/4d", sourcée sur l'incident M-HOOKS-04
  réel, avec renvoi à l'entrée `DECISIONS.md` correspondante
- §Test : ajout de "ça a l'air bon" à la liste existante + renvoi croisé vers §Rôle (et
  réciproquement)
- §Tokens : nouvelle règle de sélection de modèle sous-agent (mécanique → réduit, jugement →
  standard, jamais plus capable que la session sans aval explicite)
- `02-STANDARDS-TEMPLATE.md §Types de sprint` : nouvelle ligne "Revue" + note de différenciation
  vs "Spike"
- Entrées `07-DECISIONS-SDLC.md` correspondantes (a minima une par item ci-dessus)

**Exclu (explicitement) :**
- SDLC_CANDIDATE #1 (hook SessionStart) → `ROADMAP.md §Next`, impact reclassé Moyen (M-HOOKS-04
  couvre déjà le pire cas observé) — **note de séquencement pour quand il sera implémenté** : s'il
  réinjecte le contenu de `§Règles absolues + HALT`, il ne doit **pas** dupliquer les tables de
  rationalisation écrites dans ce sprint (déjà chargées en permanence via `Claude.md` dans Claude
  Code) — seulement les noms de règles/HALT et leur condition de déclenchement, sous peine de
  doubler inutilement le contenu injecté à chaque session
- REMPLACER (revue mi-parcours sous-agent) → `ROADMAP.md §Later`, bloqué tant que
  `code-reviewer.md` (Superpowers, non lu) n'a pas été consulté
- `10-audit-externe-TEMPLATE.md` → `ROADMAP.md §Later`, décision différée à après ce sprint
- Toute modification de `08-hooks-TEMPLATE.md` — sprint Fix séparé, fichier différent

---

## Option retenue — alternatives écartées

**Retenue :** rédaction en langage gouvernance générique, sourcée prioritairement sur nos
incidents documentés quand ils existent, adaptée (pas traduite mot à mot) depuis Superpowers pour
le reste.

**Écartée(s) :**
- *Traduction littérale des exemples Superpowers (TDD, debugging)* — écarté : jargon spécifique
  au code qui se propagerait vers des projets doc-only via `/sdlc-sync`, perdant sa pertinence
  (cf. discussion précédente sur la portée méta-repo vs tous projets)
- *Une table de rationalisation unique pour tous les HALT* — écarté : chaque HALT a un mode de
  contournement distinct ; une table générique perdrait la spécificité qui fait la valeur du
  pattern
- *Limiter aux seuls HALT illustrables par un incident réel documenté* — écarté : sous-exploite
  le candidat validé ; les 5 HALT partagent la même structure de risque latent même sans incident
  spécifique pour chacun à ce jour

**Sacrifices délibérés :** pas de remaniement du bloc HALT lui-même (texte des 5 conditions) —
uniquement ajout des tables en dessous. Aucune tentative de sourcer les 5 HALT sur des incidents
réels — un seul (4a/4b/4c/4d) en a un à ce jour, le reste reste hypothétique/adapté, ce qui est
assumé et non présenté comme autre chose.

---

## Contraintes techniques / produit

- Format imposé par paire : `**Pensée :** "…" → **Réalité :** …` (cohérent avec le ton du
  modèle, pas de markdown imbriqué complexe)
- Langage gouvernance, zéro vocabulaire spécifique à un langage de programmation ou framework de
  test (ce template est copié dans des projets doc-only comme dans des projets code)
- Toute correction par script `sed`/patch exécutable avec grep de validation finale
- Le renvoi croisé §Test ↔ §Rôle doit être une phrase courte (pas une duplication du contenu de
  l'autre section)

**Interdit :**
- Modifier le texte des 5 conditions HALT elles-mêmes ou de la liste "Ne jamais" — seulement
  ajouter en dessous
- Toucher `08-hooks-TEMPLATE.md` (sprint séparé)
- Dupliquer le contenu entre §Test et §Rôle au lieu de les relier par renvoi

---

## Dépendances

**Inputs requis :**
- [x] `doc/AUDIT-EXTERNE-superpowers-vs-sdlc.md` accessible — résultat : oui, présent
- [x] Entrée `07-DECISIONS-SDLC.md` M-HOOKS-04 accessible — résultat : oui, présent (Sprint SDLC-18)
- [x] `01-Claude-md-TEMPLATE.md` et `02-STANDARDS-TEMPLATE.md` état courant — à charger en 4c

**Outputs produits :**
- [x] `01-Claude-md-TEMPLATE.md` mis à jour
- [x] `02-STANDARDS-TEMPLATE.md` mis à jour
- [x] `07-DECISIONS-SDLC.md` — nouvelles entrées
- [x] `ROADMAP.md` — entrées §Next/§Later pour les items exclus
- [x] `CHANGELOG.md`

---

## Critères d'acceptation

- [x] 5 tables HALT-DEP/3X/ARCH/SCOPE/TIMEOUT présentes, 2-4 paires chacune, zéro jargon
      code/test spécifique
- [x] Règle absolue "4a/4b/4c/4d" enrichie d'≥1 paire sourcée sur M-HOOKS-04, avec renvoi explicite
- [x] §Test : "ça a l'air bon" ajouté, renvoi croisé vers §Rôle présent
- [x] §Rôle : renvoi croisé vers §Test présent
- [x] §Tokens : règle de sélection de modèle sous-agent présente et bornée (3 cas : mécanique,
      jugement, jamais plus capable sans aval)
- [x] `02-STANDARDS-TEMPLATE.md` : ligne "Revue" + note de différenciation vs "Spike"
- [x] ≥ 4 nouvelles entrées dans `07-DECISIONS-SDLC.md`, chacune avec alternatives écartées
- [x] `ROADMAP.md` : SDLC_CANDIDATE #1 en §Next (impact Moyen, note de non-duplication des
      tables), REMPLACER et `10-audit-externe-TEMPLATE.md` en §Later
- [x] CHANGELOG mis à jour

```bash
# Test A — structure
grep -c "Pensée :" 01-Claude-md-TEMPLATE.md
# → ≥ 11 attendu (5 HALT × ≥2 paires + 1 paire règle absolue)

grep -c "ça a l'air bon" 01-Claude-md-TEMPLATE.md
# → 1 attendu

grep -c "§Rôle\|§Test" 01-Claude-md-TEMPLATE.md
# → ≥ 2 attendu (renvois croisés dans les deux sens)

grep -c "Revue" 02-STANDARDS-TEMPLATE.md
# → ≥ 1 nouvelle occurrence dans le tableau Types de sprint

# Test A — non-régression : les 5 HALT et la liste "Ne jamais" existants restent inchangés
grep -E "HALT-DEP|HALT-3X|HALT-ARCH|HALT-SCOPE|HALT-TIMEOUT" 01-Claude-md-TEMPLATE.md | wc -l
# → 5 attendu (un par HALT, texte des conditions non dupliqué ni altéré)
```

---

## Risques

- **Inflation permanente de `Claude.md`** : ce contenu est chargé à *chaque* session (pas une
  injection optionnelle comme le futur hook SessionStart) — probabilité de gonflement progressif
  élevée si d'autres imports suivent sans discipline · mitigation : 2-4 paires par HALT maximum,
  pas une liste exhaustive ; revoir la taille totale du fichier après ce sprint avant d'envisager
  SDLC_CANDIDATE #1
- **Exemples adaptés (non sourcés sur incident réel) qui sonnent artificiels** : probabilité
  moyenne sur les 4 HALT sans incident documenté · mitigation : formuler au niveau du principe
  plutôt que d'inventer un scénario projet trop spécifique

---

## Handoff Claude Code

**Fichiers — chargement immédiat :**
- `01-Claude-md-TEMPLATE.md` (§Règles absolues/HALT, §Rôle, §Test, §Tokens)
- `02-STANDARDS-TEMPLATE.md` (§Types de sprint)
- `doc/AUDIT-EXTERNE-superpowers-vs-sdlc.md` §6 et §8 (recommandations sourcées)
- `07-DECISIONS-SDLC.md` — entrée M-HOOKS-04 (source de la paire 4a/4b/4c/4d)

**Fichiers — chargement différé :** aucun — périmètre limité à 2 fichiers de gouvernance.

**Instructions spécifiques :**
- Écrire les tables HALT en dernier, après §Test/§Rôle/§Tokens/§Types de sprint — ce sont les
  plus longues et les plus exposées au risque de jargon, autant les faire avec le reste du
  vocabulaire du fichier déjà bien en tête
- Pour chaque paire sans incident réel disponible, rester au niveau du principe générique plutôt
  que d'inventer un scénario projet trop spécifique qui sonnerait faux
- Vérifier la taille totale de `01-Claude-md-TEMPLATE.md` avant/après (`wc -l`) et la consigner
  dans `sprint-memory.md` — donnée utile pour calibrer SDLC_CANDIDATE #1 plus tard

---

## Plan de développement
*(produit par Claude Code après analyse — étape 4d, avant toute écriture du livrable)*

**Dépendances vérifiées :**
- [x] `doc/AUDIT-EXTERNE-superpowers-vs-sdlc.md` — accessible
- [x] Entrée M-HOOKS-04 — accessible

**Modules touchés :** `01-Claude-md-TEMPLATE.md`, `02-STANDARDS-TEMPLATE.md` — fichiers de
gouvernance propagés à tout projet via `/sdlc-sync`, niveau B implicite (relecture complète des
sections existantes pour éviter toute altération du texte des HALT/règles absolues).

**Risques identifiés :** cf. §Risques ci-dessus.

**Plan d'exécution :**
1. §Rôle/§Test : renvois croisés + "ça a l'air bon"
2. §Tokens : règle de sélection de modèle sous-agent
3. §Règles absolues/HALT : 1 paire 4a/4b/4c/4d (sourcée M-HOOKS-04) + 5×2 paires HALT
4. 02-STANDARDS-TEMPLATE.md : ligne Revue + note différenciation
5. 07-DECISIONS-SDLC.md : M-PROC-31→34
6. doc/ROADMAP.md : P-20 (§Next), P-21/P-22 (§Later)
7. CHANGELOG.md

**Plan de test :**
- A — Ciblé : voir §Critères d'acceptation
- B — Non-régression : texte des 5 HALT et de la liste "Ne jamais" inchangé

---

## Corrections ajustées vs spec
*(complété au wrap-up — §Étape 3)*

1. **Test B littéral du PDR retourne 10, pas 5** — `grep -E "HALT-DEP|HALT-3X|HALT-ARCH|HALT-SCOPE|HALT-TIMEOUT" | wc -l` compte aussi les 5 nouveaux sous-titres `*HALT-XXX*` des tables de rationalisation (effet de bord attendu de l'ajout demandé par ce même PDR, non anticipé par la commande littérale). Non-régression réelle vérifiée différemment : les 5 définitions originales `**HALT-XXX**` existent une seule fois chacune, texte exact intact (grep ciblé sur le texte complet de chaque condition, lignes 28/30/32/34/36) — confirmé, pas de régression.
2. **`doc/ROADMAP.md` — IDs `P-20/21/22`** plutôt qu'une référence directe "SDLC_CANDIDATE #1" : convention de numérotation déjà en place dans `ROADMAP.md` (`P-08` à `P-19` existants) — suivie pour cohérence plutôt que d'introduire un nouveau format d'identifiant.

Aucune autre divergence — portée, gabarit du livrable et critères d'acceptation exécutés tels
que reçus.
