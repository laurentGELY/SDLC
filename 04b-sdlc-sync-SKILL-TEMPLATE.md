---
name: sdlc-sync
description: Alignement du projet sur une nouvelle version du modèle SDLC. Utiliser quand le modèle a évolué ou sur demande.
---
# sdlc-sync — SKILL
<!-- Template SDLC v2.3 · Destination : .claude/skills/sdlc-sync/SKILL.md dans le repo cible -->
<!-- Générique — copier tel quel, zéro adaptation -->

Aligne la gouvernance du projet courant sur la version SDLC indiquée dans les sources.
Exécuter quand le modèle SDLC a évolué depuis le dernier alignement, ou à la demande.

**Principe d'exécution** : aucune modification de fichier sans validation humaine explicite.
Le tuning local du projet prime toujours sur le modèle générique.

---

## Étape 0 — Détection de version

```bash
# Version actuelle du projet
cat CLAUDE.md Claude.md STANDARDS.md 2>/dev/null | grep "SDLC version" || echo "ABSENT"
```

| Résultat | Situation | Suite |
|----------|-----------|-------|
| `SDLC version : vX.Y` | Projet versionné | Delta vX.Y → courant |
| `ABSENT` | Antérieur au modèle générique | Delta complet depuis zéro |
| Version = courante | À jour | Confirmer à l'humain, s'arrêter |

La version courante du modèle SDLC est indiquée dans l'en-tête de `CLAUDE.md`
et `STANDARDS.md` des fichiers sources du projet SDLC.

**Ancien nom `Claude.md` :** si `CLAUDE.md` est absent et `Claude.md` présent, le fichier
d'instructions n'est pas chargé par Claude Code sous Linux (système sensible à la casse).
Proposer le renommage en deux temps, sûr aussi sur macOS et Windows :
`git mv Claude.md Claude.md.tmp && git mv Claude.md.tmp CLAUDE.md` — puis appliquer le delta
au fichier renommé (`M-ARCH-10`).

---

## Étape A — Inventaire

```bash
# Fichiers de gouvernance présents dans le projet
ls CLAUDE.md Claude.md STANDARDS.md CHANGELOG.md .gitignore 2>/dev/null
ls docs/DECISIONS.md docs/ROADMAP.md docs/LESSONS_LEARNED.md docs/DIAGNOSTIC_CMDS.md docs/REMONTEE_SDLC.md 2>/dev/null
ls -d doc/ specs/Sprints/sprint-template.md doc/DECISIONS*.md doc/REPRISE.md doc/REMONTEE_SDLC.md 2>/dev/null   # réglages locaux (ci-dessous)
ls .claude/skills/wrap-up/SKILL.md \
   .claude/skills/retrospective/SKILL.md \
   .claude/skills/sdlc-sync/SKILL.md \
   .claude/skills/reprise/SKILL.md 2>/dev/null
for f in specs/Sprints/sprint-*.md; do head -1 "$f" | grep -qE '^Statut : ' || echo "sans marqueur : $f"; done
ls .claude/hooks/pre-tool-bash.sh .claude/hooks/pre-compact.sh .claude/settings.json 2>/dev/null
head -1 .claude/skills/*/SKILL.md   # « --- » attendu : frontmatter name/description
ls specs/sprint-template.md specs/SPEC.md 2>/dev/null
```

**Mécanismes du bootstrap à aligner (`M-ARCH-10`)** — chacun est un écart s'il manque :
regex de poussée forcée du bloc `[UNIVERSEL]` de `08` (option cherchée dans le seul segment
du push) · `.gitignore` avec `.env`, `.claude/sprint-memory.md`, `.claude/settings.local.json` ·
frontmatter `name`/`description` de chaque skill · `pre-compact.sh` et ses entrées `PreCompact`.

**Mémoire de reprise (`M-PROC-55`)** — trois mécanismes, chacun un écart s'il manque :
skill `.claude/skills/reprise/SKILL.md` (copié de `13-reprise-SKILL-TEMPLATE.md`, adapter seulement
les répertoires de sorties datées de `/reprise init`) · `.claude/reprise.md` dans le `.gitignore` ·
marqueur `Statut` en ligne 1 des specs `specs/Sprints/sprint-*.md`. Specs sans marqueur → appliquer
`/reprise` §Amorçage (liste `fichier → statut` soumise à l'humain avant écriture), puis `/reprise init`.
Un correctif ou un équivalent local déjà présent (ex. `doc/REPRISE.md`) est classé « déjà aligné », jamais écrasé.

**File de remontées (`M-PROC-61`)** — `docs/REMONTEE_SDLC.md` à 3 sections (« Entrées », « Remontées en
attente », « Décisions demandées au projet SDLC ») ; absente → la créer vide depuis `sdlc-init.sh`. Les
`[SDLC_CANDIDATE]` encore portés par `docs/LESSONS_LEARNED.md` y sont reportés, l'entrée LESSONS gardant un renvoi.

**Réglages locaux de chemin (`M-PROC-59`)** — une variante détectée par `ls` est un réglage local, jamais
un écart : la consigner dans l'entrée `D-SYNC-XX` (ligne « Réglages locaux ») et appliquer le delta au
chemin local. Le skill reste « zéro adaptation ».

| Chemin du modèle | Variantes locales acceptées |
|---|---|
| `docs/` | `doc/` |
| `specs/sprint-template.md` | `specs/Sprints/sprint-template.md` |
| `docs/DECISIONS.md` | `doc/DECISIONS.md` · `DECISIONS-<famille>.md` |
| `.claude/reprise.md` | `doc/REPRISE.md` |
| `docs/REMONTEE_SDLC.md` | `doc/REMONTEE_SDLC.md` |

Produire le tableau d'inventaire avant de continuer :

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 INVENTAIRE GOUVERNANCE — [projet] — [date]
Version détectée : [vX.Y / ABSENT]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ [fichier] — présent
❌ [fichier] — absent → à créer depuis template courant
⚠️  [fichier] — présent, sections à comparer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Étape B — Tri section par section

Pour chaque fichier présent, comparer avec le template courant du modèle SDLC.
Consulter le tableau de compatibilité dans `07-DECISIONS-SDLC.md` §Tableau de compatibilité
pour qualifier chaque décision manquante (universelle / conditionnelle).

**Règle de tri :**

| Situation | Action |
|-----------|--------|
| Section absente, universelle | → AJOUTER |
| Section absente, conditionnelle | → Vérifier la contrainte dans le projet · AJOUTER si pertinent · IGNORER sinon |
| Section présente, formulée différemment | → Comparer : MIGRER si bénéfice net · LAISSER sinon |
| Tuning local sans équivalent SDLC | → LAISSER · noter REMONTER? si candidat remontée |

Produire la liste de décisions complète :

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔍 DÉCISIONS SDLC-SYNC — [projet]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
→ AJOUTER   : [section] dans [fichier] — universelle (M-PROC-XX)
→ AJOUTER   : [section] dans [fichier] — conditionnelle (contrainte vérifiée : [oui/non])
→ IGNORER   : [section] dans [fichier] — [raison]
→ MIGRER    : [section] dans [fichier] — bénéfice net : [description]
→ LAISSER   : [section] dans [fichier] — tuning local · [description]
→ REMONTER? : [tuning] — candidat [SDLC_CANDIDATE] · [description]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Attendre l'aval explicite de l'humain avant de passer à l'étape C.**

---

## Étape C — Application

Appliquer uniquement les décisions validées. Dans l'ordre :
1. Créer les fichiers absents (depuis template courant, adapter si nécessaire)
2. Ajouter les sections manquantes dans les fichiers existants
3. Appliquer les migrations validées (noter la valeur précédente en commentaire)

**Zéro modification sur les éléments classés LAISSER.**

Pour chaque fichier modifié : vérifier `git diff [fichier]` avant de continuer.

---

## Étape D — Traçabilité

### D1 — Entrée DECISIONS.md

Ajouter dans `docs/DECISIONS.md` du projet :

```markdown
## D-SYNC-01 · Alignement SDLC vX.Y (ou "antérieur") → vZ.W · [date]

Appliqués    : [liste sections ajoutées/migrées]
Ignorés      : [liste + raison]
Laissés      : [tuning local conservé + description]
Réglages locaux : [chemin du modèle → variante locale détectée, ou « aucun »]
Remontées ?  : [SDLC_CANDIDATE si trouvés — inscrits dans docs/REMONTEE_SDLC.md]
```

### D2 — Marqueur de version

Apposer dans `CLAUDE.md` **et** `STANDARDS.md` :

```
<!-- SDLC version : vZ.W · aligné le JJ/MM/AAAA -->
```

### D3 — Vérification finale

```bash
grep "SDLC version" CLAUDE.md STANDARDS.md   # doit afficher vZ.W dans les deux
git diff --stat                               # uniquement fichiers de gouvernance attendus
```

### D4 — Vérification CLAUDE_PROJECT

```bash
bash /chemin/vers/sdlc-toolkit/sdlc-project-check.sh "Nom du projet Claude.ai"
# → affiche delta (fichiers absents de docs/CLAUDE_PROJECT.md)
# → si delta non vide : mettre à jour docs/CLAUDE_PROJECT.md avant de commiter
```

Si `docs/CLAUDE_PROJECT.md` absent → le créer avec `sdlc-project-check.sh` (voir `06-PDR-bootstrap.md §Étape 1b`).

---

## Étape E — Commit

```
docs(gouvernance): SDLC-Sync vX.Y → vZ.W

- [changement 1]
- [changement 2]
- Tests : N/A (gouvernance uniquement)
```

---

## Critères d'acceptation

- [ ] Inventaire complet produit avant toute modification
- [ ] Liste de décisions validée par l'humain avant application
- [ ] Zéro élément LAISSER modifié
- [ ] Marqueur `<!-- SDLC version : vZ.W -->` dans `CLAUDE.md` et `STANDARDS.md`
- [ ] Entrée `D-SYNC-XX` dans `docs/DECISIONS.md`
- [ ] `git diff --stat` : uniquement fichiers de gouvernance attendus
- [ ] Commit conforme au format ci-dessus
