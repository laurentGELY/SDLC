# /sdlc-sync, /diagnostic, /help

Trois skills utilitaires qui complètent `/wrap-up` et `/retrospective`.

---

## /sdlc-sync — aligner sur une version plus récente

Quand le modèle SDLC évolue, les projets qui en dérivent portent un marqueur de version antérieur. `/sdlc-sync` calcule le **delta** entre la version du projet et la version courante du toolkit, puis l'applique **sélectivement** — sans écraser le réglage local.

```
delta version  →  application sélective  →  entrée D-SYNC-XX
```

Le point délicat : un projet a souvent *tuné* ses templates (adapté `§Rôle`, `§Limites bash`, ajouté des règles). Une synchronisation brutale détruirait ce travail. `/sdlc-sync` distingue donc ce qui vient du modèle (à mettre à jour) de ce qui est du réglage local (à préserver).

**Co-construction recommandée** (`M-PROC-25`) : lancer `sdlc-delta.sh <chemin-projet>` en local pour pré-calculer le delta, puis faire construire le PDR de synchronisation dans Claude.ai avant de l'exécuter dans Claude Code. La synchronisation n'est jamais automatique — c'est une **décision humaine au cas par cas**.

## /diagnostic — sur incident

Déclenché sur un bug ou un comportement inattendu, et automatiquement par la condition `HALT-3X` (même test échoué 3 fois). Le skill impose une démarche ancrée sur la preuve, cohérente avec les principes anti-biais de `Claude.md` :

- ancrer sur une preuve observable **avant** de théoriser — jamais l'inverse ;
- traiter la description de l'utilisateur comme une hypothèse à vérifier, pas comme un fait de départ ;
- si une preuve contredit la théorie en cours → mettre à jour la théorie, jamais minimiser la preuve.

Toute commande ayant localisé ou résolu un problème est archivée dans `DIAGNOSTIC_CMDS.md` — une base de connaissances de diagnostic qui grossit avec le projet.

## /help — recap en reprise de session

Un skill **lecture seule, zéro suggestion** (`M-PROC-26`). En reprise de session, il produit un recap de « où on en est / où on va / quels outils sont disponibles » à partir de trois sources : `.claude/sprint-memory.md`, `docs/ROADMAP.md §Now/§Next`, et la classification du travail dans `Claude.md`.

Sa contrainte définissante : il **ne suggère rien**. Il expose l'état, sans proposer d'action. C'est délibéré — le recap doit être un miroir neutre du contexte, pas un moteur de décisions qui biaiserait la reprise.

## Le fil commun

Ces trois skills partagent la philosophie du modèle. `/sdlc-sync` préserve le réglage local plutôt que d'imposer. `/diagnostic` ancre sur la preuve plutôt que sur l'intuition. `/help` expose plutôt que de suggérer. Chacun, à sa manière, refuse l'implicite — c'est `INV-2` décliné en outils.
