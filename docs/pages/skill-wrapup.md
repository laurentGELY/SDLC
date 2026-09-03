# Le skill /wrap-up

La procédure de clôture de sprint. Une **séquence stricte**, exécutée dans l'ordre, sans sauter d'étape — même pour un sprint Doc ou Spike.

> **Principe d'exécution :** Claude fait le travail et rapporte ce qu'il a fait. Pas de questions quand l'info est accessible dans la conversation ou les fichiers. La seule vraie question à l'utilisateur est la rétrospective (Étape 1).

---

## Étape 0 — Bilan de session

- **0a — Lire la mémoire sprint.** Source de vérité prioritaire pour reconstruire le bilan. Les entrées `EN ATTENTE [humain]` deviennent des action items. Un second output synthétise les signaux rétrospectifs (`PIVOT`, `BLOQUANT`, `HOOK_CANDIDATE`, `CONF FAIBLE`).
- **0b — Identifier la référence** de session (ROADMAP §Now ou PDR en cours).
- **0c — Ancrer sur git** (`git diff --stat HEAD`, `git status`). Auto-exécuté, jamais de copier-coller demandé. Source de vérité primaire `[✓ git]`.
- **0d — Bilan structuré** : FAIT / PARTIEL / NON FAIT / BLOQUANTS / HORS SCOPE / DETTE, avec un ratio « objectifs réalisés X/Y ».
- **0e — Revue objectif** : croiser l'objectif du PDR avec le résultat constaté → verdict `ATTEINT / PARTIEL / NON ATTEINT`. Un « fait à 90% » sans critère d'acceptation coché n'est **pas** ATTEINT.
- **0f — Adversarial Review** *(Taille M/L uniquement)* — relecture adverse en couches. Voir [Garde-fous](#garde-fous).

## Étape 1 — Question rétrospective

Le seul moment où l'humain est sollicité. Trois questions posées en un bloc :

1. Qu'est-ce qui s'est bien ou mal passé ?
2. Une action risquée que Claude Code aurait dû bloquer automatiquement ? *(→ `[HOOK_CANDIDATE]`)*
3. Quelque chose qui devrait changer le modèle SDLC lui-même ? *(→ `[SDLC_CANDIDATE]`)*

## Étape 2 — Lessons Learned

Une entrée de 5 lignes max dans `LESSONS_LEARNED.md`, avec les champs `[HOOK_CANDIDATE]` / `[SDLC_CANDIDATE]` seulement si l'Étape 1 les a produits. C'est l'entrée de la [boucle de rétroaction](#boucle).

## Étape 3 — Documentation

- **Obligatoire :** `CHANGELOG.md` (nouvelle entrée), `ROADMAP.md` (sprint déplacé en historique), `DIAGNOSTIC_CMDS.md` (commandes nouvelles), spec sprint (placeholders résiduels grepés).
- **Conditionnel :** `SPEC.md` si convention modifiée, `STANDARDS §Modules partagés` si fichier registre ±, répercussion dans les `.claude/skills/` si un template de skill a changé.
- **Nettoyage artefacts** auto-exécuté : marqueurs `[ ]`/`[À FAIRE]` cochés, décisions évoluées annotées d'un sous-bloc `→ Mise à jour`.

## Étapes 3.5 → 6

- **3.5 — Vérification pré-commit** : `git diff --stat`, checklist (version +0.1 cohérente, aucun sprint futur écrasé, zéro fichier hors portée).
- **4 — Commit** : format `type(module): résumé`, puis suppression de `sprint-memory.md` **après** le commit (jamais avant).
- **5 — Amorce session suivante** : bloc de contexte + écriture dans `SESSION_BRIDGE.md`, avec un **test STATELESS** — la session suivante peut-elle reprendre depuis ce seul fichier ?
- **6 — Sync Claude.ai** : reminder de synchroniser les fichiers de gouvernance (hors repo git).

## Pourquoi une séquence si stricte

Chaque étape ferme une porte par laquelle un sprint pourrait « fuir » sans laisser de trace : un bilan non fait, une leçon non capturée, un commit non conforme, une session suivante démarrée à froid. La rigidité de l'ordre est le prix de la garantie qu'**aucun sprint ne se termine à moitié**.
