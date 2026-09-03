# Hooks bash & PreCompact

Les hooks sont le versant **mécanique** de la gouvernance. Là où les `HALT` sont des blocages logiques que l'agent détecte pendant son raisonnement, un hook s'exécute **avant** une commande et peut la refuser, sans que l'agent ait à y penser.

C'est la forme la plus forte de `INV-2` : une règle si bien fermée qu'elle ne dépend plus du jugement de l'agent.

---

## PreToolUse — le hook Bash

`08-hooks-TEMPLATE.md §1` fournit un hook `pre-tool-bash.sh` qui intercepte chaque commande bash avant exécution. Il active des sections pertinentes selon le projet : détection de commandes dangereuses, patterns interdits (ex : `pip install` hors environnement virtuel), écriture directe dans un fichier protégé.

```
commande bash proposée
        │
        ▼
  pre-tool-bash.sh   ← intercepte AVANT exécution
        │
   ┌────┴─────┐
   ▼          ▼
 autorise    refuse + message
```

Le circuit vient de la [boucle de rétroaction](#boucle) : un `[HOOK_CANDIDATE]` détecté en rétrospective, vu ≥ 2 fois, devient une ligne de détection dans ce hook. L'incident cesse alors d'être une vigilance humaine pour devenir un mur.

## PreCompact — le checkpoint de mémoire

Ajouté au Sprint SDLC-23 (`M-HOOKS-08`), le hook `pre-compact.sh` s'exécute **avant toute compaction** du contexte — manuelle ou automatique. Il écrit une entrée `CHECKPOINT` dans la mémoire de sprint :

```
[HH:MM] CHECKPOINT — compaction reason=[manual/auto]
        tokens [used]/[limit] (≈[freed] libérés)
        transcript : <transcript_path>
```

C'est le **seul type d'entrée non écrit par Claude** : purement mécanique, il marque le moment de la coupure — il ne résume pas le contexte perdu. Il étend `M-PROC-13` : une pause forcée par compaction suit désormais le même chemin de reprise qu'une session tronquée par crash, **sans action manuelle** pour amorcer la trace.

## Hooks ≠ HALT

Les deux mécanismes sont complémentaires et ne se recouvrent pas :

- **Hook bash** — bloque une *commande* dangereuse, mécaniquement, avant exécution.
- **HALT** — bloque une *condition logique* détectée pendant le raisonnement (dépendance absente, périmètre dépassé…).

Un hook n'a pas besoin que l'agent « pense » à la règle ; un HALT dépend du raisonnement. Ensemble, ils couvrent les deux façons dont une session peut déraper — par une commande, ou par une inférence.

## Le principe de config vérifiée

Toute modification d'un fichier de config (`.claude/settings.json`, `.claude/hooks/*`) exige de noter la **valeur précédente** dans le commit, et une entrée dans le registre des décisions si le choix n'est pas trivial. La config est du code de gouvernance : elle se versionne et se justifie comme le reste.
