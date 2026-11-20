# Standards : DoD, types, tests

`STANDARDS.md` est la **référence technique permanente** du dépôt — complémentaire de `CLAUDE.md`, sans workflow de sprint. Il répond à une question : *qu'est-ce qui définit un travail « terminé » ici ?*

---

## Definition of Done

Un livrable est « fait » quand :

- les critères d'acceptation de la spec sont passés (ou N/A justifié) ;
- aucun fichier hors portée n'apparaît dans le diff (`git diff --stat`) ;
- le **niveau A** (critères du PDR vérifiés par grep) est systématique ;
- le **niveau B** est fait si la modification touche un fichier registre central (références croisées cohérentes) ;
- `CHANGELOG`, `DECISIONS`, `STANDARDS` sont à jour si impactés.

Et la clôture est complète quand `/wrap-up` est terminé (Lessons Learned + CHANGELOG + ROADMAP + commit), le commit est conforme, et le reminder de sync Claude.ai est déclenché.

## Les niveaux de test

| Niveau | Quand obligatoire | Forme | Critère OK |
|--------|-------------------|-------|------------|
| **A — Ciblé** | Systématique | `grep`/`diff` exact sur le critère du PDR | Résultat attendu, zéro erreur |
| **B — Cohérence registre** | Fichier registre touché | Vérifier les références croisées | Aucune référence cassée |
| **C — Intégration** | Selon projet | Run complet | Système intègre sans régression |

Dans un projet de gouvernance de templates (comme le toolkit lui-même), le niveau C est souvent N/A — il n'y a pas de système exécutable, seulement des fichiers markdown dont l'état s'observe par `git diff`/`git log`.

## Les modules partagés

Le cœur de la discipline `STANDARDS` : lister tout fichier référencé par ≥ 2 autres comme registre central. Toute modification de l'un d'eux déclenche un **niveau B obligatoire** et une mise à jour de cette table, dans le même commit.

Exemple, pour le toolkit lui-même : `07-DECISIONS-SDLC.md` (référencé par tout PDR de gouvernance) et `00-CONTEXT.md` (la carte des fichiers).

## La barre qualité

Le template `02-STANDARDS-TEMPLATE.md` porte une section **§Barre qualité** (`M-PROC-42`), construite sur la même règle que le reste : *un chiffre sans commande de vérification est une aspiration, pas une contrainte* (`INV-1`). Elle a quatre blocs :

- **Seuils** — un tableau `Dimension / Règle / Vérifié par / S'exécute à`, complété au bootstrap (zéro placeholder avant le commit initial).
- **Plancher** — non négociable, sans configuration : aucun commentaire de suppression nouveau (`@ts-ignore`, `# noqa`…), aucun stub livré comme fini, aucun test sauté sans raison au commit, aucun secret en source. Affaiblir un seuil ou le plancher (seuil baissé, suppression ajoutée, test retiré) passe par la table d'exceptions, jamais par une modification silencieuse.
- **Cliquet** — pour les dimensions sans seuil évident : mesurer la valeur du jour et tenir la ligne. Exemple fourni : le contexte permanent (M1, `wc -w CLAUDE.md STANDARDS.md`) ne croît pas de plus de 10 % entre deux `/retrospective`. Le gabarit `CLAUDE.md` livré par le modèle a, lui, un plafond absolu : le contrôle C11 de `sdlc-validate.sh` mesure le fichier produit par `sdlc-init.sh` et bloque toute croissance (`M-PROC-49`).
- **Exceptions** — une dérogation est une ligne datée avec propriétaire et date d'expiration, jamais un `# noqa` anonyme.

Cette règle n'est énoncée qu'ici : ELAG-4 l'a retirée de `CLAUDE.md`, où elle faisait doublon. `STANDARDS.md` n'étant importé par aucun fichier, elle ne fait pas partie du contexte chargé à chaque session (risque accepté par ELAG-4, `M-PROC-42`, à surveiller en rétrospective).

## Règles d'archivage

- **`DIAGNOSTIC_CMDS.md`** — toute commande `grep`/`diff`/`git` ayant localisé ou résolu un problème est archivée avant le wrap-up, avec symptôme, date, commande exacte, résultat observé et conclusion.
- **Fichiers de configuration** — toute modification note la valeur précédente dans le commit, et crée une entrée `DECISIONS` si le choix n'est pas trivial.

## L'idée de fond

`STANDARDS.md` transforme « terminé » d'une impression en une **checklist vérifiable**. C'est `INV-1` appliqué à la notion même d'achèvement : on ne *déclare* pas un travail fini, on *démontre* qu'il coche chaque case — grep à l'appui.
