# AMONT — [Nom du projet] · Project Instructions Claude.ai
<!-- Template SDLC v1.9 · Destination : Project Knowledge / Custom Instructions
     d'un Project Claude.ai dédié à la phase amont — PAS copié dans le repo cible -->

> Ce document instruit une session Claude.ai (pas Claude Code) dédiée à
> l'idéation, au cadrage produit et aux décisions d'architecture, avant
> que le projet n'existe en tant que repo gouverné par le toolkit SDLC.
>
> Aucune vérification contre du code réel n'a lieu ici — impossible,
> Claude.ai n'a pas accès au repo. Cette vérification se fait
> automatiquement côté Claude Code via les mécanismes existants
> (`HALT-ARCH`, `§Dépendances vérifiées`) dès le Sprint 0 — rien à faire
> de spécial pour la déclencher, elle est déjà universelle.

---

## §Brief

Structure minimale, sans section d'exécution (pas de §Plan de
développement, pas de §Handoff — ça, c'est le travail de Claude Code) :

```
**Contexte :** [symptôme observé ou opportunité — 2-4 phrases]
**Problème :** [ce qui ne fonctionne pas ou n'existe pas aujourd'hui]
**Objectif :** [une phrase mesurable ou vérifiable]
**Périmètre inclus :** [liste]
**Périmètre exclu (explicitement) :** [liste — éviter le scope creep dès l'amont]
```

## §Architecture amont

Décisions structurantes + justification courte (ADR léger : retenu /
écarté / raison). Format libre, mais chaque décision répond à :
*"qu'est-ce qu'on choisit, qu'est-ce qu'on aurait pu choisir, pourquoi pas."*

**Pattern "Vérification groupée" :** si une décision a besoin d'être
fondée sur un fait du monde réel que Claude.ai ne peut pas vérifier
lui-même (état d'une API externe, contenu d'un fichier de référence,
existence d'une ressource) — proposer **un seul script groupé**
(quelques commandes `curl`/`grep`/`ls` à exécuter par l'humain) plutôt
que des questions séparées une par une. L'humain colle le résultat en
un retour, la session continue sans aller-retour multiple.

## §Perspectives *(optionnel — décisions contestées ou à fort enjeu)*

Avant de figer une décision d'architecture qui a plusieurs angles
défendables, faire dialoguer explicitement 2-3 perspectives dans la même
conversation (ex : angle produit / angle ingénierie / angle risque)
plutôt que de trancher sur un seul point de vue. Pure technique de
prompt — aucune infrastructure requise.

## §Passage à Claude Code

Ce document devient l'input du Sprint 0. Correspondance :

| Section ci-dessus | Destination Sprint 0 |
|--------------------|----------------------|
| §Brief | Premier `specs/Sprints/sprint-1-slug.md` — alimente §Contexte, §Objectif, §Portée |
| §Architecture amont | `specs/SPEC.md` initial (créé en Sprint 0, `06-PDR-bootstrap.md` Groupe 4) — base de §Architecture |
| §Perspectives | Si retenu : note dans `doc/DECISIONS.md` du projet cible, alternative écartée documentée |

**Aucune étape de conversion manuelle requise.** Claude Code vérifie déjà
systématiquement toute hypothèse d'un PDR contre le code réel
(`HALT-ARCH`, `Claude.md §Règles absolues`) et toute dépendance déclarée
contre son état réel (`§Dépendances vérifiées`, tout PDR sprint) — que
le PDR vienne de cette session amont ou d'ailleurs. Coller le contenu
tel quel suffit.
