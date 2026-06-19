# Sprint N — [Titre]
<!-- Template SDLC v1.9 · Destination : specs/Sprints/sprint-N-slug.md dans le repo cible -->
<!-- Ce template est générique — ne pas adapter, utiliser tel quel -->

**Type :** Feature | Fix | Tuning | Doc | Spike | Dette  ← choisir un
**Taille :** XS | S | M | L  ← XS < 1h · S < 3h · M < 1 jour · L > 1 jour
**Surface :** [modules / fichiers principalement concernés]
**Risque :** Faible | Moyen | Élevé

---

## Contexte

[Symptôme observé ou opportunité identifiée. Pourquoi ce sprint, pourquoi maintenant.
2-4 phrases. Pas de solution ici — juste le problème ou l'opportunité.]

---

## Objectif

[Une phrase. Doit être mesurable ou vérifiable.
Ex : "Réduire les faux positifs de type X de Y% sur le corpus de référence"
Ex : "Le composant Z accepte les formats A et B sans erreur"]

---

## Comportement actuel → cible

- **Actuel :** [ce qui se passe aujourd'hui]
- **Cible :** [ce qui doit se passer après le sprint]

---

## Portée

**Inclus :**
- [item 1]
- [item 2]

**Exclu (explicitement) :**
- [item hors scope — être précis pour éviter le scope creep]

---

## Option retenue — alternatives écartées

**Retenue :** [description de l'approche choisie]

**Écartée(s) :**
- [Alternative A] — raison en 1 ligne
- [Alternative B] — raison en 1 ligne

**Sacrifices délibérés :** [ce qu'on accepte de ne pas avoir dans ce sprint]

---

## Contraintes techniques / produit

- [Contrainte 1 — ex : pas de nouvelle dépendance pip]
- [Contrainte 2 — ex : rétrocompatibilité avec format X]
- [Contrainte 3 — ex : taille fichier < N lignes]

**Interdit :**
- [ex : modifier le schéma DB sans migration · appeler l'API externe en mode test · caster les types sans décomposition]

---

## Dépendances

**Inputs requis** *(ce sprint assume que ces outputs de sprints précédents existent et sont valides)* :
- [ ] [Sprint N ou artifact — ex : `specs/Sprints/sprint-12-auth.md` · décision D-07 stable]
- [ ] [Ressource externe — ex : connecteur GitHub configuré · secret API_KEY présent dans .env]
- *(aucune dépendance explicite)* ← supprimer si des dépendances sont listées

**Outputs produits** *(ce que les sprints suivants pourront utiliser)* :
- [ ] [ex : `src/module_x.py` · interface publique stable]
- [ ] [ex : décision D-XX dans DECISIONS.md]

**Règle :** avant de démarrer, vérifier que tous les inputs requis cochés existent et sont dans l'état attendu.
Si un input manque ou a changé → signaler comme BLOQUANT avant toute analyse.

---

## Critères d'acceptation

- [ ] [Critère 1 — vérifiable par commande ou observation]
- [ ] [Critère 2]
- [ ] [Critère 3]
- [ ] Tests niveau A : `[commande exacte — ex : pytest tests/test_module.py -q]`
- [ ] CHANGELOG mis à jour

*(Pour les sprints Feature — optionnel, remplacer ou compléter les critères ci-dessus)*
```
Scénario : [nom du comportement]
  Étant donné [état initial du système]
  Quand [action déclenchante]
  Alors [résultat observable attendu]
  Et [effet de bord attendu si applicable]
```

---

## Risques

- **[Risque 1]** : [probabilité] · [mitigation]
- **[Risque 2]** : [probabilité] · [mitigation]

---

## Pre-mortem *(obligatoire pour taille M et L)*

> Si ce sprint échoue ou dépasse 2× l'estimation, la cause la plus probable est :

[Compléter avant de commencer — force à nommer le risque principal]

---
<!-- FIN PRD — La section Handoff est complétée par Claude Code en début de session -->

## Handoff Claude Code
*(à compléter en début de session)*

**Fichiers — chargement immédiat :**
- *(lire en étape 4c, avant toute analyse)*

**Fichiers — chargement différé :**
- *(grep d'abord · lire uniquement si le grep confirme la pertinence)*

**Données à collecter avant de coder :**
-

**Instructions spécifiques :**
-

**Grep de vérification préalable :**
```bash

```

**Init mémoire sprint :**
```bash
echo "# Sprint N — [slug] · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-N-slug.md" >> .claude/sprint-memory.md
```
*(Remplacer N et slug. Exécuter en étape 4b du démarrage, après création du fichier spec.)*

---

## Plan de développement
*(produit par Claude Code après analyse — à compléter en étape 4d, avant tout code)*

**Dépendances vérifiées :**
- [ ] [input requis] — état : [présent / absent / modifié depuis spec]

**Modules touchés :**

**Risques identifiés :**

**Plan d'exécution :**
1.
2.

*(Taille L uniquement — optionnel mais recommandé : grille succès/échec
par étape majeure du plan d'exécution ci-dessus)*

| Étape | ✅ Succès si | ❌ Échec si |
|-------|-------------|------------|
| 1. [nom étape] | [critère observable] | [signal d'échec] |

**Plan de test :**
- A — Ciblé : `<commande exacte>`
- **Volumétrie minimum :** *(optionnel — si le système traite des items)* `[minimum en dessous duquel le test A est invalide même si exit 0 — ex: ≥ 1 item traité confirmé dans les logs]`
- B — Non-régression :

---

## Corrections ajustées vs spec
*(complété au wrap-up — §Étape 3)*
