# DECISIONS-SDLC — Modèle de gouvernance Claude Code
<!-- v1.7 · 11/06/2026 · Décisions sur le modèle lui-même, pas sur les projets cibles -->

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
| M-ENV   | Décisions sur l'environnement et l'infrastructure locale (chemins, outils) |

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

→ Mise à jour 19/06/2026 (Sprint SDLC-18) : matcher `PreToolUse` élargi de `Bash` seul à
`Bash|Edit|Write` dans ce projet, pour permettre le carve-out M-HOOKS-04 (garde-fou
étape 4a) de s'appliquer aussi aux écritures de fichier, pas seulement aux commandes
shell. Le `PostToolUse` reste non activé — décision M-HOOKS-01 inchangée sur ce point.

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
| M-PROC-13 | Annotation `[CONF: HAUTE/MOY/FAIBLE]` sur ANALYSE (sprint-memory) | ✓ | — |
| M-PROC-14 | Champ `→ alternative :` sur BLOQUANT (sprint-memory) | ✓ | — |
| M-PROC-15 | `[valide jusqu'à : condition]` sur DÉCISION (sprint-memory) | ✓ | — |
| M-PROC-16 | Handoff PDR scindé en chargement immédiat / différé | ✓ | — |
| M-PROC-17 | Index structuré des patterns + métriques dans /retrospective | ✓ | — |
| M-ARCH-07 | §Dépendances (inputs/outputs) dans le PDR sprint | ✓ | — |
| M-PROC-18 | Recommandation de vérification externe (Oracle/revue humaine) si confiance FAIBLE | ✓ | — |
| M-HOOKS-03 | §PostToolUse restructuré en Option A (lint) / Option B (changelog) | ✓ | — |
| M-PROC-19 | Revue objectif sprint §0e — verdict ATTEINT/PARTIEL/NON ATTEINT ancré sur spec + git diff | ✓ | — |
| M-PROC-20 | Signaux rétrospectifs — second output §0a extrait de sprint-memory avant §Étape 1 | ✓ | — |
| M-PROC-21 | Enforcement fichier sprint — `grep -En` unique dans §Étape 3 avec résultat attendu | ✓ | — |
| M-PROC-22 | SESSION_BRIDGE accumulatif (§Étape 5) + vérification CLAUDE_PROJECT delta (§Étape 6) | ✓ | — |
| M-PROC-23 | Volumétrie minimum dans §Plan de test PDR + note anti-faux-positif §Niveau A (STANDARDS) | ✓ | — |
| M-PROC-24 | CLAUDE_PROJECT versionné — script sdlc-project-check.sh + §Étape D sdlc-sync | ✓ | — |
| M-ARCH-08 | §Observabilité STANDARDS restructuré en checklist Q/R actionnable (5 questions `[À REMPLIR]`) | ✓ | — |
| M-ENV-01  | Emplacement toolkit SDLC local (`~/Downloads/Sandbox/SDLC/`) | ✓ (valeur locale) | — |
| M-PROC-25 | Co-construction PDR SDLC-Sync dans Claude.ai via sdlc-delta.sh | ✓ | — |
| M-SCOPE-03 | Pas de modes nommés dans Claude.md §Rôle | ✓ | — |
| M-PROC-26 | Skill /help — recap lecture seule | ✓ | — |
| M-SCOPE-04 | Phase amont Project Claude.ai séparé, zéro marqueur côté Claude Code | ✓ | — |
| M-HOOKS-04 | Carve-out anti-auto-verrouillage M-HOOKS-04 (garde-fou étape 4a) | ✓ | — |
| M-HOOKS-05 | Extraction JSON PreToolUse corrigée (`tool_input`, pas `input`) | ✓ | — |
| M-HOOKS-06 | Allowlist Bash lecture seule pendant blocage M-HOOKS-04 | — | Si M-HOOKS-04 rétro-porté vers 08-hooks-TEMPLATE.md |
| M-PROC-27 | Backfill CHANGELOG/DECISIONS SDLC-07-09 — clos sans rattrapage | — (résolution historique propre à ce repo, hors cadre du tableau) | — |
| M-PROC-28 | Distinction taille « cœur » vs « gouvernance associée » — règle stable | — (jamais rétro-porté — confirmé : grep "cœur du changement" 01-Claude-md-TEMPLATE.md → vide) | Si rétro-porté vers 01-Claude-md-TEMPLATE.md |
| M-PROC-29 | Audit complet SDLC-07→15 — verdicts confirmés, requalification narrative | — (audit propre à ce repo, hors cadre du tableau) | — |
| M-PROC-30 | Test d'un hook bloquant — isolation obligatoire | ✓ | — |
| M-PROC-31 | Tables de rationalisation par HALT — import recalibré Superpowers | ✓ | — |
| M-PROC-32 | Fusion clause anti-complaisance + renvoi croisé §Rôle/§Test | ✓ | — |
| M-PROC-33 | Sélection de modèle pour sous-agent délégué | ✓ | — |
| M-PROC-34 | Taxonomie "Revue" dans STANDARDS §Types de sprint | ✓ | — |
| M-PROC-35 | Tables de rationalisation HALT — 3e passage, étiquette [HYPOTHÈSE] retenue | ✓ | — |
| M-HOOKS-07 | Confinement natif sandbox OS (bubblewrap/Seatbelt) + permissions dontAsk | ✓ (template) | Si sandboxing natif disponible sur la machine (bwrap/socat installés, profil AppArmor sur Ubuntu 24.04+) |
| M-PROC-36 | Instrumentation conso token réelle — `sdlc-token-usage.sh` + suppression collage manuel §0c wrap-up | ✓ | — |

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

---

## M-PROC-18 · Recommandation de vérification externe si confiance FAIBLE · v1.7 · 11/06/2026

**Contexte :** M-PROC-13 a introduit l'annotation `[CONF: HAUTE/MOY/FAIBLE — raison]` sur
les entrées `ANALYSE` de `sprint-memory.md`, comme signal de calibration. Le signal est
correctement renseigné mais n'a aucune conséquence procédurale : une `ANALYSE [CONF: FAIBLE]`
mène à une `Demande d'aval` formulée exactement comme une analyse `[CONF: HAUTE]`.

**Retenu :** Ajout d'une ligne dans `Claude.md §Analyse §Demande d'aval`, juste après la
ligne de résumé :
> Si confiance FAIBLE → recommander explicitement une vérification externe (Oracle ou
> revue humaine) avant l'aval.

**Écarté :**
- Statu quo (annotation `[CONF: FAIBLE]` purement informative) — c'est l'option qui motive
  cette décision : un signal sans conséquence se dégrade en habitude ignorée après quelques
  sprints.
- Vérification externe obligatoire et bloquante sur toute analyse `[CONF: FAIBLE]` —
  transférerait la décision de l'humain vers une règle automatique, contraire à
  "Claude propose, l'humain décide" (INV-3).

**Raison :** Ferme la boucle ouverte par M-PROC-13 sans changer qui décide. La
recommandation apparaît au moment précis où l'humain donne (ou non) son aval — il reste
libre de l'ignorer, mais ne peut plus l'ignorer *passivement*.

**Interaction avec M-PROC-15 :** une `ANALYSE [CONF: FAIBLE]` qui mène à une `DÉCISION`
porte souvent un `[valide jusqu'à : condition]` non trivial — faible confiance et validité
conditionnelle sont fréquemment corrélées (l'incertitude vient généralement d'une
dépendance à un état qui peut changer).

**Impact fichiers :** `01-Claude-md-TEMPLATE.md` (§Analyse §Demande d'aval, +1 ligne).

---

## M-HOOKS-03 · §PostToolUse restructuré en deux options indépendantes · v1.7 · 11/06/2026

**Contexte :** `08-hooks-TEMPLATE.md §PostToolUse` ne documentait qu'une seule option
(lint/format `ruff`, M-HOOKS-01), non titrée, avec une recommandation de timing unique
("décider au sprint 1 ou 2 une fois la stack stabilisée"). Cette recommandation est
justifiée pour `ruff` (suppose un formatter configuré) mais n'a aucune raison de
s'appliquer à un hook sans dépendance externe.

**Retenu :** Restructuration de la section en deux sous-sections indépendamment activables :
- **Option A — Lint/format automatique (ruff)** : contenu inchangé (M-HOOKS-01), retitré,
  intro reformulée pour expliciter la sémantique PostToolUse (s'exécute après l'action,
  ne peut pas bloquer — seulement avertir ou compléter). Référence `§D-HOOK-07`.
- **Option B — Vérification CHANGELOG au commit** (nouvelle) :
  `.claude/hooks/post-commit-changelog.sh`, hook `PostToolUse` sur `Bash`, avertit
  (non bloquant) si un `git commit` ne modifie pas `CHANGELOG.md`, hors `--amend`.
  Snippet `settings.json`, smoke test et référence `§D-HOOK-08` inclus.

**Écarté :**
- Fusionner Option B dans la section existante avec la même recommandation de timing —
  aurait masqué que Option B n'a aucune des dépendances qui justifient le délai
  d'Option A (formatter configuré, tests < 5s).
- Rendre Option B bloquante (PreToolUse) — au moment où un hook PostToolUse se déclenche,
  le commit a déjà eu lieu ; bloquer après coup n'a pas de sens, seul l'avertissement est
  cohérent avec la sémantique PostToolUse.

**Raison :** Option A suppose une stack stabilisée (sprint 1-2). Option B n'a aucune
dépendance externe au-delà de `git` + `python3` et peut être activée dès le sprint 0.
Regrouper les deux sous une recommandation de timing unique était trompeur pour Option B.
La restructuration rend les deux trajectoires d'activation indépendantes et explicites,
sans imposer l'une comme prérequis de l'autre.

**Lien avec `/wrap-up` §Étape 3 :** Option B fournit un filet de sécurité non bloquant sur
le même invariant que l'Étape 3 du wrap-up ("CHANGELOG.md à jour") — elle rattrape un
oubli au moment du commit plutôt qu'en fin de session, sans dupliquer ni remplacer la
vérification de wrap-up.

**Impact fichiers :** `08-hooks-TEMPLATE.md` (§PostToolUse → ### Option A / ### Option B,
+~95 lignes).

---

## M-PROC-19 · Revue objectif sprint — verdict §0e · v1.8 · 14/06/2026

**Contexte :** Le wrap-up produisait un bilan factuel (fait/pas fait) sans évaluer si
l'objectif du sprint avait été atteint dans sa substance. Un sprint "fait à 90%" pouvait
être présenté comme un succès sans jamais citer les critères d'acceptation.

**Retenu :** Nouvelle sous-section §0e à la fin de §Étape 0, avant §Étape 1.
Verdict en 4 champs : objectif PDR · résultat constaté · ATTEINT/PARTIEL/NON ATTEINT ·
justification citant ≥ 1 critère d'acceptation de la spec et son état dans le diff git.
Règle : un "fait à 90%" sans critère d'acceptation coché n'est pas ATTEINT.

**Écarté :** Fusion avec §Étape 1 (rétrospective) — l'évaluation factuelle et le qualitatif
sont de nature différente, les mélanger dilue les deux.

**Raison :** Ferme le gap entre bilan de tâches et verdict sur l'objectif. Ancrer sur la
spec et le git diff empêche le biais d'optimisme en fin de session.

**Impact fichiers :** `03-wrap-up-SKILL-TEMPLATE.md` (§0e nouveau, ~12 lignes).

---

## M-PROC-20 · Signaux rétrospectifs — second output §0a · v1.8 · 14/06/2026

**Contexte :** Les questions rétrospectives de §Étape 1 étaient posées à blanc, alors que
sprint-memory contenait déjà les signaux pertinents (PIVOT, BLOQUANT non résolu,
HOOK_CANDIDATE, CONF FAIBLE). Les réponses humaines manquaient de contexte factuel.

**Retenu :** Extension de §0a : même passage sur sprint-memory (déjà chargé), second output =
synthèse 3 bullets maximum des signaux pertinents pour la rétrospective. Présentée avant les
questions de §Étape 1 comme contexte — pas comme réponses suggérées.

**Écarté :** Relecture séparée de sprint-memory en §Étape 1 — doublon (sprint-memory est
déjà chargé en §0a). Réponses à choix multiples — biais de confirmation documenté.

**Raison :** Les signaux sont factuels et court-circuitent la reconstruction de mémoire.
Les présenter comme contexte (pas comme pré-réponses) respecte INV-3.

**Impact fichiers :** `03-wrap-up-SKILL-TEMPLATE.md` (§0a étendu, +8 lignes).

---

## M-PROC-21 · Enforcement fichier sprint — `grep -En` unique · v1.8 · 14/06/2026

**Contexte :** §Étape 3 décrivait en prose non exécutable la vérification du fichier sprint.
Aucune commande permettait de confirmer l'absence de placeholders résiduels avant commit.

**Retenu :** Une commande consolidée dans §Étape 3, juste après le bloc prose existant :
```bash
grep -En "\[À REMPLIR\]|\[ \]|\[→ ADAPTER\]" specs/Sprints/sprint-N-slug.md \
  && echo "⚠️ placeholders résiduels — corriger avant commit" \
  || echo "✅ spec propre"
```
Résultat `✅ spec propre` attendu. Ligne `⚠️` = erreur bloquante.
Deux déclencheurs conditionnels ajoutés : nettoyage SESSION_BRIDGE et delta CLAUDE_PROJECT.

**Écarté :** Trois commandes distinctes (ls + grep + grep) — sur-ingénierie, une seule
couvre les cas utiles.

**Raison :** Une commande exécutable couvrant les cas d'usage réels, avec résultat attendu
explicite. Cohérent avec INV-1 (vérification exécutable).

**Impact fichiers :** `03-wrap-up-SKILL-TEMPLATE.md` (§Étape 3 + tableau conditionnels, +8 lignes).

---

## M-PROC-22 · SESSION_BRIDGE accumulatif + vérification CLAUDE_PROJECT delta · v1.8 · 14/06/2026

**Contexte :** L'amorce session suivante (§Étape 5) était affichée dans le chat et perdue
dès la fermeture. §Étape 6 émettait un reminder vague "Sync now" sans cibler les fichiers
manquants.

**Retenu (SESSION_BRIDGE) :** §Étape 5 réécrite : écriture de `doc/SESSION_BRIDGE.md`
versionné, accumulatif (entrée la plus récente en tête). Format 4 champs : sprint/date ·
commit · bloquants en suspens · fil fonctionnel (2 phrases max). Nettoyage conditionnel
au wrap-up si entrée `[CLOS]` ou > 5 entrées sans nettoyage. Ne contient pas de liste de
tâches (rôle du ROADMAP §Now). Affiché dans le chat ET écrit dans le fichier.

**Retenu (CLAUDE_PROJECT) :** §Étape 6 réécrite : si `doc/CLAUDE_PROJECT.md` existe →
comparer les fichiers de gouvernance du repo avec la liste et produire un reminder ciblé
sur les fichiers manquants. Si absent (05b non exécuté) → fallback reminder vague conservé.

**Écarté :** Écrasement SESSION_BRIDGE à chaque sprint — détruit le fil fonctionnel quand
des sprints correctifs s'intercalent. `.claude/next-session.md` non versionné — perdu en
cas de changement de machine.

**Raison :** Persiste le contexte inter-session sans dépendre de la continuité du chat.
La vérification CLAUDE_PROJECT devient structurée quand 05b est exécuté, dégradée sinon.

**Interaction avec M-PROC-10 :** SESSION_BRIDGE complète sprint-memory sans se substituer.
sprint-memory est intra-session et non versionné ; SESSION_BRIDGE est inter-session et
versionné. La règle de destruction de sprint-memory (M-PROC-10) reste inchangée.

**Impact fichiers :** `03-wrap-up-SKILL-TEMPLATE.md` (§Étape 5 réécrite + §Étape 6 réécrite) ·
`01-Claude-md-TEMPLATE.md` (§Démarrage §2 + §Règles absolues) · `06-PDR-bootstrap.md` (carte §Groupe 2).

---

## M-PROC-23 · Volumétrie minimum dans §Plan de test · v1.9 · 14/06/2026

**Contexte :** Un test de niveau A peut passer au vert sur un corpus vide — le pipeline
tourne, zéro item traité, zéro erreur. La commande retourne exit 0 et le test est marqué
OK. Ce faux positif est indétectable par la procédure actuelle sans condition de volumétrie.

**Retenu :** Champ optionnel `**Volumétrie minimum :**` dans §Plan de test du PDR sprint,
avec note explicative. Ajout dans STANDARDS §Niveaux de test d'une note anti-faux-positif :
"un test A sur pipeline est invalide si le corpus contient zéro items traités — vérifier
le compteur de sortie, pas seulement exit 0."

**Écarté :** Nouveau niveau "A+" — sur-ingénierie, le problème est dans la définition du
critère, pas dans la taxonomie des niveaux. Champ obligatoire — tous les sprints ne traitent
pas de corpus, rendre optionnel avec note est plus juste.

**Raison :** Ferme la boucle ouverte par la définition actuelle de niveau A qui ne distingue
pas "commande réussie" et "système a traité des items". L'optionnalité préserve la simplicité
pour les sprints de gouvernance (zéro corpus).

**Impact fichiers :** `04-sprint-PDR-TEMPLATE.md` (§Plan de test +1 ligne) · `02-STANDARDS-TEMPLATE.md` (§Niveaux de test +1 note).

---

## M-PROC-24 · CLAUDE_PROJECT versionné — sdlc-project-check.sh · v1.9 · 14/06/2026

**Contexte :** Le projet Claude.ai (description + liste fichiers synchronisés) n'était nulle
part versionné. Une suppression accidentelle du projet dans Claude.ai était irrécupérable
sans référence. §Étape 6 du wrap-up (M-PROC-22) référençait CLAUDE_PROJECT.md sans que
le fichier puisse être créé.

**Retenu :** Script shell `sdlc-project-check.sh` (bash pur, < 60 lignes, zéro dépendance).
Il inventorie les fichiers de gouvernance, détecte les deltas vs CLAUDE_PROJECT.md existant,
affiche une liste de directives pour Claude Code (avis), et génère `doc/CLAUDE_PROJECT.md`
avec sections standardisées. Intégré dans `06-PDR-bootstrap.md §Étape 1b` et dans
`04b-sdlc-sync-SKILL-TEMPLATE.md §Étape D4`.

**Écarté :** Skill `/project-check` dédié — sur-ingénierie pour 3 lignes de checklist.
Grep automatique systématique au wrap-up — fragile et trop fréquent (CLAUDE_PROJECT.md
n'évolue pas à chaque sprint).

**Raison :** `doc/CLAUDE_PROJECT.md` versionné → reconstructible après suppression accidentelle.
L'intelligence reste chez Claude (lecture des fichiers + formulation), le script fait le
travail mécanique (inventaire + génération template).

**Impact fichiers :** `sdlc-project-check.sh` (nouveau) · `06-PDR-bootstrap.md` (§Étape 1b + carte + critère 10) · `04b-sdlc-sync-SKILL-TEMPLATE.md` (§D4 nouveau).

---

## M-ARCH-08 · §Observabilité STANDARDS — checklist Q/R actionnable · v1.9 · 14/06/2026

**Contexte :** La section §Observabilité de STANDARDS était un paragraphe générique
copiable sans être complété. Ni actionnable (pas de commandes concrètes), ni vérifiable
par grep (pas de `[À REMPLIR]`). Un projet bootstrap avec §Observabilité vide passait
toutes les vérifications — l'invisibilité des étapes système n'était jamais détectée.

**Retenu :** Remplacement de la section générique par une checklist de 5 questions Q/R
au format `Q: → R: [À REMPLIR]`. Grep de validation au bootstrap :
`grep "\[À REMPLIR\]" STANDARDS.md` → zéro résultat attendu. Même pattern que `[→ ADAPTER]`.
Ajout du grep dans `06-PDR-bootstrap.md §Étape 2` pour cohérence.

**Écarté :** Exemples génériques sans obligation de réponse — copiable sans être complété,
même problème que l'existant. Les 5 questions sont une proposition — note explicite
"adapter à la nature du système" préservée via `[→ ADAPTER]`.

**Raison :** Cohérent avec le pattern existant `[→ ADAPTER]` + `[À REMPLIR]` déjà utilisé.
La checklist Q/R force un choix de marqueur de log concret plutôt qu'un principe abstrait.
Vérifiable mécaniquement (grep) sans introduire de nouvelle convention.

**Interaction avec M-PROC-23 :** la question 5 ("aucun item silencieusement ignoré")
complète la note anti-faux-positif de M-PROC-23 — les deux adressent la même invisibilité
mais à des niveaux différents (design-time vs test-time).

**Impact fichiers :** `02-STANDARDS-TEMPLATE.md` (§Observabilité remplacé + note §Niveaux) · `06-PDR-bootstrap.md` (§Étape 2 grep étendu + critère 3).

---

## M-ENV-01 · Emplacement immuable du toolkit SDLC · 2026-06-14

**Emplacement local :** `~/Downloads/Sandbox/SDLC/`

Ce chemin est l'emplacement de référence du toolkit sur cette machine.
Il est encodé dans `sdlc-delta.sh` et doit être mis à jour si le toolkit est déplacé.
Ne pas inclure dans les repos de projets cibles — information locale uniquement.

**Scripts qui dépendent de ce chemin :**
- `sdlc-delta.sh` (variable `SDLC_SRC`)
- `sdlc-init.sh` (référencé dans `06-PDR-bootstrap.md`)

---

## M-PROC-25 · Co-construction PDR SDLC-Sync dans Claude.ai · 2026-06-14

**Contexte :** une migration SDLC-Sync sans pré-calcul force Claude Code à faire
l'inventaire et le delta lui-même depuis le projet cible, sans vue d'ensemble
validée avant l'entrée dans le projet.

**Retenu :** workflow en 3 temps pour les opérations SDLC-Sync :
1. **Pré-calcul local** : `bash ~/Downloads/Sandbox/SDLC/sdlc-delta.sh <chemin-projet>` — produit un bloc structuré (version, inventaire, git, tuning local, templates source)
2. **Co-construction dans Claude.ai** : coller le bloc + *"Construis le PDR SDLC-Sync pour [projet]"* — Claude.ai calcule le delta, pré-remplit le tableau, identifie les tunings à préserver
3. **Exécution dans Claude Code** : le PDR co-construit est copié dans `specs/Sprints/`, Claude Code exécute le sync depuis ce PDR

**Écarté :**
- Lancer `/sdlc-sync` directement dans Claude Code sans PDR : fonctionnel mais delta non validé avant l'entrée dans le projet
- PDR entièrement manuel : lent et source d'oublis sur les décisions récentes

**Script :** `sdlc-delta.sh` dans le toolkit (M-ENV-01).

---

## M-SCOPE-03 · Pas de "modes" nommés dans Claude.md §Rôle · v1.9+SDLC-10 · 18/06/2026

**Retenu :** Aucun mécanisme de modes/personas nommés (type "stratège/dev/
reviewer") n'est ajouté à `Claude.md §Rôle`. Question fermée (Q4,
`doc/ANALYSE-BMAD.md §5`).

**Écarté :** Formaliser des modes inspirés des agents nommés BMad — même
sans la machinerie TOML déjà écartée côté Spike SDLC-06 stratégique, le
simple fait de nommer des postures permanentes réintroduirait une rigidité
identitaire déjà écartée pour les named agents.

**Raison :** Le besoin réel de bascule de posture est déjà couvert par deux
mécanismes existants, contextuels et temporaires — jamais identitaires :
(1) le tableau "Classifier le travail" (`Claude.md §Démarrage`) fait varier
la posture selon le type de sprint (Évolution/Bug/Tuning/Revue) ;
(2) les couches Adversarial Review (`03-wrap-up-SKILL-TEMPLATE.md §0f`,
importées Sprint SDLC-09) font basculer la posture plusieurs fois dans une
même session avec des règles d'accès à l'information distinctes (Blind
Hunter / Edge Case Hunter / Acceptance Auditor), sans jamais nommer de
persona permanente.

**Déclencheur de réouverture :** signal documenté dans un `LESSONS_LEARNED`
de projet cible montrant un besoin de bascule de posture hors du cadre
couvert par ces deux mécanismes.

---

## M-PROC-26 · Skill /help — recap lecture seule, pas un guide · v1.9+SDLC-11 · 18/06/2026

**Retenu :** Skill `/help` qui agrège 3 sources existantes
(`sprint-memory.md`, `ROADMAP.md §Now/§Next`, tableau classification
`Claude.md`) en un recap fixe. Lecture seule, zéro suggestion, zéro
décision.

**Écarté :** `bmad-help` complet — un skill qui devine quoi faire selon
les modules installés. Notre toolkit a 4 skills, pas 34 workflows ; la
complexité qui justifie un moteur de guidance chez BMad n'existe pas ici.

**Raison :** Le besoin observé n'est pas "je ne sais pas quoi faire", c'est
"je dois relire 2-3 fichiers à chaque reprise de session pour me souvenir
où j'en suis" — un problème d'agrégation, pas de décision. Un agrégateur
pur coûte presque rien à construire (il n'invente rien) et n'a pas le
risque de mauvaise recommandation d'un guide actif.

**Déclencheur de réouverture (vers une version plus riche) :** si le
toolkit dépasse 6-7 skills actifs, ou si `/help` en l'état s'avère
insuffisant sur plusieurs sprints consécutifs (signal LESSONS_LEARNED).

---

## M-SCOPE-04 · Phase amont en Project Claude.ai séparé, zéro marqueur côté Claude Code · v1.9+SDLC-12 · 18/06/2026

**Retenu :** `10-AMONT-TEMPLATE.md` — contenu à charger dans le Project
Knowledge d'un Project Claude.ai dédié à l'idéation/PRD/architecture,
hors repo, hors toolkit Claude Code. Réponse à Q1 (`doc/ANALYSE-BMAD.md §5`).

**Écarté :** Étendre `01-Claude-md-TEMPLATE.md` ou créer un skill Claude
Code pour les phases amont — le toolkit reste un méta-framework de
gouvernance de sprint, pas un framework de product management (cohérent
avec la conclusion de Spike SDLC-06 stratégique).

**Écarté également :** marqueur de provenance (`<!-- Origine : Amont -->`
ou équivalent) sur les PDR issus de cette phase amont, et modifications
correspondantes de `Claude.md` / `03-wrap-up-SKILL-TEMPLATE.md`. Conçu
puis retiré pendant ce sprint — raison : `HALT-ARCH` (P-01, SDLC-07) et
`§Dépendances vérifiées` (M-ARCH-07) vérifient déjà toute hypothèse de
tout PDR contre le code réel, sans condition sur son origine. Un marqueur
aurait dupliqué un comportement déjà universel — ajout de complexité
sans bénéfice net.

**Raison du découpage amont/aval :** seul Claude Code a accès à la
"vérité" du code et de l'architecture réelle (le repo). Claude.ai ne
peut produire qu'un plan — aussi soigné soit-il, il reste une hypothèse
jusqu'à confrontation avec le code. Le découpage rend cette limite
explicite plutôt que de prétendre qu'un gate amont pourrait se substituer
à la vérification aval.

**M-SCOPE-02 inchangé :** la phase amont reste optionnelle, `specs/SPEC.md`
from scratch reste la voie par défaut sans elle.

---

## M-PROC-27 · Backfill CHANGELOG/DECISIONS SDLC-07-09 — clos sans rattrapage · v1.9+SDLC-15 · 19/06/2026

**Retenu :** Ne pas backfiller rétroactivement les entrées `CHANGELOG.md` /
`07-DECISIONS-SDLC.md` manquantes pour les sprints SDLC-07, 08, 09
(`LL-T01`, `doc/LESSONS_LEARNED.md`). Le gap reste documenté tel quel
dans `doc/LESSONS_LEARNED.md` et `doc/DIAGNOSTIC_CMDS.md` ; la discipline
d'entrée systématique est restaurée depuis SDLC-10 et ne s'est pas
reproduite depuis.

**Écarté :** Réécrire l'historique des versions déjà publiées pour
insérer rétroactivement 3 entrées entre `[v1.9] SDLC-05b` et
`[v1.9+SDLC-10]` — reconstruction a posteriori sans preuve directe
(contredit la citabilité de `Claude.md §Rôle`), pour un bénéfice
opérationnel nul sur des sprints déjà clos.

**Raison :** Le signal a rempli sa fonction — déclencher la discipline
observée depuis SDLC-10 — sans qu'un rattrapage rétroactif soit
nécessaire pour la suite. Décision prise lors de la première
`/retrospective` (SDLC-15), suite à l'alerte `SD-5` sur l'action `⏳`
ouverte depuis SDLC-11 (voir aussi décision ci-dessous).

**Déclencheur de réouverture :** aucun prévu — décision stable.

---

## M-PROC-29 · Audit complet SDLC-07→15 — verdicts confirmés, requalification narrative · v1.9+SDLC-16 · 19/06/2026

**Retenu :** Audit groupé des 9 sprints SDLC-07 à SDLC-15 par grep/ls/git
diff (Sprint SDLC-16) — verdict **ATTEINT** confirmé pour SDLC-07 à
SDLC-13 et SDLC-15 (8 sprints), preuve citée pour chacun. SDLC-14 scindé
en deux volets distincts : le volet "self-bootstrap" (livrables réels —
`Claude.md`, skills, hook, etc.) est **ATTEINT** ; le volet "rattrapage
07/08/09" du PDR SDLC-14 original est confirmé **non fait** — mais déjà
couvert par une décision explicite antérieure (`M-PROC-27`), pas un gap
ouvert. 8 phrases narratives déjà présentes dans
`doc/LESSONS_LEARNED.md` (écrites Sprint SDLC-14, portant sur le
déroulement de sessions de conception non vérifiable depuis git) sont
requalifiées en l'état — annotées `(non vérifiable depuis le repo —
audit SDLC-16)` sans suppression, sur décision explicite de
l'utilisateur (option "Requalifier non vérifiable" plutôt que retrait ou
confirmation).

**Raison :** `doc/LESSONS_LEARNED.md` contenait déjà du contenu créé en
SDLC-14 — pas vide comme le présupposait le contexte initial du PDR
SDLC-16. Plutôt que de retirer ou de confirmer sans preuve un contenu
narratif invérifiable, la requalification en place préserve l'historique
tout en marquant sa nature (Stronghold first appliqué à la documentation
existante, pas seulement au contenu à écrire).

**Déclencheur de réouverture :** aucun prévu — décision stable.

---

## M-PROC-28 · Distinction taille « cœur » vs « gouvernance associée » — règle stable · v1.9+SDLC-15 · 19/06/2026

**Retenu :** `Claude.md §Analyse` porte désormais une règle stable :
si la taille du « cœur du changement » diffère de la taille totale une
fois la gouvernance associée comptée (fichiers de registre/doc/specs à
mettre à jour en plus du livrable principal), déclarer les deux
explicitement dans la spec plutôt que sous-estimer en ne comptant que
le cœur.

**Raison :** Observé dès SDLC-11 (Skill `/help`, taille XS → S une fois
la gouvernance comptée), laissé en décision `⏳` sans déclencheur pendant
3 sprints (SDLC-12, 13, 14) — `Significant Discovery Alert SD-5` détecté
lors de la première `/retrospective` (SDLC-15). Une pratique déjà
appliquée de fait mais jamais actée se résout en règle explicite plutôt
qu'en `⏳` indéfini.

**Déclencheur de réouverture :** aucun prévu — décision stable.

---

## M-HOOKS-04 · Carve-out anti-auto-verrouillage — garde-fou étape 4a · v1.9+SDLC-18 · 19/06/2026

**Contexte :** revue critique d'un PDR conçu en Claude.ai pour ajouter un garde-fou
mécanique sur l'omission de l'étape 4a (`Claude.md §Démarrage` — création du fichier
spec sprint). Le PDR anticipait un bug de conception sur le matcher `Bash|Edit|Write` :
bloquer toute commande dès que `.claude/sprint-memory.md` référence un spec absent du
disque verrouille la session, car aucune action couverte par le matcher ne peut sortir
de l'état bloqué — y compris le `Write` qui créerait le spec, seule recommandation du
message d'erreur lui-même.

**Retenu :** le garde-fou et son carve-out sont conçus ensemble, pas en deux temps.
`pre-tool-bash.sh` bloque (exit 2) tout `Bash`/`Edit`/`Write` si `SPEC_PATH` (extrait de
`sprint-memory.md`, motif `# Spec : ` recherché n'importe où dans le fichier — pas figé
ligne 2) est non vide et absent du disque, **sauf** si l'outil est `Write`/`Edit` et que
le `file_path` cible exactement `SPEC_PATH` ou un chemin sous `specs/Sprints/` — ce
carve-out est exempté dès la première version, jamais ajouté après coup.

**Écarté :**
- Restreindre le matcher à `Bash` seul pour éviter le problème — aurait annulé la
  couverture Edit/Write que l'élargissement visait précisément à apporter.
- Script de carve-out séparé — un seul `pre-tool-bash.sh` reste plus simple à auditer.

**Incident découvert pendant l'implémentation (Sprint SDLC-18) :** la première version du
carve-out comparait `file_path` (toujours absolu, confirmé empiriquement) à `SPEC_PATH`
(relatif) — comparaison qui ne matchait jamais. Combiné à l'absence totale de carve-out
pour `Bash`, la session s'est retrouvée verrouillée sur Bash/Edit/Write pendant ~40
minutes, débloquée une première fois par suppression manuelle de `sprint-memory.md` par
l'utilisateur hors session Claude Code, puis retombée brièvement dans le même piège lors
de la restauration avant d'être résolue seule via le carve-out corrigé (comparaison en
suffixe absolu). Corrigé avant tout commit — 4 smoke tests (non-régression, positif,
négatif, carve-out) exécutés avec succès sur la version corrigée.

**Limite initialement actée, comblée dans le même sprint :** `Bash` n'avait aucun carve-out
(lecture seule incluse — `git status`/`diff`/`ls`/`cat`), exclusion explicite du PDR
d'origine ("amélioration de confort, pas un correctif"). Confirmée comme `[HOOK_CANDIDATE]`
réel — observée deux fois en conditions réelles cette session, pas hypothétique. Scope
élargi sur validation explicite de l'utilisateur après l'incident → voir `M-HOOKS-06`.

→ Mise à jour 19/06/2026 (même sprint) : limite comblée par `M-HOOKS-06` (allowlist Bash
lecture seule). Cette entrée M-HOOKS-04 reste la trace de l'incident d'origine.

**Impact fichiers :** `.claude/hooks/pre-tool-bash.sh` (+section M-HOOKS-04, v2.0.0→2.0.1),
`.claude/settings.json` (matcher `Bash` → `Bash|Edit|Write`).

**Origine commune avec SDLC_CANDIDATE #1 :** le garde-fou que cette entrée mécanise
(blocage de l'omission de l'étape 4a) répond au même incident que la recommandation
hook `SessionStart` laissée en `[SDLC_CANDIDATE]` dans
`doc/AUDIT-EXTERNE-superpowers-vs-sdlc.md §8` (Sprint SDLC-17) — toutes deux tracent au
pattern `LL-T05` (`doc/LESSONS_LEARNED.md`). M-HOOKS-04 est une mécanisation partielle et
indépendante (blocage réactif sur l'état du disque) ; le hook `SessionStart` resterait une
injection proactive en contexte — les deux approches ne se substituent pas l'une à
l'autre, décision de cumul ou d'arbitrage différée à la session Claude.ai dédiée déjà
prévue pour `LL-T05`.

**Déclencheur de réouverture :** si l'allowlist Bash lecture seule (`[HOOK_CANDIDATE]`
ci-dessus) est activée par `/retrospective` → revoir cette entrée en conséquence.

---

## M-HOOKS-05 · Extraction JSON PreToolUse corrigée (`tool_input`, pas `input`) · v1.9+SDLC-18 · 19/06/2026

**Contexte :** root cause distincte de M-HOOKS-04, antérieure (Sprint SDLC-14,
self-bootstrap). Le script extrayait la commande via
`data.get('input', {}).get('command', '')`, sur la base d'un commentaire non vérifié
(`{"tool":"bash","input":{"command":"..."}}`). Le smoke test existant ne testait qu'une
commande inoffensive (`echo ok`) — incapable de détecter une extraction cassée.

**Retenu :** capture empirique du schéma JSON réel avant toute correction (pas de
confiance en documentation tierce — c'est exactement le mode d'échec ayant produit le
bug initial). Réalisée sans restart de session : (1) instrumentation temporaire du hook
`Bash` déjà actif (ajout d'une ligne de capture, retirée après usage) → confirme
l'enveloppe `{"hook_event_name":"PreToolUse","tool_name":"...","tool_input":{...}}` ;
(2) grep direct du transcript de session (`tool_use` réels `Edit`/`Write`) → confirme le
paramètre `file_path`, toujours en chemin absolu. Extraction corrigée :
`data.get('tool_input', {}).get('command', '')`.

**Constat :** `data.get('input', {})` sur un payload sans clé `input` retourne toujours
`{}` → `$CMD` était vide depuis l'origine du script. Les blocages `[UNIVERSEL]`
(`git push --force`, `rm -rf` sur dossier critique) n'ont **jamais** pu matcher quoi que
ce soit en conditions réelles, depuis leur introduction Sprint SDLC-14, jusqu'à cette
correction.

**Validation :** la commande de test du smoke test non-régression a, par accident,
déclenché le blocage sur une commande Bash légitime de cette même session (le texte de
la commande contenait littéralement le motif testé) — preuve en conditions réelles,
non simulée, que l'extraction corrigée fonctionne.

**Écarté :** auditer l'ensemble des sections `[ACTIVER si…]` commentées du template
`08-hooks-TEMPLATE.md` pour le même défaut — hors scope (sections inactives, aucune
n'est exécutée en l'état) ; sprint Doc séparé si le besoin se confirme.

**Impact fichiers :** `.claude/hooks/pre-tool-bash.sh` (extraction CMD + nouvelles
extractions TOOL/FILE_PATH, en-tête mis à jour avec le schéma réel documenté).

**Déclencheur de réouverture :** aucun prévu — schéma confirmé empiriquement, pas une
hypothèse.

---

## M-HOOKS-06 · Allowlist Bash lecture seule pendant blocage M-HOOKS-04 · v1.9+SDLC-18 · 19/06/2026

**Contexte :** suite directe de l'incident `M-HOOKS-04` (auto-verrouillage réel ~40 minutes,
ce même sprint). `Bash` n'avait aucun carve-out — un bug dans le carve-out Write/Edit a donc
laissé la session sans aucun outil disponible pour diagnostiquer ou corriger quoi que ce soit,
y compris des commandes en lecture pure. Scope initialement exclu par le PDR ("amélioration de
confort, pas un correctif") — réintégré sur validation explicite de l'utilisateur après
l'incident ("élargi le scope... implémente les solutions").

**Retenu :** pendant un blocage M-HOOKS-04, `Bash` est autorisé (le blocage est court-circuité,
mais l'exécution continue vers les blocages `[UNIVERSEL]` plus bas — pas un `exit 0` immédiat)
si la commande matche un préfixe d'une liste fermée (`git status|diff|log|show`, `ls`, `cat`,
`pwd`, `find`, `grep`, `head`, `tail`, `wc`, `bash -n`) **et** ne contient aucun caractère de
chaînage/redirection/substitution (`;`, `&`, `|`, backtick, `$(`, `>`). Une commande qui matche
le préfixe mais contient un de ces caractères reste bloquée (anti-évasion — testé explicitement :
`ls; rm -rf <dossier>` reste bloqué malgré le préfixe `ls` autorisé).

**Écarté :**
- Allowlist par expression libre (toute commande ne contenant pas tel mot-clé interdit) — risque
  d'angle mort bien plus large qu'une liste fermée de préfixes lecture-seule.
- Désactiver M-HOOKS-04 entièrement en cas de doute — annulerait le garde-fou que ce sprint
  visait à renforcer, pas seulement son carve-out.

**Raison :** un carve-out d'écriture (Write/Edit) peut avoir un bug (cf. M-HOOKS-04) sans
qu'aucune commande de diagnostic en lecture ne soit disponible pour le constater depuis la
session elle-même. Cette allowlist est une couche de défense indépendante du carve-out
principal — elle réduit le rayon d'impact de tout bug futur dans ce fichier, pas seulement
celui déjà corrigé.

**Impact fichiers :** `.claude/hooks/pre-tool-bash.sh` (v2.0.1 → 2.1.0).

**Déclencheur de réouverture :** si un cas réel nécessite d'élargir la liste de préfixes
autorisés → documenter le préfixe ajouté et la raison dans une mise à jour de cette entrée.

---

## M-PROC-30 · Test d'un hook bloquant — isolation obligatoire · v1.9+SDLC-18 · 19/06/2026

**Contexte :** même incident (`M-HOOKS-04`). Le test des scénarios "doit bloquer" (négatif,
carve-out) a été réalisé en manipulant `.claude/sprint-memory.md` **réel** — le même fichier
qui gate la session courante. Un bug dans le mécanisme testé a donc immédiatement bloqué la
session elle-même, sans aucune couche d'isolation entre le test et l'environnement réel.

**Retenu :** `08-hooks-TEMPLATE.md` documente désormais une règle explicite (`§Test d'un hook
bloquant — isolation obligatoire`) : tout test d'un comportement bloquant d'un hook
`PreToolUse` s'exécute dans un répertoire temporaire isolé (copie du hook + fixtures), jamais
contre l'état réel de la session.

**Découverte additionnelle pendant la correction :** un `cd` exécuté sans sous-shell persiste
entre les appels d'outil de la session — le hook réel (gating ces appels) peut alors résoudre
ses chemins relatifs contre ce mauvais répertoire et déclencher un faux blocage sur la session
réelle en lisant les fixtures de test comme si elles étaient l'état réel. Reproduit une fois en
conditions réelles pendant ce sprint, débloqué via le carve-out désormais fonctionnel (pas
d'intervention humaine nécessaire cette fois). Le template documente ce piège et impose
`( cd ... && ... )` (sous-shell) plutôt que `cd` nu pour tout test d'isolation.

**Limite non comblée, actée explicitement :** la résolution de chemin relatif dans
`pre-tool-bash.sh` (`.claude/sprint-memory.md`, `$SPEC_PATH`) reste sensible au cwd du
processus. Une résolution ancrée sur un chemin absolu fixe serait plus robuste mais n'a pas été
implémentée ce sprint (changement plus large, hors des 3 solutions validées par l'utilisateur) —
`[HOOK_CANDIDATE]` à consigner pour `/retrospective` si l'angle mort se reproduit hors contexte
de test.

**Écarté :** ne documenter la règle que dans `Claude.md` (spécifique à ce projet) plutôt que
dans `08-hooks-TEMPLATE.md` — écarté car la règle concerne tout hook `PreToolUse` bloquant,
pertinente pour tout projet cible du modèle SDLC, pas seulement celui-ci.

**Impact fichiers :** `08-hooks-TEMPLATE.md` (+§Test d'un hook bloquant, ~25 lignes).

**Déclencheur de réouverture :** si la résolution de chemin absolu est implémentée → mettre à
jour cette entrée et `M-HOOKS-04`/`M-HOOKS-05`.

---

## M-PROC-31 · Tables de rationalisation par HALT — import recalibré Superpowers · v1.9+SDLC-19 · 19/06/2026

**Contexte :** audit externe `obra/superpowers` (Sprint SDLC-17, `doc/AUDIT-EXTERNE-superpowers-vs-sdlc.md §6/§8`) recommandait d'importer le pattern "table de rationalisation" (`test-driven-development/SKILL.md:256-286`) — pour chaque règle non-négociable, lister les formulations internes typiques de contournement avec leur réfutation.

**Retenu :** `01-Claude-md-TEMPLATE.md` porte désormais, sous chaque HALT (HALT-DEP, HALT-3X, HALT-ARCH, HALT-SCOPE, HALT-TIMEOUT), 2 paires `**Pensée :** "…" → **Réalité :** …` en langage gouvernance générique — pas de vocabulaire test/code spécifique (contrairement à la source Superpowers, écrite pour un contexte TDD). 1 paire supplémentaire sous la règle absolue "4a/4b/4c/4d", sourcée sur l'incident réel `M-HOOKS-04` plutôt qu'adaptée — seule paire de ce sprint ancrée sur un fait documenté du repo.

**Écarté :**
- Traduction littérale des exemples Superpowers (TDD, debugging) — jargon spécifique au code qui se propagerait vers des projets doc-only via `/sdlc-sync`.
- Sourcer les 5 HALT sur des incidents réels documentés — un seul (4a/4b/4c/4d) en a un à ce jour ; le reste reste assumé comme générique/adapté, pas présenté comme un fait vécu.

**Raison :** les règles absolues et HALT étaient énoncées comme conditions logiques sans anticiper les formulations par lesquelles un agent pourrait s'en convaincre. Le format pensée→réalité rend visible le mécanisme de rationalisation lui-même, pas seulement la règle.

**Impact fichiers :** `01-Claude-md-TEMPLATE.md` (+11 paires, ~50 lignes).

**Déclencheur de réouverture :** si un nouvel incident réel survient sur un HALT actuellement non sourcé → remplacer la paire générique correspondante par une paire sourcée, sur le modèle de la paire 4a/4b/4c/4d.

→ Mise à jour 20/06/2026 (Sprint SDLC-20) : cette décision a fait l'objet de 2 revues critiques supplémentaires après sa mise en œuvre — voir `M-PROC-35` pour le détail des 3 passages et l'état final retenu (étiquette `[HYPOTHÈSE]`, contenu des paires inchangé).

---

## M-PROC-32 · Fusion clause anti-complaisance + renvoi croisé §Rôle/§Test · v1.9+SDLC-19 · 19/06/2026

**Contexte :** audit Superpowers recommandait (`SDLC_CANDIDATE` §8, source `verification-before-completion/SKILL.md:52-61`) de fusionner une liste de formulations interdites dans la clause anti-complaisance existante. Vérification a montré que 3 des 4 formulations proposées ("devrait passer", "probablement", "en principe") existaient déjà, dispersées entre `§Rôle` (citabilité) et `§Test` (anti-complaisance) — sans lien explicite entre les deux. Seule "ça a l'air bon" était un ajout net.

**Retenu :** ajout de "ça a l'air bon" à la liste existante de `§Test` + 1 phrase de renvoi croisé dans chaque sens (`§Rôle` → `§Test`, `§Test` → `§Rôle`) plutôt qu'une fusion qui aurait dupliqué du contenu déjà présent.

**Écarté :** fusionner intégralement les deux sections en une seule — écarté, `§Rôle` couvre la citabilité de toute affirmation factuelle (périmètre large), `§Test` couvre spécifiquement les résultats de test (périmètre étroit) ; les deux ont une raison d'être distincte, seul le lien manquait.

**Raison :** le principe anti-complaisance existait déjà à deux endroits cohérents entre eux — le gap réel était l'absence de lien, pas l'absence de contenu. Recalibrage à la baisse du candidat d'audit (qui sur-estimait le delta en proposant une liste de 4 alors que 3/4 existaient).

**Impact fichiers :** `01-Claude-md-TEMPLATE.md §Rôle` (+1 phrase), `§Test` (+"ça a l'air bon" +1 phrase).

**Déclencheur de réouverture :** aucun prévu — décision stable.

---

## M-PROC-33 · Sélection de modèle pour sous-agent délégué · v1.9+SDLC-19 · 19/06/2026

**Contexte :** audit Superpowers (`IDÉE NOUVELLE`, source `subagent-driven-development/SKILL.md:99-130`) — `§Tokens` avait déjà un critère de délégation basé sur le volume (> 5 fichiers ou fichier > 10K tokens) mais rien sur le choix du modèle du sous-agent dispatché.

**Retenu :** règle distincte du critère de volume — basée sur la nature de la tâche déléguée : tâche mécanique (lecture/extraction/synthèse factuelle) → modèle réduit ; tâche de jugement (analyse comparative, arbitrage, rédaction de recommandation) → modèle standard ; jamais déléguer à un modèle plus capable que celui de la session courante sans aval explicite.

**Écarté :** lier le choix de modèle uniquement au volume déjà mesuré (fichiers/tokens) — écarté car un volume faible peut porter un jugement complexe (ex: arbitrer entre 2 fichiers contradictoires) et un volume élevé peut être une lecture purement mécanique (ex: lister 20 fichiers de logs) — la nature de la tâche est un axe orthogonal au volume, pas un raffinement du même axe.

**Raison :** confirmé faisable techniquement (`Task`/`Agent` du framework Claude Code expose un paramètre `model` natif). Le critère "jamais plus capable que la session sans aval" évite qu'une délégation silencieuse engage un coût ou une capacité supérieure à ce que l'utilisateur a choisi pour la session.

**Impact fichiers :** `01-Claude-md-TEMPLATE.md §Tokens` (+4 lignes).

**Déclencheur de réouverture :** si un cas réel de mauvaise sélection de modèle (sous- ou sur-dimensionné) est observé → affiner les deux catégories avec des exemples concrets sourcés.

---

## M-PROC-34 · Taxonomie "Revue" dans STANDARDS §Types de sprint · v1.9+SDLC-19 · 19/06/2026

**Contexte :** `Claude.md §Classifier le travail` utilise "Revue" comme type de sprint (flux : Lecture → Recommandations → `/wrap-up`) depuis plusieurs sprints (SDLC-16, SDLC-17 notamment), mais `02-STANDARDS-TEMPLATE.md §Types de sprint` ne l'a jamais listé — écart entre les deux fichiers de référence.

**Retenu :** ajout d'une ligne "Revue" dans la table `§Types de sprint`, avec une note de différenciation explicite vs "Spike" (déjà présent) : une Revue audite un livrable existant sans le modifier dans le même sprint ; un Spike investigue une question ouverte sans livrable préexistant sur le sujet.

**Écarté :** renommer "Spike" en fusionnant les deux types — écarté, les flux et les outputs attendus sont différents (Revue produit des recommandations étiquetées sur un objet déjà là ; Spike produit une décision sur une question encore ouverte).

**Raison :** un type de sprint utilisé dans `Claude.md` mais absent de `STANDARDS.md` est un gap de cohérence interne au modèle — exactement le type d'écart que ce sprint visait à corriger par ailleurs (cf. `M-PROC-31` à `33`).

**Impact fichiers :** `02-STANDARDS-TEMPLATE.md §Types de sprint` (+1 ligne, +1 note).

**Déclencheur de réouverture :** aucun prévu — décision stable.

---

## M-PROC-35 · Tables de rationalisation HALT — 3e passage, étiquette `[HYPOTHÈSE]` retenue · v1.9+SDLC-20 · 20/06/2026

**Contexte :** suite directe de `M-PROC-31`. Après la mise en œuvre initiale (Sprint SDLC-19 :
2 paires par HALT, sans étiquette de provenance), une 1ère revue critique a proposé de vider
les 4 HALT sans incident réel en squelette, au nom d'`INV-4` (`00-CONTEXT.md`). Cette révision a
été rédigée (spec `sprint-SDLC-20-halt-squelettes.md`) mais **jamais committée** — l'utilisateur
a mis le sprint en pause avant exécution pour une 2e revue.

**Écarté (1er passage de révision — squelette vide) :** citait `INV-4` à tort. `INV-4` garantit
qu'une observation terrain a un chemin vers une règle ("incident → LESSONS_LEARNED →
retrospective → règle") — elle n'interdit pas qu'une règle naisse d'un apport externe sans
incident préalable. Incohérent avec le fait que le bloc HALT lui-même (les 5 conditions)
provient de l'import BMad (Sprint SDLC-07) sans incident préalable. Coût réel sous-estimé : 4/5
HALT se retrouveraient sans aucune garde anti-rationalisation le temps qu'un incident survienne
— possiblement jamais pour certains (ex : HALT-TIMEOUT, condition mécanique peu sujette à
rationalisation complexe).

**Retenu (3e passage, ce sprint) :** ni squelette vide, ni contenu silencieusement présenté
comme équivalent à du vécu (état SDLC-19 d'origine). Les 2 paires existantes par HALT sont
conservées telles quelles (contenu inchangé) mais précédées d'une étiquette unique
`[HYPOTHÈSE — non confirmée sur ce projet, adaptée de Superpowers]`. La table sous la règle
absolue "4a/4b/4c/4d" reste la seule sans étiquette, sourcée sur l'incident réel `M-HOOKS-04`.
L'étiquette se retire et se remplace par un renvoi `M-XXX` si un incident réel vient un jour
confirmer ou corriger une paire donnée — sur le modèle de la table 4a/4b/4c/4d.

**Écarté :**
- Squelette vide — cf. ci-dessus, argument INV-4 invalide et coût de couverture sous-estimé.
- Contenu complet sans étiquette (état SDLC-19 d'origine) — recalibré : risque de donner une
  fausse impression de couverture, du contenu générique jamais confronté à la réalité de ce
  projet présenté avec la même autorité qu'une règle sourcée sur incident.

**Raison :** l'étiquette rend visible la nature provisoire du contenu (donc lisible comme tel
par un lecteur attentif) sans sacrifier la valeur immédiate du pattern (anticiper les
rationalisations typiques) pour les HALT sans incident documenté à ce jour.

**Impact fichiers :** `01-Claude-md-TEMPLATE.md` (+5 lignes d'étiquette, contenu des paires
inchangé), `M-PROC-31` (amendée avec renvoi).

**Déclencheur de réouverture :** si un incident réel survient sur un HALT actuellement étiqueté
`[HYPOTHÈSE]` → remplacer l'étiquette par un renvoi `M-XXX` sourcé, sur le modèle de la table
4a/4b/4c/4d (cf. `M-PROC-31`).

---

## M-HOOKS-07 · Confinement natif sandbox OS (bubblewrap/Seatbelt) en complément du hook · v1.9+SDLC-21 · 21/06/2026

**Contexte :** Besoin de confiner Claude Code à un répertoire unique (`/sandbox`) et de
réduire la friction de validation à l'intérieur de ce périmètre, plutôt que des
confirmations au cas par cas. `pre-tool-bash.sh` (M-HOOKS-02) est un filtre par
pattern-matching sur la commande — contournable par construction et sans portée sur
les outils natifs `Read`/`Edit`/`Write`. 9 tests empiriques exécutés en conditions
réelles (Ubuntu 24.04, Claude Code sandboxé) avant toute décision, conformément à
`M-PROC-30` (isolation des tests — ici appliquée à un mécanisme natif, pas au hook
custom).

**Retenu :** Deux couches complémentaires, aucune ne remplaçant l'autre :

- **`sandbox.*`** (niveau OS, bubblewrap/Seatbelt) — confine les processus enfants
  de `Bash` uniquement. `filesystem.allowWrite` pour le périmètre d'écriture,
  `filesystem.denyRead` pour les chemins sensibles explicitement exclus
  (`~/.ssh`, `~/.aws`), `network.allowedDomains` pour le réseau.
- **`permissions.defaultMode: dontAsk` + `permissions.allow` scopé** — couvre
  `Read`/`Edit`/`Write`/`Bash`, qui ne passent pas par le sandbox OS. `dontAsk`
  auto-refuse tout ce qui n'est pas explicitement listé, sans ouvrir de prompt
  contournable — validé empiriquement (Test 4, Test 5) et confirmé sur un outil
  non testé initialement (`AskUserQuestion`, bloqué identiquement en session réelle).
- **`failIfUnavailable: true`** + **`allowUnsandboxedCommands: false`** —
  fail-closed : pas de démarrage en dégradé si bubblewrap est absent, pas
  d'échappatoire `dangerouslyDisableSandbox`. Même principe que `M-HOOKS-04`
  (pas de dégradation silencieuse d'un garde-fou).
- Chemins en dur dans la config — `${VAR}` non confirmé comme supporté pour les
  chemins `sandbox.*`/`permissions.*` (seulement pour `.mcp.json` et certaines
  valeurs de `hooks`/`env`).

**Écarté :**
- `pre-tool-bash.sh` seul comme mécanisme de confinement — pattern-matching sur
  la commande, bypassable, et structurellement aveugle aux outils natifs
  `Read`/`Edit`/`Write` (n'interceptent jamais `Bash`).
- `permissions.deny` large (`Read(//**)`) combiné à un `allow` scopé sur le
  périmètre — une règle `deny` ne porte pas d'exceptions allowlist (priorité
  deny > ask > allow indépendante de la spécificité), le `deny` large aurait
  avalé l'`allow` plus étroit. Piège identifié avant tout test, pas découvert
  en échouant en production.
- `defaultMode: default` (comportement du draft initial) — hors périmètre,
  les opérations natives passent par un prompt humain contournable plutôt
  qu'un refus net, contraire à l'objectif de confinement strict.

**Raison :** Les deux couches répondent à des outils disjoints (sandbox = `Bash`
et sous-processus · permissions = `Read`/`Edit`/`Write`/`Bash`), confirmé par
la doc officielle et par les Tests 1/4/5. Aucune des deux seules ne couvre le
besoin "interdire toute opération hors `/sandbox`" — seule la combinaison le
fait, et seulement avec `dontAsk` plutôt que `default`.

**Prérequis machine — bug bwrap rencontré et résolu pendant le test :**
`bwrap: loopback: Failed RTM_NEWADDR: Operation not permitted` sur Ubuntu
24.04+/25.10 — `kernel.apparmor_restrict_unprivileged_userns` bloque la
configuration du network namespace par bubblewrap. Corrigé par un profil
AppArmor dédié (`/etc/apparmor.d/bwrap` + `systemctl reload apparmor`) :
bug connu, pas une erreur de configuration Claude Code. Vérification à faire
*avant* tout test en se plaçant hors session Claude Code (le `!` du CLI
repasse par le sandbox — confirmé empiriquement, pas une voie de contournement
pour le diagnostic).

**Comportement observé non documenté officiellement :** sous `dontAsk`, un
domaine réseau non listé dans `allowedDomains` est bloqué net (`403`,
`X-Proxy-Error: blocked-by-allowlist`) — pas de prompt, contrairement au
comportement par défaut documenté pour le mode `default`.

**9 tests exécutés (résumé, détail dans la conversation Claude.ai source) :**
dépendances OK · Bash write hors périmètre bloqué (`Read-only file system`)
· Bash read libre par défaut, `denyRead` confirmé nécessaire · lecture
`~/.ssh` masquée (liste vide, pas de refus explicite) · Write natif hors
périmètre bloqué (`dontAsk` explicite, message verbatim) · Read natif hors
périmètre bloqué (comportemental, 2 fichiers) · Bash auto-allow fonctionne
sous `dontAsk` · domaine réseau non listé bloqué net · auto-protection de
`settings.json` confirmée même dans le périmètre autorisé.

**Limite non tranchée :** le masquage de `~/.ssh` (liste vide plutôt que
`Permission denied`) n'a pas été distingué entre comportement `denyRead`
volontaire et effet de bord du montage bwrap — sans conséquence sur la
décision, à noter si un usage futur en dépend (ex : code qui teste
`os.path.exists()` avant lecture obtiendrait un faux négatif silencieux).

**Impact fichiers :** `08-hooks-TEMPLATE.md` (nouvelle `§4 Confinement natif —
sandbox OS`) · `06-PDR-bootstrap.md` (prérequis machine + Groupe 6 étendu +
critère d'acceptation) · `07-DECISIONS-SDLC.md` (tableau de compatibilité
rattrapé — 10 lignes manquantes M-HOOKS-06/M-PROC-27→35 réintégrées dans le
même commit, traitement mécanique pas une décision distincte).

**Déclencheur de réouverture :** si l'interaction `dontAsk` × `autoAllowBashIfSandboxed`
se comporte différemment dans un cas non testé ici, ou si le fix AppArmor
s'avère insuffisant sur une distribution/version kernel non couverte par ce test.

---

## M-PROC-36 · Instrumentation conso token réelle — `sdlc-token-usage.sh` · v1.9+SDLC-22 · 21/06/2026

**Contexte :** le Sprint Lean précédent (bilan + avis Oracle) avait identifié des
pistes d'allègement token sans mesure réelle pour les arbitrer — seulement des
proxys statiques (`wc -w` sur les fichiers gouvernance). Les transcripts JSONL
Claude Code portent déjà un bloc `usage` horodaté par message assistant ;
`sprint-memory.md` horodate déjà chaque étape — la corrélation des deux
existait en germe sans être exploitée.

**Retenu :** script bash autonome `sdlc-token-usage.sh` (bash+jq, cohérent avec
`sdlc-project-check.sh`) lisant les transcripts JSONL locaux
(`~/.claude/projects/<slug-cwd>/*.jsonl`) et calculant les totaux bruts
`input_tokens`/`output_tokens`/`cache_read_input_tokens`/`cache_creation_input_tokens`.
Si `.claude/sprint-memory.md` est présent et contient des entrées horodatées
`[HH:MM] TYPE`, bucketisation des totaux par étape (intervalle entre deux
horodatages consécutifs). En parallèle, `03-wrap-up-SKILL-TEMPLATE.md §0c`
exécute désormais `git diff --stat HEAD` / `git status` directement en bash au
lieu de demander à l'utilisateur de coller le résultat — avec fallback explicite
sur l'ancien comportement si la commande échoue (repo non-git, environnement
restreint). `09-retrospective-SKILL-TEMPLATE.md` reçoit une nouvelle `§Étape 7
— Métriques tokens (optionnel)` : baseline statique M1 (`wc -w Claude.md
STANDARDS.md`) / M2 (`wc -w .claude/skills/wrap-up/SKILL.md`), plus appel
optionnel du script pour la mesure dynamique.

**Écarté :**
- Dashboard temps réel ou par agent — disproportionné pour la fréquence de
  sprint actuelle (pas un usage continu multi-agents), rejeté en avis Oracle.
- Instrumentation via hook `PreToolUse` — le payload hook ne porte pas le bloc
  `usage`, seul le transcript JSONL le contient.
- Nouveau skill `/token-audit` dédié — sur-ingénierie pour un script appelé
  toutes les ~5 sprints (même raisonnement que `M-PROC-24` pour
  `sdlc-project-check.sh`).
- Bloquer `/retrospective` ou `/wrap-up` sur l'absence/échec du script ou de
  `git` — dégradation systématique vers l'ancien comportement à la place
  (même principe que le fallback CLAUDE_PROJECT, `M-PROC-22`).

**Raison :** la mesure réelle remplace un proxy statique par une donnée
directement actionnable pour juger l'effet des pistes d'allègement déjà
identifiées, sans complexifier l'outillage au-delà du besoin (script, pas
skill ; lecture seule, pas de nouvel état à maintenir).

**Bug rencontré et corrigé pendant l'implémentation :** `jq fromdateiso8601`
rejette tous les timestamps de transcript (`"2026-06-21T13:49:42.450Z"`) car le
format ne tolère pas les fractions de seconde — corrigé par
`sub("\\.[0-9]+Z$"; "Z")` avant parsing. Détail et commande de reproduction en
`doc/DIAGNOSTIC_CMDS.md`.

**Limite connue acceptée :** la bucketisation par étape compare des `HH:MM`
sans date — suppose un sprint mono-journée locale (cas réel actuel). Le
chemin `~/.claude/projects/` n'est pas garanti stable inter-OS (même nature de
contrainte que `M-ENV-01`), rendu configurable via `CLAUDE_PROJECTS_DIR`.

**Impact fichiers :** `sdlc-token-usage.sh` (nouveau) · `03-wrap-up-SKILL-TEMPLATE.md`
v1.4 (§0c) + `.claude/skills/wrap-up/SKILL.md` (synchronisé) · `09-retrospective-SKILL-TEMPLATE.md`
v1.7 (§Étape 7) + `.claude/skills/retrospective/SKILL.md` (synchronisé) ·
`doc/DIAGNOSTIC_CMDS.md` (+1 symptôme).

**Déclencheur de réouverture :** si un sprint s'étale sur plusieurs jours
calendaires (la bucketisation `HH:MM` deviendrait ambiguë), ou si le schéma
`usage` du transcript JSONL change de structure côté Claude Code.
