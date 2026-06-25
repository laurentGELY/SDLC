# retrospective — SKILL
<!-- Template SDLC v1.8 · Destination : .claude/skills/retrospective/SKILL.md dans le repo cible -->

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

GRADUATION — patterns candidats à promotion
[liste — voir §Graduation automatique ci-dessous]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Graduation automatique :**
Après le rapport, scanner l'§Index des patterns (`doc/LESSONS_LEARNED.md`) :
- Identifier tout pattern avec `Occurrences ≥ 3` ET `Statut: actif`
- Vérifier que les occurrences se trouvent dans les 5 derniers sprints
  (grep les IDs sprint dans les colonnes Sprints de l'§Index)
- Si `grep -q "§Index des patterns" doc/LESSONS_LEARNED.md` échoue → confirmer "§Index absent, graduation non disponible."
- Si condition remplie → produire le bloc suivant pour chaque candidat :

```
---
🎓 GRADUATION CANDIDATE — [ID Pattern] · [Nom]
Occurrences : [N] sur [liste sprints]
Résumé : [description du pattern en 1 phrase]

Destinations possibles :
  A) Claude.md §[section pertinente] — règle permanente de comportement
  B) STANDARDS.md §[section] — standard projet à appliquer à tous les sprints
  C) .claude/hooks/ — garde-fou automatique (nécessite M-PROC-X dans DECISIONS)
  D) doc/LESSONS_LEARNED.md §Règles — règle documentée, pas encore hookée

→ Décision demandée : quelle destination ? (A / B / C / D / différer)
---
```

Si l'humain valide une destination :
- Pour A ou B : appliquer dans ce sprint si trivial, sinon créer un sprint Fix dédié
- Pour C : créer un HOOK_CANDIDATE avec ligne bash proposée, décision dans DECISIONS.md
- Pour D : ajouter sous §Règles dans LESSONS_LEARNED, modifier Statut → "promu (D)"
- Pour "différer" : marquer Statut → "surveillé" dans l'§Index, réévaluer à la prochaine rétro

Si aucun candidat → confirmer explicitement "✅ Graduation — aucun pattern ≥ 3 occurrences actif."

---

## Étape 2b — Significant Discovery Alert

Après le rapport §Étape 2, vérifier systématiquement les 5 conditions ci-dessous.
Cette checklist est indépendante du rapport — elle se déclenche sur des patterns
observés, pas sur la mémoire spontanée de l'humain ou de l'agent.

```
□ SD-1  Run réel absent ou défaillant :
        (a) le run réel n'a pas été obtenu avant clôture du ou des sprints couverts
            (tests synthétiques uniquement, pas de run en conditions réelles)
        (b) le run réel a révélé des défaillances non couvertes par les tests
            synthétiques (ex : format LLM variable, bug SFTP, VRAM contention)
        → si coché : quels autres modules dépendent du même mécanisme ?

□ SD-2  Code ou module hérité d'un projet antérieur supposé réutilisable
        s'est révélé invalide ou inutilisable pendant les sprints couverts
        (artifact périmé, logique métier étrangère, interface cassée)

□ SD-3  Comportement LLM ou infrastructure a divergé de ≥ 2 axes de la spec
        sur run réel (format de sortie, timeout, paramétrage, VRAM,
        dépendances externes) pendant les sprints couverts

□ SD-4  Décision architecturale réversée ≥ 2 fois pendant un même sprint
        → signal que l'hypothèse de départ était insuffisamment validée
          avant le code

□ SD-5  ≥ 1 action ⏳ sans déclencheur documenté présente depuis > 2 sprints
        dans doc/LESSONS_LEARNED.md ou doc/ROADMAP.md §Later
```

**Si ≥ 1 case cochée :**
```
🚨 SIGNIFICANT DISCOVERY ALERT
Sprint(s) concerné(s) : [N]
Condition(s) : [SD-X — description courte]
→ Ne pas démarrer le sprint suivant sans session de replanification
→ Documenter dans doc/DECISIONS.md ce qui change et pourquoi
→ Mettre à jour doc/ROADMAP.md §Now si le prochain sprint est remis en cause
```

**Si 0 case cochée :** confirmer explicitement :
`✅ SD1 à SD5 — RAS · prochain sprint peut démarrer`

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

## Étape 7 — Métriques tokens (optionnel)

Mesure réelle de la conso token, en complément des patterns qualitatifs des
étapes précédentes. Déclencher tous les ~5 sprints, en même temps que le
reste de la rétro.

### Baseline statique — M1 / M2

```bash
# M1 — plancher de contexte permanent (Claude.md + STANDARDS.md)
wc -w Claude.md STANDARDS.md

# M2 — coût de la procédure wrap-up
wc -w .claude/skills/wrap-up/SKILL.md
```

Comparer M1/M2 au sprint précédent ainsi mesuré (chercher dans
`doc/LESSONS_LEARNED.md §Métriques de rétro` ou `git log -p` sur ces fichiers)
— une variation notable est un signal pour les pistes d'allègement (§Étape 3).

### Mesure dynamique — sdlc-token-usage.sh

```bash
bash sdlc-token-usage.sh 2>/dev/null || echo "— script absent ou en échec, mesure dynamique ignorée"
```

Si le script est absent ou échoue → dégrader proprement, ne jamais bloquer la
rétro sur cette étape (même principe que le fallback CLAUDE_PROJECT existant,
M-PROC-22). Si présent → reporter les totaux bruts et, si disponible, la
bucketisation par étape dans le rapport §Étape 2 comme donnée d'appui (pas
comme nouveau pattern à elle seule).

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
