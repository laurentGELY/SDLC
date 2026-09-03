# Le skill /retrospective

L'analyse de patterns sur plusieurs sprints. Là où `/wrap-up` clôt **un** sprint, `/retrospective` prend du recul sur **N** sprints — toutes les ~5 sprints, ou après un incident notable.

C'est l'étage d'analyse de la [boucle de rétroaction](#boucle).

---

## La procédure

- **Étape 1 — Chargement contexte.** Lecture de l'index `LESSONS_LEARNED §Index des patterns` et des entrées récentes. Chargement chirurgical : l'index d'abord, les entrées détaillées seulement si pertinentes.
- **Étape 2 — Analyse des patterns internes.** Détection des récurrences, aggravations et succès. Un `[HOOK_CANDIDATE]` vu ≥ 2 fois devient une proposition d'activation de hook.
- **Étape 2b — Significant Discovery Alert.** Cinq catégories `SD-1` → `SD-5` de découvertes significatives à signaler explicitement.
- **Étapes 3/4 — Actions.** Propositions d'actions internes (nouveaux hooks, règles) **et** remontées vers le modèle SDLC (synthèse des `[SDLC_CANDIDATE]` en attente → bloc de remontée manuelle).
- **Étape 5 — Index structuré des patterns.** Mise à jour de l'index avec les patterns confirmés/infirmés.

## Les deux circuits de remontée

`/retrospective` alimente deux destinations différentes :

- **Interne au projet** — un `[HOOK_CANDIDATE]` récurrent devient un hook bash ou une règle `Claude.md`. La boucle se ferme dans le projet lui-même.
- **Vers le modèle SDLC** — un `[SDLC_CANDIDATE]` propose de faire évoluer un template, une procédure ou un invariant du toolkit. La remontée est **manuelle et humaine** : elle n'est jamais automatique, car modifier le modèle affecte tous les projets qui en dérivent.

## Validation humaine

Aucune action n'est committée sans validation humaine. `/retrospective` **propose** — avec une destination explicite pour chaque proposition — mais c'est l'humain qui tranche. C'est cohérent avec l'esprit du modèle : les évolutions structurantes sont des décisions, pas des automatismes, et chacune laisse une trace (`M-XXXX-NN` ou `D-SYNC-XX`).

## Le rythme

Pourquoi ~5 sprints ? Trop tôt, il n'y a pas assez de matière pour distinguer un pattern d'un accident. Trop tard, les observations s'accumulent sans être exploitées et la boucle se distend. La cadence est un réglage, ajustable — et comme tout réglage du modèle, tracé si on le change.
