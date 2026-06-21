# wrap-up — SKILL
<!-- Template SDLC v1.4 · Destination : .claude/skills/wrap-up/SKILL.md dans le repo cible -->
<!-- Adapter uniquement les sections marquées [→ ADAPTER] -->

Procédure de clôture de sprint. Exécuter dans l'ordre strict.
Ne pas sauter d'étape, même pour un sprint Doc ou Spike.

**Principe d'exécution** : Claude fait le travail et rapporte ce qu'il a fait.
Ne pas poser de questions quand l'information est accessible dans la conversation
ou les fichiers. La seule vraie question utilisateur est la rétrospective (Étape 1).
Toutes les autres étapes sont auto-exécutées avec rapport de résultat.

---

## Étape 0 — Bilan de session

### 0a. Lire la mémoire sprint
```bash
cat .claude/sprint-memory.md 2>/dev/null || echo "— aucun fichier mémoire"
```
Si le fichier existe → source de vérité prioritaire `[✓ mémoire]` pour reconstruire le bilan.
Les entrées `EN ATTENTE [humain]` (QUESTION et BLOQUANT) deviennent des action items prioritaires.

**Second output — Synthèse signaux rétrospectifs** (si sprint-memory non vide) :
Extraire et résumer en 3 bullets maximum les entrées pertinentes :
- `PIVOT` — tout changement de plan survenu dans le sprint
- `BLOQUANT EN ATTENTE [humain]` — tout bloquant non résolu en fin de sprint
- `HOOK_CANDIDATE` / `[CONF: FAIBLE]` — action risquée non bloquée ou analyse à faible confiance
Afficher ce bloc avant les questions de §Étape 1 comme contexte — pas comme réponses suggérées.
Si aucun signal pertinent → confirmer "✅ Aucun signal rétrospectif notable".

### 0b. Identifier la référence de session
Chercher dans la conversation le document de référence initial (PRD uploadé,
objectifs énoncés, liste de tâches du sprint). Si absent, utiliser `doc/ROADMAP.md §Now`.

### 0c. Ancrer sur git
Exécuter directement (pas de copier-coller demandé à l'utilisateur) :
```bash
git diff --stat HEAD
git status
```
Si la commande réussit → source de vérité primaire `[✓ git]`.
Si elle échoue (repo non-git, environnement restreint) → fallback : demander
à l'utilisateur de coller le résultat manuellement ; si toujours absent →
inférer depuis la conversation `[~ chat]` avec avertissement explicite.
Ne jamais bloquer le wrap-up sur cette étape.

### 0d. Produire le bilan structuré

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 BILAN SESSION — [date]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Référence : [doc ou objectifs du sprint]

FAIT
✅ [item] [✓ git / ~ chat]

PARTIEL
🔶 [item] — ce qui manque

NON FAIT / REPORTÉ
❌ [item] — raison si connue
📌 [item] — à planifier prochain sprint

BLOQUANTS
🔴 [décision attendue] — de qui

HORS SCOPE (fait mais non prévu)
➕ [item] — impact éventuel

DETTE / EFFETS DE BORD
⚠️  [modification non prévue avec impact potentiel]

Objectifs réalisés : X / Y
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 0e. Revue objectif sprint

À partir de la spec sprint (§Objectif ou §Critères d'acceptation) et du git diff (`[✓ git]` ou `[~ chat]`) :

```
OBJECTIF PDR    : [objectif énoncé dans la spec sprint]
RÉSULTAT CONSTATÉ : [état livré — croisé avec le bilan §0d et le diff git]
VERDICT         : ATTEINT / PARTIEL / NON ATTEINT
Justification   : [citer ≥ 1 critère d'acceptation de la spec + son état observé dans le diff git]
```

Règle : un "fait à 90%" sans critère d'acceptation coché n'est pas ATTEINT.
Le verdict est ancré sur la spec et le diff git — pas sur une impression de session.

---

### 0f. Adversarial Review *(conditionnel — Taille M/L uniquement)*

**Déclenchement :** vérifier la Taille du sprint dans l'en-tête du PDR
(`specs/Sprints/sprint-N-slug.md`). Si XS ou S → confirmer explicitement
"✅ Adversarial Review — Taille XS/S, non applicable" et passer à §Étape 1.

**Si Taille M ou L → exécuter les 2-3 couches suivantes :**

**Couche 1 — Blind Hunter (toujours)**
Relire uniquement `git diff` du sprint, sans rouvrir le fil de conversation
ni présumer du contexte déjà discuté. Chercher : bugs évidents, incohérences,
code mort, edge cases visibles dans le diff seul.
- Si le mode Agent (sous-agent Claude Code) est disponible → déléguer cette
  passe à un sous-agent qui ne reçoit que `git diff` en entrée (vraie cécité,
  cohérent avec le seuil de délégation `Claude.md §Tokens`).
- Sinon → discipline simulée : déclarer explicitement
  "Relecture en cécité simulée — fil de conversation ignoré pour cette passe."

**Couche 2 — Edge Case Hunter (toujours)**
Relecture du même diff avec accès complet au projet (specs, code existant,
conventions `STANDARDS.md`). Chercher : edge cases liés au contexte projet,
régressions potentielles sur modules existants, divergence avec les
conventions établies.

**Couche 3 — Acceptance Auditor (conditionnel — module partagé touché)**
Même déclencheur que le niveau de test B (`STANDARDS.md §Modules partagés`).
Si applicable : relire le diff contre la spec complète du PDR sprint —
vérifier que chaque critère d'acceptation est *réellement* satisfait, pas
seulement vraisemblable.

**Triage — pour chaque finding des couches exécutées :**
```
🔴 décision_requise — ambigu, nécessite arbitrage humain avant de continuer
🟡 patch          — fix trivial, applicable immédiatement avant commit
🔵 différé        — valide mais hors scope de ce sprint → doc/ROADMAP §Later
                     ou doc/LESSONS_LEARNED
⚪ écarté         — faux positif ou non pertinent — noter pourquoi
```

**Format de sortie :**
```
🔍 ADVERSARIAL REVIEW — Sprint [N] · Taille [M/L]
Couche 1 : [N findings]
Couche 2 : [N findings]
Couche 3 : [N findings / N/A — module partagé non touché]

🔴 [finding] → bloquant avant commit
🟡 [finding] → appliqué : [description du patch]
🔵 [finding] → ajouté à [doc/ROADMAP §Later / doc/LESSONS_LEARNED]
⚪ [finding] → raison : [...]
```

**Règle :** si ≥ 1 finding `🔴 décision_requise` → ne pas committer avant
résolution ou aval explicite de l'humain sur ce point précis.
Si zéro finding sur toutes les couches exécutées → confirmer explicitement
"✅ Adversarial Review — RAS, [N] couches passées."

---

## Étape 1 — Question rétrospective

*Contexte : utiliser la synthèse des signaux produite en §0a (PIVOT · BLOQUANT · HOOK_CANDIDATE / CONF FAIBLE) pour formuler l'avis éclairé ci-dessous.*

Lire l'index `doc/LESSONS_LEARNED.md` §Index des patterns.
Formuler un avis éclairé : ce sprint confirme-t-il un pattern connu ?

Poser les trois questions en un seul bloc — attendre la réponse humaine avant de continuer :

**"Qu'est-ce qui s'est bien ou mal passé dans ce sprint ?"**

**"Y a-t-il eu une action risquée, une hésitation sur une commande, ou une règle
appliquée manuellement que Claude Code aurait dû bloquer automatiquement ?"**
*(Si oui → sera capturé comme `[HOOK_CANDIDATE]` à l'étape 2)*

**"Y a-t-il quelque chose dans ce sprint qui devrait changer le modèle SDLC lui-même —
un template, une procédure, un invariant ?"**
*(Si oui → sera capturé comme `[SDLC_CANDIDATE]` à l'étape 2 · remontée manuelle dans projet SDLC)*

---

## Étape 2 — Entrée Lessons Learned

Ajouter une entrée dans `doc/LESSONS_LEARNED.md` §Entrées par sprint.

Format obligatoire (5 lignes max) :
```
### Sprint N — JJ/MM/AAAA — [Titre]
**Code :** [observations techniques — ou "RAS"]
**Processus :** [observations de processus — ou "RAS"]
**Lien pattern :** [confirme P-XX / infirme P-XX / aucun]
**Action proposée :** [action + destination (ex: Claude.md §X)] → décision : [en attente]
**Hook candidat :** [HOOK_CANDIDATE] [description action risquée] → ligne bash : `[commande grep/pattern]` — décision : [en attente]
**SDLC candidat :** [SDLC_CANDIDATE] [description] → fichier cible : [ex: 03-wrap-up / 04-PDR / Claude.md template] · nature : [nouveau champ / règle renforcée / procédure modifiée] — décision : [en attente — à remonter manuellement dans projet SDLC]
```

Le champ `**Hook candidat :**` est optionnel — n'inclure que si l'Étape 1 a produit une réponse positive sur la 2e question.
Le champ `**SDLC candidat :**` est optionnel — n'inclure que si l'Étape 1 a produit une réponse positive sur la 3e question.
Omettre les lignes entières si RAS.

---

## Étape 2b — Corrections ajustées vs spec

Si ≥ 1 correction ajustée par rapport à la spec initiale :
Ajouter un bloc dans l'entrée CHANGELOG du sprint :

```
**Corrections ajustées vs spec** — [description de la divergence et raison]
  - Fichiers à relire dans Claude.ai : [si applicable]
```

---

## Étape 3 — Mise à jour documentation

### Obligatoire à chaque sprint

**`CHANGELOG.md`** — nouvelle entrée :
```
## [X.Y] — AAAA-MM-JJ · Sprint N · [Titre]
- **`fichier.py` vX.Y** : [description modification]
- **Tests** : [résultat]
```
Règles format : zéro `###` dans les entrées · bullets plats · **bold** pour noms de fichiers.

**`doc/ROADMAP.md`** — mettre à jour :
- Sprint complété → déplacer en §Historique
- §Now → prochain sprint ou "— En attente"
- §Next / §Later → ajuster si nécessaire

**`doc/DIAGNOSTIC_CMDS.md`** — obligatoire, auto-exécuté :
Relire la conversation. Extraire toute commande utilisée ou affinée ce sprint.
Ajouter si nouvelle. Si aucune commande nouvelle : confirmer explicitement "✅ DIAGNOSTIC_CMDS — RAS".

**`specs/Sprints/sprint-N-slug.md`** — obligatoire, auto-exécuté :
Vérifier que le fichier existe (créé en étape 4a du démarrage).
Si absent : signaler l'anomalie explicitement — `⚠️ specs/Sprints/sprint-N-slug.md absent`.
Si présent : compléter la section §Corrections ajustées vs spec si ≥ 1 divergence par rapport à la spec initiale.
Si aucune divergence : confirmer explicitement "✅ spec sprint — aucune correction ajustée".
Enforcement placeholders résiduels :
```bash
grep -En "\[À REMPLIR\]|\[ \]|\[→ ADAPTER\]" specs/Sprints/sprint-N-slug.md \
  && echo "⚠️ placeholders résiduels — corriger avant commit" \
  || echo "✅ spec propre"
```
Résultat attendu : `✅ spec propre`. Une ligne `⚠️` est une erreur bloquante.

### Nettoyage artefacts — auto-exécuté, rapporter le résultat

**Artefacts périmés (Q1) :**
Lire `git diff --name-only HEAD` pour obtenir les fichiers touchés ce sprint.
Dans chacun de ces fichiers, chercher les marqueurs `[ ]`, `[À FAIRE]`, `[sprint dédié]`.
Si le sprint résout l'item → cocher/nettoyer dans le fichier source.
Rapporter :
```
🧹 NETTOYAGE ARTEFACTS
✅ [fichier] ligne [N] — [marqueur] coché
— aucun marqueur périmé trouvé dans les fichiers touchés
```

**Décisions évoluées (Q2) :**
Lire `doc/DECISIONS.md`. Identifier les entrées existantes liées au travail de ce sprint.
Si une décision existante a évolué → ajouter un sous-bloc sous l'entrée originale :
`→ Mise à jour [date] : [description de l'évolution]`
Ne jamais réécrire l'entrée source — préserver l'historique.
Rapporter :
```
📋 DECISIONS.md
✅ §[titre décision] — sous-bloc "→ Mise à jour" ajouté
— aucune décision existante impactée
```

### Conditionnels (déclencher si applicable)

| Condition | Action |
|-----------|--------|
| Nouvelle décision architecturale | Nouvelle entrée dans `doc/DECISIONS.md` |
| Comportement système modifié | Mettre à jour `specs/SPEC.md` |
| Module partagé ajouté/supprimé/renommé | Mettre à jour `STANDARDS.md` §Modules partagés **et** `doc/DEPENDENCY_MAP.md` — même commit |
| Entrée `[CLOS]` dans `doc/SESSION_BRIDGE.md`, ou > 5 entrées sans nettoyage | Nettoyer `doc/SESSION_BRIDGE.md` — supprimer les entrées `[CLOS]` · avertir si > 5 sans nettoyage |
| Nouveau fichier de gouvernance créé ce sprint (`.claude/`, `doc/`, `specs/`) | Vérifier `doc/CLAUDE_PROJECT.md` — noter les fichiers manquants → §Étape 6 |

<!-- [→ ADAPTER] Ajouter les déclencheurs spécifiques au projet -->

---

## Étape 3.5 — Vérification pré-commit

```bash
git diff --stat          # uniquement les fichiers attendus
git status               # rien d'oublié, rien d'en trop
```

Checklist :
- [ ] CHANGELOG : version +0.1 cohérente avec la précédente
- [ ] ROADMAP : aucun sprint futur écrasé
- [ ] Tests : niveau A passé (obligatoire), B si module partagé touché
- [ ] Zéro fichier hors portée dans le diff
- [ ] Bilan session (Étape 0) cohérent avec le diff git

---

## Étape 4 — Commit

Format : `type(module): résumé court`

Types valides : `feat` · `fix` · `refactor` · `tuning` · `docs` · `chore` · `test`

Corps du commit :
```
- [changement 1]
- [changement 2]
- Tests : [résultat niveau A] · [résultat niveau B si applicable]
```

**Après confirmation du commit — supprimer la mémoire sprint :**
```bash
rm -f .claude/sprint-memory.md && echo "✅ sprint-memory.md supprimé"
```
Supprimer *après* le commit — jamais avant. Si le commit échoue, conserver le fichier.

---

## Étape 5 — Amorce session suivante

Générer le bloc contexte session suivante et l'afficher dans le chat :

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 CONTEXTE SESSION SUIVANTE — [date]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Sprint complété : [titre]
Commit : [hash court]

BLOQUANTS EN SUSPENS
🔴 [décision attendue — de qui] *(vide si aucun)*

FIL FONCTIONNEL
[2 phrases max : état du système livrable après ce sprint — ce qui est opérationnel]

Référence : doc/ROADMAP.md §Now
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Écrire dans `doc/SESSION_BRIDGE.md` (accumulatif) :**

Insérer en tête du fichier (entrée la plus récente en premier) :

```markdown
## [Sprint N — slug] · [AAAA-MM-JJ]
**Commit :** [hash court]
**Bloquants en suspens :** [liste ou "aucun"]
**Fil fonctionnel :** [2 phrases max — état du livrable après ce sprint]
```

Si le fichier n'existe pas → le créer avec le header puis l'entrée :
```markdown
# SESSION_BRIDGE — Contexte inter-session
<!-- Accumulatif · entrée la plus récente en tête · nettoyage conditionnel au wrap-up -->

## [Sprint N — slug] · [AAAA-MM-JJ]
**Commit :** [hash court]
**Bloquants en suspens :** [liste ou "aucun"]
**Fil fonctionnel :** [2 phrases max — état du livrable après ce sprint]
```

**Ne pas inclure dans SESSION_BRIDGE :** liste de tâches ou next actions (rôle de `doc/ROADMAP.md §Now`).

Le contenu est versionné dans le même commit que le wrap-up du sprint.

---

## Étape 6 — Sync fichiers projet Claude.ai

<!-- [→ ADAPTER] Nom du projet Claude.ai cible -->

**Si `doc/CLAUDE_PROJECT.md` existe :**
Comparer les fichiers de gouvernance présents dans le repo (`.claude/`, `doc/`, `specs/`)
avec la liste dans `doc/CLAUDE_PROJECT.md`.
Si delta (fichier présent dans le repo mais absent de CLAUDE_PROJECT.md) :
```
⚠️  SYNC CLAUDE_PROJECT requis — fichiers à ajouter dans le projet Claude.ai `[Nom du projet]` :
  - [fichier 1]
  - [fichier 2]
→ Ouvrir les Project Files → "Sync now".
```

**Si `doc/CLAUDE_PROJECT.md` absent (sprint SDLC-05b non exécuté) :**
Reminder : "Sync now" dans les Project Files du projet Claude.ai `[Nom du projet]`.
Si des fichiers ont été modifiés dans `.claude/` ou les templates de gouvernance :
les fichiers projet Claude.ai sont **hors repo git** — mise à jour manuelle requise.

---

## Référence rapide — Déclencheurs étape 3

```
Nouvelle feature ou fix         → CHANGELOG + SPEC si comportement change
Tuning seuils/prompts           → CHANGELOG + DECISIONS (mesure avant/après)
Module partagé ±                → STANDARDS §Modules + DEPENDENCY_MAP (même commit)
Spike                           → DECISIONS uniquement (pas de code)
Sprint Doc                      → CHANGELOG uniquement (zéro code)
Incident / rollback             → LESSONS_LEARNED §Action proposée prioritaire
[HOOK_CANDIDATE] en Étape 1     → LESSONS_LEARNED champ Hook candidat → décision différée à /retrospective
[SDLC_CANDIDATE] en Étape 1     → LESSONS_LEARNED champ SDLC candidat → remontée manuelle projet SDLC
```
