# Sprint SDLC-22 — Instrumentation conso token réelle

**Type :** Feature
**Taille :** S
**Surface :** `03-wrap-up-SKILL-TEMPLATE.md` (§0c) · `09-retrospective-SKILL-TEMPLATE.md` (nouvelle section métriques) · nouveau script `sdlc-token-usage.sh` (hors templates numérotés, même famille que `sdlc-project-check.sh`)
**Risque :** Faible

---

## Contexte

Le Sprint Lean précédent (bilan + avis Oracle) a identifié des pistes d'allègement
token mais sans mesure réelle pour les arbitrer — seulement des proxys statiques
(`wc -w` sur les fichiers gouvernance). Or les transcripts Claude Code écrivent déjà
un `usage` (`input_tokens`, `output_tokens`, `cache_read_input_tokens`,
`cache_creation_input_tokens`) par message, horodaté, et `sprint-memory.md`
horodate déjà chaque étape du sprint (`HH:MM TYPE — résumé`). La corrélation des
deux existe en germe mais n'est exploitée nulle part.

Par ailleurs, `wrap-up §0c` demande aujourd'hui à l'utilisateur de **coller
manuellement** `git diff --stat` / `git status`, alors que Claude Code dispose déjà
de l'outil bash pour les exécuter lui-même — friction sans gain de fiabilité,
repérée lors de la revue de l'avis Oracle externe.

---

## Objectif

Disposer d'une mesure réelle (pas estimée) de la consommation token par étape de
sprint, exploitable en `/retrospective`, et supprimer une étape de copier-coller
manuel devenue inutile dans `/wrap-up`.

---

## Comportement actuel → cible

- **Actuel :**
  - Aucune mesure de conso token réelle — seuls des proxys statiques (taille fichier)
  - `wrap-up §0c` : l'utilisateur colle `git diff --stat` / `git status` à la main
  - `/retrospective` ne reporte aucune métrique de token
- **Cible :**
  - Script `sdlc-token-usage.sh` qui parse le(s) JSONL de session, en déduit
    input/output/cache_read par message, et — si `sprint-memory.md` présent —
    par intervalle entre entrées horodatées
  - `wrap-up §0c` exécute `git diff --stat HEAD` / `git status` lui-même via bash,
    plus de copier-coller demandé à l'utilisateur
  - `/retrospective` affiche une baseline M1 (plancher Claude.md+STANDARDS.md)
    et M2 (coût wrap-up), mesurée tous les ~5 sprints

---

## Portée

**Inclus :**
- Script `sdlc-token-usage.sh` (bash, zéro dépendance lourde — `jq` autorisé,
  cohérent avec `sdlc-project-check.sh`)
- `03-wrap-up-SKILL-TEMPLATE.md §0c` réécrite : exécution bash directe au lieu
  de la demande de collage
- `09-retrospective-SKILL-TEMPLATE.md` : nouvelle section optionnelle
  §Métriques tokens — appel du script, affichage M1/M2, comparaison au sprint
  précédent si donnée disponible

**Exclu (explicitement) :**
- Dashboard temps réel ou par agent (hors échelle — rejeté en avis Oracle)
- Budget token de session / nouveau HALT (changement de périmètre comportemental,
  candidat séparé en `ROADMAP §Later`)
- Application des pistes de coupe (élagage Claude.md, archivage DECISIONS) —
  ce sprint instrumente, ne coupe rien
- Modification de `cache_creation`/`cache_read` côté API — lecture seule du JSONL

---

## Option retenue — alternatives écartées

**Retenue :** script bash autonome lisant les transcripts JSONL locaux
(`~/.claude/projects/.../*.jsonl`), corrélé optionnellement à `sprint-memory.md`
par fenêtre de timestamps.

**Écartée(s) :**
- Dashboard quotidien (pratique citée par l'Oracle externe) — disproportionné
  pour la fréquence de sprint actuelle (pas un usage continu multi-agents)
- Mesure par instrumentation du hook PreToolUse — ne capture pas `usage` (absent
  du payload hook), seul le transcript JSONL porte cette donnée
- Nouveau skill `/token-audit` dédié — sur-ingénierie pour un script appelé
  toutes les ~5 sprints (même raisonnement que M-PROC-24 pour
  `sdlc-project-check.sh` : script, pas skill)

**Sacrifices délibérés :** pas de garantie multi-OS sur le chemin du dossier
`~/.claude/projects/` — documenté comme limitation connue, pas bloquant pour
l'usage local actuel (cf. M-ENV-01, même nature de contrainte).

---

## Contraintes techniques / produit

- Script bash pur ou bash+jq, cohérent avec `sdlc-project-check.sh` (< 60 lignes
  visé, zéro dépendance lourde)
- Ne modifie aucun fichier — lecture seule des transcripts et de `sprint-memory.md`
- `wrap-up §0c` : si bash échoue (repo non-git, environnement restreint) →
  fallback sur l'ancien comportement (demande de collage), ne jamais bloquer
  le wrap-up sur cette étape

**Interdit :**
- Faire dépendre `/retrospective` du script — si absent ou en échec, dégrader
  proprement (comme le fallback CLAUDE_PROJECT existant, M-PROC-22)
- Introduire une nouvelle convention de marqueur (`[À REMPLIR]`, `[→ ADAPTER]`...)
  pour ce sprint — réutiliser l'existant

---

## Dépendances

**Inputs requis :**
- [x] `sprint-memory.md` — format d'horodatage `HH:MM TYPE` stable (M-PROC-10/13/14/15) — confirmé `Claude.md:266-272`
- [x] Présence de `jq` dans l'environnement local — confirmé (`/usr/bin/jq`)

**Outputs produits :**
- [x] `sdlc-token-usage.sh` — script réutilisable par tout projet bootstrappé
- [x] §0c `wrap-up` réécrite — réutilisable dans tous les projets au prochain `/sdlc-sync`
- [x] §Métriques tokens `/retrospective` — baseline M1/M2 mesurée, point de
      comparaison pour juger l'effet réel des pistes 1 et 4 du Sprint Lean précédent

---

## Critères d'acceptation

- [x] `bash -n sdlc-token-usage.sh` → exit 0
- [x] Exécution sur une session réelle → affiche au moins `input_tokens`,
      `output_tokens`, `cache_read_input_tokens` totaux, sans erreur
- [x] Si `sprint-memory.md` présent → sortie bucketisée par étape (tableau
      étape/input/output/cache_read)
- [x] Si `sprint-memory.md` absent → total brut affiché, pas d'erreur bloquante
- [x] `wrap-up §0c` : `git diff --stat HEAD` et `git status` exécutés par bash,
      zéro demande de collage à l'utilisateur dans le cas nominal
- [x] Fallback `§0c` testé : si `git` indisponible → ancien comportement
      (demande de collage) déclenché sans erreur
- [x] `/retrospective` affiche M1 (Claude.md + STANDARDS.md, mots) et M2
      (wrap-up SKILL.md, mots) — mesure statique, pas besoin du script JSONL
      pour cette partie
- [x] CHANGELOG mis à jour
- [x] Entrée `07-DECISIONS-SDLC.md` — format M-PROC-XX (exécuté sur le toolkit
      lui-même, pas sur un projet cible)

---

## Risques

- **Format JSONL non documenté publiquement, peut évoluer** : probabilité moyenne
  · mitigation : script tolérant aux champs manquants (`usage` absent → skip,
  pas de crash), versionner la structure observée dans `doc/DIAGNOSTIC_CMDS.md`
- **Chemin `~/.claude/projects/` non garanti stable inter-OS** : probabilité faible
  (usage local connu) · mitigation : variable configurable en tête de script,
  documentée comme M-ENV si le projet l'exécute en routine

---

## Handoff Claude Code

**Données collectées avant code (cf. Plan de développement) :**
- Structure réelle confirmée sur un JSONL de cette session : entrée `type=="assistant"`
  porte `.timestamp` (ISO 8601 UTC) et `.message.usage.{input_tokens,output_tokens,
  cache_read_input_tokens,cache_creation_input_tokens}`
- `jq` présent (`/usr/bin/jq`)
- Aucun `sprint-memory.md` antérieur trouvé dans l'historique du repo (premier usage
  du script sur cette session)

---

## Plan de développement

**Dépendances vérifiées :**
- [x] `sprint-memory.md` — format horodatage confirmé (`Claude.md:266-272`, entrées `[HH:MM] TYPE — texte`)
- [x] `jq` — présent (`/usr/bin/jq`)

**Modules touchés :**
- `sdlc-token-usage.sh` (nouveau)
- `03-wrap-up-SKILL-TEMPLATE.md` §0c
- `09-retrospective-SKILL-TEMPLATE.md` (nouvelle section)
- `CHANGELOG.md`, `07-DECISIONS-SDLC.md`, `README.md` (table de version)

**Risques identifiés :**
- Bucketisation par `HH:MM` (sans date) suppose un sprint contenu sur une même
  journée locale — acceptable pour l'usage actuel (sprints mono-session),
  documenté comme limitation dans le script lui-même
- Conversion UTC (timestamp JSONL) → heure locale (sprint-memory) via
  `jq 'fromdateiso8601 | localtime | strftime("%H:%M")'` — dépend du `TZ` système

**Plan d'exécution :**
1. Écrire `sdlc-token-usage.sh` : totaux bruts + bucketisation optionnelle
2. Réécrire `03-wrap-up-SKILL-TEMPLATE.md §0c` (bash direct + fallback documenté)
3. Ajouter `§Métriques tokens` à `09-retrospective-SKILL-TEMPLATE.md`
4. Documenter structure JSONL observée dans `doc/DIAGNOSTIC_CMDS.md`
5. CHANGELOG + DECISIONS (M-PROC-36) + README table de version

**Plan de test :**
- A — Ciblé : `bash -n sdlc-token-usage.sh && bash sdlc-token-usage.sh --dry-run`
- **Volumétrie minimum :** ≥ 1 session JSONL réelle avec ≥ 1 entrée `usage` non nulle
  — confirmé, session courante en contient des centaines
- B — Non-régression : `§0c` ancien comportement encore atteignable via fallback

---

## Corrections ajustées vs spec
*(complété au wrap-up — §Étape 3)*
