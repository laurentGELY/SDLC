# Sprint SDLC-16 — Audit complet SDLC-07→15 + documentation rétroactive vérifiée
<!-- Template SDLC v1.9 · specs/Sprints/sprint-SDLC-16-audit-complet.md -->
<!-- Fichier créé rétroactivement après l'exécution du sprint — voir §Corrections ajustées vs spec -->

**Type :** Doc
**Taille :** L
**Surface :** `doc/LESSONS_LEARNED.md` · `07-DECISIONS-SDLC.md` · `CHANGELOG.md`
(conditionnels — uniquement sur ce que l'audit confirme manquant ou divergent)
**Risque :** Faible

---

## Contexte

SDLC-15 a été partiellement exécuté — Claude Code a correctement refusé de
remplir `doc/LESSONS_LEARNED.md` à partir du contenu narratif fourni dans
le PDR original (§M8), parce que ce contenu décrivait la session de
conception (Claude.ai), pas l'état réel du repo. Ce refus était le bon
comportement — exactement le principe Stronghold first qu'on a importé
en SDLC-07, appliqué correctement à mes propres affirmations.

Ce sprint remplace l'approche "je dicte, tu écris" par "tu audites, tu
écris ce que tu observes". Deux catégories de contenu, traitées
différemment :

1. **Vérifiable depuis le repo** (état de fichier, grep, git log/diff) —
   Claude Code audite et documente directement, aucune confiance requise
   envers la session de conception.
2. **Narratif** (observations sur le déroulement des sessions de
   conception elles-mêmes) — ne peut pas être vérifié depuis git. Reste
   **proposé, pas écrit**, jusqu'à confirmation explicite de l'humain
   en session.

---

## Objectif

L'état réel du repo pour SDLC-07 à SDLC-15 est connu avec certitude
(rapport d'audit). `07-DECISIONS-SDLC.md`, `CHANGELOG.md` et
`doc/LESSONS_LEARNED.md` reflètent cet état réel — pas une supposition,
pas une narration non vérifiée.

---

## Portée

**Inclus :**
- Script d'audit groupé (grep/ls/git log) sur les 9 sprints SDLC-07→15
- Verdict par sprint avec preuve citée
- `07-DECISIONS-SDLC.md` : nouvelle entrée si gap de traçabilité confirmé
- `CHANGELOG.md` : idem
- `doc/LESSONS_LEARNED.md` : audit du contenu déjà présent (créé SDLC-14),
  traitement des entrées narratives non vérifiables
- Ce fichier (`specs/Sprints/sprint-SDLC-16-audit-complet.md`), créé
  rétroactivement

**Exclu :**
- Toute modification des templates `01-12` eux-mêmes
- Backfill CHANGELOG/DECISIONS pour SDLC-07/08/09 — déjà tranché
  (`M-PROC-27`, hors portée de ce sprint, pas à rouvrir)

---

## Critères d'acceptation

- [x] Étape 1 exécutée intégralement, sortie brute rapportée avant toute
      interprétation
- [x] Verdict produit pour chacun des 9 sprints (SDLC-07 à 15), chacun
      appuyé sur une preuve grep/ls citée — `SDLC-14` scindé en 2 volets
      (self-bootstrap `ATTEINT` / rattrapage `non fait, déjà couvert`)
- [x] Aucune entrée `doc/LESSONS_LEARNED.md §Processus` ne contient
      d'affirmation non vérifiable sans le marqueur de confirmation
      humaine explicite — 8 entrées annotées `(non vérifiable depuis le
      repo — audit SDLC-16)` sur décision explicite de l'utilisateur
      (option "Requalifier non vérifiable", pas retrait ni confirmation)
- [x] Bloc "Observations narratives non vérifiables" produit (8 entrées,
      dont 2 correspondant mot pour mot aux exemples cités par le PDR
      lui-même)
- [x] `07-DECISIONS-SDLC.md`/`CHANGELOG.md` mis à jour uniquement pour
      les sprints en verdict PARTIEL/DIVERGENT/NON FAIT sur la
      traçabilité — aucune entrée dupliquée (vérifié par grep avant
      ajout) ; aucun gap de ce type trouvé pour SDLC-07→15 (déjà couverts
      par `M-PROC-25/26/27`), entrée `M-PROC-29` ajoutée pour le sprint
      SDLC-16 lui-même (discipline standard, pas une exigence du PDR)
- [x] `git diff --stat` cohérent avec les verdicts réellement constatés

---

## Plan de développement

*(rédigé rétroactivement — reconstruit depuis la conversation, pas écrit
avant l'exécution comme `Claude.md §Démarrage 4d` l'impose normalement)*

1. Exécuter le script d'audit groupé fourni par le PDR, rapporter la
   sortie brute intégrale sans l'interpréter
2. Vérifier les chemins/cibles obsolètes du script hérité avant de
   conclure à un échec (ex : `doc/ANALYSE-BMAD.md` déplacé en
   `specs/Sprints/` dès SDLC-07 — vérifié avant de conclure "absent")
3. Pour chaque sprint, produire un verdict ancré sur la preuve — jamais
   sur la supposition du PDR
4. Vérifier l'état réel de `doc/LESSONS_LEARNED.md` avant d'agir —
   découverte qu'il contient déjà 8 entrées rétroactives (SDLC-14),
   contredisant la prémisse du contexte du PDR ("refusé, donc vide")
5. Identifier les phrases narratives invérifiables déjà présentes,
   les soumettre à l'utilisateur plutôt que les retirer ou les
   confirmer unilatéralement
6. Appliquer la décision utilisateur (requalification en place)
7. Mettre à jour `07-DECISIONS-SDLC.md`/`CHANGELOG.md` pour le sprint
   SDLC-16 lui-même, par cohérence avec la discipline restaurée depuis
   SDLC-10 (`LL-T01`)

---

## Plan de test

- **A — Ciblé :** sortie brute du script d'audit citée intégralement
  avant tout verdict — fait (voir conversation)
- **B — Non-régression :** grep de vérification avant chaque ajout dans
  `07-DECISIONS-SDLC.md`/`CHANGELOG.md` — `M-PROC-25/26/27/28` confirmés
  présents une seule fois chacun, `M-PROC-29` ajouté sans doublon

---

## Corrections ajustées vs spec

- **Fichier spec créé rétroactivement.** Le sprint a démarré directement
  depuis le PDR collé en conversation, sans exécuter `Claude.md §Démarrage`
  étape 4a (création de ce fichier) ni étape 4d (§Plan de développement
  écrit avant le travail). Signalé à l'utilisateur lors du `/wrap-up`, qui
  a demandé la création rétroactive plutôt que de laisser le gap. Le
  §Plan de développement ci-dessus est reconstruit après coup, pas écrit
  avant l'exécution — moins fiable qu'un plan écrit en amont, noté ici
  pour traçabilité.
- **Contexte du PDR contredit par l'état réel.** Le PDR affirmait que
  `doc/LESSONS_LEARNED.md` avait été laissé vide en SDLC-15 (refus
  correct de Claude Code face à du contenu narratif). L'audit a montré
  qu'il était en réalité déjà entièrement rempli depuis SDLC-14, avec des
  entrées narratives non vérifiables. Le PDR anticipait explicitement ce
  cas alternatif (§Étape 3/Niveau 2, dernier paragraphe) — traité comme
  prévu : audit du contenu existant, proposition à l'utilisateur plutôt
  qu'action unilatérale.
- **Aucune entrée de backfill ajoutée pour SDLC-07/08/09/10/11/12/13/15**
  — tous déjà couverts par des décisions ou entrées antérieures
  (`M-PROC-25/26/27`, entrées CHANGELOG existantes). Seule nouvelle entrée :
  `M-PROC-29`, pour le sprint SDLC-16 lui-même.
- **Adversarial Review (Taille L, déclenchée au wrap-up)** : 1 finding
  🟡 patché — `M-PROC-29`/CHANGELOG initialement ambigus sur le statut de
  SDLC-14 (laissaient croire à un statut entièrement non résolu), corrigé
  en clarifiant le split self-bootstrap (`ATTEINT`) / rattrapage (`non
  fait, couvert par M-PROC-27`).
