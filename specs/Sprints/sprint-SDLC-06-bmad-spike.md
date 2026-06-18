# Sprint SDLC-06 — Analyse tactique BMad Method
<!-- Template SDLC v1.9 · Destination : specs/Sprints/sprint-SDLC-06-bmad-spike.md -->

**Type :** Spike
**Taille :** M
**Surface :** Gouvernance SDLC — lecture du repo cloné + analyse tactique
**Risque :** Faible

---

## Contexte

Une analyse stratégique (niveau docs publiques) a été produite dans `doc/ANALYSE-BMAD.md`.
Elle identifie les avantages/faiblesses des deux modèles à haut niveau.

Ce sprint approfondit la lecture **au niveau tactique** : patterns d'implémentation
dans les fichiers source du repo cloné (`/exemples/bmad-method/`), formulations
dans les skill .md, mécaniques de gestion du contexte, structures de prompt, etc.

L'objectif : trouver ce qu'on ne peut pas voir depuis la doc publique.

---

## Objectif

Produire `doc/ANALYSE-BMAD-TACTIQUE.md` — un catalogue de patterns concrets
extraits des fichiers source BMad, classés par notre capacité à les adapter.

---

## Portée

**Inclus :**
- Lecture des skills source BMad (`.md`)
- Extraction de patterns de formulation, gestion d'état, enforcement, structure de prompt
- Comparaison ligne-à-ligne avec nos templates là où c'est pertinent
- Catalogue PATTERN / SOURCE / APPLICABLE / PROPOSITION

**Exclu :**
- Toute modification de nos templates (décision post-discussion dans Claude.ai)
- Re-faire l'analyse stratégique déjà dans `doc/ANALYSE-BMAD.md`
- Analyse des modules secondaires (TEA, BMGD, CIS)

---

## Dépendances

**Inputs requis :**
- [x] `/exemples/bmad-method/` — repo cloné et accessible (path réel : `exemples/bmad-method/`, relatif — corrigé)
- [x] `doc/ANALYSE-BMAD.md` — analyse stratégique existante (ne pas répéter) (absent au démarrage, fourni par l'utilisateur en cours de session)

**Outputs produits :**
- [x] `doc/ANALYSE-BMAD-TACTIQUE.md` — catalogue tactique (19 fiches P-XX)

**Vérification préalable :**
```bash
ls /exemples/bmad-method/src/ | head -20
# → doit afficher des dossiers bmad-agent-*, bmad-prd, bmad-retrospective, etc.
# Si absent → signaler le path correct avant de continuer
```

---

## Plan de lecture — ordre et priorités

### Étape 1 — Cartographie du repo (5 min)
```bash
# Structure générale
find /exemples/bmad-method/src -type d | sort
find /exemples/bmad-method/src -name "*.md" | wc -l
find /exemples/bmad-method/src -name "*.toml" | wc -l

# Tailles des skills pour prioriser
wc -l /exemples/bmad-method/src/*/SKILL.md 2>/dev/null | sort -rn | head -20

# Fichiers de config globaux
ls /exemples/bmad-method/src/_bmad/ 2>/dev/null || \
  find /exemples/bmad-method -name "config.toml" | head -5
```

### Étape 2 — Skills à lire intégralement (priorité haute)
Lire dans cet ordre, extraire les patterns au fur et à mesure :

```bash
# 1. Le skill qui guide l'humain — notre modèle n'en a pas
cat /exemples/bmad-method/src/bmad-help/SKILL.md

# 2. La rétrospective — comparer avec notre 09-retrospective-SKILL-TEMPLATE.md
cat /exemples/bmad-method/src/bmad-retrospective/SKILL.md

# 3. Le dev story — le cœur de l'implémentation
cat /exemples/bmad-method/src/bmad-dev-story/SKILL.md

# 4. Le code review avec adversarial review intégré
cat /exemples/bmad-method/src/bmad-code-review/SKILL.md

# 5. L'implementation readiness gate
cat /exemples/bmad-method/src/bmad-check-implementation-readiness/SKILL.md

# 6. La forensic investigation (niveaux de preuve)
cat /exemples/bmad-method/src/bmad-investigate/SKILL.md

# 7. Le PRD — lifecycle planning
cat /exemples/bmad-method/src/bmad-prd/SKILL.md

# 8. Le wrap-up équivalent BMad
# (chercher le skill qui fait le bilan de sprint)
grep -rl "retrospective\|wrap.up\|sprint.*end\|close.*sprint" \
  /exemples/bmad-method/src/ --include="*.md" | head -5
```

### Étape 3 — Agents nommés — structure et persona
```bash
# Lire UNE persona complète pour comprendre la structure
cat /exemples/bmad-method/src/bmad-agent-dev/SKILL.md

# Le fichier de customisation pour comprendre le système TOML
cat /exemples/bmad-method/src/bmad-agent-dev/customize.toml 2>/dev/null || \
  find /exemples/bmad-method/src/bmad-agent-dev -type f | xargs ls -la

# La config centrale du roster d'agents
find /exemples/bmad-method -name "config.toml" | head -3 | xargs cat 2>/dev/null
```

### Étape 4 — Gestion du contexte et des tokens
```bash
# Chercher les patterns de gestion de contexte
grep -rn "context\|token\|window\|memory\|load.*file\|eager\|lazy\|shard" \
  /exemples/bmad-method/src/ --include="*.md" -l

# Lire les fichiers trouvés si pertinents (grep d'abord)
grep -n "token\|window\|load\|context" /exemples/bmad-method/src/bmad-dev-story/SKILL.md | head -20
```

### Étape 5 — Enforcement et règles non-négociables
```bash
# BMad a-t-il un équivalent de nos hooks bash ?
find /exemples/bmad-method -name "*.sh" | head -10
ls /exemples/bmad-method/.husky/ 2>/dev/null

# Chercher les patterns d'enforcement dans les skills
grep -rn "MUST\|NEVER\|ALWAYS\|block\|prevent\|forbidden\|mandatory" \
  /exemples/bmad-method/src/ --include="*.md" | head -30
```

### Étape 6 — Système de mémoire et état de session
```bash
# BMad a-t-il un équivalent de sprint-memory.md ?
grep -rn "memory\|session\|state\|persist\|remember\|context.*file" \
  /exemples/bmad-method/src/ --include="*.md" -l | head -10

# Lire le plus pertinent
grep -n "memory\|session\|persist" \
  /exemples/bmad-method/src/bmad-dev-story/SKILL.md | head -20
```

### Étape 7 — Structure des prompts et formulations remarquables
Pour chaque skill lu, noter les formulations qui "font la différence" :
- Structures de raisonnement (step-by-step, chain-of-thought explicite)
- Patterns de vérification
- Gestion des cas limites ("si X alors Y sinon Z")
- Tone et persona enforcement

---

## Format de sortie : ANALYSE-BMAD-TACTIQUE.md

Pour chaque pattern trouvé, une fiche :

```markdown
### P-XX · [Nom court du pattern]
**Source :** `/exemples/bmad-method/src/[skill]/SKILL.md` (ligne N)
**Citation (≤ 5 lignes) :**
> [extrait textuel exact]

**Ce que ça fait :** [1-2 phrases]
**Pourquoi c'est intéressant :** [comparaison avec notre modèle]
**Applicable :** OUI directement / OUI avec adaptation / NON (trop couplé BMad)
**Proposition :** [si applicable — destination dans notre modèle et formulation adaptée]
```

Grouper les fiches par catégorie :
- §A — Enforcement & vérification
- §B — Gestion du contexte & des tokens
- §C — Boucles de rétroaction & apprentissage
- §D — Formulations prompt remarquables
- §E — Structure des skills
- §F — Autres patterns

En conclusion : **Top 5 patterns à discuter en priorité**, classés par impact/effort.

---

## Critères d'acceptation

- [x] `ls /exemples/bmad-method/src/` vérifié avant lecture (path corrigé en `exemples/bmad-method/src/`)
- [x] ≥ 8 skills lus intégralement (étapes 2 et 3) — bmad-help, bmad-retrospective, bmad-dev-story, bmad-code-review (+4 steps), bmad-check-implementation-readiness (+step-06), bmad-investigate, bmad-prd, bmad-agent-dev (+customize.toml)
- [x] Greps étapes 4-6 exécutés et résultats documentés (même si RAS) — voir sprint-memory et §B/§A/§C de l'analyse tactique
- [x] ≥ 10 fiches P-XX dans l'analyse tactique (19 fiches)
- [x] Chaque fiche : citation exacte + source ligne + proposition concrète
- [x] Top 5 patterns en conclusion
- [x] Comparaison avec nos templates là où les écarts sont significatifs

---

## Handoff Claude Code

**Init mémoire sprint :**
```bash
echo "# Sprint SDLC-06 — bmad-tactique · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-SDLC-06-bmad-spike.md" >> .claude/sprint-memory.md
```

**Fichiers SDLC à lire en parallèle (chargement immédiat) :**
Ces fichiers servent de référence pour les comparaisons — les avoir en contexte.
```bash
cat doc/ANALYSE-BMAD.md          # analyse stratégique existante — ne pas répéter
cat 01-Claude-md-TEMPLATE.md     # notre §Analyse, §Mémoire de sprint
cat 03-wrap-up-SKILL-TEMPLATE.md # notre skill wrap-up — comparer avec bmad-retrospective
cat 09-retrospective-SKILL-TEMPLATE.md # notre retrospective
```

**Instructions spécifiques :**
- Citer les lignes exactes des fichiers BMad — jamais de paraphrase pour les fiches P-XX
- Si un skill n'existe pas au path attendu : chercher avec `find` et adapter
- NE PAS modifier nos templates — output uniquement dans `doc/ANALYSE-BMAD-TACTIQUE.md`
- Si un skill est très long (> 200 lignes) : grep les sections clés d'abord, lire entièrement si le grep révèle des patterns
- Sprint-memory : noter un ANALYSE par skill lu avec CONF et 1 ligne de synthèse

**Grep de vérification finale avant commit :**
```bash
grep "^### P-" doc/ANALYSE-BMAD-TACTIQUE.md | wc -l  # doit être ≥ 10
grep "Top 5" doc/ANALYSE-BMAD-TACTIQUE.md            # doit exister
```

---

## Corrections ajustées vs spec

1. **Path repo cloné** — la spec référençait `/exemples/bmad-method/src/` (absolu) avec une structure plate supposée (`bmad-agent-*`, `bmad-prd`, `bmad-retrospective` directement sous `src/`). Le repo réel est à `exemples/bmad-method/src/` (relatif à la racine du toolkit), structuré en deux familles : `src/core-skills/` (transverses) et `src/bmm-skills/{1-analysis,2-plan-workflows,3-solutioning,4-implementation}/` (module BMM). Tous les chemins de lecture de la spec ont été remappés avant utilisation — documenté en tête de `doc/ANALYSE-BMAD-TACTIQUE.md`.
2. **`doc/ANALYSE-BMAD.md` absent au démarrage** — dépendance déclarée comme existante dans la spec, introuvable dans le repo en début de session. Bloquant signalé à l'utilisateur (AskUserQuestion) avant de continuer ; l'utilisateur l'a fourni en cours de session (initialement déposé à la racine, déplacé vers `doc/` pour respecter la structure attendue).
3. **bmad-code-review et bmad-check-implementation-readiness** sont des skills à architecture "step-file" (le SKILL.md ne contient que l'activation + un pointeur vers `./steps/step-01-*.md`) — la spec demandait `cat .../SKILL.md` seul, ce qui n'aurait donné aucun contenu métier. Les fichiers `steps/` pertinents ont été lus en complément (non prévu explicitement par la spec mais nécessaire pour respecter l'objectif "patterns concrets").
4. **Deux corrections factuelles identifiées dans `doc/ANALYSE-BMAD.md`** (l'analyse stratégique, pas la spec elle-même) — reportées en fin d'analyse tactique plutôt que corrigées directement dans le fichier stratégique (hors périmètre de ce sprint) : verdict readiness gate réel `READY/NEEDS WORK/NOT READY` (pas `PASS/CONCERNS/FAIL`) ; grading investigation réel `Confirmed/Deduced/Hypothesized` + statut séparé `Open/Confirmed/Refuted` (pas une échelle unique à 4 niveaux).

**Fichiers à relire dans Claude.ai :** `doc/ANALYSE-BMAD-TACTIQUE.md` (catalogue complet) avant toute décision d'import dans les templates.
