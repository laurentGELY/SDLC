# Sprint SDLC-Audit-GSD-lite — Analyse externe GSD-lite
<!-- SDLC v1.9 · specs/Sprints/sprint-audit-gsd-lite.md -->

**Type :** Spike
**Taille :** S
**Surface :** `doc/` — zéro code métier, zéro modification de template
**Risque :** Faible

---

## Contexte

Suite directe de l'audit GSD-full (Sprint SDLC-Audit-GSD, `doc/AUDIT-EXTERNE-gsd-vs-sdlc.md`).
GSD-lite est une version allégée de GSD : conserve la séparation planning/exécution,
supprime le bulk (tooling npm, waves de parallélisme, multi-agents, release CI, etc.).

Selon la description disponible : *"Smaller, simpler Claude workflows. Keeps planning/execution,
drops bulk. Less power than full GSD."*

L'audit GSD-full a produit 6 propositions (A à F). L'objectif de ce sprint est de
vérifier si GSD-lite modifie, renforce ou invalide ces propositions — et de produire
un document de synthèse consolidé des deux audits, prêt pour discussion et décision.

---

## Objectif

Produire `doc/AUDIT-EXTERNE-gsd-lite-vs-sdlc.md` + `doc/SYNTHESE-AUDITS-GSD.md`,
permettant une décision informée sur les propositions A-F sans nouvelle session d'analyse.

---

## Comportement actuel → cible

- **Actuel :** un seul audit (GSD-full), propositions A-F non encore validées
- **Cible :** deux audits complétés + une synthèse consolidée avec statut de chaque
  proposition (confirmée / renforcée / invalidée / nuancée) et recommandation
  d'ordre d'implémentation

---

## Portée

**Inclus :**
- Lecture et cartographie du repo local `/exemples/get-shit-done-lite/` (ou chemin équivalent)
- Comparaison GSD-lite vs GSD-full (delta réel)
- Comparaison GSD-lite vs modèle SDLC (même grille que l'audit GSD-full)
- Impact de GSD-lite sur les propositions A-F issues de l'audit GSD-full
- Document de synthèse consolidé

**Exclu explicitement :**
- Toute modification de template SDLC dans ce sprint (mode Plan uniquement)
- Analyse des fichiers GSD-full déjà couverts dans l'audit précédent
- Toute décision d'implémentation (les décisions se prennent après discussion humaine)

---

## Sources disponibles

- Repo local GSD-lite : `/exemples/get-shit-done-lite/` — lire en priorité
- Audit GSD-full : `doc/AUDIT-EXTERNE-gsd-vs-sdlc.md` — référence, ne pas re-lire en entier
  (charger uniquement §4 Propositions et §5 Verdict synthétique)
- Modèle SDLC : fichiers du projet Claude.ai (chargés en contexte)

---

## Dépendances

**Inputs requis :**
- [x] `doc/AUDIT-EXTERNE-gsd-vs-sdlc.md` — doit exister (produit sprint précédent)
- [x] `/exemples/get-shit-done-lite/` — doit être présent localement

**Outputs produits :**
- [ ] `doc/AUDIT-EXTERNE-gsd-lite-vs-sdlc.md`
- [ ] `doc/SYNTHESE-AUDITS-GSD.md`

**Règle :** avant de démarrer, vérifier que le repo GSD-lite est accessible et non vide.
Si absent → signaler BLOQUANT, ne pas improviser depuis des sources web.

---

## Critères d'acceptation

- [ ] `doc/AUDIT-EXTERNE-gsd-lite-vs-sdlc.md` existe avec §Cartographie · §Comparaison · §Impact propositions
- [ ] `doc/SYNTHESE-AUDITS-GSD.md` existe avec tableau statut des 6 propositions A-F
- [ ] Chaque proposition A-F a un statut explicite (Confirmée / Renforcée / Invalidée / Nuancée) et une justification ≥ 1 phrase
- [ ] La synthèse contient un ordre d'implémentation recommandé (1er, 2ème, etc.) avec justification
- [ ] Zéro modification de fichier template ou de gouvernance dans ce sprint
- [ ] CHANGELOG mis à jour (entrée courte — sprint Spike)

---

## Pre-mortem

> Si ce sprint échoue ou produit une synthèse inutile, la cause la plus probable est :
> GSD-lite est trop proche de GSD-full pour apporter un delta significatif,
> et la synthèse répète l'audit GSD-full sans valeur ajoutée.

Mitigation : si GSD-lite ≈ GSD-full avec moins de commandes, le dire explicitement
dans la synthèse — c'est une conclusion valide. Ne pas forcer un delta artificiel.

---

## Handoff Claude Code

**Fichiers — chargement immédiat :**
- Ce PDR
- `doc/AUDIT-EXTERNE-gsd-vs-sdlc.md` §4 et §5 uniquement (grep `## 4` et `## 5`)

**Fichiers — chargement différé :**
- `doc/AUDIT-EXTERNE-gsd-vs-sdlc.md` complet — seulement si une proposition
  nécessite de recontextualiser son §3 (Analyse comparative)

**Données à collecter avant de rédiger :**

```bash
# 1. Vérifier que le repo GSD-lite est présent et lister sa structure
find /exemples/get-shit-done-lite -type f | sort

# 2. Lister les skills/commands disponibles dans GSD-lite
find /exemples/get-shit-done-lite -name "*.md" | sort
ls /exemples/get-shit-done-lite/.claude/commands/ 2>/dev/null || \
  ls /exemples/get-shit-done-lite/commands/ 2>/dev/null || echo "chemin à ajuster"

# 3. Lire le README principal de GSD-lite
cat /exemples/get-shit-done-lite/README.md 2>/dev/null | head -150

# 4. Charger §4 et §5 de l'audit GSD-full
grep -n "^## [45]\." doc/AUDIT-EXTERNE-gsd-vs-sdlc.md || \
  grep -n "^## 4\|^## 5" doc/AUDIT-EXTERNE-gsd-vs-sdlc.md
```

**Instructions spécifiques :**
- Lire les fichiers GSD-lite AVANT de rédiger quoi que ce soit
- La grille de comparaison doit utiliser exactement les mêmes axes que l'audit GSD-full
  (§3.1 GSD fait mieux / §3.2 SDLC fait mieux / §3.3 Convergences)
- Le tableau de synthèse des propositions est le livrable principal —
  s'assurer qu'il répond à : "qu'est-ce qu'on fait en premier ?"
- Ne pas répéter l'analyse GSD-full dans l'audit GSD-lite — référencer, pas répliquer
- Format des deux documents : même en-tête PDR que l'audit GSD-full
  (Type Spike · Taille S · Surface doc/ · Risque Faible)

**Init mémoire sprint :**
```bash
echo "# Sprint SDLC-Audit-GSD-lite · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-audit-gsd-lite.md" >> .claude/sprint-memory.md
```

---

## Plan de développement
*(à compléter par Claude Code après lecture du repo GSD-lite)*

**Dépendances vérifiées :**
- [ ] `/exemples/get-shit-done-lite/` — présent / absent
- [ ] `doc/AUDIT-EXTERNE-gsd-vs-sdlc.md` — présent / absent

**Plan d'exécution (ordre strict) :**
1. Lire le repo GSD-lite complet (structure + README + skills)
2. Cartographier les commandes disponibles (vs GSD-full et vs SDLC)
3. Rédiger `doc/AUDIT-EXTERNE-gsd-lite-vs-sdlc.md`
4. Reprendre les 6 propositions A-F, statuer sur chacune
5. Rédiger `doc/SYNTHESE-AUDITS-GSD.md` avec tableau + ordre d'implémentation
6. Mettre à jour CHANGELOG
7. Wrap-up (Taille S — pas d'Adversarial Review)

**Plan de test :**
- A — Ciblé : `grep "## [45]\." doc/SYNTHESE-AUDITS-GSD.md | wc -l` → ≥ 1 section
- A — Ciblé : `grep -c "Confirmée\|Renforcée\|Invalidée\|Nuancée" doc/SYNTHESE-AUDITS-GSD.md` → = 6

---

## Corrections ajustées vs spec
*(complété au wrap-up)*
