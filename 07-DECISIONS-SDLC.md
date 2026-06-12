# DECISIONS-SDLC — Modèle de gouvernance Claude Code
<!-- v1.0 · 29/05/2026 · Décisions sur le modèle lui-même, pas sur les projets cibles -->

Registre des décisions prises sur le modèle SDLC.
Format : ID · Décision retenue · Alternative écartée · Justification · Sprint / Date

---

## Conventions

| Préfixe | Domaine |
|---------|---------|
| M-ARCH  | Architecture du modèle (structure fichiers, séparation des couches) |
| M-TMPL  | Décisions sur le contenu des templates |
| M-PROC  | Décisions sur les procédures (wrap-up, bootstrap, rétrospective) |
| M-SCOPE | Périmètre du modèle (ce qui est in / out) |
| M-HOOKS | Décisions sur les hooks Claude Code (activation, boucle de rétroaction) |

---

## M-ARCH-01 · 8 fichiers séparés vs monolithique · Bootstrap v1.0 · 29/05/2026

**Retenu :** 8 fichiers `.md` séparés par rôle dans le projet Claude.ai.

**Écarté :** Un fichier unique `sdlc-kit.md` contenant tous les templates.

**Raison :** Claude charge tous les Project Files dans le contexte à chaque conversation.
Un monolithique de 500+ lignes consomme inutilement de la fenêtre de contexte et
ne permet pas de mettre à jour un template sans toucher les autres.
La séparation permet aussi une évolution indépendante par fichier et
des commits ciblés dans le registre DECISIONS-SDLC.

---

## M-ARCH-02 · Numérotation 00-07 des fichiers · Bootstrap v1.0 · 29/05/2026

**Retenu :** Préfixe numérique `00-` à `07-` sur tous les fichiers.

**Écarté :** Noms sans préfixe (Claude-md-TEMPLATE.md, STANDARDS-TEMPLATE.md, etc.)

**Raison :** Claude.ai affiche les fichiers par ordre alphabétique.
La numérotation impose un ordre de lecture naturel (README en premier,
PDR-bootstrap en avant-dernier, DECISIONS en dernier).
L'ordre reflète aussi la priorité d'utilisation au quotidien.

---

## M-ARCH-03 · DECISIONS/CHANGELOG/LESSONS_LEARNED hors projet SDLC · Bootstrap v1.0 · 29/05/2026

**Retenu :** Ces trois fichiers appartiennent au repo de chaque projet cible, pas au projet SDLC.

**Écarté :** Inclure des templates DECISIONS.md, CHANGELOG.md et LESSONS_LEARNED.md dans le projet SDLC.

**Raison :** Ces fichiers accumulent l'historique *vivant* d'un projet spécifique.
Un template pré-rempli induirait en erreur. Le format est suffisamment simple
pour être créé from scratch au bootstrap (< 10 lignes chacun).
Les formats sont documentés dans `06-PDR-bootstrap.md` §Format.

---

## M-TMPL-01 · Placeholders [entre crochets] + marqueurs [→ ADAPTER] · Bootstrap v1.0 · 29/05/2026

**Retenu :** Double convention : `[Nom du projet]` pour les valeurs à remplacer,
`<!-- [→ ADAPTER] -->` en commentaire pour les sections à modifier.

**Écarté :** Placeholders uniquement, ou marqueurs uniquement.

**Raison :** Les placeholders sont cherchables par grep pour validation post-adaptation
(`grep "\[→ ADAPTER\]"`). Les deux types sont visuellement distincts :
placeholders inline = valeur à remplacer ; marqueurs commentaire = section à repenser.

---

## M-PROC-01 · Sprint 0 comme PDR opérationnel complet · Bootstrap v1.0 · 29/05/2026

**Retenu :** `06-PDR-bootstrap.md` est un PDR complet avec plan d'exécution, critères d'acceptation,
handoff Claude Code — pas juste une liste de fichiers.

**Écarté :** Un simple tableau "fichier source → destination → action".

**Raison :** Claude Code doit pouvoir exécuter le bootstrap sans poser de questions.
Un PDR complet avec ordre d'exécution, greps de validation et critères d'acceptation
réduit la friction à zéro et garantit un résultat reproductible.
Cohérent avec le principe du modèle : tout ce qui n'est pas écrit n'existe pas opérationnellement.

---

## M-SCOPE-01 · sprint-template.md = copie sans adaptation · Bootstrap v1.0 · 29/05/2026

**Retenu :** Le template PDR de sprint est copié tel quel dans tout nouveau projet, sans adaptation.

**Écarté :** Un template avec placeholders projet-spécifiques dans l'en-tête.

**Raison :** Le format PDR est entièrement générique par construction.
Les parties spécifiques au projet (§Contexte, §Objectif, §Critères d'acceptation)
sont remplies à chaque sprint, pas au bootstrap.
Forcer l'adaptation au bootstrap créerait du travail inutile et risquerait
de dénaturer le template.

---

## M-SCOPE-02 · SPEC.md = from scratch, jamais copiée · Bootstrap v1.0 · 29/05/2026

**Retenu :** `specs/SPEC.md` est toujours créée from scratch pour chaque projet.

**Écarté :** Un template SPEC.md générique dans le projet SDLC.

**Raison :** La SPEC est l'artefact le plus spécifique au domaine du projet.
Sa structure, ses sections et son niveau de détail varient radicalement selon le domaine.
Un template générique induirait en erreur sur ce qu'il faut documenter.
La seule contrainte : structure vide avec §Vue d'ensemble · §Architecture · §Modules.

---

## M-PROC-02 · Bilan session intégré dans wrap-up · v1.1 · 30/05/2026

**Retenu :** Le bilan de session (fait vs prévu, ancré sur git diff) est intégré
comme Étape 0 du wrap-up, pas comme skill séparé `/bilan-local`.

**Écarté :** Un skill `/bilan-local` indépendant appelé séparément.

**Raison :** Sur des sprints courts (15 min à demi-journée), multiplier les commandes
augmente la friction inutilement. Le wrap-up est le moment naturel du bilan —
les intégrer garantit que le bilan est toujours fait, jamais oublié.
Le skill séparé reste pertinent pour des reprises de session sans wrap-up immédiat.

---

## M-PROC-03 · Auto-exécution sans questions utilisateur · v1.1 · 30/05/2026

**Retenu :** Toutes les étapes du wrap-up où Claude a accès à l'information
(git, fichiers, conversation) sont auto-exécutées. Claude rapporte ce qu'il a fait.
L'utilisateur valide après, pas avant. Seule exception : la rétrospective (Étape 1).

**Écarté :** Questions systématiques à l'utilisateur avant chaque action.

**Raison :** Sur des sprints courts, chaque question est une friction.
Claude a accès à la conversation, aux fichiers et à git — il peut faire le travail
lui-même dans la grande majorité des cas. Le pattern "rapport + validation post"
est plus rapide et aussi sûr que "question + confirmation pré".

---

## M-PROC-04 · Nettoyage artefacts périmés intégré en Étape 3 · v1.1 · 30/05/2026

**Retenu :** Deux vérifications auto-exécutées ajoutées en Étape 3 :
Q1 — cocher les `[ ]`/`[À FAIRE]` dans les fichiers touchés par le sprint.
Q2 — ajouter un sous-bloc `→ Mise à jour [date]` dans DECISIONS.md si une décision existante évolue.

**Écarté :** Laisser ces nettoyages comme actions manuelles implicites.

**Raison :** Sans check explicite, les artefacts périmés s'accumulent (marqueurs non cochés,
décisions obsolètes non mises à jour). Le scope est limité aux fichiers du sprint
(`git diff --name-only`) pour éviter un audit complet du repo à chaque wrap-up.
La règle "sous-bloc, jamais réécriture" sur DECISIONS.md préserve l'historique.

**Règle sur DECISIONS.md :** ne jamais réécrire une entrée existante —
toujours ajouter `→ Mise à jour [date] : [évolution]` sous l'entrée originale.

---

## M-PROC-05 · DIAGNOSTIC_CMDS.md obligatoire · v1.1 · 30/05/2026

**Retenu :** `doc/DIAGNOSTIC_CMDS.md` devient obligatoire à chaque sprint.
Claude relit la conversation, extrait les commandes utilisées, ajoute si nouvelle.
Si aucune commande nouvelle : confirmer "✅ DIAGNOSTIC_CMDS — RAS" explicitement.

**Écarté :** Conditionnel ("si commande utile découverte").

**Raison :** Conditionnel = jamais fait en pratique. L'obligation de se poser
la question garantit que les commandes utiles sont archivées. Le "RAS" explicite
confirme que la vérification a eu lieu — différent d'un simple oubli.

---

## M-HOOKS-01 · PreToolUse-only vs PostToolUse optionnel · v1.2 · 30/05/2026

**Retenu :** `settings.json` ne déclare que le hook `PreToolUse` sur `Bash` au bootstrap.
Le `PostToolUse` (lint/format automatique après Edit/Write) est documenté mais non activé par défaut.

**Écarté :** Activer PreToolUse + PostToolUse dès le bootstrap.

**Raison :** Un hook PostToolUse déclenche un outil (ruff, pytest) après chaque Edit.
Si le formatter ou les tests sont lents ou mal configurés au sprint 0, le workflow devient
pénible immédiatement. La valeur du PostToolUse est réelle mais dépend d'une stack stabilisée.
Décision différée au sprint 1 ou 2, une fois que les commandes sont connues et rapides.
Le template documente le bloc PostToolUse commenté pour faciliter l'activation consciente.

---

## M-HOOKS-02 · Sections [ACTIVER si…] vs hook vide · v1.2 · 30/05/2026

**Retenu :** Le `pre-tool-bash.sh` template contient toutes les sections utiles sous forme
commentée, avec un marqueur `[ACTIVER si…]` et un grep de validation post-bootstrap.

**Écarté :** Livrer un hook vide (seulement les blocages universels) et laisser l'équipe
construire from scratch.

**Raison :** Le hook de production (projet JobSearch) a mis plusieurs sprints à atteindre
sa forme finale. Partir d'un template avec sections pré-rédigées réduit le temps de bootstrap
et garantit la cohérence du pattern de lecture stdin JSON — non-trivial à retrouver.
Le grep `[ACTIVER` force une décision explicite sur chaque section : activer = documenter
dans DECISIONS.md, désactiver = supprimer la ligne. Zéro section ambiguë en production.

---

## M-PROC-06 · Boucle de rétroaction hook via LESSONS_LEARNED · v1.2 · 30/05/2026

**Retenu :** Les règles de hook évoluent via un circuit explicite :
(1) question hook candidat en Étape 1 du wrap-up,
(2) tag `[HOOK_CANDIDATE]` + ligne bash proposée dans LESSONS_LEARNED,
(3) détection au `/retrospective` (≥ 2 occurrences ou 1 incident grave),
(4) décision humaine → commit hook + entrée DECISIONS.md §D-HOOK-XX.

**Écarté :** Questionnaire de bootstrap pour prédire les règles à l'avance.

**Raison :** Le questionnaire devine — la rétroaction *sait*. Les règles métier spécifiques
(fichiers protégés, endpoints particuliers, contraintes de stack) émergent du vécu et ne sont
pas prévisibles avant le sprint 1. Le circuit via LESSONS_LEARNED garantit que chaque règle
ajoutée est fondée sur un incident ou une hésitation réelle, documentée et validée.
Coût marginal faible (une question de plus en Étape 1, un champ optionnel en Étape 2).

**Invariant :** toute règle dans `pre-tool-bash.sh` doit avoir une entrée `doc/DECISIONS.md §D-HOOK-XX`.
Un hook sans décision documentée est une règle implicite — interdit par le modèle.

---

## M-TMPL-02 · Champ Interdit dans PDR · v1.2 · 30/05/2026

**Retenu :** Champ `**Interdit :**` distinct dans §Contraintes techniques du PDR.

**Écarté :** Laisser les interdictions mélangées aux contraintes positives.

**Raison :** Les interdictions sont de nature différente des contraintes — elles énoncent
ce que Claude ne doit *jamais* faire pendant le sprint, pas ce qui est hors scope.
La séparation visuelle force à les nommer explicitement plutôt que de les laisser implicites.
Issu du retour d'expérience Oracle : "énoncer les interdictions explicitement dans les skills".

---

## M-TMPL-03 · Given/When/Then dans PDR · v1.2 · 30/05/2026

**Retenu :** Format Scénario Given/When/Then optionnel dans §Critères d'acceptation,
réservé aux sprints Feature, en français (Étant donné / Quand / Alors).

**Écarté :** Format obligatoire pour tous les sprints, ou format anglais.

**Raison :** Les sprints Fix, Tuning, Doc, Spike n'ont pas de comportement utilisateur
à décrire — rendre le format obligatoire créerait du remplissage vide.
Le français maintient la cohérence avec le reste du modèle.
Complémentaire aux critères en checkbox, pas un remplacement.

---

## M-PROC-07 · Vérification exécutable renforcée dans PDR et Claude.md · v1.2 · 30/05/2026

**Retenu :** Deux renforcements : (1) ligne "Tests niveau A" dans PDR avec syntaxe backtick
forçant une commande, (2) règle explicite dans Claude.md §Plan de test :
"le niveau A est invalide sans commande exécutable".

**Écarté :** Laisser `<commande exacte>` comme invitation non contraignante.

**Raison :** Sans contrainte explicite, Claude peut remplir le champ avec une description
("vérifier que X fonctionne") sans violer aucune règle visible. La syntaxe backtick
et la règle nommée transforment l'invitation en contrat.
Principe INV-1 du README : tout plan de test doit contenir une commande exacte, pas une description.

---

## M-ARCH-04 · 00-README comme méta-document du projet SDLC · v1.2 · 30/05/2026

**Retenu :** Fichier `00-README.md` contenant les 4 invariants, la carte des fichiers,
la checklist d'évolution et l'historique des versions. Jamais copié dans les projets cibles.

**Écarté :** Pas de méta-document — les principes restent implicites.

**Raison :** Sans document de référence explicite, les futures évolutions du modèle
risquent de violer les invariants sans s'en rendre compte. La numérotation `00-`
le place en premier dans le contexte Claude.ai — premier chargé, premier lu.
Les 4 invariants (vérification exécutable, circuit fermé, contexte chirurgical,
boucle de rétroaction) formalisent les principes d'optimisation Claude Code
identifiés dans les retours d'expérience terrain.

---

## M-PROC-08 · Circuit SDLC_CANDIDATE via retrospective · v1.2 · 30/05/2026

**Retenu :** Tag `[SDLC_CANDIDATE]` dans LESSONS_LEARNED des projets cibles,
capturé à l'Étape 1 du wrap-up (3e question), synthétisé à l'Étape 4 de `/retrospective`,
remonté manuellement dans le projet SDLC.

**Écarté :** Skill `/retrospective` dédié dans le projet SDLC lui-même.

**Raison :** Les rétrospectives se font dans les projets individuels, pas dans le projet SDLC.
La remontée reste manuelle — le projet SDLC ne peut pas se modifier automatiquement.
Le circuit garantit que l'information ne se perd pas dans un LESSONS_LEARNED de projet
individuel : elle remonte au niveau méta via un chemin explicite et documenté.

---

## M-PROC-09 · Sprint SDLC-Sync — propagation descendante du modèle · v1.3 · 03/06/2026

**Retenu :** Un type de sprint dédié `SDLC-Sync` pour aligner un projet existant
sur une version plus récente du modèle SDLC, avec logique de tri asymétrique
et possibilité de remontée bidirectionnelle. Exécuté via le skill `/sdlc-sync`.

**Écarté :** Propagation automatique (trop risquée sur le tuning local) · migration
manuelle non structurée (non traçable) · skill `/sdlc-init` dans le repo vide
(impossible : le skill n'existe pas encore au moment du bootstrap).

**Raison :** Les projets antérieurs au modèle SDLC générique ont une gouvernance
plus riche en tuning local mais moins complète structurellement. Ce n'est pas
une divergence intentionnelle — c'est une réalité historique : le modèle n'existait
pas encore. Le SDLC-Sync apporte les sections manquantes sans écraser le tuning local.
Le bootstrap d'un repo vide est délégué à `sdlc-init.sh` (script shell),
car un skill ne peut pas être invoqué avant d'exister dans le repo.

**Règle de tri :**
- Section absente, universelle → ajouter
- Section absente, conditionnelle → vérifier la contrainte, ajouter si pertinent
- Section présente, formulée différemment → comparer, migrer si bénéfice net, sinon laisser
- Tuning local sans équivalent SDLC → laisser intact, évaluer remontée vers modèle SDLC

**Détection de version :**
Chercher `<!-- SDLC version` dans `Claude.md` et `STANDARDS.md`.
Si absent → projet antérieur au modèle générique. Même règle de tri, delta complet.
À la fin du SDLC-Sync, apposer le marqueur de version courante dans les deux fichiers.

**Traçabilité :** entrée `D-SYNC-XX` obligatoire dans `doc/DECISIONS.md` du projet cible.

---

## M-ARCH-05 · sdlc-init.sh comme point d'entrée bootstrap · v1.3 · 03/06/2026

**Retenu :** Script shell `sdlc-init.sh` dans le repo SDLC pour bootstrapper un repo vide.
Il crée la structure, copie les templates, remplace les placeholders mécaniques,
et dépose le skill `/sdlc-sync` dans `.claude/skills/`. Claude Code prend le relais
pour le travail de sens (§Rôle, §Limites bash, SPEC.md, hooks).

**Écarté :** Skill `/sdlc-init` invoqué depuis Claude Code dans le repo vide.

**Raison :** Problème de l'œuf et la poule — un skill ne peut pas être invoqué
avant d'exister dans le repo. Un script shell n'a pas cette contrainte :
il est exécuté depuis n'importe où, lit les templates du repo SDLC,
et les copie dans le repo cible. Division claire : script = mécanique + structure,
Claude Code = sens + adaptation domaine.

---

## M-ARCH-06 · 10-OPERATIONS.html comme mode opératoire humain · v1.3 · 03/06/2026

**Retenu :** Document HTML autonome (`10-OPERATIONS.html`) couvrant les trois opérations
humaines : initialiser un projet, mettre à jour un projet existant, faire évoluer le modèle.
Navigation latérale fixe, copy-paste des commandes en un clic.

**Écarté :** Section supplémentaire dans `06-PDR-bootstrap.md` (déjà dense) ·
README standard (moins lisible pour un humain) · skill Claude Code (mauvaise audience).

**Raison :** Les skills sont pour Claude Code. Le mode opératoire est pour l'humain
qui orchestre. Le HTML permet une expérience de lecture qualitative impossible en markdown :
navigation, sections, commandes copiables. Audience : tout développeur qui utilise le toolkit,
pas seulement l'auteur du modèle.

---

## Tableau de compatibilité — décisions par version

> Pour chaque décision du modèle : universelle (s'applique à tout projet sans condition)
> ou conditionnelle (dépend d'une contrainte projet).
> Référence utilisée à l'étape B du skill `/sdlc-sync`.

| ID | Décision | Universelle | Conditionnelle si… |
|----|----------|-------------|-------------------|
| M-ARCH-01 | 8 fichiers séparés | ✓ | — |
| M-ARCH-02 | Numérotation 00-0N | ✓ | — |
| M-ARCH-03 | DECISIONS/CHANGELOG/LESSONS_LEARNED hors SDLC | ✓ | — |
| M-ARCH-04 | 00-README méta-document | ✓ projet SDLC uniquement | — |
| M-ARCH-05 | sdlc-init.sh point d'entrée bootstrap | ✓ | — |
| M-ARCH-06 | 10-OPERATIONS.html mode opératoire humain | ✓ | — |
| M-TMPL-01 | Placeholders + marqueurs [→ ADAPTER] | ✓ | — |
| M-TMPL-02 | Champ Interdit dans PDR | ✓ | — |
| M-TMPL-03 | Given/When/Then dans PDR | ✓ | — |
| M-PROC-01 | Sprint 0 comme PDR opérationnel complet | ✓ | — |
| M-PROC-02 | Bilan session intégré dans wrap-up (Étape 0) | ✓ | — |
| M-PROC-03 | Auto-exécution sans questions utilisateur | ✓ | — |
| M-PROC-04 | Nettoyage artefacts périmés en Étape 3 | ✓ | — |
| M-PROC-05 | DIAGNOSTIC_CMDS.md obligatoire | ✓ | — |
| M-PROC-06 | Boucle rétroaction hook via LESSONS_LEARNED | ✓ | — |
| M-PROC-07 | Vérification exécutable renforcée | ✓ | — |
| M-PROC-08 | Circuit SDLC_CANDIDATE via retrospective | ✓ | — |
| M-PROC-09 | Sprint SDLC-Sync + skill /sdlc-sync | ✓ | — |
| M-SCOPE-01 | sprint-template.md = copie sans adaptation | ✓ | — |
| M-SCOPE-02 | SPEC.md = from scratch | ✓ | — |
| M-HOOKS-01 | PreToolUse-only au bootstrap | — | Si contraintes bash identifiées |
| M-HOOKS-02 | Sections [ACTIVER si…] dans hook | — | Si contraintes bash identifiées |
| M-PROC-10 | Mémoire de sprint intra-session | ✓ | — |
| M-PROC-11 | Modifications spot par script sed/grep | ✓ | — |
| M-PROC-12 | Init sprint : spec + mémoire + plan de développement | ✓ | — |

---

## M-PROC-10 · Mémoire de sprint intra-session · v1.3 · 04/06/2026

**Retenu :** Fichier `.claude/sprint-memory.md` — non versionné (gitignore), créé au §Handoff,
enrichi au fil du sprint (6 types d'entrées), lu à l'Étape 0 du wrap-up, détruit après commit (Étape 4).

**Écarté :**
- Section "ÉTAT DU SPRINT" en tête (oracle) : doublon de la vérification début de sprint, coût de maintenance à chaque écriture
- Section "WRAP-UP automatique" en bas de fichier (oracle) : confusion de rôles avec le skill `/wrap-up`
- Règle de résumé automatique >150 lignes (oracle) : corrige le symptôme, pas la cause (règles de déclenchement non respectées)
- Matrice de tests (oracle) : sur-ingénierie pour 1-3 tests par sprint standard
- Emplacement `specs/Sprints/sprint-N-memory.md` : versionné = bruit dans git log ; le fichier ne vit pas jusqu'au commit

**Raison :** Deux fonctions distinctes — crash-recovery (reprendre une session interrompue) et matière
première du wrap-up (extraire décisions/apprentissages sans relire toute la conversation).
Non versionné → zéro bruit git. Destruction post-commit → force la migration vers les fichiers permanents
(CHANGELOG, DECISIONS, LESSONS_LEARNED), cohérent avec INV-2 (circuit fermé).

**Règles de déclenchement (c) :** écrire uniquement sur analyse, décision, test, question, pivot, bloquant
— soit 3–5 entrées/heure. Maintient le fichier sous ~80 lignes (seuil empirique validé par oracle).

**Vérification début de sprint :** si `.claude/sprint-memory.md` est non vide, Claude bloque et demande
à l'humain (wrap-up oublié / crash / reprise volontaire). Exception : header correspond au sprint en cours
→ reprise normale. Validation humaine obligatoire car Claude n'a pas l'information pour décider seul.

**Enrichissements oracle retenus :**
- Flag `EN ATTENTE [humain]` sur QUESTION et BLOQUANT → action items automatiques au wrap-up
- Champ `→ fichiers :` optionnel sur DÉCISION → reprise de contexte rapide post-crash

---

## M-PROC-11 · Modifications spot par script sed/grep · v1.4 · 04/06/2026

**Retenu :** Toute modification ciblée sur un fichier existant (substitution de
pattern, mise à jour de référence, renommage dans le contenu) se fait par script
`sed`/`grep` exécutable, avec vérification finale obligatoire (grep de l'ancien
pattern → zéro résultat). Si la modification est trop complexe pour `sed`,
régénérer le fichier complet depuis le template.

**Écarté :** Fournir un diff textuel ou des instructions manuelles "remplacer X
par Y à la ligne N" à appliquer par l'humain.

**Raison :** Cohérent avec INV-1 (vérification exécutable) : une modification sans
preuve observable n'est pas une modification vérifiée. Un diff manuel est une
source d'erreur (mauvaise ligne, contexte décalé, oubli d'occurrence). Un script
`sed` avec grep de validation est reproductible, auditable, et échoue explicitement
si le pattern a changé. La pratique existait déjà implicitement dans `sdlc-init.sh`
(substitution des placeholders) mais n'était pas formalisée comme règle générale.

---

## M-PROC-12 · Init sprint : spec + mémoire + plan de développement · v1.5 · 05/06/2026

**Retenu :** Séquence obligatoire en 4 étapes (4a→4d) avant tout code :
(4a) créer `specs/Sprints/sprint-N-slug.md` depuis le PDR reçu,
(4b) initialiser `.claude/sprint-memory.md`,
(4c) lire le spec,
(4d) écrire le §Plan de développement dans le spec.

**Écarté :**
- Hook `pre-tool-bash.sh` détectant l'absence du fichier sprint : trop invasif pour un gap de process
- Skill `/sprint-init` dédié : surcharge pour 4 actions séquentielles déjà dans §Démarrage

**Raison :** Observation directe projet JobSearch (05/06/2026) — sprints 33–37b sans fichier
`specs/Sprints/sprint-N.md` dans git. La règle §4 existante (`cat specs/Sprints/…`) supposait
que le fichier existait déjà. Rendre la création explicite et vérifiable dès la réception du PDR
garantit la traçabilité du plan de développement et la matière première du wrap-up.
La distinction §Handoff (humain) / §Plan de développement (Claude Code) / §Corrections ajustées
(wrap-up) matérialise les trois temps du sprint dans un seul fichier versionné.

---

## M-PROC-13 · Annotation de confiance sur les entrées ANALYSE · v1.6 · 11/06/2026

**Retenu :** Suffixe optionnel `[CONF: HAUTE/MOY/FAIBLE — raison en 1 ligne]` sur les entrées
`ANALYSE` dans `sprint-memory.md`, et mention explicite du niveau de confiance dans la
`## Demande d'aval` de `Claude.md §Analyse`.

**Écarté :**
- Confiance sur tous les types d'entrées (DÉCISION, TEST, etc.) : surcharge sans bénéfice net — TEST a déjà OK/FAIL, DÉCISION est binaire par construction
- Score numérique (0–100%) : fausse précision, difficile à calibrer de façon cohérente
- Champ obligatoire : ajoute de la friction sur les analyses simples où la confiance est évidemment haute

**Raison :** Issu de l'analyse des skills `/incident-response` (Harness) — le niveau HIGH/MEDIUM/LOW
sur les corrélations causales permet à l'humain de calibrer son aval sans relire toute l'analyse.
Principe 9.9 du chapitre (vérification indépendante) : l'annotateur et l'analyste sont le même
agent, mais nommer l'incertitude force une auto-évaluation explicite et donne à l'humain
un signal rapide pour savoir où concentrer son attention. Sur les analyses FAIBLE, l'humain
sait immédiatement qu'un Oracle ou une vérification manuelle est justifiée avant l'aval.

**Critères de calibration :**
- HAUTE : information directement observable dans les fichiers/logs, pas d'inférence
- MOY : inférence fondée sur des indices convergents, mais sans preuve directe
- FAIBLE : hypothèse de travail, information manquante ou contradictoire

---

## M-PROC-14 · Alternative concrète dans les messages de blocage · v1.6 · 11/06/2026

**Retenu :** Champ optionnel `→ alternative : [action concrète possible sans lever ce bloquant]`
sur les entrées `BLOQUANT` dans `sprint-memory.md`. Dans les hooks `pre-tool-bash.sh`,
étendre le message `exit 2` pour inclure une alternative quand elle existe.

**Écarté :**
- Alternative obligatoire sur tout BLOQUANT : certains bloquants n'ont pas d'alternative
  (ex : secret manquant — la seule action est d'attendre l'humain)
- Arbre de décision complet dans le hook : trop lourd pour un message d'erreur bash

**Raison :** Issu des troubleshooting sections des skills Harness — la distinction entre
"mur" et "mur avec porte" change radicalement l'expérience de friction. Principe 9.7
du chapitre (recovery optimizes for continuation) : ne pas laisser l'utilisateur dans
un état d'échec sans chemin de sortie visible. Le champ est optionnel car son absence
est aussi informative : un BLOQUANT sans alternative signale une dépendance humaine
réelle, pas une limitation contournable.

**Règle d'application aux hooks :**
Quand une section `[ACTIVER si…]` est activée dans `pre-tool-bash.sh`, si une alternative
concrète existe, l'ajouter au message `exit 2` :
```bash
echo "BLOQUÉ : X interdit." >&2
echo "Alternative : Y." >&2  # ← ajouter quand pertinent
exit 2
```
Documenter l'alternative dans l'entrée `doc/DECISIONS.md §D-HOOK-XX` correspondante.

---

## M-PROC-15 · Marqueur de validité conditionnelle sur les entrées DÉCISION · v1.6 · 11/06/2026

**Retenu :** Champ optionnel `[valide jusqu'à : condition]` sur les entrées `DÉCISION`
dans `sprint-memory.md`. La condition est un état observable du système, pas un timestamp.

**Écarté :**
- Timestamp d'expiration (ex : `[valide jusqu'à : 17:00]`) : une décision n'expire pas
  avec le temps mais avec un changement d'état — le timestamp est une approximation incorrecte
- Champ obligatoire : la majorité des décisions sont stables pour toute la durée du sprint
  et le rendre obligatoire créerait du remplissage vide

**Raison :** Issu des performance notes des skills Harness — `/deployment-readiness` note
explicitement que les checks doivent tourner contre l'état réel, pas un état mis en cache,
et que l'analyse de drift est valide "right before deployment", pas des heures avant.
En session longue (> 2h avec modifications de fichiers), une `DÉCISION` prise sur la base
d'une analyse peut être invalidée par un changement ultérieur sans que Claude le détecte.
Le marqueur rend la condition d'invalidation explicite au moment où la décision est prise,
ce qui permet de la repérer immédiatement au wrap-up ou en reprise de session tronquée.

**Exemples de conditions valides :**
```
[valide jusqu'à : aucun fichier config modifié]
[valide jusqu'à : schema DB stable]
[valide jusqu'à : dépendance X non mise à jour]
[stable]  ← forme courte pour les décisions sans condition d'invalidation
```

**Interaction avec M-PROC-13 (session tronquée) :**
En reprise après crash (option D du démarrage), les entrées DÉCISION avec
`[valide jusqu'à : condition]` doivent être vérifiées en premier — si la condition
n'est plus vraie, la décision est invalidée et l'analyse doit être refaite.

---

## M-ARCH-07 · §Dépendances dans le PDR sprint · v1.6 · 11/06/2026

**Retenu :** Nouvelle section `## Dépendances` dans `04-sprint-PDR-TEMPLATE.md`,
avec deux sous-listes : **Inputs requis** (outputs de sprints précédents ou ressources
externes que ce sprint assume comme valides) et **Outputs produits** (artefacts que
les sprints suivants pourront utiliser). Vérification des inputs requise en §Plan de
développement avant toute analyse.

**Écarté :**
- Dépendances dans §Contexte (enfouies dans du texte, non vérifiables par grep)
- Liste unique sans distinction input/output (perd l'information de direction)
- Section obligatoire avec "aucune" par défaut (aucune dépendance n'est aussi informative
  que de cocher explicitement la case)

**Raison :** Issu de l'analyse des §Cross-Skill Workflows Harness — la règle
*"always check if a referenced resource exists before creating something that depends on it"*
s'applique directement aux sprints : une décision D-07 citée dans un sprint ultérieur
peut avoir été révisée. Sans §Dépendances explicite, cette vérification est implicite
dans la tête de l'humain, pas dans le processus. Cohérent avec INV-1 (vérification
exécutable) étendu au séquencement inter-sprints, pas seulement aux tests unitaires.

**Propagation :** §Plan de développement du PDR inclut désormais un sous-bloc
"Dépendances vérifiées" avec la liste des inputs et leur état constaté.

---

## M-PROC-16 · §Handoff eager/lazy — chargement immédiat vs différé · v1.6 · 11/06/2026

**Retenu :** Le §Handoff du PDR sprint distingue explicitement deux listes :
**"chargement immédiat"** (lire en étape 4c, avant toute analyse) et
**"chargement différé"** (grep d'abord, lire entièrement seulement si le grep
confirme la pertinence). Cette distinction est répercutée dans `Claude.md §Démarrage`
(étape 4c) et `Claude.md §Tokens`.

**Écarté :**
- Liste unique sans distinction (état actuel — force un choix implicite à chaque session)
- Toujours tout charger en immédiat (viole INV-3 sur les sessions avec SPEC.md dense)
- Laisser Claude décider au cas par cas sans guidage (non reproductible, dépend de
  l'expérience accumulée de l'auteur du §Handoff)

**Raison :** Issu du pattern `harness_describe` de l'architecture Harness MCP —
*"don't embed schemas in skills, discover at runtime what you need."* Traduit dans
le SDLC : la distinction eager/lazy dans le §Handoff est une décision prise par
l'humain qui rédige la spec, pas une heuristique que Claude reconstruit à chaque session.
Cohérent avec INV-3 (contexte chirurgical) et principe 9.5 du chapitre (context is
working memory — optimise for governable, not more). Les fichiers différés typiques :
SPEC.md complet, modules non touchés par ce sprint, DECISIONS.md historique.
Les fichiers immédiats typiques : spec du sprint, fichiers directement modifiés.

---

## M-PROC-17 · Index structuré des patterns dans /retrospective · v1.6 · 11/06/2026

**Retenu :** Le skill `/retrospective` produit désormais un §Index des patterns
en format tableau markdown (colonnes : ID, Pattern, Occurrences, Sprints, Statut,
Décision) et un §Métriques de rétro (compteurs : sprints couverts, HOOK_CANDIDATE,
SDLC_CANDIDATE, décisions invalidées, patterns nouveaux/résolus). Ces deux sections
remplacent le simple horodatage `Dernière /retrospective : JJ/MM/AAAA · Sprints N→M`.
Un bloc §Requêtes utiles documente les greps permettant des vues rapides sans relire
tout le fichier.

**Écarté :**
- Format JSON dans LESSONS_LEARNED (lisible par machine mais pas par humain sans outil)
- Fichier séparé `doc/RETRO_INDEX.md` (un fichier de plus à maintenir, risque de
  désynchronisation avec LESSONS_LEARNED)
- Compteurs seulement sans tableau de patterns (perd la traçabilité par pattern)

**Raison :** Issu de l'observation que les skills `/dora-metrics` et `/sei-analytics`
Harness rendent les patterns engineering *requêtables* — pas seulement lisibles.
Après 10-15 sprints, un LESSONS_LEARNED en prose devient difficile à exploiter :
les patterns se répètent sans être facilement identifiables. Le format tableau
markdown est à la fois human-readable et grep-able — les requêtes §Requêtes utiles
permettent d'extraire patterns actifs, HOOK_CANDIDATE en attente, et décisions
invalidées sans charger tout le fichier (INV-3). Le §Métriques de rétro donne
une vue d'état instantanée de la santé du processus, analogue à un DORA snapshot
pour le workflow de sprint lui-même.

**Interaction avec M-PROC-15 :** Les décisions `[valide jusqu'à : condition]`
sont désormais scannées à chaque `/retrospective` (Étape 2 — bloc DÉCISIONS
POTENTIELLEMENT INVALIDÉES), ce qui ferme la boucle entre la pose du marqueur
(en session) et sa vérification (en rétro).
