# SDLC Toolkit

Un **harnais de gouvernance** reproductible pour les agents — concrètement, pour les projets pilotés par **Claude Code**.

Là où un SDLC classique décrit les *phases* d'un projet logiciel, ce modèle gouverne autre chose : **la façon dont un agent exécute le travail**. C'est de l'*agentic SDLC* — de l'ingénierie de harnais (*harness engineering*) : le cadre de règles, de garde-fous et de mémoire qu'on met autour du modèle pour le rendre fiable, reproductible et perfectible.

Bootstrapper un nouveau projet, aligner un projet existant, faire évoluer le modèle — avec des règles d'exécution permanentes, des skills de clôture et une boucle de rétroaction qui transforme chaque incident terrain en règle durable.

> **Version courante : v2.0+SDLC-31** · Un harnais de templates numérotés `01` → `12`, dont la plupart sont copiés dans un projet cible pour lui donner un cadre d'exécution complet.

Les [quatre invariants](#invariants) qui fondent le modèle sont, au fond, quatre principes de conception de harnais : boucle de contrôle vérifiable (INV-1), zéro état implicite (INV-2), budget de contexte (INV-3), et un harnais qui apprend (INV-4).

---

## Le problème

Piloter un projet avec un agent comme Claude Code, c'est vite se heurter à trois dérives :

- **L'implicite** — l'agent applique des comportements non écrits ; personne ne sait pourquoi une session diffère de la précédente.
- **Le contexte qui déborde** — charger « tout le repo pour être sûr » sature la fenêtre et dégrade la qualité.
- **L'oubli** — un incident résolu aujourd'hui se reproduit dans trois sprints, faute de trace exploitable.

Le SDLC Toolkit répond à ces trois dérives par un cadre : des fichiers permanents que l'agent lit à chaque session, des points d'arrêt explicites, et un circuit qui remonte toute observation vers une règle.

## Ce que ça donne concrètement

Un projet gouverné par ce toolkit possède :

- Un **`Claude.md`** — les règles permanentes d'exécution (rôle, limites, workflow, points d'arrêt `HALT`).
- Un skill **`/wrap-up`** — clôture chaque sprint en une séquence stricte : bilan → rétrospective → doc → commit.
- Un skill **`/retrospective`** — détecte les patterns récurrents et propose de nouveaux hooks ou règles.
- Un skill **`/sdlc-sync`** — aligne le projet sur une version plus récente du modèle sans écraser le réglage local.
- Une **boucle de rétroaction terrain** : incident → `LESSONS_LEARNED` → `/retrospective` → hook ou règle permanente.

## Par où commencer

Ce site suit trois niveaux de lecture. Restez en surface, ou suivez les liens pour aller au fond.

- **Niveau 1 — comprendre.** [Les quatre invariants](#invariants) fondent tout le modèle. [Démarrage rapide](#demarrage) pour l'installer.
- **Niveau 2 — le fonctionnement.** [Deux surfaces](#deux-surfaces), [la boucle de rétroaction](#boucle), [le cycle de sprint](#cycle-sprint), [le contexte chirurgical](#contexte).
- **Niveau 3 — la référence.** [Les skills](#skill-wrapup) en détail, le [catalogue des templates](#templates), le [registre des décisions](#decisions).

À la fin, un projet passe de « l'agent fait de son mieux » à « l'agent suit un contrat vérifiable, et le contrat s'améliore à chaque sprint ».
