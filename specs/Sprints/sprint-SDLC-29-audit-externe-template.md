# Sprint SDLC-29 — `12-audit-externe-TEMPLATE.md` (P-22)

**Type :** Doc
**Taille :** XS
**Sprint :** SDLC-29 (04/09/2026)

---

## §Contexte

`docs/ROADMAP.md §Next` portait `P-22` — un gabarit générique pour les audits
externes (checklist 7 sections + bloc verdict `IMPORTER/REJETER/INVESTIGUER/
MERGER`), débloqué par `Sprint SDLC-Audit-GSTACK` après 3 audits externes
(GSD, GSD-lite, Superpowers) ayant chacun réinventé leur propre format.

**Vérification factuelle avant rédaction du plan :**

1. **Collision de numérotation** — le nom `10-audit-externe-TEMPLATE.md`,
   utilisé tel quel dans `docs/ROADMAP.md` et cité dans 6 fichiers
   historiques (`CHANGELOG.md`, plusieurs `specs/Sprints/*.md`), collisionne
   avec `10-AMONT-TEMPLATE.md` qui occupe déjà ce slot. `ls *.md` confirme
   les slots 01-11 tous occupés, 12 libre. Les mentions historiques
   (specs/CHANGELOG passés) ne sont pas réécrites — seules les références
   vivantes (`ROADMAP.md`, `00-CONTEXT.md`, `specs/SPEC.md`) utilisent le nom
   corrigé.
2. **Contenu déjà spécifié** — `docs/AUDIT-EXTERNE-gstack-vs-sdlc.md §7 "Sur
   P-22"` contient le squelette recommandé par ce même audit : 7 sections,
   verdicts étiquetés, tableau comparatif à 6 axes (déjà nommés et utilisés
   dans ce même audit : Gouvernance de session, Séparation des rôles,
   Traçabilité et documentation, Scalabilité, Overhead, Récupération de
   session). C'est le format le plus mature des 4 audits existants — repris
   tel quel plutôt que réinventé.
3. **Destination** — activité de maintenance du toolkit (comparer le modèle
   à un framework tiers), jamais exécutée par un projet cible bootstrappé →
   `*(guide toolkit — pas copié dans le projet cible)*`, même statut que
   `06-PDR-bootstrap.md`.

---

## §Portée

**Inclus :**
- `12-audit-externe-TEMPLATE.md` (nouveau, ~30 lignes)
- `00-CONTEXT.md §1 Carte des fichiers` : nouvelle ligne
- `specs/SPEC.md §Modules` : nouvelle ligne
- `07-DECISIONS-SDLC.md` : `M-TMPL-07`
- `docs/ROADMAP.md`, `CHANGELOG.md`, `README.md` : entrées standard

**Exclu :**
- Réécriture des mentions historiques de `10-audit-externe-TEMPLATE.md` dans
  les specs/CHANGELOG passés — préservées telles quelles (jamais réécrire
  l'historique).
- Application rétroactive du template aux 4 audits existants — hors scope,
  ils restent dans leur format d'origine.

---

## §Critères d'acceptation

- [x] `ls 12-audit-externe-TEMPLATE.md` → fichier existe
- [x] `grep -c "IMPORTER/REJETER/INVESTIGUER/MERGER" 12-audit-externe-TEMPLATE.md` → ≥ 1
- [x] `grep -c "^## " 12-audit-externe-TEMPLATE.md` → `7`
- [x] `grep -c "12-audit-externe-TEMPLATE.md" 00-CONTEXT.md specs/SPEC.md` → ≥ 1 sur chaque fichier
- [x] `grep -c "^## M-TMPL-07" 07-DECISIONS-SDLC.md` → `1`
- [x] `docs/ROADMAP.md §Next` ne contient plus `P-22`
- [x] `bash sdlc-validate.sh` → 8/8, exit code 0

---

## §Plan de développement

1. Créer `12-audit-externe-TEMPLATE.md` depuis le squelette `docs/AUDIT-EXTERNE-gstack-vs-sdlc.md §7`.
2. `00-CONTEXT.md §1` + `specs/SPEC.md §Modules` : ajouter la ligne.
3. `07-DECISIONS-SDLC.md` : entrée `M-TMPL-07` (dont la correction de numérotation 10→12).
4. `docs/ROADMAP.md` : `P-22` déplacé `§Next` → `§Historique`.
5. `CHANGELOG.md`, `README.md` : entrées standard.
6. Vérification : critères ci-dessus + `bash sdlc-validate.sh`.

---

## §Risques

- **Le template devient une "super-structure"** — l'audit source lui-même
  prévient contre ça (« ce n'est pas une super-structure — c'est une
  checklist de sections obligatoires »). Mitigé en copiant le squelette
  quasi tel quel, sans enrichissement.

---

## §Corrections ajustées vs spec

*(à compléter au wrap-up si divergence)*
