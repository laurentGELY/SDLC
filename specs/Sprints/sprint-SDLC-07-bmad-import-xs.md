# Sprint SDLC-07 — Import patterns BMad tactiques (XS)
<!-- Template SDLC v1.9 · Destination : specs/Sprints/sprint-SDLC-07-bmad-import-xs.md -->

**Type :** Doc
**Taille :** XS
**Surface :** `01-Claude-md-TEMPLATE.md` · `doc/ANALYSE-BMAD.md`
**Risque :** Faible

---

## Contexte

Spike SDLC-06 (stratégique + tactique) a produit un catalogue de 19 patterns BMad.
Ce sprint importe le sous-ensemble à effort minimal et bénéfice net clair,
identifié comme "Sprint XS possible tout de suite" :

- **P-01** — 5 conditions HALT dans `Claude.md §Règles absolues`
- **P-13** — Principes anti-biais "Stronghold first" dans `Claude.md §Analyse`
- **P-14** — Règle "toute affirmation citable" dans `Claude.md §Rôle`
- **P-12 / P-05** — 2 corrections factuelles dans `doc/ANALYSE-BMAD.md`

Aucun nouveau fichier. Aucun nouveau skill. Aucune modification de procédure.

---

## Objectif

`01-Claude-md-TEMPLATE.md` intègre les 3 patterns BMad retenus,
vérifiable par grep. `doc/ANALYSE-BMAD.md` est corrigé sur 2 points factuels.

---

## Comportement actuel → cible

**P-01 :**
- Actuel : `Claude.md §Règles absolues` contient 6 interdictions + 1 règle d'aval.
  Les conditions logiques in-sprint (dépendance absente, boucle d'échec, scope drift,
  timeout) ne sont pas nommées — l'arrêt reste implicite et rationalisable.
- Cible : 5 conditions HALT explicites, nommées, avec mécanisme pour HALT-TIMEOUT.

**P-13 :**
- Actuel : `Claude.md §Analyse` a un plan structuré mais pas de principe anti-biais
  sur le point de départ du raisonnement.
- Cible : 3 principes ajoutés en tête de `§Analyse` (avant "Toujours partir du
  code réel...").

**P-14 :**
- Actuel : `Claude.md §Rôle` décrit le périmètre de travail mais pas de règle
  sur la vérifiabilité des affirmations.
- Cible : 1 ligne ajoutée dans `§Rôle`.

**Corrections ANALYSE-BMAD.md :**
- §B7 et §3 : `CONFIRMED/PROBABLE/POSSIBLE/SPECULATIVE` (4 niveaux) → corriger
  en `Confirmed/Deduced/Hypothesized` (3 niveaux de preuve) + statut
  indépendant `Open/Confirmed/Refuted` (2 axes orthogonaux)
- §B5 et §3 : `PASS/CONCERNS/FAIL` → noter que BMad utilise
  `READY/NEEDS WORK/NOT READY` (le nôtre reste valide, préciser que c'est notre
  vocabulaire adapté)

---

## Portée

**Inclus :**
- Modifications dans `01-Claude-md-TEMPLATE.md` (3 emplacements)
- Corrections dans `doc/ANALYSE-BMAD.md` (2 emplacements)

**Exclu :**
- `09-retrospective-SKILL-TEMPLATE.md` (P-09 — sprint S planifié séparément)
- `03-wrap-up-SKILL-TEMPLATE.md` (P-10 — sprint S planifié séparément)
- Création d'un skill `/review` (P-04 — sprint M, décision non tranchée)
- Tout autre fichier SDLC

**Interdit :**
- Modifier `STANDARDS.md`, `08-hooks-TEMPLATE.md` ou tout autre template
- Créer de nouveaux fichiers
- Modifier le numéro de version SDLC (pas d'évolution structurelle)

---

## Contenu précis des modifications

### M1 — `01-Claude-md-TEMPLATE.md` §Règles absolues
Ajouter après le bloc "Ne jamais :" existant, un bloc `**HALT — arrêt immédiat,
attendre l'humain :**` avec les 5 conditions :

```markdown
**HALT — arrêt immédiat, attendre l'humain :**
- **HALT-DEP** : dépendance requise absente du PDR détectée avant d'installer
  ou d'adapter le code
- **HALT-3X** : même test ou commande échoue 3 fois consécutives sans
  diagnostic clair entre chaque tentative → lancer `/diagnostic` avant de continuer
- **HALT-ARCH** : hypothèse technique du PDR contredite par le code réel
  (architecture, interface, comportement) → signaler avant d'adapter le code
- **HALT-SCOPE** : périmètre des fichiers à modifier dépasse significativement
  le §Portée du PDR → ne pas étendre sans validation explicite
- **HALT-TIMEOUT** : commande de test/build sans sortie depuis > [N] secondes
  → Mécanisme : préfixer avec `timeout [N]` (ex: `timeout 120 pytest tests/ -q`)
  → Si exit code 124 (timeout dépassé) → HALT
  → N à définir dans `Claude.md §Limites bash` du projet cible (défaut : 120s)

HALT ≠ hook bash : les hooks bloquent les commandes dangereuses avant exécution.
Les HALT bloquent les conditions logiques détectées pendant le raisonnement.
Les deux sont complémentaires.
```

### M2 — `01-Claude-md-TEMPLATE.md` §Analyse
Ajouter 3 lignes **en tête** de la section (avant "Toujours partir du code réel...") :

```markdown
**Principes anti-biais (avant toute analyse) :**
- Ancrer sur une preuve observable avant de théoriser — jamais l'inverse
- Traiter la description de l'utilisateur comme une hypothèse à vérifier,
  pas comme un fait de départ
- Si une preuve contredit la théorie en cours → mettre à jour la théorie,
  jamais minimiser la preuve
```

### M3 — `01-Claude-md-TEMPLATE.md` §Rôle
Ajouter une ligne à la fin du §Rôle (avant `**Source de vérité :**`) :

```markdown
**Toute affirmation factuelle doit être citable** : chemin:ligne, sortie
de commande, entrée git, log — éviter les formulations non vérifiables
("probablement", "devrait", "en principe").
```

### M4 — `doc/ANALYSE-BMAD.md` — 2 corrections factuelles
Correction 1 (§B7 + §3 §ADAPTER `/diagnostic`) :
```
Remplacer : "CONFIRMED/PROBABLE/POSSIBLE/SPECULATIVE (4 niveaux)"
Par        : "3 niveaux de preuve (Confirmed/Deduced/Hypothesized) ×
              statut cycle de vie (Open/Confirmed/Refuted) — 2 axes orthogonaux"
```

Correction 2 (§B5 + §3 §IMPORTER readiness gate) :
```
Remplacer : "PASS/CONCERNS/FAIL"
Par        : "notre vocabulaire PASS/CONCERNS/FAIL (BMad utilise
              READY/NEEDS WORK/NOT READY — sémantiquement équivalent)"
```

---

## Critères d'acceptation

- [ ] `grep "HALT-DEP\|HALT-3X\|HALT-ARCH\|HALT-SCOPE\|HALT-TIMEOUT" 01-Claude-md-TEMPLATE.md` → 5 résultats
- [ ] `grep "HALT.*hook\|hook.*HALT\|complémentaires" 01-Claude-md-TEMPLATE.md` → note explicative présente
- [ ] `grep "Ancrer sur une preuve\|Stronghold\|anti-biais" 01-Claude-md-TEMPLATE.md` → présent
- [ ] `grep "citable\|chemin:ligne" 01-Claude-md-TEMPLATE.md` → présent dans §Rôle
- [ ] `grep "2 axes orthogonaux\|Deduced\|Hypothesized" doc/ANALYSE-BMAD.md` → présent
- [ ] `grep "PASS/CONCERNS/FAIL" doc/ANALYSE-BMAD.md` → accompagné de la note BMad
- [ ] `git diff --stat` → exactement 2 fichiers modifiés
- [ ] `grep "\[→ ADAPTER\]" 01-Claude-md-TEMPLATE.md` → aucun nouveau placeholder introduit

---

## Plan de test

- **A — Ciblé :** `grep -c "HALT-" 01-Claude-md-TEMPLATE.md` → `5`
- **B — Non-régression :** `grep "Ne jamais" 01-Claude-md-TEMPLATE.md` → bloc
  existant intouché (les HALT sont un bloc additionnel, pas un remplacement)

---

## Dépendances

**Inputs requis :**
- [ ] `doc/ANALYSE-BMAD.md` — présent (produit par Spike SDLC-06)
- [ ] `doc/ANALYSE-BMAD-TACTIQUE.md` — présent (produit par Spike SDLC-06, lecture source)

**Outputs produits :**
- [ ] `01-Claude-md-TEMPLATE.md` modifié (v1.9 → annoter comme v1.9+SDLC-07 dans le header)
- [ ] `doc/ANALYSE-BMAD.md` corrigé

---

## Handoff Claude Code

**Fichiers — chargement immédiat :**
```bash
cat 01-Claude-md-TEMPLATE.md    # fichier principal à modifier
cat doc/ANALYSE-BMAD.md         # corrections factuelles
```

**Fichiers — chargement différé :**
```bash
# Si doute sur le placement de M2 dans §Analyse :
grep -n "Toujours partir du code réel\|§Analyse" 01-Claude-md-TEMPLATE.md
```

**Init mémoire sprint :**
```bash
echo "# Sprint SDLC-07 — bmad-import-xs · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-SDLC-07-bmad-import-xs.md" >> .claude/sprint-memory.md
```

**Instructions spécifiques :**
- Utiliser `sed` pour toutes les modifications (règle M-PROC-11)
- Vérifier chaque grep de CA après chaque modification
- Ne pas réécrire les sections existantes — insérer uniquement
- Le bloc HALT va **après** le bloc "Ne jamais :" et **avant** "Si l'aval n'est
  pas donné..." — préserver l'ordre logique de la section

**Grep de vérification finale :**
```bash
grep -c "HALT-" 01-Claude-md-TEMPLATE.md          # → 5
grep "Ne jamais" 01-Claude-md-TEMPLATE.md          # → présent, intouché
grep "\[→ ADAPTER\]" 01-Claude-md-TEMPLATE.md      # → aucun nouveau
git diff --stat                                     # → 2 fichiers uniquement
```

---

## Plan de développement
*(complété par Claude Code en étape 4d)*

**Modules touchés :** `01-Claude-md-TEMPLATE.md` (§Règles absolues, §Analyse, §Rôle) · `doc/ANALYSE-BMAD.md`

**Plan d'exécution :**
1. M3 — §Rôle (1 ligne, simple, risque zéro) · grep CA M3
2. M2 — §Analyse (3 lignes en tête, grep position avant insertion) · grep CA M2
3. M1 — §Règles absolues (bloc HALT, le plus dense) · grep CA M1 (5 lignes)
4. M4 — `doc/ANALYSE-BMAD.md` (2 corrections sed) · grep CA M4
5. Vérification finale : git diff --stat + tous les grep CA

**Plan de test :**
- A — Ciblé : `grep -c "HALT-" 01-Claude-md-TEMPLATE.md` → 5
- B — Non-régression : `grep "Ne jamais" 01-Claude-md-TEMPLATE.md` → présent intouché

---

## Corrections ajustées vs spec
*(complété au wrap-up)*
