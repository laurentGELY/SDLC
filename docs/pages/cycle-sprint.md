# Le cycle de sprint

Le travail avance par **sprints** — des unités bornées, chacune décrite par un PDR (Plan de Développement et de Réalisation) et close par `/wrap-up`.

---

## La boucle

```
Analyse  →  Demande d'aval  →  Code  →  Test  →  /wrap-up
   │         (verdict            │        │         │
   │          PASS/CONCERNS      │        │         └─ clôture stricte
   │          /FAIL)             │        └─ commande exacte (INV-1)
   │                             └─ jamais sans aval explicite
   └─ obligatoire, tous types sauf Revue
```

**Règle absolue :** ne jamais écrire de code avant l'aval explicite de l'utilisateur. Ne jamais sauter l'analyse, même pour un petit fix. Ne jamais conclure sans preuves observables.

## L'analyse d'abord

Chaque sprint commence par une analyse structurée : compréhension de l'objectif, fichiers nécessaires, analyse d'impact, plan d'exécution, **plan de test avec commandes exactes**, et une demande d'aval qui se termine par un verdict :

- **PASS** — analyse complète, prêt à coder sans réserve.
- **CONCERNS** — prêt à coder, mais ≥ 1 point de vigilance signalé (risque accepté, pas bloquant).
- **FAIL** — analyse incomplète ou bloquant non résolu → ne pas demander l'aval, compléter d'abord.

Voir [Garde-fous : HALT & verdicts](#garde-fous) pour le détail du verdict gate.

## Les types de sprint

Le type détermine le flux et l'output attendu.

| Type | Description | Output attendu |
|------|-------------|----------------|
| **Feature** | Nouvelle fonctionnalité | Code + tests + doc |
| **Fix** | Correction de bug/régression | Code corrigé + test non-régression |
| **Tuning** | Seuils, prompts, paramètres | Mesure avant/après + `DECISIONS.md` |
| **Doc** | Documentation, process | Fichiers doc mis à jour, zéro code |
| **Spike** | Investigation bornée | Décision dans `DECISIONS.md` (pas de code) |
| **Dette** | Remboursement dette technique | Code nettoyé + test non-régression |
| **SDLC-Sync** | Alignement version | Marqueur version à jour + `D-SYNC-XX` |

## La mémoire de sprint

Pendant le sprint, un fichier éphémère `.claude/sprint-memory.md` (non versionné) trace les moments décisifs. Sept types d'entrées : `ANALYSE`, `DÉCISION`, `TEST`, `QUESTION`, `PIVOT`, `BLOQUANT`, et `CHECKPOINT` (généré automatiquement par le hook `PreCompact` avant toute compaction).

On écrit quand : analyse formulée, décision prise, résultat de test, question résolue, pivot, bloquant détecté ou levé. On **n'écrit pas** après chaque lecture de fichier ou ce que le CLI montre déjà.

Le fichier est détruit après le commit de clôture — jamais avant. S'il est retrouvé non vide au démarrage d'une session, c'est le signal d'un sprint précédent non clôturé, et l'agent s'arrête pour demander quoi faire.

## La clôture

Tests OK → `/wrap-up`. Anomalie → `/diagnostic`. Le [skill /wrap-up](#skill-wrapup) exécute une séquence stricte de 6 étapes qui garantit qu'aucun sprint ne se termine sans bilan, entrée de rétrospective, mise à jour de doc et commit conforme.
