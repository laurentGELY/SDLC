# Sprint SDLC-Audit-GSTACK — Audit externe GSTACK vs modèle SDLC
<!-- Template SDLC v2.0 · specs/Sprints/sprint-SDLC-Audit-GSTACK.md -->

**Type :** Revue
**Taille :** M
**Surface :** `doc/` (output uniquement) · zéro modification des fichiers de gouvernance
**Risque :** Faible

---

## Contexte

GSTACK est un framework d'orchestration basé sur des rôles pour les workflows Claude Code,
conçu autour de la séparation des responsabilités (planification, exécution, review) en rôles
d'agents distincts. Il a été identifié comme cadre pertinent à analyser suite aux audits GSD-full,
GSD-lite et Superpowers déjà menés (CHANGELOG v1.9+SDLC-Audit-GSD-lite, SDLC-19).

Le projet P-22 (`doc/ROADMAP.md §Later`) prévoyait un template `10-audit-externe-TEMPLATE.md`
pour standardiser les audits — ce sprint peut servir de cas réel pour valider ou affiner ce besoin.

Source locale : `/home/laurentg/Downloads/Sandbox/SDLC/exemples/gstack` (git clone de
`https://github.com/garrytan/gstack`). Ne pas fetcher le repo distant.

---

## Objectif

Produire une analyse comparative honnête GSTACK vs modèle SDLC, avec des recommandations
étiquetées IMPORTER / REJETER / INVESTIGUER / MERGER pour chaque concept significatif identifié.

---

## Comportement actuel → cible

- **Actuel :** Aucune connaissance formalisée de GSTACK dans le modèle SDLC. P-22 en §Later.
- **Cible :** `doc/AUDIT-EXTERNE-gstack-vs-sdlc.md` produit, concepts évalués, recommandations
  actionnables documentées, P-22 mis à jour selon les conclusions.

---

## Portée

**Inclus :**
- Lecture et cartographie complète du repo GSTACK local (structure, fichiers, patterns)
- Analyse des concepts clés : rôles agents, séparation des responsabilités, workflow orchestration
- Comparaison honnête avec le modèle SDLC actuel (forces, faiblesses, gaps, redondances)
- Recommandations étiquetées par concept (IMPORTER / REJETER / INVESTIGUER / MERGER)
- Discussion de nouvelles idées potentielles pour améliorer notre SDLC
- Verdict synthétique : fit général GSTACK avec notre contexte solo/petit projet
- Mise à jour `doc/ROADMAP.md` : P-22 statut + nouveaux items si recommandations actionnables

**Exclu (explicitement) :**
- Modification de tout fichier de gouvernance SDLC (templates, Claude.md, STANDARDS, etc.)
- Implémentation de quoi que ce soit issu de GSTACK
- Fetch du repo distant GitHub (source locale uniquement)
- Audit de frameworks tiers non présents dans le clone local

---

## Option retenue — alternatives écartées

**Retenue :** Sprint Revue M avec output `doc/AUDIT-EXTERNE-gstack-vs-sdlc.md`, sur le modèle
des audits GSD-full, GSD-lite et Superpowers déjà produits.

**Écartée :** Sprint Spike — écarté car un Spike investigue une question ouverte sans livrable
préexistant. Ici le livrable à auditer (GSTACK) existe ; le type Revue est approprié.

**Écartée :** Intégration directe dans le même sprint — écarté, le modèle Revue interdit de
modifier les fichiers de gouvernance dans le même sprint que l'audit.

**Sacrifices délibérés :** aucun test d'implémentation réelle des patterns GSTACK ce sprint —
les recommandations sont analytiques uniquement.

---

## Contraintes techniques / produit

- Source locale uniquement : `/home/laurentg/Downloads/Sandbox/SDLC/exemples/gstack/`
- Output : fichier `.md` unique dans `doc/`
- Le livrable audité (GSTACK) n'est jamais modifié
- Format des recommandations cohérent avec les audits précédents (étiquetage explicite)

**Interdit :**
- Modifier un template SDLC dans ce sprint
- Appeler GitHub ou toute URL externe pour compléter l'analyse
- Produire du code ou des modifications de gouvernance (output = recommandations uniquement)

---

## Dépendances

**Inputs requis :**
- [x] Clone local GSTACK disponible : `/home/laurentg/Downloads/Sandbox/SDLC/exemples/gstack/`
- [x] Audits précédents pour cohérence de format :
  - `doc/AUDIT-EXTERNE-gsd-vs-sdlc.md` (GSD-full)
  - `doc/AUDIT-EXTERNE-gsd-lite-vs-sdlc.md` (GSD-lite)
- [x] `doc/ROADMAP.md` — pour mise à jour P-22 en fin de sprint

**Outputs produits :**
- [x] `doc/AUDIT-EXTERNE-gstack-vs-sdlc.md` — analyse complète avec recommandations
- [x] `doc/ROADMAP.md` — P-22 §Later→§Next + P-40–P-44 §Later + 3 signaux faibles §Signaux

---

## Critères d'acceptation

- [x] `doc/AUDIT-EXTERNE-gstack-vs-sdlc.md` créé, lisible, structuré
- [x] Chaque concept GSTACK significatif a un verdict étiqueté (20 concepts : 4/7/2/7)
- [x] Le tableau comparatif couvre au minimum les 6 axes définis (§3.1)
- [x] La section §Nouvelles idées est présente (5 idées)
- [x] Le verdict synthétique répond explicitement à la question d'intégration partielle vs globale
- [x] `doc/ROADMAP.md` mis à jour — P-22 §Later→§Next révisé
- [x] Aucun fichier de gouvernance SDLC modifié (vérifié `git diff --stat`)
- [x] CHANGELOG mis à jour

## Corrections ajustées vs spec

- **Spec sprint créée lors du wrap-up** (et non en §4a démarrage) : le PDR a été fourni
  dans le message utilisateur sans étape de démarrage formelle. Anomalie notée en Adversarial
  Review Couche 2 — patch appliqué lors du wrap-up.
- **Décompte CHANGELOG corrigé** : "5/8/3/7=23" → "4/7/2/7=20" (patch Couche 1).
