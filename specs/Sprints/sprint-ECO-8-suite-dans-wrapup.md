# Sprint ECO-8 — Suite de tests du validateur branchée au wrap-up + C8 étendu à `tests/`

<!-- PDR conforme à 04-sprint-PDR-TEMPLATE.md v2.0 -->
<!-- Rédigé en session Claude Code le 23/09/2026 depuis le SDLC_CANDIDATE d'ECO-7 -->
<!-- (docs/LESSONS_LEARNED.md §Sprint ECO-7, points a et b ; le point c — règle de méthode -->
<!-- « état du repo avant source externe » — reste hors de ce sprint) -->

**Type :** Fix
**Taille :** S (cœur XS : 1 glob + 1 cas de test + 1 ligne de procédure · gouvernance associée : template 03 versionné, `00-CONTEXT.md`, décision, CHANGELOG — `M-PROC-28`)
**Surface :** `sdlc-validate.sh` (C8) · `tests/sdlc-validate-test.sh` · `.claude/skills/wrap-up/SKILL.md` §3.5 · `03-wrap-up-SKILL-TEMPLATE.md` §3.5 · `00-CONTEXT.md` §4
**Risque :** Faible — ajout d'un répertoire au glob de C8 et d'une commande à une procédure

---

## Contexte

ECO-7 (`437ca42`) a livré `tests/sdlc-validate-test.sh` (15/15) et noté deux trous en
`[SDLC_CANDIDATE]` (`docs/LESSONS_LEARNED.md §Sprint ECO-7`) :

- **(a) C8 ne vérifie pas `tests/*.sh`.** Son glob est `"$ROOT"/*.sh "$ROOT"/.claude/hooks/*.sh`
  (`sdlc-validate.sh`, `check_c8`). La suite de tests elle-même peut donc casser en syntaxe
  sans que le validateur le voie.
- **(b) Personne n'appelle la suite.** L'Étape 3.5 du wrap-up — skill vivant et template —
  ne lance que `bash sdlc-validate.sh` ; la checklist `00-CONTEXT.md §4` aussi. Une suite
  que rien n'appelle dérive en silence : c'est exactement le défaut qu'ECO-7 a corrigé
  pour le validateur lui-même.

État vérifié le 23/09/2026 : `bash sdlc-validate.sh` → 10/10 · `bash tests/sdlc-validate-test.sh`
→ 15/15 · `03-wrap-up-SKILL-TEMPLATE.md` v1.9 · `00-CONTEXT.md` v1.9.

---

## Comportement actuel → cible

- **Actuel :** un `tests/sdlc-validate-test.sh` syntaxiquement cassé laisse C8 vert. Le wrap-up
  se clôt sans lancer la suite.
- **Cible :** C8 couvre `tests/*.sh` et a un cas RED qui le prouve. L'Étape 3.5 (skill vivant
  **et** template, sous la même condition « présent uniquement dans le repo modèle ») et la
  checklist `00-CONTEXT.md §4` lancent `bash tests/sdlc-validate-test.sh`, dont le résultat
  entre dans la ligne `**Tests**` du CHANGELOG.

---

## Portée

**Inclus :**
- `check_c8` : `"$ROOT"/tests/*.sh` ajouté au glob · commentaire de tête mis à jour
- `tests/sdlc-validate-test.sh` : 1 cas RED « script invalide sous `tests/` → `❌ C8 ·` »
- `.claude/skills/wrap-up/SKILL.md §Étape 3.5` : `bash tests/sdlc-validate-test.sh` dans le bloc de commandes, résultat dans la ligne `**Tests**`
- `03-wrap-up-SKILL-TEMPLATE.md §Étape 3.5` : même ajout dans le paragraphe conditionnel existant (« si `sdlc-validate.sh` existe… »), version v1.9 → v2.0
- `00-CONTEXT.md §4` : ligne de checklist pour la suite · version v1.9 → v2.0
- `07-DECISIONS-SDLC.md` : sous-bloc `→ Mise à jour` sous `M-PROC-40` (pas de nouvel ID — prolongement direct de la mise à jour ECO-7)
- `CHANGELOG.md` et versions (au wrap-up)

**Exclu :**
- Toute autre modification de contrôle (C1–C7, C9, C10)
- Le point (c) du `SDLC_CANDIDATE` (règle « état du repo avant source externe ») — autre nature (procédure de revue), autre fichier (`12-audit-externe-TEMPLATE.md`)
- `docs/MODE-OPERATOIRE.html §Vérifier le modèle` — mention de la suite possible, mais livrable de lecture humaine, pas une procédure exécutée
- Rendre la suite obligatoire dans un projet cible : elle n'existe que dans le repo modèle

<!-- SPIDR — axe retenu : Rules. Deux règles indépendantes (couverture C8, appel de la suite). -->

---

## Option retenue — alternatives écartées

**Retenue :** étendre le glob de C8 + une commande à l'Étape 3.5, dans le skill vivant et le
template, sous la condition existante « repo modèle uniquement ».

**Écartée(s) :**
- **Faire lancer la suite par `sdlc-validate.sh` lui-même (C11)** — la suite lance le
  validateur : récursion à garder, et un contrôle qui exécute 15 copies de dépôt n'est plus
  « lecture seule, idempotent ». Deux commandes distinctes restent plus lisibles.
- **Modifier seulement le skill vivant** — laisse le template diverger du skill sur la
  procédure même (`M-TMPL-04`) ; C4 ne le verrait pas (titres `##` identiques).
- **Nouvel ID de décision** — la règle prolonge `M-PROC-40 → Mise à jour 23/09/2026`
  (cas RED obligatoire) ; un ID neuf éclaterait une même règle en deux entrées.

**Sacrifices délibérés :**
- Le wrap-up gagne ~0,3 s et une commande. Assumé.

---

## Contraintes techniques / produit

- Bash + POSIX, zéro dépendance.
- Le cas RED C8 injecte sous `tests/` de la **fixture** uniquement (`M-PROC-30`).
- Template et skill vivant gardent les mêmes titres `##` (C4).
- Le paragraphe du template reste conditionnel : un projet cible sans `tests/sdlc-validate-test.sh` ne bloque pas.

**Interdit :**
- Modifier un contrôle autre que C8
- Ajouter un contrôle
- Rendre l'appel de la suite bloquant dans un projet cible

---

## Dépendances

**Inputs requis :**
- [x] `bash sdlc-validate.sh` → 10/10, exit 0 — état : vérifié 23/09/2026
- [x] `bash tests/sdlc-validate-test.sh` → 15/15, exit 0 — état : vérifié 23/09/2026
- [x] Aucun sprint actif (`docs/ROADMAP.md §Now` vide) — état : vide au démarrage, ECO-8 inscrit

**Outputs produits :**
- [x] C8 couvrant `tests/*.sh`
- [x] Étape 3.5 appelant la suite (template + skill vivant)

---

## Critères d'acceptation

- [x] `bash tests/sdlc-validate-test.sh ; echo "exit=$?"` → exit 0, **16** `[PASS]` (15 + le cas C8 `tests/`)
- [x] Le nouveau cas a été vu **FAIL avant** l'extension du glob, PASS après
- [x] `bash sdlc-validate.sh ; echo "exit=$?"` → `10/10 ✅`, exit 0
- [x] `grep -c 'tests/\*\.sh' sdlc-validate.sh` → ≥ 1
- [x] `grep -c "tests/sdlc-validate-test.sh" .claude/skills/wrap-up/SKILL.md 03-wrap-up-SKILL-TEMPLATE.md 00-CONTEXT.md` → ≥ 1 pour chacun
- [x] `head -3 03-wrap-up-SKILL-TEMPLATE.md | grep -c "v2.0"` → 1 · `head -1 00-CONTEXT.md | grep -c "v2.0"` → 1
- [x] `diff <(grep '^## ' 03-wrap-up-SKILL-TEMPLATE.md) <(grep '^## ' .claude/skills/wrap-up/SKILL.md)` → vide (C4)
- [x] `grep -c "Mise à jour 24/09/2026 (Sprint ECO-8)" 07-DECISIONS-SDLC.md` → 1, sous `M-PROC-40`
- [x] `git status --porcelain` inchangé après la suite
- [x] `CHANGELOG.md` : ligne `**Tests**` avec le résultat réel des deux scripts

---

## Risques

- **Le glob `tests/*.sh` sans fichier** (repo sans `tests/`) : le motif reste littéral —
  déjà géré par `[ -f "$f" ] || continue` dans la boucle. *Faible.*
- **Le template 03 est copié dans les projets cibles** : la phrase ajoutée doit rester sous
  la condition « repo modèle uniquement », sinon un projet cible chercherait une suite
  inexistante. *Faible, vérifié à la lecture.*

---
<!-- FIN PRD -->

## Handoff Claude Code

**Fichiers — chargement immédiat :**
- `sdlc-validate.sh` §`check_c8` · `tests/sdlc-validate-test.sh` (cas C8 existant)
- `.claude/skills/wrap-up/SKILL.md` §Étape 3.5 · `03-wrap-up-SKILL-TEMPLATE.md` §Étape 3.5
- `00-CONTEXT.md` §4

**Fichiers — chargement différé :**
- `07-DECISIONS-SDLC.md` — grep `M-PROC-40` et son bloc ECO-7 uniquement

**Grep de vérification préalable :**
```bash
bash sdlc-validate.sh | tail -2 ; bash tests/sdlc-validate-test.sh | tail -2
grep -n 'for f in "$ROOT"' sdlc-validate.sh
grep -n "sdlc-validate" .claude/skills/wrap-up/SKILL.md 03-wrap-up-SKILL-TEMPLATE.md 00-CONTEXT.md
```

---

## Plan de développement
*(produit par Claude Code — étape 4d, 23/09/2026)*

**Dépendances vérifiées :** les 3 inputs ci-dessus, cochés.

**Localisations (grep) :**
- Glob de C8 : `sdlc-validate.sh:320` — `for f in "$ROOT"/*.sh "$ROOT"/.claude/hooks/*.sh`
- Cas C8 existant : `tests/sdlc-validate-test.sh:86-90` (`zz-broken.sh` à la racine)
- Étape 3.5 : `.claude/skills/wrap-up/SKILL.md:300` (bloc de commandes) · `03-wrap-up-SKILL-TEMPLATE.md:301` (paragraphe conditionnel)
- Checklist : `00-CONTEXT.md:121`

**Modules touchés :** les 5 fichiers de §Surface + `07-DECISIONS-SDLC.md` (sous-bloc).

**Risques identifiés :** le grep préalable du §Handoff (`grep -n 'for f in "$ROOT"'`) ne renvoie rien — `$` interprété par le regex ; `grep -F` nécessaire. Sans effet sur le code, à consigner en §Corrections.

**Plan d'exécution :**
1. Cas RED C8 `tests/` dans la suite (`tests/zz-broken.sh` dans la fixture) → le voir **FAIL** (C8 vert, glob aveugle).
2. Ajouter `"$ROOT"/tests/*.sh` au glob de `check_c8` + commentaire → cas PASS, suite 16/16, validateur 10/10.
3. Skill vivant §3.5 : `bash tests/sdlc-validate-test.sh   # suite de tests du validateur` dans le bloc ; phrase « Son résultat » étendue aux deux scripts.
4. Template §3.5 : même ajout dans le paragraphe conditionnel ; en-tête v1.9 → v2.0.
5. `00-CONTEXT.md §4` : ligne `bash tests/sdlc-validate-test.sh` → tous `[PASS]` ; H1 v1.9 → v2.0.
6. `07-DECISIONS-SDLC.md` : `→ Mise à jour 23/09/2026 (Sprint ECO-8)` sous `M-PROC-40`.
7. Critères d'acceptation.

**Plan de test :**
- A — Ciblé : `bash tests/sdlc-validate-test.sh ; echo "exit=$?"` → 16/16
- B — Non-régression : `bash sdlc-validate.sh ; echo "exit=$?"` → 10/10 (C2 versions, C4 parité template ↔ skill)

---

## Corrections ajustées vs spec
*(complété au wrap-up — §Étape 3)*

- **Grep préalable du §Handoff** — `grep -n 'for f in "$ROOT"' sdlc-validate.sh` ne renvoie rien (`$` interprété en regex) : écrit sans être exécuté. Remplacé en session par `grep -nF` (`LL-T12`, 3ᵉ occurrence).
- **Date de la mise à jour `M-PROC-40`** — 24/09/2026 (clôture), pas 23/09 (rédaction) ; critère d'acceptation ajusté en conséquence.
