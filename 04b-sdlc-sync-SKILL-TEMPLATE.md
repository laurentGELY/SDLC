# sdlc-sync — SKILL
<!-- Template SDLC v1.9 · Destination : .claude/skills/sdlc-sync/SKILL.md dans le repo cible -->
<!-- Générique — copier tel quel, zéro adaptation -->

Aligne la gouvernance du projet courant sur la version SDLC indiquée dans les sources.
Exécuter quand le modèle SDLC a évolué depuis le dernier alignement, ou à la demande.

**Principe d'exécution** : Claude fait l'inventaire et le tri, propose la liste de décisions,
attend l'aval humain, puis applique. Aucune modification de fichier sans validation explicite.
Le tuning local du projet prime toujours sur le modèle générique.

---

## Étape 0 — Détection de version

```bash
# Version actuelle du projet
grep "SDLC version" Claude.md STANDARDS.md 2>/dev/null || echo "ABSENT"
```

| Résultat | Situation | Suite |
|----------|-----------|-------|
| `SDLC version : vX.Y` | Projet versionné | Delta vX.Y → courant |
| `ABSENT` | Antérieur au modèle générique | Delta complet depuis zéro |
| Version = courante | À jour | Confirmer à l'humain, s'arrêter |

La version courante du modèle SDLC est indiquée dans l'en-tête de `Claude.md`
et `STANDARDS.md` des fichiers sources du projet SDLC.

---

## Étape A — Inventaire

```bash
# Fichiers de gouvernance présents dans le projet
ls Claude.md STANDARDS.md CHANGELOG.md 2>/dev/null
ls doc/DECISIONS.md doc/ROADMAP.md doc/LESSONS_LEARNED.md doc/DIAGNOSTIC_CMDS.md 2>/dev/null
ls .claude/skills/wrap-up/SKILL.md \
   .claude/skills/retrospective/SKILL.md \
   .claude/skills/sdlc-sync/SKILL.md 2>/dev/null
ls .claude/hooks/pre-tool-bash.sh .claude/settings.json 2>/dev/null
ls specs/sprint-template.md specs/SPEC.md 2>/dev/null
```

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

Ajouter dans `doc/DECISIONS.md` du projet :

```markdown
## D-SYNC-01 · Alignement SDLC vX.Y (ou "antérieur") → vZ.W · [date]

Appliqués    : [liste sections ajoutées/migrées]
Ignorés      : [liste + raison]
Laissés      : [tuning local conservé + description]
Remontées ?  : [SDLC_CANDIDATE si trouvés — à reporter manuellement dans projet SDLC]
```

### D2 — Marqueur de version

Apposer dans `Claude.md` **et** `STANDARDS.md` :

```
<!-- SDLC version : vZ.W · aligné le JJ/MM/AAAA -->
```

### D3 — Vérification finale

```bash
grep "SDLC version" Claude.md STANDARDS.md   # doit afficher vZ.W dans les deux
git diff --stat                               # uniquement fichiers de gouvernance attendus
```

### D4 — Vérification CLAUDE_PROJECT

```bash
bash /chemin/vers/sdlc-toolkit/sdlc-project-check.sh "Nom du projet Claude.ai"
# → affiche delta (fichiers absents de doc/CLAUDE_PROJECT.md)
# → si delta non vide : mettre à jour doc/CLAUDE_PROJECT.md avant de commiter
```

Si `doc/CLAUDE_PROJECT.md` absent → le créer avec `sdlc-project-check.sh` (voir `06-PDR-bootstrap.md §Étape 1b`).

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
- [ ] Marqueur `<!-- SDLC version : vZ.W -->` dans `Claude.md` et `STANDARDS.md`
- [ ] Entrée `D-SYNC-XX` dans `doc/DECISIONS.md`
- [ ] `git diff --stat` : uniquement fichiers de gouvernance attendus
- [ ] Commit conforme au format ci-dessus
