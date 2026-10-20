# Sprint ELAG-1 — Audit d'élagage théorique du modèle SDLC
<!-- Template SDLC v2.4 · Destination : specs/Sprints/sprint-ELAG-1-audit-elagage-theorique.md (repo SDLC) -->
<!-- PDR rédigé en session Claude.ai le 20/10/2026 — revue article AHE (arXiv 2604.25850) + littérature -->

**Type :** Spike
**Taille :** M
**Surface :** lecture seule — `01`→`11-*-TEMPLATE.md`, `07-DECISIONS-SDLC.md`, `sdlc-init.sh`, `sdlc-validate.sh`, historique git · écriture — `specs/Sprints/AUDIT-ELAGAGE-1.md` (nouveau), `docs/ROADMAP.md`, `CHANGELOG.md`, `docs/LESSONS_LEARNED.md`
**Risque :** Faible (aucun template modifié)

---

## Contexte

Le modèle n'a, à notre connaissance, jamais retiré de règle : chaque sprint, rétro ou import (BMad, GSD, Harness, Strands) en ajoute. Le seul garde-fou de taille est le cliquet M1 (`M-PROC-42`). Il est relatif (+10 % entre deux rétros), mesure des mots et non des règles, et exige une « piste d'allègement », pas un retrait. La revue du 20/10/2026 (article AHE + littérature, §Références) indique que la densité d'instructions dégrade leur respect, et que les couches redondantes se gênent. Ce repo est un réceptacle théorique : il ne produit pas de données d'usage réel des règles. Ce Spike fait donc l'audit **structurel** ; `ELAG-2` mesurera l'**usage réel** dans le projet Job search, avec la grille produite ici.

---

## Objectif

Livrer `specs/Sprints/AUDIT-ELAGAGE-1.md`, qui :
1. chiffre l'empreinte d'instructions d'un projet fraîchement bootstrappé et son évolution historique, chaque chiffre accompagné de sa commande ;
2. classe chaque règle dans une grille avec une disposition proposée ;
3. rédige, sans les appliquer, les décisions des mécanismes d'élagage retenus, chacune avec une prédiction réfutable ;
4. fournit une grille réutilisable telle quelle par `ELAG-2`.

---

## Comportement actuel → cible

- **Actuel :** la taille du modèle n'est suivie qu'en variation relative de mots (M1/M2). Aucune vue « règle par règle » n'existe : origine, mécanisme associé, doublons, recouvrements. Aucun mécanisme de retrait n'existe.
- **Cible :** une grille exhaustive des règles avec disposition proposée (GARDER / FUSIONNER / DÉPLACER / MÉCANISER / CANDIDAT RETRAIT). L'empreinte réelle du bootstrap est mesurée contre la cible documentée (< 200 lignes par CLAUDE.md). Des décisions d'élagage sont rédigées et prêtes pour un sprint d'import.

---

## Portée

**Inclus :**
- Phase 1 — mesures : empreinte du bootstrap, historique ajouts/suppressions, registre `07-DECISIONS-SDLC.md`
- Phase 2 — grille de classement de chaque règle
- Phase 3 — cartographie des recouvrements entre couches de vérification, et des références cassées
- Phase 4 — propositions A→H (§Protocole) : décisions rédigées dans le rapport, avec prédiction et risque
- `docs/ROADMAP.md` : ajout de `ELAG-2` (§Next) et d'un sprint d'import (§Later)

**Exclu (explicitement) :**
- Toute modification d'un template numéroté, de `sdlc-validate.sh`, de `sdlc-init.sh`, ou des `Claude.md` / `STANDARDS.md` / `.claude/` de ce repo
- Le retrait effectif d'une règle
- Toute insertion d'entrée dans `07-DECISIONS-SDLC.md` : les décisions sont rédigées dans le rapport uniquement, comme pour l'audit Strands
- Toute ablation expérimentale (retirer une règle pendant N sprints pour observer)
- Le projet Job search (→ `ELAG-2`)

---

## Références — littérature recueillie en session Claude.ai (20/10/2026)

> Chiffres repris des pages et abstracts lus en session. Avant de citer l'un d'eux **dans un template**, le revérifier par `WebFetch` (`Claude.md §Analyse §Vérification factuelle`). Dans le rapport, les citer tels quels avec la source. Paraphraser, ne jamais recopier de passage.

| # | Source | Constat | Implication pour l'audit |
|---|--------|---------|--------------------------|
| L1 | AHE — arXiv 2604.25850 (Lin et al., 2026) | Ablation sur Terminal-Bench 2 : mémoire seule 75,3 %, outils seuls 73,0 %, middleware seul 71,9 %, **prompt seul 67,4 %** (sous la base, 69,7 %). Gains individuels cumulés +11,1 pts contre +7,3 pts pour l'ensemble : effets non additifs, plusieurs couches poussaient la même vérification de clôture. Prédictions de régression à peine 2× meilleures que le hasard (précision 11,8 %). | Une règle en prose sans mécanisme vaut peu. Des vérifications qui se recouvrent se gênent. Les risques de régression déclarés par l'agent sont peu fiables. |
| L2 | IFScale — arXiv 2507.11538 (NeurIPS 2025) | 20 modèles, jusqu'à 500 instructions simultanées : les meilleurs n'en respectent qu'environ 68 %. Biais en faveur des instructions placées en premier. | Chaque règle ajoutée dégrade le respect des autres ; la position compte. |
| L3 | Chroma — *Context Rot* (2025) | 18 modèles : la fiabilité baisse avec la longueur d'entrée. Un seul contenu proche mais non pertinent réduit déjà la précision, et l'effet croît avec la longueur. | Des règles quasi-doublons font du bruit l'une pour l'autre. |
| L4 | Gloaguen et al. — *Evaluating AGENTS.md*, arXiv 2602.11988 (ICLR 2026) | Les fichiers de contexte n'améliorent généralement pas la réussite des tâches et augmentent le coût d'inférence de plus de 20 %. Les agents suivent bien les instructions. Les vues d'ensemble du repo n'aident pas. | Réserver le contexte permanent aux pratiques non standard ; évaluer chaque ajout avant de le garder. |
| L5 | Anthropic — *Effective context engineering for AI agents* | Viser le plus petit ensemble de tokens à fort signal. Partir d'un prompt minimal et ajouter seulement face à un échec observé. Préférer quelques exemples canoniques aux listes de cas limites. Les outils qui se recouvrent sont un mode d'échec courant. | Critère « origine = échec observé » dans la grille ; les règles préventives sont suspectes. |
| L6 | Doc Claude Code — `code.claude.com/docs/en/memory` | Cible : moins de 200 lignes par CLAUDE.md, l'adhérence baisse au-delà. Les imports `@` ne réduisent pas le coût. Deux instructions contradictoires : Claude peut en suivre une arbitrairement. Recommande une revue périodique. Commande `/doctor prompt-audit` : instructions écrites pour d'anciens modèles, fichiers inexistants, contradictions. CLAUDE.md est du contexte, pas une contrainte ; pour bloquer une action, utiliser un hook `PreToolUse`. | Budget absolu chiffré disponible (lève l'objection de `M-PROC-42`) ; la prose doublée d'un hook est redondante. |
| L7 | ACE — arXiv 2510.04618 (ICLR 2026) | Réécrire globalement le contexte provoque son effondrement : 18 282 → 122 tokens, précision 66,7 % → 57,1 %, sous la base sans contexte (63,7 %). Remède : articles unitaires avec ID et compteurs utile/nuisible, déduplication et élagage article par article. | Ne jamais élaguer par réécriture globale ; retrait règle par règle, avec un ID et un compteur. |

---

## Protocole

### Phase 1 — Mesures *(chaque valeur reportée dans le rapport porte sa commande entre backticks — `LL-T14`)*

**1.1 Empreinte d'un projet fraîchement bootstrappé** — ce qu'un projet reçoit réellement :
```bash
SDLC="$PWD"; TMP="$(mktemp -d)"
git -C "$TMP" init -q
( cd "$TMP" && bash "$SDLC/sdlc-init.sh" "Projet Audit" )
( cd "$TMP" && wc -l -w Claude.md STANDARDS.md .claude/skills/*/SKILL.md )
```
Reporter le contexte chargé à chaque session : `Claude.md` + `STANDARDS.md`, le plancher M1. Le comparer à la cible L6 (200 lignes par fichier). Garder `$TMP` jusqu'à la Phase 3, puis `rm -rf "$TMP"`.

**1.2 Historique — le modèle ne fait-il que grossir ?**
```bash
for f in 01-Claude-md-TEMPLATE.md 02-STANDARDS-TEMPLATE.md 03-wrap-up-SKILL-TEMPLATE.md \
         04-sprint-PDR-TEMPLATE.md 08-hooks-TEMPLATE.md 09-retrospective-SKILL-TEMPLATE.md; do
  git log --numstat --format= -- "$f" | awk -v f="$f" '{a+=$1; d+=$2} END {print f, "ajouts=" a, "suppressions=" d}'
done
for c in $(git log --format=%h --reverse -- 01-Claude-md-TEMPLATE.md); do
  printf "%s %s %s\n" "$c" "$(git log -1 --format=%ad --date=short "$c")" "$(git show "$c":01-Claude-md-TEMPLATE.md | wc -w)"
done
```
Reporter le ratio ajouts/suppressions par fichier et la courbe de taille de `01-Claude-md-TEMPLATE.md`. Les lignes supprimées sont surtout des réécritures, pas des retraits. Le dire, et compter à part les retraits nets de règle identifiables dans le CHANGELOG.

**1.3 Registre `07-DECISIONS-SDLC.md`** — rappel : il est chargé dans chaque conversation Claude.ai (`M-ARCH-01`).
```bash
grep -c "^## M-" 07-DECISIONS-SDLC.md
wc -l -w 07-DECISIONS-SDLC.md
grep -cE "^## M-.*(retrait|retiré|suppression|abandon)" 07-DECISIONS-SDLC.md
```
Classer chaque entrée : **ajout de règle** / **modification** / **retrait de règle** / **décision close ou remplacée**. Le dernier statut détermine ce qui pourrait passer en archive froide (proposition F).

**1.4 Unité de comptage — à fixer avant la Phase 2 et à écrire dans le rapport.**
Une règle, c'est :
- chaque puce ou ligne numérotée d'une section normative de `Claude.md` et `STANDARDS.md` du projet bootstrappé (`$TMP`) ;
- chaque section activée de `pre-tool-bash.sh` ;
- chaque étape obligatoire de `wrap-up` et `retrospective` ;
- chaque fonction `check_cN` de `sdlc-validate.sh`.

Écrire la commande de comptage utilisée et le total sous la forme exacte `Règles comptées : N — commande : \`...\``. Le critère d'acceptation 3 en dépend.

### Phase 2 — Grille de classement

Une ligne par règle, ID provisoire `R-NN` (stable : `ELAG-2` le réutilise) :

| Colonne | Contenu |
|---------|---------|
| ID | `R-NN` |
| Emplacement | fichier + §section |
| Énoncé | paraphrase ≤ 12 mots |
| Décision source | `M-XXXX-NN`, ou `aucune` |
| Origine | `incident` (incident ou LL cité) · `import` (BMad/GSD/Harness/Strands sans incident local) · `préventif` |
| Forme | `prose` · `prose+mécanisme` · `mécanisme` |
| Mécanisme | hook / `check_cN` / skill / aucun |
| Recouvre | IDs des règles qui ciblent le même défaut |
| Portée | `toujours` · `type de sprint X` · `taille M/L` · `rare` |
| Modèle antérieur ? | oui / non / inconnu — règle compensant une faiblesse de modèle documentée à l'époque |
| Disposition | `GARDER` · `FUSIONNER` (avec R-xx) · `DÉPLACER` (skill / `.claude/rules/` / archive) · `MÉCANISER` (prose → renvoi d'une ligne) · `CANDIDAT RETRAIT` |
| Justification | 1 ligne |

**Règles de disposition :**
- **Barrière de Chesterton :** aucun `CANDIDAT RETRAIT` sans avoir lu la décision source et la citer. S'il n'y en a pas, l'écrire (`aucune`) : c'est en soi un signal (règle implicite, contraire à INV-2).
- Forme `prose+mécanisme` → `MÉCANISER` par défaut : la prose devient un renvoi d'une ligne (L1, L6).
- Portée ≠ `toujours` → `DÉPLACER` vers le skill ou le fichier chargé au moment voulu, par défaut (L5, INV-3).
- Repo théorique, sans donnée d'usage : tout `CANDIDAT RETRAIT` est marqué `provisoire — à confirmer par ELAG-2`.

### Phase 3 — Recouvrements et cohérence

**3.1 Matrice des couches de vérification.** Couches : vérification factuelle, auto-revue en 3 passes, verdict gate PASS/CONCERNS/FAIL, Plan de test / niveau A, revue objectif §0e, Adversarial Review (3 couches), DoD, `sdlc-validate.sh` (chaque contrôle). Pour chacune : **moment** (analyse / exécution / wrap-up / commit) · **défaut attrapé** · **preuve d'une capture réelle** (citation `CHANGELOG §Corrections ajustées vs spec` ou `LESSONS_LEARNED`, avec `grep -n`). Lister les paires qui ciblent le même défaut au même moment : ce sont des candidates à la fusion (L1, effets non additifs).

**3.2 Références cassées** (proxy mécanique d'une partie de `/doctor prompt-audit`) :
```bash
( cd "$TMP" && grep -ohE "[A-Za-z0-9_./-]+\.(md|sh|json)" Claude.md STANDARDS.md .claude/skills/*/SKILL.md \
  | sort -u | while read -r f; do [ -e "$f" ] || echo "ABSENT: $f"; done )
```
Trier les résultats : fichier créé plus tard dans la vie du projet (normal) / référence réellement cassée.

**3.3 `/doctor prompt-audit`** — commande intégrée à la CLI, que Claude ne peut pas lancer lui-même. Vérifier qu'elle existe dans la version installée (`claude --version`). Puis demander à l'humain de la lancer dans `$TMP` et de coller le rapport. Consigner en `QUESTION` dans `sprint-memory.md`. Si la commande est absente ou si l'humain décline : l'écrire dans le rapport et s'appuyer sur 3.2 seul.

### Phase 4 — Propositions (rédigées dans le rapport, jamais appliquées)

Évaluer chacune contre les mesures des Phases 1 à 3 : retenir, adapter ou rejeter, avec la raison.

| Code | Proposition |
|------|-------------|
| A | **Budget absolu** : plafond de lignes et de règles pour le contexte permanent, contrôlé par `sdlc-validate.sh` ; au-delà, règle « une entrée, une sortie ». Valeur proposée tirée de la mesure 1.1 et de L6. |
| B | **ID stable + compteurs par règle** (L7) : chaque règle porte un `R-NN` ; le wrap-up note servie / gênante / non sollicitée ; la rétro agrège. |
| C | **Clause d'extinction** : toute règle expire à une échéance (par exemple 2 rétros) sauf reconfirmation par une preuve d'utilité. Charge de la preuve inversée. |
| D | **Prose → renvoi** dès qu'un mécanisme garantit la règle. |
| E | **Fusion** des couches de vérification identifiées en 3.1. |
| F | **Registre chaud/froid** : `07-DECISIONS-SDLC.md` séparé en décisions en vigueur et archive non chargée par défaut (même pattern que `SESSION_BRIDGE §Actif/§Archive`). |
| G | **Revue à chaque changement de modèle** : `/doctor prompt-audit` + modèle noté dans l'en-tête de chaque sprint. |
| H | **Interdiction de la réécriture globale** : retrait règle par règle, diff relu, une décision par retrait (L7). |

Pour chaque proposition **retenue ou adaptée**, rédiger l'entrée au format du registre (`M-XXXX-NN` provisoire, Retenu / Écarté / Raison / Impact fichiers / Déclencheur de réouverture), avec deux champs en plus :

```
**Prédiction :** [effet observable] — vérifié par `[commande]` — échéance : [sprint ou rétro]
**Risque :** [ce qui pourrait régresser — rappel L1 : risque déclaré peu fiable, prévoir un contrôle mécanique]
```

### Livrable — structure de `specs/Sprints/AUDIT-ELAGAGE-1.md`

```
# Audit d'élagage 1 — modèle SDLC (théorique)
## Mesures          ← Phase 1, chaque valeur avec sa commande
## Grille           ← Phase 2, une ligne par règle (R-NN)
## Recouvrements    ← Phase 3
## Propositions     ← Phase 4, entrées rédigées avec Prédiction / Risque
## Verdict          ← 5-10 lignes : le modèle grossit-il, de combien, où élaguer d'abord, ce que ELAG-2 doit confirmer
```

---

## Option retenue — alternatives écartées

**Retenue :** audit en lecture seule, structurel dans ce repo ; l'usage réel est mesuré dans un projet concret (`ELAG-2`) avant tout retrait.

**Écartées :**
- Élaguer directement les templates — aucune preuve d'inutilité règle par règle, et risque d'effondrement du contexte (L7).
- Demander à Claude une version raccourcie de `01-Claude-md-TEMPLATE.md` — c'est exactement le mode d'échec documenté par L7.
- Ablation expérimentale (retirer une règle N sprints) — avec un sprint à la fois, puissance statistique insuffisante pour conclure.
- Gabarit `12-audit-externe-TEMPLATE.md` — conçu pour comparer un framework tiers, pas pour un audit interne ; seul son principe de verdicts étiquetés est repris.

**Sacrifices délibérés :** sans données d'usage, les `CANDIDAT RETRAIT` restent provisoires jusqu'à `ELAG-2`.

---

## Contraintes techniques / produit

- `sdlc-init.sh` est exécuté uniquement dans un répertoire créé par `mktemp -d`, puis supprimé.
- Les commandes de mesure sont reproductibles telles quelles et recopiées dans le rapport.
- La grille est en Markdown tabulaire, une ligne par règle commençant par `| R-` (ELAG-2 la parse).

**Interdit :**
- Modifier un fichier `NN-*.md`, `sdlc-validate.sh`, `sdlc-init.sh`, ou les `Claude.md` / `STANDARDS.md` / `.claude/` de ce repo
- Insérer une entrée dans `07-DECISIONS-SDLC.md` (décisions rédigées dans le rapport seulement)
- Écrire un total ou un comptage sans la commande qui le produit (`M-PROC-48`)
- Recopier un passage des sources §Références (paraphraser)
- Proposer un retrait sans citer la décision source ou `aucune`

---

## Dépendances

**Inputs requis :**
- [x] `sdlc-init.sh` bootstrappe avec succès dans un repo vierge (vérifié par 1.1 ; sinon → BLOQUANT)
- [x] `bash sdlc-validate.sh` passe tous ses contrôles au démarrage (état de référence) — 10/10, exit 0 (20/10/2026)
- [x] Historique git complet (pas de clone superficiel : `git rev-parse --is-shallow-repository` → `false`)

**Outputs produits :**
- [x] `specs/Sprints/AUDIT-ELAGAGE-1.md` et sa `§Grille` (IDs `R-NN`), réutilisée par `ELAG-2`
- [x] `docs/ROADMAP.md` : `ELAG-2` en §Next, « Import élagage » en §Later

**Règle :** avant de démarrer, vérifier que tous les inputs requis cochés existent et sont dans l'état attendu. Si un input manque ou a changé → signaler comme BLOQUANT avant toute analyse.

---

## Critères d'acceptation

*(La Definition of Done — `STANDARDS.md §Definition of Done` — s'applique en plus.)*

- [x] `test -f specs/Sprints/AUDIT-ELAGAGE-1.md && echo OK` → `OK`
- [x] `grep -cE "^## (Mesures|Grille|Recouvrements|Propositions|Verdict)$" specs/Sprints/AUDIT-ELAGAGE-1.md` → `5`
- [x] La grille couvre toutes les règles comptées :
  ```bash
  F=specs/Sprints/AUDIT-ELAGAGE-1.md
  N=$(grep -oE "Règles comptées : [0-9]+" "$F" | grep -oE "[0-9]+")
  R=$(grep -c "^| R-[0-9]" "$F")
  [ -n "$N" ] && [ "$N" -eq "$R" ] && echo OK
  ```
  → `OK`
- [x] Tout candidat au retrait cite sa source : `grep "CANDIDAT RETRAIT" specs/Sprints/AUDIT-ELAGAGE-1.md | grep -vcE "M-[A-Z]+-[0-9]+|aucune"` → `0`
- [x] Chaque valeur chiffrée de §Mesures porte sa commande : `awk '/^## Mesures$/{f=1;next} /^## /{f=0} f' specs/Sprints/AUDIT-ELAGAGE-1.md | grep -E "^\|.*[0-9]" | grep -vc '`'` → `0`
- [x] Chaque proposition retenue a sa prédiction et son risque : `grep -c "^\*\*Prédiction :\*\*" specs/Sprints/AUDIT-ELAGAGE-1.md` égal à `grep -c "^\*\*Risque :\*\*" specs/Sprints/AUDIT-ELAGAGE-1.md`, et ≥ 1
- [x] Aucun template ni script modifié, avant commit : `git status --porcelain | awk '{print $2}' | grep -E "^[0-9]{2}[a-z]?-|^sdlc-|^Claude\.md$|^STANDARDS\.md$|^\.claude/"` → vide
- [x] Répertoire temporaire supprimé : `test -d "$TMP" && echo PRESENT || echo OK` → `OK`
- [x] Tests niveau A : `bash sdlc-validate.sh` → tous les contrôles ✅, exit 0
- [x] CHANGELOG mis à jour

---

## Risques

- **La grille devient un inventaire interminable** : probabilité moyenne · fixer l'unité de comptage (1.4) avant de commencer. Si N > 150, grouper les puces d'une même sous-section en une ligne et l'écrire dans le rapport.
- **Biais vers GARDER** (Claude classe des règles qu'il a lui-même aidé à écrire) : probabilité moyenne · appliquer mécaniquement les dispositions par défaut de la Phase 2 (prose+mécanisme → MÉCANISER, portée ≠ toujours → DÉPLACER), et ne justifier que les écarts à ce défaut.
- **`sdlc-init.sh` échoue dans le répertoire temporaire** : probabilité faible (corrigé, voir registre) · BLOQUANT, Phase 1.1 mesurée alors sur les templates bruts, signalé dans le rapport.

---

## Pre-mortem

> Si ce sprint échoue ou dépasse 2× l'estimation, la cause la plus probable est :

la Phase 2 menée règle par règle en relisant tout `07-DECISIONS-SDLC.md` pour chacune. Mitigation : chercher la décision source par `grep -n` sur un mot-clé de la règle (INV-3), jamais en lecture intégrale, et accepter `aucune` après deux recherches infructueuses.

---
<!-- FIN PRD — La section Handoff est complétée par Claude Code en début de session -->

## Handoff Claude Code

> Ce PDR ne remplace pas `Claude.md §Démarrage` — les 4 étapes (4a créer le
> fichier spec · 4b initialiser la mémoire sprint · 4c charger les fichiers ·
> 4d écrire le §Plan de développement) restent dues même si ce Handoff n'en
> détaille qu'une partie ci-dessous.

**Chargement immédiat :** ce PDR · `00-CONTEXT.md §3 Invariants` · `01-Claude-md-TEMPLATE.md` · `02-STANDARDS-TEMPLATE.md`

**Chargement différé (Phase 2-3) :** `03-wrap-up-SKILL-TEMPLATE.md` · `09-retrospective-SKILL-TEMPLATE.md` · `08-hooks-TEMPLATE.md` · `sdlc-validate.sh` · `07-DECISIONS-SDLC.md` par `grep -n` ciblé uniquement

**Instructions spécifiques :**
- Ordre strict : Phase 1 → 4. La grille ne commence qu'une fois l'unité de comptage écrite dans le rapport.
- Rapport écrit tôt, puis complété phase par phase (pas de rédaction finale d'un bloc).
- Demande d'aval après la Phase 1 (mesures + unité de comptage), puis à nouveau avant le commit.
- Un seul commit final : `docs(sdlc): Spike ELAG-1 — audit d'élagage théorique`.
- Reporter tout écart au plan dans ce fichier (§Corrections ajustées vs spec).

**Exécution (20/10/2026, Claude Code 2.1.304, modèle `claude-opus-5-5`) :**
- 4a ✅ ce fichier · 4b ✅ `.claude/sprint-memory.md` · 4c ✅ immédiat chargé (`01`/`02` lus dans la version bootstrappée `$TMP`, c'est elle que la grille classe) · 4d ✅ §Plan ci-dessous.

---

## Plan de développement

**Classification :** Revue (Spike lecture seule) — Lecture → Recommandations → `/wrap-up`.

**Taille :** cœur M (rapport) · gouvernance S (ROADMAP, CHANGELOG, LESSONS_LEARNED, ce spec) → total M.

**Modules touchés (écriture) :** `specs/Sprints/AUDIT-ELAGAGE-1.md` (nouveau) · ce spec · `docs/ROADMAP.md` · `CHANGELOG.md` · `docs/LESSONS_LEARNED.md`. Aucun module partagé → niveau B = critère « aucun template modifié ».

**Plan d'exécution :**
1. Phase 1 — bootstrap dans `mktemp -d`, mesures 1.1→1.3, unité de comptage 1.4 ; écrire `## Mesures` dans le rapport → **aval humain**.
2. Phase 2 — grille `R-NN`, dispositions par défaut appliquées mécaniquement, décision source par `grep -n` (2 recherches max).
3. Phase 3 — matrice des couches de vérification, références cassées 3.2, `/doctor prompt-audit` demandé à l'humain (3.3).
4. Phase 4 — évaluation A→H, entrées rédigées avec Prédiction / Risque ; Verdict.
5. ROADMAP (ELAG-2 §Next, Import élagage §Later), `rm -rf "$TMP"`, critères d'acceptation → **aval humain** → `/wrap-up` (commit unique).

**Plan de test :**
- A — Ciblé : les 9 commandes de §Critères d'acceptation, exécutées telles quelles.
- B — Non-régression : `git status --porcelain | awk '{print $2}' | grep -E "^[0-9]{2}[a-z]?-|^sdlc-|^Claude\.md$|^STANDARDS\.md$|^\.claude/"` → vide.
- C — Intégration : `bash sdlc-validate.sh` → 10/10 et `bash tests/sdlc-validate-test.sh` → exit 0.

---

## Corrections ajustées vs spec

*(complété au fil de l'exécution)*

- **Unité de comptage (1.4) étendue** : le PDR ne compte que les puces et lignes numérotées. Les amorces grasses hors en-têtes de liste (b), les étapes du §Démarrage et les sections du gabarit d'Analyse en bloc de code (c) sont ajoutées. Sinon, la clause anti-complaisance, le verdict gate et la vérification factuelle, pourtant au cœur de 3.1, ne seraient pas comptés. Script reproductible dans `AUDIT-ELAGAGE-1.md §1.4`.
- **Constat hors périmètre** : le hook livré par `sdlc-init.sh:336` lit le champ `input` et non `tool_input` (`M-HOOKS-05`), et laisse donc passer une poussée forcée (exit 0 observé). Non corrigé ici, puisque `sdlc-init.sh` est interdit par le PDR. Consigné au rapport, à `LESSONS_LEARNED` et à la ROADMAP.
- **Chiffres écrits avant d'être mesurés (`LL-T14`), 5 fois dans ce sprint**, tous corrigés avant livraison par la commande lancée juste après : sous-totaux (a)/(b) 66/30 → 55/29 ; règles de `Claude.md` non gardées 51 → 56 ; règles d'origine `incident` 13 → 20 ; règles `import` 43 → 29 ; liste « modèle antérieur » 7 → 9. La règle `M-PROC-48` était chargée (lue au §Démarrage) et n'a rien empêché : seule la commande lancée après coup a attrapé ces erreurs. C'est l'observation L1 sur la prose seule, illustrée par le sprint lui-même.
- **Phase 3.3 réintégrée** : l'humain avait décliné `/doctor prompt-audit`, puis en a collé le rapport en cours de Phase 3. Il est intégré en §3.3, chaque constat repris étant revérifié par commande. Il apporte le constat majeur du Spike : `Claude.md` n'est pas chargé sous Linux, puisque Claude Code charge `CLAUDE.md`. Ce constat a été confirmé dans cette session même (contexte initial sans `Claude.md`). La lecture de §Mesures 1.1 a été révisée en conséquence.
- **Exception de méthode en Phase 2** : les règles de forme `mécanisme` (skill, hook, `check_cN`) ne coûtent rien au contexte permanent. Le défaut « portée ≠ toujours → DÉPLACER » ne leur est donc pas appliqué. L'exception est justifiée une fois en tête de §Grille.
- **Proposition « I » ajoutée aux propositions A→H** (`M-ARCH-10` provisoire, Fix bootstrap), en préalable à D. La ROADMAP reçoit en conséquence un item de plus que prévu par le PDR : `ELAG-1b` en §Next, avant `ELAG-2`. Raison : `ELAG-2` ne peut rien mesurer dans un projet où les règles ne sont pas chargées.
