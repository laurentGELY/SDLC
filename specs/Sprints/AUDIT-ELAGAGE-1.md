# Audit d'élagage 1 — modèle SDLC (théorique)
<!-- Spike ELAG-1 · spec : specs/Sprints/sprint-ELAG-1-audit-elagage-theorique.md · 20/10/2026 -->
<!-- Exécuté par Claude Code 2.1.304, modèle claude-opus-5-5 · état du repo : 890f47a (v2.0+ECO-8) -->

> Audit **structurel**, en lecture seule : aucun template, script ou décision du registre n'est modifié.
> Les propositions de retrait de la grille sont toutes provisoires, à confirmer par `ELAG-2` sur données d'usage réel.
> Références L1→L7 : voir le spec du sprint, §Références (chiffres cités tels que relevés en session Claude.ai, non revérifiés ici).

**Reproduire les mesures.** Toutes les commandes ci-dessous se lancent depuis la racine du repo SDLC. Dans les tableaux, `\|` est l'échappement Markdown du caractère barre verticale : retirer la barre oblique avant de copier une commande. Préalable :

```bash
SDLC="$PWD"; TMP="$(mktemp -d)"
git -C "$TMP" init -q
( cd "$TMP" && bash "$SDLC/sdlc-init.sh" "Projet Audit" )   # exit 0 observé le 20/10/2026
```

---

## Mesures

### 1.1 Empreinte d'un projet fraîchement bootstrappé

| Fichier (projet `$TMP`) | Lignes | Mots | Commande |
|---|---|---|---|
| `Claude.md` | 499 | 3 715 | `( cd "$TMP" && wc -l -w Claude.md )` |
| `STANDARDS.md` | 192 | 1 396 | `( cd "$TMP" && wc -l -w STANDARDS.md )` |
| **Contexte permanent (plancher M1)** = `Claude.md` + `STANDARDS.md` | 691 | 5 111 | `( cd "$TMP" && cat Claude.md STANDARDS.md \| wc -l -w )` |
| Skill `wrap-up` (chargé à la clôture) | 458 | 2 817 | `( cd "$TMP" && wc -l -w .claude/skills/wrap-up/SKILL.md )` |
| Skill `retrospective` | 298 | 1 605 | `( cd "$TMP" && wc -l -w .claude/skills/retrospective/SKILL.md )` |
| Skill `sdlc-sync` | 168 | 777 | `( cd "$TMP" && wc -l -w .claude/skills/sdlc-sync/SKILL.md )` |
| Skill `diagnostic` | 22 | 104 | `( cd "$TMP" && wc -l -w .claude/skills/diagnostic/SKILL.md )` |
| Total instructions livrées (2 fichiers permanents + 4 skills) | 1 637 | 10 414 | `( cd "$TMP" && wc -l -w Claude.md STANDARDS.md .claude/skills/*/SKILL.md \| tail -1 )` |
| Cible L6 (lignes par fichier mémoire) | 200 | — | source : `code.claude.com/docs/en/memory` (L6, non revérifiée en session) |
| Dépassement de `Claude.md` sur la cible L6 | ×2,5 (499/200) | — | `( cd "$TMP" && echo "scale=1; $(wc -l < Claude.md)/200" \| bc )` |

**Ce qui est réellement chargé — correctif apporté par `/doctor prompt-audit` (§3.3), vérifié ensuite :**

| Mesure | Valeur | Commande |
|---|---|---|
| `CLAUDE.md` (nom attendu par Claude Code) dans le projet bootstrappé | absent (0 fichier) | `ls "$TMP"/CLAUDE.md 2>/dev/null \| wc -l` |
| `CLAUDE.md` dans le repo SDLC lui-même | absent (0 fichier) | `ls CLAUDE.md 2>/dev/null \| wc -l` |
| Import `@` de `Claude.md` ou `STANDARDS.md` depuis un fichier chargé | 0 | `grep -rlE "^@(Claude\|STANDARDS)\.md" "$TMP" 2>/dev/null \| wc -l` |
| Lignes de règles SDLC chargées automatiquement sous Linux (système de fichiers sensible à la casse) | 0 | observé dans cette session : le contexte initial ne contenait que `MEMORY.md`, pas `Claude.md` (lu à la main au §Démarrage) ; constat n° 1 du rapport `/doctor prompt-audit` |

**Lecture.** Le plancher M1 (`wc -w Claude.md STANDARDS.md`) mesure un contexte qui, **sous Linux, n'est jamais chargé**. Claude Code charge `CLAUDE.md` et ne trouve pas `Claude.md` sur un système sensible à la casse. `STANDARDS.md` n'est importé par aucun fichier chargé. Les 691 lignes ne pèsent donc que lorsqu'un agent les lit volontairement. L'hypothèse de densité de ce Spike (L2, L3) ne vaut alors que sur un système insensible à la casse (macOS, Windows par défaut) ou une fois le nom corrigé. Ce n'est pas un argument pour garder les règles : le jour où le nom sera corrigé, les 499 lignes arriveront d'un coup dans chaque session.

**Lecture (taille, si le fichier est chargé).** `Claude.md` seul fait 2,5 fois la cible documentée ; `STANDARDS.md` est juste sous la cible. Le template porte lui-même la règle `.claude/rules/` qui cite ce seuil de ~200 lignes (`Claude.md:236-250` du projet bootstrappé), sans que le fichier qui la contient la respecte.

**Constats annexes du bootstrap** (hors mesure de taille, reportés en §Recouvrements) :

| Constat | Valeur | Commande |
|---|---|---|
| Hook `pre-tool-bash.sh` livré : lit le champ `input` au lieu de `tool_input` (`M-HOOKS-05`) → laisse passer une poussée forcée (exit 0) | exit 0 attendu 2 | `F="--for""ce"; printf '{"tool_name":"Bash","tool_input":{"command":"git push %s origin main"}}' "$F" \| bash "$TMP/.claude/hooks/pre-tool-bash.sh"; echo $?` |
| Origine : copie inline de `sdlc-init.sh`, non resynchronisée après `M-HOOKS-05` | ligne 336 | `grep -n "get('input'" sdlc-init.sh` |
| Marqueur de version écrit dans le `Claude.md` bootstrappé : `v2.0+SDLC-29` alors que le repo est à `v2.0+ECO-8` | 1 ligne | `grep -n "SDLC version" "$TMP/Claude.md" 01-Claude-md-TEMPLATE.md` |

### 1.2 Historique — le modèle ne fait-il que grossir ?

| Template | Lignes ajoutées | Lignes supprimées | Ratio ajouts/suppressions | Commande |
|---|---|---|---|---|
| `01-Claude-md-TEMPLATE.md` | 549 | 50 | 11,0 | `git log --numstat --format= -- 01-Claude-md-TEMPLATE.md \| awk '{a+=$1; d+=$2} END {print a, d}'` |
| `02-STANDARDS-TEMPLATE.md` | 223 | 31 | 7,2 | `git log --numstat --format= -- 02-STANDARDS-TEMPLATE.md \| awk '{a+=$1; d+=$2} END {print a, d}'` |
| `03-wrap-up-SKILL-TEMPLATE.md` | 519 | 61 | 8,5 | `git log --numstat --format= -- 03-wrap-up-SKILL-TEMPLATE.md \| awk '{a+=$1; d+=$2} END {print a, d}'` |
| `04-sprint-PDR-TEMPLATE.md` | 256 | 11 | 23,3 | `git log --numstat --format= -- 04-sprint-PDR-TEMPLATE.md \| awk '{a+=$1; d+=$2} END {print a, d}'` |
| `08-hooks-TEMPLATE.md` | 511 | 11 | 46,5 | `git log --numstat --format= -- 08-hooks-TEMPLATE.md \| awk '{a+=$1; d+=$2} END {print a, d}'` |
| `09-retrospective-SKILL-TEMPLATE.md` | 334 | 36 | 9,3 | `git log --numstat --format= -- 09-retrospective-SKILL-TEMPLATE.md \| awk '{a+=$1; d+=$2} END {print a, d}'` |

**Courbe de taille de `01-Claude-md-TEMPLATE.md`** (mots, un point par commit qui touche le fichier) — commande : `for c in $(git log --format=%h --reverse -- 01-Claude-md-TEMPLATE.md); do printf "%s %s %s\n" "$c" "$(git log -1 --format=%ad --date=short "$c")" "$(git show "$c":01-Claude-md-TEMPLATE.md | wc -w)"; done`

| Repère | Commit | Date | Mots | Commande |
|---|---|---|---|---|
| Premier état | `48c7c23` | 2026-05-30 | 1 147 | `git show 48c7c23:01-Claude-md-TEMPLATE.md \| wc -w` |
| Fin v1.9 (SDLC-24) | `0a3f300` | 2026-06-25 | 3 178 | `git show 0a3f300:01-Claude-md-TEMPLATE.md \| wc -w` |
| Seule baisse de la série (−10 mots) | `0409bd2` | 2026-09-04 | 3 619 | `git show 0409bd2:01-Claude-md-TEMPLATE.md \| wc -w` |
| État actuel | `38703d1` | 2026-09-22 | 3 716 | `git show 38703d1:01-Claude-md-TEMPLATE.md \| wc -w` |
| Croissance totale | — | 115 jours | ×3,2 (3 716/1 147) | `git log --format=%h -- 01-Claude-md-TEMPLATE.md \| wc -l` → 24 commits |

**Lecture.** Sur 24 commits, la taille de `01` ne baisse qu'une fois, de 10 mots. Les 50 lignes supprimées sont des réécritures (une ligne modifiée compte comme 1 suppression + 1 ajout), pas des retraits.

| Retraits nets de règle dans le CHANGELOG | Valeur | Commande |
|---|---|---|
| Lignes du CHANGELOG mentionnant un retrait/une suppression | 4 | `grep -ciE "retir\|supprim" CHANGELOG.md` |
| … dont retrait effectif d'une règle normative | 0 | lecture des 4 lignes de `grep -niE "retir\|supprim" CHANGELOG.md` : `:40` tâche de PDR supprimée, `:103` item de backlog `P-39` clos, `:155` résumé d'en-tête retiré de `04b` (pas une règle), `:158` critère d'acceptation corrigé |

### 1.3 Registre `07-DECISIONS-SDLC.md`

| Mesure | Valeur | Commande |
|---|---|---|
| Entrées `M-*` | 79 | `grep -c "^## M-" 07-DECISIONS-SDLC.md` |
| Taille | 2 566 lignes · 21 825 mots | `wc -l -w 07-DECISIONS-SDLC.md` |
| Taille au premier commit (2026-05-30) | 2 037 mots | `git show 48c7c23:07-DECISIONS-SDLC.md \| wc -w` |
| Titres signalant un retrait | 0 | `grep -cE "^## M-.*(retrait\|retiré\|suppression\|abandon)" 07-DECISIONS-SDLC.md` |
| Champ de statut (Remplacé / Clos / Obsolète) | 0 | `grep -cE "^\*\*(Statut\|Remplac\|Clos\|Obsol)" 07-DECISIONS-SDLC.md` |

Classement de chaque entrée (jugement sur titre + champ **Retenu**, figé par la liste d'IDs dans la commande) :

| Statut | Nombre | Entrées | Commande |
|---|---|---|---|
| Retrait de règle | 0 | — | `grep -cE "^## M-.*(retrait\|retiré\|suppression\|abandon)" 07-DECISIONS-SDLC.md` |
| Décision close ou remplacée | 6 | `M-ARCH-02` (numérotation 00-07, dépassée : fichiers jusqu'à `12`), `M-ARCH-04` (`00-README.md` → `00-CONTEXT.md`), `M-ARCH-06` (`10-OPERATIONS.html` → `docs/MODE-OPERATOIRE.html`), `M-PROC-27` (backfill clos), `M-PROC-29` (audit ponctuel clos), `M-HOOKS-05` (correctif ponctuel) | `grep -cE "^## (M-ARCH-02\|M-ARCH-04\|M-ARCH-06\|M-PROC-27\|M-PROC-29\|M-HOOKS-05) " 07-DECISIONS-SDLC.md` |
| Modification d'une règle existante | 11 | `M-TMPL-04`, `M-PROC-07`, `M-PROC-20`, `M-PROC-22`, `M-ARCH-08`, `M-HOOKS-03`, `M-PROC-32`, `M-PROC-35`, `M-PROC-48`, `M-ARCH-09`, `M-PROC-47` | `grep -cE "^## (M-TMPL-04\|M-PROC-07\|M-PROC-20\|M-PROC-22\|M-ARCH-08\|M-HOOKS-03\|M-PROC-32\|M-PROC-35\|M-PROC-48\|M-ARCH-09\|M-PROC-47) " 07-DECISIONS-SDLC.md` |
| Ajout de règle | 62 | les 79 − 6 − 11 restantes | `echo $(( $(grep -c "^## M-" 07-DECISIONS-SDLC.md) - 6 - 11 ))` |

**Lecture.** Le registre est chargé dans chaque conversation Claude.ai (`M-ARCH-01`) et a été multiplié par 10,7 en mots (21 825/2 037). Il ne porte aucun champ de statut : les 6 décisions closes ou remplacées restent chargées comme si elles étaient en vigueur, et deux d'entre elles (`M-ARCH-04`, `M-ARCH-06`) nomment des fichiers qui n'existent plus.

### 1.4 Unité de comptage

Une règle = une ligne émise par le script ci-dessous, appliqué au projet bootstrappé et au repo SDLC :

- **(a)** `Claude.md`, `STANDARDS.md`, hors blocs de code : puce ou ligne numérotée en colonne 0. Les illustrations « Pensée → Réalité » sont rattachées à leur HALT ou à leur règle et ne sont pas comptées à part.
- **(b)** idem : ligne à amorce grasse (`**…**`), sauf si c'est l'en-tête d'une liste, d'un tableau ou d'un bloc de code. Dans ce cas, ce sont les éléments qui comptent, ou rien pour un tableau ou un bloc.
- **(c)** `Claude.md`, dans les blocs de code : étapes `# N.` du §Démarrage et sections `## ` du gabarit d'Analyse.
- **(d)** chaque bloc `if` actif de `.claude/hooks/pre-tool-bash.sh`.
- **(e)** chaque étape de `wrap-up` (`### 0x.` et `## Étape N`) et de `retrospective` (`## Étape N`), sauf les en-têtes marqués « optionnel ».
- **(f)** chaque fonction `check_cN` de `sdlc-validate.sh`.

Écart au PDR : les points (b) et (c) sont ajoutés (voir le spec, §Corrections ajustées vs spec). Sans eux, la règle « Clause anti-complaisance », le verdict gate et la vérification factuelle ne seraient pas comptés : ils ne sont pas rédigés en puces. Limite connue : les tableaux (`Classifier le travail`, `Types de sprint`, `Niveaux de test`, checklist Q/R d'observabilité) et le bloc `Format des entrées` de la mémoire de sprint ne sont pas comptés. Ils sont rattachés à la ligne la plus proche dans la grille.

```bash
# compter-regles.sh <projet-bootstrappé> <repo-SDLC> [--liste]
P="$1"; S="$2"; MODE="${3:-}"
{
for f in Claude.md STANDARDS.md; do
  awk -v F="$f" '
    { L[NR]=$0 }
    END {
      c=0
      for (i=1;i<=NR;i++) {
        if (L[i] ~ /^```/) { c=!c; continue }
        if (c) {
          if (F=="Claude.md" && (L[i] ~ /^# [0-9][a-d]?\. / || L[i] ~ /^## /)) print F":"i":c: "L[i]
          continue
        }
        if (L[i] ~ /^(- |[0-9]+\. )/ && L[i] !~ /Pensée/) { print F":"i":a: "L[i]; continue }
        if (L[i] ~ /^\*\*/) {
          j=i+1; while (j<=NR && L[j] ~ /^[[:space:]]*$/) j++
          if (L[j] ~ /^(- |[0-9]+\. |\||```)/) continue
          print F":"i":b: "L[i]
        }
      }
    }' "$P/$f"
done
grep -n "^if " "$P/.claude/hooks/pre-tool-bash.sh" | sed 's|^|pre-tool-bash.sh:|; s|:if |:d: if |'
grep -nE "^### 0[a-f]\. |^## Étape [1-9]" "$P/.claude/skills/wrap-up/SKILL.md" | grep -v optionnel | sed 's|^|wrap-up:|; s|:\(##*\) |:e: \1 |'
grep -nE "^## Étape [1-9]" "$P/.claude/skills/retrospective/SKILL.md" | grep -v optionnel | sed 's|^|retrospective:|; s|:## |:e: ## |'
grep -nE "^check_c[0-9]+\(\)" "$S/sdlc-validate.sh" | sed 's|^|sdlc-validate.sh:|; s|:check|:f: check|'
} | if [ "$MODE" = "--liste" ]; then cat; else wc -l; fi
```

Règles comptées : 134 — commande : `bash compter-regles.sh "$TMP" "$SDLC"` (script ci-dessus, non versionné dans le repo : le recopier dans un fichier de ce nom avant usage ; `--liste` affiche les 134 lignes `fichier:ligne:catégorie: texte` dans l'ordre de la grille)

| Catégorie | Règles | Commande |
|---|---|---|
| (a) puces / numéros | 55 | `bash compter-regles.sh "$TMP" "$SDLC" --liste \| grep -c ":a: "` |
| (b) amorces grasses | 29 | `bash compter-regles.sh "$TMP" "$SDLC" --liste \| grep -c ":b: "` |
| (c) étapes Démarrage + sections Analyse | 16 | `bash compter-regles.sh "$TMP" "$SDLC" --liste \| grep -c ":c: "` |
| (d) blocs du hook | 3 | `bash compter-regles.sh "$TMP" "$SDLC" --liste \| grep -c ":d: "` |
| (e) étapes de skills | 21 | `bash compter-regles.sh "$TMP" "$SDLC" --liste \| grep -c ":e: "` |
| (f) contrôles `check_cN` | 10 | `bash compter-regles.sh "$TMP" "$SDLC" --liste \| grep -c ":f: "` |

N = 134 ≤ 150 : aucun regroupement de sous-section n'est nécessaire (seuil de §Risques du spec).

---

## Grille

**Lecture des colonnes.** *Emplacement* : fichier du projet bootstrappé (ou du repo SDLC pour `sdlc-validate.sh`) et numéro de ligne, comme dans `compter-regles.sh --liste`. *Décision source* : trouvée par `grep -n` sur un mot-clé (au plus deux recherches, puis `aucune`). « `aucune` (48c7c23) » : règle présente dès le commit initial, sans décision dédiée. « `aucune` (SDLC-0x, cf. `M-PROC-27`) » : règle importée de BMad par SDLC-07/08/09, sprints dont `M-PROC-27` a acté la clôture sans entrée au registre. Le commit d'introduction est donné par `git log --reverse -S "<motif>" -- <template>`. *Modèle antérieur ?* : « oui » seulement si la décision source invoque une faiblesse du modèle de l'époque.

**Dispositions par défaut appliquées mécaniquement** : `prose+mécanisme` → `MÉCANISER` ; portée ≠ `toujours` → `DÉPLACER`. Une exception de méthode, justifiée une fois ici plutôt que ligne par ligne : une règle de forme `mécanisme` (hook, étape de skill, `check_cN`) ne coûte rien au contexte permanent, puisqu'elle n'est chargée qu'à l'exécution ou jamais. Le défaut « portée ≠ toujours → DÉPLACER » ne s'y applique donc pas : ces règles sont en `GARDER`, sauf recouvrement. Tout autre écart à un défaut est justifié dans sa ligne. Les candidats au retrait sont tous `provisoire — à confirmer par ELAG-2`.

| ID | Emplacement | Énoncé | Décision source | Origine | Forme | Mécanisme | Recouvre | Portée | Modèle antérieur ? | Disposition | Justification |
|---|---|---|---|---|---|---|---|---|---|---|---|
| R-01 | Claude.md:15 §Règles absolues | Pas de code avant l'aval explicite | aucune (48c7c23) | préventif | prose | aucun | R-14, R-52 | toujours | inconnu | GARDER | Pivot du flux Analyse → Aval ; cible de fusion de R-14 |
| R-02 | Claude.md:16 §Règles absolues | Ne jamais sauter l'analyse | aucune (48c7c23) | préventif | prose | aucun | R-43→R-52 | toujours | inconnu | GARDER | Seule règle qui rend le gabarit d'Analyse obligatoire |
| R-03 | Claude.md:17 §Règles absolues | Ne pas conclure sans preuve observable | aucune (48c7c23) | préventif | prose | aucun | R-15, R-40, R-62 | toujours | inconnu | FUSIONNER (avec R-62) | Quatre formulations du même défaut (L3 : quasi-doublons) |
| R-04 | Claude.md:18 §Règles absolues | Noter la valeur précédente d'une config modifiée | aucune (48c7c23) | préventif | prose | aucun | R-99 | rare | inconnu | FUSIONNER (avec R-99) | Doublon exact de STANDARDS:191 ; R-99 est déplacée |
| R-05 | Claude.md:19 §Règles absolues | Pas de refactor hors périmètre sans validation | aucune (48c7c23) | préventif | prose | aucun | R-11 | toujours | inconnu | FUSIONNER (avec R-11) | Même condition que HALT-SCOPE |
| R-06 | Claude.md:20 §Règles absolues | Étapes 4a→4d faites avant tout code | M-PROC-12, M-HOOKS-04 | incident | prose | aucun | R-22, R-23, R-25 | toujours | non | GARDER | Incident réel (`LL-T05`) ; le garde-fou hook 4a n'est pas livré aux projets |
| R-07 | Claude.md:26 §Règles absolues | Ne pas affaiblir un seuil de Barre qualité | M-PROC-42 | import | prose | aucun | R-92, R-97 | toujours | non | FUSIONNER (avec R-92) | Même règle en trois endroits (Claude.md, STANDARDS ×2) |
| R-08 | Claude.md:31 §HALT | HALT-DEP : dépendance absente du PDR | aucune (SDLC-07, cf. M-PROC-27) | import | prose | aucun | — | toujours | inconnu | GARDER | Déclencheur observable, coût 2 lignes |
| R-09 | Claude.md:33 §HALT | HALT-3X : trois échecs → /diagnostic | aucune (SDLC-07, cf. M-PROC-27) | import | prose | skill | R-59 | toujours | inconnu | GARDER | Prose de 2 lignes qui déclenche le skill ; pas de doublon |
| R-10 | Claude.md:35 §HALT | HALT-ARCH : PDR contredit par le code | aucune (SDLC-07, cf. M-PROC-27) | import | prose | aucun | R-41, R-50 | toujours | inconnu | GARDER | Recouvrement partiel avec R-50 (prémisse fausse), moment différent (exécution) |
| R-11 | Claude.md:37 §HALT | HALT-SCOPE : périmètre dépasse le PDR | aucune (SDLC-07, cf. M-PROC-27) | import | prose | aucun | R-05, R-80 | toujours | inconnu | GARDER | Cible de fusion de R-05 |
| R-12 | Claude.md:39 §HALT | HALT-TIMEOUT : préfixer timeout, exit 124 → HALT | M-PROC-31, M-PROC-35 | import | prose+mécanisme | timeout natif de l'outil Bash | — | toujours | oui | MÉCANISER | L'outil Bash de Claude Code a déjà un délai par défaut (120 000 ms, vu dans sa définition en session) |
| R-13 | Claude.md:44 §Rationalisations | Tables Pensée → Réalité pour les 5 HALT | M-PROC-31, M-PROC-35 | import | prose | aucun | R-08→R-12 | toujours | oui | CANDIDAT RETRAIT | M-PROC-35 : étiquettes « [HYPOTHÈSE — non confirmée] » gardées, aucune confirmation depuis ; 50 lignes = 10 % de Claude.md — provisoire — à confirmer par ELAG-2 |
| R-14 | Claude.md:99 §Règles absolues | Sans aval, s'arrêter après l'analyse | aucune (48c7c23) | préventif | prose | aucun | R-01, R-52 | toujours | inconnu | FUSIONNER (avec R-01) | Redit R-01 et la dernière ligne du gabarit d'aval |
| R-15 | Claude.md:110 §Rôle | Toute affirmation factuelle citable | aucune (SDLC-07, cf. M-PROC-27) | import | prose | aucun | R-03, R-62 | toujours | inconnu | FUSIONNER (avec R-62) | M-PROC-32 a déjà relié les deux par renvoi croisé : fusion naturelle |
| R-16 | Claude.md:115 §Rôle | Git source de vérité, restaurer avant patch | aucune (48c7c23) | préventif | prose | aucun | — | toujours | inconnu | CANDIDAT RETRAIT | aucune décision source ; pratique standard qu'un agent applique sans consigne (L4) — provisoire — à confirmer par ELAG-2 |
| R-17 | Claude.md:117 §Rôle | specs/SPEC.md référence architecturale | M-SCOPE-02 | préventif | prose | aucun | R-24 | toujours | non | GARDER | Pointeur propre au projet (non standard, L4) |
| R-18 | Claude.md:121 §Rôle | Limites bash du projet, commande prête à copier | aucune (48c7c23) | préventif | prose | aucun | — | toujours | inconnu | GARDER | Contenu propre à l'environnement : le cas que L4 juge utile |
| R-19 | Claude.md:125 §Rôle | .env chmod 600, jamais versionné | aucune (48c7c23) | préventif | prose | aucun | R-96 | toujours | inconnu | FUSIONNER (avec R-96) | Même défaut (secret exposé) ; R-96 est la règle générale |
| R-20 | Claude.md:133 §Démarrage | Étape 1 : sync et état du dépôt | aucune (48c7c23) | préventif | prose | aucun | — | toujours | inconnu | GARDER | Bloc exécutable, ancrage de session |
| R-21 | Claude.md:136 §Démarrage | Étape 2 : mémoire sprint + SESSION_BRIDGE | M-PROC-10, M-PROC-22 | incident | prose | aucun | R-26, R-116 | toujours | non | GARDER | Reprise inter-session ; l'écriture est faite par R-116 |
| R-22 | Claude.md:152 §Démarrage | Étape 4a : créer le fichier spec | M-PROC-12 | incident | prose | aucun | R-06 | toujours | non | GARDER | Incident `M-HOOKS-04` / `LL-T05` |
| R-23 | Claude.md:156 §Démarrage | Étape 4b : initialiser la mémoire sprint | M-PROC-12 | incident | prose | aucun | R-06 | toujours | non | GARDER | `LL-T08` : mémoire vide sur diff substantiel |
| R-24 | Claude.md:160 §Démarrage | Étape 4c : charger immédiat, différé par grep | M-PROC-16 | préventif | prose | aucun | R-28, R-29, R-44 | toujours | inconnu | GARDER | Cible de fusion de R-28/R-29 (même règle redite dans §Tokens) |
| R-25 | Claude.md:169 §Démarrage | Étape 4d : plan de développement avant code | M-PROC-12 | incident | prose | aucun | R-06, R-47 | toujours | non | GARDER | Incident `M-HOOKS-04` |
| R-26 | Claude.md:176 §Démarrage | Mémoire non vide → bloc à 4 options | M-PROC-10 | préventif | prose | aucun | R-21, R-56 | rare | inconnu | DÉPLACER (skill de reprise) | Portée ≠ toujours ; 22 lignes chargées à chaque session pour un cas de reprise |
| R-27 | Claude.md:208 §Démarrage | Mode /fast : correction < 2 min sans PDR | M-PROC-38 | import | prose | aucun | — | rare | inconnu | DÉPLACER (05-ROADMAP / amont) | Portée ≠ toujours ; le nom entre en collision avec la commande intégrée `/fast` de Claude Code (bascule du mode rapide) : contradiction au sens L6 |
| R-28 | Claude.md:217 §Tokens | Chargement chirurgical immédiat/différé | M-PROC-16 | préventif | prose | aucun | R-24 | toujours | inconnu | FUSIONNER (avec R-24) | Redit l'étape 4c |
| R-29 | Claude.md:218 §Tokens | Grep avant lecture de tout fichier différé | aucune (48c7c23) | préventif | prose | aucun | R-24, R-30 | toujours | inconnu | FUSIONNER (avec R-24) | Redit l'étape 4c |
| R-30 | Claude.md:219 §Tokens | Fichier > 200 lignes : passer par l'index | aucune (SDLC-08, cf. M-PROC-27) | import | prose | aucun | R-29 | taille M/L | inconnu | DÉPLACER (.claude/rules/ ou Handoff PDR) | Portée ≠ toujours (brownfield, gros fichiers) |
| R-31 | Claude.md:223 §Tokens | > 5 fichiers ou > 10K tokens → sous-agent | aucune (SDLC-08, cf. M-PROC-27) | import | prose | aucun | R-35 | taille M/L | oui | DÉPLACER (Handoff PDR) | Portée ≠ toujours ; seuil lié à la fenêtre de contexte des modèles de l'époque |
| R-32 | Claude.md:228 §Tokens | Formuler toutes les questions avant de modifier | aucune (48c7c23) | préventif | prose | aucun | R-02 | toujours | inconnu | CANDIDAT RETRAIT | aucune décision source ; consigne non vérifiable, déjà portée par l'existence du gabarit d'Analyse — provisoire — à confirmer par ELAG-2 |
| R-33 | Claude.md:229 §Tokens | Oracle en amont : questions résolues avant handoff | aucune (48c7c23) | préventif | prose | aucun | — | rare | inconnu | DÉPLACER (10-AMONT / PDR) | Portée ≠ toujours ; s'adresse au rédacteur du PDR (Claude.ai), pas à l'exécutant. La §Oracle en fin de fichier (non comptée) y est rattachée |
| R-34 | Claude.md:230 §Tokens | Signaler les batchings XS/S possibles | aucune (48c7c23) | préventif | prose | aucun | — | rare | inconnu | DÉPLACER (05-ROADMAP / amont) | Portée ≠ toujours ; décision de planification, pas d'exécution |
| R-35 | Claude.md:231 §Tokens | Modèle du sous-agent selon la nature de la tâche | M-PROC-33 | import | prose | aucun | R-31 | taille M/L | oui | DÉPLACER (Handoff PDR) | Portée ≠ toujours ; dépend de la gamme de modèles du moment (proposition G) |
| R-36 | Claude.md:236 §Tokens | Claude.md > 200 lignes → .claude/rules/ scopé | M-TMPL-06 | import | prose | aucun | — | rare | non | DÉPLACER (06-PDR-bootstrap / sdlc-sync) | Portée ≠ toujours (décision de structure ponctuelle) ; 15 lignes chargées à chaque session |
| R-37 | Claude.md:261 §Modifications spot | Modification ciblée par script sed | M-PROC-11 | préventif | prose+mécanisme | outil Edit natif | R-38, R-39 | toujours | oui | MÉCANISER | L'outil Edit échoue si le motif est absent ou ambigu : il fait déjà la vérification. Règle née des diffs manuels Claude.ai |
| R-38 | Claude.md:262 §Modifications spot | Grep final : ancien motif → zéro | M-PROC-11 | préventif | prose | aucun | R-37 | toujours | oui | FUSIONNER (avec R-37) | Une seule ligne de renvoi suffit |
| R-39 | Claude.md:263 §Modifications spot | Trop complexe pour sed → régénérer depuis template | M-PROC-11 | préventif | prose | aucun | R-37 | rare | oui | DÉPLACER (skill sdlc-sync) | Portée ≠ toujours |
| R-40 | Claude.md:280 §Analyse anti-biais | Ancrer sur la preuve avant de théoriser | aucune (SDLC-07, cf. M-PROC-27) | import | prose | aucun | R-03, R-42 | toujours | inconnu | FUSIONNER (avec R-62) | Même défaut que R-03/R-15 (conclusion sans preuve) |
| R-41 | Claude.md:281 §Analyse anti-biais | Description de l'utilisateur = hypothèse | aucune (SDLC-07, cf. M-PROC-27) | import | prose | aucun | R-50, R-10 | toujours | inconnu | FUSIONNER (avec R-50) | R-50 couvre « contenu d'un document fourni comme acquis » |
| R-42 | Claude.md:283 §Analyse anti-biais | Preuve contraire → réviser la théorie | aucune (SDLC-07, cf. M-PROC-27) | import | prose | aucun | R-40 | toujours | inconnu | FUSIONNER (avec R-62) | Corollaire de R-40 |
| R-43 | Claude.md:289 §Analyse gabarit | Section Compréhension | aucune (48c7c23) | préventif | prose | aucun | — | toujours | inconnu | GARDER | Champ structurel (forme recommandée par `00-CONTEXT §5.2`) |
| R-44 | Claude.md:294 §Analyse gabarit | Section Fichiers nécessaires | aucune (48c7c23) | préventif | prose | aucun | R-24 | toujours | inconnu | CANDIDAT RETRAIT | aucune décision source ; redit le §Handoff du PDR, imposé depuis M-PROC-16 — provisoire — à confirmer par ELAG-2 |
| R-45 | Claude.md:298 §Analyse gabarit | Section Données collectées (Tuning) | aucune (48c7c23) | préventif | prose | aucun | — | type de sprint Tuning | inconnu | DÉPLACER (04 PDR, type Tuning) | Portée ≠ toujours |
| R-46 | Claude.md:303 §Analyse gabarit | Section Analyse d'impact | aucune (48c7c23) | préventif | prose | aucun | R-60, R-90 | toujours | inconnu | GARDER | Seul endroit qui relie modules partagés et niveau B |
| R-47 | Claude.md:308 §Analyse gabarit | Section Plan d'exécution | aucune (48c7c23) | préventif | prose | aucun | R-25 | toujours | inconnu | GARDER | Champ structurel |
| R-48 | Claude.md:313 §Analyse gabarit | Plan de test : niveau A = commande exécutable | M-PROC-07 | préventif | prose | aucun | R-63→R-65, R-81 | toujours | inconnu | GARDER | INV-1 ; cible de fusion des définitions A/B/C |
| R-49 | Claude.md:321 §Analyse gabarit | Section Candidat hook (optionnelle) | M-PROC-06 | préventif | prose+mécanisme | skill (wrap-up Ét. 1, rétro Ét. 3) | R-73, R-110 | rare | inconnu | MÉCANISER | Prose+mécanisme ; la collecte se fait déjà au wrap-up |
| R-50 | Claude.md:327 §Analyse gabarit | Vérification factuelle + totaux vérifiés par commande | M-PROC-41, M-PROC-48 | incident | prose | aucun | R-41, R-03 | toujours | non | GARDER | Règle la mieux étayée (`LL-T04` 10 occ., `LL-T14` 4 occ.). Pourtant, ce sprint l'a encore enfreinte (sous-totaux 66/30) : la prose seule ne suffit pas (L1) |
| R-51 | Claude.md:347 §Analyse gabarit | Auto-revue du plan en 3 passes | M-PROC-43 | import | prose | aucun | R-52, R-109 | toujours | inconnu | FUSIONNER (avec R-52) | Aucune capture tracée (`grep -c "uto-revue" docs/LESSONS_LEARNED.md` → 0) ; même moment et même défaut que le verdict gate |
| R-52 | Claude.md:358 §Analyse gabarit | Demande d'aval + verdict gate PASS/CONCERNS/FAIL | aucune (SDLC-09, cf. M-PROC-27) | import | prose | aucun | R-01, R-14, R-51 | toujours | inconnu | GARDER | Garder la demande d'aval. Verdict gate sans trace d'usage (`grep -c CONCERNS CHANGELOG.md docs/LESSONS_LEARNED.md` → 0/0) : à mesurer par ELAG-2 |
| R-53 | Claude.md:390 §Mémoire de sprint | Quand écrire dans sprint-memory | M-PROC-10 | incident | prose+mécanisme | skill (avertissement M-PROC-44, wrap-up 3.5) | R-54 | toujours | non | MÉCANISER | Prose+mécanisme ; la liste des déclencheurs reste dans le bloc Format (non compté) |
| R-54 | Claude.md:392 §Mémoire de sprint | Quand ne pas écrire dans sprint-memory | M-PROC-10 | préventif | prose | aucun | R-53 | toujours | inconnu | FUSIONNER (avec R-53) | Négatif du précédent ; liste d'interdits (forme déconseillée, `00-CONTEXT §5.2`) |
| R-55 | Claude.md:394 §Mémoire de sprint | CHECKPOINT généré par hook PreCompact | M-HOOKS-08 | incident | prose+mécanisme | hook pre-compact.sh (absent des projets) | — | rare | non | MÉCANISER | Prose+mécanisme, mais le hook n'est pas livré par `sdlc-init.sh` (§Recouvrements 3.2) : livrer le hook ou retirer la mention |
| R-56 | Claude.md:401 §Mémoire de sprint | Mémoire perdue → reconstruire depuis git | M-PROC-10 | préventif | prose | aucun | R-26, R-57 | rare | inconnu | DÉPLACER (skill de reprise) | Portée ≠ toujours |
| R-57 | Claude.md:413 §Mémoire de sprint | Après compaction, la trace écrite fait foi | M-PROC-43 | import | prose | aucun | R-56 | rare | oui | DÉPLACER (skill de reprise) | Portée ≠ toujours (après compaction seulement) |
| R-58 | Claude.md:423 §Code | Commenter chaque bloc logique, le pourquoi | aucune (48c7c23) | préventif | prose | aucun | — | type de sprint Feature/Fix | inconnu | DÉPLACER (.claude/rules/ scopé `src/**`) | Portée ≠ toujours ; cas d'école de M-TMPL-06 |
| R-59 | Claude.md:428 §Code | Tester chaque modification avant la suivante | aucune (48c7c23) | préventif | prose | aucun | R-09 | type de sprint Feature/Fix | inconnu | DÉPLACER (.claude/rules/ scopé) | Portée ≠ toujours |
| R-60 | Claude.md:431 §Code | Module partagé → vérifier les consommateurs | aucune (48c7c23) | préventif | prose | aucun | R-90, R-46 | type de sprint Feature/Fix | inconnu | FUSIONNER (avec R-90) | Doublon de STANDARDS:75 |
| R-61 | Claude.md:433 §Code | Éviter : renvoi vers §Priorités | aucune (48c7c23) | préventif | prose | aucun | R-78 | toujours | inconnu | CANDIDAT RETRAIT | aucune décision source ; ligne sans contenu propre (renvoi vers la section suivante) — provisoire — à confirmer par ELAG-2 |
| R-62 | Claude.md:439 §Test | Clause anti-complaisance : test vu dans la session | M-PROC-32 | import | prose | aucun | R-03, R-15, R-40 | toujours | oui | GARDER | Cible de fusion du groupe « conclure sans preuve » (R-03, R-15, R-40, R-42) |
| R-63 | Claude.md:448 §Test | Définition test OK niveau A | M-PROC-07 | préventif | prose | aucun | R-48, R-81 | toujours | inconnu | FUSIONNER (avec R-48) | A/B/C définis trois fois (Claude.md §Analyse, §Test, tableau STANDARDS §Niveaux de test) |
| R-64 | Claude.md:449 §Test | Définition test OK niveau B | M-PROC-07 | préventif | prose | aucun | R-48, R-90 | toujours | inconnu | FUSIONNER (avec R-48) | Idem R-63 |
| R-65 | Claude.md:450 §Test | Définition test OK niveau C | M-PROC-07 | préventif | prose | aucun | R-48 | toujours | inconnu | FUSIONNER (avec R-48) | Idem R-63 |
| R-66 | Claude.md:461 §Wrap-up | Résumé : question rétrospective | aucune (48c7c23) | préventif | prose+mécanisme | skill wrap-up | R-110 | toujours | inconnu | MÉCANISER | Prose+mécanisme ; résumer la procédure d'un skill est le défaut visé par M-TMPL-05 |
| R-67 | Claude.md:462 §Wrap-up | Résumé : entrée Lessons Learned | aucune (48c7c23) | préventif | prose+mécanisme | skill wrap-up | R-111 | toujours | inconnu | MÉCANISER | Idem R-66 |
| R-68 | Claude.md:463 §Wrap-up | Résumé : CHANGELOG + ROADMAP obligatoires | aucune (48c7c23) | préventif | prose+mécanisme | skill wrap-up | R-113, R-82 | toujours | inconnu | MÉCANISER | Idem R-66 |
| R-69 | Claude.md:464 §Wrap-up | Résumé : bloc Corrections ajustées vs spec | aucune (48c7c23) | préventif | prose+mécanisme | skill wrap-up | R-112 | toujours | inconnu | MÉCANISER | Idem R-66 |
| R-70 | Claude.md:465 §Wrap-up | Résumé : commit + rappel de sync | aucune (48c7c23) | préventif | prose+mécanisme | skill wrap-up | R-115, R-117 | toujours | inconnu | MÉCANISER | Idem R-66 |
| R-71 | Claude.md:468 §Wrap-up | Résumé rétro : lecture index LL | aucune (48c7c23) | préventif | prose+mécanisme | skill retrospective | R-118 | rare | inconnu | MÉCANISER | Prose+mécanisme (le défaut MÉCANISER prime, il produit aussi le déplacement) |
| R-72 | Claude.md:469 §Wrap-up | Résumé rétro : détection récurrences | aucune (48c7c23) | préventif | prose+mécanisme | skill retrospective | R-119 | rare | inconnu | MÉCANISER | Idem R-71 |
| R-73 | Claude.md:470 §Wrap-up | Résumé rétro : HOOK_CANDIDATE ≥ 2 occurrences | M-PROC-06 | préventif | prose+mécanisme | skill retrospective | R-121, R-49 | rare | inconnu | MÉCANISER | Idem R-71 |
| R-74 | Claude.md:471 §Wrap-up | Résumé rétro : SDLC_CANDIDATE à remonter | M-PROC-08 | préventif | prose+mécanisme | skill retrospective | R-122 | rare | inconnu | MÉCANISER | Idem R-71 |
| R-75 | Claude.md:472 §Wrap-up | Résumé rétro : actions avec destination | aucune (48c7c23) | préventif | prose+mécanisme | skill retrospective | R-121 | rare | inconnu | MÉCANISER | Idem R-71 |
| R-76 | Claude.md:473 §Wrap-up | Résumé rétro : validation humaine avant commit | aucune (48c7c23) | préventif | prose+mécanisme | skill retrospective | R-121 | rare | inconnu | MÉCANISER | Idem R-71 |
| R-77 | Claude.md:475 §Wrap-up | Avant commit : DoD + git diff --stat | aucune (48c7c23) | préventif | prose+mécanisme | skill wrap-up Ét. 3.5 | R-114, R-80 | toujours | inconnu | MÉCANISER | Prose+mécanisme ; l'Étape 3.5 fait exactement ces vérifications |
| R-78 | Claude.md:495 §Priorités | Arbitrage de priorités → compromis + aval | aucune (48c7c23) | préventif | prose | aucun | R-61 | rare | inconnu | DÉPLACER (gabarit Demande d'aval) | Portée ≠ toujours ; la ligne d'ordre des priorités (non comptée) y est rattachée |
| R-79 | STANDARDS.md:15 §DoD | Critères d'acceptation passés ou N/A justifié | aucune (48c7c23) | préventif | prose+mécanisme | skill wrap-up 0e, 3.5 | R-108, R-114 | toujours | inconnu | GARDER | Écart au défaut : c'est la cible des renvois du wrap-up, pas un doublon |
| R-80 | STANDARDS.md:16 §DoD | Aucun fichier hors portée dans le diff | aucune (48c7c23) | préventif | prose+mécanisme | skill wrap-up 3.5 | R-11, R-77 | toujours | inconnu | GARDER | Écart au défaut : cible de renvoi (idem R-79) |
| R-81 | STANDARDS.md:17 §DoD | Tests A/B/C exécutés ou N/A justifié | M-PROC-07 | préventif | prose+mécanisme | skill wrap-up 3.5 | R-48, R-63 | toujours | inconnu | GARDER | Écart au défaut : cible de renvoi (idem R-79) |
| R-82 | STANDARDS.md:18 §DoD | CHANGELOG/DECISIONS/STANDARDS mis à jour si impactés | aucune (48c7c23) | préventif | prose+mécanisme | skill wrap-up Ét. 3 | R-68, R-100, R-113 | toujours | inconnu | GARDER | Écart au défaut : cible de renvoi (idem R-79) |
| R-83 | STANDARDS.md:21 §DoD | /wrap-up terminé | aucune (48c7c23) | préventif | prose+mécanisme | skill wrap-up | R-114 | toujours | inconnu | CANDIDAT RETRAIT | aucune décision source ; circulaire : la DoD est vérifiée *pendant* le wrap-up (3.5), elle ne peut exiger qu'il soit fini — provisoire — à confirmer par ELAG-2 |
| R-84 | STANDARDS.md:22 §DoD | Commit au format conventionnel | aucune (48c7c23) | préventif | prose+mécanisme | skill wrap-up Ét. 4 | R-70, R-115 | toujours | inconnu | MÉCANISER | Prose+mécanisme |
| R-85 | STANDARDS.md:23 §DoD | Rappel de sync Claude.ai déclenché | aucune (48c7c23) | préventif | prose+mécanisme | skill wrap-up Ét. 6 | R-70, R-117 | toujours | inconnu | MÉCANISER | Prose+mécanisme |
| R-86 | STANDARDS.md:40 §Types de sprint | Distinction Revue / Spike | M-PROC-34 | import | prose | aucun | R-87 | rare | inconnu | DÉPLACER (04 PDR / 10-AMONT) | Portée ≠ toujours : sert à typer le sprint, au moment du PDR |
| R-87 | STANDARDS.md:45 §Types de sprint | Spike : sortie = décision, jamais du code | aucune (48c7c23) | préventif | prose | aucun | R-86 | type de sprint Spike | inconnu | DÉPLACER (04 PDR) | Portée ≠ toujours |
| R-88 | STANDARDS.md:47 §Types de sprint | SDLC-Sync via le skill /sdlc-sync | M-PROC-09 | préventif | prose+mécanisme | skill sdlc-sync | — | type de sprint SDLC-Sync | non | MÉCANISER | Prose+mécanisme |
| R-89 | STANDARDS.md:59 §Niveaux de test | Test A invalide si zéro item traité | M-PROC-23 | incident | prose | aucun | R-48 | type de sprint pipeline | inconnu | DÉPLACER (.claude/rules/ scopé pipeline) | Portée ≠ toujours |
| R-90 | STANDARDS.md:75 §Modules partagés | Module partagé → niveau B + table à jour | aucune (48c7c23) | préventif | prose | aucun | R-60, R-46, R-64 | type de sprint Feature/Fix | inconnu | GARDER | Écart au défaut : la table qu'elle maintient est propre au projet (non standard, L4) ; cible de fusion de R-60 |
| R-91 | STANDARDS.md:77 §Modules partagés | Régénérer DEPENDENCY_MAP si module partagé change | aucune (48c7c23) | préventif | prose | aucun | R-90 | rare | inconnu | CANDIDAT RETRAIT | aucune décision source ; le fichier n'est jamais créé (absent du bootstrap, §3.2) — provisoire — à confirmer par ELAG-2 |
| R-92 | STANDARDS.md:85 §Barre qualité | Seuil sans commande = aspiration ; dérogation datée | M-PROC-42 | import | prose | aucun | R-07, R-97 | toujours | non | GARDER | Cible de fusion de R-07 et R-97 |
| R-93 | STANDARDS.md:103 §Plancher | Aucun nouveau commentaire de suppression (noqa…) | M-PROC-42 | import | prose | aucun | — | type de sprint Feature/Fix | non | DÉPLACER (.claude/rules/ scopé code) | Portée ≠ toujours ; candidat hook `PostToolUse` (L6 : bloquer = hook) |
| R-94 | STANDARDS.md:104 §Plancher | Aucun stub livré comme fini | M-PROC-42 | import | prose | aucun | R-62 | type de sprint Feature/Fix | non | DÉPLACER (.claude/rules/ scopé code) | Portée ≠ toujours |
| R-95 | STANDARDS.md:105 §Plancher | Aucun test sauté sans raison au commit | M-PROC-42 | import | prose | aucun | R-07 | type de sprint Feature/Fix | non | DÉPLACER (.claude/rules/ scopé tests) | Portée ≠ toujours |
| R-96 | STANDARDS.md:106 §Plancher | Aucun secret en source | M-PROC-42 | import | prose | aucun | R-19 | toujours | non | GARDER | Cible de fusion de R-19 ; la section hook `.env` de `08` (non activée) la mécaniserait |
| R-97 | STANDARDS.md:107 §Plancher | Ce fichier ne s'affaiblit pas | M-PROC-42 | import | prose | aucun | R-07, R-92 | toujours | non | FUSIONNER (avec R-92) | Troisième énoncé de la même règle |
| R-98 | STANDARDS.md:131 §Observabilité | Étape de pipeline : traces début/fin/erreur | M-ARCH-08 | préventif | prose | aucun | — | type de sprint Feature (pipeline) | inconnu | DÉPLACER (.claude/rules/ scopé pipeline) | Portée ≠ toujours |
| R-99 | STANDARDS.md:191 §Archivage | Config modifiée : valeur précédente au commit | aucune (48c7c23) | préventif | prose | aucun | R-04 | rare | inconnu | DÉPLACER (.claude/rules/ scopé fichiers de config) | Portée ≠ toujours ; frontière `paths:` naturelle |
| R-100 | STANDARDS.md:192 §Archivage | Config non triviale → entrée DECISIONS.md | aucune (48c7c23) | préventif | prose | aucun | R-82 | rare | inconnu | FUSIONNER (avec R-82) | Cas particulier de R-82 |
| R-101 | pre-tool-bash.sh:20 | Bloquer git push --force | M-HOOKS-01, M-HOOKS-02 | préventif | mécanisme | hook (inopérant : champ `input`) | — | toujours | non | GARDER | Garder **et réparer** : `sdlc-init.sh:336` lit le mauvais champ (§Mesures 1.1) |
| R-102 | pre-tool-bash.sh:26 | Bloquer rm -rf sur dossier critique | M-HOOKS-01, M-HOOKS-02 | préventif | mécanisme | hook (inopérant : champ `input`) | — | toujours | non | GARDER | Idem R-101 |
| R-103 | pre-tool-bash.sh:33 | Avertir sur sudo hors apt/snap | M-HOOKS-02 | préventif | mécanisme | hook (inopérant : champ `input`) | — | rare | non | GARDER | Mécanisme : aucun coût de contexte |
| R-104 | wrap-up:17 §0a | Lire la mémoire sprint | M-PROC-10, M-PROC-20 | préventif | mécanisme | skill wrap-up | — | toujours | non | GARDER | Étape de skill |
| R-105 | wrap-up:32 §0b | Identifier le document de référence de session | aucune (831d501) | préventif | mécanisme | skill wrap-up | R-108 | toujours | inconnu | FUSIONNER (avec R-108) | Ne sert qu'à 0e (objectif vs résultat) ; le spec sprint (4a) est la référence depuis M-PROC-12 |
| R-106 | wrap-up:36 §0c | Ancrer le bilan sur git | M-PROC-02 | préventif | mécanisme | skill wrap-up | R-107 | toujours | non | GARDER | Étape de skill |
| R-107 | wrap-up:60 §0d | Produire le bilan structuré | M-PROC-02 | préventif | mécanisme | skill wrap-up | R-106 | toujours | non | GARDER | Étape de skill |
| R-108 | wrap-up:91 §0e | Revue objectif : ATTEINT/PARTIEL/NON ATTEINT | M-PROC-19 | préventif | mécanisme | skill wrap-up | R-79, R-109, R-114 | toujours | non | GARDER | Cible de fusion de 0b et de la couche 3 de 0f ; aucune trace de verdict PARTIEL (`grep -c PARTIEL docs/LESSONS_LEARNED.md` → 0) : à mesurer par ELAG-2 |
| R-109 | wrap-up:107 §0f | Adversarial Review 3 couches (M/L) | aucune (SDLC-09, cf. M-PROC-27) | import | mécanisme | skill wrap-up | R-108, R-51 | taille M/L | inconnu | FUSIONNER (couche 3 avec R-108) | Couches 1-2 à garder : captures réelles (`CHANGELOG.md:181` 6 défauts, `LESSONS_LEARNED.md:106`). La couche 3 refait 0e |
| R-110 | wrap-up:166 §Ét. 1 | Question rétrospective avec avis | aucune (48c7c23) | préventif | mécanisme | skill wrap-up | R-66, R-49 | toujours | inconnu | GARDER | Étape de skill |
| R-111 | wrap-up:187 §Ét. 2 | Entrée Lessons Learned | aucune (48c7c23) | préventif | mécanisme | skill wrap-up | R-67 | toujours | inconnu | GARDER | INV-4 |
| R-112 | wrap-up:208 §Ét. 2b | Corrections ajustées vs spec | M-PROC-12 | préventif | mécanisme | skill wrap-up | R-69 | toujours | non | GARDER | Seule source de preuves de capture pour la Phase 3 |
| R-113 | wrap-up:220 §Ét. 3 | Mise à jour documentation + nettoyage | M-PROC-04, M-PROC-21 | préventif | mécanisme | skill wrap-up | R-68, R-82 | toujours | non | GARDER | Étape de skill |
| R-114 | wrap-up:294 §Ét. 3.5 | Vérification pré-commit (diff, DoD, validateur) | M-PROC-40, M-PROC-44 | incident | mécanisme | skill wrap-up | R-77, R-79, R-80 | toujours | non | GARDER | Cible de renvoi de R-77 |
| R-115 | wrap-up:322 §Ét. 4 | Commit | aucune (48c7c23) | préventif | mécanisme | skill wrap-up | R-84 | toujours | inconnu | GARDER | Étape de skill |
| R-116 | wrap-up:343 §Ét. 5 | Amorce SESSION_BRIDGE §Actif/§Archive | M-PROC-22, M-PROC-39 | préventif | mécanisme | skill wrap-up | R-21 | toujours | non | GARDER | Modèle chaud/froid réutilisé par la proposition F |
| R-117 | wrap-up:424 §Ét. 6 | Sync des fichiers projet Claude.ai | M-PROC-25 | préventif | mécanisme | skill wrap-up | R-85 | toujours | non | GARDER | Étape de skill |
| R-118 | retrospective:12 §Ét. 1 | Chargement du contexte | aucune (48c7c23) | préventif | mécanisme | skill retrospective | R-71 | rare | inconnu | GARDER | Étape de skill |
| R-119 | retrospective:30 §Ét. 2 | Analyse des patterns internes | aucune (48c7c23) | préventif | mécanisme | skill retrospective | R-72, R-123 | rare | inconnu | GARDER | Étape de skill |
| R-120 | retrospective:99 §Ét. 2b | Significant Discovery Alert | aucune (SDLC-08, cf. M-PROC-27) | import | mécanisme | skill retrospective | R-119 | rare | inconnu | GARDER | Capture réelle : SD-5 a tranché 3 décisions en attente (`CHANGELOG.md:150`) |
| R-121 | retrospective:144 §Ét. 3 | Actions internes au projet | aucune (48c7c23) | préventif | mécanisme | skill retrospective | R-73, R-75, R-76 | rare | inconnu | GARDER | Étape de skill |
| R-122 | retrospective:161 §Ét. 4 | Remontées vers le modèle SDLC | M-PROC-08 | préventif | mécanisme | skill retrospective | R-74 | rare | non | GARDER | INV-4 (circuit SDLC_CANDIDATE) |
| R-123 | retrospective:190 §Ét. 5 | Index structuré des patterns | M-PROC-17 | préventif | mécanisme | skill retrospective | R-119 | rare | non | GARDER | Index LL utilisé à chaque wrap-up (Ét. 1) |
| R-124 | retrospective:220 §Ét. 6 | Mise à jour des champs de décision | M-PROC-15 | préventif | mécanisme | skill retrospective | — | rare | non | GARDER | Capture réelle : décisions invalidées (`CHANGELOG.md:111`) |
| R-125 | sdlc-validate.sh:96 | C1 version README ↔ CHANGELOG | M-PROC-40 | incident | mécanisme | check_c1 | R-126, R-133, R-134 | rare (repo SDLC seul) | non | GARDER | Mécanisme ; C1/C2/C9/C10 vérifient tous un marqueur de version, mais sans coût de contexte |
| R-126 | sdlc-validate.sh:113 | C2 en-tête de version sur chaque template | M-PROC-40 | incident | mécanisme | check_c2 | R-125 | rare (repo SDLC seul) | non | GARDER | Idem R-125 |
| R-127 | sdlc-validate.sh:150 | C3 placeholders hors templates | M-PROC-40, M-TMPL-01 | incident | mécanisme | check_c3 | — | rare (repo SDLC seul) | non | GARDER | Mécanisme |
| R-128 | sdlc-validate.sh:199 | C4 parité template ↔ skill vivant | M-PROC-40 | incident | mécanisme | check_c4 | — | rare (repo SDLC seul) | non | GARDER | Mécanisme |
| R-129 | sdlc-validate.sh:250 | C5 parité schéma JSON hook template ↔ hooks actifs | M-PROC-40, M-TMPL-04 | incident | mécanisme | check_c5 | — | rare (repo SDLC seul) | non | GARDER | Garder **et étendre** à la copie inline de `sdlc-init.sh` : angle mort qui a laissé passer R-101→R-103 |
| R-130 | sdlc-validate.sh:270 | C6 carte des fichiers ↔ disque ↔ 00-CONTEXT | M-PROC-40, M-PROC-47 | incident | mécanisme | check_c6 | — | rare (repo SDLC seul) | non | GARDER | Mécanisme |
| R-131 | sdlc-validate.sh:301 | C7 unicité des identifiants M-XXXX-NN | M-PROC-40 | incident | mécanisme | check_c7 | — | rare (repo SDLC seul) | non | GARDER | Mécanisme |
| R-132 | sdlc-validate.sh:317 | C8 syntaxe des scripts shell | M-PROC-40 | incident | mécanisme | check_c8 | — | rare (repo SDLC seul) | non | GARDER | Mécanisme (`bash -n` ne voit pas une clé JSON erronée : cf. R-129) |
| R-133 | sdlc-validate.sh:340 | C9 site docs/ à jour | M-PROC-45 | incident | mécanisme | check_c9 | R-125, R-134 | rare (repo SDLC seul) | non | GARDER | Mécanisme |
| R-134 | sdlc-validate.sh:369 | C10 livrables HTML à jour | M-PROC-46 | incident | mécanisme | check_c10 | R-125, R-133 | rare (repo SDLC seul) | non | GARDER | Mécanisme |

**Synthèse des dispositions** (commande : `grep "^| R-[0-9]" specs/Sprints/AUDIT-ELAGAGE-1.md | awk -F'|' '{print $12}' | sed 's/ (.*//; s/^ *//; s/ *$//' | sort | uniq -c`) :

| Disposition | Règles | Part |
|---|---|---|
| GARDER | 61 | 46 % |
| FUSIONNER | 23 | 17 % |
| DÉPLACER | 23 | 17 % |
| MÉCANISER | 20 | 15 % |
| Retrait proposé (provisoire) | 7 | 5 % |

**Lecture.** Sur les 78 règles de `Claude.md`, 56 ne restent pas en l'état dans le contexte permanent : elles sont à fusionner, déplacer, mécaniser ou retirer (commande : `grep "^| R-[0-9]" specs/Sprints/AUDIT-ELAGAGE-1.md | grep "Claude.md:" | grep -vc "| GARDER |"`). Parmi les 61 `GARDER`, 32 sont des mécanismes sans coût de contexte permanent : étapes de skills, hook, `check_cN` (`grep "^| R-[0-9]" specs/Sprints/AUDIT-ELAGAGE-1.md | grep "| mécanisme |" | grep -c "| GARDER |"`). Les retraits proposés sont peu nombreux à dessein : sans donnée d'usage, la fusion et le déplacement sont les seules dispositions qui ne perdent aucune règle.

---

## Recouvrements

### 3.1 Matrice des couches de vérification

« Preuve d'une capture réelle » : une occurrence où la couche a trouvé un défaut, tracée dans `CHANGELOG.md` ou `docs/LESSONS_LEARNED.md`. Une mention de création ou de rapport de routine ne compte pas.

| Couche | Grille | Moment | Défaut attrapé | Preuve d'une capture réelle |
|---|---|---|---|---|
| Vérification factuelle | R-50 | analyse (+ écriture d'un livrable) | prémisse fausse, total recopié de mémoire | oui — `LESSONS_LEARNED.md:75` (HTML figés depuis 23 versions), `:105` (E-04 infirmé), `:111` (mécanisme tiers vérifié) ; `LL-T04` 10 occ. |
| Auto-revue en 3 passes | R-51 | analyse, avant l'aval | exigence non couverte, placeholder, incohérence de nom | aucune — `grep -c "uto-revue" docs/LESSONS_LEARNED.md` → 0 ; les 4 lignes du CHANGELOG sont des mentions de création/doc |
| Verdict gate PASS/CONCERNS/FAIL | R-52 | analyse, à l'aval | analyse incomplète présentée comme prête | aucune — `grep -c CONCERNS CHANGELOG.md docs/LESSONS_LEARNED.md` → 0/0 |
| Plan de test / niveau A | R-48, R-63 | analyse (plan) → exécution | test décrit et non exécutable ; régression | oui — `CHANGELOG.md:29` (C3 : 2 cas FAIL avant durcissement), `LESSONS_LEARNED.md:51` (cas RED C8) |
| Clause anti-complaisance | R-62 | exécution | test déclaré OK sans sortie vue | aucune trace distincte — les 4 mentions LL sont des imports ou des renvois croisés |
| Revue objectif §0e | R-108 | wrap-up | critère d'acceptation non atteint déclaré fait | aucune — `grep -cE "PARTIEL\|NON ATTEINT" docs/LESSONS_LEARNED.md` → 0 |
| Adversarial Review — couche 1 (Blind Hunter) | R-109 | wrap-up (M/L) | défaut visible dans le seul diff | oui — `CHANGELOG.md:181` (6 défauts), `LESSONS_LEARNED.md:106` (ECO-1, ECO-3) ; bruit : `LL-T10` (2 faux positifs sur 4) |
| Adversarial Review — couche 2 (Edge Case Hunter) | R-109 | wrap-up (M/L) | régression liée au contexte projet | non distinguée de la couche 1 dans les traces |
| Adversarial Review — couche 3 (Acceptance Auditor) | R-109 | wrap-up (M/L, module partagé) | critère d'acceptation seulement vraisemblable | aucune trace distincte |
| DoD (STANDARDS) | R-79→R-85 | wrap-up 3.5 | livrable incomplet, fichier hors portée | aucune capture tracée ; `CHANGELOG.md:140` porte sur la DoD mais c'est la vérification factuelle qui a attrapé |
| `sdlc-validate.sh` C1, C2, C9, C10 (marqueurs de version) | R-125, R-126, R-133, R-134 | commit (repo SDLC) | version désalignée entre fichiers | oui — `CHANGELOG.md:86` (C9 ❌ avant rattrapage), `:76` (C10) |
| `sdlc-validate.sh` C3 (placeholders) | R-127 | commit | placeholder résiduel | oui, sur défaut injecté seulement — `CHANGELOG.md:29` |
| `sdlc-validate.sh` C4, C6, C7 (parité, carte, IDs) | R-128, R-130, R-131 | commit | dérive structurelle | aucune capture tracée hors suite de tests (rouge démontré par `tests/sdlc-validate-test.sh`) |
| `sdlc-validate.sh` C5 (schéma JSON hook) | R-129 | commit | clé JSON du hook erronée | **manque** — ne couvre pas la copie inline de `sdlc-init.sh:336`, inopérante (§Mesures 1.1) |
| `sdlc-validate.sh` C8 (syntaxe shell) | R-132 | commit | script non analysable | oui, sur défaut injecté — `LESSONS_LEARNED.md:51` |

**Paires qui ciblent le même défaut au même moment** (candidates à la fusion, L1) :

1. **Critère d'acceptation non satisfait, au wrap-up — 4 couches :** §0e (R-108), Adversarial couche 3 (R-109), DoD « critères passés » (R-79) et la checklist 3.5 (R-114). Seule la couche 1 de l'Adversarial a des captures, mais sur un autre défaut (diff). → Fusion : §0e est la seule revue d'objectif, la couche 3 et 0b disparaissent, la DoD reste la cible du renvoi.
2. **Plan non prêt présenté à l'aval, en analyse — 2 couches :** auto-revue (R-51) et verdict gate (R-52), aucune capture. → Fusion : une seule auto-évaluation avant l'aval.
3. **Conclusion sans preuve, en exécution — 5 énoncés :** R-03, R-15, R-40, R-42 et R-62. Ce sont des quasi-doublons au sens de L3 plutôt que des couches. → Fusion sous la clause anti-complaisance (R-62).
4. **Version désalignée, au commit — 4 contrôles :** C1, C2, C9 et C10. Ce sont des mécanismes sans coût de contexte et chacun a une capture : **pas de fusion**. L1 vise les couches qui consomment l'attention de l'agent, pas les contrôles de script.

Recouvrement partiel, **non fusionné** : vérification factuelle (R-50) et HALT-ARCH (R-10) ciblent tous deux une prémisse du PDR fausse. Mais R-50 agit avant l'aval et R-10 pendant l'exécution, donc à deux moments différents.

### 3.2 Références cassées

Commande (projet bootstrappé) : `( cd "$TMP" && grep -ohE "[A-Za-z0-9_./-]+\.(md|sh|json)" Claude.md STANDARDS.md .claude/skills/*/SKILL.md | sort -u | while read -r f; do [ -e "$f" ] || echo "ABSENT: $f"; done )` → 22 lignes `ABSENT:` (`... | wc -l`).

| Tri | Références | Verdict |
|---|---|---|
| Créé plus tard dans la vie du projet | `.claude/sprint-memory.md`, `sprint-memory.md`, `docs/SESSION_BRIDGE.md`, `docs/CLAUDE_PROJECT.md`, `CLAUDE_PROJECT.md` | normal |
| Gabarit ou artefact de l'expression régulière | `specs/Sprints/sprint-N-slug.md`, `fichier.md`, `/SKILL.md`, `/chemin/vers/sdlc-toolkit/sdlc-project-check.sh` | normal |
| Fichier du repo SDLC cité par un skill pour une remontée ou un sync | `07-DECISIONS-SDLC.md` (rétro:183, sdlc-sync:62), `03-wrap-up-SKILL-TEMPLATE.md` (rétro:173), `06-PDR-bootstrap.md`, `sdlc-project-check.sh` (sdlc-sync), `sdlc-token-usage.sh` (rétro:256) | normal — cible hors projet, explicitement |
| Contenu réservé au repo SDLC, livré aux projets | `sdlc-validate.sh`, `tests/sdlc-validate-test.sh` (wrap-up:301, conditionnel « si présent »), `08-hooks-TEMPLATE.md` (wrap-up:457, déclencheur `M-PROC-37`), `sdlc-init.sh` | pas cassé, mais contexte mort dans un projet cible : à déplacer hors du skill projet |
| **Réellement cassé** | `.claude/hooks/pre-compact.sh` — `Claude.md:395` affirme que `CHECKPOINT` est généré par ce hook, mais `sdlc-init.sh` ne l'installe pas (`grep -c pre-compact sdlc-init.sh` → 0) | **cassé** (R-55) |
| **Réellement cassé** | `04-sprint-PDR-TEMPLATE.md` — `Claude.md:351` (auto-revue) renvoie à sa §Pas de placeholders ; dans le projet, cette section est dans `specs/sprint-template.md:133` | **cassé** (R-51) |
| **Réellement cassé** | `DECISIONS.md` — `Claude.md:22` cite « `DECISIONS.md` M-HOOKS-04 », mais `M-HOOKS-04` est dans `07-DECISIONS-SDLC.md` du repo SDLC, pas dans le `docs/DECISIONS.md` du projet | **cassé** (R-06) |

Deux contradictions non détectables par 3.2, relevées en Phase 2 :
- **`/fast`** (R-27) : le « Mode /fast » du modèle porte le nom d'une commande intégrée de Claude Code, qui bascule le mode rapide.
- **Hook livré inopérant** (R-101→R-103) : `Claude.md:95-97` affirme que « les hooks bloquent les commandes dangereuses avant exécution ». Dans un projet bootstrappé, le hook ne bloque rien (§Mesures 1.1).

### 3.3 `/doctor prompt-audit`

Annoncée comme déclinée, la commande a finalement été lancée par l'humain dans `$TMP` (Claude Code 2.1.304, modèle Opus 5.5). Son rapport a été collé en séance le 20/10/2026. Elle existe donc dans cette version. Elle a proposé un diff sans rien appliquer. Ses constats sont repris ci-dessous et rapprochés de la grille. Chaque constat repris a été revérifié par commande dans cette session (colonne Vérification).

| # audit | Constat (paraphrasé) | Grille | Vérification | Nouveau vs 3.1/3.2 ? |
|---|---|---|---|---|
| 1 | Le fichier s'appelle `Claude.md`, Claude Code charge `CLAUDE.md` : sous Linux, aucune règle n'est chargée | toutes R-01→R-100 | `ls "$TMP"/CLAUDE.md` → absent ; contexte initial de cette session sans `Claude.md` | **nouveau, majeur** |
| 2 | Les 4 skills n'ont pas de frontmatter `name`/`description` : la liste des skills n'affiche que « wrap-up — SKILL », etc. | R-104→R-124 | `head -1 "$TMP"/.claude/skills/*/SKILL.md` → titre seul ; la liste des skills de cette session affiche « wrap-up — SKILL » | **nouveau** — contredit `00-CONTEXT §5.1` (« description = déclenchement ») |
| 3 | Dates du jour figées dans 3 gabarits du skill wrap-up | R-111, R-113, R-116 | `grep -n "20/10/2026\|2026-10-20" "$TMP"/.claude/skills/wrap-up/SKILL.md` → lignes 193, 226, 388 | **nouveau** — `sdlc-init.sh` remplace la date dans les gabarits |
| 4 | `CHECKPOINT` présenté comme automatique, mais le hook `pre-compact.sh` n'est pas installé | R-55 | `grep -c pre-compact sdlc-init.sh` → 0 | déjà vu en 3.2 |
| 5 | Pas de `.gitignore` : `.env` et `sprint-memory.md` ne sont pas réellement ignorés | R-19, R-96 | `ls "$TMP"/.gitignore` → absent | **nouveau** |
| 6 | `git pull origin main` échoue sans remote, et le `&&` saute `status`/`log` | R-20 | dépôt neuf sans remote (attendu au bootstrap) | nouveau, mineur |
| 7 | Récit d'incident et renvoi à `DECISIONS.md` qui ne contient pas `M-HOOKS-04` | R-06 | voir 3.2 | déjà vu en 3.2 |
| 8 | Tables Pensée → Réalité : non confirmées, et peuvent suggérer l'excuse au modèle | R-13 | — | converge avec la grille (retrait proposé) |
| 9 | Règle « tout par sed » : fossile du flux Claude.ai, pousse des modifications JSON/HTML multi-lignes vers sed plutôt que vers l'outil Edit | R-37→R-39 | — | converge (MÉCANISER) |
| 10 | `/fast` entre en collision avec la commande intégrée | R-27 | — | converge |
| 11 | Seuils de lecture chiffrés (> 5 fichiers, ~10K tokens) : coaching de stratégie | R-29, R-31 | — | converge (FUSIONNER/DÉPLACER) |
| 12 | « Si une règle n'est pas ici, elle n'existe pas » contredit les renvois vers STANDARDS et les skills | en-tête, non compté | — | **nouveau** |
| F1 | Le mode correction rapide autorise un commit direct sans PDR, contre les règles absolues R-01/R-02 | R-27 vs R-01, R-02 | — | **nouveau** — contradiction de règles (L6) |
| F2 | Placeholders jamais remplis (Rôle, Limites bash, `.env`, étape 3, skill diagnostic) | R-18, R-19 | attendu au bootstrap (`[→ ADAPTER]`) | — |
| F3 | `Claude.md` à 499 lignes contre le seuil de ~200 qu'il cite lui-même | R-36 | §Mesures 1.1 | converge |
| F4 | `M-PROC-44`, `LL-T08` cités par le skill wrap-up mais indéfinis dans le projet | R-104 | — | même famille que `DECISIONS.md` en 3.2 : IDs du repo SDLC fuités dans les projets |
| F5 | `STANDARDS.md` compté dans le contexte permanent (M1) mais chargé par rien | R-79→R-100 | `grep -rlE "^@STANDARDS" "$TMP"` → vide | **nouveau** — invalide la définition de M1 |

**Lecture.** L'audit externe confirme 6 dispositions de la grille (R-13, R-27, R-29/R-31, R-37, R-55, R-06) sans avoir vu la grille. Il ajoute surtout quatre défauts du **bootstrap** que l'analyse structurelle de ce Spike ne voyait pas : le nom du fichier (n° 1), le frontmatter des skills (n° 2), les dates figées (n° 3) et le `.gitignore` (n° 5). Trois d'entre eux sont des mécanismes que la prose déclare et que le projet bootstrappé ne fournit pas : chargement de `CLAUDE.md`, déclenchement des skills, `.gitignore`. Le hook inopérant (§Mesures 1.1) et `pre-compact.sh` (§3.2) portent ce total à cinq. Le diff proposé par l'audit n'est pas appliqué (hors périmètre, `$TMP` jetable) : il sert d'entrée au sprint correctif proposé dans la ROADMAP.

---

## Propositions

Rédigées, **jamais appliquées** : aucune entrée n'est insérée dans `07-DECISIONS-SDLC.md`. Les ID sont provisoires et suivent les derniers ID utilisés (`grep -oE "^## M-PROC-[0-9]+" 07-DECISIONS-SDLC.md | sort -V | tail -1` → `M-PROC-48`). Ils sont à renuméroter au moment de l'import. Une proposition « I » est ajoutée aux propositions A→H du PDR : elle est née des constats du bootstrap et c'est un **préalable** à D.

| Code | Proposition | Verdict | Raison (mesure qui tranche) |
|---|---|---|---|
| A | Budget absolu de lignes/règles | **ADAPTÉ** | `Claude.md` à 499 lignes contre 200 (L6). Le budget porte sur le fichier produit par `sdlc-init.sh`, et le cliquet M1 relatif devient un plafond absolu qui descend par paliers |
| B | ID stable + compteurs par règle | **ADAPTÉ** | Les `R-NN` existent désormais (§Grille). Les compteurs sont tenus par `ELAG-2` le temps de la mesure, pas ajoutés au wrap-up de façon permanente : ce serait une règle de plus avant d'en avoir prouvé l'utilité |
| C | Clause d'extinction (expiration sauf preuve d'utilité) | **REJETÉ (prématuré)** | Sans compteurs (B), aucune règle ne peut apporter sa preuve : l'extinction retirerait aussi les 20 règles d'origine `incident` (`grep "^| R-[0-9]" specs/Sprints/AUDIT-ELAGAGE-1.md \| grep -c "\| incident \|"`) |
| D | Prose → renvoi dès qu'un mécanisme garantit la règle | **RETENU, conditionnel à I** | 20 règles `MÉCANISER`. Mais trois mécanismes cités ne marchent pas dans un projet bootstrappé (hook, `pre-compact.sh`, `.gitignore`) : remplacer la prose par un renvoi vers un mécanisme absent supprimerait la règle |
| E | Fusion des couches de vérification | **RETENU** | 3 groupes de §3.1 (critère d'acceptation au wrap-up ×4, plan non prêt ×2, conclusion sans preuve ×5) ; les contrôles de version C1/C2/C9/C10 exclus |
| F | Registre chaud/froid | **ADAPTÉ** | 6 entrées closes = 2 381 mots sur 21 825, soit 11 % (`awk '/^## M-/{id=$2} id ~ /^(M-ARCH-02\|M-ARCH-04\|M-ARCH-06\|M-PROC-27\|M-PROC-29\|M-HOOKS-05)$/' 07-DECISIONS-SDLC.md \| wc -w`). Gain modeste : il faut d'abord un champ **Statut**, sans lequel le tri chaud/froid reste à refaire à la main |
| G | Revue à chaque changement de modèle | **RETENU** | `/doctor prompt-audit` a trouvé, dès sa première exécution, 3 défauts de bootstrap invisibles à l'audit structurel (§3.3) |
| H | Interdiction de la réécriture globale | **RETENU** | L7 ; ce Spike a lui-même évité de réécrire `01` |
| I | Le bootstrap livre les mécanismes que la prose promet | **RETENU (ajout)** | Hook inopérant (`sdlc-init.sh:336`), `CLAUDE.md` absent, `.gitignore` absent, skills sans frontmatter, dates figées, `pre-compact.sh` absent (§Mesures 1.1, §3.2, §3.3) |

### M-ARCH-10 (provisoire) · Le bootstrap livre les mécanismes que la prose promet — préalable à l'élagage

**Retenu :** un sprint Fix avant tout élagage. (1) `sdlc-init.sh` crée `CLAUDE.md` (renommage ou `@Claude.md`) et les outils `grep` sont alignés. (2) Le hook inline lit `tool_input` (aligné sur `08-hooks-TEMPLATE.md:67`). (3) Un `.gitignore` est créé avec `.env` et `.claude/sprint-memory.md`. (4) Les 4 skills ont un frontmatter `name`/`description`. (5) Les dates des gabarits du skill wrap-up restent des placeholders. (6) `pre-compact.sh` est installé, ou sa mention est retirée de `01`. **C5 est étendu** à la copie inline de `sdlc-init.sh`, avec un cas RED.

**Écarté :** élaguer d'abord. Retirer une prose dont le mécanisme est cassé supprime la seule trace de la règle.

**Raison :** quatre mécanismes déclarés par la prose sont absents ou inopérants dans un projet bootstrappé, et aucun contrôle ne l'a vu. C5 ne compare que `08` et les hooks actifs du repo SDLC.

**Impact fichiers :** `sdlc-init.sh`, `sdlc-validate.sh` (C5), `tests/sdlc-validate-test.sh`, `01-Claude-md-TEMPLATE.md`, `03`/`09`/`04b`/`11` (frontmatter).

**Déclencheur de réouverture :** Claude Code change le nom ou la casse du fichier mémoire chargé, ou le schéma JSON de `PreToolUse`.

**Prédiction :** dans un projet bootstrappé neuf, la poussée forcée est bloquée et `CLAUDE.md` existe — vérifié par `F="--for""ce"; printf '{"tool_name":"Bash","tool_input":{"command":"git push %s x"}}' "$F" | bash "$TMP/.claude/hooks/pre-tool-bash.sh"; echo $?` → `2`, et `ls "$TMP"/CLAUDE.md "$TMP"/.gitignore` → 2 fichiers — échéance : sprint Fix bootstrap (ROADMAP §Next).
**Risque :** renommer `Claude.md` casse les scripts et skills qui le citent par son nom (`grep -rl "Claude\.md" .` à relire). Un `CLAUDE.md` chargé sous Linux fait aussi arriver d'un coup les 499 lignes dans le contexte de chaque projet : le risque de densité (L2) passe de théorique à réel. Contrôle mécanique : C5 étendu + cas RED.

### M-PROC-49 (provisoire) · Budget absolu du contexte permanent — remplace la clause relative du cliquet M1

**Retenu :** plafond en lignes du `Claude.md` **produit par `sdlc-init.sh`**, contrôlé par un nouveau contrôle de `sdlc-validate.sh` (bootstrap dans `mktemp -d`, puis `wc -l`). Paliers : ≤ 499 immédiatement (gel), ≤ 350 après le sprint d'import élagage, ≤ 200 cible (L6). Au-delà du plafond, la règle « une entrée, une sortie » s'applique : tout ajout dans `01` retire ou déplace une règle de même taille, citée par son `R-NN`. M1 compte `STANDARDS.md` seulement s'il est importé par `@` (§3.3, F5).

**Écarté :** plafond en mots (M1 actuel, relatif, sans retrait exigé) ; plafond en nombre de règles seul (l'unité de §1.4 est une convention de ce Spike, pas encore éprouvée).

**Raison :** §Mesures 1.2 — une seule baisse en 24 commits. Le cliquet M1 ne retire rien.

**Impact fichiers :** `sdlc-validate.sh`, `tests/sdlc-validate-test.sh`, `02-STANDARDS-TEMPLATE.md §Cliquet`, `09-retrospective-SKILL-TEMPLATE.md §M1/M2`.

**Déclencheur de réouverture :** la doc Claude Code change sa cible de lignes, ou `ELAG-2` montre que le respect des règles ne varie pas avec la taille.

**Prédiction :** la taille du `Claude.md` bootstrappé ne dépasse plus jamais 499 lignes et atteint ≤ 350 au sprint d'import — vérifié par `( cd "$TMP" && wc -l < Claude.md )` à chaque commit qui touche `01` — échéance : sprint « Import élagage » (ROADMAP §Later).
**Risque :** déplacer des règles vers des fichiers non chargés revient à les retirer sans le dire (L6 : un `@import` ne réduit pas le coût, un fichier non importé n'est pas lu). Contrôle mécanique : toute règle `DÉPLACER` doit avoir une destination effectivement chargée (skill déclenché, `.claude/rules/` avec `paths:`), vérifiée par 3.2 rejoué.

### M-PROC-50 (provisoire) · Identifiants R-NN et compteurs d'usage, limités à la mesure ELAG-2

**Retenu :** la §Grille de ce rapport est le référentiel `R-NN`. Pendant `ELAG-2`, chaque `/wrap-up` du projet Job search ajoute une ligne `USAGE` dans `sprint-memory.md` : règles servies, gênantes ou non sollicitées, citées par leur `R-NN`. Une rétro agrège ensuite les lignes.

**Écarté :** compteurs permanents dans le wrap-up du modèle, avant d'avoir mesuré qu'ils servent (ce serait une règle de plus, contraire à A).

**Raison :** L7 (articles unitaires avec compteurs) ; ce repo n'a pas de données d'usage.

**Impact fichiers :** aucun template. Seuls le PDR `ELAG-2` et le `sprint-memory.md` du projet Job search sont concernés.

**Déclencheur de réouverture :** fin d'`ELAG-2`. Si les compteurs ont changé au moins une disposition, les rendre permanents.

**Prédiction :** `ELAG-2` produit au moins une ligne `USAGE` par wrap-up et confirme ou infirme les 7 retraits proposés — vérifié par `grep -c "USAGE" docs/LESSONS_LEARNED.md` (projet Job search) ≥ nombre de sprints `ELAG-2` — échéance : rétro de clôture `ELAG-2`.
**Risque :** l'auto-déclaration « règle servie » par l'agent est peu fiable (L1 : précision 11,8 % sur ses propres prédictions). Contrôle mécanique : ne compter comme « servie » qu'une règle dont l'effet laisse une trace (fichier, commande, entrée de mémoire), citée dans la ligne.

### M-TMPL-10 (provisoire) · Prose → renvoi d'une ligne quand un mécanisme vérifié garantit la règle

**Retenu :** les 20 lignes `MÉCANISER` de la grille deviennent chacune un renvoi d'une ligne vers leur mécanisme (skill, outil natif, hook). Les résumés de skills dans `Claude.md §Wrap-up` (R-66→R-76) se réduisent à une ligne de déclenchement par skill (`00-CONTEXT §5.1`). **Condition :** le mécanisme est vérifié en marche dans un projet bootstrappé avant que la prose soit retirée (`M-ARCH-10` d'abord).

**Écarté :** retirer la prose sans renvoi (perte de la règle si le mécanisme casse).

**Raison :** L1 (prompt seul sous la base), L6 (bloquer = hook, pas prose) ; §3.3 (les audits interne et externe convergent sur R-37, R-55, R-27).

**Impact fichiers :** `01-Claude-md-TEMPLATE.md`, `02-STANDARDS-TEMPLATE.md` (§DoD R-84/R-85, R-88).

**Déclencheur de réouverture :** un mécanisme visé est retiré ou cesse de fonctionner (C5 rouge, skill renommé).

**Prédiction :** `Claude.md` bootstrappé perd au moins 30 lignes sans qu'aucune règle disparaisse de la grille — vérifié par `bash compter-regles.sh "$TMP" "$SDLC"` (avant/après) et `( cd "$TMP" && wc -l < Claude.md )` — échéance : sprint « Import élagage ».
**Risque :** un renvoi vers un skill sans frontmatter n'est jamais déclenché (§3.3 n° 2). Contrôle mécanique : C4 étendu pour exiger le frontmatter `description` sur chaque skill.

### M-PROC-51 (provisoire) · Fusion des couches de vérification qui ciblent le même défaut au même moment

**Retenu :** trois fusions de §3.1. (1) La revue objectif §0e absorbe la couche 3 de l'Adversarial Review et l'étape 0b ; la DoD reste la cible du renvoi. (2) L'auto-revue en 3 passes et le verdict gate deviennent une seule auto-évaluation avant l'aval. (3) R-03, R-15, R-40 et R-42 fusionnent dans la clause anti-complaisance (R-62). Les couches 1-2 de l'Adversarial Review restent intactes (captures réelles).

**Écarté :** fusionner les contrôles de version C1/C2/C9/C10 (mécanismes sans coût de contexte, chacun avec une capture).

**Raison :** L1 (effets non additifs) ; aucune capture tracée pour l'auto-revue, le verdict gate, §0e ni la couche 3.

**Impact fichiers :** `01-Claude-md-TEMPLATE.md` (§Analyse, §Rôle, §Test), `03-wrap-up-SKILL-TEMPLATE.md` (0b, 0e, 0f) + skill vivant.

**Déclencheur de réouverture :** `ELAG-2` trace une capture propre à une couche fusionnée.

**Prédiction :** les revues d'objectif ou d'acceptation exécutées au wrap-up d'un sprint M passent de 5 (0b, 0e, couches 1-3) à 3 (0e, couches 1-2), sans hausse des défauts trouvés après commit — vérifié par `grep -cE "^### 0[a-f]\. " .claude/skills/wrap-up/SKILL.md` (6 → 5) et `grep -c "^\*\*Couche" .claude/skills/wrap-up/SKILL.md` (3 → 2) et le relevé `Corrections ajustées vs spec` des 3 sprints suivants — échéance : rétro qui suit l'import.
**Risque :** une capture rare de la couche 3 serait perdue. Contrôle mécanique : la checklist 3.5 garde la ligne « chaque critère d'acceptation coché avec sa commande ».

### M-PROC-52 (provisoire) · Registre chaud/froid avec champ Statut

**Retenu :** champ obligatoire `**Statut :** En vigueur | Modifiée par M-… | Close | Remplacée par M-…` sur chaque entrée ; `07-DECISIONS-SDLC.md` ne garde que les entrées `En vigueur`/`Modifiée`, les autres vont dans `07b-DECISIONS-ARCHIVE.md`, non chargé dans le projet Claude.ai (même schéma que `SESSION_BRIDGE §Actif/§Archive`, R-116). Premier lot : les 6 entrées closes de §Mesures 1.3.

**Écarté :** archive sans champ de statut (le tri resterait implicite, contraire à INV-2).

**Raison :** §Mesures 1.3 — aucun champ de statut, 6 décisions closes chargées, dont deux qui nomment des fichiers disparus.

**Impact fichiers :** `07-DECISIONS-SDLC.md`, nouveau `07b-…`, `00-CONTEXT.md §1`, `sdlc-validate.sh` (C6 carte, C7 sur les deux fichiers).

**Déclencheur de réouverture :** le registre chaud repasse au-dessus de sa taille d'après archivage.

**Prédiction :** le registre chargé dans Claude.ai baisse d'au moins 2 381 mots (11 %) au premier lot — vérifié par `wc -w 07-DECISIONS-SDLC.md` avant/après — échéance : sprint « Import élagage ».
**Risque :** une décision archivée cesse d'être consultée alors qu'une règle vivante en dépend. Contrôle mécanique : C7 étendu pour signaler tout `M-…` cité dans un template et présent seulement dans l'archive.

### M-PROC-53 (provisoire) · Revue d'instructions à chaque changement de modèle

**Retenu :** l'en-tête de chaque spec de sprint porte le modèle exécutant (ex : `claude-opus-5-5`). Quand il change par rapport au sprint précédent, le sprint suivant de type SDLC-Sync ou la rétro suivante lance `/doctor prompt-audit` dans un projet bootstrappé neuf (`mktemp -d`) et en consigne les constats. L'humain lance la commande : Claude ne peut pas la lancer lui-même.

**Écarté :** revue périodique au calendrier (pas de lien avec la cause : les instructions vieillissent avec le modèle, pas avec le temps).

**Raison :** §3.3 — premier passage : 12 constats et 6 signalements, dont 8 marqués « nouveau » en §3.3 (`awk '/^### 3.3/{f=1} /^## Propositions/{f=0} f' specs/Sprints/AUDIT-ELAGAGE-1.md | grep "^| " | grep -c "nouveau"`) ; 9 règles à faiblesse de modèle (`Modèle antérieur ? oui`) : R-12, R-13, R-31, R-35, R-37, R-38, R-39, R-57, R-62 (`grep "^| R-[0-9]" specs/Sprints/AUDIT-ELAGAGE-1.md | grep -c "| oui |"`).

**Impact fichiers :** `04-sprint-PDR-TEMPLATE.md` (en-tête), `09-retrospective-SKILL-TEMPLATE.md` (étape conditionnelle).

**Déclencheur de réouverture :** la commande `/doctor prompt-audit` disparaît ou change de portée.

**Prédiction :** au prochain changement de modèle, un rapport `/doctor prompt-audit` est consigné dans le sprint suivant — vérifié par `grep -l "prompt-audit" specs/Sprints/*.md` — échéance : premier changement de modèle après l'import.
**Risque :** l'audit propose des réécritures globales (son diff touche 7 fichiers d'un coup), le mode d'échec L7. Contrôle mécanique : ses propositions passent par `M-PROC-54` (une décision par retrait).

### M-PROC-54 (provisoire) · Élagage règle par règle, jamais par réécriture globale

**Retenu :** tout retrait, fusion ou déplacement cite un `R-NN` et une décision. Un commit d'élagage touche au plus les règles listées dans son PDR. Toute demande de « version raccourcie » d'un template est refusée en HALT-SCOPE.

**Écarté :** réécriture d'ensemble de `01` par un agent (L7 : effondrement du contexte, 18 282 → 122 tokens).

**Raison :** L7 ; §Mesures 1.2 — les 50 lignes supprimées de `01` sont déjà des réécritures, sans traçabilité règle par règle.

**Impact fichiers :** `04-sprint-PDR-TEMPLATE.md` (type « Élagage » : champ `Règles visées : R-…`), `00-CONTEXT.md §4`.

**Déclencheur de réouverture :** aucun prévu.

**Prédiction :** chaque commit d'élagage ne change le comptage `compter-regles.sh` que des règles listées dans son PDR — vérifié par `diff <(bash compter-regles.sh "$TMP_avant" "$SDLC" --liste | cut -d: -f4-) <(bash compter-regles.sh "$TMP_après" "$SDLC" --liste | cut -d: -f4-)` — échéance : sprint « Import élagage ».
**Risque :** les déplacements font bouger les numéros de ligne, ce qui crée un faux diff. Contrôle mécanique : comparer sur le texte (`cut -d: -f4-`), pas sur les numéros de ligne.

---

## Verdict

1. **Le modèle grossit sans jamais retirer.** `01` a été multiplié par 3,2 en mots en 115 jours, avec une seule baisse de 10 mots. Le registre a été multiplié par 10,7, sans aucun retrait et sans champ de statut. Le cliquet M1 freine la croissance mais ne retire rien (§Mesures 1.2, 1.3).
2. **Le bootstrap a d'abord un problème de chargement.** Sous Linux, `Claude.md` n'est pas chargé (Claude Code charge `CLAUDE.md`) et `STANDARDS.md` n'est importé par rien. Les 691 lignes de règles ne pèsent donc que si un agent les lit volontairement. À cela s'ajoutent un hook livré inopérant, pas de `.gitignore` et des skills sans frontmatter : la prose promet des mécanismes que le projet ne reçoit pas. **Premier sprint à faire : `M-ARCH-10` (Fix bootstrap), avant tout élagage.**
3. **Si le fichier est chargé, il fait 2,5 fois la cible** (499/200 lignes). La grille classe les 134 règles : 61 GARDER (dont 32 mécanismes sans coût de contexte), 23 FUSIONNER, 23 DÉPLACER, 20 MÉCANISER, 7 retraits proposés. Les 7 retraits sont provisoires.
4. **Où élaguer d'abord** (gain maximal, risque minimal) : les tables de rationalisation (R-13, 50 lignes, non confirmées par `M-PROC-35`) ; les résumés de skills dans `Claude.md` (R-66→R-77) ; les règles de portée rare chargées à chaque session (R-26, R-36, R-56, R-57, R-58/R-59) ; les quatre groupes de doublons (R-03/R-15/R-40/R-42 → R-62, R-28/R-29 → R-24, R-07/R-97 → R-92, R-63→R-65 → R-48).
5. **Ce qu'`ELAG-2` doit confirmer** dans le projet Job search, avec les `R-NN` de cette grille : (a) les 7 retraits proposés ; (b) l'absence de capture du verdict gate, de l'auto-revue et de §0e, avant de les fusionner (`M-PROC-51`) ; (c) si les règles importées sans incident local (29 règles `import`) servent réellement ; (d) si `CLAUDE.md` y est chargé, et quel système de fichiers y est utilisé.

Comptes du verdict : `grep "^| R-[0-9]" specs/Sprints/AUDIT-ELAGAGE-1.md | grep -c "| import |"` → 29 (et 85 `préventif`, 20 `incident`).
