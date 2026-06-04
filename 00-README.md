# Modèle de gouvernance SDLC — Claude Code · v1.3
<!-- Méta-document de ce projet Claude.ai · Ne pas copier dans les projets cibles -->
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
| 05 | `05-ROADMAP-TEMPLATE.md` | Backlog Now/Next/Later | `doc/ROADMAP.md` |
| 06 | `06-PDR-bootstrap.md` | Guide opérationnel Sprint 0 | *(guide d'exécution, pas copié)* |
| 07 | `07-DECISIONS-SDLC.md` | Registre des décisions sur le modèle | *(propre à ce projet)* |
| 08 | `08-hooks-TEMPLATE.md` | Hook PreToolUse Bash + settings | `.claude/hooks/` |
| 09 | `09-retrospective-SKILL-TEMPLATE.md` | Procédure de rétrospective + remontées SDLC | `.claude/skills/retrospective/SKILL.md` |
| 10 | `10-OPERATIONS.html` | Mode opératoire humain (init · sync · évolution modèle) | *(consulté par l'humain, pas copié)* |
| — | `sdlc-init.sh` | Script bootstrap d'un repo vide | *(exécuté depuis le repo SDLC)* |
| — | `04b-sdlc-sync-SKILL-TEMPLATE.md` | Skill `/sdlc-sync` pour projet existant | `.claude/skills/sdlc-sync/SKILL.md` |

**Ce fichier (`00-README.md`)** : méta-document de ce projet uniquement — jamais copié.

---

## 2. Utilisation selon le contexte

### Bootstrapper un nouveau projet
→ Lire `06-PDR-bootstrap.md` — guide complet avec plan d'exécution étape par étape.

### Faire évoluer le modèle SDLC
→ Lire §3 (invariants) avant toute modification.
→ Documenter la décision dans `07-DECISIONS-SDLC.md`.
→ Mettre à jour le numéro de version dans l'en-tête du fichier modifié.

### Comprendre une décision passée
→ Lire `07-DECISIONS-SDLC.md` — registre exhaustif avec justifications.

---

## 3. Invariants — à préserver dans toute évolution

Ces quatre principes sont les fondements du modèle.
Toute évolution qui en viole un doit être explicitement justifiée dans `07-DECISIONS-SDLC.md`.

### INV-1 · Vérification exécutable
**Principe :** tout plan de test doit contenir une commande exacte, pas une description.
Claude itère seul jusqu'à ce que la commande passe — il ne déclare pas "terminé" sur estimation.

**Conséquence pour les évolutions :**
- Ne jamais remplacer une commande de test par une formulation vague ("vérifier que ça marche")
- Tout nouveau type de sprint doit définir sa commande de vérification niveau A
- Le wrap-up ne valide pas sans test A passé — ne pas affaiblir cette règle

**Signal d'alarme :** si une section du modèle permet à Claude de conclure sans preuve observable → violation.

---

### INV-2 · Circuit fermé — rien n'existe sans trace écrite
**Principe :** toute règle implicite doit devenir explicite (hook, DECISIONS.md, ou Claude.md).
Si une contrainte dépend de la mémoire du modèle entre sessions, elle n'existe pas opérationnellement.

**Conséquence pour les évolutions :**
- Toute nouvelle règle de comportement → destination explicite (quel fichier, quelle section)
- Toute règle dans un hook → entrée DECISIONS.md obligatoire (préfixe D-HOOK-XX)
- Les LESSONS_LEARNED ne sont pas un cul-de-sac : chaque observation doit avoir un chemin vers une action (Claude.md, hook, ou DECISIONS.md)

**Signal d'alarme :** si une observation dans LESSONS_LEARNED n'a pas de champ "Action proposée" rempli → circuit ouvert.

---

### INV-3 · Contexte chirurgical
**Principe :** chaque template doit lister explicitement les fichiers à charger.
Claude ne lit pas le repo en entier — il charge uniquement ce qui est listé dans §Handoff.

**Conséquence pour les évolutions :**
- Tout nouveau template de sprint doit avoir une section §Handoff
- Les commandes `grep avant lecture` et `chargement chirurgical` dans Claude.md ne doivent pas être affaiblies
- Ajouter des fichiers au §Démarrage de session → justifier pourquoi ils sont nécessaires à chaque session

**Signal d'alarme :** si un template demande `cat specs/SPEC.md` sans condition → lecture non-chirurgicale.

---

### INV-4 · Boucle de rétroaction terrain → règle
**Principe :** toute observation de terrain a un chemin vers une règle permanente.
L'ordre est : incident → LESSONS_LEARNED `[HOOK_CANDIDATE]` → `/retrospective` → décision → hook ou Claude.md.

**Conséquence pour les évolutions :**
- Ne pas court-circuiter la boucle en ajoutant des règles directement dans les hooks sans passage par LESSONS_LEARNED
- La question hook candidat dans wrap-up (Étape 1) ne doit pas être supprimée ou rendue optionnelle
- `/retrospective` doit toujours scanner les `[HOOK_CANDIDATE]` non résolus

**Signal d'alarme :** si une règle apparaît dans `pre-tool-bash.sh` sans entrée DECISIONS.md correspondante → règle implicite.

---

## 4. Checklist d'évolution du modèle

Avant tout commit sur ce projet SDLC :

- [ ] Le changement respecte INV-1 (vérification exécutable) ou la violation est justifiée dans 07
- [ ] Le changement respecte INV-2 (circuit fermé) — toute nouvelle règle a une destination
- [ ] Le changement respecte INV-3 (contexte chirurgical) — pas de lecture globale ajoutée
- [ ] Le changement respecte INV-4 (boucle rétroaction) — le chemin terrain → règle est intact
- [ ] `07-DECISIONS-SDLC.md` mis à jour si la décision est non triviale
- [ ] Numéro de version mis à jour dans l'en-tête du fichier modifié

---

## 5. Historique des versions

| Version | Date | Changements principaux |
|---------|------|------------------------|
| v1.0 | 29/05/2026 | Bootstrap initial — 7 fichiers |
| v1.1 | 30/05/2026 | Bilan session (Étape 0 wrap-up) · Auto-exécution · Nettoyage artefacts · DIAGNOSTIC_CMDS obligatoire |
| v1.2 | 30/05/2026 | Hooks template (08) · Boucle rétroaction LESSONS_LEARNED → hook · Given/When/Then PDR · Champ Interdit PDR · Vérification exécutable renforcée · README méta-document (00) · Retrospective skill (09) · Circuit remontée SDLC via [SDLC_CANDIDATE] |
| v1.3 | 03/06/2026 | Sprint SDLC-Sync · Skill /sdlc-sync (04b) · Script sdlc-init.sh · Marqueur version SDLC dans templates · Tableau compatibilité décisions · Mode opératoire HTML (10) |
