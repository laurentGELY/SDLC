# Sprint ECO-1 — `sdlc-validate.sh` : vérification exécutable du modèle

<!-- PDR conforme à 04-sprint-PDR-TEMPLATE.md v2.0 -->
<!-- Destination : specs/Sprints/sprint-ECO-1-sdlc-validate.md -->
<!-- Modèle au moment de la rédaction : v2.0+SDLC-GSD-V2 · dernière décision M-PROC-39 -->

**Type :** Feature
**Taille :** M
**Surface :** `sdlc-validate.sh` (nouveau) · `03-wrap-up-SKILL-TEMPLATE.md` §3.5 · `.claude/skills/wrap-up/SKILL.md` §3.5 · `00-CONTEXT.md` §4 · `README.md` (1 ligne de version) · `07-DECISIONS-SDLC.md` · `CHANGELOG.md`
**Risque :** Moyen — un contrôle trop strict produit des faux positifs bloquants sur du tuning local légitime (cf. §Pre-mortem)

---

## Contexte

`specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md` (revue du 02/09/2026, 10 dépôts Agent Skills)
a produit un constat unique et structurant, formulé en §2 :

> L'écosystème teste ses artefacts de gouvernance. Le modèle SDLC ne teste pas les siens.

`INV-1` (« tout test = une commande exacte ») est appliqué au code des projets cibles et
aux critères d'acceptation de chaque PDR. Il n'est appliqué à **aucun** des 12 fichiers
du modèle. La trace de cette exception est visible dans presque toutes les entrées du
`CHANGELOG.md` : `**Tests** : N/A (gouvernance uniquement)`.

Deux incidents déjà documentés du repo sont exactement ce qu'un contrôle structurel
attrape, et sont la justification la plus forte de ce sprint :

| Incident | Ce qui s'est passé | Contrôle qui l'aurait vu |
|----------|--------------------|--------------------------|
| `M-HOOKS-05` (SDLC-18) | `pre-tool-bash.sh` lisait `data.get('input')` au lieu de `data.get('tool_input')` — hook silencieusement inopérant pendant plusieurs sprints | C5 |
| `M-TMPL-04` (SDLC-24) | `08-hooks-TEMPLATE.md` non re-synchronisé après le fix de `M-HOOKS-05` — bug reproduit dès le premier bootstrap suivant | C5 |

Un troisième défaut est **déjà connu et non corrigé au moment de la rédaction de ce PDR** :
`README.md` annonce `Version courante : v1.9+SDLC-13` alors que `CHANGELOG.md` porte
`[v2.0+SDLC-GSD-V2]` et que `07-DECISIONS-SDLC.md` va jusqu'à `M-PROC-39`. Ce sprint
dispose donc d'un cas de test rouge réel avant d'écrire la première ligne de script — ce
qui est précisément la discipline que `E-02` recommande (`obra/superpowers/writing-skills` :
*« si tu n'as pas vu l'échec sans le contrôle, tu ne sais pas si le contrôle vérifie la
bonne chose »*).

---

## Comportement actuel → cible

- **Actuel :** aucune commande ne vérifie la cohérence interne du modèle. La seule
  vérification exécutable au wrap-up est le `grep` de placeholders sur le fichier spec du
  sprint courant (`M-PROC-21`). Toute dérive entre un template, le skill vivant qu'il
  produit, la carte des fichiers et le `README.md` est invisible jusqu'à ce qu'un projet
  cible la reproduise.
- **Cible :** `bash sdlc-validate.sh` retourne `0` sur un repo sain, `1` dès qu'un contrôle
  échoue, et sa sortie est un rapport lisible. La commande est appelée à l'Étape 3.5 du
  wrap-up et son résultat remplace `Tests : N/A (gouvernance uniquement)` dans l'entrée
  `CHANGELOG.md`.

---

## Portée

**Inclus :**
- Le script `sdlc-validate.sh` avec 8 contrôles structurels (**tier 1** de `E-01` uniquement)
- Son architecture en **registre de contrôles** — une fonction + une ligne de registre par
  contrôle, de sorte que les vagues suivantes ajoutent des lignes, pas un second script
- L'intégration à l'Étape 3.5 du wrap-up, dans le template `03` **et** dans le skill vivant
  `.claude/skills/wrap-up/SKILL.md`
- La correction du défaut C1 déjà connu (`README.md`, ligne de version)
- Une entrée `M-PROC-40` et le changement de format de la ligne `**Tests**` du `CHANGELOG.md`

**Exclu :**
- Le **tier 2** (déclenchement / routage par TF-IDF sur les descriptions) — sans objet tant
  que les skills du modèle ne sont pas auto-déclenchées, question ouverte de `E-16`
- Le **tier 3** (evals comportementaux `claude -p` + grader) — sprint à part entière,
  question ouverte n°2 du catalogue
- Toute variante du script destinée à valider un **projet cible** plutôt que le repo SDLC.
  `sdlc-validate.sh` valide le modèle, pas ses copies. La propagation vers les projets
  cibles est une décision distincte, à instruire après un premier cycle d'usage réel.
- Toute modification du **contenu** d'un template. Ce sprint constate, il ne réécrit pas.
  Seule exception explicite : la ligne de version du `README.md` (défaut C1 connu).
- Les contrôles qui dépendent de règles pas encore écrites : parité `/help` ↔ skills
  présentes (dépend de `E-17`), budget de contexte M1 (dépend de `E-03`/`E-11`).
  Ils arrivent en Vague 2 **avec** la règle qu'ils font respecter.

<!-- SPIDR — axe de découpe retenu : Rules.
     Les 8 contrôles sont des règles ajoutables progressivement ; le registre
     est l'échafaudage qui rend l'ajout marginal. Découpe par Paths ou Data
     sans objet ici (un seul chemin, pas de volumétrie). -->

---

## Option retenue — alternatives écartées

**Retenue :** un script bash unique, `sdlc-validate.sh`, à la racine du repo, structuré en
registre de contrôles, appelé manuellement et depuis l'Étape 3.5 du wrap-up.

**Écartée(s) :**

- **Vague 1 en doc-only (précédent GSD)** — les deux imports GSD ont commencé par une vague
  « friction nulle » de modifications de templates. Écarté ici pour une raison précise :
  les vagues suivantes de ce catalogue (§Vagues, en annexe) ajoutent ~8 règles nouvelles.
  Les écrire avant le contrôle qui les fait respecter revient à écrire deux fois chaque
  vérification — une fois comme critère d'acceptation ad hoc du PDR, une fois dans le
  script. Le registre livré ici est l'endroit où les vagues 2 et 3 déposent leurs contrôles.
- **Hook `PreToolUse` / `PostToolUse` déclenchant la validation** — écarté : `M-HOOKS-01`
  a déjà tranché que le `PostToolUse` n'est pas activé par défaut, et `M-HOOKS-04`/`M-PROC-30`
  documentent le coût réel d'un hook bloquant mal calibré (auto-verrouillage de session,
  ~40 min). Un script appelé explicitement ne peut pas verrouiller une session.
- **Intégration dans `sdlc-project-check.sh`** — écarté : ce script a un autre objet
  (inventaire de gouvernance et delta vs `doc/CLAUDE_PROJECT.md`, `M-PROC-22`). Les
  fusionner mélangerait « ce qui doit être reporté dans Claude.ai » et « ce qui est
  incohérent dans le repo ».
- **Script Python** — écarté : les trois scripts existants (`sdlc-init.sh`,
  `sdlc-project-check.sh`, `sdlc-token-usage.sh`) sont en bash. Une seconde stack pour un
  quatrième script est un coût sans contrepartie.
- **Contrôles en CI GitHub Actions** — écarté pour ce sprint, pas sur le fond : la valeur
  d'un contrôle qui tourne au wrap-up est qu'il tourne au moment où l'humain décide de
  committer. La CI est un ajout ultérieur légitime, une fois le script stable.

**Sacrifices délibérés :**
- Le script ne **corrige** rien. Il constate et sort en erreur. Un mode `--fix` créerait
  une classe de modifications non tracées dans `07-DECISIONS-SDLC.md` — contraire à `INV-2`.
- Les contrôles C4 et C6 comparent des **structures** (titres de section, listes de
  fichiers), jamais du contenu. Une divergence de texte entre un template et son skill
  vivant est légitime (le repo est self-bootstrappé, `SDLC-14`) et ne doit pas échouer.
- Aucun contrôle sur `doc/*.html` (`SPEC.html`, `MODE-OPERATOIRE.html`) — audience humaine,
  hors du champ de la cohérence machine.

---

## Contraintes techniques / produit

- Bash + outils POSIX uniquement (`grep`, `sed`, `awk`, `wc`, `diff`, `sort`, `comm`).
  Aucune dépendance nouvelle. `jq` toléré s'il est déjà requis ailleurs, sinon `python3`
  comme dans `pre-tool-bash.sh`.
- `set -uo pipefail`, jamais `-e` : un contrôle qui échoue ne doit pas interrompre les
  suivants. Le rapport doit être complet en un seul passage. *(Même raison que le hook
  `pre-compact.sh`, `M-PROC-13`.)*
- Sortie : un bloc par contrôle, préfixé `✅` ou `❌`, plus un résumé final `N/8`.
  Le format visuel suit celui déjà employé par `/sdlc-sync` §Étape A et par le bloc
  `🧹 NETTOYAGE ARTEFACTS` du wrap-up.
- Codes de sortie : `0` = 8/8 · `1` = ≥ 1 contrôle en échec · `2` = erreur d'exécution du
  script lui-même (fichier attendu absent, commande indisponible).
- Le script s'exécute depuis la racine du repo et **résout ses chemins par rapport à sa
  propre position**, pas au `cwd`. *(Angle mort explicitement acté et non comblé dans
  `M-PROC-30` pour `pre-tool-bash.sh` — ne pas le reproduire ici.)*
- Idempotent et en lecture seule : aucune écriture de fichier, aucun appel réseau.

**Interdit :**
- Écrire ou modifier le moindre fichier depuis le script — y compris un cache, un
  `.last-run`, un journal
- Implémenter un mode `--fix`
- Implémenter le tier 2 ou le tier 3 de `E-01` dans ce sprint
- Comparer le **contenu** d'un template et de son skill vivant (uniquement la structure)
- Faire échouer un contrôle sur une divergence dont `07-DECISIONS-SDLC.md` porte déjà la
  justification explicite — un tel cas doit passer par la liste d'exceptions de C4/C6
- Utiliser `cd` sans sous-shell dans le script ou dans ses tests *(piège documenté,
  `M-PROC-30`)*

---

## Dépendances

**Inputs requis** *(ce sprint assume que ces outputs existent et sont valides)* :
- [x] `specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md` §E-01 — absent au démarrage, fourni par l'utilisateur en session, écrit dans le repo
- [x] Décision `M-PROC-39` stable — confirmé présent, `M-PROC-40` libre
- [x] État self-bootstrap du repo (`SDLC-14`) — **partiellement faux** : `Claude.md`, `STANDARDS.md`, `.claude/skills/{wrap-up,retrospective}/SKILL.md`, `.claude/hooks/pre-tool-bash.sh` présents ; `.claude/skills/{help,sdlc-sync}/SKILL.md` **absents** (jamais installés au self-bootstrap SDLC-14) — arbitré avec l'utilisateur avant de coder C4 (cf. §Plan de développement)
- [x] `M-PROC-21` — bloc d'enforcement `grep -En` de l'Étape 3, confirmé comme point d'ancrage du nouvel appel

**Outputs produits** *(ce que les sprints suivants pourront utiliser)* :
- [x] `sdlc-validate.sh` — interface stable : `bash sdlc-validate.sh` → rapport + code de sortie
- [x] Le **registre de contrôles** du script — point d'extension pour les vagues 2 et 3
- [x] Décision `M-PROC-40` dans `07-DECISIONS-SDLC.md`
- [x] Format de ligne `**Tests**` du `CHANGELOG.md` : la mention `N/A (gouvernance uniquement)`
      n'est plus valide pour un sprint touchant les fichiers du modèle

**Règle :** avant de démarrer, vérifier que tous les inputs requis cochés existent et sont
dans l'état attendu. Si un input manque ou a changé → signaler comme BLOQUANT avant toute
analyse.

---

## Les 8 contrôles — spécification exécutable

Chaque contrôle est décrit par ce qu'il vérifie, la commande qui produit le verdict, et le
défaut réel qu'il aurait attrapé. Aucun contrôle n'est admis sans les trois.

### C1 · Version `README.md` ↔ dernière entrée `CHANGELOG.md`

Extraire la version de `README.md` (`**Version courante : vX.Y…**`) et le premier
`## [vX.Y…]` du `CHANGELOG.md`. Elles doivent être identiques.

```bash
README_V=$(grep -m1 -oE 'Version courante : [^ ]+' README.md | sed 's/Version courante : //')
CHLOG_V=$(grep -m1 -oE '^## \[[^]]+\]' CHANGELOG.md | tr -d '#[] ')
[ "$README_V" = "$CHLOG_V" ]
```

**Défaut réel visé :** écart `v1.9+SDLC-13` vs `v2.0+SDLC-GSD-V2`, présent au moment de
la rédaction de ce PDR. **Ce contrôle doit être rouge au premier lancement.**

### C2 · En-tête de version sur chaque template

Tout fichier `NN-*.md` doit porter un commentaire de version dans ses 3 premières lignes
(`<!-- Template SDLC vX.Y … -->` ou `<!-- vX.Y · … -->`).

```bash
for f in [0-9][0-9]-*.md; do head -3 "$f" | grep -qE '<!--.*v[0-9]+\.[0-9]+' || echo "❌ $f"; done
```

**Défaut visé :** un template modifié sans incrément de version — violation directe de la
checklist `00-CONTEXT.md §4`, ligne 2, aujourd'hui vérifiée à l'œil.

### C3 · Placeholders hors des fichiers template

Les marqueurs `[→ ADAPTER]`, `[À REMPLIR]`, `[Nom du projet]` sont légitimes dans les
fichiers `*-TEMPLATE.md`. Ils ne doivent apparaître dans **aucun** fichier de référence :
`00-CONTEXT.md`, `06-PDR-bootstrap.md`, `07-DECISIONS-SDLC.md`, `README.md`, `CHANGELOG.md`,
`Claude.md`, `STANDARDS.md`, `specs/SPEC.md`.

```bash
grep -lE '\[→ ADAPTER\]|\[À REMPLIR\]|\[Nom du projet\]' \
  00-CONTEXT.md 06-PDR-bootstrap.md 07-DECISIONS-SDLC.md README.md CHANGELOG.md \
  Claude.md STANDARDS.md specs/SPEC.md 2>/dev/null
```

Sortie vide attendue. **Défaut visé :** un placeholder copié depuis un template vers un
fichier de référence lors d'une réorganisation.

### C4 · Parité structurelle template ↔ skill vivant

Quatre paires : `03`↔`wrap-up`, `04b`↔`sdlc-sync`, `09`↔`retrospective`, `11`↔`help`.
Comparer la **liste ordonnée des titres `^## `**, pas le contenu.

```bash
diff <(grep '^## ' 03-wrap-up-SKILL-TEMPLATE.md) \
     <(grep '^## ' .claude/skills/wrap-up/SKILL.md)
```

Une divergence de titres est un échec **sauf** si la paire figure dans la liste
d'exceptions en tête de script, avec un renvoi vers l'entrée `07-DECISIONS-SDLC.md` qui la
justifie. La liste d'exceptions est initialisée **vide** : si le premier lancement révèle
des divergences légitimes, chacune est ajoutée avec sa justification — c'est un livrable
du sprint, pas un contournement.

**Défaut réel visé :** `M-TMPL-04` — un template et son artefact vivant qui divergent sans
que personne ne le voie.

### C5 · Parité du schéma JSON entre hook template et hook actif

Extraire les clés lues via `data.get('…')` dans `08-hooks-TEMPLATE.md` et dans
`.claude/hooks/pre-tool-bash.sh`, `.claude/hooks/pre-compact.sh`. Les ensembles doivent
coïncider par hook.

```bash
comm -3 <(grep -oE "data\.get\('[a-z_]+'" 08-hooks-TEMPLATE.md | sort -u) \
        <(grep -oE "data\.get\('[a-z_]+'" .claude/hooks/pre-tool-bash.sh .claude/hooks/pre-compact.sh | \
          grep -oE "'[a-z_]+'" | sed "s/^/data.get(/" | sort -u)
```

Sortie vide attendue. **Défaut réel visé :** `M-HOOKS-05` puis `M-TMPL-04` — la séquence
exacte de deux sprints qui ont coûté un bug reproduit en production de bootstrap.
*C'est le contrôle qui justifie ce sprint à lui seul.*

### C6 · Carte des fichiers ↔ disque ↔ `README.md §Structure du repo`

Trois listes doivent coïncider : les fichiers `NN-*.md` présents sur disque, ceux cités
dans la carte de `00-CONTEXT.md`, ceux cités dans le bloc `§Structure du repo` du `README.md`.

```bash
ls [0-9][0-9]-*.md | sort > /tmp/eco1-disk.txt
grep -oE '^\| *`?[0-9]{2}-[a-zA-Z-]+\.md' 00-CONTEXT.md | grep -oE '[0-9]{2}-.*\.md' | sort -u > /tmp/eco1-ctx.txt
comm -3 /tmp/eco1-disk.txt /tmp/eco1-ctx.txt
```

*(Les motifs d'extraction exacts sont à ajuster sur la forme réelle des deux blocs à
l'étape 4d — cette commande est la forme, pas la valeur finale. C'est le seul point du PDR
qui admet un ajustement, et il est nommé.)*

**Défaut visé :** un 12e template ajouté sans mise à jour de la carte — exactement le
travail fait à la main aux sprints SDLC-11 et SDLC-12.

### C7 · Unicité des identifiants `M-XXXX-NN`

Aucun ID de décision ne doit apparaître deux fois comme titre d'entrée.

```bash
grep -oE '^## M-[A-Z]+-[0-9]+' 07-DECISIONS-SDLC.md | sort | uniq -d
```

Sortie vide attendue. **Défaut réel visé :** `M-PROC-25` a déjà été attribué deux fois
(noté dans le `CHANGELOG` de SDLC-11 : *« M-PROC-25 déjà pris par la co-construction PDR
SDLC-Sync »*). Le conflit a été résolu à la main, sans garde-fou.

### C8 · Syntaxe de tous les scripts shell

```bash
for f in *.sh .claude/hooks/*.sh; do bash -n "$f" || echo "❌ $f"; done
```

**Défaut visé :** aucun connu — c'est le contrôle de non-régression. Il est déjà pratiqué
manuellement (`bash -n` apparaît dans les tests des sprints SDLC-21, 22, 23) ; ce sprint le
rend systématique plutôt que discipliné.

---

## Critères d'acceptation

- [x] `bash sdlc-validate.sh ; echo $?` → le script s'exécute jusqu'au bout et affiche
      les 8 blocs de contrôle, quel que soit le nombre d'échecs *(vérifie `set -uo pipefail` sans `-e`)*
- [x] **Premier lancement, avant correction :** C1 est `❌` et cite les deux versions
      divergentes. Code de sortie `1`. *(Le rouge attendu — si C1 est vert au premier
      lancement, le contrôle ne teste pas ce qu'il prétend tester.)*
- [x] `README.md` corrigé → **second lancement :** C1 est `✅`
- [x] Chacun des 8 contrôles a été observé au moins une fois en `❌`, par une fixture
      construite dans un répertoire isolé — jamais en dégradant l'état réel du repo
      *(règle d'isolation `M-PROC-30`, sous-shell `( cd … && … )` obligatoire)*
- [x] `grep -c "^check_" sdlc-validate.sh` → `8`
- [x] `grep -n "REGISTRE\|CHECKS=" sdlc-validate.sh` → le registre est présent, nommé, et
      un commentaire indique où ajouter un contrôle
- [x] `bash -n sdlc-validate.sh` → exit 0
- [x] `grep -c "sdlc-validate.sh" 03-wrap-up-SKILL-TEMPLATE.md .claude/skills/wrap-up/SKILL.md`
      → `1` dans chacun *(l'appel est ajouté aux deux, template et skill vivant)*
- [x] `grep -A12 "Étape 3.5" .claude/skills/wrap-up/SKILL.md | grep -c "sdlc-validate"` → `1`
      *(l'appel est bien dans la 3.5, pas ailleurs)*
- [x] `grep -c "sdlc-validate" 00-CONTEXT.md` → `≥ 1` *(§4, nouvelle ligne de checklist)*
- [x] `grep -c "M-PROC-40" 07-DECISIONS-SDLC.md` → `≥ 1`
- [x] `grep "M-PROC-40" 07-DECISIONS-SDLC.md` → l'entrée porte les 4 champs du format :
      Retenu · Écarté · Raison · Déclencheur de réouverture
- [x] Le script n'écrit rien : `git status --porcelain` inchangé avant/après exécution
- [x] Tests niveau A : `bash sdlc-validate.sh` → `8/8 ✅`, exit 0, sur le repo corrigé
- [x] Tests niveau B (non-régression) : `bash sdlc-init.sh` sur un répertoire temporaire
      → comportement inchangé *(le nouveau script ne doit rien casser du bootstrap)*
- [x] CHANGELOG mis à jour — et sa ligne `**Tests**` porte le résultat réel du script,
      pas `N/A (gouvernance uniquement)`

<!-- Guidance goal-backward appliquée : chaque critère est un état observable
     produit par une commande, jamais "le script est écrit" ou "l'intégration est faite". -->

<!-- Ce PDR est lui-même conforme à E-13(b) — aucun "TBD", aucun "gérer les cas
     appropriés", aucune référence à une fonction non définie. Le seul ajustement
     admis (motifs d'extraction de C6) est nommé explicitement à l'endroit où il
     se trouve. -->

---

## Risques

- **Faux positifs bloquants sur C4/C6** : *probable* · Le repo est self-bootstrappé, ses
  skills vivants divergent légitimement de leurs templates (`doc/DECISIONS.md` →
  `07-DECISIONS-SDLC.md`, par exemple). **Mitigation :** comparaison structurelle
  uniquement, plus une liste d'exceptions initialisée vide et remplie au premier
  lancement avec, pour chaque entrée, le renvoi vers la décision qui la justifie.
- **Dérive du périmètre vers le tier 2** : *possible* · Le TF-IDF sur les descriptions est
  intellectuellement plus intéressant que huit `grep`. **Mitigation :** §Interdit explicite,
  et critère d'acceptation `grep -c "^check_"` → exactement 8.
- **Le script devient un second `pre-tool-bash.sh`** : *peu probable* · Un script de
  gouvernance qui grossit sans registre devient illisible. **Mitigation :** le registre est
  un critère d'acceptation, pas une intention.
- **C6 non implémentable en une commande propre** : *possible* · Les formats de la carte
  `00-CONTEXT.md` et du bloc `§Structure du repo` du `README.md` ne sont pas normalisés.
  **Mitigation :** si l'extraction demande plus de 5 lignes de `sed`, dégrader C6 en
  comparaison disque ↔ `00-CONTEXT.md` seule et consigner le `README.md` en
  `[SDLC_CANDIDATE]` pour normalisation.

---

## Pre-mortem *(obligatoire taille M)*

> Si ce sprint échoue ou dépasse 2× l'estimation, la cause la plus probable est :

**C4 et C6 produisent une avalanche de divergences légitimes au premier lancement**, et la
session bascule de « écrire un validateur » à « arbitrer trente écarts template/skill ».

Le repo a douze templates, quatre skills vivants et trois scripts, construits sur
vingt-quatre sprints par adaptation successive plutôt que par génération. Il est probable
qu'une part significative des divergences constatées soit intentionnelle mais non écrite —
le tuning local dont `M-PROC-09` dit qu'il « prime toujours », jamais formalisé pour le
repo SDLC lui-même puisqu'il est à la fois modèle et projet cible.

**Signal d'alerte :** plus de 5 divergences sur une seule paire en C4.
**Conduite à tenir si le signal apparaît :** arrêter l'arbitrage, consigner le compte brut
dans `sprint-memory.md`, livrer C4 en mode `⚠️ avertissement non bloquant` avec le nombre
de divergences, et ouvrir un sprint distinct pour le tri. Ne pas arbitrer trente écarts en
fin de session — c'est le mode d'échec que `M-PROC-35` documente déjà (trois passages de
revue avant stabilisation sur une seule décision).

---
<!-- FIN PRD — La section Handoff est complétée par Claude Code en début de session -->

## Handoff Claude Code
*(pré-rempli à titre de proposition — à confirmer ou corriger en étape 4c)*

**Fichiers — chargement immédiat :**
- `specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md` §E-01 uniquement *(la spécification des 8 contrôles est dans ce PDR, pas besoin du catalogue entier)*
- `03-wrap-up-SKILL-TEMPLATE.md` §Étape 3 et §Étape 3.5
- `.claude/skills/wrap-up/SKILL.md` §Étape 3 et §Étape 3.5
- `00-CONTEXT.md` §4
- `README.md` — bloc `§Structure du repo` + ligne de version

**Fichiers — chargement différé :**
- `08-hooks-TEMPLATE.md` — grep `data.get` d'abord, lire seulement si C5 échoue
- `.claude/hooks/pre-tool-bash.sh`, `.claude/hooks/pre-compact.sh` — idem
- `07-DECISIONS-SDLC.md` — grep `^## M-` pour C7 ; lecture complète uniquement pour rédiger `M-PROC-40`
- `sdlc-init.sh`, `sdlc-project-check.sh`, `sdlc-token-usage.sh` — lire uniquement pour aligner le style de sortie
- `CHANGELOG.md` — `head -40` suffit

**Données à collecter avant de coder :**
- Le format exact de la ligne de version du `README.md` et du premier `## [` du `CHANGELOG.md` (C1)
- La forme réelle de la carte des fichiers dans `00-CONTEXT.md` et du bloc `§Structure du repo` (C6)
- La liste exacte des paires template ↔ skill présentes sur disque (C4)
- Le compte de divergences par paire en C4 — **avant** d'écrire la moindre exception

**Instructions spécifiques :**
- Écrire les 8 contrôles dans l'ordre C1 → C8. Après chaque contrôle : le lancer, observer
  son verdict sur le repo réel, et le faire échouer une fois par une fixture isolée avant
  de passer au suivant.
- Toute fixture de test se construit dans `/tmp/eco1-fixture/` et s'invoque en sous-shell :
  `( cd /tmp/eco1-fixture && bash /chemin/absolu/sdlc-validate.sh )`. Jamais un `cd` nu
  *(`M-PROC-30`)*.
- Ne pas corriger le `README.md` avant d'avoir vu C1 échouer. Le rouge est un livrable.
- Si le compte de divergences C4 dépasse 5 sur une paire → appliquer la conduite du
  §Pre-mortem, ne pas arbitrer.

**Grep de vérification préalable :**
```bash
ls sdlc-*.sh
ls .claude/skills/*/SKILL.md
ls .claude/hooks/*.sh
grep -c "^## M-" 07-DECISIONS-SDLC.md
grep -m1 "Version courante" README.md
grep -m1 "^## \[" CHANGELOG.md
```

**Init mémoire sprint :**
```bash
echo "# Sprint ECO-1 — sdlc-validate · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-ECO-1-sdlc-validate.md" >> .claude/sprint-memory.md
```
*(Exécuter en étape 4b du démarrage, après création du fichier spec.)*

---

## Plan de développement
*(produit par Claude Code après analyse — à compléter en étape 4d, avant tout code)*

**Dépendances vérifiées :**
- [x] `ANALYSE-SKILLS-ECOSYSTEM.md` présent — état : absent au démarrage, fourni par
      l'utilisateur en cours de session, écrit dans `specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md`
- [x] `M-PROC-39` dernier ID — état : confirmé présent (ligne 345 de `07-DECISIONS-SDLC.md`),
      `M-PROC-40` libre (`grep "M-PROC-40"` → vide)
- [x] 4 paires template ↔ skill présentes — état : **FAUX pour 2 des 4**. `.claude/skills/`
      ne contient que `diagnostic`, `retrospective`, `wrap-up` — `sdlc-sync` et `help`
      n'ont jamais été installés dans ce repo (self-bootstrap SDLC-14). Dépendance du PDR
      erronée sur ce point, signalée et arbitrée avec l'utilisateur avant de coder (cf.
      décision C4 ci-dessous).
- [x] Écart de version `README`/`CHANGELOG` toujours présent — état : confirmé,
      `v1.9+SDLC-13` (README) vs `v2.0+SDLC-25` (CHANGELOG). Cas de test rouge C1 disponible.

**Modules touchés :** `sdlc-validate.sh` (nouveau) · `03-wrap-up-SKILL-TEMPLATE.md §3.5` ·
`.claude/skills/wrap-up/SKILL.md §3.5` · `00-CONTEXT.md §4` · `README.md` (1 ligne) ·
`07-DECISIONS-SDLC.md` (`M-PROC-40`) · `CHANGELOG.md`

**Modules partagés concernés (→ niveau B obligatoire) :** `00-CONTEXT.md`,
`07-DECISIONS-SDLC.md` — les deux modifiés, niveau B exécuté au wrap-up
(`STANDARDS.md §Modules partagés`).

**Risques identifiés :** cf. §Risques et §Pre-mortem du PDR, complétés par le dry-run
manuel des 8 contrôles sur le repo réel avant toute ligne de code :

| # | Écart constaté | Décision |
|---|---|---|
| C1 | La commande du PDR capture les `**` de fermeture markdown (`[^ ]+` sans espace avant `**`) | Corrigé silencieusement dans le script — motif `[^ *]+` ou nettoyage `sed 's/\*//g'` après extraction. Le PDR donne la forme, pas la valeur finale (même règle explicitée pour C6). |
| C2 | `00-CONTEXT.md` porte sa version en titre H1 (`# ... · v1.5`), pas en commentaire HTML comme les 11 templates `0X-TEMPLATE` | Motif élargi : `^#.*v[0-9]+\.[0-9]+` **ou** `<!--.*v[0-9]+\.[0-9]+`, testé sur les 3 premières lignes. Convention stable et légitime de ce fichier, pas une dérive. |
| C3 | 3 fichiers cibles (`06-PDR-bootstrap.md`, `CHANGELOG.md`, `07-DECISIONS-SDLC.md`) citent le motif `[→ ADAPTER]`/`[À REMPLIR]`/`[Nom du projet]` en le *documentant* (ex. titre de décision `M-TMPL-01`), pas en résidu réel | **Décision utilisateur :** C3 reçoit le même mécanisme d'exceptions que C4/C6 (liste vide initialisée, remplie ici avec les 3 citations légitimes de `M-TMPL-01`, chacune renvoyant vers cette décision) — léger dépassement de la lettre du PDR (qui ne prévoyait l'exception que pour C4/C6), dans son esprit exact. |
| C4 | `.claude/skills/sdlc-sync/` et `.claude/skills/help/` absents — 2 des 4 paires n'ont pas de skill vivante à comparer | **Décision utilisateur :** pour une paire dont le fichier skill n'existe pas, C4 affiche `⚠️ non applicable — skill non installée dans ce repo` (ni ✅ ni ❌), et le contrôle global reste ✅ si les paires réellement présentes (wrap-up, retrospective) sont pairées. N'installe pas les skills manquantes — hors périmètre PDR. |
| C6 | `00-CONTEXT.md §1` ne se liste pas lui-même (la table commence à `01`), mais `ls [0-9][0-9]-*.md` inclut `00-CONTEXT.md` | `00-CONTEXT.md` exclu explicitement du côté "disque" de la comparaison C6 — asymétrie structurelle attendue, pas un défaut. |
| C5, C7, C8 | Aucun écart au dry-run | Implémentés tels que spécifiés dans le PDR, sans ajustement. |

**Plan d'exécution :**
1. Écrire le squelette du script (`set -uo pipefail`, résolution de chemin par `SCRIPT_DIR`,
   registre `CHECKS=(check_c1 … check_c8)`, boucle d'exécution, compteur, code de sortie).
2. Implémenter C1 → C8 dans l'ordre, avec les ajustements ci-dessus. Après chaque contrôle :
   le lancer sur le repo réel, observer son verdict, le faire échouer une fois via une
   fixture isolée dans `/tmp/eco1-fixture/` (sous-shell `( cd … && bash /chemin/absolu/… )`).
3. Initialiser les listes d'exceptions C3/C4/C6 avec les cas légitimes trouvés au dry-run.
4. Corriger `README.md` (ligne de version) — uniquement après avoir observé C1 rouge une
   première fois.
5. Intégrer l'appel `bash sdlc-validate.sh` à l'Étape 3.5 du wrap-up, dans
   `03-wrap-up-SKILL-TEMPLATE.md` **et** `.claude/skills/wrap-up/SKILL.md`.
6. Ajouter la ligne de checklist dans `00-CONTEXT.md §4`.
7. Rédiger l'entrée `M-PROC-40` (4 champs : Retenu · Écarté · Raison · Déclencheur de
   réouverture) dans `07-DECISIONS-SDLC.md`.
8. `git add` + tests niveau A et B + demande d'aval finale avant commit.

**Plan de test :**
- A — Ciblé : `bash sdlc-validate.sh ; echo "exit=$?"`
- **Volumétrie minimum :** 8 blocs de contrôle affichés — un rapport qui sort `0` en
  affichant moins de 8 blocs est invalide même avec un code de sortie correct
- B — Non-régression : `bash sdlc-init.sh` sur `/tmp/eco1-init-test/` (repo git temporaire)
  → structure produite identique à celle d'avant le sprint (`diff -r`) — le script
  `sdlc-validate.sh` ne modifie rien à `sdlc-init.sh`, ce test vérifie l'absence d'effet
  de bord accidentel.

---

## Corrections ajustées vs spec
*(complété au wrap-up — §Étape 3)*

---

## Annexe — Plan de vagues

Ce PDR couvre la Vague 1. Les vagues suivantes suivent le même découpage que les imports
GSD (`M-PROC-38`, `M-PROC-39`) : une vague = un sprint = une entrée de décision.

| Vague | Sprint proposé | Patterns | Type · Taille | Dépend de |
|-------|----------------|----------|---------------|-----------|
| **1** | **ECO-1 · `sdlc-validate`** | **E-01 tier 1** | **Feature · M** | — |
| 2 | ECO-2 · Rédaction des templates | E-08 · E-09 · E-16 · E-17 | Doc · S | ECO-1 *(les règles arrivent avec leurs contrôles C9–C11)* |
| 3 | ECO-3 · Barre qualité | E-03 · E-04 · E-11 | Doc · M | ECO-1 *(contrôle C12 : budget M1)* |
| 4 | ECO-4 · Durcissement PDR | E-13(b) · E-14 · E-06 · E-07 | Doc · S | — *(indépendant, peut passer avant ECO-3)* |
| 5 | ECO-5 · `P-20` SessionStart | E-15 | Feature · M | — *(déjà en ROADMAP §Next)* |
| 6 | ECO-6 · Lexique | E-05 | Doc · S | — |
| §Later | — | E-02 version forte · E-12/`P-21` · E-18 · E-19 | — | tier 3, ou décision sur `M-ARCH-05` |

**Note de séquencement :** ECO-2 et ECO-3 sont volontairement placés **après** ECO-1 parce
qu'ils produisent des règles dont l'application se vérifie par un contrôle — la règle et
son contrôle doivent arriver dans le même commit, sinon la règle est une aspiration
(`E-03`, appliqué au modèle lui-même). ECO-4 n'a pas cette dépendance : ses ajouts se
vérifient par le `grep` d'enforcement déjà présent en Étape 3 (`M-PROC-21`), et il peut
donc être joué à tout moment si un sprint court est préférable.

**Questions ouvertes bloquantes pour les vagues §Later** — reprises du catalogue §8, à
trancher avant tout PDR sur ces lignes :
1. `M-ARCH-05` est-elle rouverte ? *(E-19, distribution par plugin)*
2. Le tier 3 entre-t-il un jour au périmètre ? *(conditionne la version forte de E-02)*
3. `P-22` (`10-audit-externe-TEMPLATE.md`) est-il promu ? *(troisième audit externe consécutif à réinventer son format)*
