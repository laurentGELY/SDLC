# Flux complet

Du bootstrap à l'évolution du modèle, voici le chemin complet — vérifié contre l'état réel des templates (Sprint SDLC-13).

---

## Vue d'ensemble

```
[Optionnel] Project Claude.ai amont (10-AMONT-TEMPLATE.md)
        │  alimente specs/SPEC.md + premier PDR
        ▼
Sprint 0 — bootstrap (sdlc-init.sh + 06-PDR-bootstrap.md)
        │
        ▼
Claude.md gouverne chaque session (01-…§Démarrage)
        │
        ▼
Boucle de sprint :
   Analyse → Demande d'aval (verdict PASS/CONCERNS/FAIL)
           → Code → Test → /wrap-up
        │
        ▼
/wrap-up (03-…) :
   Étape 0 — bilan
     0a mémoire sprint → 0c ancrage git → 0d bilan structuré
     → 0e revue objectif → 0f Adversarial Review (si Taille M/L)
   Étape 1 — question rétrospective → Étape 2 — Lessons Learned
   Étape 3 — doc (CHANGELOG, nettoyage) → 3.5 vérif pré-commit
   Étape 4 — commit → Étape 5 — amorce session → Étape 6 — sync Claude.ai
        │  toutes les ~5 sprints ou incident
        ▼
/retrospective (09-…) :
   Étape 1 — chargement contexte → Étape 2 — analyse patterns
   Étape 2b — Significant Discovery Alert → Étape 3/4 — actions
   + remontées modèle SDLC → Étape 5 — index structuré
        │  quand le modèle SDLC évolue
        ▼
/sdlc-sync (04b-…) :
   delta version → application sélective → entrée D-SYNC-XX
```

## Lire ce flux

Trois boucles imbriquées, à trois fréquences différentes :

- **La boucle de sprint** (à chaque sprint) — Analyse → aval → code → test → wrap-up. C'est le rythme de base du travail. Voir [Le cycle de sprint](#cycle-sprint).
- **La boucle de rétrospective** (toutes les ~5 sprints) — analyse les patterns accumulés et fait remonter les évolutions. Voir [La boucle de rétroaction](#boucle).
- **La boucle de synchronisation** (quand le modèle évolue) — réaligne chaque projet sur la version courante du toolkit. Voir [/sdlc-sync](#skill-autres).

## Le point d'entrée : Claude.md §Démarrage

Chaque session Claude Code commence par une séquence fixe déclarée dans `Claude.md §Démarrage` : sync git, vérification de la mémoire de sprint, lecture de la référence architecturale, création du fichier spec du sprint, initialisation de la mémoire, chargement chirurgical du `§Handoff`, puis écriture du plan de développement **avant tout code**.

C'est cette séquence qui garantit qu'une session ne démarre jamais « à froid » : l'agent connaît toujours l'état du dépôt, le sprint actif et l'architecture avant d'agir.

## Vérifié, pas supposé

Ce diagramme n'est pas une intention : il a été confronté à l'état réel des fichiers `01-…§Démarrage`, `03-wrap-up` (étapes 0a-0f, 1-6) et `09-retrospective` (étapes 1-6, dont 2b) au moment de sa rédaction. C'est `INV-1` appliqué à la documentation elle-même — un cas de *dogfooding* assumé (Sprint SDLC-13).
