# retrospective — SKILL
<!-- Template SDLC v1.2 · Destination : .claude/skills/retrospective/SKILL.md dans le repo cible -->
<!-- Adapter uniquement les sections marquées [→ ADAPTER] -->

Analyse de patterns sur l'ensemble des sprints complétés.
Déclencher toutes les ~5 sprints, ou immédiatement après un incident grave.

**Principe d'exécution** : Claude lit, analyse et propose — l'humain décide.
Aucune modification de fichier sans validation explicite.

---

## Étape 1 — Chargement du contexte

```bash
# Lire l'index des patterns
grep -A 3 "§Index des patterns" doc/LESSONS_LEARNED.md

# Lire les N dernières entrées (adapter N selon le nombre de sprints depuis la dernière rétro)
tail -150 doc/LESSONS_LEARNED.md
```

Identifier :
- Le nombre de sprints couverts depuis la dernière `/retrospective`
- Les tags `[HOOK_CANDIDATE]` non résolus (champ "décision : en attente")
- Les tags `[SDLC_CANDIDATE]` non résolus (champ "décision : en attente")

---

## Étape 2 — Analyse patterns internes

Produire un rapport structuré :

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔍 ANALYSE PATTERNS — [date] · Sprints [N] à [M]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

RÉCURRENCES (≥ 2 occurrences)
🔁 [pattern] — observé sprints [X, Y, Z] — impact : [description]

AGGRAVATIONS
📈 [pattern] — tendance : [description]

SUCCÈS À CONSOLIDER
✅ [pattern] — raison du succès — action pour pérenniser

HOOK_CANDIDATES EN ATTENTE
🪝 Sprint [N] — [description] — ligne bash : `[commande]`
   → Décision proposée : [activer / reporter / rejeter] — justification

AUCUN PATTERN NOTABLE
— RAS sur [N] sprints
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Étape 3 — Actions internes au projet

Pour chaque récurrence ou aggravation identifiée, proposer une action concrète :

| Pattern | Action proposée | Destination | Priorité |
|---------|----------------|-------------|----------|
| [pattern] | [action] | Claude.md §X / hook / DECISIONS.md | Haute / Normale |

**Règle de décision hooks :**
- ≥ 2 occurrences `[HOOK_CANDIDATE]` identiques → proposer activation
- 1 incident grave → proposer activation immédiate
- Pattern ponctuel → reporter à la prochaine rétro

Attendre la validation humaine avant tout commit.

---

## Étape 4 — Remontées modèle SDLC

Scanner tous les `[SDLC_CANDIDATE]` non résolus dans `doc/LESSONS_LEARNED.md`.

Produire un bloc de synthèse :

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🏗️  REMONTÉES MODÈLE SDLC — à reporter manuellement
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[SDLC_CANDIDATE] Sprint N — [description]
→ Fichier cible : [ex: 03-wrap-up-SKILL-TEMPLATE.md]
→ Nature : [nouveau champ / règle renforcée / procédure modifiée]
→ Contexte : [2 phrases — pourquoi ce sprint a révélé ce besoin]
→ Proposition concrète : [ce qui devrait changer exactement]

[SDLC_CANDIDATE] Sprint M — [description]
→ ...

AUCUN SDLC_CANDIDATE EN ATTENTE
— RAS

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  Ces remontées ne sont pas appliquées automatiquement.
    Reporter manuellement dans le projet SDLC (07-DECISIONS-SDLC.md)
    et modifier les templates concernés.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Étape 5 — Mise à jour LESSONS_LEARNED

Pour chaque `[HOOK_CANDIDATE]` ou `[SDLC_CANDIDATE]` traité, mettre à jour le champ
`décision :` dans `doc/LESSONS_LEARNED.md` :

```
→ décision : [activé sprint N / reporté / rejeté — raison]
```

Ne jamais réécrire l'entrée source — modifier uniquement le champ décision.

---

## Étape 6 — Mise à jour index patterns

Mettre à jour `doc/LESSONS_LEARNED.md` §Index des patterns :
- Ajouter tout nouveau pattern détecté (P-XX)
- Marquer les patterns confirmés ou infirmés par cette rétro
- Horodater la dernière rétro : `Dernière /retrospective : JJ/MM/AAAA · Sprints N→M`

---

## Référence rapide — Seuils de déclenchement

| Signal | Action |
|--------|--------|
| 5 sprints sans rétro | Déclencher `/retrospective` |
| Incident grave (rollback, perte données) | Déclencher immédiatement |
| ≥ 3 `[HOOK_CANDIDATE]` en attente | Déclencher |
| ≥ 1 `[SDLC_CANDIDATE]` en attente depuis > 3 sprints | Déclencher |
