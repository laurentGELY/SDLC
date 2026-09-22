# Sprint SDLC-32 — Rappel 4a-4d dans le PDR, réévaluation `LL-T05`

**Type :** Doc
**Taille :** XS
**Sprint :** SDLC-32 (22/09/2026)

---

## §Contexte

`/retrospective` (SDLC-31, 22/09/2026) a déclenché `SD-5` sur un
`[SDLC_CANDIDATE]` ouvert depuis SDLC-16 (19/06/2026, 3 mois) : le bloc
`## Handoff Claude Code` de `04-sprint-PDR-TEMPLATE.md` cite les étapes 4b
(« Init mémoire sprint »), 4c (« chargement immédiat/différé ») et 4d
(« Plan de développement, étape 4d ») séparément, dans des commentaires
disjoints — jamais 4a (créer le fichier spec), et jamais un rappel unifié
renvoyant à `Claude.md §Démarrage`. Un lecteur qui ne travaille que depuis le
PDR peut manquer 4a sans qu'aucun garde-fou ne le détecte avant le
`/wrap-up` (c'est exactement `LL-T05`, 2 occurrences : SDLC-16, SDLC-Audit-GSTACK).

**Vérification factuelle avant rédaction :**

1. `grep -n '4a\.\|4b\.\|4c\.\|4d\.' Claude.md` confirme la terminologie exacte
   des 4 étapes dans `Claude.md §Démarrage` (4a Créer le fichier spec · 4b
   Initialiser la mémoire sprint · 4c Charger les fichiers · 4d Écrire le
   §Plan de développement) — à reprendre à l'identique dans le rappel.
2. `LL-T05` porte un déclencheur de réouverture explicite : *« dès que
   `P-20`/`ECO-5` est livré, réévaluer si le garde-fou manuel reste
   nécessaire en plus »*. `ECO-5` est livré depuis le 03/09/2026 (hook
   `SessionStart` rejeté, pattern `.claude/rules/` documenté à la place) —
   jamais réévalué depuis. Ce sprint clôt cette réévaluation : le rappel
   ajouté ici est jugé suffisant comme garde-fou additionnel, sans
   mécanisation (cohérent avec 2 décisions similaires de la session
   précédente : pas de hook pour un défaut de prose/lecture).

---

## §Portée

**Inclus :**
- `04-sprint-PDR-TEMPLATE.md` : rappel unifié des 4 étapes en tête de
  `## Handoff Claude Code`, renvoyant à `Claude.md §Démarrage`
- `docs/LESSONS_LEARNED.md` : champ décision du candidat SDLC-16 mis à jour
  (implémenté) · `LL-T05` — statut `Actif` → `Résolu` avec la réévaluation
  actée
- `07-DECISIONS-SDLC.md` : entrée `M-TMPL-08`
- Bump standard (`README.md`, `CHANGELOG.md`, `docs/meta.json`,
  `docs/pages/versions.md`, marqueurs `SPEC.html`/`MODE-OPERATOIRE.html`)

**Exclu :**
- Item 2 (`SDLC-18`, résolution de chemin dans `pre-tool-bash.sh`) — sprint
  séparé, touche un hook bloquant, discipline de test en isolation
  (`M-PROC-30`) à respecter, pas mélangé à ce sprint Doc.
- Modification de `Claude.md §Démarrage` lui-même — déjà correct, seule la
  citation manquait côté PDR.

---

## §Critères d'acceptation

- [ ] `grep -c '4a' 04-sprint-PDR-TEMPLATE.md` → ≥ 1 (aucune occurrence avant ce sprint — c'est le défaut corrigé)
- [ ] `grep -c 'Claude.md §Démarrage' 04-sprint-PDR-TEMPLATE.md` → ≥ 1
- [ ] `grep -n '^## Handoff Claude Code'` suivi du rappel dans les 5 lignes
- [ ] `grep -c 'décision : \*\*implémenté\*\*\|décision : \*\*tranché\*\*.*implémenté' docs/LESSONS_LEARNED.md` → le champ du candidat SDLC-16 reflète l'implémentation
- [ ] `grep -c '^## M-TMPL-08' 07-DECISIONS-SDLC.md` → `1`
- [ ] `bash sdlc-validate.sh` → 10/10, exit 0

---

## §Plan de développement

1. `04-sprint-PDR-TEMPLATE.md` — ajouter le rappel, bump version template.
2. `docs/LESSONS_LEARNED.md` — champ décision SDLC-16 → implémenté ; `LL-T05` → Résolu.
3. `07-DECISIONS-SDLC.md` — `M-TMPL-08`.
4. Bump standard.
5. Vérification + wrap-up léger (XS, pas d'Adversarial Review).

---

## §Risques

Aucun — modification de prose dans un template Markdown, zéro mécanisme
exécutable touché.

---

## §Corrections ajustées vs spec

- **Critère d'acceptation mal calibré** — `grep -c '4a' → ≥ 2` supposait une
  occurrence de « 4a » déjà présente dans le fichier ; en réalité il n'y en
  avait aucune (c'est précisément le défaut corrigé par ce sprint), le seuil
  correct est `≥ 1`. Corrigé avant de conclure, pas un écart de contenu.
