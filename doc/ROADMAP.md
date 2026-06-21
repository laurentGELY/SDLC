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
| P-30 — Hook PreCompact × sprint-memory.md (`specs/Sprints/sprint-SDLC-precompact-sprint-memory.md`) | Feature | S | P-28 | — | PDR rédigé, prêt à exécuter — voir fichier joint |

**Règle de passage Next → Now :** bloquants levés + spec rédigée ou rédigeable en < 30 min.

---

## 🗂 Later — Backlog

> Items identifiés mais non prioritaires ou bloqués.

| Item | Type | Taille | Débloque | Bloqué par | Déclencheur | Expiration |
|------|------|--------|----------|------------|-------------|------------|
| P-08 — Délégation par défaut (Extract, don't ingest) pour sprints L | Spike | S | — | Q1 stratégique (scope amont) | Si le scope du toolkit s'étend vers les phases amont — réévaluer le principe de délégation par défaut | — |
| P-15 — Architecture step-file (wrap-up / retrospective) | Refactor | S | — | Taille fichier | Si `03-wrap-up-SKILL-TEMPLATE.md` ou `09-retrospective-SKILL-TEMPLATE.md` dépasse ~500 lignes mesurées | — |
| P-16 — En-tête d'activation uniforme (6 étapes) | Doc | XS | — | Nouveau skill SDLC | Si un nouveau skill SDLC est créé au-delà de wrap-up / retrospective / sdlc-sync | — |
| P-17 — Dégradation gracieuse documentée (principe rédactionnel) | Doc | XS | — | Skill dépendant d'un script externe | Si un futur skill SDLC dépend d'un script externe (ex : `/diagnostic` outillé) | — |
| P-18 — Sharding `specs/SPEC.md` | Doc | XS | — | Taille SPEC.md | Si `specs/SPEC.md` d'un projet cible dépasse un seuil mesuré (ex : > 500 lignes) | — |
| P-19 — Séparation résumé/détail (roster-like) | Spike | S | — | Q4 stratégique (modes) | Si des "modes" sont formalisés dans `Claude.md §Rôle` (Q4) | — |
| P-21 — Revue mi-parcours par sous-agent dédié (sprints L) | Doc | S | — | Lecture de `code-reviewer.md` (Superpowers, non lu) | Si `code-reviewer.md` est consulté et confirme la pertinence du pattern pour `03-wrap-up-SKILL-TEMPLATE.md §Adversarial Review` | — |
| P-22 — `10-audit-externe-TEMPLATE.md` (gabarit générique de revue) | Doc | XS | — | Décision différée Sprint SDLC-19 | Si un 3e audit externe est commandé — évaluer alors si un gabarit générique apporte de la valeur vs un PDR ad-hoc par audit | — |
| P-23 — Résumé compressé auto-généré pour DECISIONS-SDLC.md (texte complet conservé, vue par défaut allégée) | Tuning | S | — | Mesure M3 réelle | ≥ 1 mesure M3 disponible | — |
| P-24 — Taille XS/S/M/L recalibrée avec coût token empirique + signal d'anomalie douce en /retrospective | Tuning | M | — | ≥ 5 sprints mesurés | sdlc-token-usage.sh actif sur ≥ 5 sprints | — |
| P-25 — Dry-run syntaxique de la commande de test avant §Plan d'exécution (4d) | Tuning | XS | — | — | Exécutable directement | — |
| P-26 — Aval unique par sprint (pas par sous-étape) + vérification batching active en §4a | Doc | XS | — | — | Durcissement direct de règle existante | — |
| P-27 — sprint-memory.md documenté explicitement comme mécanisme de reprise après pause tranche horaire | Doc | XS | — | P-30 (PreCompact) | Après exécution du sprint PreCompact | — |
| P-28 — Détection cache_creation anormal en milieu de session (signal expiration TTL liée au délai humain) | Feature | S | — | P-36 (script étendu) | Script de base en place | — |
| P-29 — Ligne de pacing informative en wrap-up §0d ("≈X% d'une tranche typique") — non bloquant | Tuning | S | — | Baseline tranche horaire | Plusieurs sessions mesurées | — |
| P-31 — Évaluer le Mode Plan natif (Shift+Tab) comme remplacement de §4d manuel | Spike | S | — | Vérification doc Claude Code | Interaction avec règle "aval explicite" confirmée | — |
| P-32 — Recommandation "prompt structuré" formalisée dans doc/MODE-OPERATOIRE.html | Doc | XS | — | — | Exécutable directement | — |
| P-33 — Vérification .gitignore ajoutée aux critères d'acceptation du Sprint 0 (06-PDR-bootstrap.md) | Doc | XS | — | — | Pour projets cibles avec code | — |
| P-34 — Calibrage empirique du seuil délégation sous-agent (>5 fichiers / >10K tokens) | Tuning | S | — | Données réelles | sdlc-token-usage.sh actif sur ≥ 5 sprints | — |
| P-35 — Réordonnancement Claude.md pour maximiser cache hit (stable en tête, volatile en fin) | Tuning | S | — | Mesure cache_read réelle | sdlc-token-usage.sh disponible sur ≥ 3 sprints | — |
| P-36 — Extension sdlc-token-usage.sh → package figé (diff + critères) pour Adversarial Review Couche 1 | Feature | S | — | Script de base validé | Sur un sprint Taille M/L réel | — |
| P-37 — 00-CONTEXT.md déclaré Index-guidé formellement (résorbe duplication invariants + carte fichiers) | Doc | S | — | — | Exécutable directement | — |

**Règle de passage Later → Next :** déclencheur atteint OU décision humaine explicite.
**Renumérotation au merge (wrap-up SDLC-22) :** les items "Sprint Lean" reçus sous P-20/P-21/P-22
collisionnaient avec des IDs déjà attribués à des items différents — renumérotés en P-35/P-36/P-37
sur confirmation explicite. P-30 attribué à l'item §Next "Hook PreCompact" (référencé tel quel par
P-27 dans le contenu reçu, préfixe manquant dans le texte source).

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
