# Audit externe — `obra/superpowers` vs modèle SDLC
<!-- Sprint SDLC-17 · specs/Sprints/sprint-SDLC-17-audit-superpowers.md · 19/06/2026 -->
<!-- Source auditée : exemples/superpowers/Superpowers/ (clone local, ~174k★ GitHub) -->
<!-- Analyse statique du contenu uniquement — pas de session de test comportementale -->

---

## 1. Tableau d'équivalence terminologique

| Terme Superpowers | Équivalent SDLC le plus proche | Écart |
|---|---|---|
| **skill** (`skills/*/SKILL.md`) | aucun équivalent direct | SDLC encode le même type de savoir-faire procédural directement dans `Claude.md`/`STANDARDS.md` (sections statiques), pas dans des fichiers chargés à la demande. Pas de mécanisme de "skill discoverable par description" dans SDLC. |
| **plan** (sortie de `writing-plans`) | spec sprint (PDR) + §Plan de développement | Proche fonctionnellement : découpage en tâches, fichiers à toucher, plan de test. SDLC produit ce plan en étape 4d (intra-spec), Superpowers en document séparé persistant entre sessions. |
| **subagent** (dispatch isolé) | « délégation sous-agent » (`Claude.md §Tokens`) | Equivalent direct mais SDLC le déclenche uniquement par seuil token (>5 fichiers / >10K tokens) sans sélection de modèle par tâche — Superpowers ajoute une dimension absente (cf. §4). |
| **Iron Law** | « Règle absolue » / `HALT-X` (`Claude.md §Règles absolues`) | Partiel : les deux sont non-négociables, mais SDLC les formule comme conditions logiques détectées par raisonnement, sans contre-table de rationalisations (cf. §4). |
| **Hard Gate** | « verdict gate » (PASS/CONCERNS/FAIL) + « aval explicite » | Proche : les deux bloquent la progression sans validation. SDLC documente le verdict dans la spec ; Superpowers l'encode comme balise structurelle (`<HARD-GATE>`) dans le skill lui-même. |
| **Red Flags table** (table pensée→réalité) | aucun équivalent | Concept sans équivalent direct dans SDLC — voir §4 et recommandation IMPORTER. |
| **human partner** | « l'utilisateur » / « l'humain » | Synonymes, différence de ton uniquement. |
| **hook `SessionStart`** (injection auto de contexte) | aucun équivalent | SDLC n'a que des hooks `PreToolUse`/`PostToolUse` (bash) — rien qui injecte du contexte au démarrage de session. Voir §3 INV-2/INV-3 et recommandation IMPORTER. |
| **ledger** (`.superpowers/sdd/progress.md`) | `.claude/sprint-memory.md` | Proche : les deux survivent à une compaction de contexte intra-sprint. Différence : sprint-memory est détruit après wrap-up (`03-wrap-up-SKILL-TEMPLATE.md:309-312`), le ledger Superpowers n'a pas de règle de suppression équivalente documentée. |
| **brainstorming → design approuvé** | §Analyse + Demande d'aval (`Claude.md §Analyse`) | Equivalent fonctionnel direct : les deux imposent un design/analyse validé avant code. |
| **code-reviewer subagent** (`requesting-code-review`) | Adversarial Review (Blind Hunter / Edge Case Hunter / Acceptance Auditor, `03-wrap-up-SKILL-TEMPLATE.md`) | Partiel : SDLC fait la revue *après* le travail (au wrap-up), Superpowers la dispatche *pendant* (après chaque tâche, avant merge). Voir §6 recommandation REMPLACER. |
| **`finishing-a-development-branch`** | aucun équivalent | SDLC ne gère pas de branches/PR — un seul commit de wrap-up sur la branche courante. Concept sans objet dans ce modèle (mono-repo doc, pas de feature branches). |
| **`using-git-worktrees`** | aucun équivalent | Idem — pas de notion d'isolation de workspace dans SDLC. |
| **`LESSONS_LEARNED` + `/retrospective`** | aucun équivalent côté Superpowers | Superpowers évolue via son propre eval harness (mainteneurs, hors session utilisateur) ; SDLC boucle sur l'historique *du projet local* via un agent qui détecte ses propres patterns. Voir §5. |
| **`HOOK_CANDIDATE` / `SDLC_CANDIDATE`** | aucun équivalent côté Superpowers | Mécanisme de remontée structurée propre à SDLC — pas de concept similaire identifié dans les skills lus. |
| **registre `M-XXXX`** (`07-DECISIONS-SDLC.md`) | aucun équivalent direct | Le CHANGELOG/PR-history de Superpowers joue un rôle voisin mais n'est pas un registre de décisions interrogeable par l'agent lui-même. |

---

## 2. Mapping skill par skill

| Skill Superpowers | Objectif | Mécanisme d'activation | Rigidité | Équivalent SDLC le plus proche |
|---|---|---|---|---|
| `using-superpowers` | Bootstrap — impose le réflexe "vérifier les skills avant toute réponse" | Auto-trigger (hook `SessionStart`) — `hooks/session-start:27` | Hard Gate (table Red Flags anti-rationalisation) | Aucun — pas de mécanisme d'injection automatique en début de session SDLC |
| `brainstorming` | Transformer une idée en design approuvé avant tout code | À la demande — `SKILL.md:3` | Hard Gate — `SKILL.md:12-14` | `Claude.md §Analyse` + Demande d'aval |
| `writing-plans` | Écrire un plan d'implémentation détaillé, bite-sized, zéro placeholder | À la demande — `SKILL.md:3` | Recommandation stricte (chaînage obligatoire vers skill suivant) — `SKILL.md:55-77` | §Plan de développement (étape 4d du PDR) |
| `executing-plans` | Charger et exécuter un plan en session séparée, avec checkpoints | À la demande — `SKILL.md:3` | Règle prescriptive — `SKILL.md:35` | Flux "Évolution" (`Claude.md §Classifier le travail`) |
| `subagent-driven-development` | Dispatcher un subagent frais par tâche + review après chaque tâche | À la demande — `SKILL.md:3` | Règle rigide (continuité d'exécution sans pause) — `SKILL.md:14-17` | « Délégation sous-agent » (`Claude.md §Tokens`) — bien moins détaillé |
| `dispatching-parallel-agents` | Déléguer des tâches indépendantes à des agents en parallèle | À la demande — `SKILL.md:3` | Pattern décisionnel souple — `SKILL.md:18-34` | « Délégation sous-agent », sans le critère d'indépendance explicite |
| `test-driven-development` | Red-Green-Refactor, jamais de code de prod sans test qui échoue | À la demande — `SKILL.md:3` | Iron Law — `SKILL.md:31-45` | Aucun — SDLC n'a pas de notion de test unitaire (projet doc-only) |
| `systematic-debugging` | 4 phases de diagnostic avant tout fix | À la demande — `SKILL.md:3` | Iron Law — `SKILL.md:16-21` | Skill `/diagnostic` (référencé par `HALT-3X`, `Claude.md:25-26`) |
| `verification-before-completion` | Jamais revendiquer succès sans preuve fraîche exécutée | À la demande — `SKILL.md:3` | Iron Law — `SKILL.md:17-20` | Clause anti-complaisance (`Claude.md §Test`, lignes 296-301) — équivalent direct fort |
| `requesting-code-review` | Dispatcher un subagent reviewer à des points de complétion | À la demande, points "Mandatory" — `SKILL.md:12-22` | Recommandation avec obligations ponctuelles | Adversarial Review (wrap-up) — décalé en fin de sprint plutôt qu'en continu |
| `receiving-code-review` | Évaluer le feedback de review avant d'agir, pousser-back si erroné | À la demande — `SKILL.md:3` | Liste de réponses interdites — `SKILL.md:27-38` | Aucun équivalent formel (pas de boucle de review externe documentée) |
| `finishing-a-development-branch` | Présenter les options de clôture de branche après tests verts | À la demande — `SKILL.md:3` | Gate de vérification tests + menu prescrit — `SKILL.md:19-37, 67-92` | Aucun — pas de notion de branche dans le flux SDLC |
| `using-git-worktrees` | Isoler le travail via outils natifs ou fallback worktree manuel | À la demande — `SKILL.md:3` | Recommandation rigide sur hiérarchie d'outils — `SKILL.md:9-12` | Aucun |
| `writing-skills` | Créer/éditer des skills via leur propre cycle TDD (RED=baseline sans skill, GREEN=skill minimal, REFACTOR=bulletproofing) | À la demande — `SKILL.md:3` | Iron Law — `SKILL.md:16-18, 374-391` | Aucun équivalent — SDLC n'a pas de méthode de test empirique de ses propres règles avant publication |

---

## 3. Analyse par invariant

**INV-1 · Vérification exécutable**
Superpowers porte ce principe à l'extrême sous forme d'Iron Law dédiée : `verification-before-completion` interdit toute affirmation de succès sans avoir exécuté la commande *dans le message courant* (`SKILL.md:17-20`), avec une table de 10 formulations-pièges ("should", "probably", "seems" — `SKILL.md:52-61`) et un pattern de revert obligatoire pour les tests de non-régression (`SKILL.md:76-106`). SDLC porte le même principe via la « clause anti-complaisance » (`Claude.md:296-301`) mais sans table de formulations interdites ni protocole de revert-test systématisé.
**Verdict :** Superpowers va plus loin dans l'opérationnalisation du même principe (table de contre-exemples vs. énoncé de principe seul).

**INV-2 · Circuit fermé**
SDLC formalise ce principe explicitement comme invariant nommé (`00-CONTEXT.md:86-89`) avec un circuit documenté : observation → `LESSONS_LEARNED` → `/retrospective` → hook/règle, et des seuils précis de déclenchement (`09-retrospective-SKILL-TEMPLATE.md:199-206`). Superpowers n'a pas d'équivalent *côté agent/projet* : ses skills évoluent via un eval harness séparé (`evals/`, maintenu par les auteurs du framework, hors session utilisateur — `CLAUDE.md:102-104`), donc aucune règle implicite observée par l'agent sur un projet donné ne devient automatiquement explicite pour ce projet.
**Verdict :** SDLC est structurellement plus complet sur cet invariant — c'est l'un des axes où le modèle SDLC est plus avancé (cf. §5).

**INV-3 · Contexte chirurgical**
Les deux modèles partagent la philosophie (charger seulement ce qui est nécessaire) mais avec des mécanismes très différents. SDLC le résout par discipline de lecture : `§Handoff` distingue immédiat/différé, grep avant lecture intégrale (`Claude.md:150-160`). Superpowers inverse le problème : le hook `SessionStart` injecte automatiquement le contenu complet de `using-superpowers` (`hooks/session-start:27`) puis chaque skill est chargé à la demande via le tool `Skill` plutôt que lu en fichier brut (`skills/using-superpowers/SKILL.md:30-32`) — séparation nette entre "ce qui doit toujours être en contexte" (le bootstrap) et "ce qui se charge au besoin" (les 14 skills).
**Verdict :** équivalent fonctionnel, mécanismes différents — Superpowers automatise la garantie de chargement du minimum vital (le bootstrap), SDLC s'appuie sur la discipline de lecture de l'agent en début de session.

**INV-4 · Boucle de rétroaction**
Recouvre largement INV-2 côté SDLC. Côté Superpowers, l'équivalent le plus proche est le cycle TDD appliqué à l'écriture des skills eux-mêmes (`writing-skills`, RED=scénario de pression sans skill, GREEN=skill minimal, REFACTOR=fermeture des nouvelles rationalisations trouvées — `SKILL.md:552-595`), mais ce cycle s'exécute en amont (par les auteurs du skill, en dehors du projet utilisateur), pas en boucle continue sur l'historique d'un déploiement spécifique.
**Verdict :** SDLC ferme la boucle *par projet* ; Superpowers ferme une boucle similaire mais *par version du framework*, invisible et inaccessible à l'utilisateur final d'un projet donné.

---

## 4. Forces honnêtes de Superpowers

1. **Auto-injection du bootstrap via hook `SessionStart`** (`hooks/session-start:27`, `hooks/hooks.json:1-16`) — élimine structurellement la classe d'incident où un agent démarre une session sans avoir relu les règles permanentes. C'est précisément le défaut qui a motivé ce sprint d'audit (omission de l'étape 4a de `Claude.md §Démarrage` lors d'une session précédente, faute de relecture du fichier en tête de session). SDLC n'a aucun mécanisme équivalent — il dépend entièrement de la discipline de l'agent à exécuter `Claude.md §Démarrage` de mémoire.

2. **Tables de rationalisation ("Red Flags") couplées à chaque règle rigide** — chaque Iron Law est accompagnée d'une liste de formulations-pièges spécifiques et de leur réfutation, ex. `test-driven-development/SKILL.md:256-286` (11 excuses dont "tests-after achieve same goals" → réfuté ligne par ligne), `systematic-debugging/SKILL.md:245-256` (8 excuses dont **"one more fix attempt" (when already tried 2+)**). SDLC énonce ses règles absolues et ses HALT comme conditions logiques, mais sans anticiper et contrer les formulations spécifiques par lesquelles un agent pourrait s'auto-convaincre de les contourner.

3. **Sélection de modèle par nature de tâche dispatchée** (`subagent-driven-development/SKILL.md:99-130`) — distingue explicitement modèle "cheap" (tâches mécaniques), "standard" (intégration/jugement), "capable" (architecture/revue finale), avec le principe « Turn count beats token price ». La règle de délégation sous-agent de SDLC (`Claude.md:155-160`) déclenche la délégation sur un seuil de volume (>5 fichiers / >10K tokens) mais ne dit rien sur le choix du modèle du sous-agent dispatché.

4. **Validation empirique des skills avant déploiement** (`writing-skills/SKILL.md:30-44, 444-457`) — un skill n'est publié qu'après avoir démontré, par un scénario de pression réel (subagent en situation, sans le skill), qu'il corrige un comportement observé, puis re-testé après ajout du skill. SDLC valide ses évolutions de règles par jugement humain en `/retrospective` (seuil ≥2 occurrences) mais sans protocole de test adversarial de la formulation elle-même avant adoption.

---

## 5. Forces du modèle SDLC absentes de Superpowers

1. **Boucle de rétroaction *par projet*, accessible à l'agent et à l'utilisateur du projet lui-même** (`00-CONTEXT.md §INV-4`, `09-retrospective-SKILL-TEMPLATE.md`) — `LESSONS_LEARNED` accumule les incidents et succès propres à un déploiement donné, indexés par patterns `P-XX`, avec des seuils explicites de promotion en règle permanente (`≥ 2 [HOOK_CANDIDATE] identiques → proposer activation`, `09-retrospective-SKILL-TEMPLATE.md:117-119`). L'évolution des skills Superpowers, elle, passe par un eval harness séparé (`evals/`) maintenu par les auteurs du framework — invisible et non actionnable par un utilisateur final qui constaterait un problème récurrent sur *son* projet.

2. **Propagation de gouvernance multi-projets avec tuning local protégé** (`04b-sdlc-sync-SKILL-TEMPLATE.md`) — le skill `/sdlc-sync` trie chaque évolution du modèle central en AJOUTER (universel/conditionnel) / IGNORER / MIGRER / LAISSER / REMONTER, avec une règle explicite qu'un élément classé `LAISSER` (tuning local) n'est jamais écrasé par une mise à jour du modèle (`05:101` — voir audit fichier 5). Superpowers a une distribution canonique unique par plugin (marketplace), sans mécanisme documenté de delta versionné distinguant ce qui est universel de ce qui est local à un déploiement particulier.

3. **Mémoire de session structurée avec annotations de confiance et de validité** (`.claude/sprint-memory.md`, 6 types d'entrées dont `DÉCISION` avec `[valide jusqu'à : condition]` et `ANALYSE` avec `[CONF: HAUTE/MOY/FAIBLE]` — `Claude.md:266-272`). Le ledger le plus proche côté Superpowers (`.superpowers/sdd/progress.md`, `subagent-driven-development/SKILL.md:246-264`) trace l'avancement des tâches mais ne porte pas d'annotation de confiance ni de condition de validité sur les décisions enregistrées.

---

## 6. Recommandations

| Idée | Source Superpowers | Étiquette | Fichier cible | Esquisse | Impact estimé |
|---|---|---|---|---|---|
| Hook d'injection automatique des règles absolues + HALT en début de session | `hooks/session-start` + `hooks/hooks.json` (`SessionStart`) | **IMPORTER** | `08-hooks-TEMPLATE.md` (nouvelle section hook `SessionStart`) | Un hook qui lit `Claude.md §Règles absolues` + `§HALT` et les réinjecte comme contexte additionnel à chaque démarrage/clear/compact, plutôt que de compter sur la relecture manuelle de l'agent | **Élevé** — corrige directement la classe d'incident root-cause de ce sprint |
| Table de rationalisations spécifiques par règle absolue/HALT | `test-driven-development/SKILL.md:256-286`, `systematic-debugging/SKILL.md:245-256` | **IMPORTER** | `01-Claude-md-TEMPLATE.md` (nouvelle sous-section sous chaque HALT) | Pour chaque HALT, lister 3-5 formulations internes typiques par lesquelles l'agent pourrait s'auto-justifier de l'ignorer ("c'est juste une petite exception", "je vérifie après coup"), avec la réfutation en face | Moyen |
| Table de formulations interdites pour la clause anti-complaisance | `verification-before-completion/SKILL.md:52-61` | **FUSIONNER** | `01-Claude-md-TEMPLATE.md §Test` (clause anti-complaisance existante) | Ajouter à la clause anti-complaisance déjà présente (`Claude.md:296-301`) la liste explicite de formulations interdites ("devrait passer", "probablement", "en principe") — le principe existe déjà, seule la liste de contre-exemples manque | Faible |
| Sélection de modèle par nature de tâche déléguée | `subagent-driven-development/SKILL.md:99-130` | **IDÉE NOUVELLE** | `Claude.md §Tokens` (nouvelle sous-section) | Ajouter une règle de choix de modèle pour le sous-agent dispatché selon la nature de la tâche (lecture/synthèse mécanique vs. jugement architectural), distincte du critère de volume déjà présent | Moyen |
| Revue par subagent dédiée en cours de sprint, pas seulement au wrap-up | `requesting-code-review/SKILL.md:12-46` | **REMPLACER** *(partiellement)* | `03-wrap-up-SKILL-TEMPLATE.md` (Adversarial Review) | Pour les sprints L, ajouter un point de revue par sous-agent à mi-parcours (avant la fin du sprint) en complément — pas en remplacement — de l'Adversarial Review actuelle qui reste post-hoc | Moyen |
| Hard Gate universel "zéro code avant design approuvé" pour tout type de sprint | `brainstorming/SKILL.md:12-14` | **REJETER** | — | Voir justification détaillée en §7 | — |

---

## 7. Ce qu'on ne doit PAS importer

1. **Hard Gate universel "zéro code avant design approuvé" appliqué à tout type de sprint** (`brainstorming/SKILL.md:12-14` : *"This applies to EVERY project regardless of perceived simplicity"*). SDLC distingue déjà 4 flux par type de travail (`Claude.md §Classifier le travail` : Évolution / Bug / Tuning / Revue) précisément parce qu'un bug de régression ou un ajustement de seuil ne bénéficie pas du même cycle qu'une feature complexe. Imposer un brainstorming formel avant chaque fix cassait le flux `Bug : /diagnostic → Fix → Test → /wrap-up` sans bénéfice net — sur-ingénierie pour les petits sprints, qui sont la majorité du volume sur ce projet.

2. **Gouvernance de contribution PR / "94% rejection rate"** (`CLAUDE.md` de Superpowers, sections "Pull Request Requirements", "What We Will Not Accept"). Ce dispositif répond à un problème que SDLC n'a pas : un projet open-source avec contributeurs externes anonymes soumettant des PR de qualité variable. Le modèle SDLC n'a ni dépôt public, ni file de contribution, ni mainteneurs distincts de l'utilisateur — importer ce mécanisme n'a pas d'objet.

3. **Eval harness empirique** (`evals/`, mentionné `CLAUDE.md:102-104`, drive de sessions tmux réelles + jugement par LLM verifier). Explicitement hors périmètre de cet audit (cf. Portée du PDR) — son adoption introduirait une dépendance d'automatisation de session (tmux, harnais de test multi-agents) qui contredit à la fois la contrainte `Claude.md §Limites bash` ("pas d'API authentifiée, pas de déploiement") et l'éthique "zero-dependency by design" que Superpowers revendique lui-même (`CLAUDE.md:38`) — recommander cette dépendance serait incohérent avec le principe qu'on prétendrait importer.

4. **`using-git-worktrees` et `finishing-a-development-branch` dans leur intégralité**. Ces skills répondent à un modèle de développement multi-branches avec PR — ce projet SDLC opère en mono-commit de wrap-up sur une branche unique, sur un dépôt de documentation markdown sans code exécutable nécessitant d'isolation de workspace. Importer ces mécanismes introduirait de la complexité sans cas d'usage réel actuel.

---

## 8. Candidats `[SDLC_CANDIDATE]` préformatés

```
[SDLC_CANDIDATE] Hook SessionStart — injection automatique des règles absolues + HALT
Source : exemples/superpowers/Superpowers/hooks/session-start:27, hooks/hooks.json:1-16
Constat : l'agent dépend entièrement de la relecture manuelle de Claude.md §Démarrage en tête
de session ; aucun garde-fou mécanique ne force cette relecture. Incident déclencheur :
omission de l'étape 4a (création du fichier spec) lors d'un sprint précédent, faute de
confrontation entre les instructions d'init embarquées dans un PDR et la checklist réelle
de Claude.md (cf. LL-T05, doc/SESSION_BRIDGE.md entrée Sprint SDLC-16).
Proposition : hook SessionStart (matcher startup|clear|compact) qui extrait et réinjecte
en contexte additionnel le contenu de Claude.md §Règles absolues + §HALT.
Fichier cible : 08-hooks-TEMPLATE.md (nouvelle section)
Impact estimé : Élevé
```

```
[SDLC_CANDIDATE] Tables de rationalisation par HALT / règle absolue
Source : exemples/superpowers/Superpowers/skills/test-driven-development/SKILL.md:256-286,
skills/systematic-debugging/SKILL.md:245-256
Constat : les règles absolues et HALT de Claude.md sont énoncées comme conditions logiques
mais sans anticiper les formulations internes spécifiques par lesquelles un agent pourrait
se convaincre de les contourner.
Proposition : pour chaque HALT (HALT-DEP, HALT-3X, HALT-ARCH, HALT-SCOPE, HALT-TIMEOUT),
ajouter une mini-table "pensée → réalité" de 3-5 rationalisations typiques.
Fichier cible : 01-Claude-md-TEMPLATE.md (sous chaque définition de HALT)
Impact estimé : Moyen
```

```
[SDLC_CANDIDATE] Liste de formulations interdites — clause anti-complaisance
Source : exemples/superpowers/Superpowers/skills/verification-before-completion/SKILL.md:52-61
Constat : la clause anti-complaisance existante (Claude.md §Test) énonce le principe
("ne jamais marquer OK sans sortie réelle") mais sans lister les formulations à bannir.
Proposition : fusionner dans la clause existante la liste de formulations interdites
("devrait passer", "probablement", "en principe", "ça a l'air bon").
Fichier cible : 01-Claude-md-TEMPLATE.md §Test
Impact estimé : Faible
```

---

## 9. Limites de l'audit

- **Eval harness Superpowers (`superpowers-evals`)** : non cloné, non évalué — son existence est mentionnée (`CLAUDE.md:102-104`) mais son contenu (scénarios, méthodologie de jugement LLM) n'a pas été inspecté. Explicitement exclu du périmètre du PDR.
- **Comportement réel en session** : cet audit est une analyse statique du contenu des fichiers. Aucune session Claude Code avec le plugin Superpowers actif n'a été ouverte pour observer empiriquement l'auto-trigger des skills, le comportement réel du hook `SessionStart`, ou la qualité effective des reviews dispatchées. Toute affirmation sur l'efficacité réelle des mécanismes décrits reste une lecture qualitative du contenu, pas une mesure.
- **Autres harnais** (Cursor, Codex, Gemini CLI, Copilot CLI, Antigravity, Pi, Kimi) : Superpowers s'adapte à 7+ environnements différents (`README.md §Quickstart`) — cet audit s'est concentré exclusivement sur l'intégration Claude Code, conformément au périmètre du PDR.
- **Templates `code-reviewer.md` référencé mais non lu** : `requesting-code-review/SKILL.md:34` référence un template séparé (`code-reviewer.md`) qui structure le prompt dispatché au subagent reviewer — ce fichier n'a pas été localisé/lu séparément ; son contenu exact (critères de revue détaillés) n'est donc pas évalué ici, seul le mécanisme de dispatch l'est.
- **Conventions `docs/superpowers/plans/` et `specs/`** : seule la convention de nommage a été vérifiée (`ls` → format `YYYY-MM-DD-<slug>.md` confirmé), le contenu métier de ces fichiers n'a pas été lu, conformément à l'exclusion explicite du PDR.
