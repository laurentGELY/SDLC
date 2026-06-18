# Sprint SDLC-08 — Import BMad : qualité & continuité
<!-- Template SDLC v1.9 · Destination : specs/Sprints/sprint-SDLC-08-bmad-qualite-continuite.md -->

**Type :** Doc
**Taille :** M
**Surface :** `01-Claude-md-TEMPLATE.md` · `09-retrospective-SKILL-TEMPLATE.md`
**Risque :** Faible

---

## Contexte

Suite directe de SDLC-07 (P-01/P-13/P-14 importés). Ce sprint importe le groupe
"qualité & continuité" — les patterns BMad qui répondent tous à la même question :
*"est-ce vraiment fini, et le prochain sprint peut démarrer sur des bases saines ?"*

Patterns groupés :
- **P-06** — 3e mode de chargement INDEX_GUIDED (`Claude.md §Tokens`)
- **P-07** — Seuil quantifié de délégation sous-agent (`Claude.md §Tokens`)
- **P-02** — Clause anti-complaisance test OK (`Claude.md §Test`)
- **P-11** — Reconstruction sprint-memory si perte accidentelle (`Claude.md §Mémoire de sprint`)
- **P-09** — Checklist Significant Discovery Alert (`09-retrospective §Étape 2b`)

P-10 (Critical Readiness) est absorbé dans SD-1 et SD-5 — décision SDLC-08.

---

## Objectif

Les 5 patterns sont intégrés, vérifiables par grep.
`01-Claude-md-TEMPLATE.md` et `09-retrospective-SKILL-TEMPLATE.md` sont les
deux seuls fichiers modifiés.

---

## Comportement actuel → cible

**P-06 + P-07 — `Claude.md §Tokens` :**
- Actuel : 2 modes — immédiat / différé (grep avant lecture). Aucun seuil chiffré
  pour la délégation. "Grep avant lecture" qualitatif sans condition de taille.
- Cible : 3 modes — immédiat / différé / index-guidé. Seuil explicite :
  > 5 fichiers ou > 10K tokens → déléguer à un sous-agent.

**P-02 — `Claude.md §Test` :**
- Actuel : définition "test OK" en 3 niveaux A/B/C. INV-1 exige une commande
  exacte, mais pas de garde-fou explicite contre l'auto-complaisance
  ("devrait passer" sans exécution réelle).
- Cible : clause anti-complaisance ajoutée à la définition "test OK".

**P-11 — `Claude.md §Mémoire de sprint` :**
- Actuel : le fichier `sprint-memory.md` est créé au démarrage, détruit après
  commit. Aucune procédure si le fichier disparaît accidentellement en cours
  de sprint (incident observé en session SDLC-06).
- Cible : clause de dégradation : si absent en cours de sprint → reconstruire
  depuis `git diff HEAD` + conversation avant de continuer.

**P-09 — `09-retrospective-SKILL-TEMPLATE.md §Étape 2b` :**
- Actuel : §Étape 2 produit un rapport de patterns (RÉCURRENCES, AGGRAVATIONS,
  SUCCÈS, HOOK_CANDIDATES...) sur déclaration spontanée. Les conditions
  d'invalidation du plan suivant ne sont vérifiées que si quelqu'un y pense.
- Cible : checklist fermée de 5 conditions (SD-1 à SD-5) vérifiée
  systématiquement après le rapport — déclenchement indépendant de la mémoire
  humaine.

---

## Portée

**Inclus :**
- `01-Claude-md-TEMPLATE.md` — §Tokens (M1, M2), §Test (M3), §Mémoire de sprint (M4)
- `09-retrospective-SKILL-TEMPLATE.md` — nouveau §Étape 2b (M5)

**Exclu :**
- `03-wrap-up-SKILL-TEMPLATE.md` — §0e reste intact (Option B retenue pour P-10)
- `07-DECISIONS-SDLC.md` — pas de nouvelle décision structurelle (imports tactiques)
- Tout autre fichier SDLC

**Interdit :**
- Modifier §Étape 2 existant de la rétrospective — §2b est un ajout après, pas
  un remplacement
- Modifier les niveaux de test A/B/C — clause anti-complaisance s'ajoute,
  ne remplace pas
- Modifier `STANDARDS.md` ou `08-hooks-TEMPLATE.md`

---

## Contenu précis des modifications

### M1 — `01-Claude-md-TEMPLATE.md §Tokens`
Ajouté après le bullet `**Grep avant lecture**` : bullets "Index-guidé" et
"Délégation sous-agent".

### M2 — Rien de plus dans §Tokens
M1 couvre P-06 et P-07 au même emplacement.

### M3 — `01-Claude-md-TEMPLATE.md §Test`
Clause anti-complaisance ajoutée en tête de §Test, avant "Définition "test OK"".

### M4 — `01-Claude-md-TEMPLATE.md §Mémoire de sprint`
Clause "Perte accidentelle en cours de sprint" ajoutée après le bloc
"Ne pas écrire".

### M5 — `09-retrospective-SKILL-TEMPLATE.md` — §Étape 2b (nouveau)
Bloc complet inséré après la fin de §Étape 2 (rapport structuré), avant
§Étape 3.

---

## Critères d'acceptation

**`01-Claude-md-TEMPLATE.md` :**
- [x] `grep "Index-guidé\|index-guidé" 01-Claude-md-TEMPLATE.md` → présent
- [x] `grep "10K tokens\|sous-agent" 01-Claude-md-TEMPLATE.md` → présent (P-07)
- [x] `grep "anti-complaisance\|sortie réelle\|supposition" 01-Claude-md-TEMPLATE.md` → présent (P-02)
- [x] `grep "Perte accidentelle\|RECONSTRUIT\|git diff HEAD" 01-Claude-md-TEMPLATE.md` → présent (P-11)
- [x] `grep "Grep avant lecture" 01-Claude-md-TEMPLATE.md` → toujours présent, intouché (non-régression)
- [x] `grep "niveau A\|niveau B\|niveau C" 01-Claude-md-TEMPLATE.md` → CA imprécis dans la spec d'origine
      (le fichier utilise `**A — Ciblé :**` / `**B — Non-régression :**` / `**C — Intégration :**`,
      jamais la forme littérale "niveau X" sauf une occurrence ponctuelle de "niveau B" et "niveau A" déjà
      présentes avant ce sprint). Vérifié : les 3 niveaux de test A/B/C sont intouchés (non-régression réelle ✓).

**`09-retrospective-SKILL-TEMPLATE.md` :**
- [x] `grep -c "SD-[1-5]" 09-retrospective-SKILL-TEMPLATE.md` → `5`
- [x] `grep "SIGNIFICANT DISCOVERY ALERT" 09-retrospective-SKILL-TEMPLATE.md` → présent
- [x] `grep "✅ SD1 à SD5" 09-retrospective-SKILL-TEMPLATE.md` → présent (reformulé, voir corrections)
- [x] `grep "^## Étape 2b" 09-retrospective-SKILL-TEMPLATE.md` → présent
- [x] `grep "^## Étape 2 " 09-retrospective-SKILL-TEMPLATE.md` → toujours présent, intouché (non-régression)

**Git :**
- [x] `git diff --stat` → exactement 2 fichiers modifiés
- [x] `grep "\[→ ADAPTER\]" 01-Claude-md-TEMPLATE.md` → aucun nouveau placeholder (4 préexistants, intouchés)

---

## Plan de test

- **A — Ciblé :**
  `grep -c "SD-[1-5]" 09-retrospective-SKILL-TEMPLATE.md` → `5` ✓
  `grep -c "Index-guidé\|10K tokens\|anti-complaisance\|Perte accidentelle" 01-Claude-md-TEMPLATE.md` → `4` ✓

- **B — Non-régression :**
  `grep "Grep avant lecture" 01-Claude-md-TEMPLATE.md` → présent ✓
  `grep "^## Étape 2 " 09-retrospective-SKILL-TEMPLATE.md` → présent, intouché ✓

---

## Dépendances

**Inputs requis :**
- [x] `doc/ANALYSE-BMAD-TACTIQUE.md` — lu (Spike SDLC-06, source des patterns)
- [x] SDLC-07 commité — `01-Claude-md-TEMPLATE.md` contient déjà P-01/P-13/P-14
      (`grep "HALT-DEP" 01-Claude-md-TEMPLATE.md` → présent, confirmé)

**Outputs produits :**
- [x] `01-Claude-md-TEMPLATE.md` — §Tokens enrichi + §Test renforcé + §Mémoire de sprint avec dégradation
- [x] `09-retrospective-SKILL-TEMPLATE.md` — §Étape 2b Significant Discovery Alert

---

## Handoff Claude Code

**Fichiers — chargement immédiat :**
```bash
cat 01-Claude-md-TEMPLATE.md           # 3 emplacements à modifier
cat 09-retrospective-SKILL-TEMPLATE.md # 1 bloc à insérer après §Étape 2
```

**Grep de position avant chaque insertion :**
```bash
# M1+M2 : trouver la ligne "Grep avant lecture"
grep -n "Grep avant lecture" 01-Claude-md-TEMPLATE.md

# M3 : trouver la ligne "Définition .test OK."
grep -n 'Définition.*test OK\|définition.*test ok' 01-Claude-md-TEMPLATE.md

# M4 : trouver la fin de "Ne pas écrire"
grep -n "Ne pas écrire" 01-Claude-md-TEMPLATE.md

# M5 : trouver la fin de §Étape 2 et le début de §Étape 3
grep -n "^## Étape 3\|^## Étape 2" 09-retrospective-SKILL-TEMPLATE.md
```

**Init mémoire sprint :**
```bash
echo "# Sprint SDLC-08 — bmad-qualite-continuite · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-SDLC-08-bmad-qualite-continuite.md" >> .claude/sprint-memory.md
```

**Instructions spécifiques :**
- Ordre d'exécution recommandé : M3 → M4 → M1 → M5 (garder M5 pour la fin,
  c'est la plus dense)
- Utiliser `sed` ou `str_replace` selon la complexité de l'insertion
- Après chaque modification : grep de CA correspondant avant de passer à la suivante
- §Étape 2b dans la rétrospective : insérer entre la fin du bloc rapport §Étape 2
  et le séparateur `---` précédant §Étape 3 — ne pas modifier §Étape 2 existant

**Grep de vérification finale :**
```bash
# Ciblés
grep -c "SD-[1-5]" 09-retrospective-SKILL-TEMPLATE.md        # → 5
grep -c "Index-guidé\|10K tokens\|anti-complaisance\|Perte accidentelle" \
  01-Claude-md-TEMPLATE.md                                    # → 4

# Non-régression
grep "Grep avant lecture" 01-Claude-md-TEMPLATE.md            # → présent
grep "^## Étape 2 " 09-retrospective-SKILL-TEMPLATE.md        # → présent
git diff --stat                                               # → 2 fichiers
```

---

## Plan de développement
*(complété par Claude Code en étape 4d)*

**Modules touchés :**
`01-Claude-md-TEMPLATE.md` (§Tokens, §Test, §Mémoire de sprint) ·
`09-retrospective-SKILL-TEMPLATE.md` (§Étape 2b)

**Ordre d'exécution :**
1. Vérifié que SDLC-07 est commité (`grep "HALT-DEP" 01-Claude-md-TEMPLATE.md`)
2. M3 — §Test, clause anti-complaisance (1 bloc, position juste avant "Définition")
3. M4 — §Mémoire de sprint, clause dégradation (1 bloc en fin de section)
4. M1 — §Tokens, 2 bullets après "Grep avant lecture"
5. M5 — §Étape 2b rétrospective (bloc le plus dense — après §Étape 2, avant §Étape 3)
6. Greps CA sur les 2 fichiers + git diff --stat

**Plan de test :**
- A : `grep -c "SD-[1-5]" 09-retrospective-SKILL-TEMPLATE.md` → 5 ✓
- A : `grep -c "Index-guidé\|10K tokens\|anti-complaisance\|Perte accidentelle" 01-Claude-md-TEMPLATE.md` → 4 ✓
- B : `grep "Grep avant lecture" 01-Claude-md-TEMPLATE.md` → présent, intouché ✓

---

## Décision de design documentée

**D-SDLC-08-01 · P-10 absorbé dans SD-1 et SD-5 · 18/06/2026**
P-10 (Critical Readiness Exploration — wrap-up §0e) écarté en tant que modification
standalone. Option B retenue : les dimensions couvertes par P-10 (run réel non obtenu,
dette opérationnelle) sont capturées par SD-1 et SD-5 à la rétrospective. Raison :
éviter la friction wrap-up sur chaque sprint, y compris Doc/Spike où ces questions
ne s'appliquent pas. Compromis accepté : une sprint qui passe en commit sans run réel
n'est détecté qu'à la rétro suivante, pas au wrap-up immédiat.

---

## Corrections ajustées vs spec
*(complété au wrap-up)*

- **M5 — confirmation reformulée** : le texte de confirmation 0-coché était
  spécifié comme `` `✅ SD-1 à SD-5 — RAS · prochain sprint peut démarrer` ``.
  Deux CA de la spec entraient en conflit sur ce texte : (1)
  `grep "✅ SD-1 à SD-5"` → présent (texte littéral exigé) et (2)
  `grep -c "SD-[1-5]"` → `5` (compte de lignes). Comme la ligne de confirmation
  contient elle-même "SD-1" et "SD-5", la garder littérale porte le compte de
  lignes à 6, pas 5. Décision (validée avec l'utilisateur) : reformuler en
  `` `✅ SD1 à SD5 — RAS · prochain sprint peut démarrer` `` (sans tirets) pour
  satisfaire le CA quantitatif (5) plutôt que le CA littéral, qui est abandonné.
- **CA "niveau A/B/C"** : la formulation littérale du CA ("niveau A", "niveau B",
  "niveau C") ne correspond pas au texte réel du fichier (`**A — Ciblé :**` etc.,
  préexistant). Écart de rédaction dans la spec d'origine, sans impact — vérifié
  manuellement que les définitions A/B/C sont intactes.
