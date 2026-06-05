# wrap-up — SKILL
<!-- Template SDLC v1.2 · Destination : .claude/skills/wrap-up/SKILL.md dans le repo cible -->
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

### 0b. Identifier la référence de session
Chercher dans la conversation le document de référence initial (PRD uploadé,
objectifs énoncés, liste de tâches du sprint). Si absent, utiliser `doc/ROADMAP.md §Now`.

### 0c. Ancrer sur git
Demander à l'utilisateur de coller le résultat de :
```bash
git diff --stat HEAD
git status
```
Si collé → source de vérité primaire `[✓ git]`.
Si absent → inférer depuis la conversation `[~ chat]` avec avertissement explicite.

<!-- [→ ADAPTER] Remplacer les chemins git par les chemins du projet cible -->

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

---

## Étape 1 — Question rétrospective

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

Générer un bloc compact à coller en début de prochaine session :

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 CONTEXTE SESSION SUIVANTE — [date]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Sprint complété : [titre]
Commit : [hash court]

À FAIRE EN PRIORITÉ
→ [item 1 — vient de ❌ ou 📌 du bilan]
→ [item 2]

BLOQUANTS À RÉSOUDRE
🔴 [décision attendue — de qui]

DETTE À SURVEILLER
⚠️  [item si critique]

Référence : doc/ROADMAP.md §Now
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Étape 6 — Sync fichiers projet Claude.ai

<!-- [→ ADAPTER] Nom du projet Claude.ai cible -->
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
