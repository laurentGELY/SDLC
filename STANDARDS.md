# STANDARDS.md — Projet toolkit SDLC · v1.0
<!-- Adapté depuis 02-STANDARDS-TEMPLATE.md (SDLC v1.9) · Sprint SDLC-14 (self-bootstrap) -->
<!-- SDLC version : v1.9 · aligné le 19/06/2026 -->

> Référence technique permanente du dépôt.
> Complémentaire à `Claude.md` — ne contient pas de workflow de sprint.
> Mettre à jour dans le même commit que tout changement architectural.

---

## Definition of Done

### Livrable
- Critères d'acceptation de la spec : passés ou N/A justifié
- Aucun fichier hors portée dans le diff (`git diff --stat`)
- Niveau A = critères d'acceptation du PDR vérifiés par grep, systématique.
  Niveau B = si la modification touche un fichier référencé par plusieurs
  autres comme registre central (`07-DECISIONS-SDLC.md`, `00-CONTEXT.md`),
  vérifier la cohérence des références croisées. Pas de niveau C (pas
  d'intégration système au sens logiciel).
- CHANGELOG, `07-DECISIONS-SDLC.md`, STANDARDS.md mis à jour si impactés

### Clôture
- `/wrap-up` terminé (Lessons Learned + CHANGELOG + ROADMAP + commit)
- Commit conforme : `type(module): résumé court` + liste de changements + résultat tests
- Reminder sync fichiers projet Claude.ai déclenché

---

## Types de sprint

| Type | Description | Output attendu |
|------|-------------|----------------|
| **Doc** | Documentation, process, gouvernance du modèle | Fichiers `.md` mis à jour |
| **Spike** | Investigation bornée dans le temps | Décision dans `07-DECISIONS-SDLC.md` |
| **Feature** | Nouvelle convention/section ajoutée au modèle | Fichiers template mis à jour + doc |
| **Fix** | Correction d'une incohérence du modèle | Fichier corrigé + grep de non-régression |
| **Tuning** | Ajustement d'une règle existante (seuils, formulation) | Avant/après + décision `07-DECISIONS-SDLC.md` |
| **Dette** | Nettoyage de gouvernance (doublons, fichiers obsolètes) | Fichiers nettoyés + grep de non-régression |

Doc et Spike dominent dans ce projet — pas de code applicatif. Les autres
types restent valides quand un script (`sdlc-init.sh`, `sdlc-delta.sh`,
`sdlc-project-check.sh`) est modifié.

**Spike :** output = décision documentée, jamais un template partiel. Durée bornée définie dans la spec.

---

## Niveaux de test

| Niveau | Quand obligatoire | Forme | Critère OK |
|--------|------------------|-------|------------|
| **A — Ciblé** | Systématique | `grep`/`diff` exact sur le critère d'acceptation du PDR | Résultat attendu, zéro erreur |
| **B — Cohérence registre** | Fichier référencé par plusieurs autres (`07-DECISIONS-SDLC.md`, `00-CONTEXT.md`) touché | Vérifier les références croisées | Aucune référence cassée |
| **C — Intégration** | N/A | — | — *(pas de système exécutable dans ce projet)* |

---

## Modules partagés

> Lister ici tout fichier référencé par ≥ 2 autres fichiers comme registre
> central ou carte de référence.

| Fichier | Rôle | Référencé par |
|---------|------|----------------|
| `07-DECISIONS-SDLC.md` | Registre des décisions structurantes du modèle | Tout PDR de gouvernance, `Claude.md §Rôle` |
| `00-CONTEXT.md` | Carte des fichiers du projet toolkit | Bootstrap, `sdlc-sync`, sprints d'audit |

**Règle :** toute modification d'un de ces fichiers → niveau B obligatoire + mise à jour de cette table dans le même commit.

---

## Observabilité

N/A — projet de gouvernance de templates, pas de pipeline en production.
Aucune trace de log à émettre : les seuls artefacts sont des fichiers
markdown versionnés dans git, dont l'état s'observe par `git diff`/`git log`.

---

## Règles d'archivage

### doc/DIAGNOSTIC_CMDS.md
Toute commande `grep`/`diff`/`git` ayant localisé ou résolu un problème
de cohérence du modèle → archivée avant le wrap-up.

Format :
```
## Symptôme : <description>
Date : JJ/MM/AAAA
Commande : <commande exacte>
Résultat observé : <ce qu'on a vu>
Conclusion : <ce que ça a confirmé ou infirmé>
```

### Fichiers de configuration
Toute modification d'un fichier de config (`.claude/settings.json`,
`.claude/hooks/*`) :
- Valeur précédente notée dans le commit
- Entrée dans `07-DECISIONS-SDLC.md` si décision non triviale
