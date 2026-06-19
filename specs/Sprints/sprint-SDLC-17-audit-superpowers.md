# Sprint SDLC-17 — Audit externe : obra/superpowers vs modèle SDLC
<!-- Destination : specs/Sprints/sprint-SDLC-17-audit-superpowers.md -->
<!-- Gabarit dérivé de 04-sprint-PDR-TEMPLATE.md v1.9 — instance remplie, pas un template générique -->
<!-- Si ce sprint est jugé reproductible après exécution : candidat à formaliser en 10-audit-externe-TEMPLATE.md (cf. note de réutilisabilité en fin de fichier) -->

<!-- CORRECTIONS APPLIQUÉES AU DÉMARRAGE (étape 4a, Claude.md §Démarrage) — anomalies signalées avant écriture, validées par l'utilisateur :
  1. Numérotation : le PDR reçu portait "Sprint SDLC-06", déjà utilisé par specs/Sprints/sprint-SDLC-06-bmad-spike.md
     (Analyse tactique BMad Method). Collision détectée par HALT-ARCH avant création du fichier. Renuméroté en SDLC-17
     (suite de SDLC-16, dernier sprint clos — commit 9f35250) sur validation explicite de l'utilisateur.
  2. Chemin : le PDR référence `/exemples/superpowers/` à plusieurs endroits. Le contenu réel du clone est nesté un niveau
     plus bas : `exemples/superpowers/Superpowers/` (sous-dossier capitalisé contenant son propre `.git`). Toutes les
     références de chemin ci-dessous utilisent le chemin corrigé. Le contenu substantiel du PDR n'est pas modifié.
-->

**Type :** Doc *(cf. Note méthodologique ci-dessous — le flux réel est celui de "Revue" dans Claude.md §Classifier le travail : Lecture → Recommandations → /wrap-up)*
**Taille :** M
**Surface :** `exemples/superpowers/Superpowers/` (lecture seule) + fichiers de gouvernance SDLC `00-CONTEXT.md`, `01` à `09`, `07-DECISIONS-SDLC.md` (lecture seule) — livrable : nouveau fichier `doc/AUDIT-EXTERNE-superpowers-vs-sdlc.md`
**Risque :** Faible

> **Note méthodologique :** le champ `Type` du PDR (Feature/Fix/Tuning/Doc/Spike/Dette) n'a pas d'entrée "Revue", alors que `Claude.md §Classifier le travail` en a une (Audit, backlog → Lecture → Recommandations → `/wrap-up`). Ce sprint suit le flux Revue mais utilise le type PDR le plus proche (Doc, zéro code). L'écart de taxonomie est noté ici, pas corrigé — correction éventuelle hors périmètre de ce sprint, à discuter séparément.

---

## Contexte

`obra/superpowers` est un framework agentique open-source (plugin Claude Code / Codex / Cursor / Gemini CLI / Copilot CLI) qui encode une méthodologie complète de développement logiciel en 14 "skills" — fichiers d'instructions chargés à la demande, dont le chargement est rendu quasi obligatoire par un hook `SessionStart` injectant le skill bootstrap (`using-superpowers`) directement dans le contexte de session. Adoption communautaire large (174k+ étoiles GitHub), gouvernance de contribution stricte (94% de taux de rejet de PR documenté dans son propre `CLAUDE.md`).

Le modèle SDLC de ce projet poursuit un objectif structurellement proche — gouverner le comportement de Claude Code sur un projet via des règles permanentes, des templates de sprint, une boucle de rétroaction — mais avec une architecture, un vocabulaire et des mécanismes d'application différents. Aucune comparaison systématique n'a été faite à ce jour. Le risque sans cet audit : soit ignorer des mécanismes éprouvés à grande échelle, soit importer des idées par effet de mode sans évaluation critique.

---

## Objectif

Produire un document d'analyse comparatif (`doc/AUDIT-EXTERNE-superpowers-vs-sdlc.md`) qui mappe chaque mécanisme de Superpowers à son équivalent (ou son absence) dans le modèle SDLC, et qui classe chaque écart identifié en recommandation actionnable (IMPORTER / FUSIONNER / REMPLACER / REJETER / IDÉE NOUVELLE), avec au moins 3 axes où Superpowers fait honnêtement mieux et au moins 1 axe où le modèle SDLC est plus complet.

---

## Comportement actuel → cible

- **Actuel :** le modèle SDLC évolue par observation interne (boucle `LESSONS_LEARNED` → `/retrospective` → hook ou règle) sans point de comparaison externe formalisé. Aucun gabarit n'existe pour auditer un framework concurrent.
- **Cible :** un document d'analyse existe, lisible en une session, qui permet une décision humaine éclairée sur quels mécanismes de Superpowers méritent un sprint Doc d'import dans `07-DECISIONS-SDLC.md`.

---

## Portée

**Inclus :**
- Lecture exhaustive de `exemples/superpowers/Superpowers/CLAUDE.md` (gouvernance de contribution)
- Lecture exhaustive des 14 `skills/*/SKILL.md`
- Lecture du mécanisme de chargement (`hooks/hooks.json`, `hooks/session-start`)
- Lecture des conventions de `docs/superpowers/plans/` et `docs/superpowers/specs/` (nommage, structure — pas le contenu métier de ces fichiers, hors sujet)
- Lecture de `README.md` (positionnement, promesse produit)
- Comparaison systématique avec `00-CONTEXT.md` (4 invariants), `01` à `09`, `07-DECISIONS-SDLC.md`
- Production du document de synthèse unique décrit en §Gabarit du livrable

**Exclu (explicitement) :**
- Toute modification des templates SDLC dans ce sprint — c'est un sprint de lecture, pas d'évolution. L'évolution effective (si validée après lecture humaine du rapport) sera un sprint Doc séparé avec entrées `M-XXXX` dans `07-DECISIONS-SDLC.md`.
- L'évaluation du eval harness de Superpowers (`superpowers-evals`, dépôt séparé, non cloné dans `exemples/`) — mentionner son existence si pertinent, ne pas l'auditer.
- Tout test fonctionnel réel (installer le plugin, ouvrir une session Claude Code avec Superpowers actif, observer son comportement en conditions réelles) — analyse statique du contenu uniquement, pas analyse comportementale empirique.
- Le contenu spécifique aux autres harnais supportés par Superpowers (Cursor, Codex, Gemini CLI, Copilot, Antigravity, Pi, Kimi) — se concentrer sur l'équivalent Claude Code.

---

## Option retenue — alternatives écartées

**Retenue :** audit statique en grille de comparaison par composant fonctionnel (skill par skill, mécanisme par mécanisme), produisant un document conversationnel destiné à discussion humaine avant toute décision d'import.

**Écartée(s) :**
- *Import direct de skills Superpowers sans analyse* — écarté : violerait `00-CONTEXT.md §3` (toute évolution doit être justifiée dans `07-DECISIONS-SDLC.md`) et l'invariant INV-2 (circuit fermé) ; un import "par enthousiasme" est une règle implicite non justifiée.
- *Diff textuel automatisé entre les deux corpus* — écarté : les deux modèles utilisent des paradigmes différents pour des fonctions équivalentes (ex. un hook `SessionStart` qui injecte du contexte vs une checklist `§Démarrage` lue manuellement) ; un diff syntaxique ne capture pas l'équivalence fonctionnelle.

**Sacrifices délibérés :** l'audit ne mesure pas l'efficacité réelle des mécanismes Superpowers (pas de session de test, pas de chiffres d'adoption interprétés). Jugement qualitatif assumé sur la base du contenu lu. Si une recommandation IMPORTER est validée plus tard, son efficacité réelle se mesurera par un sprint Tuning classique (mesure avant/après), pas dans ce sprint.

---

## Contraintes techniques / produit

- Lecture seule sur `exemples/superpowers/Superpowers/` — ne jamais modifier le clone.
- Chaque affirmation comparative doit citer le chemin exact du fichier source (`skills/<nom>/SKILL.md`, ligne ou section si utile) — pas de paraphrase non vérifiable a posteriori.
- Document de sortie en français, cohérent avec la langue du modèle SDLC. Les concepts Superpowers (ex. "Iron Law", "Hard Gate") peuvent être cités en anglais entre guillemets s'ils sont des termes techniques propres au projet, mais leur explication doit être en français.
- Un seul fichier markdown en sortie.
- **Honnêteté obligatoire :** pour chaque axe de comparaison, formuler explicitement ce que Superpowers fait *mieux* que le modèle SDLC — pas seulement ce qu'il fait différemment. Interdiction du biais de confirmation ("notre modèle couvre déjà ça donc rien à apprendre").

**Interdit :**
- Modifier un seul fichier du modèle SDLC (`00-CONTEXT.md`, `01` à `09`, `07-DECISIONS-SDLC.md`) pendant ce sprint.
- Recommander l'import d'une dépendance tierce dans le hook `pre-tool-bash.sh` ou ailleurs — Superpowers lui-même revendique "zero-dependency by design" (`CLAUDE.md`) ; recommander une dépendance externe contredirait directement le mécanisme qu'on prétendrait importer.
- Conclure sur un score numérique agrégé unique ("le modèle SDLC vaut X/10"). Verdicts qualitatifs argumentés par axe uniquement — pas de pseudo-métrique non falsifiable.

---

## Dépendances

**Inputs requis :**
- [x] `exemples/superpowers/Superpowers/` cloné et accessible en lecture (vérifié en §Démarrage — 14 skills, hooks/hooks.json + hooks/session-start présents)
- [x] Fichiers de gouvernance SDLC accessibles : `00-CONTEXT.md`, `01-Claude-md-TEMPLATE.md`, `02-STANDARDS-TEMPLATE.md`, `03-wrap-up-SKILL-TEMPLATE.md`, `04-sprint-PDR-TEMPLATE.md`, `04b-sdlc-sync-SKILL-TEMPLATE.md`, `05-ROADMAP-TEMPLATE.md`, `07-DECISIONS-SDLC.md`, `08-hooks-TEMPLATE.md`, `09-retrospective-SKILL-TEMPLATE.md`

**Outputs produits :**
- [x] `doc/AUDIT-EXTERNE-superpowers-vs-sdlc.md` — livrable principal, structure imposée en §Gabarit ci-dessous
- [x] Liste de candidats `[SDLC_CANDIDATE]` préformatés dans le livrable, prêts à coller dans une entrée `LESSONS_LEARNED` ou directement utilisables pour cadrer un futur sprint Doc d'import

---

## Critères d'acceptation

- [x] Les 14 skills de Superpowers ont chacun une ligne de mapping explicite vers leur équivalent SDLC le plus proche, ou un constat d'absence d'équivalent
- [x] Les 4 invariants (`INV-1` à `INV-4` de `00-CONTEXT.md`) sont utilisés comme grille de lecture explicite, avec un verdict comparatif par invariant
- [x] Au moins 3 axes où Superpowers est honnêtement meilleur sont nommés, avec citation de source précise pour chacun
- [x] Au moins 1 axe où le modèle SDLC est plus complet est nommé, avec justification
- [x] Chaque recommandation est étiquetée IMPORTER / FUSIONNER / REMPLACER / REJETER / IDÉE NOUVELLE
- [x] Chaque recommandation IMPORTER / FUSIONNER / REMPLACER précise : fichier cible exact du modèle SDLC, esquisse de contenu, impact estimé (faible / moyen / élevé)
- [x] Une section "Ce qu'on ne doit PAS importer" existe et est aussi argumentée que les recommandations positives
- [x] Zéro fichier de gouvernance SDLC modifié pendant ce sprint
- [x] Tests niveau A : voir commandes ci-dessous
- [x] CHANGELOG mis à jour (entrée sprint Doc)

---

## Gabarit du livrable — structure imposée

`doc/AUDIT-EXTERNE-superpowers-vs-sdlc.md` doit contenir, dans cet ordre :

1. **Tableau d'équivalence terminologique** — vocabulaire Superpowers ↔ vocabulaire SDLC (ex. "skill" ↔ ?, "plan" ↔ spec sprint, "subagent" ↔ ?) ; nommer explicitement les concepts sans équivalent dans un sens ou dans l'autre.
2. **Mapping skill par skill** — tableau à 5 colonnes : Skill Superpowers | Objectif | Mécanisme d'activation (auto-trigger / commande / les deux) | Rigidité (Iron Law / Hard Gate / recommandation souple) | Équivalent SDLC le plus proche (ou « aucun »).
3. **Analyse par invariant** — pour `INV-1` (vérification exécutable), `INV-2` (circuit fermé), `INV-3` (contexte chirurgical), `INV-4` (boucle de rétroaction) : comment Superpowers traite ce principe, verdict comparatif.
4. **Forces honnêtes de Superpowers** (≥ 3, sourcées).
5. **Forces du modèle SDLC absentes de Superpowers** (≥ 1, sourcées).
6. **Recommandations** — tableau : Idée | Source Superpowers | Étiquette (IMPORTER/FUSIONNER/REMPLACER/REJETER/IDÉE NOUVELLE) | Fichier SDLC cible | Esquisse | Impact estimé.
7. **Ce qu'on ne doit PAS importer** — et pourquoi (incompatibilité de paradigme, dépendance non désirée, sur-ingénierie pour notre échelle, etc.).
8. **Candidats `[SDLC_CANDIDATE]` préformatés** — un bloc par recommandation IMPORTER/FUSIONNER retenue, prêt à coller.
9. **Limites de l'audit** — ce qui n'a pas été évalué (eval harness, comportement réel en session, autres harnais) et pourquoi c'est hors périmètre de ce sprint.

```bash
# Test A — structure du livrable
grep -c "^## " doc/AUDIT-EXTERNE-superpowers-vs-sdlc.md
# → ≥ 9 attendu (une section par point du gabarit ci-dessus)

grep -E "IMPORTER|FUSIONNER|REMPLACER|REJETER|IDÉE NOUVELLE" doc/AUDIT-EXTERNE-superpowers-vs-sdlc.md | wc -l
# → ≥ 5 attendu (au moins une recommandation par étiquette possible)

# Test A — non-modification de la gouvernance SDLC
git diff --stat -- 00-CONTEXT.md 01-Claude-md-TEMPLATE.md 02-STANDARDS-TEMPLATE.md \
  03-wrap-up-SKILL-TEMPLATE.md 04-sprint-PDR-TEMPLATE.md 04b-sdlc-sync-SKILL-TEMPLATE.md \
  05-ROADMAP-TEMPLATE.md 07-DECISIONS-SDLC.md 08-hooks-TEMPLATE.md 09-retrospective-SKILL-TEMPLATE.md
# → doit retourner vide
```

---

## Risques

- **Biais de l'objet brillant** (174k étoiles, framework très visible) : probabilité moyenne · mitigation : grille de critique systématique forcée par invariant + CA "≥ 1 axe où le modèle SDLC est plus complet" rend la complaisance détectable.
- **Confusion terminologique** ("skill" Superpowers ≠ "template" SDLC, mais zone de recouvrement réelle) : probabilité élevée · mitigation : tableau d'équivalence terminologique en première section, avant toute analyse qualitative.
- **Sur-ingénierie du futur audit** (ce sprint devient prématurément un nouveau type de sprint permanent) : probabilité faible · mitigation : ne pas trancher ce point dans ce sprint — le proposer comme `[SDLC_CANDIDATE]` séparé, à discuter après lecture du rapport.

---

## Pre-mortem *(obligatoire — taille M)*

> Si ce sprint échoue ou dépasse 2× l'estimation, la cause la plus probable est : Claude essaie de comparer en profondeur ligne à ligne chaque mécanisme (ex. les 4 phases de `systematic-debugging` vs chaque étape de notre `Claude.md §Analyse`) plutôt que de rester au niveau composant fonctionnel — ce qui fait exploser la longueur du document et noie les 5 à 10 idées réellement importables sous un inventaire exhaustif mais peu actionnable. Mitigation : le §Gabarit du livrable impose un format tableau compact pour le mapping (point 2) ; la profondeur d'analyse en prose est réservée aux points 3 à 7.

---
<!-- FIN PRD — La section Handoff est complétée par Claude Code en début de session -->

## Handoff Claude Code
*(complété en début de session — étape 4c)*

**Fichiers — chargement immédiat (chargés) :**
- `exemples/superpowers/Superpowers/CLAUDE.md`
- `exemples/superpowers/Superpowers/skills/using-superpowers/SKILL.md` (skill bootstrap — point d'entrée du mécanisme)
- `exemples/superpowers/Superpowers/hooks/hooks.json` + `exemples/superpowers/Superpowers/hooks/session-start`
- `00-CONTEXT.md` (4 invariants — grille de lecture)
- `07-DECISIONS-SDLC.md §Tableau de compatibilité` (vue d'ensemble des décisions déjà prises — éviter de proposer en IDÉE NOUVELLE quelque chose qui existe déjà sous un autre nom)

**Fichiers — chargement différé :**
- Les 13 autres `skills/*/SKILL.md` — lire un par un pendant la constitution du tableau de mapping (point 2 du gabarit), pas tout charger d'un coup
- `docs/superpowers/plans/*.md` et `docs/superpowers/specs/*.md` — `ls` pour confirmer la convention de nommage uniquement (`YYYY-MM-DD-<slug>.md`), ne pas lire le contenu métier (hors périmètre)
- `01-Claude-md-TEMPLATE.md` à `09-retrospective-SKILL-TEMPLATE.md` — relire un par un au moment de la comparaison correspondante, pas en bloc

**Données à collecter avant de coder :** N/A — sprint Doc, zéro code.

**Instructions spécifiques :**
- Construire le tableau d'équivalence terminologique (point 1) avant toute analyse qualitative — il cadre tout le reste.
- Pour chaque skill, noter explicitement le mécanisme d'activation : Superpowers distingue auto-trigger (via le hook `SessionStart` + table "Red Flags" anti-rationalisation dans `using-superpowers`) de skills invoqués à la demande — ce distinguo n'a pas d'équivalent direct dans le modèle SDLC (où tout passe par lecture manuelle de `Claude.md` en `§Démarrage`) ; c'est potentiellement le point de comparaison le plus structurant de tout l'audit, à ne pas diluer dans le détail des 14 skills.
- Garder la section "Ce qu'on ne doit PAS importer" aussi rigoureuse que les recommandations positives — viser au moins 2 entrées.
- Ne pas se limiter aux skills d'exécution (TDD, debugging) — couvrir aussi les skills de méta-gouvernance (`writing-skills`, `using-git-worktrees`, `dispatching-parallel-agents`) qui n'ont pas d'équivalent évident dans `07-DECISIONS-SDLC.md` et sont susceptibles de générer des IDÉE NOUVELLE plutôt que des IMPORTER directs.

**Grep de vérification préalable (exécuté) :**
```bash
ls exemples/superpowers/Superpowers/skills | wc -l
# → 14 confirmé

test -f exemples/superpowers/Superpowers/hooks/hooks.json && test -f exemples/superpowers/Superpowers/hooks/session-start && echo "mécanisme hooks présent"
# → "mécanisme hooks présent" confirmé
```

**Init mémoire sprint :**
```bash
echo "# Sprint SDLC-17 — audit-superpowers · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-SDLC-17-audit-superpowers.md" >> .claude/sprint-memory.md
```

---

## Plan de développement
*(produit par Claude Code après analyse — étape 4d, avant toute écriture du livrable)*

**Dépendances vérifiées :**
- [x] `exemples/superpowers/Superpowers/` — état : présent, 14 skills, hooks confirmés (chemin réel diffère du PDR original — voir note de correction en tête de fichier)

**Modules touchés :** aucun module de code — uniquement le nouveau fichier `doc/AUDIT-EXTERNE-superpowers-vs-sdlc.md`.

**Risques identifiés :** voir §Risques et §Pre-mortem ci-dessus — risque principal : sur-profondeur de l'analyse skill-par-skill (mitigé par le format tableau imposé au point 2 du gabarit).

**Plan d'exécution :**
1. Lire en différé les 13 `skills/*/SKILL.md` restants (un par un), construire au fil de la lecture le tableau de mapping (point 2) et le tableau terminologique (point 1).
2. Relire `01` à `09` un par un au moment de la comparaison correspondante ; produire l'analyse par invariant (point 3), forces Superpowers (point 4), forces SDLC (point 5).
3. Rédiger recommandations (point 6), section "à ne pas importer" (point 7), candidats `[SDLC_CANDIDATE]` (point 8), limites (point 9) ; écrire `doc/AUDIT-EXTERNE-superpowers-vs-sdlc.md` en un seul passage cohérent.

**Plan de test :**
- A — Ciblé : les 3 commandes du §Gabarit du livrable ci-dessus (`grep -c "^## "`, `grep -E "IMPORTER|..."`, `git diff --stat -- <fichiers gouvernance>`)
- B — Non-régression : N/A (aucun module partagé touché)

---

## Corrections ajustées vs spec
*(complété au wrap-up — §Étape 3)*

PDR reçu sous le numéro "Sprint SDLC-06", en collision avec
`specs/Sprints/sprint-SDLC-06-bmad-spike.md` déjà existant. Renuméroté en
SDLC-17 sur validation explicite de l'utilisateur (HALT-ARCH détecté et
signalé avant création du fichier spec, étape 4a du `Claude.md §Démarrage`).
Chemin `/exemples/superpowers/` du PDR original corrigé en
`exemples/superpowers/Superpowers/` (clone git nesté d'un niveau, non
documenté dans le PDR reçu). Aucune autre divergence par rapport à la
spec initiale — portée, gabarit du livrable et critères d'acceptation
exécutés tels que reçus après ces deux corrections.
