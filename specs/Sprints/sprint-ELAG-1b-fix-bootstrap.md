# Sprint ELAG-1b — Fix bootstrap : le projet bootstrappé reçoit les mécanismes que la prose promet
<!-- Template SDLC v2.4 · rédigé le 19/11/2026 en session Claude Code · confronté à SDLC @ 012905d (README : v2.0+ELAG-1) et à un bootstrap jetable du même jour · destination : specs/Sprints/sprint-ELAG-1b-fix-bootstrap.md (ce dépôt) -->
<!-- Entrées : specs/Sprints/AUDIT-ELAGAGE-1.md @ 573d1f3 (§1.1, §3.2, §3.3, M-ARCH-10 provisoire) · remontées Job search 21/10 (défauts d'amorçage) et 18/11-4 (frontmatter sdlc-sync revenu) · Job search b943413 (regex du hook) · PDR SDLC-33 (K9, K12) -->

**Type :** Fix
**Taille :** M — 4 lots, un commit par lot
**Surface :** `sdlc-init.sh`, `08-hooks-TEMPLATE.md`, `.claude/hooks/pre-tool-bash.sh`, `01`, `02`, `03`, `04`, `04b`, `08`, `09`, `11` (renvois au fichier et frontmatter), skills vivants `wrap-up` et `retrospective`, `sdlc-validate.sh` (C2), `sdlc-delta.sh`, `sdlc-project-check.sh`, `tests/` (nouveau `tests/sdlc-init-test.sh`), `07-DECISIONS-SDLC.md`, `docs/ROADMAP.md`, gouvernance
**Risque :** Moyen — corrige un défaut actif dans tout projet bootstrappé ; le renommage touche une quarantaine de renvois. Effet de bord voulu : dès le renommage, les 499 lignes de `01` sont **chargées** dans chaque session d'un projet neuf (ELAG-4 les réduit ensuite)

---

## Décisions prises avant le handoff (Laurent, 19/11/2026)

1. **Le `Claude.md` du repo SDLC est renommé aussi**, dans un commit séparé (lot 4). Il n'est pas chargé non plus : une session du 19/11 l'a constaté (contexte initial réduit à `MEMORY.md`, skills affichés « wrap-up — SKILL », « retrospective — SKILL »). Des règles qu'on croit appliquées et qui ne le sont pas sont pires que des règles absentes. Conséquence acceptée : 384 lignes chargées dans chaque session de ce dépôt.
2. **`pre-compact.sh` est installé** par le bootstrap, avec ses entrées `PreCompact` dans `settings.json`. `01:394` promet un `CHECKPOINT` automatique ; le hook existe dans ce dépôt depuis juin, sort toujours en 0 et ne bloque rien.
3. **Une seule source pour le hook** : `sdlc-init.sh` extrait le hook de `08-hooks-TEMPLATE.md` entre deux marqueurs ; un test de comportement remplace l'extension de C5 prévue par le texte d'origine de `M-ARCH-10`. La copie inline, qui n'avait pas suivi `M-HOOKS-05`, est la cause du défaut.
4. **`--force-with-lease` et `+refspec` sont bloqués** comme `--force` ; l'humain garde la main pour pousser en force hors de Claude Code.

---

## Contexte

ELAG-1 a constaté que la prose du modèle promet des mécanismes qu'un projet bootstrappé ne reçoit pas. Un bootstrap jetable du 19/11 (`git init`, puis `bash sdlc-init.sh "Test"`) confirme les 6 défauts :

| # | Défaut | Constat du 19/11 | Conséquence |
|---|---|---|---|
| 1 | Le fichier d'instructions s'appelle `Claude.md` | `ls "$B"` → `Claude.md`, pas de `CLAUDE.md` | sous Linux (casse respectée), **aucune règle n'est chargée** ; Job search l'a corrigé localement (`337a84f`) |
| 2 | Le hook lit `input` au lieu de `tool_input` | les 4 poussées forcées testées passent (exit 0), y compris `git push --force` | **le hook ne bloque rien** ; le smoke test de `sdlc-init.sh` envoie lui aussi l'ancien schéma, et seulement un cas autorisé : il affiche « ✅ exit 0 » |
| 3 | Pas de `.gitignore` | absent du bootstrap | `.env`, `.claude/sprint-memory.md`, `.claude/settings.local.json` versionnables |
| 4 | Skills sans frontmatter `name`/`description` | `head -1` des 4 skills → `# <nom> — SKILL` | la liste des skills n'affiche que « <nom> — SKILL » ; le déclenchement par description ne marche pas (`00-CONTEXT §5.1`). Revenu dans Job search le 18/11 (remontée 18/11-4) |
| 5 | Dates figées dans les gabarits du wrap-up | `wrap-up/SKILL.md:193, 226, 388` → `19/11/2026`, `2026-11-19` | chaque entrée LESSONS/CHANGELOG reçoit la date du bootstrap ; cause : `deploy_template` remplace `JJ/MM/AAAA` et `AAAA-MM-JJ` partout |
| 6 | `pre-compact.sh` promis, non installé | `ls .claude/hooks` → `hooks-reference.md`, `pre-tool-bash.sh` ; `grep -c PreCompact settings.json` → 0 | `01:394` décrit un `CHECKPOINT` automatique qui n'existe pas |

S'y ajoutent trois défauts de la même famille :

| # | Défaut | Constat | Source |
|---|---|---|---|
| 7 | **Regex `--force`** du modèle (`08:78`, hook vivant `:78`) | sur 11 cas : 3 poussées forcées passent (`--force` en fin de commande, `-f` en fin, `--force-with-lease`), 2 commandes légitimes bloquées (`git push … && git worktree remove --force …`, `git push …; rm -f origin.txt`). Le hook vivant de ce dépôt a bloqué une commande de test pendant la rédaction de ce PDR | K9 de SDLC-33 ; correctif de référence Job search `b943413` |
| 8 | **Marqueur de version périmé** | `Claude.md:3` et `STANDARDS.md:3` bootstrappés portent `v2.0+SDLC-29`, le dépôt est en `v2.0+ELAG-1` ; `sdlc-init.sh` le signale lui-même (« ⚠️ Marqueur SDLC version non trouvé ») sans le corriger | ELAG-1 §1.1 |
| 9 | **Frontmatter incompatible avec C2** | C2 lit les 3 premières lignes de chaque `NN-*.md` ; un frontmatter en ligne 1 pousse le commentaire de version au-delà → C2 échoue sur `03`, `04b`, `09`, `11` | K12 de SDLC-33 |

`M-ARCH-10` (provisoire) fait de ce sprint le préalable à tout élagage : retirer une prose dont le mécanisme est cassé supprime la seule trace de la règle. ELAG-4 et les lots 1-2 de SDLC-33 l'attendent.

---

## Objectif

Un projet bootstrappé neuf contient `CLAUDE.md`, un `.gitignore`, un hook qui bloque toutes les poussées forcées et laisse passer les commandes légitimes, 4 skills avec frontmatter, des gabarits datés par placeholder, `pre-compact.sh` actif et le marqueur de version courant. Un test de bootstrap le vérifie à chaque wrap-up.

---

## Comportement actuel → cible

- **Actuel :** les 9 défauts ci-dessus ; aucun contrôle ne les voit (C5 compare `08` aux hooks du dépôt SDLC, pas au hook livré ; le smoke test de `sdlc-init.sh` ne peut pas échouer).
- **Cible :** `tests/sdlc-init-test.sh` bootstrappe dans `mktemp -d` et vérifie les 9 points par commande, avec au moins un cas rouge par mécanisme ; `/sdlc-sync` sait migrer un projet existant (`Claude.md` → `CLAUDE.md`, `.gitignore`, hook, frontmatter).

---

## Portée

**Inclus :**
- Lot 1 — Hook : source unique, regex, smoke test, `pre-compact.sh`
- Lot 2 — Fichiers du bootstrap : `CLAUDE.md`, renvois, `.gitignore`, marqueur, dates
- Lot 3 — Frontmatter des skills et C2
- Lot 4 — Projets existants (`04b`, `sdlc-delta.sh`), `Claude.md` du dépôt SDLC (décision 1), décision `M-ARCH-10`, gouvernance, bump `v2.0+ELAG-1b`

**Exclu (explicitement) :**
- Toute disposition sur les règles elles-mêmes (retrait, fusion, déplacement) : ELAG-4. En particulier, ce sprint **ne réduit pas** `01`, même si le renommage le fait charger.
- Les références cassées vers des IDs du dépôt SDLC (`DECISIONS.md` M-HOOKS-04 cité par `01:22`, `M-PROC-44`/`LL-T08` dans le wrap-up), `git pull` sans remote (§3.3 n° 6), « Mode /fast » : sémantique des règles, ELAG-4 ou plus tard.
- Les chemins de `/sdlc-sync` (remontée R6) : SDLC-33 (réglages locaux de chemin).
- Les mentions historiques de `Claude.md` (CHANGELOG, `07`, `specs/Sprints/`, `docs/LESSONS_LEARNED.md`, audits) : elles décrivent le passé, on ne les réécrit pas.
- Le nom du template `01-Claude-md-TEMPLATE.md` : inchangé (C6 et toute la documentation le citent).
- Job search : déjà corrigé localement ; il recevra ces correctifs par `/sdlc-sync`, qui doit les reconnaître comme déjà alignés.

---

## Option retenue — alternatives écartées

**Retenue :** renommer le fichier déployé en `CLAUDE.md`, mettre à jour les renvois **opérationnels** (fichiers déployés, scripts, docs qui décrivent l'état courant), faire du bloc de `08` la source unique du hook, et prouver chaque mécanisme par un test de comportement sur un bootstrap jetable.

**Écartées :**
- **`CLAUDE.md` d'une ligne `@Claude.md`** (option citée par `M-ARCH-10`) : sur un système insensible à la casse (macOS, Windows par défaut), `CLAUDE.md` et `Claude.md` ne peuvent pas coexister. Le bootstrap casserait là où il fonctionne aujourd'hui.
- **Étendre C5 à la copie inline** : garde trois copies du hook (`08`, hook vivant, `sdlc-init.sh`) et vérifie des clés JSON, pas un comportement. Le défaut n° 7 avait des clés correctes et une regex fausse : C5 étendu ne l'aurait pas vu.
- **Corriger seulement la regex** : laisse le hook livré inopérant (défaut n° 2).
- **Fusionner avec ELAG-4** : sprint L+ ; ce correctif ne doit pas attendre l'élagage.

**Sacrifices délibérés :** `01` chargé avec ses 499 lignes entre ce sprint et ELAG-4 (risque de densité, L2, devenu réel) ; les docs `docs/pages/*.md` et les HTML sont mis à jour seulement là où C9/C10 l'exigent et là où ils décrivent le fichier produit.

---

## Contraintes techniques / produit

- **Tester le hook sans déclencher le hook vivant** : toute commande Bash de session qui contient littéralement une poussée forcée est bloquée par `.claude/hooks/pre-tool-bash.sh` (vu le 19/11). Les cas de test vivent dans un fichier et construisent la chaîne en deux morceaux (`P="git pu""sh"; F="--for""ce"`).
- **Bootstrap jetable** : `B=$(mktemp -d) && cd "$B" && git init -q && git -c user.email=t@t -c user.name=t commit -q --allow-empty -m init && bash "$SDLC/sdlc-init.sh" "Test"`. `sdlc-init.sh` refuse un répertoire sans dépôt git (vu le 19/11).
- Template modifié → version incrémentée dans les 3 premières lignes **après le frontmatter** (C2 adapté au lot 3) ; template de skill modifié → skill vivant dans le même commit (C4).
- Renvois : un `sed` par fichier, suivi de `grep -c 'Claude\.md' <fichier>` → 0 (sauf mentions historiques listées dans §Corrections ajustées).
- IDs : ce sprint n'en crée **aucun**. Tout est porté par `M-ARCH-10`, réservé à ce sprint par ELAG-1. `M-PROC-49`→`54` et `M-TMPL-10` sont à ELAG-4 ; `M-PROC-55`→`60` et `M-HOOKS-09` à SDLC-33.

**Interdit :**
- modifier `specs/Sprints/AUDIT-ELAGAGE-1.md` ;
- réécrire une mention historique de `Claude.md` ;
- retirer ou reformuler une règle de `01` au-delà du nom du fichier ;
- garder une copie du hook dans `sdlc-init.sh` (décision 3).

---

## Dépendances

**Inputs requis :**
- [ ] Dépôt à `012905d` ou descendant ; `bash sdlc-validate.sh` et `bash tests/sdlc-validate-test.sh` verts au démarrage
- [ ] Aucun autre sprint en cours sur `sdlc-init.sh` ou les hooks (SDLC-33 lots 1-2 : après ce sprint)

**Outputs produits :**
- [ ] `tests/sdlc-init-test.sh` (nouveau), lancé par la suite du wrap-up (§3.5)
- [ ] `M-ARCH-10` adoptée dans `07`
- [ ] ROADMAP : ELAG-1b en §Historique ; ELAG-4 débloqué (état observable : `ls "$B"/CLAUDE.md` après bootstrap)

**Règle :** avant de démarrer, vérifier que tous les inputs requis cochés existent et sont dans l'état attendu. Si un input manque ou a changé → signaler comme BLOQUANT avant toute analyse.

---

## Lots

### Lot 1 — Hook (défauts 2, 6, 7 ; décisions 2, 3, 4)

| Fichier | Changement |
|---|---|
| `08-hooks-TEMPLATE.md` | Marqueurs `<!-- hook:pre-tool-bash:début -->` / `<!-- hook:pre-tool-bash:fin -->` autour du bloc ` ```bash ` (`08:42-166`) · regex `[UNIVERSEL]` : `git\s+push\b[^;&|]*(\s(--force|-f)\b\|\s\+[^[:space:]])` (option cherchée dans le seul segment du push, `--force-with-lease` et `+refspec` compris — décision 4) · commentaire qui cite les cas de test |
| `.claude/hooks/pre-tool-bash.sh` (vivant) | Même regex (`:78`) ; le carve-out `sprint-memory.md` (M-HOOKS-04) est inchangé |
| `sdlc-init.sh` | Le heredoc `HOOK` (`:322-363` environ) est remplacé par l'extraction du bloc de `08` entre les marqueurs, sans les fences, placeholders `[Nom du projet]` et `[AAAA-MM-JJ]` remplacés · installation de `pre-compact.sh` (copie de `.claude/hooks/pre-compact.sh` du dépôt, ou du bloc `08 §PreCompact` s'il est complet — à décider à l'analyse) et entrées `PreCompact` `manual` et `auto` dans le `settings.json` produit, comme dans `.claude/settings.json` de ce dépôt (décision 2) · smoke test : schéma réel `tool_input`, **un cas autorisé (exit 0) et un cas bloqué (exit 2)** ; tout autre résultat → « ❌ » et code de sortie non nul |
| `tests/sdlc-init-test.sh` (nouveau) | Bootstrap jetable ; 11 cas de hook, qui reprennent le tableau du défaut n° 7 plus `+refspec` : 7 bloqués (`--force` en tête, en fin, `-f` en tête, en fin, `--force-with-lease`, `+main`, `--force origin main`), 4 autorisés (push simple, commande chaînée avec `worktree remove --force`, `rm -f origin.txt`, `echo ok`) · `pre-compact.sh` présent, exécutable, sort en 0 sur un JSON `PreCompact` · `settings.json` valide (`python3 -m json.tool`) avec `PreCompact` |

### Lot 2 — Fichiers du bootstrap (défauts 1, 3, 5, 8)

| Fichier | Changement |
|---|---|
| `sdlc-init.sh` | Déploie `01` vers `CLAUDE.md` (`:98`) ; garde de départ (`:45`) : refuser si `CLAUDE.md` **ou** `Claude.md` existe · marqueur de version : `deploy_template` remplace `SDLC version : [^ ]*` par `SDLC version : ${SDLC_VERSION}` dans `CLAUDE.md` et `STANDARDS.md` · wrap-up : déploiement qui ne remplace que `[Nom du projet]` (les placeholders de date des gabarits `03:193, 226, 388` restent) · `.gitignore` créé, ou complété sans doublon s'il existe : `.env`, `.claude/sprint-memory.md`, `.claude/settings.local.json` · récapitulatif, CHANGELOG produit et vérifications finales (`:114`, `:424-442`) : `CLAUDE.md` |
| Fichiers déployés : `01` (5), `02` (2), `03` (3), `04` (1), `04b` (6), `08` (1), `09` (4), `11` (2) | `Claude.md` → `CLAUDE.md` (comptes `grep -c 'Claude\.md'` à `012905d`) ; skills vivants `wrap-up` et `retrospective` dans le même commit |
| Scripts : `sdlc-delta.sh` (6), `sdlc-project-check.sh` (2), `sdlc-validate.sh` (1, liste de fichiers `:156` — décision 1) | idem ; `sdlc-delta.sh` cherche `CLAUDE.md`, puis `Claude.md` en repli, et signale le second comme « à renommer » |
| Docs d'état courant : `README.md` (12), `00-CONTEXT.md` (4), `06-PDR-bootstrap.md` (11), `specs/SPEC.md` (4), `docs/CLAUDE_PROJECT.md` (2), `docs/DIAGNOSTIC_CMDS.md` (6), `docs/pages/*` et HTML selon C9/C10 | Seulement les phrases qui décrivent le fichier produit ou à lire ; chaque mention gardée est classée « historique » dans §Corrections ajustées |

### Lot 3 — Frontmatter des skills et C2 (défauts 4, 9)

- `sdlc-validate.sh` C2 : si la ligne 1 est `---`, sauter le bloc jusqu'au `---` suivant, puis lire les 3 lignes. Cas RED : template avec frontmatter sans commentaire de version → ❌ C2 ; avec frontmatter et commentaire → ✓.
- Frontmatter sur `03`, `04b`, `09`, `11`, sur le squelette `diagnostic` de `sdlc-init.sh`, et sur les skills vivants `wrap-up` et `retrospective`. La `description` dit **quand** déclencher, jamais le déroulé (un résumé du déroulé fait suivre la description au lieu du skill — `specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md:247`). Proposition :
  - `wrap-up` : « Clôture de sprint. Utiliser quand l'utilisateur dit « clôture », « wrap-up », « fin de sprint », ou quand les tests A et B du sprint sont verts. »
  - `retrospective` : « Analyse des patterns sur plusieurs sprints. Utiliser toutes les ~5 sprints, après un incident majeur, ou quand /wrap-up la recommande ; pas à chaque sprint. »
  - `sdlc-sync` : « Alignement du projet sur une nouvelle version du modèle SDLC. Utiliser quand le modèle a évolué ou sur demande. »
  - `diagnostic` : « Diagnostic d'un bug, crash, blocage ou comportement anormal. Utiliser quand l'utilisateur signale une erreur ou une régression, ou demande pourquoi ça ne marche pas. »
  - `help` : « Récapitulatif de l'état du projet, en lecture seule. Utiliser quand l'utilisateur demande où en est le projet ou quoi faire ensuite. »
- `tests/sdlc-init-test.sh` : ligne 1 = `---`, champs `name` et `description` non vides sur les 4 skills déployés.
- **Aucun `$<chiffre>` dans un skill déployé** (remontée 19/11-3) : Claude Code remplace `$1`, `$2`… par les arguments du skill ; dans Job search, `awk '{print $2}'` est devenu `print <argument>` dans 4 skills. Les templates actuels sont sains (`grep -nE '\$[0-9]' 03-*.md 04b-*.md 09-*.md 11-*.md` → vide le 19/11) ; le test le garde : `grep -nE '\$[0-9]' "$B"/.claude/skills/*/SKILL.md` → vide. Il protège aussi le futur skill `/reprise` de SDLC-33, dont la spec prévoit `awk 'NR==1{print $2}'` (à remplacer par `sed -n '1s/^worktree //p'`).

### Lot 4 — Projets existants, dépôt SDLC, gouvernance

- `04b-sdlc-sync-SKILL-TEMPLATE.md` (+ copie vivante si installée) : détection `CLAUDE.md` puis `Claude.md` (`04b:17, 35, 132`) ; si seul `Claude.md` existe → proposer le renommage en deux temps, sûr sur un système insensible à la casse : `git mv Claude.md Claude.md.tmp && git mv Claude.md.tmp CLAUDE.md` ; reporter la regex du hook, le `.gitignore` et le frontmatter comme écarts à aligner ; un correctif local déjà présent (cas de Job search) est classé « déjà aligné ».
- Décision 1 : même renommage en deux temps pour le `Claude.md` de ce dépôt, commit séparé, liste C6/`check_c1` (`sdlc-validate.sh:156`) mise à jour ; le premier démarrage de session suivant confirme le chargement (`/memory` ou le contexte initial).
- `07` : `M-ARCH-10` adoptée, amendée par la décision 3 (source unique et test de comportement au lieu de C5 étendu) ; points 1 à 9 ; déclencheur de réouverture : Claude Code change le nom ou la casse du fichier mémoire chargé, ou le schéma JSON de `PreToolUse`. Ligne au tableau de compatibilité.
- Suite du wrap-up (§3.5, template et skill vivant) : lance aussi `tests/sdlc-init-test.sh`.
- ROADMAP, CHANGELOG `## [v2.0+ELAG-1b]`, README (version), `docs/` selon C9/C10, LESSONS (entrée du sprint ; `LL-T15` +1 : regex du hook).

---

## Critères d'acceptation

*(La Definition of Done — `STANDARDS.md §Definition of Done` — s'applique en plus. `$B` = bootstrap jetable de §Contraintes.)*

- [ ] `ls "$B"/CLAUDE.md && ! ls "$B"/Claude.md 2>/dev/null` → `CLAUDE.md` seul
- [ ] `grep -c 'Claude\.md' 01-Claude-md-TEMPLATE.md 02-STANDARDS-TEMPLATE.md 03-wrap-up-SKILL-TEMPLATE.md 04-sprint-PDR-TEMPLATE.md 08-hooks-TEMPLATE.md 09-retrospective-SKILL-TEMPLATE.md 11-help-SKILL-TEMPLATE.md sdlc-init.sh sdlc-project-check.sh` → `0` partout ; `04b` et `sdlc-delta.sh` : seulement la détection de repli
- [ ] `grep -xF '.env' "$B"/.gitignore && grep -xF '.claude/sprint-memory.md' "$B"/.gitignore && grep -xF '.claude/settings.local.json' "$B"/.gitignore`
- [ ] Hook livré : `bash tests/sdlc-init-test.sh` → 11 cas de hook conformes (7 bloqués en exit 2, 4 autorisés en exit 0) ; les mêmes 11 cas sur `.claude/hooks/pre-tool-bash.sh` du dépôt
- [ ] Source unique (décision 3) : `grep -c "get('input'" sdlc-init.sh` → `0` et `grep -c "<<.*'HOOK'" sdlc-init.sh` → `0`
- [ ] Smoke test : un hook volontairement inopérant (fixture du test) fait afficher « ❌ » et sortir `sdlc-init.sh` en erreur
- [ ] `ls "$B"/.claude/hooks/pre-compact.sh` et `python3 -c "import json;print('PreCompact' in json.load(open('$B/.claude/settings.json'))['hooks'])"` → `True` (décision 2)
- [ ] `head -1 "$B"/.claude/skills/{wrap-up,retrospective,sdlc-sync,diagnostic}/SKILL.md` → `---` quatre fois ; `name:` et `description:` présents dans chaque frontmatter
- [ ] Dates : `grep -c "JJ/MM/AAAA\|AAAA-MM-JJ" "$B"/.claude/skills/wrap-up/SKILL.md` → `3`
- [ ] Arguments de skill : `grep -nE '\$[0-9]' "$B"/.claude/skills/*/SKILL.md` → vide (cas RED : une fixture avec `awk '{print $2}'` fait échouer le test)
- [ ] Bilan de report rédigé (§Bilan de report) et transmis à Laurent
- [ ] Marqueur : `grep -c "SDLC version : $(grep -m1 -oE 'Version courante : [^ *]+' README.md | cut -d' ' -f4)" "$B"/CLAUDE.md "$B"/STANDARDS.md` → `1` chacun ; plus d'avertissement « Marqueur SDLC version non trouvé » dans la sortie de `sdlc-init.sh`
- [ ] C2 : `bash sdlc-validate.sh` vert avec les 4 templates à frontmatter ; nouveau cas RED vert dans `bash tests/sdlc-validate-test.sh`
- [ ] `/sdlc-sync` : `grep -n "Claude.md.tmp" 04b-sdlc-sync-SKILL-TEMPLATE.md` non vide
- [ ] `grep -c "^## M-ARCH-10 · " 07-DECISIONS-SDLC.md` → `1` ; `grep -cE "^## M-(PROC-(49|5[0-9]|60)|TMPL-10|HOOKS-09) · " 07-DECISIONS-SDLC.md` → `0`
- [ ] Audit figé : `git diff --stat 573d1f3 -- specs/Sprints/AUDIT-ELAGAGE-1.md` → vide
- [ ] Tests niveau A : `bash sdlc-validate.sh` → tous les contrôles OK · `bash tests/sdlc-validate-test.sh` et `bash tests/sdlc-init-test.sh` → tous OK · `bash -n sdlc-init.sh .claude/hooks/pre-tool-bash.sh`
- [ ] CHANGELOG mis à jour (`v2.0+ELAG-1b`), C1 vert

---

## Signaux de dégradation

- **Test qui ne peut pas échouer** : un cas du test de bootstrap jamais vu rouge (chaque mécanisme a un cas RED exécuté avant le correctif).
- **Renommage partiel** : un renvoi opérationnel à `Claude.md` survit hors de la détection de repli.
- **Hook vivant et hook livré divergents** : les 11 cas ne donnent pas le même résultat sur les deux.

---

## Risques

- **Les 499 lignes de `01` arrivent dans chaque session d'un projet neuf** : certain, voulu · ELAG-4 suit ; ne pas bootstrapper de nouveau projet entre les deux sans le savoir (note dans le CHANGELOG).
- **Le renommage casse un renvoi non vu** : moyen · `grep -rn 'Claude\.md'` final, chaque survivant classé historique ou corrigé.
- **Renommage dans un projet existant sur macOS/Windows** : `git mv Claude.md CLAUDE.md` échoue ou ne fait rien sur un système insensible à la casse · procédure en deux temps dans `04b`.
- **Le blocage de `--force-with-lease` gêne un flux légitime** : faible · décision 4 ; l'humain pousse hors de Claude Code.
- **L'extraction depuis `08` dépend des marqueurs** : un marqueur supprimé casse le bootstrap · le test de bootstrap échoue tout de suite ; message d'erreur explicite dans `sdlc-init.sh` si un marqueur manque.

---

## Pre-mortem

> Si ce sprint échoue ou dépasse 2× l'estimation, la cause la plus probable est :

le renommage dans les docs d'état courant (README, `06`, pages du site, deux HTML : une soixantaine de mentions) absorbe la session. Parade : lots 1 à 3 d'abord (mécanismes testés), docs ensuite, un `sed` par fichier avec comptage avant/après ; si le temps manque, les pages du site passent dans un commit de suite, C9/C10 restant le garde-fou.

---

## Bilan de report (file `doc/REMONTEE_SDLC.md` de Job search)

À recopier par Laurent dans la file de Job search au wrap-up, avec les versions réelles des templates :

- **18/11-1** (wrap-up « produit chaque fichier en contenu complet, prêt à écraser ») : **rejetée pour le modèle**. La phrase n'a jamais existé dans `03-wrap-up-SKILL-TEMPLATE.md` (`git log -S "prêt à écraser" -- 03-wrap-up-SKILL-TEMPLATE.md` → aucun commit) : c'est une divergence locale, déjà corrigée par Job search au S89.
- **18/11-4** (frontmatter de `sdlc-sync` revenu) : **adoptée** — `M-ARCH-10` point 4, template `04b` v… ; contrôlée par `tests/sdlc-init-test.sh`.
- **ELAG-2 — défauts d'amorçage** (`CLAUDE.md`, hook lisant `tool_input`, frontmatter) : **adoptée** — `M-ARCH-10` points 1, 2, 4, `sdlc-init.sh`, templates `03`, `04b`, `08`, `09`, `11` v….
- **19/11-3** (`$1`, `$2` dans un skill) : **adoptée** sous forme de contrôle — `tests/sdlc-init-test.sh` ; aucun template à corriger aujourd'hui.
- **S56-3** (`pkill -f`, `pgrep -f`) : **en attente** — SDLC-33 lot 2.

---
<!-- FIN PRD — La section Handoff est complétée par Claude Code en début de session -->

## Handoff Claude Code
*(à compléter en début de session)*

> Ce PDR ne remplace pas `Claude.md §Démarrage` — les 4 étapes (4a créer le
> fichier spec · 4b initialiser la mémoire sprint · 4c charger les fichiers ·
> 4d écrire le §Plan de développement) restent dues même si ce Handoff n'en
> détaille qu'une partie ci-dessous.

**Fichiers — chargement immédiat :** ce PDR · `sdlc-init.sh` · `08-hooks-TEMPLATE.md` (bloc `:42-166`, §PreCompact) · `.claude/hooks/pre-tool-bash.sh`

**Fichiers — chargement différé :** `sdlc-validate.sh` (C2 `:113`, C4, C5) · `tests/sdlc-validate-test.sh` (patron des cas) · `04b` · `sdlc-delta.sh` · `AUDIT-ELAGAGE-1.md §1.1, §3.2, §3.3, M-ARCH-10` (grep)

**Grep de vérification préalable :**
```bash
git log --oneline -3
grep -m1 "Version courante" README.md
grep -n "get('input'\|get('tool_input'" sdlc-init.sh 08-hooks-TEMPLATE.md .claude/hooks/pre-tool-bash.sh
grep -c 'Claude\.md' 01-Claude-md-TEMPLATE.md 04b-sdlc-sync-SKILL-TEMPLATE.md sdlc-init.sh sdlc-delta.sh
bash sdlc-validate.sh | tail -2 && bash tests/sdlc-validate-test.sh | tail -2
```

**Instructions spécifiques :**
- Écrire `tests/sdlc-init-test.sh` **avant** les correctifs de chaque lot et le voir rouge sur l'état actuel (le hook livré laisse passer les 7 poussées forcées, la ligne 1 des skills n'est pas `---`, etc.).
- Demande d'aval après l'analyse, puis avant le lot 4 (renommage du `Claude.md` de ce dépôt, décision 1), puis avant chaque commit.
- Un commit par lot : `fix(bootstrap): ELAG-1b lot N — …`.

---

## Plan de développement
*(étape 4d — 19/11/2026)*

**Dépendances vérifiées :**
- [x] Dépôt à `d302d09` (descendant de `012905d`), arbre propre ; `bash sdlc-validate.sh` → 10/10 ; `bash tests/sdlc-validate-test.sh` → 16/16
- [x] Aucun autre sprint en cours sur `sdlc-init.sh` ou les hooks (§Now vide, SDLC-33 lots 1-3 en §Later)
- [x] Décisions 1 à 4 prises (§Décisions prises avant le handoff)

**Taille :** cœur du changement M (hook, bootstrap, C2, test) ; total M-L une fois la gouvernance comptée (renommage dans une soixantaine de mentions de docs d'état courant, `07`, site, HTML) — `M-PROC-28`.

**Constats de l'analyse, absents du PDR :**
- **C3 sauterait le fichier renommé sans le dire** : sa liste (`sdlc-validate.sh:156`) cite `Claude.md` et fait `[ -f ] || continue`. Renommer sans mettre la liste à jour retire un fichier du contrôle en silence. → liste mise à jour dans le même commit que le renommage, et nombre de fichiers examinés comparé avant/après.
- **`08` contient aussi le bloc complet de `pre-compact.sh`** (`08:272` environ) : la source unique (décision 3) couvre les deux hooks, chacun entre ses marqueurs ; le `pre-compact.sh` vivant ne diffère du bloc que par ses commentaires d'en-tête.
- **Le hook vivant cite `Claude.md §Démarrage`** dans ses messages (`.claude/hooks/pre-tool-bash.sh:40, 67`) : à renommer avec le reste (lot 4).

**Modules touchés :**
| Lot | Fichiers |
|---|---|
| 1 | `tests/sdlc-init-test.sh` (nouveau) · `08-hooks-TEMPLATE.md` (marqueurs ×2, regex) · `.claude/hooks/pre-tool-bash.sh` (regex) · `sdlc-init.sh` (extraction des 2 hooks, `settings.json` avec `PreCompact`, smoke test) |
| 2 | `sdlc-init.sh` (`CLAUDE.md`, garde de départ, marqueur de version, déploiement du wrap-up sans dates, `.gitignore`) · renvois dans `01`, `02`, `03`, `04`, `04b`, `08`, `09`, `11`, skills vivants `wrap-up`/`retrospective`, `sdlc-delta.sh`, `sdlc-project-check.sh` · docs d'état courant |
| 3 | `sdlc-validate.sh` (C2) · `tests/sdlc-validate-test.sh` (cas RED C2) · frontmatter `03`, `04b`, `09`, `11`, squelette `diagnostic`, skills vivants |
| 4 | `04b` (détection, renommage en deux temps) · `Claude.md` → `CLAUDE.md` de ce dépôt + `sdlc-validate.sh` C3 + messages du hook vivant · `07` (`M-ARCH-10`) · `03` §3.5 + skill vivant + `00-CONTEXT.md §4` (lancer `tests/sdlc-init-test.sh`) · ROADMAP, CHANGELOG, README, `docs/` (C9/C10), LESSONS |

**Risques identifiés :** ceux du PDR, plus : C3 aveugle après renommage (parade ci-dessus) ; extraction cassée si un marqueur manque (message explicite + test) ; le hook vivant bloque les commandes de test qui contiennent une poussée forcée littérale (cas dans un fichier, chaînes en deux morceaux).

**Plan d'exécution :**
1. `tests/sdlc-init-test.sh` complet (les 9 points + garde `$<chiffre>` + smoke test sur hook inopérant), lancé sur l'état actuel → **vu rouge**, sortie consignée en mémoire de sprint.
2. Lot 1 → test : section hook verte · `sdlc-validate.sh` + suite → commit.
3. Lot 2 → test : sections fichiers vertes · grep des renvois → commit.
4. Lot 3 → test : section skills verte · nouveau cas RED C2 → commit.
5. Lot 4 → test complet vert · C3 : même nombre de fichiers examinés · commit, puis wrap-up.

**Plan de test :**
- A — Ciblé : `bash tests/sdlc-init-test.sh` · `bash sdlc-validate.sh` · `bash tests/sdlc-validate-test.sh` · `bash -n sdlc-init.sh .claude/hooks/pre-tool-bash.sh tests/sdlc-init-test.sh`
- B — Non-régression : arborescence d'un bootstrap avant/après (`find . -type f | sort`), seuls les écarts attendus (`CLAUDE.md`, `.gitignore`, `pre-compact.sh`) ; les 4 cas autorisés du hook restent autorisés
- C — Intégration (humain, session neuve) : ouvrir Claude Code dans un bootstrap jetable puis dans ce dépôt après le lot 4 → `CLAUDE.md` chargé, skills listés avec leur description

---

## Corrections ajustées vs spec
*(à compléter au fil de l'exécution)*
