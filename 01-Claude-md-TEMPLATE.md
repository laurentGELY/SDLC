# Claude.md — [Nom du projet] · v1.0
<!-- Template SDLC v1.6 · Copier dans le repo cible · Adapter les sections marquées [→ ADAPTER] -->
<!-- SDLC version : v1.6 · aligné le JJ/MM/AAAA -->
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
- commencer à coder sans avoir exécuté les étapes 4a/4b/4c et écrit le §Plan de développement dans le spec (4d)

**Si l'aval n'est pas donné → s'arrêter après l'analyse et attendre.**

---

## Rôle

<!-- [→ ADAPTER] Décrire le rôle de Claude Code dans ce projet spécifique -->
[Description du rôle de Claude Code dans ce projet.]
L'utilisateur est gestionnaire de produit et de projet technique.
Tu prends en charge : architecture, dev, tuning, debug, QA, doc, git.

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

# 2. Vérification mémoire sprint
if [ -s .claude/sprint-memory.md ]; then
  echo "⚠️  .claude/sprint-memory.md non vide"
  cat .claude/sprint-memory.md
fi

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

---

## Tokens

- **Chargement chirurgical** : §Handoff distingue "immédiat" (lire en 4c) et "différé" (grep d'abord, lire si pertinent)
- **Grep avant lecture** : tout fichier différé → grep avant de charger entièrement — jamais de lecture préventive
- **Analyse en une passe** : formuler toutes les questions avant de modifier
- **Oracle en amont** : toute question anticipable résolue avant handoff — zéro Oracle en session sauf blocage imprévu
- **Batching XS/S** : signaler les opportunités de merger des items indépendants de même taille touchant les mêmes fichiers

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
→ J'attends ton aval explicite avant de coder.
```

---

## Mémoire de sprint

Fichier : `.claude/sprint-memory.md` — non versionné (gitignore), créé au §Handoff, détruit après commit.

**Format des entrées — 6 types uniquement :**
```
[HH:MM] ANALYSE  — [objectif · périmètre · conclusion en 1 ligne] [CONF: HAUTE/MOY/FAIBLE — raison]
[HH:MM] DÉCISION — [retenu : X / écarté : Y — raison : Z] [valide jusqu'à : condition ou "stable"]
                   → fichiers : `path/to/file`  *(optionnel)*
[HH:MM] TEST [A/B/C] — `[commande]` → [OK ✓ / FAIL ✗ — observation]
[HH:MM] QUESTION — [question] → [réponse ou EN ATTENTE [humain]]
[HH:MM] PIVOT    — [ce qui a changé par rapport au plan initial]
[HH:MM] BLOQUANT — [description] → [RÉSOLU (solution) / EN ATTENTE [humain] (raison)]
                   → alternative : [action concrète possible sans lever ce bloquant] *(optionnel)*
```

**Écrire quand :** analyse complète formulée · décision prise · résultat de test · question identifiée ou résolue · pivot · bloquant détecté ou levé.

**Ne pas écrire :** après chaque `read_file` / `bash` / `grep` · états intermédiaires sans décision · ce que le CLI montre déjà.

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
