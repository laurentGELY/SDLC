# Sprint SDLC-28 — `sprint-memory.md` documenté comme mécanisme de reprise (P-27) + clôture P-39

**Type :** Doc
**Taille :** S
**Sprint :** SDLC-28 (04/09/2026)

---

## §Contexte

`docs/ROADMAP.md §Next` portait deux items :
- `P-27` — « `sprint-memory.md` documenté explicitement comme mécanisme de
  reprise après pause tranche horaire » (Doc, XS, débloqué depuis SDLC-23).
- `P-39` — « Sync `.claude/skills/wrap-up` v1.3 + `.claude/skills/retrospective`
  avec templates v1.6/v1.8 après GSD-V2 » (Fix, XS).

**Vérification factuelle avant rédaction du plan :**

1. **`P-39`** — `sdlc-validate.sh C4` (parité structurelle `^## `) et un `diff`
   direct des deux paires confirment une parité **déjà totale** entre
   `03-wrap-up-SKILL-TEMPLATE.md`↔`.claude/skills/wrap-up/SKILL.md` et
   `09-retrospective-SKILL-TEMPLATE.md`↔`.claude/skills/retrospective/SKILL.md`
   (seuls des décalages de numéro de ligne, aucun titre manquant). La
   discipline « répercuter dans le skill vivant, même commit », appliquée à
   chaque sprint depuis, a fermé l'écart sans jamais retirer l'item du
   ROADMAP. **`P-39` est déjà résolu — rien à coder, seulement à retirer.**

2. **`P-27`** — `Claude.md`/`01-Claude-md-TEMPLATE.md §Mémoire de sprint`
   documentent déjà explicitement le mécanisme (paragraphe `CHECKPOINT`,
   ajouté Sprint SDLC-23), mais avec 2 citations fautives dans ce même
   paragraphe :
   - `M-HOOKS-XX` — placeholder jamais rempli. Le CHANGELOG de SDLC-23
     lui-même cite `M-HOOKS-08` pour ce mécanisme (`.claude/hooks/
     pre-compact.sh`) → confirmé, devrait être `M-HOOKS-08`.
   - `Étend M-PROC-13` — lecture directe de `07-DECISIONS-SDLC.md` :
     `M-PROC-13` est l'annotation `[CONF: HAUTE/MOY/FAIBLE]` sur les entrées
     `ANALYSE`, sans rapport avec la reprise après pause. Le cadrage
     crash-recovery (« Deux fonctions distinctes — crash-recovery... et
     matière première du wrap-up ») est le `Raison` de **`M-PROC-10`**, pas
     `M-PROC-13`.
   - `sdlc-validate.sh C3` ne détecte pas ce type de résidu — son motif ne
     couvre que `[→ ADAPTER]`/`[À REMPLIR]`/`[Nom du projet]`, pas les
     identifiants `M-XXXX-XX` non résolus. Noté pour `docs/LESSONS_LEARNED.md`,
     **non traité dans ce sprint** (extension de `sdlc-validate.sh` hors
     scope Doc).
   - Absence côté documentation humaine : `grep -rn "tranche horaire\|pause
     forcée" docs/MODE-OPERATOIRE.html README.md` → vide. Le mécanisme
     n'existe que dans `Claude.md` (lu par Claude, pas par un opérateur
     humain qui chercherait « comment je reprends après une coupure »).

---

## §Portée

**Inclus :**
- `Claude.md` + `01-Claude-md-TEMPLATE.md` (v2.4→v2.5) : corriger les 2
  citations (`M-HOOKS-XX`→`M-HOOKS-08`, `Étend M-PROC-13`→`Étend M-PROC-10`)
  dans le paragraphe `CHECKPOINT` de `§Mémoire de sprint`.
- `docs/MODE-OPERATOIRE.html §Concepts clés` : nouvelle carte expliquant
  `sprint-memory.md` + `CHECKPOINT`/`PreCompact` comme mécanisme de reprise
  après coupure (crash ou pause de tranche horaire).
- `07-DECISIONS-SDLC.md` : sous-bloc `→ Mise à jour` sous `M-HOOKS-08`
  documentant la correction de citation (pas de nouvelle décision).
- `docs/ROADMAP.md` : `P-27` et `P-39` déplacés `§Next` → `§Historique`.
- `CHANGELOG.md`, `README.md` : entrées standard.

**Exclu :**
- Extension de `sdlc-validate.sh C3` pour détecter les résidus `M-XXXX-XX`
  non résolus — noté comme observation `docs/LESSONS_LEARNED.md`, pas un
  livrable de ce sprint (mécanisme exécutable nouveau, hors Doc/S).
- Toute modification du comportement du hook `pre-compact.sh` lui-même —
  seule la documentation est corrigée, pas le mécanisme.

---

## §Critères d'acceptation

- [x] `grep -c "M-HOOKS-XX" Claude.md 01-Claude-md-TEMPLATE.md` → `0` sur les
      deux fichiers
- [x] `grep -c "Étend M-PROC-13" Claude.md 01-Claude-md-TEMPLATE.md` → `0` sur
      les deux fichiers
- [x] `grep -c "M-HOOKS-08\|M-PROC-10" Claude.md 01-Claude-md-TEMPLATE.md` →
      ≥ 1 sur les deux fichiers (citation corrigée présente)
- [x] `grep -c "sprint-memory" docs/MODE-OPERATOIRE.html` → ≥ 1
- [x] `docs/ROADMAP.md §Next` ne contient plus `P-27` ni `P-39`
- [x] `docs/ROADMAP.md §Historique` contient une nouvelle ligne `SDLC-28`
- [x] `bash sdlc-validate.sh` → 8/8, exit code 0
- [x] `README.md §Version courante` cohérent avec `CHANGELOG.md`

---

## §Plan de développement

1. `Claude.md` : corriger les 2 citations dans le paragraphe `CHECKPOINT`
   (`§Mémoire de sprint`).
2. `01-Claude-md-TEMPLATE.md` : même correction + bump version v2.4→v2.5.
3. `docs/MODE-OPERATOIRE.html §Concepts clés` : ajouter une carte (`card-grid`)
   — icône, titre « Reprise après coupure », texte citant `sprint-memory.md`,
   `CHECKPOINT`, `pre-compact.sh`.
4. `07-DECISIONS-SDLC.md` : sous-bloc `→ Mise à jour 04/09/2026` sous
   `M-HOOKS-08`.
5. `docs/ROADMAP.md` : retirer `P-27`/`P-39` de `§Next`, ajouter ligne
   `§Historique`.
6. `CHANGELOG.md`, `README.md` : entrées standard.
7. Vérification : critères d'acceptation ci-dessus + `bash sdlc-validate.sh`.

---

## §Risques

- **Confusion citation `M-PROC-10` vs `M-HOOKS-08`** — les deux sont
  légitimes (M-HOOKS-08 est le hook lui-même, M-PROC-10 est l'origine du
  cadrage crash-recovery) ; le paragraphe corrigé citera les deux
  explicitement pour éviter de reproduire une simplification fautive.
- **Carte `MODE-OPERATOIRE.html` trop technique pour le public visé** —
  mitigé en gardant le texte au niveau opérationnel (« si la session
  s'interrompt, `sprint-memory.md` porte la trace ») plutôt que le détail
  du schéma JSON du hook.

---

## §Corrections ajustées vs spec

*(à compléter au wrap-up si divergence)*
