# Sprint — Audit externe Strands Harness vs SDLC
<!-- Destination : specs/Sprints/sprint-audit-strands-harness.md dans le repo SDLC -->
<!-- Précédent direct : specs/Sprints/sprint-audit-gsd-lite.md (même type de sprint, même format à reproduire) -->

**Type :** Revue
**Taille :** S (< 3h)
**Surface :** `doc/` (nouveau fichier) — zéro template (`01` à `11`) modifié dans ce sprint
**Risque :** Faible

---

## Contexte

Un avis externe a été soumis sur Strands Agents / **Strands Harness** (SDK open source AWS,
Apache 2.0, harness annoncé le 21/09/2026). Une première analyse en session Claude.ai a
identifié trois pistes de comparaison concrètes avec le modèle SDLC (gestion de contexte,
mécanisme de session, hooks/lifecycle), et une clarification structurante : Strands Harness
est une couche **runtime** (boucle agent, comparable à Claude Code lui-même), alors que SDLC
est une couche **gouvernance/process** posée par-dessus un runtime existant — la comparaison
est donc partielle par construction, comme cela avait déjà été conclu pour GSD-lite
(« framework orthogonal », `doc/AUDIT-EXTERNE-gsd-lite-vs-sdlc.md`).

Ce sprint formalise cette analyse en Revue bornée, pour produire des recommandations tracées
plutôt qu'une impression de conversation.

---

## Objectif

Produire `doc/AUDIT-EXTERNE-strands-harness-vs-sdlc.md` avec au moins 3 recommandations
étiquetées IMPORTER / ADAPTER / REJETER, chacune reliée à un fichier SDLC précis, et pour
toute recommandation IMPORTER, une proposition d'entrée `DECISIONS-SDLC.md` rédigée (non
committée dans ce sprint).

---

## Comportement actuel → cible

- **Actuel :** aucune trace de Strands Agents dans le modèle SDLC. `§Observabilité` de
  `02-STANDARDS-TEMPLATE.md` contient des `[À REMPLIR]` sans référentiel externe pour les
  qualifier. `SESSION_BRIDGE` (`03-wrap-up-SKILL-TEMPLATE.md §Étape 5`) n'a jamais été
  comparé à un mécanisme de session natif d'un autre framework.
- **Cible :** un audit externe documenté et daté, verdict explicite sur la distinction
  runtime/gouvernance, recommandations tracées et prêtes pour un éventuel sprint d'import
  ultérieur.

---

## Portée

**Inclus :**
- Lecture ciblée de 2-3 sources externes précises (liste dans `§Handoff`)
- Comparaison avec : `INV-3` (`00-CONTEXT.md`), `§Observabilité` (`02-STANDARDS-TEMPLATE.md`),
  `SESSION_BRIDGE` (`03-wrap-up-SKILL-TEMPLATE.md §Étape 5`), `08-hooks-TEMPLATE.md`
- Rédaction de `doc/AUDIT-EXTERNE-strands-harness-vs-sdlc.md`, même structure que
  `doc/AUDIT-EXTERNE-gsd-lite-vs-sdlc.md`
- Si retenu : texte de proposition d'entrée `DECISIONS-SDLC.md` (rédigé dans l'audit, pas commité)

**Exclu (explicitement) :**
- Toute modification effective des templates `01` à `11` — réservée à un sprint « Import »
  ultérieur si décidé, sur le modèle de `M-PROC-38` (import GSD Vague 1)
- Le reste du site Strands (déploiement AWS, patterns multi-agents swarm/graph, robotique,
  support multi-provider) — hors périmètre gouvernance, SDLC est zéro code métier
- Vérification indépendante des chiffres de benchmark AWS (28 %, 77 % vs Claude Code) — s'ils
  sont cités dans l'audit, les qualifier explicitement de chiffre vendeur non vérifié
  indépendamment, jamais comme fait de gouvernance

---

## Critères d'acceptation

1. `doc/AUDIT-EXTERNE-strands-harness-vs-sdlc.md` existe et contient une section
   `§Verdict synthétique`
2. Le fichier contient ≥ 3 recommandations, chacune étiquetée IMPORTER / ADAPTER / REJETER,
   chacune référençant un fichier SDLC précis (chemin exact)
3. `grep -c "IMPORTER\|ADAPTER\|REJETER" doc/AUDIT-EXTERNE-strands-harness-vs-sdlc.md` → ≥ 3
4. Le fichier contient un paragraphe dédié à la distinction « harness runtime (Strands) vs
   harness gouvernance (SDLC) »
5. Si ≥ 1 recommandation IMPORTER : le texte de l'entrée `DECISIONS-SDLC.md` correspondante
   est rédigé dans l'audit (format `M-XXX-NN`, voir `07-DECISIONS-SDLC.md` pour le format)
6. `git diff --stat` → aucun fichier parmi `01-Claude-md-TEMPLATE.md`,
   `02-STANDARDS-TEMPLATE.md`, `08-hooks-TEMPLATE.md`, `07-DECISIONS-SDLC.md` modifié
7. `/wrap-up` exécuté en fin de sprint

---

## Risques

- **Contenu externe modifié ou dépublié depuis la synthèse initiale (23/09/2026)** : faible ·
  mitigation — revérifier la date de publication des sources au chargement
- **Sur-généralisation d'un pattern runtime vers la couche gouvernance** : moyen · mitigation —
  le critère d'acceptation #4 force la distinction de couche avant toute recommandation

---

## Handoff Claude Code

**Fichiers — chargement immédiat :**
- Ce fichier (`specs/Sprints/sprint-audit-strands-harness.md`)
- `00-CONTEXT.md` — notamment `§3 Invariants`, en particulier `INV-3`
- `07-DECISIONS-SDLC.md` — dernières entrées (`M-PROC-3x`), pour le format d'entrée et le
  précédent direct
- `doc/AUDIT-EXTERNE-gsd-lite-vs-sdlc.md` — précédent direct, même type de sprint, structure
  à reproduire

**Fichiers — chargement différé (grep d'abord) :**
- `02-STANDARDS-TEMPLATE.md` → `grep "Observabilité"` avant lecture complète
- `03-wrap-up-SKILL-TEMPLATE.md` → `grep "SESSION_BRIDGE"` avant lecture complète
- `08-hooks-TEMPLATE.md` → lire en entier seulement si la source externe sur les hooks
  confirme un gap réel

**Sources externes à lire, dans cet ordre :**
1. `https://strandsagents.com/blog/introducing-strands-harness/` — gestion de contexte
   (troncature outils > ~1500 tokens, compaction à 85 % de fenêtre, context recovery),
   sessions, mémoire
2. `https://aws.amazon.com/blogs/machine-learning/strands-agents-sdk-a-technical-deep-dive-into-agent-architectures-and-observability/` —
   observabilité, OpenTelemetry
3. Chercher sur `strandsagents.com` une page dédiée aux hooks / lifecycle (chemin non
   confirmé à la rédaction de ce PDR — `WebSearch "strandsagents.com hooks lifecycle"` ou
   navigation depuis la doc SDK)

**Instructions spécifiques :**
- Reproduire exactement la structure de `doc/AUDIT-EXTERNE-gsd-lite-vs-sdlc.md` (cartographie,
  analyse comparative, propositions étiquetées, verdict)
- Le `§Verdict synthétique` doit trancher explicitement la distinction runtime/gouvernance
  avant toute recommandation — pas de comparaison terme à terme naïve
- Chaque recommandation IMPORTER précise le fichier cible exact et la section visée
- Aucun chiffre de benchmark AWS n'est repris sans la mention « chiffre vendeur, non vérifié
  indépendamment »

**Grep de vérification préalable :**
```bash
ls doc/AUDIT-EXTERNE-*.md 2>/dev/null
grep -n "INV-3" 00-CONTEXT.md
grep -n "SESSION_BRIDGE" 03-wrap-up-SKILL-TEMPLATE.md | head -5
grep -n "À REMPLIR" 02-STANDARDS-TEMPLATE.md
```

**Init mémoire sprint :**
```bash
echo "# Sprint Revue — audit-strands-harness · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-audit-strands-harness.md" >> .claude/sprint-memory.md
```

---

## Plan de développement
*(produit par Claude Code après analyse — à compléter en étape 4d, avant toute rédaction)*

**Dépendances vérifiées :**
- [x] S1 `strandsagents.com/blog/introducing-strands-harness/` — lu 23/09/2026, publié 21/09/2026
  (6 auteurs AWS). Hooks et OpenTelemetry **absents** de ce billet.
- [x] S2 blog AWS « deep dive » — lu, mais **daté du 31/07/2025** : porte sur le SDK Strands
  Agents, antérieur au Harness → à signaler dans l'audit, ne pas l'attribuer au Harness.
- [x] S3 — `strandsagents.com/docs/user-guide/concepts/agents/hooks/` → HTTP 404 ;
  remplacé par l'API reference `strandsagents.com/docs/api/python/strands.hooks.events/` (lue).

**Modules touchés :** `docs/AUDIT-EXTERNE-strands-harness-vs-sdlc.md` (nouveau) + fichiers
standards du wrap-up. Taille cœur S = taille totale S.

**Écarts PDR ↔ repo (HALT-ARCH — soumis à aval) :**
1. `doc/` n'existe pas — le repo utilise `docs/` → tous les chemins du PDR lus comme `docs/`
2. Structure : `12-audit-externe-TEMPLATE.md` (`M-TMPL-07`, SDLC-29) est postérieur à
   l'audit GSD-lite et a été créé pour unifier le format → suivre le template 12 (7 sections,
   6 axes), en conservant `ADAPTER` demandé par le PDR en plus de ses 4 verdicts (justifié §7)
3. `DECISIONS-SDLC.md` → `07-DECISIONS-SDLC.md` ; dernières entrées = `M-PROC-48`/`M-TMPL-08`
   (pas `M-PROC-3x`) → prochain identifiant template : `M-TMPL-09`

**Risques identifiés :**
- Rouvrir un sujet déjà tranché : hook `SessionStart` écarté par `M-TMPL-06` (ECO-5) —
  l'analogue Strands `AgentInitializedEvent` ne doit pas le relancer sans fait nouveau
- Attribuer au Harness 2026 des propriétés décrites en 2025 pour le SDK (S2)
- Sur-généralisation runtime → gouvernance (critère #4)

**Recommandations pressenties (à confirmer à la rédaction) :**
- R1 REJETER — compaction > 85 % / troncature ~1500 tokens vs `INV-3` (`00-CONTEXT.md`) :
  couche runtime ; la trace de compaction côté SDLC est déjà couverte (`08-hooks-TEMPLATE.md
  §PreCompact`, `M-HOOKS-08`)
- R2 REJETER — reprise par session ID + mémoire long terme vs `SESSION_BRIDGE`
  (`03-wrap-up-SKILL-TEMPLATE.md §Étape 5`) : état runtime opaque vs artefact git relu par un humain
- R3 IMPORTER — jeu d'exemples « projet agent/LLM » pour `02-STANDARDS-TEMPLATE.md
  §Observabilité` (itérations de boucle, succès/échec outils, tokens, latence) → `M-TMPL-09` rédigé
- R4 ADAPTER — rôle explicite de chaque hook (gate / observation), inspiré des attributs
  modifiables vs en lecture seule de Strands → `08-hooks-TEMPLATE.md`
- R5 REJETER — `AfterInvocationEvent.resume` (relance autonome) et `AgentInitializedEvent`
  → contredit « aval explicite » (`Claude.md §Règles absolues`) / déjà tranché `M-TMPL-06`

**Plan d'exécution :**
1. Rédiger `docs/AUDIT-EXTERNE-strands-harness-vs-sdlc.md` sur le squelette du template 12 ;
   paragraphe « harness runtime vs harness gouvernance » avant les recommandations
2. Rédiger le texte `M-TMPL-09` dans l'audit (non reporté dans `07-DECISIONS-SDLC.md`)
3. Tests A/B ci-dessous
4. `/wrap-up`

**Plan de test :**
- A1 — `grep -c "IMPORTER\|ADAPTER\|REJETER" docs/AUDIT-EXTERNE-strands-harness-vs-sdlc.md` → ≥ 3
- A2 — `grep -c "Verdict synthétique\|runtime vs harness gouvernance" docs/AUDIT-EXTERNE-strands-harness-vs-sdlc.md` → ≥ 2
- A3 — `grep -n "28 %\|77 %" docs/AUDIT-EXTERNE-strands-harness-vs-sdlc.md` → chaque ligne contient
  « chiffre vendeur, non vérifié indépendamment »
- B — `git status --short` → seuls le spec, l'audit et les fichiers standards du wrap-up
  (`CHANGELOG.md`, `docs/ROADMAP.md`, `docs/LESSONS_LEARNED.md`, `docs/SESSION_BRIDGE.md`) ;
  aucun `0X-*-TEMPLATE.md`, `12-*`, ni `07-DECISIONS-SDLC.md`

---

## Corrections ajustées vs spec

- **Chemins** : `doc/` → `docs/` (dossier `doc/` inexistant) ; `DECISIONS-SDLC.md` → `07-DECISIONS-SDLC.md` ; dernières entrées réelles `M-PROC-48`/`M-TMPL-08` (pas `M-PROC-3x`) → identifiant proposé `M-TMPL-09`. Les critères 1, 3 et 6 ont été vérifiés sur `docs/`.
- **Structure** : gabarit `12-audit-externe-TEMPLATE.md` (`M-TMPL-07`, postérieur à l'audit GSD-lite) au lieu de la structure de `AUDIT-EXTERNE-gsd-lite-vs-sdlc.md` ; verdict `ADAPTER` conservé en plus des 4 verdicts du gabarit, justifié §7 de l'audit. Aval utilisateur 23/09/2026.
- **Sources** : S3 page guide hooks → HTTP 404, remplacée par l'API reference `strands.hooks.events` ; S2 datée du 31/07/2025 (SDK, pas le Harness) — signalé dans l'audit.
- **Grep placeholders** : 1 ligne remontée (l.40, marqueur « À REMPLIR ») — citation descriptive de l'état de `02-STANDARDS-TEMPLATE.md` dans §Comportement actuel, pas un placeholder de plan (même cas que ECO-4, `docs/DIAGNOSTIC_CMDS.md`).
