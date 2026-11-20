Statut : ouvert
# Sprint SDLC-35 — Hygiène post-rétro : Fix post-rétro 20/11 + reste de l'alignement du `CLAUDE.md` de ce dépôt
<!-- PDR rédigé en session Claude Code le 20/11/2026 depuis docs/ROADMAP.md (§Next « Fix post-rétro 20/11 », §Later « Aligner le CLAUDE.md de ce dépôt ») · dépôt @ a02862c -->

**Type :** Fix
**Taille :** cœur S (5 corrections ciblées + 3 retraits dans `CLAUDE.md`) · total M une fois la gouvernance comptée (`07`, CHANGELOG, bump, site, ROADMAP, LESSONS — `M-PROC-28`)
**Modèle exécutant :** claude-opus-5-5 — inchangé depuis la `/retrospective` du 20/11/2026, où `/doctor prompt-audit` a été lancé
**Surface :** `sdlc-validate.sh` (C12), `tests/sdlc-validate-test.sh`, `03-wrap-up-SKILL-TEMPLATE.md` + skill vivant, `sdlc-delta.sh`, `tests/sdlc-init-test.sh`, `12-audit-externe-TEMPLATE.md`, `CLAUDE.md` de ce dépôt, gouvernance
**Risque :** Faible — aucun template diffusé n'est restructuré ; `01` (budget C11) n'est pas touché

---

## Contexte

La `/retrospective` du 20/11/2026 a décidé un sprint Fix (`docs/ROADMAP.md §Next`) pour quatre constats : `LL-T16` (champ « Modèle exécutant » jamais rempli : la vérification « modèle changé ? » de la rétro est impossible), `LL-T14` (totaux écrits de mémoire, récidive après graduation), `LL-T15` (`sdlc-delta.sh` sans test, affichage « ABSENT » sous la version) et le `SDLC_CANDIDATE` ECO-7 (c). La ligne §Later « Aligner le `CLAUDE.md` de ce dépôt », partiellement traitée par le prompt-audit (`a02862c`), garde trois règles en double avec `/reprise` ou retirées de `01` ; son déclencheur (« prochain sprint qui touche `CLAUDE.md` ») est atteint par regroupement XS/S (`CLAUDE.md §Tokens`).

## Objectif

Rendre mécaniques les vérifications que la rétro a trouvées manquantes, réparer `sdlc-delta.sh`, et finir l'alignement du `CLAUDE.md` de ce dépôt sur `01` v2.10 pour les règles déplacées vers `/reprise` ou retirées.

## Comportement actuel → cible

| # | Actuel (constaté le 20/11) | Cible |
|---|---|---|
| a | C12 ne lit que la ligne 1 ; aucune spec n'a `**Modèle exécutant :**` | C12 refuse une spec `Statut : ouvert` sans ligne `**Modèle exécutant :**` renseignée (placeholder `[modèle` refusé) ; specs closes non lues |
| b | `03 §3.5` ne relance aucun total cité | Une ligne : relancer la commande de chaque total cité dans l'entrée CHANGELOG et SESSION_BRIDGE (`LL-T14`), template + skill vivant |
| c | `sdlc-delta.sh:36-40` : si `STANDARDS.md` manque, `grep` sort en 2 sous `pipefail` et `\|\| echo "ABSENT"` s'ajoute sous la version trouvée (reproduit sur bootstrap jetable) ; aucun test | Version seule, ou « ABSENT » seulement si aucune n'est trouvée ; cas de test (à jour, en retard, `STANDARDS.md` absent, variante `doc/`) |
| d | `12` n'impose pas d'établir l'état du dépôt avant de lire une source externe | `12 §2` : état courant du dépôt (`git log`, scripts lancés) cité avant toute lecture de la source (ECO-7 (c), `LL-T04`) |
| e | `03:326`, `03:503` demandent de tenir `docs/DEPENDENCY_MAP.md`, que le bootstrap ne crée pas (R-91 retirée par ELAG-4) | Mentions retirées (le skill vivant ne les a déjà plus) |
| f | `CLAUDE.md:118-139` : bloc « MÉMOIRE SPRINT NON VIDE » complet (R-26), en double avec `/reprise` | Renvoi de deux lignes, texte de `01` v2.10 |
| g | `CLAUDE.md:310-320` : « Perte accidentelle » complète (R-56), en double avec `/reprise` | Renvoi de deux lignes, texte de `01` v2.10 |
| h | `CLAUDE.md:241-246` : section « Candidat hook » (R-49), retirée de `01` par SDLC-34 | Retirée (collecte au `/wrap-up`, Étapes 1-2) |

## Portée

**Inclus :** a à h ci-dessus, gouvernance associée (bump `v2.0+SDLC-35`).
**Exclu :** P-15 (architecture step-file, §Next, sprint suivant) · règle absolue « avant de coder » sans 4e (`CLAUDE.md:19` et `01:20` à l'identique — hors constat) · R-35 (absente du `CLAUDE.md` de ce dépôt, vérifié par grep).

## Contraintes techniques / produit

- Modifications ciblées : `Edit` ou `sed` + grep de vérification (`CLAUDE.md §Modifications spot`).
- Template modifié → version incrémentée (C2) ; template de skill modifié → même changement dans le skill vivant (C4).
- Nouveau cas de contrôle vu **rouge** avant le correctif (C12, `sdlc-delta.sh`).
- Tests du hook vivant : aucune chaîne `pkill`/`pgrep -f` en clair dans une commande (M-HOOKS-09).
- `03` est à 510 lignes (déclencheur P-15) : ajout net ≤ 1 ligne dans `03`.

**Interdit :** toucher `01` (budget C11) · restructurer `03` (P-15) · modifier les specs closes.

## Critères d'acceptation

- [ ] (a) `bash tests/sdlc-validate-test.sh` contient ≥ 2 nouveaux cas C12 (spec ouverte sans champ → rouge ; champ placeholder → rouge), vus rouges avant le correctif · `bash sdlc-validate.sh` → C12 vert sur le dépôt (cette spec porte le champ)
- [ ] (b) `grep -n "LL-T14" 03-wrap-up-SKILL-TEMPLATE.md .claude/skills/wrap-up/SKILL.md` non vide dans les deux
- [ ] (c) bootstrap jetable sans `STANDARDS.md` : `bash sdlc-delta.sh <projet> | grep -cx ABSENT` → 0 ; cas de test ajoutés à `tests/sdlc-init-test.sh`, vus rouges avant le correctif
- [ ] (d) `grep -n "git log" 12-audit-externe-TEMPLATE.md` non vide
- [ ] (e) `grep -c "DEPENDENCY_MAP" 03-wrap-up-SKILL-TEMPLATE.md` → 0
- [ ] (f, g) `grep -c "MÉMOIRE SPRINT NON VIDE\|Perte accidentelle en cours de sprint" CLAUDE.md` → 0 · `grep -c "/reprise" CLAUDE.md` en hausse
- [ ] (h) `grep -c "Candidat hook" CLAUDE.md` → 0
- [ ] `wc -l 03-wrap-up-SKILL-TEMPLATE.md` ≤ 511
- [ ] Tests niveau A : `bash sdlc-validate.sh` 12/12 · `bash tests/sdlc-validate-test.sh` · `bash tests/sdlc-init-test.sh` tous OK · `bash -n sdlc-delta.sh sdlc-validate.sh`
- [ ] CHANGELOG `v2.0+SDLC-35`, C1 vert

## Pas de placeholders

`grep -En "TBD|à implémenter plus tard|gestion d'erreur appropriée|cas limites appropriés|similaire à la tâche" specs/Sprints/sprint-SDLC-35-hygiene-post-retro.md` → seule la ligne de ce paragraphe correspond.

## Risques

- C12 rougit une spec ouverte existante : aucune autre spec n'est `Statut : ouvert` (inventaire C12 du 20/11) · cette spec porte le champ.
- Correctif `sdlc-delta.sh` qui change la sortie attendue par `04b` : `04b` lit la sortie à l'œil, pas par motif (grep à faire en 4d).

---
<!-- FIN PRD — La section Handoff est complétée par Claude Code en début de session -->

## Handoff Claude Code

**Fichiers — chargement immédiat :** ce PDR · `sdlc-validate.sh` (`check_c12`) · `sdlc-delta.sh:30-50`
**Fichiers — chargement différé (grep d'abord) :** `tests/sdlc-validate-test.sh` (cas C12) · `tests/sdlc-init-test.sh` · `03` §3.5 · `12` §2 · `CLAUDE.md` · `07` (`M-PROC-53`, `M-PROC-61`)

**Init mémoire sprint :**
```bash
echo "# Sprint SDLC-35 — hygiene-post-retro · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-SDLC-35-hygiene-post-retro.md" >> .claude/sprint-memory.md
```

---

## Plan de développement
*(étape 4d — 20/11/2026, dépôt @ `a02862c`)*

**Dépendances vérifiées :** baseline 12/12 · 27/27 · 67/67 (dernier passage `a02862c`) · défaut (c) reproduit (copie de bootstrap sans `STANDARDS.md` → ligne `ABSENT` sous `Projet : v2.0+SDLC-29`) · `set -euo pipefail` à `sdlc-delta.sh:9` · R-35 absente de `CLAUDE.md`.

**Plan d'exécution** (branche `sdlc-35`, un commit) :
1. (a) cas C12 RED dans `tests/sdlc-validate-test.sh` → vus rouges → `check_c12` étendu → verts ; « → Mise à jour » sous `M-PROC-53` dans `07`
2. (c) cas `sdlc-delta.sh` RED dans `tests/sdlc-init-test.sh` → vus rouges → correctif (`{ grep … || true; }`, `ABSENT` si vide) → verts
3. (b), (e) `03` v2.4 + skill vivant ; (d) `12` v1.1
4. (f, g, h) `CLAUDE.md` : renvois de `01` v2.10, section Candidat hook retirée
5. tests complets → `/wrap-up` (bump `v2.0+SDLC-35`)

**Plan de test :**
- A — `bash sdlc-validate.sh && bash tests/sdlc-validate-test.sh && bash tests/sdlc-init-test.sh && bash -n sdlc-delta.sh sdlc-validate.sh` + chaque grep des critères
- B — `sdlc-delta.sh` sur bootstrap complet inchangé (« Déjà à jour » / inventaire) ; C12 inchangé sur les specs closes
- C — N/A

---

## Corrections ajustées vs spec
*(complété au wrap-up — §Étape 3)*
