# Sprint ECO-2 — Rédaction des templates : description = déclenchement, forme = fonction de l'échec

<!-- PDR rédigé par Claude Code depuis specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md §E-08/E-09/E-17 -->
<!-- Destination : specs/Sprints/sprint-ECO-2-redaction-templates.md -->
<!-- Modèle au moment de la rédaction : v2.0+ECO-1 · dernière décision M-PROC-40 -->

**Type :** Doc
**Taille :** S
**Surface :** `00-CONTEXT.md` (nouvelle §5) · `04b-sdlc-sync-SKILL-TEMPLATE.md` (en-tête) · `11-help-SKILL-TEMPLATE.md`
**Risque :** Faible — modification de prose et d'une checklist, aucun mécanisme exécutable touché

---

## Contexte

`specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md` (revue du 02/09/2026) catalogue trois
manques de renforcement directement actionnables sur la rédaction des templates et
skills du modèle :

- **`E-08`** — une description/en-tête de skill qui résume le *workflow* (plutôt que ses
  conditions de déclenchement) crée un raccourci qu'un agent peut suivre au lieu de lire
  le corps détaillé. Cas concret déjà présent dans le repo : l'en-tête de
  `04b-sdlc-sync-SKILL-TEMPLATE.md` résume 4 étapes en une phrase avant que les Étapes
  A→E ne les détaillent.
- **`E-09`** — le modèle choisit la forme d'une règle (interdiction / recette positive /
  champ structurel / conditionnel) à l'instinct, sans grille de décision, alors que la
  forme qui marche dépend du type d'échec visé.
- **`E-17`** — `/help` (`11-help-SKILL-TEMPLATE.md`) est déjà le routeur qui liste les
  skills disponibles, mais rien ne rappelle de le resynchroniser quand une skill est
  ajoutée, renommée ou retirée.

Un quatrième pattern du même bloc (`E-16`, invocation modèle vs humain des skills via
`disable-model-invocation`) a été vérifié factuellement pendant le démarrage de ce sprint
et **écarté de son périmètre** : le frontmatter YAML qu'il nécessite doit commencer à la
toute première ligne du fichier pour être reconnu par Claude Code, ce qui repousserait le
marqueur de version (`<!-- Template SDLC vX.Y -->`, actuellement dans les 3 premières
lignes) hors de la fenêtre vérifiée par le contrôle C2 de `sdlc-validate.sh` — régression
sciemment introduite sur un script livré la veille. Décision utilisateur : différer,
`docs/ROADMAP.md §Later` (item ECO-2b).

---

## Objectif

`00-CONTEXT.md` porte une règle de rédaction vérifiable (description = déclenchement,
forme = fonction de l'échec visé) et une checklist à jour ; `04b-sdlc-sync-SKILL-TEMPLATE.md`
n'a plus d'en-tête résumant son propre workflow ; `11-help-SKILL-TEMPLATE.md` rappelle sa
propre obligation de resynchronisation.

---

## Comportement actuel → cible

- **Actuel :** aucune règle écrite sur la forme d'une description de skill ni sur le choix
  de forme d'une règle de template — décisions prises à l'instinct, non reproductibles
  d'un sprint à l'autre. L'en-tête de `04b-sdlc-sync-SKILL-TEMPLATE.md` résume les 4 étapes
  de son propre workflow avant leur détail. `00-CONTEXT.md §4` ne mentionne pas `/help`
  parmi ce qu'il faut maintenir à jour.
- **Cible :** `00-CONTEXT.md` contient une §5 « Rédaction des templates et skills » avec
  la règle description/déclenchement et le tableau forme-selon-échec. L'en-tête de
  `04b-sdlc-sync-SKILL-TEMPLATE.md` énonce uniquement quand se déclencher. `00-CONTEXT.md
  §4` rappelle de vérifier `/help` à chaque skill ajoutée/renommée/retirée.

---

## Portée

**Inclus :**
- Nouvelle `## 5. Rédaction des templates et skills` dans `00-CONTEXT.md`, avec deux
  règles : (a) description/en-tête = déclenchement seul, jamais les étapes ; (b) tableau
  de correspondance forme de règle ↔ type d'échec (4 lignes, `E-09`)
- Réécriture de l'en-tête de `04b-sdlc-sync-SKILL-TEMPLATE.md` pour retirer le résumé de
  workflow, conformément à la règle (a) que ce sprint introduit
- Nouvelle ligne dans `00-CONTEXT.md §4` : vérifier `11-help-SKILL-TEMPLATE.md` (liste des
  skills) à chaque skill ajoutée/renommée/retirée dans `.claude/skills/`
- Nouvelle entrée `M-TMPL-05` dans `07-DECISIONS-SDLC.md`

**Exclu (explicitement) :**
- `E-16` (frontmatter YAML + `disable-model-invocation`) — conflit vérifié avec C2 de
  `sdlc-validate.sh`, différé en `ECO-2b` (`docs/ROADMAP.md §Later`)
- Relecture/réécriture des en-têtes de `03-wrap-up-SKILL-TEMPLATE.md`,
  `09-retrospective-SKILL-TEMPLATE.md`, `11-help-SKILL-TEMPLATE.md` : leurs « Principe
  d'exécution » énoncent une philosophie/portée générale, pas une séquence d'étapes
  numérotées — ils ne correspondent pas au défaut précis que `E-08` documente (vérifié en
  §4d ci-dessous, pas supposé)
- Application de la grille forme-selon-échec (`E-09`) aux 11 paires Pensée → Réalité de
  `M-PROC-31` — signalé comme piste dans `E-09` lui-même, mais c'est une relecture d'un
  autre sprint, pas une tâche mécanique de celui-ci
- Contrôle C9 dans `sdlc-validate.sh` vérifiant la règle (a) — la vague ECO-1 §Annexe
  prévoit que « les règles arrivent avec leurs contrôles C9-C11 » à la vague suivante, pas
  celle-ci ; ce sprint pose la règle, pas son enforcement mécanique

---

## Option retenue — alternatives écartées

**Retenue :** ajout d'une nouvelle section `00-CONTEXT.md §5` (jamais de renumérotation
des sections existantes — `§4` est cité par `sdlc-validate.sh`, le `CHANGELOG.md` et
`07-DECISIONS-SDLC.md`, un renommage casserait ces renvois) + une seule réécriture ciblée
(`04b`, cas confirmé) + une ligne de checklist.

**Écartée(s) :**
- **Relire et réécrire les 4 en-têtes de skill** — écarté : seul `04b` correspond
  factuellement au défaut décrit par `E-08` (résumé de séquence d'étapes). Réécrire les 3
  autres sans défaut constaté serait une modification de contenu sans preuve, contraire à
  `Claude.md §Rôle` (« affirmation citable »)
- **Fusionner `§5` dans `§3. Invariants`** — écarté : les invariants sont des principes
  de conception du modèle entier (`INV-1` à `INV-4`), la §Rédaction est une règle
  d'écriture locale aux templates/skills — catégories différentes, mélanger nuirait à la
  lisibilité de `§3`
- **Inclure `E-16` avec un ajustement de `sdlc-validate.sh` dans le même sprint** — écarté
  sur décision utilisateur : élargit le risque et la taille du sprint (`Doc S` → proche de
  `M`) pour un gain non urgent (aucun coût de contexte actif à retirer, puisque les
  templates n'ont aujourd'hui aucun frontmatter du tout)

**Sacrifices délibérés :** la règle (a) et le tableau (b) ne sont pour l'instant vérifiés
qu'à l'œil — leur contrôle mécanique (`C9`/`C10`) est explicitement une vague ultérieure
(`ECO-1 §Annexe`), pas ce sprint.

---

## Contraintes techniques / produit

- Zéro renumérotation des sections existantes de `00-CONTEXT.md` (`§1`-`§4` référencées
  ailleurs dans le repo)
- La nouvelle `§5` et la ligne de checklist `§4` doivent porter la version incrémentée de
  `00-CONTEXT.md` en tête de fichier (`00-CONTEXT.md §4`, checklist elle-même)
- Aucune modification du contenu narratif d'un fichier autre que `04b` sans defaut
  constaté et cité

**Interdit :**
- Réécrire un en-tête de skill sans avoir d'abord vérifié qu'il correspond réellement au
  défaut `E-08` (grep + lecture, pas une supposition par analogie)
- Toucher `sdlc-validate.sh`, `.claude/hooks/*`, ou tout fichier lié à `E-16`

---

## Dépendances

**Inputs requis** *(ce sprint assume que ces outputs existent et sont valides)* :
- [x] `specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md` §E-08/§E-09/§E-17 — présent dans le repo
      (Sprint ECO-1, 02/09/2026)
- [x] `sdlc-validate.sh` — présent, `M-PROC-40`, 8/8 sur l'état actuel du repo
- [x] Dernier ID `M-TMPL` attribué — `M-TMPL-04` (Sprint SDLC-24), `M-TMPL-05` libre

**Outputs produits** *(ce que les sprints suivants pourront utiliser)* :
- [x] `00-CONTEXT.md §5` — point d'ancrage pour les contrôles `C9`/`C10` d'une vague
      ultérieure de `sdlc-validate.sh`
- [x] Décision `M-TMPL-05` dans `07-DECISIONS-SDLC.md`
- [x] `docs/ROADMAP.md` item `ECO-2b` (E-16 différé, déjà ajouté en amont de ce PDR)

**Règle :** avant de démarrer, vérifier que tous les inputs requis cochés existent et sont
dans l'état attendu. Si un input manque ou a changé → signaler comme BLOQUANT avant toute
analyse.

---

## Critères d'acceptation

- [x] `grep -c "^## 5\." 00-CONTEXT.md` → `1`
- [x] `grep -A25 "^## 5\." 00-CONTEXT.md | grep -c "déclenchement"` → `≥ 1` (règle E-08
      présente)
- [x] `grep -A25 "^## 5\." 00-CONTEXT.md | grep -c "Forme qui marche"` → `1` (tableau E-09
      présent, en-tête de colonne exact)
- [x] `grep -A25 "^## 5\." 00-CONTEXT.md | grep -c "^|"` → `≥ 5` (4 lignes de contenu + 1
      ligne d'en-tête minimum pour le tableau à 3 colonnes)
- [x] `grep -c "fait l'inventaire et le tri.*propose.*attend l'aval.*puis applique" 04b-sdlc-sync-SKILL-TEMPLATE.md`
      → `0` (le résumé séquentiel des 4 étapes est retiré — critère corrigé au wrap-up :
      la formulation initiale, `grep -c "Principe d'exécution" → 0`, aurait aussi supprimé
      le libellé lui-même, incohérent avec les 3 autres templates de skill qui le
      conservent tous pour une phrase non séquentielle · voir §Corrections ajustées vs spec)
- [x] `head -8 04b-sdlc-sync-SKILL-TEMPLATE.md | grep -c "Étape A\|Étape B\|Étape C\|Étape D\|Étape E"`
      → `0` (l'en-tête n'énonce plus la séquence — les étapes restent détaillées plus loin
      dans le corps, non touchées par ce critère)
- [x] `grep -c "help" 00-CONTEXT.md` → `≥ 1` de plus qu'avant ce sprint (nouvelle ligne §4)
- [x] `grep -c "M-TMPL-05" 07-DECISIONS-SDLC.md` → `≥ 1`
- [x] `grep "M-TMPL-05" 07-DECISIONS-SDLC.md` → l'entrée porte les 4 champs du format :
      Retenu · Écarté · Raison · Déclencheur de réouverture
- [x] `bash sdlc-validate.sh` → `8/8 ✅`, exit 0 — non-régression, aucun des 8 contrôles
      cassé par ce sprint (en particulier C2 et C4, les plus proches de la surface touchée)
- [x] Tests niveau A : `bash sdlc-validate.sh ; echo $?` → `0`
- [x] CHANGELOG mis à jour, ligne `**Tests**` porte le résultat réel de `sdlc-validate.sh`

<!-- Guidance goal-backward : chaque critère est un état observable produit par une
     commande, jamais "la section est écrite" ou "l'en-tête est corrigé". -->

---

## Risques

- **La réécriture de l'en-tête `04b` supprime une information utile qui n'était pas
  seulement un résumé de workflow** : *faible* · relire le texte retiré avant suppression,
  ne garder que la substitution par une phrase de déclenchement pur, vérifier par lecture
  humaine (pas de commande possible ici, jugement rédactionnel)
- **Le tableau `E-09` recopié verbatim ne s'applique pas clairement au vocabulaire du
  modèle SDLC** (termes « interdiction », « recette », « structurel », « conditionnel »
  pas forcément alignés avec `§Interdit du PDR`, `HALT`, critères d'acceptation) : *moyen*
  · reformuler les 4 lignes avec les noms réels des mécanismes SDLC (`§Interdit`, critère
  d'acceptation structurel, `HALT`, table de rationalisation) plutôt que le vocabulaire
  source, pour que la grille soit immédiatement utilisable en session

---

## Handoff Claude Code

**Fichiers — chargement immédiat :**
- `specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md` §E-08, §E-09, §E-17 (déjà lus pour rédiger
  ce PDR)
- `00-CONTEXT.md` (fichier complet — court, 4 sections)
- `04b-sdlc-sync-SKILL-TEMPLATE.md` (en-tête + Étapes A→E, pour vérifier que la séquence
  reste intacte après retrait du résumé)
- `11-help-SKILL-TEMPLATE.md` (déjà lu — pour la ligne de checklist)

**Fichiers — chargement différé :**
- `07-DECISIONS-SDLC.md` — grep `^## M-TMPL-` pour confirmer le prochain ID, lecture
  complète uniquement pour rédiger `M-TMPL-05`
- `sdlc-validate.sh` — non modifié, relire uniquement si le test niveau A échoue

**Données à collecter avant de coder :**
- Confirmer que `03-wrap-up-SKILL-TEMPLATE.md`, `09-retrospective-SKILL-TEMPLATE.md`,
  `11-help-SKILL-TEMPLATE.md` ne correspondent PAS au défaut `E-08` (grep + lecture des
  3 en-têtes, pas une supposition)
- Dernier ID `M-TMPL` réellement attribué (`grep -n "^## M-TMPL-" 07-DECISIONS-SDLC.md`)

**Init mémoire sprint :**
```bash
echo "# Sprint ECO-2 — redaction-templates · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-ECO-2-redaction-templates.md" >> .claude/sprint-memory.md
```

---

## Plan de développement
*(produit par Claude Code après analyse — à compléter en étape 4d, avant tout code)*

**Dépendances vérifiées :**
- [x] 3 en-têtes de skill non concernés par E-08 — état : confirmé, `03`/`09`/`11`
      énoncent une philosophie générale (« fait le travail et rapporte », « lit, analyse
      et propose », « agréger 3 sources, ne rien inventer »), aucune séquence d'étapes
      numérotées contrairement à `04b`
- [x] Dernier ID `M-TMPL` — état : `M-TMPL-04` confirmé (ligne 261), `M-TMPL-05` libre

**Modules touchés :** `00-CONTEXT.md` (+§5, +1 ligne §4) · `04b-sdlc-sync-SKILL-TEMPLATE.md`
(en-tête) · `07-DECISIONS-SDLC.md` (`M-TMPL-05`) · `CHANGELOG.md`

**Risques identifiés :** cf. §Risques ci-dessus. Aucun mécanisme exécutable touché —
`sdlc-validate.sh` sert de niveau A ET de garde non-régression simultanément.

**Plan d'exécution :**
1. Rédiger `00-CONTEXT.md §5` (règle E-08 + tableau E-09 reformulé au vocabulaire SDLC)
2. Réécrire l'en-tête de `04b-sdlc-sync-SKILL-TEMPLATE.md` (retirer le résumé de workflow,
   garder une phrase de déclenchement pur)
3. Ajouter la ligne `/help` à `00-CONTEXT.md §4`
4. Bumper la version de `00-CONTEXT.md`
5. Rédiger `M-TMPL-05` dans `07-DECISIONS-SDLC.md`
6. `bash sdlc-validate.sh` → 8/8 attendu (non-régression)
7. CHANGELOG + wrap-up

**Plan de test :**
- A — Ciblé : `bash sdlc-validate.sh ; echo "exit=$?"`
- B — Non-régression : aucun mécanisme exécutable touché — la non-régression EST le test A

---

## Corrections ajustées vs spec
*(complété au wrap-up — §Étape 3)*

**Corrections ajustées vs spec** — un critère d'acceptation mal spécifié, corrigé en cours d'exécution : `grep -c "Principe d'exécution" 04b-sdlc-sync-SKILL-TEMPLATE.md → 0` demandait la suppression du libellé lui-même, pas seulement du résumé séquentiel qu'il portait — incohérent avec les 3 autres templates de skill, qui conservent tous ce même libellé pour une phrase non séquentielle (philosophie/portée générale). Remplacé par un critère ciblant précisément la phrase séquentielle retirée (`grep -c "fait l'inventaire et le tri...puis applique" → 0`), le libellé « Principe d'exécution » étant conservé avec son contenu non séquentiel restant (validation humaine obligatoire, primauté du tuning local). Aucun fichier à relire dans Claude.ai au-delà de la resynchronisation standard.
