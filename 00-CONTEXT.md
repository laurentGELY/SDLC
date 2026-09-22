# Modèle de gouvernance SDLC — Claude Code · v1.9
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

Rôle, destination projet cible, dépendances et consommateurs de chaque
module : voir la table canonique `specs/SPEC.md §Modules` — ne pas la
dupliquer ici (fusion sprint courant, évite le double-maintien constaté sur
l'ajout de `12-audit-externe-TEMPLATE.md`). Index de lecture rapide (ordre
numérique du repo) :

`00-CONTEXT.md` (ce fichier) → `01-Claude-md-TEMPLATE.md` →
`02-STANDARDS-TEMPLATE.md` → `03-wrap-up-SKILL-TEMPLATE.md` →
`04-sprint-PDR-TEMPLATE.md` → `04b-sdlc-sync-SKILL-TEMPLATE.md` →
`05-ROADMAP-TEMPLATE.md` → `06-PDR-bootstrap.md` → `07-DECISIONS-SDLC.md` →
`08-hooks-TEMPLATE.md` → `09-retrospective-SKILL-TEMPLATE.md` →
`10-AMONT-TEMPLATE.md` → `11-help-SKILL-TEMPLATE.md` →
`12-audit-externe-TEMPLATE.md`.

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
- [ ] `bash sdlc-validate.sh` → tous ✅ (`M-PROC-40`, C9 : `M-PROC-45`, C10 : `M-PROC-46`) — 10 contrôles
      structurels du modèle (version, en-têtes, placeholders, parité
      template↔skill, schéma JSON hooks, carte des fichiers, unicité des IDs,
      syntaxe shell, site `docs/` et livrables HTML à jour), auparavant vérifiés à l'œil un par un
- [ ] `docs/meta.json` (version) et `docs/pages/versions.md` (ligne du sprint)
      mis à jour — contrôlés par C9
- [ ] Marqueur `SDLC version` de `docs/SPEC.html` et `docs/MODE-OPERATOIRE.html`
      aligné, tout nouveau template cité dans leurs cartes — contrôlé par C10
- [ ] `11-help-SKILL-TEMPLATE.md` mis à jour si une skill a été ajoutée, renommée
      ou retirée dans `.claude/skills/` (`M-TMPL-05`) — un routeur qui omet une
      skill vivante ou route vers une skill morte ment
- [ ] Fichiers modifiés re-synchronisés dans le projet Claude.ai

---

## 5. Rédaction des templates et skills

Ces deux règles guident la rédaction, pas la lecture — elles s'appliquent quand on
écrit ou modifie un template ou une skill, pas à chaque session qui l'exécute.

### 5.1 · Description = déclenchement, corps = procédure

L'en-tête ou la description d'une skill énonce **quand** s'en servir (les conditions
de déclenchement), jamais **comment** — les étapes vivent uniquement dans le corps du
document, et le corps est la seule autorité. Un en-tête qui résume la séquence
d'étapes crée un raccourci qu'un agent peut suivre à la place de la lire — le corps
devient alors une documentation qu'on saute, pas une procédure qu'on exécute.

*(Sprint ECO-2, `M-TMPL-05` — cas confirmé : l'en-tête de `04b-sdlc-sync-SKILL-TEMPLATE.md`
résumait ses 4 étapes avant qu'elles ne soient détaillées plus loin, corrigé.)*

### 5.2 · La forme d'une règle dépend du type d'échec qu'elle vise

Choisir la forme d'une règle par le défaut qu'elle doit prévenir, pas à l'instinct :

| Échec visé | Forme qui marche (exemple SDLC) | Forme qui échoue |
|---|---|---|
| Viole une règle sciemment sous pression | Règle absolue + table de rationalisation Pensée → Réalité (`01-Claude-md-TEMPLATE.md`, `M-PROC-31`) | Consigne molle (« préférer… », « envisager… ») |
| Se conforme, mais la sortie a la mauvaise forme (verbeux, verdict enterré) | Recette positive — dire ce que la sortie EST, dans l'ordre (ex : gabarit du Bilan §0d du wrap-up) | Liste d'interdictions (« ne pas recopier », « ne jamais narrer ») |
| Omet un élément requis d'un livrable qu'il produit déjà | Champ structurel obligatoire dans le gabarit (ex : les 4 champs Retenu/Écarté/Raison/Déclencheur de réouverture d'une entrée `07-DECISIONS-SDLC.md`) | Rappel en prose à côté du gabarit |
| Le comportement doit dépendre d'une condition observable | Conditionnel sur un prédicat vérifiable (ex : un `HALT`, `Claude.md §Règles absolues`) | Règle inconditionnelle + clauses d'exemption |

Deux règles annexes, quelle que soit la forme retenue :
- **Pas de clause de nuance** — « sauf si ça compte » rouvre la négociation qu'une
  recette ferme. Une vraie exception s'exprime comme son propre conditionnel sur un
  prédicat observable, pas comme un assouplissement de la règle générale.
- **Une clause d'exemption ne cadre pas** — « cette limite ne s'applique pas à X »
  laisse quand même de la place à l'erreur. Si une partie doit être exemptée,
  restructurer pour que la règle ne puisse pas l'atteindre du tout.

*(Sprint ECO-2, `M-TMPL-05`, adapté de `specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md §E-09`.
Contrôle mécanique différé à une vague ultérieure de `sdlc-validate.sh`.)*
