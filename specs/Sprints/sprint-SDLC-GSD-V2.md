# Sprint SDLC-GSD-V2 — Import GSD : patterns impact fort (Vague 2)
<!-- SDLC v1.9+SDLC-GSD-V1 · specs/Sprints/sprint-SDLC-GSD-V2.md -->

**Type :** Doc
**Taille :** M
**Surface :** `09-retrospective-SKILL-TEMPLATE.md` · `03-wrap-up-SKILL-TEMPLATE.md` · `01-Claude-md-TEMPLATE.md` · `doc/SESSION_BRIDGE.md` (structure)
**Risque :** Moyen — la Prop K restructure un fichier versionné existant dans les projets cibles

---

## Contexte

Suite directe de SDLC-GSD-V1 (Vague 1 committée, `v1.9+SDLC-GSD-V1`).
Trois propositions validées dans `doc/SYNTHESE-AUDITS-GSD.md §4 Vague 2` :

- **Prop H** — Graduation semi-automatique dans `/retrospective`
- **Prop K** — Séparation hot/cold dans SESSION_BRIDGE
- **Prop D** — Journalism Standard (hypothesis tracking) pour sessions diagnostic

Décisions actées (`SYNTHESE-AUDITS-GSD.md §5`) :
- L précède K — critère de qualité (Vague 1, déjà fait) avant restructuration du contenant
- Prop D conditionnelle — activée uniquement sur sessions BLOQUANT/BUG

---

## Objectif

Trois mécanismes SDLC améliorés, chacun vérifiable par grep ou par structure de fichier :

1. `/retrospective` détecte automatiquement les patterns récurrents et propose la graduation
2. `doc/SESSION_BRIDGE.md` a une structure §Actif / §Archive qui reste légère naturellement
3. Le format SESSION_BRIDGE a une extension optionnelle hypothesis tracking pour les diagnostics

---

## Comportement actuel → cible

| Fichier | Actuel | Cible |
|---------|--------|-------|
| `09-retrospective-SKILL-TEMPLATE.md §Étape 2` | Analyse patterns manuellement — aucun seuil de promotion automatique | Scan §Index : si pattern ≥ 3 occurrences dans 5 derniers sprints → bloc GRADUATION proposé à l'humain |
| `doc/SESSION_BRIDGE.md` (template et existant) | Accumulatif plat, nettoyage conditionnel > 5 entrées | Deux sections : §Actif (≤ 3 entrées, chargé au §Démarrage) + §Archive (chargé sur demande) |
| `03-wrap-up-SKILL-TEMPLATE.md §Étape 5` | Écrit SESSION_BRIDGE en entrée unique en tête | Écriture dans §Actif, archivage conditionnel si §Actif > 3 entrées |
| `01-Claude-md-TEMPLATE.md §Démarrage` | Lit `doc/SESSION_BRIDGE.md` complet | Lit uniquement §Actif — §Archive sur demande explicite |
| `03-wrap-up-SKILL-TEMPLATE.md §Étape 5` (diagnostic) | Format fixe 4 champs | Si sprint de type Diagnostic/BUG : extension optionnelle hypothesis table |

---

## Portée

**Inclus :**

**Prop H — Graduation dans `/retrospective` :**
Ajouter dans `09-retrospective-SKILL-TEMPLATE.md §Étape 2` un bloc GRADUATION
automatique : après le scan des patterns, vérifier l'§Index — tout pattern avec
`Occurrences ≥ 3` ET `Statut: actif` dans une fenêtre de 5 sprints récents est
soumis à l'humain pour décision de promotion. Destinations possibles : `Claude.md`,
`STANDARDS.md`, `.claude/hooks/` (nouveau hook), ou `doc/LESSONS_LEARNED.md §Règles`.

**Prop K — Hot/cold SESSION_BRIDGE :**
- Modifier `03-wrap-up-SKILL-TEMPLATE.md §Étape 5` : écriture dans §Actif, archivage
  conditionnel automatique si §Actif > 3 entrées (déplacer la plus ancienne en §Archive)
- Modifier `01-Claude-md-TEMPLATE.md §Démarrage §2` : charger uniquement §Actif
  par défaut, §Archive sur demande explicite de l'humain
- Mettre à jour le format de bootstrap SESSION_BRIDGE dans `03-wrap-up §Étape 5` :
  header avec deux sections §Actif / §Archive

**Prop D — Hypothesis tracking (conditionnel) :**
Ajouter dans `03-wrap-up-SKILL-TEMPLATE.md §Étape 5`, après le format SESSION_BRIDGE
de base, un bloc conditionnel : si le sprint était de type Diagnostic, BUG, ou
BLOQUANT non résolu → ajouter une table `§Hypothèses` au SESSION_BRIDGE de ce sprint.

**Exclu explicitement :**
- Prop A (sous-agents Taille L) — Vague 3
- Prop E1 (skill /quick) — Vague 3
- Prop B (commits atomiques) — réexaminer après Prop A
- Toute modification de code ou de hook existant
- Migration des SESSION_BRIDGE existants dans les projets cibles (fait manuellement
  si nécessaire — trop dépendant du projet)

---

## Dépendances

**Inputs requis :**
- [x] `doc/SYNTHESE-AUDITS-GSD.md` — §4 Vague 2 + §5 décisions
- [x] `v1.9+SDLC-GSD-V1` committé (Prop L déjà dans §Étape 5 — ancre textuel disponible)
- [x] `09-retrospective-SKILL-TEMPLATE.md` — §Étape 2 + §Index format actuel
- [x] `03-wrap-up-SKILL-TEMPLATE.md §Étape 5` — format SESSION_BRIDGE actuel (4 champs + STATELESS)
- [x] `01-Claude-md-TEMPLATE.md §Démarrage §2` — règle lecture SESSION_BRIDGE

**Outputs produits :**
- [x] `09-retrospective-SKILL-TEMPLATE.md` vX.Y+1 — §Étape 2 + bloc GRADUATION
- [x] `03-wrap-up-SKILL-TEMPLATE.md` vX.Y+1 — §Étape 5 hot/cold + hypothesis tracking conditionnel
- [x] `01-Claude-md-TEMPLATE.md` vX.Y+1 — §Démarrage §2 lecture §Actif uniquement
- [x] `07-DECISIONS-SDLC.md` — entrée M-PROC-39 (3 props Vague 2)
- [x] CHANGELOG entrée `Sprint SDLC-GSD-V2`

**Non-output (intentionnel) :**
`doc/SESSION_BRIDGE.md` n'est pas un template dans le repo SDLC — c'est un fichier versionné
dans chaque projet cible. Ce sprint modifie uniquement les règles qui gouvernent sa structure
(dans wrap-up et Claude.md). La migration des SESSION_BRIDGE existants est hors scope.

---

## Contenu exact à implémenter

### Prop H — Bloc GRADUATION dans /retrospective §Étape 2

Ajouter **à la fin** du bloc de rapport §Étape 2 (après `AUCUN PATTERN NOTABLE`),
**avant** `---` de fin de section :

```markdown
GRADUATION — patterns candidats à promotion
```

Et dans la description de l'§Étape 2, ajouter après le bloc de rapport :

```
**Graduation automatique :**
Après le rapport, scanner l'§Index des patterns (doc/LESSONS_LEARNED.md) :
- Identifier tout pattern avec Occurrences ≥ 3 ET Statut: actif
- Vérifier que les occurrences se trouvent dans les 5 derniers sprints
  (grep les IDs sprint dans les colonnes Sprints de l'§Index)
- Si condition remplie → produire le bloc suivant pour chaque candidat :

---
🎓 GRADUATION CANDIDATE — [ID Pattern] · [Nom]
Occurrences : [N] sur [liste sprints]
Résumé : [description du pattern en 1 phrase]

Destinations possibles :
  A) Claude.md §[section pertinente] — règle permanente de comportement
  B) STANDARDS.md §[section] — standard projet à appliquer à tous les sprints
  C) .claude/hooks/ — garde-fou automatique (nécessite M-PROC-X dans DECISIONS)
  D) doc/LESSONS_LEARNED.md §Règles — règle documentée, pas encore hookée

→ Décision demandée : quelle destination ? (A / B / C / D / différer)
---

Si l'humain valide une destination :
- Pour A ou B : appliquer dans ce sprint si trivial, sinon créer un sprint Fix dédié
- Pour C : créer un HOOK_CANDIDATE avec ligne bash proposée, décision dans DECISIONS.md
- Pour D : ajouter sous §Règles dans LESSONS_LEARNED, modifier Statut → "promu (D)"
- Pour "différer" : marquer Statut → "surveillé" dans l'§Index, réévaluer à la prochaine rétro

Si aucun candidat → confirmer explicitement "✅ Graduation — aucun pattern ≥ 3 occurrences actif."
```

---

### Prop K — Hot/cold SESSION_BRIDGE

**Modification 1 : `03-wrap-up-SKILL-TEMPLATE.md §Étape 5`**

Remplacer le bloc de création du format SESSION_BRIDGE actuel par :

```markdown
**Écriture dans `doc/SESSION_BRIDGE.md` :**

Structure cible du fichier (créer si absent, sinon respecter les sections existantes) :

```markdown
# SESSION_BRIDGE — Contexte inter-session
<!-- §Actif : ≤ 3 entrées récentes — chargé automatiquement au §Démarrage -->
<!-- §Archive : entrées plus anciennes — chargé sur demande explicite uniquement -->

## §Actif

## §Archive
```

**Écriture de la nouvelle entrée :**
Insérer en tête de `## §Actif` (entrée la plus récente en premier) :

```markdown
### [Sprint N — slug] · [AAAA-MM-JJ]
**Commit :** [hash court]
**Bloquants en suspens :** [liste ou "aucun"]
**Fil fonctionnel :** [2 phrases max — état du livrable après ce sprint]
```

**Archivage conditionnel :**
Compter les entrées `### ` dans `## §Actif`.
Si > 3 entrées après l'ajout → déplacer la plus ancienne (dernière entrée `###` de §Actif)
dans `## §Archive` (en tête de §Archive, même format).

**Extension hypothesis tracking (Prop D — conditionnel) :**
Si le sprint était de type Diagnostic, BUG, ou BLOQUANT non résolu → ajouter
après le bloc standard de l'entrée §Actif :

```markdown
**§Hypothèses :**
| Hypothèse | Probabilité | Test | Statut |
|-----------|-------------|------|--------|
| [hypothèse] | Haute / Moyenne / Basse | [commande ou observation] | CONFIRMÉE / REJETÉE / EN ATTENTE |
```

Ne pas inclure la table si le sprint n'est pas de type diagnostic — overhead inutile.
```

**Modification 2 : `01-Claude-md-TEMPLATE.md §Démarrage §2`**

Remplacer la règle de lecture SESSION_BRIDGE par :

```
2. Si `doc/SESSION_BRIDGE.md` existe → lire uniquement la section `## §Actif`
   (entrées récentes, contexte inter-session immédiatement pertinent).
   `## §Archive` : ne pas charger sauf si l'humain demande explicitement
   "remonte un sprint ancien" ou référence un sprint précédent par son nom.
```

---

## Critères d'acceptation

### Prop H
- [x] `grep -n "GRADUATION\|graduation\|Graduation" 09-retrospective-SKILL-TEMPLATE.md` → ≥ 3 résultats
- [x] `grep -n "≥ 3\|Occurrences ≥" 09-retrospective-SKILL-TEMPLATE.md` → ≥ 1 résultat
- [x] `grep -n "Destinations possibles\|différer\|promu" 09-retrospective-SKILL-TEMPLATE.md` → ≥ 2 résultats

### Prop K
- [x] `grep -n "§Actif\|§Archive" 03-wrap-up-SKILL-TEMPLATE.md` → ≥ 2 résultats dans §Étape 5
- [x] `grep -n "§Actif\|§Archive" 01-Claude-md-TEMPLATE.md` → ≥ 1 résultat dans §Démarrage
- [x] `grep -n "> 3 entrées\|archivage conditionnel\|Archivage conditionnel" 03-wrap-up-SKILL-TEMPLATE.md` → ≥ 1 résultat

### Prop D
- [x] `grep -n "Hypothèses\|hypothesis\|CONFIRMÉE\|REJETÉE" 03-wrap-up-SKILL-TEMPLATE.md` → ≥ 3 résultats
- [x] `grep -n "Diagnostic\|BUG\|BLOQUANT non résolu" 03-wrap-up-SKILL-TEMPLATE.md` → ≥ 1 résultat (déclencheur conditionnel)

### Non-régression
- [x] `grep -c "## Étape" 03-wrap-up-SKILL-TEMPLATE.md` — avant/après identique (zéro étape supprimée)
- [x] `grep -c "## Étape" 09-retrospective-SKILL-TEMPLATE.md` — avant/après identique
- [x] `grep -n "STATELESS" 03-wrap-up-SKILL-TEMPLATE.md` → toujours présent (Prop L Vague 1 conservée)
- [x] `grep -n "SESSION_BRIDGE" 01-Claude-md-TEMPLATE.md` → ≥ 1 résultat (règle de lecture non supprimée)
- [x] `grep -n "M-PROC-39" 07-DECISIONS-SDLC.md` → 1 résultat (entrée créée)

---

## Risques

**Prop K — collision avec SESSION_BRIDGE existants dans projets cibles**
Si un projet cible a déjà un SESSION_BRIDGE au format plat (sans §Actif / §Archive),
le `03-wrap-up` modifié essaiera d'écrire dans `## §Actif` qui n'existe pas.
Mitigation : ajouter dans le wrap-up une vérification préalable :
`grep -q "## §Actif" doc/SESSION_BRIDGE.md || [créer les deux sections]`
→ rétrocompatibilité automatique, le template crée les sections manquantes au premier
wrap-up post-migration.

**Prop H — graduation sans §Index structuré**
Si un projet cible n'a pas encore l'§Index des patterns dans `LESSONS_LEARNED.md`
(non présent avant M-PROC-17, Sprint SDLC-05 / v1.6), la graduation ne peut pas
scanner. Mitigation : le bloc graduation commence par `grep -q "§Index des patterns"` —
si absent → "§Index absent, graduation non disponible, déclencher /retrospective complète."

**Prop D — sur-ingénierie sur sprint standard**
Le bloc hypothesis tracking ne doit jamais apparaître hors sprint diagnostic.
Mitigation : la condition est explicite dans le wrap-up (type sprint BUG/Diagnostic/BLOQUANT)
et le bloc est facultatif avec décision de l'humain.

---

## Pre-mortem

> Si ce sprint produit une régression, la cause la plus probable est :
> la modification §Étape 5 du wrap-up écrase le bloc STATELESS HANDOFF ajouté en Vague 1
> en remplaçant plutôt qu'en étendant.

Mitigation : vérifier `grep -n "STATELESS" 03-wrap-up-SKILL-TEMPLATE.md` après chaque
modification de §Étape 5 — doit toujours retourner ≥ 1 résultat.

---

## Handoff Claude Code

**Fichiers — chargement immédiat :**
```bash
# Localiser les ancres textuels avant de modifier
grep -n "GRADUATION\|§Étape 2" 09-retrospective-SKILL-TEMPLATE.md | head -20
grep -n "STATELESS\|SESSION_BRIDGE\|§Étape 5" 03-wrap-up-SKILL-TEMPLATE.md | head -20
grep -n "SESSION_BRIDGE\|§Démarrage" 01-Claude-md-TEMPLATE.md | head -20
```

**Comptes de non-régression à capturer AVANT toute modification :**
```bash
grep -c "## Étape" 03-wrap-up-SKILL-TEMPLATE.md
grep -c "## Étape" 09-retrospective-SKILL-TEMPLATE.md
grep -n "STATELESS" 03-wrap-up-SKILL-TEMPLATE.md
grep -n "SESSION_BRIDGE" 01-Claude-md-TEMPLATE.md
```

**Fichiers — chargement différé :**
- `09-retrospective-SKILL-TEMPLATE.md` complet — seulement si l'ancre §Étape 2 ne suffit pas
- `03-wrap-up-SKILL-TEMPLATE.md` complet — seulement si §Étape 5 s'étend sur plus de
  lignes que prévu par les greps

**Instructions spécifiques :**
- Ordre d'exécution : H → K (wrap-up §Étape 5) → K (Claude.md §Démarrage) → D
  Raison : H est indépendant, K en deux temps (wrap-up avant Claude.md), D extension de K
- Prop K §Étape 5 : NE PAS remplacer le bloc SESSION_BRIDGE actuel — l'étendre avec
  la structure §Actif / §Archive et l'archivage conditionnel
- Prop K Claude.md : remplacer uniquement la ligne de lecture SESSION_BRIDGE — pas la section entière
- Vérifier `grep -n "STATELESS" 03-wrap-up-SKILL-TEMPLATE.md` après Prop K avant de continuer
- Entrée M-PROC-39 dans `07-DECISIONS-SDLC.md` en une seule entrée groupée (3 props)
- Un seul commit final après tous les CA passés

**Init mémoire sprint :**
```bash
echo "# Sprint SDLC-GSD-V2 · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-SDLC-GSD-V2.md" >> .claude/sprint-memory.md
```

---

## Plan de développement
*(à compléter par Claude Code après localisation des ancres)*

**Dépendances vérifiées :**
- [x] `09-retrospective-SKILL-TEMPLATE.md` — §Étape 2 localisée + fin du bloc rapport localisée
- [x] `03-wrap-up-SKILL-TEMPLATE.md` — §Étape 5 complète localisée, STATELESS confirmé présent
- [x] `01-Claude-md-TEMPLATE.md` — règle lecture SESSION_BRIDGE §Démarrage §2 localisée
- [x] `doc/SYNTHESE-AUDITS-GSD.md` — §4 Vague 2 accessible (différé)

**Plan d'exécution (ordre strict) :**
1. Capturer comptes non-régression (bash — avant modification)
2. Prop H — ajouter bloc GRADUATION après le rapport §Étape 2 de /retrospective
3. CA H — 3 greps
4. Prop K (wrap-up) — étendre §Étape 5 avec structure §Actif/§Archive + archivage conditionnel
5. Vérifier STATELESS toujours présent
6. Prop D — ajouter bloc hypothesis tracking conditionnel après §Actif
7. CA K + D — 5 greps
8. Prop K (Claude.md) — remplacer ligne lecture SESSION_BRIDGE par lecture §Actif uniquement
9. CA K Claude.md — 1 grep
10. CA non-régression — 4 greps (Étapes comparées + STATELESS + SESSION_BRIDGE Claude.md)
11. Incrémenter versions dans les 3 en-têtes de templates
12. Écrire entrée M-PROC-39 dans `07-DECISIONS-SDLC.md`
13. Mettre à jour CHANGELOG
14. Adversarial Review (Taille M — couches 1 et 2)
15. Commit

**Plan de test :**
- A — Ciblé : 9 greps individuels (voir §Critères d'acceptation)
- A — Non-régression : 4 greps comparatifs (avant/après Étapes count, STATELESS, SESSION_BRIDGE Claude.md)

---

## Corrections ajustées vs spec
*(complété au wrap-up)*

- **Prop H** — ajout de `[liste — voir §Graduation automatique ci-dessous]` comme placeholder dans le bloc rapport (non prévu dans la spec, ajouté pour clarté)
- **Prop K Claude.md** — utilisation de `awk` (extraction §Actif→§Archive) au lieu d'une règle textuelle : la section §Démarrage étant un bash block, une commande exécutable est cohérente avec le reste du template
- **Prop D** — label "Extension hypothesis tracking (conditionnel)" plutôt que "Prop D — conditionnel" : évite la référence à un ID de prop dans un fichier de production
- **Versions** : 09-retro v1.7→v1.8, 03-wrap-up v1.5→v1.6, 01-Claude-md v1.9→v2.0
