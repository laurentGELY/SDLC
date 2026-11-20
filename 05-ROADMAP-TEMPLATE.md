# ROADMAP — [Nom du projet] · v1.0
<!-- Template SDLC v1.3 · Copier dans docs/ROADMAP.md du repo cible · Adapter le contenu, pas la structure -->

---

## ▶ Now — Sprint actif

| Item | Type | Taille | Statut |
|------|------|--------|--------|
| Sprint 1 — [Titre à définir] | Feature | M | 🔄 En cours |

**Règle :** un seul sprint **en exécution** par copie de travail ; un sprint en attente d'un déclencheur reste en §Now avec ⏸ + déclencheur + pointeur `.claude/reprise.md`.

---

## ⏭ Next — Prêt à démarrer

> Items dont les bloquants sont levés et le périmètre est défini.
> Peut démarrer dès que §Now est terminé.

| Item | Type | Taille | Débloque | Bloqué par | Déclencheur |
|------|------|--------|----------|------------|-------------|
| — | — | — | — | — | — |

**Colonne Déclencheur** (§Next et §Later) : `<déclencheur> · observé par : <script | section | /reprise | personne>`.
« personne » est autorisé mais visible, et compte comme dette sans maison au wrap-up (`M-PROC-56`).

**Règle de passage Next → Now :** bloquants levés + spec rédigée ou rédigeable en < 30 min.

---

## 🗂 Later — Backlog

> Items identifiés mais non prioritaires ou bloqués.

| Item | Catégorie | Taille | Débloque | Bloqué par | Déclencheur/Condition | Expiration |
|------|-----------|--------|----------|------------|----------------------|------------|
| — | Standard | — | — | — | — | — |

**Catégories §Later :**
- `Standard` — backlog ordinaire, déclencheur optionnel
- `Seed` — idée à déclenchement conditionnel : la colonne Déclencheur/Condition
  doit être une condition mesurable (ex : "si latence DB > 100ms sur 3 runs consécutifs"),
  pas une intention vague ("quand on aura le temps"). Un Seed n'est pas planifié avant
  que sa condition soit atteinte.

**Règle de passage Later → Next :** déclencheur atteint OU décision humaine explicite.

---

## §Seuils métriques déclencheurs

> Seuils quantitatifs qui font passer un item Later → Next automatiquement.
> À définir après le premier sprint de mesure.

<!-- [→ REMPLIR après sprint 1 — ex: "Si métrique X < seuil Y → activer item Z"] -->
- À définir

---

## §Signaux faibles

> Canal informel pour idées non matures. Max 5 lignes.
> Critère de passage vers §Later : idée assez concrète pour écrire un contexte de 3 phrases.

<!-- [idées en vrac — pas de format imposé] -->

---

## Tailles de référence

| Taille | Durée estimée | Exemples |
|--------|--------------|---------|
| XS | < 1h | Correction config, ajout d'une règle doc |
| S | 1-3h | Nouveau parseur simple, ajout d'un champ |
| M | 3h-1j | Nouveau module, refactor ciblé, audit |
| L | > 1j | Refonte architecture, nouveau pipeline |

---

## Historique — Sprints complétés

<!-- Déplacer ici les sprints terminés depuis §Now, avec leur tableau de livrables -->

*(vide au bootstrap)*
