# Claude.md — Projet toolkit SDLC · v1.0
<!-- Adapté depuis 01-Claude-md-TEMPLATE.md (SDLC v1.9) · Sprint SDLC-14 (self-bootstrap) -->
<!-- SDLC version : v1.9 · aligné le 19/06/2026 -->

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

**HALT — arrêt immédiat, attendre l'humain :**
- **HALT-DEP** : dépendance requise absente du PDR détectée avant d'installer
  ou d'adapter le code
- **HALT-3X** : même test ou commande échoue 3 fois consécutives sans
  diagnostic clair entre chaque tentative → lancer `/diagnostic` avant de continuer
- **HALT-ARCH** : convention du modèle (numérotation, structure de fichier)
  contredite par le changement proposé → signaler avant d'adapter le fichier
- **HALT-SCOPE** : périmètre des fichiers à modifier dépasse significativement
  le §Portée du PDR → ne pas étendre sans validation explicite
- **HALT-TIMEOUT** : commande sans sortie depuis > 60s → préfixer avec
  `timeout 60`. Si exit code 124 → HALT. (N=60s : aucune commande de ce
  projet ne dépasse l'édition de fichiers + git, pas de build/test long)

HALT ≠ hook bash : les hooks bloquent les commandes dangereuses avant exécution.
Les HALT bloquent les conditions logiques détectées pendant le raisonnement.
Les deux sont complémentaires.

**Si l'aval n'est pas donné → s'arrêter après l'analyse et attendre.**

---

## Rôle

Tu exécutes les PDR de sprint produits sur ce projet — souvent conçus en
amont dans une session Claude.ai dédiée à la conception, puis transmis ici
pour exécution. Chaque sprint modifie un ou plusieurs fichiers
`0X-*-TEMPLATE.md`/`1X-*-TEMPLATE.md`, ou les fichiers de gouvernance
propres à ce projet (`07-DECISIONS-SDLC.md`, `CHANGELOG.md`, `README.md`).
Source de vérité : `07-DECISIONS-SDLC.md` pour les décisions sur le modèle —
`doc/DECISIONS.md` générique n'existe pas pour ce projet, ne pas le créer.

**Toute affirmation factuelle doit être citable** : chemin:ligne, sortie
de commande, entrée git, log — éviter les formulations non vérifiables
("probablement", "devrait", "en principe").

**Source de vérité :** le dépôt git. Restaurer depuis git avant tout patch.

**Référence architecturale :** `specs/SPEC.md` — exhaustive et toujours à jour.
Sprint specs individuels dans `specs/Sprints/`.

**Limites bash :** pas d'API authentifiée, pas de déploiement — édition de
fichiers markdown + git uniquement. Pour toute action hors portée : fournir
la commande exacte prête à copier avec le résultat attendu.

**Secrets :** N/A — aucun `.env`, aucun secret dans ce projet.

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

# Contexte inter-session (entrée la plus récente en tête)
head -15 doc/SESSION_BRIDGE.md 2>/dev/null \
  || echo "— SESSION_BRIDGE absent (premier sprint ou 05b non exécuté)"

# 3. Référence — sprint actif et architecture du modèle
sed -n '/^## ▶ Now/,/^## ⏭ Next/p' doc/ROADMAP.md
grep -n "^##" specs/SPEC.md | head -20

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

Toujours partir du contenu réel des fichiers, pas d'une hypothèse mémoire.

**Taille du sprint :** si la taille du « cœur du changement » diffère de
la taille totale une fois la gouvernance associée comptée (fichiers de
registre, doc, specs à mettre à jour en plus du livrable principal) —
déclarer les deux explicitement dans la spec plutôt que sous-estimer en
ne comptant que le cœur (SDLC-11 · `M-PROC-28`, `/retrospective` SDLC-15).

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

## Test

**Clause anti-complaisance :**
Ne jamais marquer un test OK sans avoir vu la sortie réelle de la commande
dans cette session. Un souvenir ("passait avant"), une supposition ("devrait
passer") ou une inférence ("le contenu est correct donc...") ne sont pas des
vérifications. Si la commande n'a pas été exécutée → l'exécuter avant de
conclure.

**Définition "test OK" :**
- **A — Ciblé :** commande exacte produit le résultat attendu, pas d'erreur.
- **B — Non-régression :** fichiers non touchés se comportent comme avant.
- **C — Intégration :** N/A — pas de système exécutable à intégrer.

Si résultat ambigu → documenter l'observation et demander aval avant de décider.

Si tests OK → `/wrap-up`. Si anomalie → `/diagnostic`.

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

Justesse → robustesse → maintenabilité → observabilité → performance.

**Arbitrage :** si deux priorités s'affrontent → expliciter le compromis et demander aval avant de trancher.

Toujours expliciter : solution retenue · alternative écartée · dette créée.

Éviter : complexité prématurée · dépendances sans bénéfice net · logique implicite · duplication · refactor hors périmètre.
