# STANDARDS.md — [Nom du projet] · v1.0
<!-- Template SDLC v1.9 · Copier dans le repo cible · Adapter les sections marquées [→ ADAPTER] -->
<!-- SDLC version : v1.9 · aligné le JJ/MM/AAAA -->
<!-- Absence de ce marqueur = projet antérieur au modèle SDLC générique · voir sdlc-init.sh et doc/MODE-OPERATOIRE.html -->

> Référence technique permanente du dépôt.
> Complémentaire à `Claude.md` — ne contient pas de workflow de sprint.
> Mettre à jour dans le même commit que tout changement architectural.

---

## Definition of Done

### Livrable
- Critères d'acceptation de la spec : passés ou N/A justifié
- Aucun fichier hors portée dans le diff (`git diff --stat`)
- Tests exécutés et passés, ou N/A justifié (niveau A systématique, B si module partagé touché, C si risque élevé)
- CHANGELOG, DECISIONS.md, STANDARDS.md mis à jour si impactés

### Clôture
- `/wrap-up` terminé (Lessons Learned + CHANGELOG + ROADMAP + commit)
- Commit conforme : `type(module): résumé court` + liste de changements + résultat tests
- Reminder sync fichiers projet Claude.ai déclenché

---

## Types de sprint

| Type | Description | Output attendu |
|------|-------------|----------------|
| **Feature** | Nouvelle fonctionnalité | Code + tests + doc |
| **Fix** | Correction de bug ou régression | Code corrigé + test non-régression |
| **Tuning** | Seuils, prompts, paramètres | Mesure avant/après + décision DECISIONS.md |
| **Doc** | Documentation, process, SDLC | Fichiers doc mis à jour, zéro code |
| **Revue** | Audit, backlog — lecture et recommandations sans modification du livrable audité | Recommandations étiquetées (ex: IMPORTER/REJETER) + `/wrap-up`, zéro fichier de gouvernance modifié |
| **Spike** | Investigation bornée dans le temps | Décision dans DECISIONS.md (pas du code) |
| **Dette** | Remboursement dette technique | Code nettoyé + test de non-régression |
| **SDLC-Sync** | Alignement sur une version plus récente du modèle SDLC | Marqueur de version à jour + D-SYNC-XX dans DECISIONS.md |

**Revue vs Spike :** une Revue audite un livrable existant et produit des recommandations
sur celui-ci (le livrable audité n'est jamais modifié dans le même sprint) ; un Spike
investigue une question ouverte et produit une décision sur la suite à donner (rien
n'est audité, aucun livrable n'existe encore sur le sujet investigué).

**Spike :** output = décision documentée, jamais du code partiel. Durée bornée définie dans la spec.

**SDLC-Sync :** output = gouvernance alignée sur la version SDLC courante. Tests : N/A (zéro code métier). Exécuter via le skill `/sdlc-sync` dans Claude Code. Voir `doc/MODE-OPERATOIRE.html` §Mettre à jour un projet existant.

---

## Niveaux de test

| Niveau | Quand obligatoire | Forme | Critère OK |
|--------|------------------|-------|------------|
| **A — Ciblé** | Systématique | Commande exacte sur le module modifié | Résultat attendu, zéro erreur |
| **B — Non-régression** | Module partagé touché | Vérification des consommateurs | Comportement identique à avant |
| **C — Intégration** | Risque élevé, changement architectural | Run complet du système | Output valide de bout en bout |

**Anti-faux-positif niveau A sur pipeline :** un test A est invalide si le corpus d'entrée contient zéro items traités — vérifier le compteur de sortie, pas seulement exit 0. Définir la condition dans `**Volumétrie minimum :**` du PDR sprint si applicable.

<!-- [→ ADAPTER] Ajouter des niveaux spécifiques si pertinent (ex: golden set, snapshot) -->

---

## Modules partagés

<!-- [→ REMPLIR au fur et à mesure — vide au bootstrap] -->
> Lister ici tout module importé par ≥ 2 autres modules.
> Mettre à jour dans le même commit qu'un ajout/suppression/renommage de module.

| Module | Rôle | Importé par |
|--------|------|-------------|
| — | — | — |

**Règle :** toute modification d'un module partagé → niveau B obligatoire + mise à jour de cette table dans le même commit.

**Déclencheur DEPENDENCY_MAP :** si un module partagé est ajouté, supprimé ou renommé → régénérer `doc/DEPENDENCY_MAP.md` dans le même commit.

---

## Observabilité

<!-- [→ ADAPTER] Adapter les questions à la nature du système -->

**Règle :** toute nouvelle étape du pipeline doit émettre une trace de début, de fin et d'erreur. Sans ces marqueurs, l'étape est invisible au diagnostic en cas de crash.

### Checklist Q/R — à compléter au bootstrap · zéro placeholder avant le commit initial

Q: Quel marqueur de log indique qu'une étape a démarré ?
→ R: [À REMPLIR] *(ex: "[START] nom_etape run_id=...")*

Q: Quel marqueur indique qu'elle est terminée avec succès ?
→ R: [À REMPLIR] *(ex: "[DONE] nom_etape items=N duration=Xs")*

Q: Quel marqueur indique une erreur non fatale (avertissement) ?
→ R: [À REMPLIR] *(ex: "[WARN] description item_id=...")*

Q: Quelle commande affiche les N dernières lignes de log en prod ?
→ R: [À REMPLIR] *(ex: "tail -100 logs/pipeline.log | grep RUN_ID")*

Q: Comment vérifier qu'aucun item n'a été silencieusement ignoré ?
→ R: [À REMPLIR] *(ex: "grep 'items_skipped=[^0]' logs/pipeline.log")*

Grep de validation au bootstrap : `grep "\[À REMPLIR\]" STANDARDS.md` → zéro résultat attendu.

### Distinction déterministe / LLM (si applicable)

| Tâche | Responsable |
|-------|-------------|
| Compter, filtrer, corréler, classer | Déterministe uniquement |
| Synthétiser, expliquer, prioriser | LLM |
| Contradiction entre les deux | Déterministe gagne |

---

## Carte des étapes système

<!-- [→ REMPLIR dès sprint 1 — vide au bootstrap] -->
> Carte validée sur code réel. Mettre à jour à chaque changement de marqueur de log.

```
# Format : ("marqueur log", "checkpoint_id", "fichier_source")
[À compléter après le premier sprint fonctionnel]
```

---

## Règles d'archivage

### doc/DIAGNOSTIC_CMDS.md
Toute commande `grep / tail / python3 / etc.` ayant localisé ou résolu un problème
→ archivée avant le wrap-up.

Format :
```
## Symptôme : <description>
Date : JJ/MM/AAAA
Commande : <commande exacte>
Résultat observé : <ce qu'on a vu>
Conclusion : <ce que ça a confirmé ou infirmé>
```

### Fichiers de configuration
Toute modification d'un fichier de config :
- Valeur précédente notée dans le commit
- Entrée dans `doc/DECISIONS.md` si décision non triviale
