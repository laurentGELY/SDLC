# STANDARDS.md — [Nom du projet] · v1.0
<!-- Template SDLC v1.0 · Copier dans le repo cible · Adapter les sections marquées [→ ADAPTER] -->

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
| **Spike** | Investigation bornée dans le temps | Décision dans DECISIONS.md (pas du code) |
| **Dette** | Remboursement dette technique | Code nettoyé + test de non-régression |

**Spike :** output = décision documentée, jamais du code partiel. Durée bornée définie dans la spec.

---

## Niveaux de test

| Niveau | Quand obligatoire | Forme | Critère OK |
|--------|------------------|-------|------------|
| **A — Ciblé** | Systématique | Commande exacte sur le module modifié | Résultat attendu, zéro erreur |
| **B — Non-régression** | Module partagé touché | Vérification des consommateurs | Comportement identique à avant |
| **C — Intégration** | Risque élevé, changement architectural | Run complet du système | Output valide de bout en bout |

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

<!-- [→ ADAPTER] Ajuster selon la nature du système -->

### Règle fondamentale
Toute nouvelle étape du système doit émettre :
- Message d'entrée avec identifiant d'étape
- Message de fin avec compteur et durée
- Heartbeat si durée probable > 30s

Sans ces événements, l'étape est invisible au diagnostic en cas de crash.

### Format de log recommandé
```
YYYY-MM-DD HH:MM:SS LEVEL [run_id] module.etape message
```

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
