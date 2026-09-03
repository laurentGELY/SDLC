# Registre des décisions

`07-DECISIONS-SDLC.md` est le registre exhaustif des décisions structurantes prises sur le modèle **lui-même**. C'est la mémoire longue du toolkit : pourquoi telle règle existe, ce qui a été écarté, et sous quelle contrainte.

> C'est `INV-2` poussé à sa conséquence ultime : même les décisions *sur le modèle* sont explicites et tracées. Rien de ce qui structure le toolkit n'est resté dans une tête.

---

## Le format M-XXXX-NN

Chaque décision porte un identifiant stable, préfixé par famille :

| Préfixe | Domaine |
|---------|---------|
| `M-SCOPE-NN` | Périmètre du modèle (amont/aval, phase optionnelle…) |
| `M-PROC-NN` | Procédures (séquences de skill, cadences…) |
| `M-ARCH-NN` | Architecture (structure de fichiers, conventions…) |
| `M-HOOKS-NN` | Hooks (PreToolUse, PreCompact…) |
| `D-SYNC-NN` | Synchronisations de version appliquées à un projet |

Ces identifiants sont **citables** depuis n'importe quel fichier : une règle de `Claude.md` peut renvoyer à `M-PROC-28`, un template à `M-SCOPE-04`. La référence croisée est le tissu conjonctif du modèle.

## Quelques décisions structurantes

Pour donner le grain de ce que le registre contient :

- **`M-SCOPE-04`** — séparation amont (Claude.ai) / aval (Claude Code), zéro marqueur de provenance côté Claude Code. Fonde les [deux surfaces](#deux-surfaces).
- **`M-PROC-25`** — co-construction du PDR de synchronisation via `sdlc-delta.sh` pré-calculé. Fonde le workflow de [/sdlc-sync](#skill-autres).
- **`M-PROC-26`** — skill `/help` en lecture seule, zéro suggestion.
- **`M-HOOKS-08`** — hook `PreCompact` × mémoire de sprint, 7ᵉ type d'entrée `CHECKPOINT`. Voir [Hooks](#hooks).
- **`M-PROC-36`** — métriques de tokens `M1`/`M2` remontées dans `/retrospective`.

## La règle d'or d'évolution

Avant de modifier un fichier du toolkit, la checklist d'évolution impose :

- [ ] les invariants sont vérifiés, ou la violation est explicitement justifiée dans ce registre ;
- [ ] la version est incrémentée dans l'en-tête du fichier modifié ;
- [ ] une entrée `M-XXXX-NN` est ajoutée ;
- [ ] la décision est ajoutée au tableau de compatibilité (universelle / conditionnelle) ;
- [ ] `§Historique des versions` du README est à jour ;
- [ ] `specs/SPEC.md §Modules` est à jour si la carte a changé.

## Pourquoi tracer les décisions sur le modèle

Un modèle de gouvernance qui évolue sans mémoire finit par se contredire : une règle ajoutée aujourd'hui annule sans le savoir une règle posée il y a trois mois. Le registre `M-XXXX` empêche cette entropie. Il rend chaque évolution **redevable** de l'histoire — et c'est ce qui permet à `/sdlc-sync` de calculer un delta propre entre deux versions, plutôt qu'un écrasement aveugle.
