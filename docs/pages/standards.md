# Standards : DoD, types, tests

`STANDARDS.md` est la **référence technique permanente** du dépôt — complémentaire de `Claude.md`, sans workflow de sprint. Il répond à une question : *qu'est-ce qui définit un travail « terminé » ici ?*

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

## Règles d'archivage

- **`DIAGNOSTIC_CMDS.md`** — toute commande `grep`/`diff`/`git` ayant localisé ou résolu un problème est archivée avant le wrap-up, avec symptôme, date, commande exacte, résultat observé et conclusion.
- **Fichiers de configuration** — toute modification note la valeur précédente dans le commit, et crée une entrée `DECISIONS` si le choix n'est pas trivial.

## L'idée de fond

`STANDARDS.md` transforme « terminé » d'une impression en une **checklist vérifiable**. C'est `INV-1` appliqué à la notion même d'achèvement : on ne *déclare* pas un travail fini, on *démontre* qu'il coche chaque case — grep à l'appui.
