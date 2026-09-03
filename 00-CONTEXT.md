# Modèle de gouvernance SDLC — Claude Code · v1.6
<!-- Contexte Claude.ai · Premier fichier lu · Ne pas copier dans les projets cibles -->
<!-- Mis à jour à chaque évolution structurelle du modèle -->

> Ce fichier est la conscience du projet SDLC lui-même.
> Il ne contient pas de templates — il contient les principes
> qui doivent guider toute évolution future des templates.
>
> **Règle d'or :** avant de modifier un fichier de ce projet,
> vérifier que le changement respecte les invariants §3 ci-dessous.

---

## 1. Carte des fichiers

| # | Fichier | Rôle | Destination dans le projet cible |
|---|---------|------|----------------------------------|
| 01 | `01-Claude-md-TEMPLATE.md` | Instructions permanentes Claude Code | `Claude.md` (racine) |
| 02 | `02-STANDARDS-TEMPLATE.md` | DoD, types de sprint, niveaux de test | `STANDARDS.md` (racine) |
| 03 | `03-wrap-up-SKILL-TEMPLATE.md` | Procédure de clôture de sprint | `.claude/skills/wrap-up/SKILL.md` |
| 04 | `04-sprint-PDR-TEMPLATE.md` | Spec de sprint — copier tel quel | `specs/sprint-template.md` |
| 04b | `04b-sdlc-sync-SKILL-TEMPLATE.md` | Skill /sdlc-sync | `.claude/skills/sdlc-sync/SKILL.md` |
| 05 | `05-ROADMAP-TEMPLATE.md` | Backlog Now/Next/Later | `docs/ROADMAP.md` |
| 06 | `06-PDR-bootstrap.md` | Guide opérationnel Sprint 0 | *(guide d'exécution, pas copié)* |
| 07 | `07-DECISIONS-SDLC.md` | Registre des décisions sur le modèle | *(propre à ce projet)* |
| 08 | `08-hooks-TEMPLATE.md` | Hook PreToolUse Bash + settings | `.claude/hooks/` |
| 09 | `09-retrospective-SKILL-TEMPLATE.md` | Procédure de rétrospective + remontées SDLC | `.claude/skills/retrospective/SKILL.md` |
| 10 | `10-AMONT-TEMPLATE.md` | Instructions phase amont — Project Claude.ai | Project Knowledge Claude.ai dédié (hors repo cible) |
| 11 | `11-help-SKILL-TEMPLATE.md` | Skill /help — recap contexte | `.claude/skills/help/SKILL.md` |

**Fichiers humains (local uniquement, non synchronisés dans Claude.ai) :**

| Fichier | Rôle |
|---------|------|
| `docs/SPEC.html` | Spec fonctionnelle du modèle : circuits, invariants, décisions M-XXXX |
| `docs/MODE-OPERATOIRE.html` | Procédures complètes : init, sync, évoluer + référence praticienne |

**Site de documentation publique (`docs/`, GitHub Pages `main` → `/docs`, M-ARCH-09) :**

| Fichier | Rôle |
|---------|------|
| `docs/index.html` | Shell du site statique (sidebar + rendu markdown runtime) |
| `docs/nav.json` | Manifeste de navigation (groupes, ordre, titres) |
| `docs/meta.json` | Version + date de dernière mise à jour du site |
| `docs/.nojekyll` | Désactive Jekyll (sinon `nav.json`/`meta.json` ignorés par GitHub Pages) |
| `docs/pages/*.md` | Sources des pages du site — livrées telles quelles, ne pas éditer via sed de renommage |

**Ce fichier (`00-CONTEXT.md`)** : contexte Claude.ai — jamais copié dans les projets cibles.

---

## 2. Utilisation selon le contexte

### Phase amont — idéation, PRD, architecture *(optionnelle)*
→ Créer un Project Claude.ai dédié, charger `10-AMONT-TEMPLATE.md` en
Project Knowledge.
→ Le document produit alimente directement `specs/SPEC.md` et le premier
PDR du Sprint 0 (voir `10-AMONT-TEMPLATE.md §Passage à Claude Code`).
→ Optionnel : un projet sans phase amont formalisée continue de créer
`specs/SPEC.md` from scratch au bootstrap, comme avant (M-SCOPE-02).

### Bootstrapper un nouveau projet
→ Lire `06-PDR-bootstrap.md` — guide complet avec plan d'exécution étape par étape.
→ Procédure détaillée dans `docs/MODE-OPERATOIRE.html §Initialiser`.

### Faire évoluer le modèle SDLC
→ Lire §3 (invariants) avant toute modification.
→ Documenter la décision dans `07-DECISIONS-SDLC.md`.
→ Mettre à jour le numéro de version dans l'en-tête du fichier modifié.

### Co-construire un PDR SDLC-Sync (recommandé)
→ Exécuter le script de pré-calcul depuis la machine locale :
  `bash ~/Downloads/Sandbox/SDLC/sdlc-delta.sh <chemin-projet>`
→ Coller le résultat dans Claude.ai avec :
  *"Construis le PDR SDLC-Sync pour [nom-projet]"*
→ Claude.ai produit le PDR complet avec delta pré-calculé et tuning local identifié
→ Copier le PDR dans `specs/Sprints/` du projet cible
→ Lancer Claude Code : `cd <projet> && claude`, puis indiquer le nom du fichier PDR
→ Voir M-PROC-25 dans `07-DECISIONS-SDLC.md` pour la justification.

### Comprendre une décision passée
→ Lire `07-DECISIONS-SDLC.md` — registre exhaustif avec justifications.
→ Vue synthétique dans `docs/SPEC.html §Décisions`.

---

## 3. Invariants — à préserver dans toute évolution

Ces quatre principes sont les fondements du modèle.
Toute évolution qui en viole un doit être explicitement justifiée dans `07-DECISIONS-SDLC.md`.

### INV-1 · Vérification exécutable
**Principe :** tout plan de test doit contenir une commande exacte, pas une description.
Claude itère seul jusqu'à ce que la commande passe — il ne déclare pas "terminé" sur estimation.

### INV-2 · Circuit fermé
**Principe :** toute règle implicite devient explicite.
Si Claude applique un comportement non documenté, ce comportement doit devenir un hook,
une entrée dans `DECISIONS.md`, ou une règle dans `Claude.md`. Rien ne reste implicite.

### INV-3 · Contexte chirurgical
**Principe :** Claude charge uniquement les fichiers listés dans `§Handoff`, pas le repo entier.
Le `§Handoff` de `Claude.md` est la liste exhaustive et suffisante pour démarrer une session.

### INV-4 · Boucle de rétroaction
**Principe :** toute observation terrain a un chemin vers une règle permanente.
Circuit : incident → `LESSONS_LEARNED` → `/retrospective` → hook ou règle dans `Claude.md`.
Aucune observation ne se perd dans un fichier sans suite.

---

## 4. Checklist d'évolution du modèle

Avant tout commit sur ce projet :

- [ ] Invariants §3 vérifiés ou violation explicitement justifiée dans `07-DECISIONS-SDLC.md`
- [ ] Version incrémentée dans l'en-tête du fichier modifié
- [ ] Entrée `M-XXXX-NN` ajoutée dans `07-DECISIONS-SDLC.md`
- [ ] Décision ajoutée au tableau de compatibilité (universelle / conditionnelle)
- [ ] `§Historique des versions` dans `README.md` mis à jour
- [ ] `specs/SPEC.md §Modules` mis à jour si la carte des fichiers a changé
- [ ] `bash sdlc-validate.sh` → 8/8 (`M-PROC-40`) — 8 contrôles structurels du
      modèle (version, en-têtes, placeholders, parité template↔skill, schéma
      JSON hooks, carte des fichiers, unicité des IDs, syntaxe shell),
      auparavant vérifiés à l'œil un par un
- [ ] Fichiers modifiés re-synchronisés dans le projet Claude.ai
