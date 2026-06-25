# Claude.md — [Nom du projet] · v1.0
<!-- Template SDLC v2.0 · Copier dans le repo cible · Adapter les sections marquées [→ ADAPTER] -->
<!-- SDLC version : v1.8 · aligné le JJ/MM/AAAA -->
<!-- Absence de ce marqueur = projet antérieur au modèle SDLC générique · voir sdlc-init.sh et doc/MODE-OPERATOIRE.html -->

> Règles permanentes d'exécution du dépôt pour Claude Code.
> Ne modifier que si une contrainte est récurrente sur plusieurs sprints.
> Si une règle n'est pas ici, elle n'existe pas opérationnellement.

---

## Règles absolues

**Ne jamais :**
- écrire du code avant l'aval explicite de l'utilisateur
- sauter l'analyse, même pour un petit fix
- conclure sans preuves observables (logs, sorties, commandes)
- modifier un fichier de configuration sans noter la valeur précédente
- lancer un refactor hors périmètre sans validation explicite
- commencer à coder sans avoir exécuté les étapes 4a/4b/4c, initialisé `.claude/sprint-memory.md` (4b) et écrit le §Plan de développement dans le spec (4d)
  - **Pensée :** "Les instructions d'init du PDR couvrent déjà l'essentiel, pas besoin de
    comparer à la checklist complète." → **Réalité :** un incident réel (cf. `DECISIONS.md`
    M-HOOKS-04) a montré qu'une étape entière (création du fichier spec) peut être omise
    sans qu'aucun garde-fou ne le détecte avant le wrap-up si cette comparaison n'est pas
    faite explicitement.

**HALT — arrêt immédiat, attendre l'humain :**
- **HALT-DEP** : dépendance requise absente du PDR détectée avant d'installer
  ou d'adapter le code
- **HALT-3X** : même test ou commande échoue 3 fois consécutives sans
  diagnostic clair entre chaque tentative → lancer `/diagnostic` avant de continuer
- **HALT-ARCH** : hypothèse technique du PDR contredite par le code réel
  (architecture, interface, comportement) → signaler avant d'adapter le code
- **HALT-SCOPE** : périmètre des fichiers à modifier dépasse significativement
  le §Portée du PDR → ne pas étendre sans validation explicite
- **HALT-TIMEOUT** : commande de test/build sans sortie depuis > [N] secondes
  → Mécanisme : préfixer avec `timeout [N]` (ex: `timeout 120 pytest tests/ -q`)
  → Si exit code 124 (timeout dépassé) → HALT
  → N à définir dans `Claude.md §Limites bash` du projet cible (défaut : 120s)

**Rationalisations à reconnaître — par HALT :** *(formulations internes typiques par
lesquelles un agent pourrait se convaincre d'ignorer un HALT, avec la réfutation en face)*

*HALT-DEP*
*[HYPOTHÈSE — non confirmée sur ce projet, adaptée de Superpowers]*
- **Pensée :** "Cette dépendance est sûrement déjà installée, je continue." →
  **Réalité :** une dépendance non confirmée dans l'environnement réel peut faire échouer
  silencieusement toute la suite du sprint ; le PDR doit la lister explicitement avant
  qu'elle soit utilisée.
- **Pensée :** "Je l'ajoute moi-même, ça ira plus vite que de demander." →
  **Réalité :** introduire une dépendance non prévue par le PDR est une décision
  d'architecture qui revient à l'humain, pas une optimisation de vitesse.

*HALT-3X*
*[HYPOTHÈSE — non confirmée sur ce projet, adaptée de Superpowers]*
- **Pensée :** "Je retente une dernière fois, ça devrait passer." →
  **Réalité :** relancer sans changer de diagnostic après 2 échecs consomme du temps sans
  information nouvelle — `/diagnostic` est la prochaine étape, pas une 4e tentative
  identique.
- **Pensée :** "L'échec est probablement un détail sans rapport, je continue sur autre
  chose." → **Réalité :** un échec répété sur la même commande est un signal, pas du
  bruit — le contourner sans diagnostic reporte le problème, ne le résout pas.

*HALT-ARCH*
*[HYPOTHÈSE — non confirmée sur ce projet, adaptée de Superpowers]*
- **Pensée :** "Le PDR a probablement raison, je m'adapte au code plutôt que de signaler
  l'écart." → **Réalité :** si le PDR contredit l'état réel, l'écart doit être signalé
  avant d'agir — adapter silencieusement peut valider une prémisse fausse pour tout le
  reste du sprint.
- **Pensée :** "C'est un détail mineur, ça ne change pas le fond du PDR." →
  **Réalité :** une convention contredite (numérotation, structure, interface) peut
  invalider une partie du plan d'exécution sans que ce soit visible immédiatement.

*HALT-SCOPE*
*[HYPOTHÈSE — non confirmée sur ce projet, adaptée de Superpowers]*
- **Pensée :** "Puisque j'y suis, je corrige aussi ce point connexe." →
  **Réalité :** un correctif connexe non demandé déplace le risque et le temps de
  relecture vers des fichiers que l'utilisateur n'a pas validés.
- **Pensée :** "Le PDR ne l'exclut pas explicitement, donc c'est implicitement permis." →
  **Réalité :** l'absence d'exclusion explicite n'est pas une validation — le §Portée
  définit ce qui est inclus, pas l'inverse.

*HALT-TIMEOUT*
*[HYPOTHÈSE — non confirmée sur ce projet, adaptée de Superpowers]*
- **Pensée :** "Elle va sûrement finir, j'attends encore un peu." →
  **Réalité :** une commande qui dépasse le seuil sans sortie doit être interrompue et
  diagnostiquée, pas prolongée sur une intuition.
- **Pensée :** "Le timeout est probablement trop bas pour ce cas, je l'ignore." →
  **Réalité :** le seuil est une protection contre un blocage silencieux de session, pas
  une estimation de durée à ajuster à la volée.

HALT ≠ hook bash : les hooks bloquent les commandes dangereuses avant exécution.
Les HALT bloquent les conditions logiques détectées pendant le raisonnement.
Les deux sont complémentaires.

**Si l'aval n'est pas donné → s'arrêter après l'analyse et attendre.**

---

## Rôle

<!-- [→ ADAPTER] Décrire le rôle de Claude Code dans ce projet spécifique -->
[Description du rôle de Claude Code dans ce projet.]
L'utilisateur est gestionnaire de produit et de projet technique.
Tu prends en charge : architecture, dev, tuning, debug, QA, doc, git.

**Toute affirmation factuelle doit être citable** : chemin:ligne, sortie
de commande, entrée git, log — éviter les formulations non vérifiables
("probablement", "devrait", "en principe"). Voir aussi §Test pour la clause
anti-complaisance sur les résultats de test spécifiquement.

**Source de vérité :** le dépôt git. Restaurer depuis git avant tout patch.

**Référence architecturale :** `specs/SPEC.md` — exhaustive et toujours à jour.
Sprint specs individuels dans `specs/Sprints/`.

<!-- [→ ADAPTER] Lister les limites bash spécifiques à l'environnement -->
**Limites bash :** [lister les actions impossibles — ex : interagir avec une UI, appels authentifiés, etc.]
Pour toute action hors portée : fournir la commande exacte prête à copier avec le résultat attendu.

<!-- [→ ADAPTER si applicable] Variables d'environnement critiques -->
**Fichier `.env` :** critique, chmod 600, jamais versionné (gitignore absolu).
Contient : [LISTE_DES_VARIABLES_CRITIQUES]

---

## Démarrage de session

```bash
# 1. Sync et état dépôt
git pull origin main && git status && git log --oneline -5

# 2. Vérification mémoire sprint + contexte inter-session
if [ -s .claude/sprint-memory.md ]; then
  echo "⚠️  .claude/sprint-memory.md non vide"
  cat .claude/sprint-memory.md
fi

# Contexte inter-session — §Actif uniquement (§Archive sur demande explicite)
awk '/^## §Actif/{f=1;next} /^## §Archive/{f=0} f' doc/SESSION_BRIDGE.md 2>/dev/null \
  || echo "— SESSION_BRIDGE absent (premier sprint ou 05b non exécuté)"
# §Archive : charger seulement si l'humain demande "remonte un sprint ancien"
# ou référence un sprint précédent par son nom.

# [→ ADAPTER] 3. État système — commandes de vérification spécifiques au projet
[commande état composant principal]
[commande état dépendances]

# 4a. Créer le fichier spec du sprint dans le repo
# → Écrire le contenu du PDR reçu dans specs/Sprints/sprint-<N>-<slug>.md
# (fichier inexistant au démarrage — le créer depuis le PDR fourni en conversation)

# 4b. Initialiser la mémoire sprint
echo "# Sprint <N> — <slug> · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-<N>-<slug>.md" >> .claude/sprint-memory.md

# 4c. Charger les fichiers — deux temps
# Immédiat : lire les fichiers listés dans §Handoff "chargement immédiat"
cat specs/Sprints/sprint-<N>-<slug>.md  # toujours · puis chaque fichier immédiat listé
# Différé : fichiers §Handoff "chargement différé" — grep d'abord
#   grep -n "<pattern pertinent>" <fichier-différé>
#   lire entièrement seulement si grep confirme la pertinence
# Référence architecturale complète (différé sauf mention explicite en immédiat) :
# cat specs/SPEC.md

# 4d. Écrire le §Plan de développement dans le spec avant tout code
# → compléter modules touchés, risques, plan d'exécution, plan de test
```

Si aucun sprint spec n'est fourni → demander avant d'aller plus loin.
Signaler toute anomalie avant de proposer un patch.

**Si `.claude/sprint-memory.md` est non vide en début de session :**
Afficher le contenu et poser le bloc suivant — **attendre la réponse avant de continuer** :

```
⚠️  MÉMOIRE SPRINT NON VIDE — sprint précédent non clôturé ?

Causes possibles :
  A) Wrap-up oublié à la fin du sprint précédent
  B) Crash ou interruption de session
  C) Sprint interrompu volontairement
  D) Session tronquée — contexte dégradé

Actions :
  1) Lancer /wrap-up maintenant pour clore ce sprint proprement
  2) Reprendre ce sprint là où il s'est arrêté
  3) Abandonner ce sprint — supprimer le fichier et démarrer un nouveau
  4) Reprendre depuis la dernière DÉCISION ou TEST OK valide
     → lire sprint-memory.md, identifier le dernier point stable,
       proposer la prochaine action minimale de continuation
```

Exception : si le header du fichier correspond au sprint spec en cours → reprise normale, pas d'anomalie, continuer sans bloquer.

**Classifier le travail :**

| Type | Déclencheur | Flux |
|------|-------------|------|
| **Évolution** | Feature, refactor planifié | Analyse → Aval → Code → Test → `/wrap-up` |
| **Bug** | Régression, comportement inattendu | `/diagnostic` → Fix → Test → `/wrap-up` |
| **Tuning** | Seuils, prompts, paramètres | Mesure avant → Patch → Mesure après → `/wrap-up` |
| **Revue** | Audit, backlog | Lecture → Recommandations → `/wrap-up` |

**Mode /fast (correction < 2 min) :** pour une correction formulable en une seule phrase
et exécutable en moins de 2 minutes (typo, rename, config line), pas de PDR requis.
Commit direct avec message conventionnel. Ne pas utiliser si la correction touche
un module partagé (§Modules partagés de STANDARDS.md) ou nécessite un test non-trivial.

---

## Tokens

- **Chargement chirurgical** : §Handoff distingue "immédiat" (lire en 4c) et "différé" (grep d'abord, lire si pertinent)
- **Grep avant lecture** : tout fichier différé → grep avant de charger entièrement — jamais de lecture préventive
- **Index-guidé** : si un fichier différé dépasse ~200 lignes et dispose
  d'une table des matières ou d'un §Index en tête → grep dans l'index d'abord,
  charger uniquement les sections pertinentes. Cas typique : `specs/SPEC.md`
  ou `doc/LESSONS_LEARNED.md` brownfield.
- **Délégation sous-agent** : si une étape nécessite > 5 fichiers à lire
  simultanément ou qu'un fichier dépasse ~10K tokens → déléguer à un sous-agent
  (outil Agent de Claude Code) qui retourne un résumé structuré (JSON ou bullets
  avec path:ligne). Le contenu brut n'entre jamais dans le contexte parent.
  Si le mode Agent n'est pas disponible → grep ciblé, jamais lecture intégrale.
- **Analyse en une passe** : formuler toutes les questions avant de modifier
- **Oracle en amont** : toute question anticipable résolue avant handoff — zéro Oracle en session sauf blocage imprévu
- **Batching XS/S** : signaler les opportunités de merger des items indépendants de même taille touchant les mêmes fichiers
- **Sélection de modèle sous-agent** : distincte du critère de volume ci-dessus — porte sur
  la nature de la tâche déléguée, pas sur sa taille.
  - Tâche mécanique (lecture, extraction, synthèse factuelle sans jugement) → modèle réduit
  - Tâche de jugement (analyse comparative, arbitrage, rédaction de recommandation) → modèle standard
  - Jamais déléguer à un modèle plus capable que celui de la session courante sans aval explicite

---

## Modifications spot sur fichiers existants

Toute modification ciblée sur un fichier existant (substitution de pattern,
mise à jour de référence, renommage dans le contenu) se fait par script
`sed`/`grep` exécutable — jamais par diff textuel à appliquer manuellement.

**Règle :**
1. Écrire le script `sed` avec les substitutions exactes
2. Inclure une vérification finale : `grep` de l'ancien pattern → zéro résultat attendu
3. Si la modification est trop complexe pour `sed` → régénérer le fichier complet depuis le template

**Exemple minimal :**
```bash
sed -i 's|ancien-nom|nouveau-nom|g' fichier.md
grep "ancien-nom" fichier.md  # → doit retourner vide
```

Cette règle s'applique à tous les fichiers : `.md`, `.html`, `.sh`, `.json`.
Elle est cohérente avec INV-1 (vérification exécutable) : une modification
sans grep de validation finale n'est pas une modification vérifiée.

---

## Analyse (obligatoire — tous types sauf Revue)

**Principes anti-biais (avant toute analyse) :**
- Ancrer sur une preuve observable avant de théoriser — jamais l'inverse
- Traiter la description de l'utilisateur comme une hypothèse à vérifier,
  pas comme un fait de départ
- Si une preuve contredit la théorie en cours → mettre à jour la théorie,
  jamais minimiser la preuve

Toujours partir du code réel, pas d'une hypothèse mémoire.

```
## Compréhension
- Objectif :
- Comportement actuel → cible :
- Périmètre inclus / exclu :

## Fichiers nécessaires
- Obligatoire :
- Utile :

## Données collectées (si Tuning — sinon "N/A")
- Baseline mesurée :
- Observation justifiant la demande :
- Critère de succès mesurable avant/après :

## Analyse d'impact
- Modules touchés :
- Modules partagés concernés (→ niveau B obligatoire) :
- Risques de régression :

## Plan d'exécution
1.
2.
3.

## Plan de test
- A — Ciblé : `<commande exacte — jamais une description>`
- B — Non-régression : <ce qui ne doit pas changer>
- C — Intégration : <run complet si risque élevé>

Règle : le niveau A est invalide sans commande exécutable.
Une description ("vérifier que X fonctionne") n'est pas un test.

## Candidat hook *(optionnel — remplir si une action risquée a été évitée ou détectée)*
- Action concernée : [ex : pip install hors venv, écriture directe dans fichier protégé]
- Pattern détectable : [ex : `pip install [^-]` sans VIRTUAL_ENV]
- Fréquence estimée : [ponctuelle / récurrente]
→ À soumettre à l'Étape 1 du wrap-up pour décision.

## Demande d'aval
Résumé 3 lignes · fichiers à modifier · tests prévus · confiance : [HAUTE/MOYENNE/FAIBLE — raison en 1 ligne]

**Verdict gate :** [PASS / CONCERNS / FAIL]
- **PASS** : analyse complète, prêt à coder sans réserve
- **CONCERNS** : prêt à coder, mais ≥ 1 point de vigilance signalé
  explicitement ci-dessus (risque accepté, pas un bloquant)
- **FAIL** : analyse incomplète ou bloquant non résolu — ne pas demander
  l'aval, compléter l'analyse d'abord

→ J'attends ton aval explicite avant de coder (sauf verdict FAIL — dans ce cas, compléter l'analyse avant de demander l'aval).
```

---

## Mémoire de sprint

Fichier : `.claude/sprint-memory.md` — non versionné (gitignore), créé au §Handoff, détruit après commit.

**Format des entrées — 7 types :**
```
[HH:MM] ANALYSE  — [objectif · périmètre · conclusion en 1 ligne] [CONF: HAUTE/MOY/FAIBLE — raison]
[HH:MM] DÉCISION — [retenu : X / écarté : Y — raison : Z] [valide jusqu'à : condition ou "stable"]
                   → fichiers : `path/to/file`  *(optionnel)*
[HH:MM] TEST [A/B/C] — `[commande]` → [OK ✓ / FAIL ✗ — observation]
[HH:MM] QUESTION — [question] → [réponse ou EN ATTENTE [humain]]
[HH:MM] PIVOT    — [ce qui a changé par rapport au plan initial]
[HH:MM] BLOQUANT — [description] → [RÉSOLU (solution) / EN ATTENTE [humain] (raison)]
                   → alternative : [action concrète possible sans lever ce bloquant] *(optionnel)*
[HH:MM] CHECKPOINT — compaction reason=[manual/auto] — tokens [used]/[limit] (≈[freed] libérés) — transcript : `<transcript_path>`
```

**Écrire quand :** analyse complète formulée · décision prise · résultat de test · question identifiée ou résolue · pivot · bloquant détecté ou levé.

**Ne pas écrire :** après chaque `read_file` / `bash` / `grep` · états intermédiaires sans décision · ce que le CLI montre déjà.

**`CHECKPOINT` — seul type non écrit par Claude :** généré automatiquement par le
hook `PreCompact` (`.claude/hooks/pre-compact.sh`, M-HOOKS-XX) avant toute
compaction, manuelle ou automatique. Purement mécanique — il marque le moment
de la coupure, il ne résume pas le contexte perdu. Étend `M-PROC-13` : la
pause forcée par tranche horaire suit le même chemin de reprise que la
session tronquée par crash, sans action manuelle requise pour amorcer la trace.

**Perte accidentelle en cours de sprint :**
Si `.claude/sprint-memory.md` est absent alors qu'un sprint est manifestement
en cours (spec sprint active dans `specs/Sprints/`, ou `git diff HEAD` non vide
sans commit de wrap-up récent) → ne pas continuer sans trace.
Reconstruire un résumé minimal avant de poursuivre :
```bash
git diff HEAD                    # fichiers et changements en cours
git log --oneline -3             # ancrage temporel
```
Format minimal acceptable : 3-5 entrées DÉCISION/TEST couvrant l'état connu.
Signaler la reconstruction explicitement : `[RECONSTRUIT depuis git diff]`.

---

## Code

**Commentaires :** chaque bloc logique commenté.
Format : `# raison — décision D-XX si applicable`
Ne pas commenter ce que le code dit déjà — commenter *pourquoi*.
Documenter les pièges connus et les hypothèses non évidentes.

**Validation incrémentale :** tester chaque modification avant la suivante.
Si un test échoue → `/diagnostic` avant de continuer.

**Modules partagés :** toute modification → vérifier les consommateurs avant de coder.

**Éviter :**
- complexité prématurée
- dépendances sans bénéfice net
- logique implicite
- duplication
- refactor hors périmètre

---

## Test

**Clause anti-complaisance :**
Ne jamais marquer un test OK sans avoir vu la sortie réelle de la commande
dans cette session. Un souvenir ("passait avant"), une supposition ("devrait
passer"), une inférence ("le code est correct donc...") ou une impression
("ça a l'air bon") ne sont pas des vérifications. Si la commande n'a pas été
exécutée → l'exécuter avant de conclure. Voir aussi §Rôle pour la règle de
citabilité générale sur toute affirmation factuelle, pas seulement les tests.

**Définition "test OK" :**
- **A — Ciblé :** commande exacte produit le résultat attendu, pas d'erreur.
- **B — Non-régression :** modules non touchés se comportent comme avant.
- **C — Intégration :** run complet du système produit un output valide.

Si résultat ambigu → documenter l'observation et demander aval avant de décider.

Si tests OK → `/wrap-up`. Si bug → `/diagnostic`.

---

## Wrap-up et amélioration continue

**`/wrap-up`** — clôture de sprint :
- Question rétrospective avec avis éclairé (lit l'index LESSONS_LEARNED)
- Entrée Lessons Learned rapide (5 lignes max)
- CHANGELOG + ROADMAP obligatoires, DECISIONS/SPEC/etc. conditionnels
- Bloc "Corrections ajustées vs spec" dans CHANGELOG si ≥ 1 correction ajustée
- Commit git conforme + reminder sync fichiers projet Claude.ai

**`/retrospective`** — analyse patterns (toutes les ~5 sprints ou sur incident) :
- Lecture index + entrées récentes LESSONS_LEARNED
- Détection récurrences, aggravations, succès
- Traitement `[HOOK_CANDIDATE]` en attente (≥ 2 occurrences → proposer activation)
- Synthèse `[SDLC_CANDIDATE]` en attente → bloc de remontée manuelle vers projet SDLC
- Propositions d'actions avec destination explicite
- Validation humaine avant commit

**Avant tout commit :** vérifier la DoD (STANDARDS.md §Definition of Done).
`git diff --stat` — fichiers attendus uniquement.
CHANGELOG version cohérente, ROADMAP sans sprint futur écrasé.

---

## Oracle (→ recherche externe)

Déclencher si : question factuelle dont la réponse change le plan d'exécution.
Ne pas déclencher : info déjà dans le repo, préférence stylistique, output sans impact décision imminente.

Format : Contexte (3 lignes max) · Question · Impact sprint · Décision dépendante.

---

## Priorités d'architecture

<!-- [→ ADAPTER si nécessaire] Ordre des priorités selon le domaine -->
Justesse → robustesse → maintenabilité → observabilité → performance.

**Arbitrage :** si deux priorités s'affrontent → expliciter le compromis et demander aval avant de trancher.

Toujours expliciter : solution retenue · alternative écartée · dette créée.

Éviter : complexité prématurée · dépendances sans bénéfice net · logique implicite · duplication · refactor hors périmètre.
