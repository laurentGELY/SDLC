# Sprint ELAG-2 — Usage réel des règles dans Job search (mesure d'élagage)
<!-- Template SDLC v2.4 · BROUILLON rédigé en session Claude Code le 20/10/2026, à finaliser en session Claude.ai -->
<!-- Destination finale : specs/Sprints/sprint-ELAG-2-usage-reel-jobsearch.md dans le repo Job search -->
<!-- Entrées : specs/Sprints/AUDIT-ELAGAGE-1.md (repo SDLC, commit 573d1f3) · rapport /doctor prompt-audit « avant » de Job search -->

**Type :** Spike
**Taille :** M pour la session de mesure ; la collecte d'usage court ensuite sur les 5 sprints suivants de Job search et se clôt dans un sprint dédié (`ELAG-3`)
**Surface :** lecture seule — `CLAUDE.md`, `STANDARDS.md`, `.claude/`, `docs/LESSONS_LEARNED.md`, `CHANGELOG.md`, historique git de Job search · écriture — `specs/Sprints/AUDIT-ELAGAGE-2.md` (nouveau), `specs/Sprints/ELAG-2-prompt-audit-avant.md` (nouveau), une étape temporaire dans `.claude/skills/wrap-up/SKILL.md` de Job search, `docs/ROADMAP.md`, `CHANGELOG.md`, `docs/LESSONS_LEARNED.md`
**Risque :** Faible (une seule règle ajoutée, temporaire et datée)

---

## ⚠️ Questions ouvertes — à trancher en session Claude.ai avant handoff

1. **Chemin du repo Job search** sur la machine d'exécution (les commandes ci-dessous l'appellent `$JS`).
2. **Repo SDLC accessible depuis la session Job search ?** Le script de comptage et la grille sont dans `specs/Sprints/AUDIT-ELAGAGE-1.md` du repo SDLC. Sinon, recopier ce fichier dans `$JS/specs/Sprints/` au démarrage (option par défaut proposée).
3. **Nombre de sprints de collecte d'usage** : 5 proposé, aligné sur la cadence `/retrospective`. À confirmer selon le rythme réel de Job search.
4. **Ce que Job search a reçu après v1.5** : le marqueur dit `v1.5 · aligné le 04/06/2026`, mais `CLAUDE.md` (pas `Claude.md`), le frontmatter de 3 skills et `wrap-up` en `version: 3.2.0` montrent des évolutions locales. Les recenser en Phase 0 (`git log --oneline -- CLAUDE.md .claude/skills/` côté Job search).

---

## Contexte

`ELAG-1` (repo SDLC, commit `573d1f3`) a classé les 134 règles d'un projet bootstrappé en v2.0+ELAG-1 (`R-01`→`R-134`). Il a proposé 7 retraits, 23 fusions, 23 déplacements et 20 mécanisations, **tous provisoires faute de données d'usage**. Le repo SDLC est un réceptacle théorique : il ne produit pas ces données. Job search est le projet réel qui les produit.

Mesures faites le 20/10/2026 dans Job search, avant ce PDR :
- `CLAUDE.md` existe, contient les règles elles-mêmes (pas un `@import`) et fait 393 lignes (`wc -l CLAUDE.md`). Il est donc chargé à chaque session, contrairement au `Claude.md` d'un projet bootstrappé sous Linux (`AUDIT-ELAGAGE-1.md §3.3`).
- Le hook bloque bien `git push --force` (code 2 avec le schéma JSON `tool_input` réel). Job search n'a pas le défaut de `sdlc-init.sh:336`.
- Les 9 marqueurs de règles v2.0 testés sont à **0** dans `CLAUDE.md` : `HALT-DEP`, `Rationalisations`, `Vérification factuelle`, `Auto-revue`, `Verdict gate`, `anti-complaisance`, `Barre qualité`, `Mode /fast`, `rules/`. `Barre qualité` est aussi à 0 dans `STANDARDS.md`.

Job search tourne donc depuis juin **sans** la plupart des règles ajoutées à partir de SDLC-07. Il permet deux mesures : l'**usage** des règles qu'il a, et les **effets de l'absence** de celles qu'il n'a pas.

---

## Objectif

Livrer `specs/Sprints/AUDIT-ELAGAGE-2.md` (repo Job search), qui :
1. fait correspondre chaque règle chargée dans Job search à un `R-NN` de la grille ELAG-1, ou lui attribue un `R-JS-NN` si elle est locale ;
2. pour chaque règle v2.0 absente de Job search, établit si le défaut qu'elle vise s'est produit dans l'historique du projet (volet **absence**) ;
3. met en place la collecte d'**usage** sur les 5 sprints suivants (une étape temporaire du wrap-up), clôturée par `ELAG-3` ;
4. donne un verdict provisoire sur les 7 retraits proposés par ELAG-1 (confirmé, infirmé, non mesurable).

---

## Comportement actuel → cible

- **Actuel :** les dispositions d'ELAG-1 reposent sur la structure seule (origine, forme, recouvrement). Aucune donnée ne dit si une règle sert, gêne ou n'est jamais sollicitée.
- **Cible :** chaque `R-NN` porte un statut fondé sur des faits de Job search : présente (avec usage mesuré à partir d'ELAG-3), absente (avec défaut observé ou non dans l'historique), ou non mesurable (avec la raison).

---

## Portée

**Inclus :**
- Phase 0 — correspondance des règles Job search ↔ `R-NN`, recomptage par le script d'ELAG-1 adapté à `CLAUDE.md`
- Phase 1 — volet absence : recherche dans `LESSONS_LEARNED`, `CHANGELOG` et `git log` des défauts visés par les règles absentes
- Phase 2 — protocole d'usage : une étape temporaire dans le wrap-up de Job search, avec expiration
- Phase 3 — verdict provisoire sur les 7 retraits ELAG-1
- `/doctor prompt-audit` « avant », lancé par l'humain et archivé dans `specs/Sprints/ELAG-2-prompt-audit-avant.md`

**Exclu (explicitement) :**
- Synchroniser Job search en v2.0 (`/sdlc-sync`) : cela détruirait le point de comparaison du volet absence
- Retirer, fusionner ou déplacer une règle de Job search
- Toute modification du repo SDLC (le retour vers le modèle passe par `SDLC_CANDIDATE` et l'`Import élagage`)
- Appliquer le diff proposé par `/doctor prompt-audit`

---

## Protocole

### Phase 0 — Correspondance et recomptage

**0.1 Évolutions locales depuis v1.5 :**
```bash
cd "$JS"
git log --oneline -- CLAUDE.md STANDARDS.md .claude/skills/ .claude/hooks/ | wc -l
git log --reverse --format='%h %ad %s' --date=short -- CLAUDE.md | head -5
grep -n "SDLC version" CLAUDE.md
```

**0.2 Recomptage avec l'unité de comptage d'ELAG-1.** Recopier le script de `AUDIT-ELAGAGE-1.md §1.4` dans `/tmp/compter-regles.sh`, puis l'adapter au nom `CLAUDE.md`. Le contrôle `sdlc-validate.sh` est absent d'un projet cible : la catégorie (f) donne 0, c'est attendu.
```bash
sed -i 's/for f in Claude.md STANDARDS.md/for f in CLAUDE.md STANDARDS.md/; s/F=="Claude.md"/F=="CLAUDE.md"/' /tmp/compter-regles.sh
grep -c "CLAUDE.md" /tmp/compter-regles.sh          # → 2 attendu
bash /tmp/compter-regles.sh "$JS" "$JS" 2>/dev/null   # total Job search
bash /tmp/compter-regles.sh "$JS" "$JS" --liste 2>/dev/null > /tmp/regles-js.txt
```
Écrire dans le rapport : `Règles comptées (Job search) : N — commande : \`bash /tmp/compter-regles.sh "$JS" "$JS"\``.

**0.3 Correspondance.** Une ligne par règle de `/tmp/regles-js.txt`, avec la colonne `R-NN ELAG-1` remplie par un des trois cas :
- `R-NN` : même règle, même effet (le texte peut différer) ;
- `R-NN~` : variante locale (préciser l'écart en ≤ 12 mots) ;
- `R-JS-NN` : règle locale sans équivalent dans la grille.

Puis la liste inverse : chaque `R-01`→`R-134` absent de Job search, avec la commande `grep -c` qui le montre absent.

### Phase 1 — Volet absence (règles v2.0 manquantes)

Pour chaque groupe ci-dessous, chercher dans Job search le défaut visé. Classer le résultat : **observé** (n occurrences, avec `fichier:ligne` ou commit), **non observé** (commandes lancées, 0 résultat) ou **non mesurable** (le défaut ne laisse pas de trace écrite ; dire pourquoi).

| Groupe ELAG-1 | Défaut visé | Commandes de recherche (Job search) |
|---|---|---|
| R-50 (vérification factuelle, totaux par commande) | prémisse fausse ; chiffre faux dans un livrable | `grep -niE "comptage\|erroné\|faux\|inexact\|recompt" docs/LESSONS_LEARNED.md CHANGELOG.md` |
| R-62, R-03, R-15, R-40 (clause anti-complaisance et groupe « conclure sans preuve ») | test déclaré OK sans sortie vue ; conclusion non vérifiée | `grep -niE "pas (été )?exécut\|supposé\|déclaré.*OK\|en fait (il\|ça) \|régression" docs/LESSONS_LEARNED.md CHANGELOG.md` |
| R-51, R-52 (auto-revue, verdict gate) | plan incomplet validé, puis corrigé en cours de sprint | `grep -niE "oubli\|manquait\|non prévu\|ajusté\|Corrections ajustées" CHANGELOG.md docs/LESSONS_LEARNED.md \| wc -l` puis lecture des lignes trouvées |
| R-07, R-92→R-97 (barre qualité, plancher) | suppression de lint ajoutée, test sauté, seuil baissé | `git log -p --since=2026-06-04 \| grep -cE "^\+.*(# noqa\|pytest\.mark\.skip\|@ts-ignore\|eslint-disable)"` |
| R-08→R-13 (HALT et tables de rationalisation) | dépendance installée hors PDR ; 3 échecs sans diagnostic ; hors périmètre | `grep -c "HALT" CLAUDE.md` d'abord (présence partielle ?), puis `grep -niE "hors (périmètre\|scope)\|dépendance\|boucle\|même erreur" docs/LESSONS_LEARNED.md` |
| R-55→R-57 (reprise après compaction) | sprint repris sans trace, travail refait ou perdu | `grep -niE "compaction\|repris\|perdu\|session tronquée\|RECONSTRUIT" docs/LESSONS_LEARNED.md` |

**Biais à écrire dans le rapport :** un défaut non observé ne prouve pas que la règle est inutile. Le projet, la période et parfois le modèle diffèrent, et un défaut peut s'être produit sans être consigné. Le volet absence apporte un indice, jamais une preuve.

### Phase 2 — Protocole d'usage (5 sprints, clos par ELAG-3)

Ajouter **une** étape au wrap-up de Job search (`.claude/skills/wrap-up/SKILL.md`), juste avant l'entrée Lessons Learned. Elle est balisée pour pouvoir la retirer sans rien deviner :

```
<!-- ELAG-2 temporaire — retirer au sprint ELAG-3 -->
### Usage des règles (ELAG-2)
Ajouter à l'entrée Lessons Learned du sprint une ligne :
**Usage règles :** servies : [R-xx (trace : fichier, commande ou entrée mémoire), …] · gênantes : [R-yy (ce qu'elle a coûté), …]
Une règle n'est « servie » que si son effet a laissé une trace citée dans la ligne. Sinon, ne pas la citer.
<!-- /ELAG-2 -->
```

Les règles non citées sur les 5 sprints sont « non sollicitées ». Le PDR `ELAG-3` agrégera les lignes. Source du protocole : `M-PROC-50` (provisoire) dans `AUDIT-ELAGAGE-1.md`. La trace exigée répond au risque L1 (auto-déclaration peu fiable).

### Phase 3 — Verdict provisoire sur les 7 retraits ELAG-1

Pour R-13, R-16, R-32, R-44, R-61, R-83 et R-91 : présente ou absente dans Job search, et résultat du volet absence s'il s'applique. Statut : `confirmé provisoire` / `infirmé` / `en attente d'ELAG-3`.

### Livrable — structure de `specs/Sprints/AUDIT-ELAGAGE-2.md`

```
# Audit d'élagage 2 — usage réel (Job search)
## Correspondance    ← Phase 0, une ligne par règle Job search (| R-JS- ou | R-), puis R-NN absents
## Absence           ← Phase 1, un bloc par groupe : observé / non observé / non mesurable, avec commandes
## Protocole         ← Phase 2, étape ajoutée au wrap-up + date d'expiration (ELAG-3)
## Verdict           ← Phase 3 + ce qu'ELAG-3 doit trancher
```

---

## Option retenue — alternatives écartées

**Retenue :** mesurer Job search tel quel (v1.5 + évolutions locales). L'absence des règles v2.0 devient une donnée, pas un défaut à corriger d'abord.

**Écartées :**
- Synchroniser Job search en v2.0 puis mesurer : ajoute environ 100 lignes de règles que l'audit propose justement de réduire, et supprime le point de comparaison.
- Ablation (retirer une règle de Job search pendant N sprints) : avec un seul projet et un sprint à la fois, la puissance statistique ne suffit pas pour conclure (même raison qu'ELAG-1).
- Compteurs d'usage permanents dans le template wrap-up du modèle : ce serait une règle de plus avant d'avoir prouvé qu'elle sert (`M-PROC-50`).

**Sacrifices délibérés :** la mesure d'usage ne couvre que les règles présentes dans Job search. Les règles v2.0 n'ont que le volet absence.

---

## Contraintes techniques / produit

- Le script de comptage s'exécute depuis `/tmp`, jamais versionné dans Job search.
- La grille de correspondance est en Markdown tabulaire, une ligne par règle commençant par `| R-` (ELAG-3 la parse).
- Chaque valeur chiffrée porte sa commande (`LL-T14`). Ce sprint vise précisément ce défaut, et ELAG-1 l'a commis 5 fois.

**Interdit :**
- Lancer `/sdlc-sync` ou toute synchronisation de Job search vers v2.0
- Modifier `CLAUDE.md`, `STANDARDS.md` ou `.claude/hooks/` de Job search
- Ajouter au wrap-up autre chose que le bloc balisé `ELAG-2 temporaire`
- Classer un défaut « non observé » sans avoir écrit les commandes lancées et leur sortie (0)
- Déclarer une règle « servie » sans trace citée

---

## Dépendances

**Inputs requis :**
- [ ] `AUDIT-ELAGAGE-1.md` accessible dans la session (repo SDLC ou copie dans `$JS/specs/Sprints/`)
- [ ] Rapport `/doctor prompt-audit` « avant » de Job search, collé par l'humain (Claude ne peut pas lancer cette commande)
- [ ] Historique git complet de Job search : `git -C "$JS" rev-parse --is-shallow-repository` → `false`
- [ ] Aucune synchronisation SDLC faite depuis le 20/10/2026 : `grep -n "SDLC version" "$JS/CLAUDE.md"` → toujours `v1.5`

**Outputs produits :**
- [ ] `specs/Sprints/AUDIT-ELAGAGE-2.md` (Job search) et sa grille de correspondance
- [ ] Étape temporaire `ELAG-2` dans le wrap-up de Job search
- [ ] `ELAG-3` (agrégation d'usage) dans la ROADMAP de Job search, déclencheur : 5 sprints après ELAG-2

**Règle :** avant de démarrer, vérifier que tous les inputs requis cochés existent et sont dans l'état attendu. Si un input manque ou a changé → signaler comme BLOQUANT avant toute analyse.

---

## Critères d'acceptation

*(La Definition of Done — `STANDARDS.md §Definition of Done` — s'applique en plus.)*

- [ ] `test -f specs/Sprints/AUDIT-ELAGAGE-2.md && echo OK` → `OK`
- [ ] `grep -cE "^## (Correspondance|Absence|Protocole|Verdict)$" specs/Sprints/AUDIT-ELAGAGE-2.md` → `4`
- [ ] La correspondance couvre toutes les règles recomptées :
  ```bash
  F=specs/Sprints/AUDIT-ELAGAGE-2.md
  N=$(grep -oE "Règles comptées \(Job search\) : [0-9]+" "$F" | grep -oE "[0-9]+$")
  R=$(awk '/^## Correspondance$/{f=1;next} /^## /{f=0} f' "$F" | grep -cE "^\| R-(JS-)?[0-9]")
  [ -n "$N" ] && [ "$N" -eq "$R" ] && echo OK
  ```
  → `OK`
- [ ] Chaque groupe du volet absence a un statut : `awk '/^## Absence$/{f=1;next} /^## /{f=0} f' specs/Sprints/AUDIT-ELAGAGE-2.md | grep -cE "^\*\*Statut :\*\* (observé|non observé|non mesurable)"` → `6`
- [ ] Les 7 retraits d'ELAG-1 ont un verdict : `grep -cE "^\| R-(13|16|32|44|61|83|91) .*(confirmé provisoire|infirmé|en attente d'ELAG-3)" specs/Sprints/AUDIT-ELAGAGE-2.md` → `7`
- [ ] Étape temporaire présente et balisée : `grep -c "ELAG-2 temporaire" .claude/skills/wrap-up/SKILL.md` → `1`
- [ ] Aucun autre fichier de règles touché : `git status --porcelain | awk '{print $2}' | grep -E "^CLAUDE\.md$|^STANDARDS\.md$|^\.claude/hooks/"` → vide
- [ ] Job search non synchronisé : `grep -c "SDLC version : v1.5" CLAUDE.md` → `1`
- [ ] CHANGELOG mis à jour

---

## Risques

- **La correspondance R-NN ↔ Job search devient subjective** (variantes de texte) : probabilité moyenne · le cas `R-NN~` existe pour cela, avec l'écart écrit en ≤ 12 mots. En cas de doute, choisir `R-JS-NN` plutôt qu'une correspondance forcée.
- **Volet absence lu comme une preuve** : probabilité moyenne · le biais est écrit dans le rapport (Phase 1), et aucun retrait n'est décidé avant ELAG-3.
- **L'étape d'usage est oubliée ou remplie sans trace** : probabilité moyenne · elle est placée dans le wrap-up (pas en prose de `CLAUDE.md`, L1), et ELAG-3 ne compte que les lignes avec trace.
- **Évolutions locales post-v1.5 plus nombreuses que prévu** (le wrap-up local est en `version: 3.2.0`) : probabilité moyenne · la Phase 0.1 les recense avant la correspondance.

---

## Pre-mortem

> Si ce sprint échoue ou dépasse 2× l'estimation, la cause la plus probable est :

la correspondance faite à la lecture, règle par règle, des 393 lignes face aux 134 `R-NN`. Mitigation : partir de `/tmp/regles-js.txt` (sortie du script) et chercher chaque règle par `grep -n` d'un mot-clé dans la `§Grille` d'ELAG-1, au plus deux recherches, puis `R-JS-NN`.

---
<!-- FIN PRD — La section Handoff est complétée par Claude Code en début de session -->

## Handoff Claude Code
*(à compléter en début de session)*

> Ce PDR ne remplace pas `CLAUDE.md §Démarrage` — les 4 étapes (4a créer le
> fichier spec · 4b initialiser la mémoire sprint · 4c charger les fichiers ·
> 4d écrire le §Plan de développement) restent dues même si ce Handoff n'en
> détaille qu'une partie ci-dessous.

**Fichiers — chargement immédiat :** ce PDR · `AUDIT-ELAGAGE-1.md §1.4` (script) et `§Grille` · `CLAUDE.md` · `STANDARDS.md`

**Fichiers — chargement différé :** `docs/LESSONS_LEARNED.md` et `CHANGELOG.md` de Job search (grep de la Phase 1 uniquement) · `.claude/skills/wrap-up/SKILL.md` (Phase 2)

**Instructions spécifiques :**
- Ordre strict : Phase 0 → 3. La correspondance ne commence qu'une fois le recomptage écrit dans le rapport.
- Demande d'aval après la Phase 0, puis avant l'ajout de l'étape au wrap-up (seule modification d'un fichier de règles), puis avant le commit.
- Un seul commit final : `docs(elagage): Spike ELAG-2 — usage réel des règles`.

---

## Plan de développement
*(à compléter en début de session — étape 4d)*

---

## Corrections ajustées vs spec
*(à compléter au fil de l'exécution)*
