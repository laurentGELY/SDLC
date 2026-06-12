# retrospective — SKILL
<!-- Template SDLC v1.6 · Destination : .claude/skills/retrospective/SKILL.md dans le repo cible -->

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
- Les entrées `DÉCISION [valide jusqu'à : condition]` dont la condition n'est plus vraie

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

DÉCISIONS POTENTIELLEMENT INVALIDÉES
⚠️  Sprint [N] — DÉCISION "[résumé]" — condition "[valide jusqu'à : X]"
   → Vérification : [commande ou observation pour confirmer validité]
   → État : [toujours valide / à revérifier / invalidée]

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

AUCUN SDLC_CANDIDATE EN ATTENTE
— RAS

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  Ces remontées ne sont pas appliquées automatiquement.
    Reporter manuellement dans le projet SDLC (07-DECISIONS-SDLC.md)
    et modifier les templates concernés.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Étape 5 — Index structuré des patterns

Mettre à jour `doc/LESSONS_LEARNED.md` §Index des patterns avec les données
structurées de cette rétro. Format machine-lisible pour permettre des requêtes
ultérieures sans relire toutes les entrées.

```markdown
## §Index des patterns · mis à jour [JJ/MM/AAAA] · Sprints N→M

| ID | Pattern | Occurrences | Sprints | Statut | Décision |
|----|---------|-------------|---------|--------|----------|
| P-01 | [nom court] | [N] | [liste] | actif / résolu / surveillé | [hook activé / règle ajoutée / en attente] |
| P-02 | [nom court] | [N] | [liste] | actif / résolu / surveillé | [décision] |

## §Métriques de rétro · [JJ/MM/AAAA]

- Sprints couverts : [N à M] ([X] sprints)
- HOOK_CANDIDATE en attente : [N] · activés ce cycle : [N] · rejetés : [N]
- SDLC_CANDIDATE en attente : [N] · remontés ce cycle : [N]
- Décisions invalidées détectées : [N]
- Patterns nouveaux : [N] · patterns résolus : [N]
- Dernière /retrospective : [JJ/MM/AAAA] · Sprints N→M
```

**Règle :** ne jamais réécrire les entrées existantes de l'index — mettre à jour
les champs `Occurrences`, `Sprints`, `Statut`, `Décision` des entrées existantes,
ajouter les nouvelles lignes P-XX en fin de tableau.

---

## Étape 6 — Mise à jour champs décision

Pour chaque `[HOOK_CANDIDATE]` ou `[SDLC_CANDIDATE]` traité, mettre à jour le champ
`décision :` dans `doc/LESSONS_LEARNED.md` :

```
→ décision : [activé sprint N / reporté / rejeté — raison]
```

Ne jamais réécrire l'entrée source — modifier uniquement le champ décision.

---

## Référence rapide — Seuils de déclenchement

| Signal | Action |
|--------|--------|
| 5 sprints sans rétro | Déclencher `/retrospective` |
| Incident grave (rollback, perte données) | Déclencher immédiatement |
| ≥ 3 `[HOOK_CANDIDATE]` en attente | Déclencher |
| ≥ 1 `[SDLC_CANDIDATE]` en attente depuis > 3 sprints | Déclencher |

---

## Requêtes utiles sur l'index structuré

Une fois l'index en format tableau, ces greps donnent des vues rapides
sans relire tout le fichier :

```bash
# Patterns actifs non résolus
grep "actif" doc/LESSONS_LEARNED.md | grep -v "résolu"

# HOOK_CANDIDATE en attente depuis plus d'un cycle
grep "HOOK_CANDIDATE" doc/LESSONS_LEARNED.md | grep "en attente"

# Décisions potentiellement invalidées
grep "valide jusqu'à" doc/LESSONS_LEARNED.md | grep -v "stable"

# Métriques de la dernière rétro
grep -A 8 "§Métriques de rétro" doc/LESSONS_LEARNED.md | tail -8
```
