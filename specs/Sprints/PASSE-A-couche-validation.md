# PASSE A — Couche test et validation

<!-- Sprint Revue · Taille S · Surface : aucun fichier de gouvernance modifié -->
<!-- Rédigé le 23/09/2026 · CORRIGÉ le 23/09/2026 après contre-vérification en repo -->

---

## ⚠️ CORRECTION — prémisse initiale fausse

> **La version initiale de ce document traitait `ECO-1` comme un PDR à amender. Le sprint
> était clos depuis le 02/09.** Correction apportée après contre-vérification menée dans le
> repo par une session Claude Code. Le corps du document a été réduit à ce qui survit ; la
> trace de l'erreur est conservée ici plutôt qu'effacée *(précédent `M-PROC-29` —
> requalification en place, pas retrait)*.

**Ce que la contre-vérification a établi :**

| Affirmation initiale | Réalité constatée en repo |
|---|---|
| ECO-1 est un PDR à exécuter | `sdlc-validate.sh` existe — 378 lignes, livré au commit `720f2be`, clos par `640020e` (`[v2.0+ECO-1]`). Lancé : **10/10 ✅, exit 0**. |
| 8 contrôles | **10** — `C9` et `C10` ajoutés par SDLC-25 et SDLC-30 |
| `D-1` · « C3 est cassé » | **Faux tel qu'énoncé.** Le cas a été vu au dry-run et traité par décision utilisateur : `C3_EXCEPTIONS`, 3 entrées justifiées, consignées l. 473 du PDR ECO-1 |
| `D-1` · les marqueurs sont cités « en bloc fencé à l'Étape 2 » | **Faux.** Les blocs fencés citent la forme échappée `\[→ ADAPTER\]`, que le motif de C3 ne matche pas. Aucune occurrence fencée dans le périmètre de C3 (voir §3) |
| `D-2` · ancrer C1 sur `git describe` | Sans objet — `git tag` ne renvoie rien. C1 reste tel quel, comme le document l'avait lui-même prévu |
| `D-3` + `A-2` · exemptions validateur-owned | **Déjà faits.** Les exceptions vivent dans le script avec leur justification, et la règle « une exception ne s'ajoute jamais pour contourner un vrai défaut » est écrite en tête |
| `A-6` · résolution de chemin depuis `SCRIPT_DIR` | **Déjà fait** |
| §4 « Taille M confirmée » | Sans objet |

**La leçon de méthode.** Le §7 de la version initiale annonçait « aucun code exécuté » comme
une limite. Ce n'était pas la limite : un `bash sdlc-validate.sh` aurait montré que l'objet
existait. **Le vrai défaut est d'avoir lu 610 000 mots de code tiers et zéro ligne de l'état
courant du repo**, puis d'avoir comparé l'externe à une spécification périmée. Le §1 de la
version initiale confrontait les contrôles à un homme de paille.

> **Règle à retenir : avant de lire une source externe, relire l'état courant du repo.**
> Candidate `[SDLC_CANDIDATE]` — voir §4.

---

## §1 · Ce qui survit

Trois patterns lus au source restent applicables au validateur **tel qu'il existe**, et un
manque reste ouvert.

### A-3 · Chaque contrôle cite l'incident qui l'a fait naître

En-tête de `addyosmani/agent-skills/scripts/validate-reference-links.js` :

> « **All 18 links across 11 skills resolved to files that do not exist** … Agents that
> followed the guidance — for example using-agent-skills pointing at the Definition of Done —
> **hit a file-not-found and stalled.** »

Et de `validate-artifact-paths.js` :

> « When a producer moves an artifact without updating the consumers — **as in PR #93** … the
> pipeline breaks, **and nothing else in CI catches it**. »

Chaque validateur porte, en commentaire de tête, l'incident réel qui l'a motivé **et la
raison pour laquelle rien d'autre ne l'attrape**. C'est `E-02` (RED avant GREEN) sous une
forme bien moins coûteuse que le pressure testing, et c'est la sortie qui manquait à
l'étiquette `[HYPOTHÈSE — non confirmée]` de `M-PROC-35` : un contrôle sans incident cité
est une hypothèse, et ça se voit à la lecture.

*État dans `sdlc-validate.sh` :* `C2` le fait déjà en partie. Les autres non.

### A-5 · L'erreur imprime le correctif, pas seulement la violation

```
Links to references/ are resolved from the skill's own directory.
Shared checklists live in the repo-root references/, two levels up:
use `../../references/<file>.md`, not `references/<file>.md`.
```

`E-09` (recette plutôt qu'interdiction) appliqué à la sortie d'un outil.

### A-6 · Le harnais de test bash de superpowers

`tests/shell-lint/test-lint-shell.sh`, `tests/version-bump/test-bump-version.sh` :

```bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SCRIPT_UNDER_TEST="$REPO_ROOT/scripts/lint-shell.sh"
TEST_ROOT="$(mktemp -d)"
cleanup() { rm -rf "$TEST_ROOT"; }
trap cleanup EXIT
pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }
assert_contains() { … }
make_fixture() { … }
```

Zéro dépendance, bash pur. `mktemp -d` + `trap cleanup EXIT` + fixtures construites, c'est la
règle d'isolation de `M-PROC-30` sous forme de harnais réutilisable.

`version-bump` va plus loin : un fichier `.version-bump.json` déclare quels fichiers portent
la version et dans quel champ — **la liste à synchroniser est une donnée, pas du code.**

### Le manque ouvert · `sdlc-validate.sh` n'a aucun test

Pas de `tests/`. C'est le seul apport net de cette passe, et il est réel : un validateur non
testé est exactement l'objet que le sprint ECO-1 prétendait interdire.

---

## §2 · Écarté après contre-vérification

- **`A-1` · refactor en fonctions pures + wrapper mince.** Juste en JavaScript, sur-dimensionné
  ici : il faudrait toucher les 378 lignes existantes pour un bénéfice de testabilité que le
  harnais d'`A-6` obtient sans y toucher. *Écarté au profit de : `ROOT` surchargeable par
  variable d'environnement + copie du repo dans `mktemp -d` + injection de défaut + assertion
  `exit 1`.*
- **`A-2` · exemptions validateur-owned** — déjà implémenté.
- **`A-4` · non-périmètre déclaré** — utile en principe, mais ne survit pas comme
  recommandation distincte : le vrai sujet est le grain de l'exception (§3).
- **Le runner `node:test`** — contredit la contrainte bash/POSIX zéro-dépendance.
- **Les 2/3 de `superpowers/tests/`** (`antigravity`, `codex`, `kimi`, `opencode`, `pi`,
  `devin`, `hermes`) — tests d'intégration multi-harnais, sans objet pour un projet Claude
  Code seul. *Même sur-transposition que `E-15`, évitée cette fois.*

---

## §3 · Le vrai défaut de C3 — établi par la contre-vérification

`D-1` visait le bon fichier pour la mauvaise raison. Le défaut réel :

**L'exemption `C3_EXCEPTIONS` s'applique au fichier entier.** C3 ne voit donc plus rien dans
3 des 8 fichiers qu'il couvre. Un vrai résidu de placeholder dans `06-PDR-bootstrap.md`
passerait sans alerte — le contrôle est aveugle là où il devrait regarder.

**Ventilation mesurée le 23/09/2026** (motif de C3, forme non échappée) :

| Fichier | Bloc fencé | Code inline | Prose |
|---|---|---|---|
| `06-PDR-bootstrap.md` | 0 | 1 (l. 40) | 0 |
| `07-DECISIONS-SDLC.md` | 0 | 13 | 2 (l. 62, l. 509 — titre et index de `M-TMPL-01`) |
| `CHANGELOG.md` | 0 | 7 | 0 |
| 5 autres fichiers | 0 | 0 | 0 |

Deux conséquences :

- **C'est l'exclusion du code inline qui compte**, pas celle des blocs fencés : aucune
  occurrence fencée dans le périmètre. Les fences de `06-PDR-bootstrap.md` §Étape 2 citent la
  forme échappée `\[→ ADAPTER\]`, que C3 ne matche pas. L'exclusion des fences reste une
  précaution, à tester par injection.
- **Les 2 occurrences en prose de `07-DECISIONS-SDLC.md` sont légitimes** — elles nomment la
  convention. Les réécrire en code inline modifierait le titre d'une décision pour satisfaire
  un outil.

Correctif : matcher **ligne par ligne**, en ignorant le code inline et les blocs fencés,
supprimer les exceptions au grain fichier, et les remplacer par **une exception au grain
ligne repérée par motif de contenu** (`M-TMPL-01`), jamais par numéro de ligne.

---

## §4 · Suites

1. **Nouveau PDR Taille S — `specs/Sprints/sprint-durcissement-validate.md`** *(et non un
   amendement à ECO-1 : ajouter un bloc `→ Mise à jour` à un sprint clos brouille
   l'historique)*. Trois axes : le harnais de test, le correctif C3 du §3, les en-têtes
   d'incident et messages de correctif d'`A-3`/`A-5`.
2. **Bloc `→ Mise à jour` au catalogue `ANALYSE-SKILLS-ECOSYSTEM.md`** — inchangé, voir §5.
3. **Entrée `07-DECISIONS-SDLC.md`** — seulement si le choix du harnais de test la justifie.
4. **`[SDLC_CANDIDATE]` de méthode** — « avant toute lecture de source externe destinée à
   nourrir le modèle, établir l'état courant du repo (`git log --oneline -10`, lancement des
   scripts existants) et le citer dans le §Contexte ». Deux occurrences à ce jour : la
   sur-transposition d'`E-15` et la prémisse périmée de cette passe.

---

## §5 · Bloc de mise à jour pour `ANALYSE-SKILLS-ECOSYSTEM.md`

À ajouter en `→ Mise à jour 23/09/2026`, sans réécrire les entrées sources.

- **§1** — « lu au source » y signifiait « arborescence + quelques fichiers ». Couverture
  réelle mesurée : **~5-6 % des 610 000 mots** des 5 dépôts clonés. Les verdicts gardent leur
  valeur, pas leur pondération.
- **`E-01`** — le tier 1 a une implémentation de référence testée
  (`addyosmani/agent-skills/scripts/`, 1 838 lignes, 5 validateurs + 5 tests appariés).
  `E-01` la citait de seconde main via `evals/README.md`.
- **`E-02`** — la version praticable est `A-3` (commentaire d'en-tête citant l'incident), pas
  le pressure testing à 5 répétitions.
- **`E-03`** — l'anti-affaiblissement a une implémentation de référence (exemptions
  validateur-owned + garde anti-auto-exemption) ; `sdlc-validate.sh` l'a déjà.
- **`E-23`** — **décision à revoir.** `leonxlnx/taste-skill` a été écarté comme « skills de
  domaine » sur la foi d'un listing de `SKILL.md`, alors que son `research/laziness/`
  (10 fichiers, 3 698 mots) porte sur les causes de la troncature de sortie — soit les
  signaux « Silent partial completion » et « Increasing vagueness » du
  `04-sprint-PDR-TEMPLATE.md`. *Passe E, différée.*

---

## §6 · Limites

- **Rédigé sans le code en main.** Les constats du §Correction et du §3 proviennent de la
  contre-vérification menée en repo, pas d'une lecture directe par l'auteur de la passe. Le
  PDR de suite délègue explicitement ce qui exige les fichiers.
- **La ventilation du §3 a été faite par un `awk` ad hoc**, pas par le C3 durci. Elle est à
  re-mesurer en début de sprint.
- **`tests/hooks/test-session-start.sh` de superpowers repéré mais non lu** — il teste le hook
  dont `E-15` et `P-20` discutent.
- **`run-evals.js` (589 l.) situé, non lu.**
- **Passes B à E différées**, déclencheur : après livraison d'un sprint issu de ce catalogue.
