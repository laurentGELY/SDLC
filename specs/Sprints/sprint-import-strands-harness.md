# Sprint Doc — Import Strands Harness (R3 + R4)
<!-- Destination : specs/Sprints/sprint-import-strands-harness.md dans le repo SDLC -->
<!-- Précédent direct : M-PROC-38 (Import GSD Vague 1) — même logique de groupage par vague -->
<!-- PDR reçu de Claude.ai, révisé en 4a sur aval utilisateur (23/09/2026) — écarts listés §Corrections ajustées vs spec -->

**Type :** Doc
**Taille :** S (1-3h)
**Surface :** `02-STANDARDS-TEMPLATE.md`, `08-hooks-TEMPLATE.md`, `07-DECISIONS-SDLC.md`,
`docs/ROADMAP.md` + fichiers standards du wrap-up (CHANGELOG, version README/site/HTML,
LESSONS_LEARNED, SESSION_BRIDGE)
**Risque :** Faible

---

## Contexte

Le sprint Revue `audit-strands-harness` (23/09/2026, commits `daa5b9c` + `ba1ad24`, wrap-up
fait) a produit `docs/AUDIT-EXTERNE-strands-harness-vs-sdlc.md` : 5 recommandations —
R1, R2, R5 REJETER (mécanismes d'exécution ou déjà tranchés par `M-TMPL-06`), R3 IMPORTER,
R4 ADAPTER. Ce sprint applique les deux recommandations retenues, aucune autre. Il réalise
l'item `P-45` de `docs/ROADMAP.md §Later`.

---

## Objectif

`02-STANDARDS-TEMPLATE.md §Observabilité` propose des exemples « si projet agent/LLM » dans
les réponses Q/R existantes, `08-hooks-TEMPLATE.md` expose un tableau récapitulatif du rôle de
chaque hook avant `§Arborescence attendue`, et `M-TMPL-09` est commitée dans
`07-DECISIONS-SDLC.md` — sans changer le comportement d'aucun hook existant.

---

## Comportement actuel → cible

- **Actuel :** `§Observabilité` n'a que des exemples pipeline batch. Le rôle de chaque hook
  (garde bloquante / avertissement / observation / transformation) est dispersé sur 3 sections
  distinctes (`08-hooks-TEMPLATE.md` lignes 36-41, 203, 255) sans vue d'ensemble.
- **Cible :** un exemple agent/LLM dans la parenthèse d'exemple des questions Q/R pertinentes ;
  un tableau récapitulatif en tête de `08-hooks-TEMPLATE.md` qui résume ce que chaque hook peut
  faire, chaque ligne citant sa section source.

---

## Portée

**Inclus :**
- **R3** : pour les questions Q/R de `§Observabilité` où un exemple agent a du sens (3 à 4 sur
  5, pas forcé), ajouter l'exemple **dans la parenthèse existante** `*(ex: … · si projet
  agent/LLM : …)*` — texte source dans l'audit §4 (itérations de boucle par interaction,
  succès/échec par outil, tokens prompt/completion, latence modèle)
- **R3** : recopier tel quel le bloc `M-TMPL-09` de l'audit (§4) dans `07-DECISIONS-SDLC.md` —
  compléter uniquement `<sprint>` et `<JJ/MM/AAAA>` ; ajouter la ligne correspondante au tableau
  d'index (après `M-TMPL-08`)
- **R4** : ajouter, avant `## Arborescence attendue` dans `08-hooks-TEMPLATE.md`, un tableau
  `Hook · Rôle · Effet sur Claude Code · Source` couvrant `PreToolUse` (garde `exit 2` et
  avertissement non bloquant), `PostToolUse`, `PreCompact`
- Bump de version mineure en en-tête des 2 templates touchés + entrée `CHANGELOG.md` listant
  les fichiers modifiés et citant `M-TMPL-09`
- `docs/ROADMAP.md` : `P-45` §Later → §Historique ; 1 entrée `Seed` pour l'idée §5-2 de l'audit
  (HALT-TIMEOUT). L'idée §5-1 (pertinence de la checklist Q/R) est déjà couverte par le
  déclencheur de réouverture de `M-TMPL-09` — pas de Seed doublon

**Exclu (explicitement) :**
- R1, R2, R5 — rejetés dans l'audit, aucune action, aucune entrée `07-DECISIONS-SDLC.md`
- Entrée `07-DECISIONS-SDLC.md` pour R4 — l'audit conclut à une clarification documentaire sans
  règle nouvelle ; pas de `M-TMPL-1X` créée pour ce point
- Ajout du verdict `ADAPTER` dans `12-audit-externe-TEMPLATE.md` — reporté à un 2ᵉ audit qui en
  aurait besoin (audit §7)
- Toute modification de comportement des hooks (`pre-tool-bash.sh`, `pre-compact.sh`) — ce
  sprint documente, ne change aucun script
- Tout changement de chemin `docs/` dans l'audit — `docs/` est la convention réelle du repo

---

## Critères d'acceptation

1. `grep -c "agent/LLM" 02-STANDARDS-TEMPLATE.md` → ≥ 3
2. `grep -B3 "^## Arborescence attendue" 08-hooks-TEMPLATE.md | grep -c "^|"` → ≥ 1 (le tableau
   récapitulatif précède la section existante)
3. `grep -n "M-TMPL-09" 07-DECISIONS-SDLC.md` → ligne d'index + titre de l'entrée, avec date et
   sprint réels ; `grep -c "<sprint>\|<JJ/MM/AAAA>" 07-DECISIONS-SDLC.md` → 0
4. `CHANGELOG.md` contient une entrée pour ce sprint citant `02-STANDARDS-TEMPLATE.md`,
   `08-hooks-TEMPLATE.md` et `M-TMPL-09`
5. `docs/ROADMAP.md` : `P-45` absent de §Later et présent en §Historique ; 1 ligne `Seed` en
   §Later avec un déclencheur mesurable depuis ce repo, référençant l'audit Strands
6. `git diff --stat` → aucun template hors `02` et `08` ; `.claude/hooks/*` : seul `pre-tool-bash.sh` ligne 9 (commentaire `exit 1`, aucun changement de comportement)
7. `bash sdlc-validate.sh` → 10/10, exit 0
8. `/wrap-up` exécuté en fin de sprint

---

## Risques

- **Le tableau R4 est lu comme une nouvelle règle plutôt qu'un résumé de règles existantes** :
  faible · mitigation — chaque ligne cite sa section source, rien de nouveau n'est introduit
- **`M-TMPL-09` recopiée avec un placeholder oublié** : faible · mitigation — critère #3

---

## Handoff Claude Code

> Ce PDR ne remplace pas `Claude.md §Démarrage` — les 4 étapes (4a créer le
> fichier spec · 4b initialiser la mémoire sprint · 4c charger les fichiers ·
> 4d écrire le §Plan de développement) restent dues même si ce Handoff n'en
> détaille qu'une partie ci-dessous.

**Fichiers — chargement immédiat :**
- Ce fichier (`specs/Sprints/sprint-import-strands-harness.md`)
- `docs/AUDIT-EXTERNE-strands-harness-vs-sdlc.md` — §4 (texte R3/R4 + bloc `M-TMPL-09`), §5
- `07-DECISIONS-SDLC.md` — dernière entrée `M-TMPL-0X` (reconfirmer `09` libre par grep)

**Fichiers — chargement différé (grep d'abord) :**
- `02-STANDARDS-TEMPLATE.md` → `grep -n "Q:"`
- `08-hooks-TEMPLATE.md` → `## Arborescence attendue` et les 3 sections de hooks

**Grep de vérification préalable :**
```bash
grep -n "M-TMPL-0[4-9]" 07-DECISIONS-SDLC.md | tail -5
grep -n "Q:" 02-STANDARDS-TEMPLATE.md
grep -n "Arborescence attendue" 08-hooks-TEMPLATE.md
```

**Init mémoire sprint :**
```bash
echo "# Sprint Doc — import-strands-harness · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-import-strands-harness.md" >> .claude/sprint-memory.md
```

---

## Plan de développement

**Dépendances vérifiées :**
- [x] Sprint Revue `audit-strands-harness` clos par `/wrap-up` — `ba1ad24`, `sprint-memory.md` supprimé
- [x] `M-TMPL-09` libre — dernier identifiant `M-TMPL-08` (ligne 576 index, 2482 entrée)
- [x] `07-DECISIONS-SDLC.md` exclu en entier de C3 (`C3_EXCEPTIONS`) — le marqueur « À REMPLIR » cité
  dans `M-TMPL-09` ne fait pas échouer `sdlc-validate.sh`
- [x] 5 questions Q/R, lignes 135-148, exemples inline `*(ex: "…")*`

**Modules touchés :** `02-STANDARDS-TEMPLATE.md` (v2.0 → v2.1), `08-hooks-TEMPLATE.md`
(v1.3 → v1.4), `07-DECISIONS-SDLC.md`, `docs/ROADMAP.md` + fichiers du wrap-up.

**Risques identifiés :**
- Historique de version incohérent pour `08-hooks-TEMPLATE.md` (CHANGELOG cite v1.7 avant
  v1.3) — non corrigé ici, bump depuis l'en-tête réel v1.3
- Taille réelle ≈ XS (P-45) ; S retenu pour le coût du wrap-up (version sur 5 fichiers)

**Plan d'exécution :**
1. R3 — exemples agent/LLM sur Q1 (démarrage), Q2 (succès), Q3 (avertissement), Q5 (item ignoré) ; Q4 (commande tail) sans exemple spécifique
2. R3 — `M-TMPL-09` dans `07-DECISIONS-SDLC.md` (entrée + index)
3. R4 — tableau 4 lignes en tête de `08-hooks-TEMPLATE.md`
4. ROADMAP — P-45 → Historique, 1 Seed
5. Tests A/B, `/wrap-up`

**Plan de test :**
- A — Ciblé : critères 1 à 5, un grep par critère
- B — Non-régression : critère 6 (`git diff --stat`) + critère 7 (`sdlc-validate.sh`)

---

## Corrections ajustées vs spec

Écarts entre le PDR reçu de Claude.ai et cette version (revue en session, aval utilisateur 23/09/2026) :
- **`doc/` → `docs/`** partout — `doc/` n'existe pas. Tâche « corriger la ligne 80 de l'audit
  `docs/`→`doc/` » et son critère supprimés : elle aurait introduit un lien mort.
- **Critère « diff limité à 6 fichiers »** remplacé par « aucun template hors 02/08, aucun hook »
  — le wrap-up touche nécessairement README, `docs/meta.json`, `docs/pages/versions.md`, les
  marqueurs HTML (C1/C9/C10), LESSONS_LEARNED, SESSION_BRIDGE.
- **Note « préalable wrap-up Revue »** supprimée — vérifiée faite (`ba1ad24`).
- **P-45** ajouté (§Later → §Historique) ; **ligne d'index `M-TMPL-09`** ajoutée à la portée.
- **Seeds : 2 → 1** — l'idée §5-1 est déjà le déclencheur de réouverture de `M-TMPL-09`.
- **R3** : exemples dans la parenthèse existante plutôt qu'une ligne séparée ; « chacune des 5 »
  retiré (contradictoire avec « 3 à 4 »).
- **R4** : `PreToolUse` sur 2 lignes (garde / avertissement) + colonne Source.
- **Critère 2** : `grep -B3 … | grep -c "^|"` au lieu de `grep -B2` (`LL-T12`).
- **Encart 4a-4d** (`M-TMPL-08`) ajouté en tête du Handoff.
- **Rétractation** : le risque « marqueur À REMPLIR dans `M-TMPL-09` fait échouer C3 », soulevé en
  revue du PDR, était faux — `07-DECISIONS-SDLC.md` est exclu de C3 en entier.
- **Correction hors PDR — `exit 1`** : `08-hooks-TEMPLATE.md` (en-tête du script) et `.claude/hooks/pre-tool-bash.sh:9`
  affirmaient « `exit 1` = bloquer (silencieux) ». Faux selon `code.claude.com/docs/en/hooks` (vérifié
  23/09/2026) : `exit 1` = erreur non bloquante, seul `exit 2` bloque. Aucun `exit 1` actif dans les scripts —
  commentaires seuls. Corrigé dans les 2 fichiers ; le hook actif sur aval explicite de l'utilisateur (critère 6 ajusté).
