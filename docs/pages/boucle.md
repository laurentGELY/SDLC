# La boucle de rétroaction

C'est l'invariant `INV-4` en action, et sans doute le cœur de ce qui distingue le modèle : **aucune observation terrain ne se perd**. Chaque incident a un chemin balisé vers une règle permanente.

---

## Le circuit

```
   incident / observation terrain
              │
              ▼
   docs/LESSONS_LEARNED.md        ← capture immédiate (5 lignes max)
              │
              ▼
   /retrospective                ← analyse toutes les ~5 sprints
              │
      ┌───────┴────────┐
      ▼                ▼
   hook bash      règle Claude.md      ← la règle devient permanente
   (mécanique)    (logique)
```

## Étape 1 — Capture : LESSONS_LEARNED

À chaque `/wrap-up`, une entrée de 5 lignes maximum est ajoutée. Le format oblige à qualifier l'observation et à proposer une suite :

```
### Sprint N — JJ/MM/AAAA — [Titre]
**Code :** [observations techniques — ou "N/A"]
**Processus :** [observations de processus — ou "RAS"]
**Lien pattern :** [confirme LL-TXX / infirme / nouveau / aucun]
**Action proposée :** [action + destination] → décision : [en attente]
```

Deux marqueurs optionnels transforment une observation en candidat d'évolution :

- **`[HOOK_CANDIDATE]`** — une action risquée que l'agent aurait dû bloquer automatiquement. Accompagné de la ligne bash de détection envisagée.
- **`[SDLC_CANDIDATE]`** — quelque chose qui devrait changer le modèle SDLC lui-même (un template, une procédure, un invariant).

## Étape 2 — Analyse : /retrospective

Toutes les ~5 sprints, ou après un incident, `/retrospective` lit l'index et les entrées récentes, puis :

- détecte les **récurrences** (un `[HOOK_CANDIDATE]` vu ≥ 2 fois → proposer l'activation du hook),
- synthétise les **`[SDLC_CANDIDATE]`** en attente → bloc de remontée manuelle vers le projet SDLC,
- signale les **Significant Discovery Alerts** (`SD-1` → `SD-5`).

Voir [Le skill /retrospective](#skill-retro) pour la procédure complète.

## Étape 3 — Permanence : hook ou règle

Une observation validée devient l'un des deux :

- **un hook bash** — si elle peut être détectée mécaniquement avant l'exécution d'une commande (ex : `pip install` hors venv). Voir [Hooks](#hooks).
- **une règle `Claude.md`** — si c'est une contrainte logique de raisonnement.

Une fois permanente, la règle est appliquée à chaque session sans effort. La boucle a bouclé : l'incident ne peut plus se reproduire silencieusement.

## Ce que ça change

Sans cette boucle, un agent répète ses erreurs. Avec elle, chaque erreur est un investissement : elle coûte une fois, puis elle est neutralisée pour toujours. Le modèle **capitalise** l'expérience au lieu de la dissiper — c'est la définition d'un système qui apprend.
