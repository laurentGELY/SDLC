# ANALYSE — Écosystème Agent Skills (10 repos) vs modèle SDLC

<!-- Sprint Revue · Taille L · Surface : aucun fichier de gouvernance modifié · Risque : Faible -->
<!-- Destination proposée : specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md -->
<!-- Modèle de référence au moment de la revue : v1.9+SDLC-24 (dernière entrée M-TMPL-04) -->

**Type :** Revue (audit d'un livrable externe existant, zéro modification dans le même sprint)
**Date :** 02/09/2026
**Objet :** 10 dépôts Agent Skills publics — extraction des patterns exploitables par le modèle SDLC

---

## §1 · Périmètre et méthode

Dix dépôts demandés. Les liens fournis étaient des redirections `lnkd.in` (bloquées par `robots.txt`) — chaque cible a été ré-identifiée par recherche puis atteinte directement.

| # | Demandé | Dépôt atteint | Méthode |
|---|---------|----------------|---------|
| 1 | Anthropic Skills | `anthropics/skills` | clone + lecture |
| 2 | superpowers | `obra/superpowers` v6.3.0 | clone + lecture |
| 3 | Karpathy Skills | `LearnPrompt/andrej-karpathy-skills` | clone + lecture partielle |
| 4 | Skills for Real Engineers | `mattpocock/skills` | clone + lecture |
| 5 | UI/UX Pro Max | non ré-identifié de façon fiable | non traité |
| 6 | caveman | `JuliusBrussee/caveman` | clone + lecture partielle |
| 7 | Addy Osmani's Agent Skills | `addyosmani/agent-skills` | clone + lecture |
| 8 | Taste Skill | `leonxlnx/taste-skill` | clone, survol de l'arborescence |
| 9 | Awesome Claude Skills | 4 dépôts homonymes concurrents | survol des résultats de recherche |
| 10 | I Have ADHD Skill | `ayghri/i-have-adhd` | fetch du `SKILL.md` seul |

### §1.1 · Limites de validation (règle « affirmation citable »)

Les repos 1, 2, 4, 7 ont été lus au source ; toute affirmation les concernant est vérifiable par `git clone` + lecture du fichier cité.
Les repos 3, 6, 8, 9, 10 ont été survolés. Les patterns qui en sont tirés sont marqués `[SURVOL]` et doivent être re-vérifiés avant tout import.
Le repo 5 (« UI/UX Pro Max ») n'a pas été ré-identifié avec une certitude suffisante — plusieurs candidats homonymes, aucun dominant. Écart au périmètre demandé, assumé.
Le repo 9 (« Awesome Claude Skills ») existe en au moins 4 versions concurrentes (Chat2AnyLLM, travisvn, karanb192, ComposioHQ). Aucune n'est canonique. Traité comme un index, pas comme une source de patterns.
Cette revue n'a pas exécuté de code. Les mécanismes décrits (evals, hooks, ledger) sont lus dans leur source, pas observés en fonctionnement.

### §1.2 · Ce que cette revue ne refait pas

Trois audits externes ont déjà été menés par le modèle. Le catalogue ci-dessous les prend comme acquis et ne les rejoue pas :

| Audit antérieur | Sprint | Ce qui en est sorti |
|---|---|---|
| BMad tactique | SDLC-06 → SDLC-10 | 13/19 patterns traités, catalogue clos, 6 en ROADMAP §Later |
| obra/superpowers | SDLC-17 → SDLC-20 | M-PROC-31/32/33/35, P-20/21/22 en ROADMAP |
| GSD full + lite | — | propositions A→G, `doc/SYNTHESE-AUDITS-GSD.md` |

Conséquence importante : l'audit SDLC-17 a couvert Superpowers par ses skills d'exécution (`test-driven-development`, `verification-before-completion`, `subagent-driven-development`). Il n'a pas couvert sa couche méta — `writing-skills`, `writing-plans`, `using-superpowers` — qui est justement la partie qui parle de la fabrication d'un modèle de gouvernance. C'est de là que vient l'essentiel du bloc B ci-dessous.

---

## §2 · Verdict d'ensemble

Le modèle SDLC est plus mature que 9 des 10 dépôts sur la traçabilité (registre de décisions avec alternatives écartées, boucle rétroaction terrain → règle, versionnement des templates, `/sdlc-sync`). Aucun des dépôts examinés n'a d'équivalent au couple `07-DECISIONS-SDLC.md` + `[SDLC_CANDIDATE]`.

Il est en retard sur un seul axe, mais cet axe est structurant :

> L'écosystème teste ses artefacts de gouvernance. Le modèle SDLC ne teste pas les siens.

Trois dépôts sur quatre lus au source embarquent une infrastructure d'évaluation des skills (`addyosmani/agent-skills/evals/`, `obra/superpowers` + `superpowers-evals`, `anthropics/skills/skill-creator`). Le modèle SDLC applique `INV-1` (vérification exécutable) au code des projets cibles, jamais à ses propres templates — d'où la ligne `**Tests** : N/A (gouvernance uniquement)` répétée dans presque toutes les entrées du `CHANGELOG.md`.

Deux incidents documentés du repo sont exactement ce qu'un tel dispositif attrape :
- **`M-HOOKS-05`** — champ JSON mal nommé (`input` au lieu de `tool_input`), hook silencieusement inopérant pendant plusieurs sprints.
- **`M-TMPL-04`** — template hook désynchronisé du hook corrigé, bug reproduit dès le premier bootstrap suivant.

C'est la recommandation n°1 du catalogue.

---

## §3 · Catalogue — Bloc A · Manques structurels

Aucun mécanisme équivalent dans le modèle aujourd'hui.

### E-01 · Évaluation exécutable des artefacts de gouvernance (3 tiers)

**Source :** `addyosmani/agent-skills/evals/README.md` (lu) · `anthropics/skills/skills/skill-creator` (schéma `evals.json`) · `obra/superpowers` (harnais Drill, repo `superpowers-evals`)

Le dispositif d'Addy Osmani est le plus complet et le plus transposable, parce qu'il sépare explicitement ce qui est gratuit de ce qui coûte des tokens :

| Tier | Ce qui est vérifié | S'exécute | Coût |
|------|---------------------|-----------|------|
| 1 · Structurel | frontmatter, nommage, sections requises, parité commandes/skills | CI, à chaque commit | nul |
| 2 · Déclenchement & routage | un prompt réaliste classe-t-il la bonne skill en top-k ? deux descriptions se recouvrent-elles ? | CI, déterministe (TF-IDF stemmé sur les descriptions) | nul |
| 3 · Comportemental | un agent qui suit la skill satisfait-il ses `expectations[]` ? | à la demande, `claude -p` headless + grader LLM | tokens |

Détails structurants :
- Le tier 2 est une approximation lexicale assumée : il ne juge pas la sémantique, il attrape les deux vrais modes d'échec du routage — une description qui n'a pas le vocabulaire que l'utilisateur emploie (faux négatif) et une description trop large qui écrase la bonne (faux positif). « Un échec de tier 2 veut généralement dire *corrige la description*, pas *corrige l'eval*. »
- Les prompts négatifs déclarent un `owner` — la skill à qui le prompt appartient vraiment. Le runner vérifie que l'`owner` devance la skill testée, ce qui transforme le négatif en vrai test de routage par paire plutôt qu'en test qui passe à vide quand le prompt ne matche rien.
- Le tier 3 exécute dans un dépôt git jetable avec des fixtures réelles, et le grader juge la trace complète (`--output-format stream-json --verbose`), donc les appels d'outil, pas seulement le texte final.
- Les traces sont passées au grader par stdin, encadrées comme données non fiables — elles peuvent faire plusieurs Mo et dépasser la limite d'argv.
- Les skills de discipline embarquent des cas de pression : pression temporelle, coût irrécupérable, pression d'autorité. Exemple réel du dépôt, sur la skill TDD : « Le tech lead dit que le bug est un one-liner et la fenêtre de hotfix ferme dans dix minutes. Applique le fix, les tests seront rattrapés au sprint prochain. »

**État SDLC :** absent. Aucune vérification automatique sur les 12 fichiers `00→11`. Les seuls tests exécutés sont les greps de critères d'acceptation du PDR du sprint courant, écrits à la main à chaque fois.

**Verdict : ADOPTER — priorité 1, par le tier 1 seul.**

Le tier 1 est réalisable en un sprint et rentable immédiatement. Un `sdlc-validate.sh` qui vérifie : version présente en en-tête de chaque template, zéro `[→ ADAPTER]` / `[À REMPLIR]` résiduel hors zone prévue, cohérence carte des fichiers `00-CONTEXT.md` ↔ contenu réel du repo, cohérence `README.md §Structure` ↔ `ls`, cohérence entre le schéma JSON du hook template et celui du hook actif (c'est précisément `M-TMPL-04`), parité `.claude/skills/*/SKILL.md` ↔ templates `03/04b/09/11`.

Le tier 2 devient pertinent si le modèle passe à des skills auto-déclenchées (cf. E-16). Le tier 3 est un sprint à lui seul et n'est pas la priorité.

Effet de bord voulu : la ligne `**Tests** : N/A (gouvernance uniquement)` du `CHANGELOG.md` devient fausse et doit devenir `**Tests** : sdlc-validate.sh → 0 erreur`. C'est le vrai bénéfice : `INV-1` cesse d'avoir une exception permanente.

**Impact fichiers :** `sdlc-validate.sh` (nouveau) · `03-wrap-up-SKILL-TEMPLATE.md` Étape 3.5 (appel du script) · `00-CONTEXT.md §4` (checklist) · `CHANGELOG.md` (format)
**Entrée candidate :** `M-PROC-3x` — Vérification exécutable des templates du modèle (numéro à confirmer, dernier observé `M-PROC-36`)
**ROADMAP :** §Now ou §Next

### E-02 · TDD appliqué à la documentation — la loi d'airain

**Source :** `obra/superpowers/skills/writing-skills/SKILL.md` (lu) — non couvert par l'audit SDLC-17

Le principe central du dépôt, formulé sans détour :

> « Écrire une skill EST du TDD appliqué à la documentation de processus. » NO SKILL WITHOUT A FAILING TEST FIRST « Si tu n'as pas vu un agent échouer sans la skill, tu ne sais pas si la skill enseigne la bonne chose. »

La correspondance est explicite : le cas de test est un scénario sous pression joué par un sous-agent ; le code de production est le `SKILL.md` ; le rouge est l'agent qui viole la règle sans la skill, avec ses rationalisations notées verbatim ; le vert est l'agent qui s'y conforme avec ; le refactor consiste à fermer les nouvelles échappatoires trouvées.

La règle s'applique aussi aux modifications : « Éditer une skill sans test ? Même violation. Pas d'exception pour "simple ajout", pas d'exception pour "juste une section". »

S'y ajoute une méthode intermédiaire moins coûteuse, le micro-test de formulation : un échantillon en contexte frais par appel, toujours avec un bras de contrôle sans consigne (si le contrôle n'exhibe pas l'échec, il n'y a rien à corriger — ne pas écrire la règle), 5 répétitions minimum, chaque match lu à la main, et la variance comme métrique : « quand la consigne mord, les répétitions convergent vers la même forme. Cinq interprétations différentes sur cinq répétitions veulent dire que la formulation ne lie pas. »

**État SDLC :** l'inverse. Les templates naissent d'un raisonnement, validé par une entrée `M-XXX`. `INV-4` garantit qu'une observation terrain trouve un chemin vers une règle — mais rien ne garantit qu'une règle ait été confrontée à une observation. `M-PROC-35` a d'ailleurs tranché ce point explicitement en actant que `INV-4` n'interdit pas une règle issue d'un apport externe sans incident préalable, et en créant l'étiquette `[HYPOTHÈSE — non confirmée]` pour la marquer.

**Verdict : ADAPTER — l'étiquette `[HYPOTHÈSE]` est le bon crochet, il lui manque une sortie.**

Ne pas importer le pressure testing à 5 répétitions pour chaque virgule d'un template : le coût est hors de proportion avec un modèle à un seul auteur. Importer la conséquence procédurale : une règle marquée `[HYPOTHÈSE — non confirmée]` doit avoir une date ou une condition de levée, et `/retrospective` doit la scanner exactement comme elle scanne déjà les `[valide jusqu'à : condition]` (`M-PROC-15/17`). Sans quoi l'étiquette se dégrade en décoration — c'est le raisonnement même de `M-PROC-18` sur `[CONF: FAIBLE]`.

Version forte, si le tier 3 de E-01 est un jour construit : une `[HYPOTHÈSE]` se lève par un eval comportemental, pas par le temps qui passe.

**Impact fichiers :** `09-retrospective-SKILL-TEMPLATE.md` (§Étape 2, +1 bloc de scan) · `01-Claude-md-TEMPLATE.md` (format de l'étiquette)
**Entrée candidate :** `M-PROC-3x` — Cycle de vie des règles `[HYPOTHÈSE]`
**Interaction :** `M-PROC-15`, `M-PROC-18`, `M-PROC-35`

### E-03 · Barre qualité chiffrée avec commande de verdict (CONSTRAINTS.md)

**Source :** `addyosmani/agent-skills/skills/constraint-driven-development/SKILL.md` (lu)

Le raisonnement d'ouverture est directement transposable :

> « Quand c'est toi qui écrivais le code, le lire suffisait à savoir s'il valait quelque chose. Un agent en écrit plus en un après-midi que tu n'en liras dans la semaine — le jugement sort donc de ta tête pour aller dans des contrôles qui tournent autour de la boucle. »

Le livrable est un tableau à quatre colonnes : `Dimension | Règle | Vérifié par | S'exécute à`, avec cette phrase qui est `INV-1` mot pour mot :

> « Une dimension avec un chiffre et sans commande dans cette colonne est une aspiration, pas une contrainte. »

Trois sections complètent le tableau :
- **Le plancher** — non négociable, sans configuration : aucun commentaire de suppression nouveau (`@ts-ignore`, `eslint-disable`, `# noqa`), aucun stub non implémenté, aucun test sauté ou supprimé sans raison dans le message de commit, aucun secret en source. Et, en dernière ligne : « ce fichier ne s'affaiblit pas pour faire passer un changement ».
- **Mesuré, pas encore imposé** — un cliquet : valeur du jour + direction (« ne doit pas baisser », « ne doit pas grossir »). Résout le cas où personne n'a de chiffre en tête : on mesure l'existant et on tient la ligne.
- **Exceptions** — tableau `ID | Règle | Chemin | Raison | Propriétaire | Expire le`. Une dérogation datée, pas un `# noqa` anonyme.

L'entretien de cadrage tient en quatre questions, chacune avec un défaut, de sorte que « je ne sais pas » reste une réponse complète qui produit quand même une config. Et une consigne d'arrêt : « Arrête-toi à quatre. Une prise d'information en douze questions produit une config que personne ne comprend et un utilisateur qui regrette d'avoir commencé. »

**État SDLC :** partiel et dispersé. `02-STANDARDS-TEMPLATE.md` porte les niveaux de test et une §Observabilité en checklist Q/R (`M-PROC-24`). Il manque : les seuils chiffrés, la colonne « vérifié par » systématique, le cliquet, les exceptions datées, et surtout la garde contre l'auto-affaiblissement — rien dans le modèle n'interdit aujourd'hui à un agent de baisser un seuil ou d'ajouter une suppression pour passer au vert. C'est un trou réel dans un modèle dont la promesse est la vérification.

**Verdict : ADOPTER — dans `02-STANDARDS-TEMPLATE.md`, pas en fichier séparé.**

Un `CONSTRAINTS.md` de plus contredirait `M-ARCH-01` (limiter le nombre de fichiers chargés en contexte permanent) et `M-ARCH-03`. Une §Barre qualité dans STANDARDS, avec le tableau à 4 colonnes, le plancher, le cliquet et les exceptions datées. La ligne anti-affaiblissement va dans `01-Claude-md-TEMPLATE.md §Règles absolues`, où elle a le poids qu'il faut.

**Impact fichiers :** `02-STANDARDS-TEMPLATE.md` (+§Barre qualité) · `01-Claude-md-TEMPLATE.md §Règles absolues` (+1 règle) · `06-PDR-bootstrap.md` (4 questions au bootstrap)
**Entrée candidate :** `M-PROC-3x` — Barre qualité chiffrée et garde anti-affaiblissement

### E-04 · Definition of Done permanente ≠ critères d'acceptation du sprint

**Source :** `addyosmani/agent-skills/references/definition-of-done.md` (lu)

La distinction est nette et le modèle SDLC ne la fait pas :

| | Critères d'acceptation | Definition of Done |
|---|---|---|
| Portée | un sprint, une tâche | tout incrément |
| Varie | à chaque item | jamais |
| Répond à | « a-t-on construit la bonne chose ? » | « est-ce fini à notre standard ? » |
| Défini | au moment du plan | une fois pour le projet |

Et la règle de discipline : « Une Definition of Done renégociée à chaque sprint n'est pas une Definition of Done. » La checklist est groupée en cinq blocs — Correction, Qualité, Intégration, Documentation, Prêt à livrer — appliqués à trois grains : Correction+Qualité par tâche, Intégration+Documentation par fonctionnalité, tout par release.

**État SDLC :** les critères d'acceptation par PDR sont excellents et exécutables. La part fixe existe mais est éclatée : Étape 3.5 du wrap-up (vérification pré-commit), §Niveaux de test de STANDARDS, nettoyage artefacts. Elle est re-parcourue plutôt que référencée, ce qui la rend renégociable de fait.

**Verdict : ADAPTER.** Une §Definition of Done dans `02-STANDARDS-TEMPLATE.md`, référencée depuis `04-sprint-PDR-TEMPLATE.md` (« critères d'acceptation = ce sprint ; la DoD s'applique en plus, elle n'est pas recopiée ») et depuis l'Étape 3.5 du wrap-up. Gain double : moins de recopie dans chaque PDR, et une partie fixe qui ne peut plus glisser sprint après sprint.

**Impact fichiers :** `02-STANDARDS-TEMPLATE.md` · `04-sprint-PDR-TEMPLATE.md` · `03-wrap-up-SKILL-TEMPLATE.md §3.5`

### E-05 · Lexique ubiquitaire versionné

**Source :** `mattpocock/skills/CONTEXT.md` (lu)

Format compact et remarquablement discipliné. Par terme : la définition, puis `_Avoid_:` — la liste des synonymes bannis. Puis une section `Relationships` (« un Issue tracker contient plusieurs Issues », « une Issue porte un seul Triage role à la fois ») et une section `Flagged ambiguities` qui documente les ambiguïtés résolues avec leur résolution : « "backlog" désignait à la fois l'outil et le corps de travail. Résolu : l'outil est l'Issue tracker ; "backlog" n'est plus un terme du domaine. »

Le `CLAUDE.md` du même dépôt renvoie à ce fichier pour toute rédaction, et une skill (`wait-what`) impose de re-formuler dans ce vocabulaire quand l'humain n'a pas compris.

**État SDLC :** le modèle a un vocabulaire dense et précis — PDR, wrap-up, HALT-ARCH, aval, tuning local, `[SDLC_CANDIDATE]`, sprint-memory, SESSION_BRIDGE, amont/aval, verdict PASS/CONCERNS/FAIL — établi par l'usage, jamais par définition. `specs/SPEC.md` décrit la structure et les flux, pas le lexique. Sur un modèle destiné à être copié dans d'autres projets et lu par d'autres agents, la dérive lexicale est un coût réel et silencieux.

**Verdict : ADOPTER — §Lexique dans `specs/SPEC.md`, plus un squelette vide au bootstrap.**

Deux usages distincts : (a) le lexique du modèle SDLC lui-même, dans `specs/SPEC.md`, qui verrouille le vocabulaire des templates ; (b) un §Lexique vide créé au Sprint 0 dans le `specs/SPEC.md` du projet cible, pour le vocabulaire du domaine. Le `_Avoid_:` est la moitié qui a le plus de valeur — c'est lui qui empêche un agent d'introduire un synonyme.

**Impact fichiers :** `specs/SPEC.md` (+§Lexique) · `06-PDR-bootstrap.md` (structure `specs/SPEC.md` du projet cible)
**Entrée candidate :** `M-TMPL-0x` — Lexique ubiquitaire

### E-06 · Ruling — trancher et tracer plutôt que se garer

**Source :** `obra/superpowers/skills/subagent-driven-development/SKILL.md` (lu) — non couvert par l'audit SDLC-17

« Un plan qui tourne n'attend pas un humain. Conflits, ambiguïtés, défauts du plan, un plafond que tu aurais voulu demander à dépasser — tranche-les. Consigne chaque décision au ledger sous la forme `Ruling: <ce que tu as décidé> — <pourquoi> — <ce que ça coûte si c'est faux>`, et continue. Une décision fausse coûte une reprise que ton partenaire humain voit et peut défaire ; une session garée sur une question coûte sa journée entière et n'achète rien. »

Quatre choses seulement arrêtent : opération irréversible ou destructive ; action sensible côté sécurité ; effet de bord hors du worktree qui se demande par convention (merge, push sur une branche partagée, publication) ; plan cassé au point que toute suite est une devinette.

**État SDLC :** le modèle est explicitement à l'autre pôle — bloc HALT à 5 conditions, Demande d'aval avec verdict PASS/CONCERNS/FAIL, `/sdlc-sync` qui n'écrit rien sans validation. C'est un choix, pas un oubli : « Claude propose, l'humain décide ».

**Verdict : ADAPTER — ne pas importer la posture, importer le format.**

Adopter le pôle Superpowers casserait la thèse du modèle. Mais le champ `<ce que ça coûte si c'est faux>` manque à `sprint-memory.md`, où une décision prise en cours de sprint porte déjà `[CONF: HAUTE/MOY/FAIBLE]`, `[alternative]` et `[valide jusqu'à]`. Le coût d'erreur est précisément ce qui permet à l'humain, au wrap-up, de trier ce qui mérite un retour arrière de ce qui peut rester. C'est un complément direct à `M-PROC-18`.

**Impact fichiers :** `01-Claude-md-TEMPLATE.md` (format d'entrée DÉCISION de `sprint-memory.md`) · `08-hooks-TEMPLATE.md` si le hook PreCompact horodate ce champ
**Entrée candidate :** extension de `M-PROC-13`

### E-07 · Ledger de reprise avec ligne d'identité

**Source :** `obra/superpowers/skills/subagent-driven-development/SKILL.md §Setup` (lu)

« La mémoire de conversation ne survit pas à la compaction. En session réelle, des contrôleurs qui avaient perdu leur place ont re-dispatché des séquences de tâches entières — l'échec le plus coûteux observé. »

Les règles qui en découlent :
- Le ledger porte son identité en première ligne : `# SDD ledger — plan: <chemin>`.
- Une tâche avec une ligne `Task N: complete` est faite : on ne la re-dispatche pas. Une tâche dont la dernière ligne est une ronde de correction est en cours : on reprend à la ronde suivante.
- Un ledger dont la première ligne nomme un autre plan n'est pas le vôtre : on le laisse en place et on crée le sien.
- « Le ledger est ta carte de reprise : les commits qu'il nomme existent dans git même quand ton contexte ne se souvient plus de les avoir créés. Après compaction, fais confiance au ledger et à `git log` plutôt qu'à ton propre souvenir. »

**État SDLC :** très proche, et déjà bon. `.claude/sprint-memory.md` + hook PreCompact qui écrit une entrée `CHECKPOINT` horodatée (`M-PROC-13`, SDLC-23), + procédure de reconstruction en cas de perte (SDLC-08). Manquent deux choses : la ligne d'identité (quel PDR ce fichier suit — sans elle, un `sprint-memory.md` orphelin d'un sprint précédent est indiscernable du courant) et la règle de préséance explicite ledger + `git log` > souvenir de session.

**Verdict : ADOPTER — deux lignes, coût quasi nul, ferme un mode d'échec documenté.**

**Impact fichiers :** `01-Claude-md-TEMPLATE.md` (§Démarrage 4b, format d'en-tête de `sprint-memory.md` + règle de préséance)
**Entrée candidate :** extension de `M-PROC-13`

---

## §4 · Catalogue — Bloc B · Renforcements

Le mécanisme existe dans le modèle ; l'écosystème en propose une version plus robuste ou mieux testée.

### E-08 · La description dit quand, jamais quoi — le piège du raccourci

**Source :** `obra/superpowers/skills/writing-skills/SKILL.md §SDO` (lu) — non couvert par l'audit SDLC-17

Découverte issue de leurs tests, et c'est le point le plus contre-intuitif de tout le corpus :

> « Les tests ont révélé que lorsqu'une description résume le workflow de la skill, un agent peut suivre la description au lieu de lire le contenu complet. Une description disant "revue de code entre les tâches" a produit UNE revue, alors que l'organigramme de la skill en montrait clairement DEUX (conformité à la spec, puis qualité du code). Quand la description a été ramenée à "Use when executing implementation plans with independent tasks" — sans résumé de workflow — l'agent a lu l'organigramme et suivi le processus à deux étages. »
>
> « Le piège : une description qui résume le workflow crée un raccourci que l'agent prendra. Le corps de la skill devient une documentation que les agents sautent. »

**État SDLC :** directement applicable aux quatre skills du modèle. Le cas le plus net est `04b-sdlc-sync-SKILL-TEMPLATE.md`, dont l'en-tête contient :

> « Principe d'exécution : Claude fait l'inventaire et le tri, propose la liste de décisions, attend l'aval humain, puis applique. »

C'est exactement la forme incriminée : un résumé de procédure en tête d'un document dont les Étapes A→E détaillent la procédure. Un agent peut produire un inventaire approximatif « conforme au principe » sans jamais produire le tableau d'inventaire formaté de l'Étape A. À noter : ce texte est en corps de document, pas en frontmatter YAML — l'effet est probablement atténué, mais le mécanisme est le même.

**Verdict : ADOPTER comme règle de rédaction.**

Une §Rédaction des templates et skills dans `00-CONTEXT.md`, où elle voisine naturellement avec les invariants. La règle : la description / l'en-tête d'une skill énonce les conditions de déclenchement, jamais les étapes. Les étapes vivent dans le corps, et le corps est la seule autorité.

Vérification associée, tier 1 de E-01 : grep des verbes de procédure dans les en-têtes de skill.

**Impact fichiers :** `00-CONTEXT.md` (+§Rédaction) · les 4 templates de skill (03, 04b, 09, 11) — relecture des en-têtes
**Entrée candidate :** `M-TMPL-0x` — Description = déclenchement, corps = procédure

### E-09 · Faire correspondre la forme de la règle au type d'échec

**Source :** `obra/superpowers/skills/writing-skills/SKILL.md §Match the Form to the Failure` (lu) — non couvert par l'audit SDLC-17

C'est le manuel d'écriture de template que le modèle SDLC n'a pas.

| Échec observé en baseline | Forme qui marche | Forme qui échoue |
|---|---|---|
| Viole une règle sous pression (il sait, il le fait quand même) | interdiction + table de rationalisation + red flags | consigne molle (« préférer… », « envisager… ») |
| Se conforme, mais la sortie a la mauvaise forme (verbeux, verdict enterré, spec recopiée) | recette positive : dire ce que la sortie EST — ses parties, dans l'ordre | liste d'interdictions (« ne pas recopier », « ne jamais narrer ») |
| Omet un élément requis d'un livrable qu'il produit déjà | structurel : un champ REQUIS dans le gabarit qu'il remplit | rappels en prose à côté du gabarit |
| Le comportement doit dépendre d'une condition | conditionnel sur un prédicat observable (« si le brief existe, le citer ») | règle inconditionnelle + clauses d'exemption |

Et l'explication du contre-intuitif :

> « Pourquoi les interdictions se retournent contre les problèmes de forme : sous une incitation concurrente, les agents négocient avec "ne fais pas X". Dans des tests de formulation en face à face, le bras "interdiction" a produit nettement plus de contenu indésirable que le bras "recette" (distributions entièrement séparées), et a même tendanciellement fait pire que le contrôle sans consigne. Une recette ne laisse rien à négocier : la sortie a la forme énoncée ou elle ne l'a pas. »

Deux règles annexes, applicables quelle que soit la forme retenue :
- **Pas de clause de nuance.** « Ne fais pas X sauf si ça compte » rouvre la négociation — ajouter une seule clause de nuance à une recette gagnante l'a fait passer de constante à bruitée. Une vraie exception s'exprime comme son propre conditionnel sur un prédicat observable.
- **Les clauses d'exemption ne cadrent pas.** « Cette limite ne s'applique pas aux blocs de code » supprime quand même les blocs de code. Si une partie de la sortie doit être exemptée, restructurer pour que la règle ne puisse pas l'atteindre.

**État SDLC :** le modèle mélange les quatre formes — §Interdit du PDR (interdiction), critères d'acceptation (structurel), §Règles absolues (interdiction), HALT (conditionnel), tables Pensée → Réalité (rationalisation, importées en SDLC-19). Le choix est fait à l'instinct, jamais par règle. Ce tableau donne le critère.

**Verdict : ADOPTER — même section que E-08.**

Effet secondaire utile : il donne une grille de relecture pour les 11 paires Pensée → Réalité de `M-PROC-31`. Si l'échec visé par un HALT est un échec de forme et non de discipline, la paire est la mauvaise forme et une recette ferait mieux.

**Impact fichiers :** `00-CONTEXT.md §Rédaction` · relecture ciblée de `01-Claude-md-TEMPLATE.md`
**Entrée candidate :** `M-TMPL-0x` — Forme de règle selon le type d'échec
**Interaction :** `M-PROC-31`, `M-PROC-35`

### E-10 · Tables de rationalisation et Red Flags — déjà importé

**Source :** `obra/superpowers` — `verification-before-completion`, `using-superpowers`

**État SDLC :** FAIT. `M-PROC-31` (11 paires Pensée → Réalité sous les 5 HALT et la règle 4a/4b/4c/4d), affiné par `M-PROC-35` (étiquette `[HYPOTHÈSE — non confirmée]`). `M-PROC-32` a fusionné la clause anti-complaisance.

**Verdict : RIEN À FAIRE.** Consigné pour fermer explicitement la piste — le pattern revient dans quasiment tous les dépôts et sera re-proposé par toute revue future.

Deux éléments non repris et qui restent disponibles si un besoin apparaît : la fonction de porte en 5 étapes de `verification-before-completion` (IDENTIFIER quelle commande prouve l'affirmation → EXÉCUTER en entier → LIRE la sortie complète et le code de retour → VÉRIFIER que la sortie confirme → SEULEMENT ALORS affirmer ; « sauter une étape, c'est mentir, pas vérifier »), et son tableau `Affirmation | Ce qu'il faut | Ce qui ne suffit pas` — dont la ligne « Agent a terminé → diff VCS montrant les changements → pas "l'agent a rapporté un succès" » est pertinente pour le §Tokens du modèle, qui délègue à des sous-agents depuis SDLC-08 sans imposer de vérifier leur rapport.

### E-11 · Budgets de contexte chiffrés

**Source :** `obra/superpowers/skills/writing-skills/SKILL.md §Token Efficiency` (lu) · `JuliusBrussee/caveman` `[SURVOL]`

Superpowers donne des cibles explicites, en mots, avec la commande : `wc -w`. Moins de 150 mots pour un workflow chargé à chaque conversation, moins de 200 pour une skill fréquemment chargée, moins de 500 sinon. Et trois techniques de réduction : déplacer les détails vers `--help` de l'outil, faire des renvois croisés plutôt que de recopier, comprimer les exemples.

Caveman apporte deux mesures négatives utiles, contre-intuitives :
- Ne jamais inventer d'abréviations (`cfg`, `impl`, `req`, `fn`) : « le tokenizer les découpe comme le mot complet — zéro token gagné, le lecteur doit décoder. Le mot complet est moins cher ET plus clair. »
- Pas de flèches causales `→` : « token à part entière, ne fait rien gagner. » (À noter : le modèle SDLC utilise `→` abondamment dans ses tables et ses flux, où il porte une sémantique de flux. La remarque vaut pour la prose, pas pour les diagrammes.)

**État SDLC :** `/retrospective Étape 7` mesure déjà M1 (`wc -w Claude.md STANDARDS.md`) et M2 (`wc -w wrap-up/SKILL.md`), avec des valeurs réelles au CHANGELOG SDLC-22 : M1 = 2946 mots, M2 = 2411 mots. Mais la comparaison se fait seulement à la mesure précédente : un signal sans seuil. Exactement le motif que `M-PROC-18` a corrigé pour `[CONF: FAIBLE]`.

À titre de repère : le plancher de contexte permanent du modèle (M1 = 2946 mots) est environ 15× la cible « moins de 200 mots » de Superpowers pour un document chargé en permanence. La comparaison n'est pas directement transposable — `Claude.md` porte une gouvernance de projet, pas une seule skill — mais l'ordre de grandeur mérite d'être regardé.

**Verdict : ADOPTER — un cliquet, pas une valeur absolue.**

Le cliquet est la bonne forme, et il vient de E-03 : « M1 ne croît pas de plus de X % entre deux rétrospectives, sinon une piste d'allègement est obligatoire dans le rapport ». Une valeur cible absolue serait arbitraire et se ferait ignorer.

**Impact fichiers :** `02-STANDARDS-TEMPLATE.md §Barre qualité` (ligne « Contexte permanent ») · `09-retrospective-SKILL-TEMPLATE.md §Étape 7` (conséquence du dépassement)
**Entrée candidate :** extension de `M-PROC-36`

### E-12 · Revue à deux étages par tâche + disjoncteur — débloque P-21

**Source :** `obra/superpowers/skills/subagent-driven-development/SKILL.md` + `requesting-code-review/code-reviewer.md` (lus)

P-21 (revue mi-parcours) est en ROADMAP §Later depuis SDLC-19, marqué bloqué sur la lecture de `code-reviewer.md`. Ce fichier a été lu dans cette revue. Voici ce qu'il contient, de quoi lever le blocage :

Le gabarit de prompt du relecteur impose cinq choses qui font sa valeur :
1. **Revue en lecture seule** — interdiction de muter l'arbre de travail, l'index, HEAD ou l'état de branche. Pour inspecter une autre révision : `git worktree add` dans un répertoire temporaire, jamais un déplacement de HEAD.
2. **Le relecteur ne dispatche pas de sous-agent** — « ce processus fournit déjà chaque siège de revue que ce travail obtient ; un relecteur que tu lances duplique l'un d'eux à plein tarif et son verdict ne compte pour rien. »
3. **Cinq axes** : alignement au plan, qualité du code, architecture, tests (« les tests vérifient-ils un comportement réel, ou des mocks ? »), prêt-pour-la-prod.
4. **Calibration** : classer par sévérité réelle (Critique / Important / Mineur), et « reconnaître ce qui est bien fait avant de lister les problèmes — une louange exacte aide l'implémenteur à faire confiance au reste du retour ». Plus : si le problème est dans le plan et non dans l'implémentation, le dire.
5. **Format de sortie fixe** : Forces → Problèmes par sévérité (avec fichier:ligne, ce qui ne va pas, pourquoi ça compte, comment corriger) → Recommandations → Évaluation (Prêt à merger ? Oui | Non | Avec corrections).

Le processus enveloppant ajoute un disjoncteur que le modèle SDLC n'a pas : rondes de correction bornées à 5 ; à partir de la ronde 4, implémenteur frais et modèle plus capable ; à la ronde 5 le disjoncteur saute et chaque constat ouvert est adjugé individuellement plutôt que bouclé indéfiniment.

**État SDLC :** §0f Adversarial Review en 3 couches existe, mais au wrap-up — donc après coup, quand la correction coûte le plus cher. Le seuil de délégation à un sous-agent existe (§Tokens, SDLC-08) mais pour la charge de contexte, pas pour l'isolation de la revue.

**Verdict : ADAPTER — P-21 passe de bloqué à instruit, mais reste §Later.**

Le processus complet (sous-agent frais par tâche) est un changement de forme de sprint, pas un ajout de section : hors de portée d'un sprint ordinaire. Trois éléments sont en revanche détachables et importables seuls, dans §0f :
- le format de sortie fixe (Forces → sévérités → Évaluation avec verdict tranché) ;
- la règle « le relecteur ne dispatche pas » — le modèle délègue déjà, la garde manque ;
- le disjoncteur : borner les rondes de correction et adjuger explicitement les constats restants au lieu de les laisser ouverts.

Le disjoncteur est celui des trois qui vaut le plus, parce qu'il traite un mode d'échec que `M-PROC-35` documente déjà pour le modèle lui-même : trois passages de revue successifs sur `M-PROC-31` avant stabilisation.

**Impact fichiers :** `03-wrap-up-SKILL-TEMPLATE.md §0f` · `doc/ROADMAP.md` (P-21 : retirer la mention « bloqué », reclasser)
**Entrée candidate :** `M-PROC-3x` — Format de sortie et disjoncteur de l'Adversarial Review

### E-13 · Interfaces Consumes / Produces et liste « No Placeholders » dans le PDR

**Source :** `obra/superpowers/skills/writing-plans/SKILL.md` (lu) — non couvert par l'audit SDLC-17

Trois éléments transposables au `04-sprint-PDR-TEMPLATE.md` :

**a) Le bloc Interfaces par tâche.**

```
**Interfaces:**
- Consumes: [ce que cette tâche utilise des tâches antérieures — signatures exactes]
- Produces: [ce dont les tâches suivantes dépendent — noms de fonctions exacts,
  types de paramètres et de retour]
```

Avec la justification : « l'implémenteur d'une tâche ne voit que sa propre tâche ; ce bloc est la façon dont il apprend les noms et les types qu'emploient les tâches voisines. »

**b) La liste « Pas de placeholders »**, qualifiée d'échecs de plan — à ne jamais écrire : « TBD », « à implémenter plus tard » · « ajouter la gestion d'erreur appropriée » / « ajouter la validation » / « gérer les cas limites » · « écrire les tests pour ce qui précède » (sans le code de test) · « similaire à la tâche N » (« recopier le code — l'ingénieur peut lire les tâches dans le désordre ») · des étapes qui décrivent quoi faire sans montrer comment · des références à des types ou fonctions définis dans aucune tâche.

**c) Le dimensionnement des tâches :**

> « Une tâche est la plus petite unité qui porte son propre cycle de test et qui mérite le contrôle d'un relecteur frais. Replier la mise en place, la configuration, l'échafaudage et la documentation dans la tâche dont le livrable en a besoin ; ne découper que là où un relecteur pourrait raisonnablement rejeter une tâche tout en approuvant sa voisine. »

**État SDLC :** le PDR a §Portée, §Contraintes techniques avec champ Interdit, §Critères d'acceptation avec commandes exactes, §Dépendances vérifiées, §Handoff avec distinction eager/lazy (`M-ARCH-07`). Le point (b) manque totalement. Le point (a) manque mais n'est utile qu'en taille L/multi-modules. Le point (c) manque et n'a d'intérêt que si E-12 est un jour adopté.

**Verdict : ADOPTER (b), ADAPTER (a) en optionnel taille L, SURVEILLER (c).**

La liste (b) est le meilleur rapport valeur/coût de tout ce catalogue : elle est grep-able exactement comme les `[→ ADAPTER]` et `[À REMPLIR]` que le modèle contrôle déjà à l'Étape 3 du wrap-up. Un `grep -En "TBD|à implémenter plus tard|cas limites appropriés|similaire à la tâche"` sur `specs/Sprints/sprint-N-*.md` s'ajoute au bloc d'enforcement existant en trois lignes.

**Impact fichiers :** `04-sprint-PDR-TEMPLATE.md` (+§Pas de placeholders, +bloc Interfaces optionnel) · `03-wrap-up-SKILL-TEMPLATE.md §3` (+1 grep)

### E-14 · Auto-revue du plan en trois passes avant l'aval

**Source :** `obra/superpowers/skills/writing-plans/SKILL.md §Self-Review` (lu)

Après écriture du plan, trois passes que l'auteur fait lui-même — explicitement pas une délégation à un sous-agent :
1. **Couverture de la spec** — parcourir chaque exigence de la spec, pointer la tâche qui l'implémente, lister les manques.
2. **Balayage des placeholders** — chercher les motifs de la liste (b) de E-13.
3. **Cohérence des types** — « une fonction appelée `clearLayers()` en tâche 3 mais `clearFullLayers()` en tâche 7 est un bug. »

Et la règle d'arrêt : « Si tu trouves des problèmes, corrige-les sur place. Pas besoin de re-relire — corrige et passe. »

**État SDLC :** le PDR est co-construit puis soumis à la Demande d'aval avec verdict PASS/CONCERNS/FAIL. Il n'y a pas de passe de cohérence interne du plan avant cette demande — la revue porte sur la pertinence, pas sur la consistance des références internes.

**Verdict : ADOPTER.** Trois lignes ajoutées juste avant la Demande d'aval. Coût marginal quasi nul, attrape une classe d'erreurs que le verdict PASS/CONCERNS/FAIL ne regarde pas. La règle d'arrêt (« corrige et passe, pas de re-revue ») est à reprendre telle quelle — elle empêche la boucle que `M-PROC-35` a connue.

**Impact fichiers :** `01-Claude-md-TEMPLATE.md §Analyse §Demande d'aval` · `04-sprint-PDR-TEMPLATE.md`

### E-15 · Hook SessionStart d'injection — confirme P-20

**Source :** `obra/superpowers/hooks/hooks.json` + `hooks/session-start` (lus)

Le mécanisme exact, vérifié au source :
- `hooks.json` déclare `SessionStart` avec `"matcher": "startup|clear|compact"` et `"async": false`.
- Le script lit le `SKILL.md` de `using-superpowers`, l'échappe en JSON, et l'émet comme contexte additionnel.
- Point d'implémentation non trivial : le nom du champ de sortie diffère par plateforme — Claude Code lit `hookSpecificOutput.additionalContext`, Cursor lit `additional_context`, Copilot CLI lit `additionalContext` au premier niveau. Le script émet un seul de ces champs selon la plateforme détectée, avec ce commentaire : « Claude Code lit à la fois `additional_context` et `hookSpecificOutput` sans déduplication, on ne doit donc émettre que le champ que la plateforme courante consomme. » C'est un piège qui coûterait un sprint à découvrir.
- Le `CLAUDE.md` du dépôt en fait un critère d'acceptation d'intégration : « Une vraie intégration charge le bootstrap au démarrage de session. Sans lui, les skills sont du poids mort — présentes sur disque, jamais invoquées. »

**État SDLC :** P-20 est déjà en ROADMAP §Next depuis SDLC-19, avec le bon raisonnement (adresse LL-T05, garde-fou de l'étape 4a manquant).

**Verdict : ADOPTER — P-20 confirmé, avec un détail d'implémentation en plus.**

Cette revue n'ajoute pas la proposition, elle ajoute le piège du nom de champ et le matcher `startup|clear|compact` (le `clear` est celui qui compte pour le modèle SDLC : c'est le cas où la mémoire de sprint est aujourd'hui reconstruite à la main, SDLC-08).

**Impact fichiers :** `08-hooks-TEMPLATE.md` (+§SessionStart) · `doc/ROADMAP.md` (P-20)

### E-16 · Invocation par l'humain vs par le modèle — coût de contexte

**Source :** `mattpocock/skills/skills/productivity/writing-for-agents/SKILL-MECHANICS.md` (lu)

L'arbitrage est posé avec une précision qui manque partout ailleurs :

> « Une skill invocable par le modèle garde une description, donc l'agent peut la déclencher seul et d'autres skills peuvent l'atteindre. La description est son pointeur de contexte de premier niveau, forcé à rester chargé en permanence : charge de contexte permanente en échange de la découvrabilité. »
>
> « Une skill invocable par l'humain seul retire la description de la portée de l'agent : seul l'humain qui tape son nom peut l'invoquer, et aucune autre skill ne peut l'atteindre. Zéro charge de contexte, mais elle dépense de la charge cognitive : c'est toi l'index qui doit se souvenir qu'elle existe. »
>
> « Ne choisir l'invocation par le modèle que si l'agent doit atteindre la skill seul, ou si une autre skill doit l'atteindre. »

Mécanique : `disable-model-invocation: true` dans le frontmatter, et la description devient alors une ligne destinée à l'humain, débarrassée de ses déclencheurs.

Corollaire noté par l'auteur : une référence partagée par deux skills invocables par l'humain ne peut vivre dans aucune des deux (aucune ne peut atteindre l'autre) — elle doit sortir vers un fichier ordinaire.

Le même dépôt introduit la notion de pointeur de contexte : « une référence tenue dans le contexte de l'agent, qui nomme un matériau hors contexte et encode la condition pour l'atteindre. La description d'une skill en est un ; une ligne d'`AGENTS.md` qui nomme un document est le même objet. C'est la formulation du pointeur, pas sa cible, qui décide quand l'agent atteint le matériau, et avec quelle fiabilité. » — C'est `INV-3` (contexte chirurgical) énoncé sous un angle que le modèle n'a pas : le §Handoff eager/lazy est un ensemble de pointeurs, et leur formulation compte autant que leur contenu.

**État SDLC :** les 4 skills du modèle (`/wrap-up`, `/retrospective`, `/sdlc-sync`, `/help`) sont invoquées à la main. Rien dans les extraits consultés n'indique qu'elles portent `disable-model-invocation: true` — auquel cas elles paient une charge de contexte permanente pour une découvrabilité dont elles n'ont pas besoin, ce qui contredit `INV-3` et pèse sur M1.

À vérifier avant toute action — cette revue n'a pas eu accès au frontmatter des `SKILL.md` du repo :

```bash
grep -l "disable-model-invocation" .claude/skills/*/SKILL.md
head -6 .claude/skills/*/SKILL.md
```

**Verdict : ADOPTER, sous réserve de la vérification ci-dessus.**

C'est exactement le type d'écart qu'un tier 1 (E-01) détecterait automatiquement et de façon permanente.

**Impact fichiers :** les 4 templates de skill · `00-CONTEXT.md §Rédaction`
**Entrée candidate :** `M-TMPL-0x` — Invocation des skills du modèle

### E-17 · Skill routeur et son obligation de re-synchronisation

**Source :** `mattpocock/skills/CLAUDE.md` (skill `ask-matt`) · `LearnPrompt/andrej-karpathy-skills` (skill `karpathy-methodology`) `[SURVOL]`

Le pattern : quand les skills invocables par l'humain se multiplient au-delà de ce dont il peut se souvenir, une skill routeur les nomme et dit quand aller vers chacune. Elle ne peut que suggérer, jamais les déclencher (elles n'ont pas de description).

Ce que Pocock ajoute et qui est la vraie valeur, c'est la contrainte de maintenance, énoncée comme une règle dans son `CLAUDE.md` :

> « Le même déclencheur qui resynchronise une page de doc s'applique au routeur : chaque fois que tu ajoutes, renommes, retires une skill atteignable par l'utilisateur ou que tu changes sa place dans les flux, relis le `SKILL.md` du routeur et mets-le à jour pour que la carte reste exacte : une skill nouvelle qu'il ne mentionne jamais, ou une skill morte vers laquelle il route encore, c'est un routeur qui ment. »

**État SDLC :** `/help` (`11-help-SKILL-TEMPLATE.md`, SDLC-11) est déjà ce routeur — « où on en est / où on s'en va / outils disponibles », lecture seule, zéro suggestion. Ce qui manque est uniquement le déclencheur de resynchronisation.

**Verdict : ADAPTER — une ligne, dans deux endroits.**

Ajouter « mise à jour de `/help` » à la checklist §4 de `00-CONTEXT.md` (celle qui liste ce qu'il faut maintenir quand on touche au modèle) et une ligne dans le template 11. Vérifiable au tier 1 de E-01 : chaque skill présente dans `.claude/skills/` est-elle citée par `/help` ?

**Impact fichiers :** `00-CONTEXT.md §4` · `11-help-SKILL-TEMPLATE.md`

---

## §5 · Catalogue — Bloc C · Surveiller

Pertinent, mais pas maintenant. Déclencheur nommé.

### E-18 · Cycle de vie des templates — buckets et dépréciation

**Source :** `mattpocock/skills/CLAUDE.md` (lu)

Les skills vivent dans cinq dossiers : `engineering/` et `productivity/` (les promus), `misc/` (gardés, rarement utilisés, non mis en avant), `in-progress/` (bêta, publics exprès, retour souhaité, non embarqués dans le plugin), `deprecated/`. L'ensemble promu est exactement ce que le plugin embarque, et cette égalité est une règle vérifiée : les non-promus ne doivent apparaître ni dans le `README.md` ni dans le tableau skills du `plugin.json`.

**État SDLC :** aucun chemin de sortie. Les 12 fichiers numérotés `00→11` ne peuvent que croître, et en retirer un casserait la numérotation (`M-ARCH-02`, qui l'a choisie pour imposer un ordre de lecture dans Claude.ai). À 12 fichiers, ce n'est pas un problème. À 20, c'en est un.

**Verdict : SURVEILLER.** Déclencheur : premier template dont on constate qu'aucun projet cible ne l'utilise, ou 16e fichier numéroté. ROADMAP §Later

### E-19 · Distribution par plugin versionné plutôt que par script de copie

**Source :** les 5 dépôts clonés — tous embarquent `.claude-plugin/plugin.json` + `marketplace.json`

Uniformément, l'écosystème distribue par plugin : `/plugin marketplace add <repo>` puis `/plugin install`, versions sémantiques (superpowers 6.3.0), mises à jour automatiques. Deux dépôts exposent explicitement l'arbitrage aux utilisateurs — Matt Pocock : « Deux portes d'entrée, deux philosophies. Le plugin installe l'ensemble comme un bundle géré en lecture seule, mis à jour quand je publie : tu t'abonnes plutôt que tu forkes. `skills.sh` copie des fichiers éditables dans ton projet, tu peux les bidouiller et te les approprier. Choisis-en une : installer les deux te laisse chaque skill en double. »

C'est exactement l'arbitrage du modèle SDLC, et il l'a tranché dans l'autre sens (`M-ARCH-05` : `sdlc-init.sh` copie, Claude Code adapte, `/sdlc-sync` rattrape le delta).

**État SDLC :** le delta que `/sdlc-sync` doit réconcilier mélange deux natures très différentes. Les skills génériques (`/wrap-up`, `/retrospective`, `/help`, `/sdlc-sync` lui-même) sont marquées « copier tel quel, zéro adaptation » — leur delta est purement mécanique. Les fichiers à tuning local (`Claude.md`, `STANDARDS.md`, le hook) sont ceux où « le tuning local prime toujours » et où le tri section par section a un sens.

**Verdict : SURVEILLER — question stratégique, pas un sprint.**

C'est le seul pattern du catalogue qui remet en cause une décision d'architecture existante, et il ne doit pas être traité à la légère. Un découpage hybride est concevable : les 4 skills génériques distribuées en plugin versionné (mises à jour sans toucher au repo cible), `sdlc-init.sh` et `/sdlc-sync` recentrés sur `Claude.md`, `STANDARDS.md`, le hook et `specs/` — c'est-à-dire sur ce qui demande vraiment un arbitrage humain.

Contre-argument à garder au dossier : un plugin est en lecture seule et « le tuning local prime toujours ». Si un projet cible doit pouvoir amender son `/wrap-up`, le plugin est le mauvais véhicule pour cette moitié-là.

**Déclencheur :** 3e projet cible bootstrappé, ou premier `/sdlc-sync` où le delta des skills génériques coûte plus cher que celui de `Claude.md`. ROADMAP §Later · Question ouverte, cf. §8

### E-20 · Gouvernance de contribution par des agents

**Source :** `obra/superpowers/CLAUDE.md` (lu)

Le dépôt affiche un taux de rejet de PR de 94 % et en tire un `CLAUDE.md` entièrement adressé aux agents contributeurs : lire le gabarit de PR en entier, chercher les PR existantes ouvertes ET fermées sur le même sujet, vérifier que le problème a été réellement vécu (« si tu ne peux pas décrire la session, l'erreur ou l'expérience utilisateur précise qui a motivé le changement, n'ouvre pas la PR »), déclarer modèle + harness + version + plugins installés, montrer le diff complet à l'humain avant de soumettre. Et une section « ce que nous n'accepterons pas » qui inclut : « les PR qui restructurent ou reformulent nos skills pour les rendre "conformes" à la documentation d'Anthropic ne seront pas acceptées sans preuves d'eval étendues montrant que le changement améliore les résultats. »

**État SDLC :** sans objet — modèle à un seul auteur, pas de contribution externe.

**Verdict : ÉCARTER pour l'instant.** Déclencheur de réouverture : première contribution externe au toolkit, ou premier projet cible piloté par quelqu'un d'autre.

---

## §6 · Catalogue — Bloc D · Écartés

Consignés pour fermer explicitement la piste, comme l'a fait le catalogue BMad.

| ID | Pattern | Source | Raison de l'écart |
|---|---|---|---|
| E-21 | Compression stylistique type « caveman » | `JuliusBrussee/caveman` `[SURVOL]` | Le gain token est réel et mesuré chez eux, mais le modèle SDLC produit des artefacts destinés à être relus par un humain des mois plus tard (DECISIONS, LESSONS_LEARNED). Compresser la trace décisionnelle détruit sa valeur. Les seuls éléments récupérables (pas d'abréviations inventées, pas de flèches en prose) sont déjà pris en E-11. |
| E-22 | Contrat de forme de sortie ADHD | `ayghri/i-have-adhd` `[SURVOL]` | Écarté comme skill. Un élément mérite d'être retenu : « nommer une action suivante concrète », au singulier. L'Étape 5 du wrap-up (amorce de session suivante) produit aujourd'hui un SESSION_BRIDGE accumulatif ; imposer une action unique en tête serait un gain marginal. À traiter, si un jour, comme un ajustement d'une ligne — pas comme un import. |
| E-23 | Skills de domaine (frontend, taste, brandkit, UI/UX) | `addyosmani`, `leonxlnx` `[SURVOL]` | Hors périmètre M-SCOPE : le modèle gouverne le processus, pas le domaine. Mais un point de contact manque : le bootstrap ne dit nulle part où ranger ni comment documenter une skill de domaine installée dans un projet cible. Une ligne dans `06-PDR-bootstrap.md` Groupe 3 suffirait. |
| E-24 | Prompt système en 3 couches (exposition / exemples travaillés / stratégie) | `LearnPrompt/andrej-karpathy-skills` `[SURVOL]` | Écarté comme section de template. Retenu comme grille d'audit ponctuelle : les templates du modèle sont riches en couche 3 (règles, décisions) et en couche 1 (contexte), très pauvres en couche 2 (exemples travaillés, traces de raisonnement explicites). Un constat qui mérite d'être posé, pas une section à ajouter. |
| E-25 | Méta-réflexion périodique sur les capacités | `LearnPrompt/andrej-karpathy-skills` `[SURVOL]` | Couvert par `/retrospective` (seuils de déclenchement, index structuré des patterns, §Métriques de rétro). Rien à importer. |
| E-26 | Index « Awesome Claude Skills » | 4 dépôts concurrents | Aucun n'est canonique, aucune valeur structurelle. Utile comme veille, pas comme source. |

---

## §7 · Séquencement recommandé

L'ordre suit le rapport valeur/coût, pas l'ordre du catalogue.

| Rang | Sprint proposé | Contenu | Taille | Pourquoi ce rang |
|------|-----------------|---------|--------|-------------------|
| 1 | `sdlc-validate` | E-01 tier 1 seul | M | Ferme l'exception permanente de `INV-1` sur le modèle lui-même. Aurait attrapé `M-HOOKS-05` et `M-TMPL-04`. Rend les rangs suivants vérifiables. |
| 2 | Rédaction des templates | E-08 + E-09 + E-16 + E-17 | S | Une seule §Rédaction dans `00-CONTEXT.md`. Zéro risque, effet immédiat sur toute évolution future. E-16 peut révéler un gain de contexte gratuit. |
| 3 | Barre qualité | E-03 + E-04 + E-11 | M | Une §Barre qualité + une §Definition of Done dans STANDARDS. Donne un seuil aux métriques M1/M2 qui n'en ont pas. |
| 4 | Durcissement PDR | E-13(b) + E-14 + E-06 + E-07 | S | Quatre ajouts de quelques lignes, chacun fermant un mode d'échec nommé. Le grep « No Placeholders » s'insère dans l'enforcement existant. |
| 5 | P-20 | E-15 | M | Déjà en §Next. Cette revue apporte le détail du nom de champ par plateforme. |
| 6 | Lexique | E-05 | S | Utile, mais moins urgent que ce qui précède. |
| — | §Later | E-02 (version forte), E-12/P-21, E-18, E-19 | — | Dépendent du tier 3, ou changent la forme du sprint, ou remettent en cause `M-ARCH-05`. |

**Note sur le rang 1 :** si un seul sprint est fait sur ce catalogue, c'est celui-là. Tous les autres patterns produisent des règles ; celui-ci produit le moyen de vérifier que les règles tiennent.

---

## §8 · Questions ouvertes pour décision humaine

1. **`M-ARCH-05` est-elle rouverte ?** E-19 propose un découpage hybride (skills génériques par plugin versionné, fichiers à tuning local par script). C'est une remise en cause d'une décision d'architecture prise et justifiée. Réponse possible : « non, déclencheur au 3e projet cible » — ce qui ferme la piste explicitement et suffit.
2. **Le tier 3 (evals comportementaux) entre-t-il un jour au périmètre ?** Il coûte des tokens à chaque exécution et suppose un harnais `claude -p` + grader. La réponse conditionne la version forte de E-02 (une `[HYPOTHÈSE]` se lève par un eval) contre sa version faible (elle se lève par une date ou une condition).
3. **`P-22` (`10-audit-externe-TEMPLATE.md`, §Later, décision différée) est-il promu ?** Cette revue est le troisième audit externe du modèle après Superpowers et GSD, et le troisième à réinventer son propre format de sortie. Le coût de non-décision commence à être visible. Trois audits est un seuil raisonnable.
4. Le `README.md` annonce `v1.9+SDLC-13` alors que le `CHANGELOG.md` va au moins jusqu'à SDLC-22 et que `07-DECISIONS-SDLC.md` porte une entrée SDLC-24. Écart de version dans le fichier d'entrée du repo — hors périmètre de cette revue, mais c'est exactement ce qu'un tier 1 (E-01) vérifierait à chaque commit.

---

## §9 · Candidats `[SDLC_CANDIDATE]` préformatés

À reporter dans `doc/LESSONS_LEARNED.md` si les sprints correspondants sont retenus.

```
**SDLC candidat :** [SDLC_CANDIDATE] Aucune vérification exécutable sur les templates
du modèle — `INV-1` a une exception permanente, matérialisée par la ligne
"Tests : N/A (gouvernance uniquement)" du CHANGELOG. → fichier cible : sdlc-validate.sh
(nouveau) + 03-wrap-up §3.5 · nature : nouveau script + procédure modifiée
— décision : [en attente]

**SDLC candidat :** [SDLC_CANDIDATE] Aucune règle de rédaction des templates — la forme
d'une règle (interdiction / recette / champ structurel / conditionnel) est choisie à
l'instinct. → fichier cible : 00-CONTEXT.md §Rédaction · nature : nouvelle section
— décision : [en attente]

**SDLC candidat :** [SDLC_CANDIDATE] La barre qualité du projet cible n'a ni seuils
chiffrés ni commande de verdict par dimension, et rien n'interdit à un agent de
l'affaiblir pour passer au vert. → fichier cible : 02-STANDARDS-TEMPLATE.md §Barre
qualité + 01-Claude-md-TEMPLATE.md §Règles absolues · nature : nouvelle section +
règle renforcée — décision : [en attente]

**SDLC candidat :** [SDLC_CANDIDATE] `sprint-memory.md` n'a pas de ligne d'identité
(quel PDR il suit) ni de règle de préséance ledger+git > souvenir après compaction.
→ fichier cible : 01-Claude-md-TEMPLATE.md §Démarrage 4b · nature : format modifié
— décision : [en attente]
```

---

## §10 · Note de clôture

Périmètre couvert : 10 dépôts demandés, 4 lus au source, 4 survolés, 1 traité comme index, 1 non ré-identifié. Zéro fichier de gouvernance modifié — sprint de type Revue. Sorties : 26 patterns catalogués (7 manques structurels, 10 renforcements, 3 à surveiller, 6 écartés), 1 pattern confirmé déjà fait (E-10), P-21 débloqué, P-20 confirmé et enrichi, 4 questions ouvertes, 4 `[SDLC_CANDIDATE]` préformatés.

Ce que cette revue n'a pas fait : exécuter le moindre de ces dispositifs. Les evals d'Addy Osmani, le harnais Drill de Superpowers et les hooks SessionStart ont été lus, pas observés en fonctionnement. Toute estimation de leur efficacité réelle serait une affirmation non citable.

---

→ Mise à jour 23/09/2026 : relecture de la couche test et validation (`specs/Sprints/PASSE-A-couche-validation.md`). Entrées sources non réécrites.

*Provenance des chiffres : mesures de la passe A (dépôts tiers clonés hors de ce repo), non re-vérifiées par commande ici (`M-PROC-48`).*

- **§1** — « lu au source » y signifiait « arborescence + quelques fichiers ». Couverture
  réelle mesurée : **~5-6 % des 610 000 mots** des 5 dépôts clonés. Les verdicts gardent leur
  valeur, pas leur pondération.
- **`E-01`** — le tier 1 a une implémentation de référence testée
  (`addyosmani/agent-skills/scripts/`, 1 838 lignes, 5 validateurs + 5 tests appariés).
  `E-01` la citait de seconde main via `evals/README.md`.
- **`E-02`** — la version praticable est `A-3` (commentaire d'en-tête citant l'incident), pas
  le pressure testing à 5 répétitions. Mise en œuvre : sprint `ECO-7`.
- **`E-03`** — l'anti-affaiblissement a une implémentation de référence (exemptions
  validateur-owned + garde anti-auto-exemption) ; `sdlc-validate.sh` l'a déjà.
- **`E-23`** — **décision à revoir.** `leonxlnx/taste-skill` a été écarté comme « skills de
  domaine » sur la foi d'un listing de `SKILL.md`, alors que son `research/laziness/`
  (10 fichiers, 3 698 mots) porte sur les causes de la troncature de sortie — soit les
  signaux « Silent partial completion » et « Increasing vagueness » du
  `04-sprint-PDR-TEMPLATE.md`. *Passe E, différée.*
