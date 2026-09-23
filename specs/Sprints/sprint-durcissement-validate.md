# Sprint — Durcissement de `sdlc-validate.sh`

<!-- PDR conforme à 04-sprint-PDR-TEMPLATE.md v2.0 -->
<!-- Numéro de sprint et ID de décision à attribuer À L'EXÉCUTION, pas ici : le contrôle C7 -->
<!-- du validateur existe pour attraper exactement la double attribution qu'une attribution -->
<!-- à la rédaction provoquerait. Renommer ce fichier au moment de l'attribution. -->

**Type :** Fix
**Taille :** S
**Surface :** `sdlc-validate.sh` (C3 + en-têtes + messages) · `tests/sdlc-validate-test.sh` (nouveau) · `CHANGELOG.md`
**Risque :** Faible — le validateur est vert (10/10), aucun fichier de gouvernance n'est touché

---

## Contexte

`sdlc-validate.sh` est livré et vert : 378 lignes, 10 contrôles, `10/10 ✅`, exit 0
(commits `720f2be` puis `640020e`, entrée `[v2.0+ECO-1]`). Trois défauts subsistent, établis
par contre-vérification en repo le 23/09/2026 et consignés dans
`specs/Sprints/PASSE-A-couche-validation.md` :

1. **Le validateur n'a aucun test.** Pas de `tests/`. Un validateur non testé est exactement
   l'objet que le sprint ECO-1 prétendait interdire — le paradoxe est resté ouvert à la
   clôture.
2. **C3 est aveugle au grain fichier.** `C3_EXCEPTIONS` exempte des fichiers **entiers** :
   C3 ne voit plus rien dans 3 des 8 fichiers qu'il couvre. Un vrai résidu de placeholder
   dans `06-PDR-bootstrap.md` passerait sans alerte. Les 3 exceptions sont justifiées
   individuellement (l. 473 du PDR ECO-1) — ce n'est pas un contournement, c'est un grain
   trop grossier.
3. **Les contrôles ne citent pas leur incident fondateur, et leurs messages d'erreur ne
   donnent pas le correctif.** `C2` le fait en partie ; les autres non.

Les deux derniers points viennent de patterns lus au source dans
`addyosmani/agent-skills/scripts/` (5 validateurs + 5 tests appariés) et
`obra/superpowers/tests/`.

**Ventilation mesurée le 23/09/2026** — occurrences du motif de C3
(`[→ ADAPTER]` · `[À REMPLIR]` · `[Nom du projet]`, forme non échappée) sur les 8 fichiers :

| Fichier | Bloc fencé | Code inline | Prose |
|---|---|---|---|
| `06-PDR-bootstrap.md` | 0 | 1 (l. 40) | 0 |
| `07-DECISIONS-SDLC.md` | 0 | 13 | **2** (l. 62 titre `M-TMPL-01`, l. 509 index `M-TMPL-01`) |
| `CHANGELOG.md` | 0 | 7 | 0 |
| `00-CONTEXT.md`, `README.md`, `Claude.md`, `STANDARDS.md`, `specs/SPEC.md` | 0 | 0 | 0 |

Les blocs fencés de `06-PDR-bootstrap.md` (§Plan d'exécution Étape 2) citent la forme
**échappée** `\[→ ADAPTER\]`, que le motif de C3 ne matche pas : **aucune occurrence fencée
dans le périmètre**. Les 2 occurrences en prose sont légitimes — elles nomment la convention.

---

## Comportement actuel → cible

- **Actuel :** `bash sdlc-validate.sh` → `10/10 ✅`. Aucune preuve qu'un contrôle sache
  échouer. C3 ne lit pas 3 fichiers sur 8. Un échec dit ce qui est faux, pas quoi faire.
- **Cible :** `bash tests/sdlc-validate-test.sh` → au moins **un cas RED par contrôle**, tous
  verts. C3 opère **ligne par ligne sur les 8 fichiers**, sans exception au grain fichier.
  Chaque contrôle porte en commentaire l'incident qui l'a motivé, et son message d'échec
  nomme le correctif.

---

## Portée

**Inclus :**
- `tests/sdlc-validate-test.sh` — harnais bash + un cas RED minimum par contrôle (10)
- `ROOT` de `sdlc-validate.sh` rendu surchargeable par variable d'environnement, **seul
  changement structurel autorisé**
- C3 : matching ligne par ligne, exclusion du code inline **et** des blocs fencés
- C3 : `C3_EXCEPTIONS` (grain fichier) remplacé par `C3_LINE_EXCEPTIONS` au format
  `"fichier|motif de contenu|justification"` — une ligne n'est exemptée que si elle contient
  le motif. Entrée initiale unique : `07-DECISIONS-SDLC.md|M-TMPL-01|…` (couvre l. 62 et
  l. 509). Repérage par **contenu, jamais par numéro de ligne** (un numéro dérive à la
  première insertion)
- C3 : la sortie affiche le nombre de fichiers examinés (nouvel affichage, requis par les
  critères d'acceptation)
- En-tête d'incident (`A-3`) et message de correctif (`A-5`) pour chacun des 10 contrôles
- `CHANGELOG.md`

**Exclu :**
- **Tout refactor en fonctions pures** (`A-1` de la passe A). Écarté explicitement : il
  faudrait toucher les 378 lignes existantes pour une testabilité que le harnais obtient
  sans y toucher.
- Tout nouveau contrôle. C11 et au-delà sont hors sujet ; ce sprint durcit l'existant.
- Toute modification de C1 (ancrage sur `git describe`) — `git tag` ne renvoie rien dans ce
  repo, la question est close.
- Toute modification des exemptions de C4 — déjà validateur-owned, avec justification et la
  règle « une exception ne s'ajoute jamais pour contourner un vrai défaut ».
- Tout fichier de gouvernance `NN-*.md`, `Claude.md`, `STANDARDS.md` — y compris les 2 lignes
  en prose de `07-DECISIONS-SDLC.md` (voir §Option retenue).

<!-- SPIDR — axe retenu : Rules. Trois durcissements indépendants sur un objet existant ;
     aucun ne bloque les deux autres, chacun peut être abandonné sans casser les autres. -->

---

## Option retenue — alternatives écartées

**Retenue :** durcissement en place, harnais de test par copie de repo, exception C3 au grain
ligne par motif de contenu.

Le harnais : `ROOT` surchargeable, copie du repo dans `mktemp -d`, injection d'un défaut
ciblé, assertion `exit 1` et présence de la ligne d'échec du contrôle fautif dans la sortie.
Patron pris à `obra/superpowers/tests/` (`mktemp -d` + `trap cleanup EXIT` +
`pass`/`fail`/`assert_contains` + `SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"`).

**Écartée(s) :**
- **Refactor en règles pures + CLI mince + tests unitaires** (le pattern `skill-lint.js`
  d'Addy) — juste en JavaScript, sur-dimensionné ici. Coût : réécrire 378 lignes vertes.
  Bénéfice : tests plus rapides. Le rapport est mauvais à 10 contrôles.
- **Amender le PDR ECO-1 par un bloc `→ Mise à jour`** — ajouter une mise à jour à un sprint
  **clos** brouille l'historique. `M-PROC-04` régit les entrées de `DECISIONS.md`, pas les
  PDR archivés. Un sprint distinct laisse `[v2.0+ECO-1]` intact et lisible.
- **Corriger C3 en retirant seulement les blocs fencés** — insuffisant : la ventilation
  mesurée ne compte **aucune** occurrence fencée, mais 21 en code inline (`06` l. 40,
  13 dans `07`, 7 dans `CHANGELOG`). C'est l'exclusion du code inline qui est nécessaire ;
  celle des fences reste une précaution pour les citations futures.
- **Passer en code inline les 2 lignes en prose de `07-DECISIONS-SDLC.md`** — supprimerait
  toute exception, mais réécrit le titre d'une décision (`M-TMPL-01`) et sa ligne d'index
  pour satisfaire un outil. Contraire à l'esprit de `E-03` : c'est l'artefact qui se plierait
  au validateur par confort, pas pour corriger un défaut.
- **Garder les exceptions de fichier en les documentant mieux** — traite la forme, pas le
  fond : le contrôle resterait aveugle sur 3 fichiers.

**Sacrifices délibérés :**
- Le harnais recopie le repo par cas de test. Plus lent qu'un test unitaire, assumé : le
  validateur tourne à la main et en Étape 3.5, pas en boucle serrée.
- Un cas RED par contrôle, pas une matrice. La couverture des variantes viendra si un défaut
  réel la réclame — pas avant *(`INV-4`)*.
- Un marqueur placé en code inline devient invisible pour C3. Accepté : le code inline est la
  forme de citation, un résidu réel de template est en prose.

---

## Contraintes techniques / produit

- Bash + POSIX, zéro dépendance nouvelle. Cohérent avec les 4 scripts existants.
- `set -uo pipefail`, jamais `-e`, dans le harnais comme dans le validateur : un cas de test
  qui échoue ne doit pas interrompre les suivants.
- Le harnais résout ses chemins depuis `SCRIPT_DIR`, jamais depuis le `cwd`, et invoque en
  sous-shell : `( cd "$FIXTURE" && … )`, jamais un `cd` nu *(`M-PROC-30`)*.
- Toute fixture vit sous `mktemp -d` avec `trap cleanup EXIT`. **Aucun test ne s'exécute
  contre le repo réel.**
- `ROOT` conserve son comportement actuel quand la variable d'environnement est absente.
- **Assertion d'identifiant sur la forme complète** `❌ C<n> ·` (format de `report()`) :
  la sous-chaîne `C1` est contenue dans `C10`, une assertion sur `C1` seul est un faux
  positif.
- **Convention d'en-tête d'incident :** un commentaire en colonne 0, immédiatement au-dessus
  de chaque `check_*`, de la forme `# Incident : <incident + ce que rien d'autre n'attrape>`
  ou `# Incident : aucun connu — contrôle préventif [HYPOTHÈSE]`.

**Interdit :**
- Modifier la logique d'un contrôle autre que C3
- Ajouter un contrôle
- Écrire hors de `mktemp -d` depuis le harnais
- Faire passer un test en ajoutant une exception au validateur — la seule exception autorisée
  est l'entrée `M-TMPL-01` de `C3_LINE_EXCEPTIONS`, décidée dans ce PDR
- Une exception C3 repérée par numéro de ligne, ou couvrant un fichier entier
- Un `cd` nu dans le harnais ou le validateur
- Laisser un contrôle sans cas RED au prétexte qu'il est « évidemment correct »
- Inventer un incident fondateur *(précédent `M-PROC-31`/`M-PROC-35`)*

---

## Dépendances

**Inputs requis :**
- [x] `sdlc-validate.sh` présent, `bash sdlc-validate.sh` → `10/10 ✅`, exit 0 — état : vérifié 23/09/2026
- [x] `C3_EXCEPTIONS` : 3 entrées (`06-PDR-bootstrap.md`, `CHANGELOG.md`, `07-DECISIONS-SDLC.md`) ; C3 couvre 8 fichiers — état : vérifié 23/09/2026
- [ ] Sprint ECO-1 clos (`640020e`), aucun travail en cours sur le validateur — état :

**Outputs produits :**
- [ ] `tests/sdlc-validate-test.sh` — interface : `bash tests/sdlc-validate-test.sh`, exit 0 si tous les cas passent
- [ ] Le harnais lui-même, réutilisable par tout script `sdlc-*.sh` futur
- [ ] C3 au grain ligne — précédent pour les contrôles à venir

---

## Critères d'acceptation

- [ ] `bash tests/sdlc-validate-test.sh ; echo "exit=$?"` → exit 0, et la sortie affiche
      **au moins 10 `[PASS]`** — un par contrôle
- [ ] **Chaque contrôle a été observé en échec** : pour chacun, une fixture injecte un défaut
      et le test assert `exit 1` **et** la présence de `❌ C<n> ·` dans la sortie
      *(un `exit 1` seul ne prouve pas que c'est le bon contrôle qui a parlé)*
- [ ] `bash sdlc-validate.sh ; echo $?` → toujours `10/10 ✅`, exit 0 **après** le durcissement
      de C3 — ou, si C3 devient rouge, le résidu trouvé est un **vrai défaut** documenté dans
      `sprint-memory.md`, pas une régression du contrôle
- [ ] Aucune exception C3 au grain fichier : `grep -c "C3_EXCEPTIONS" sdlc-validate.sh` → `0`,
      et `C3_LINE_EXCEPTIONS` compte **une seule** entrée (motif `M-TMPL-01`)
- [ ] C3 couvre les 8 fichiers : `bash sdlc-validate.sh` affiche 8 fichiers examinés par C3
- [ ] **Test de non-aveuglement C3**, sur copie en `mktemp -d` :
  - injecter un `[À REMPLIR]` en prose active dans `06-PDR-bootstrap.md` → C3 **rouge** ;
  - injecter un `[À REMPLIR]` en prose dans `07-DECISIONS-SDLC.md`, sur une ligne sans
    `M-TMPL-01` → C3 **rouge** ;
  - injecter un `[→ ADAPTER]` **non échappé** dans un bloc fencé de `06-PDR-bootstrap.md`
    → C3 **vert** *(sans cette injection, l'exclusion des fences n'est testée sur rien)* ;
  - sans injection, avec les citations légitimes en place (inline l. 40 de `06`, l. 62 et
    l. 509 de `07`) → C3 **vert**
- [ ] `grep -c "^# Incident :" sdlc-validate.sh` → `10` — chaque contrôle porte son incident
      fondateur, **ou la mention explicite qu'il n'en a pas**
- [ ] Chaque message d'échec nomme le correctif, pas seulement la violation — vérifié à la
      lecture des 10 branches d'erreur
- [ ] `bash -n sdlc-validate.sh tests/sdlc-validate-test.sh` → exit 0
- [ ] `git status --porcelain` inchangé après `bash tests/sdlc-validate-test.sh` — le harnais
      n'écrit rien dans le repo
- [ ] Tests niveau A : `bash tests/sdlc-validate-test.sh` → tous verts
- [ ] Tests niveau B : `bash sdlc-validate.sh` sur le repo réel → `10/10 ✅`, exit 0
- [ ] `CHANGELOG.md` mis à jour, ligne `**Tests**` portant le résultat réel des deux scripts

---

## Risques

- **C3 durci devient rouge sur un vrai résidu** : *peu probable d'après la ventilation
  mesurée (2 occurrences en prose, toutes deux couvertes par l'exception `M-TMPL-01`).* Si
  cela arrive, ne pas le traiter comme une régression. Consigner, corriger le fichier, pas le
  contrôle.
- **L'exclusion du code inline est mal bornée** (backtick non fermé, double backtick) :
  *possible.* Une ligne à backtick impair doit être traitée comme prose — faux positif
  visible plutôt que faux négatif silencieux.
- **La copie de repo par cas de test rend la suite lente** : *possible.* Si la suite dépasse
  ~30 s, copier une fois et réinitialiser entre les cas plutôt que recopier — optimisation
  autorisée, pas un refactor.
- **`ROOT` surchargeable ouvre une surface** : *faible.* Le validateur est en lecture seule ;
  pointer ailleurs ne peut rien détruire. À noter en commentaire, sans garde.
- **Écrire les en-têtes d'incident révèle que certains contrôles n'en ont pas** :
  *certain, et c'est un bénéfice.* `C2`, `C6`, `C8` n'ont probablement pas d'incident réel
  connu. Ils doivent le **dire**, pas en inventer un *(précédent `M-PROC-31`/`M-PROC-35` —
  l'étiquette `[HYPOTHÈSE]` plutôt qu'une provenance fabriquée)*.

---

## Pre-mortem *(optionnel en Taille S — conservé, un risque le justifie)*

> Si ce sprint échoue ou dépasse 2× l'estimation, la cause la plus probable est :

**Le durcissement de C3 fait remonter des résidus que la ventilation n'a pas vus, et la
session bascule de « durcir un contrôle » à « nettoyer des fichiers de gouvernance ».**

La ventilation du 23/09/2026 rend ce scénario improbable (2 occurrences en prose, légitimes).
Elle a été faite par un `awk` ad hoc ; le C3 durci peut en différer (bornage du code inline,
lignes à backtick impair). Le pre-mortem reste pour ce cas.

**Signal d'alerte :** plus de 3 résidus sur un seul fichier.
**Conduite à tenir :** arrêter le nettoyage, consigner le compte brut dans `sprint-memory.md`,
livrer C3 durci **avec les résidus constatés en `⚠️` non bloquant**, et ouvrir un sprint
distinct pour le nettoyage. Ne pas nettoyer des fichiers de gouvernance en fin de session.

---
<!-- FIN PRD — La section Handoff est complétée par Claude Code en début de session -->

## Handoff Claude Code
*(pré-rempli à titre de proposition — à confirmer en étape 4c)*

**Fichiers — chargement immédiat :**
- `sdlc-validate.sh` — intégralement ; c'est l'objet du sprint
- `specs/Sprints/PASSE-A-couche-validation.md` §1 (`A-3`, `A-5`, `A-6`) et §3 (défaut C3)

**Fichiers — chargement différé :**
- `06-PDR-bootstrap.md`, `07-DECISIONS-SDLC.md`, `CHANGELOG.md` — grep des marqueurs
  d'abord ; lecture ciblée des lignes remontées
- `specs/Sprints/sprint-ECO-1-sdlc-validate.md` — l. 473 (justification des 3 exceptions) uniquement
- `.claude/hooks/pre-tool-bash.sh` — seulement si C5 remonte quelque chose

**Données à collecter avant de coder :**
- Re-mesurer la ventilation du §Contexte (elle date du 23/09/2026) — c'est elle qui
  dimensionne le sprint
- Pour chacun des 10 contrôles : existe-t-il un incident réel documenté dans
  `07-DECISIONS-SDLC.md` ou le `CHANGELOG` ?

**Instructions spécifiques :**
- Écrire le harnais **avant** le premier cas de test, et le valider sur un contrôle trivial
  (C8, `bash -n`) avant de traiter les neuf autres.
- Pour chaque contrôle : écrire le cas RED, **le voir échouer**, puis passer au suivant. Ne
  pas écrire dix cas puis les lancer.
- Durcir C3 **après** que les dix cas RED passent — le harnais doit exister avant qu'on
  touche à la logique d'un contrôle.
- Si le compte de résidus dépasse 3 sur un fichier → appliquer la conduite du §Pre-mortem.
- Ne pas inventer d'incident fondateur. Un contrôle sans incident l'écrit.

**Grep de vérification préalable :**
```bash
bash sdlc-validate.sh ; echo "exit=$?"
wc -l sdlc-validate.sh
grep -n "C3_EXCEPTIONS" sdlc-validate.sh
grep -n "^check_" sdlc-validate.sh
ls tests/ 2>/dev/null || echo "tests/ absent — attendu"
git log --oneline -5 -- sdlc-validate.sh
ls specs/Sprints/ | grep -E "sprint-(SDLC|ECO)-" | sort -V | tail -3   # attribution du numéro
```

**Init mémoire sprint :**
```bash
echo "# Sprint <N> — durcissement-validate · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-<N>-durcissement-validate.md" >> .claude/sprint-memory.md
```

---

## Plan de développement
*(produit par Claude Code après analyse — à compléter en étape 4d, avant tout code)*

**Dépendances vérifiées :**
- [ ] `sdlc-validate.sh` → 10/10 — état :
- [ ] `C3_EXCEPTIONS` : 3 entrées, 8 fichiers couverts — état :
- [ ] Ventilation des marqueurs re-mesurée — état :

**Modules touchés :**

**Risques identifiés :**

**Plan d'exécution :**
1.
2.

**Plan de test :**
- A — Ciblé : `bash tests/sdlc-validate-test.sh ; echo "exit=$?"`
- **Volumétrie minimum :** ≥ 10 `[PASS]` affichés — une suite qui sort `0` en affichant moins
  de 10 cas est invalide même avec un code de sortie correct
- B — Non-régression : `bash sdlc-validate.sh` sur le repo réel → `10/10 ✅`, exit 0

---

## Corrections ajustées vs spec
*(complété au wrap-up — §Étape 3)*
