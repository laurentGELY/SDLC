# ROADMAP — SDLC Toolkit · v1.0

---

## ▶ Now — Sprint actif

| Item | Type | Taille | Statut |
|------|------|--------|--------|
| — | — | — | — En attente |

**Règle :** un seul item actif à la fois dans §Now.

---

## ⏭ Next — Prêt à démarrer

> Items dont les bloquants sont levés et le périmètre est défini.
> Peut démarrer dès que §Now est terminé.

| Item | Type | Taille | Débloque | Bloqué par | Déclencheur |
|------|------|--------|----------|------------|-------------|
| P-20 — Hook SessionStart (injection auto Règles absolues + HALT) | Doc | M | LL-T05 (garde-fou démarrage) | — | Aucun — prêt à démarrer dès qu'une session le priorise. Impact reclassé **Moyen** (initialement Élevé en audit SDLC-17) : `M-HOOKS-04` (Sprint SDLC-18) couvre déjà le pire cas observé (omission étape 4a) par un mécanisme indépendant. **Note de séquencement :** ne pas dupliquer les tables de rationalisation HALT écrites Sprint SDLC-19 (`01-Claude-md-TEMPLATE.md`, déjà chargées en permanence) — réinjecter seulement les noms de règles/HALT et leur condition de déclenchement |

**Règle de passage Next → Now :** bloquants levés + spec rédigée ou rédigeable en < 30 min.

---

## 🗂 Later — Backlog

> Items identifiés mais non prioritaires ou bloqués.

| Item | Type | Taille | Débloque | Bloqué par | Déclencheur |
|------|------|--------|----------|------------|-------------|
| P-08 — Délégation par défaut (Extract, don't ingest) pour sprints L | Spike | S | — | Q1 stratégique (scope amont) | Si le scope du toolkit s'étend vers les phases amont — réévaluer le principe de délégation par défaut |
| P-15 — Architecture step-file (wrap-up / retrospective) | Refactor | S | — | Taille fichier | Si `03-wrap-up-SKILL-TEMPLATE.md` ou `09-retrospective-SKILL-TEMPLATE.md` dépasse ~500 lignes mesurées |
| P-16 — En-tête d'activation uniforme (6 étapes) | Doc | XS | — | Nouveau skill SDLC | Si un nouveau skill SDLC est créé au-delà de wrap-up / retrospective / sdlc-sync |
| P-17 — Dégradation gracieuse documentée (principe rédactionnel) | Doc | XS | — | Skill dépendant d'un script externe | Si un futur skill SDLC dépend d'un script externe (ex : `/diagnostic` outillé) |
| P-18 — Sharding `specs/SPEC.md` | Doc | XS | — | Taille SPEC.md | Si `specs/SPEC.md` d'un projet cible dépasse un seuil mesuré (ex : > 500 lignes) |
| P-19 — Séparation résumé/détail (roster-like) | Spike | S | — | Q4 stratégique (modes) | Si des "modes" sont formalisés dans `Claude.md §Rôle` (Q4) |
| P-21 — Revue mi-parcours par sous-agent dédié (sprints L) | Doc | S | — | Lecture de `code-reviewer.md` (Superpowers, non lu) | Si `code-reviewer.md` est consulté et confirme la pertinence du pattern pour `03-wrap-up-SKILL-TEMPLATE.md §Adversarial Review` |
| P-22 — `10-audit-externe-TEMPLATE.md` (gabarit générique de revue) | Doc | XS | — | Décision différée Sprint SDLC-19 | Si un 3e audit externe est commandé — évaluer alors si un gabarit générique apporte de la valeur vs un PDR ad-hoc par audit |

**Règle de passage Later → Next :** déclencheur atteint OU décision humaine explicite.

---

## §Seuils métriques déclencheurs

> Seuils quantitatifs qui font passer un item Later → Next automatiquement.
> À définir après le premier sprint de mesure.

- À définir

---

## §Signaux faibles

> Canal informel pour idées non matures. Max 5 lignes.
> Critère de passage vers §Later : idée assez concrète pour écrire un contexte de 3 phrases.

---

## Tailles de référence

| Taille | Durée estimée | Exemples |
|--------|--------------|---------|
| XS | < 1h | Correction config, ajout d'une règle doc |
| S | 1-3h | Nouveau parseur simple, ajout d'un champ |
| M | 3h-1j | Nouveau module, refactor ciblé, audit |
| L | > 1j | Refonte architecture, nouveau pipeline |

---

## Historique — Sprints complétés

<!-- Déplacer ici les sprints terminés depuis §Now, avec leur tableau de livrables -->

*(vide au bootstrap du toolkit)*
