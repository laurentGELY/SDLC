# Sprint SDLC-GSD-V1 — Import GSD : patterns friction nulle (Vague 1)
<!-- SDLC v1.9 · specs/Sprints/sprint-SDLC-GSD-V1.md -->

**Type :** Doc
**Taille :** M
**Surface :** `01-Claude-md-TEMPLATE.md` · `03-wrap-up-SKILL-TEMPLATE.md` · `04-sprint-PDR-TEMPLATE.md` · `05-ROADMAP-TEMPLATE.md`
**Risque :** Faible

---

## Contexte

Conclusion des audits externes GSD-full et GSD-lite (`doc/SYNTHESE-AUDITS-GSD.md`).
Six propositions à friction nulle ont été validées et leurs décisions actées.
Ce sprint les implémente en une passe — les fichiers touchés sont distincts
(sauf `04-sprint-PDR-TEMPLATE.md` qui reçoit 4 modifications indépendantes).

Référence décisions : `doc/SYNTHESE-AUDITS-GSD.md §4 Vague 1` et `§5 Décisions actées`.

---

## Objectif

Quatre templates SDLC enrichis avec les 6 patterns GSD retenus,
tous vérifiables par grep, zéro régression sur les sections existantes.

---

## Comportement actuel → cible

- **Actuel :** SESSION_BRIDGE sans critère de qualité explicite · PDR sans guidance goal-backward ni signaux context rot ni méthode de découpe · ROADMAP sans Seeds · Claude.md sans permission /fast
- **Cible :** chaque gap comblé par une addition ciblée — zéro réécriture de section existante

---

## Portée

**Inclus :**
- **Prop L** — Note STATELESS HANDOFF dans `03-wrap-up-SKILL-TEMPLATE.md §Étape 5`
- **Prop F** — Guidance goal-backward dans `04-sprint-PDR-TEMPLATE.md §Critères d'acceptation`
- **Prop G** — 3 signaux précoces context rot dans `04-sprint-PDR-TEMPLATE.md` (section optionnelle Taille L)
- **Prop I** — Enrichissement §Later dans `05-ROADMAP-TEMPLATE.md` : type `Seed` + colonne `Condition` formalisée
- **Prop J** — Note SPIDR dans `04-sprint-PDR-TEMPLATE.md §Portée`
- **Prop E2** — Note /fast dans `01-Claude-md-TEMPLATE.md §Démarrage`

**Exclu explicitement :**
- Propositions H, K, D, A, E1, B, M, N, O (Vague 2, 3 ou hors planning)
- Toute réécriture de section existante — additions uniquement
- Tout code ou script shell

---

## Dépendances

**Inputs requis :**
- [x] `doc/SYNTHESE-AUDITS-GSD.md` — décisions actées §5
- [x] Templates existants dans le projet SDLC (chargés en contexte)

**Outputs produits :**
- [ ] `01-Claude-md-TEMPLATE.md` vX.Y+1 — §Démarrage +note /fast
- [ ] `03-wrap-up-SKILL-TEMPLATE.md` vX.Y+1 — §Étape 5 +STATELESS
- [ ] `04-sprint-PDR-TEMPLATE.md` vX.Y+1 — §CA +goal-backward · §Portée +SPIDR · nouvelle section §Signaux Taille L
- [ ] `05-ROADMAP-TEMPLATE.md` vX.Y+1 — §Later +type Seed +colonne Condition

---

## Contenu exact à implémenter

### Prop L — STATELESS HANDOFF dans §Étape 5 wrap-up

Ajouter **après** le bloc format SESSION_BRIDGE existant, **avant** la règle de nettoyage :

```
**Critère de qualité — test STATELESS :**
Avant de valider l'entrée SESSION_BRIDGE, vérifier mentalement :
"La session suivante peut-elle reprendre uniquement depuis ce fichier,
sans accès à la conversation précédente ?"
Si non → enrichir les champs "bloquants" ou "fil fonctionnel" jusqu'à ce que la réponse soit oui.
```

---

### Prop F — Goal-backward dans §Critères d'acceptation PDR

Ajouter une note sous le bloc `- [ ]` existant dans `§Critères d'acceptation` :

```
<!-- Guidance goal-backward (GSD audit) :
     Formuler chaque critère comme un comportement observable ou un état vérifiable,
     pas comme une tâche accomplie.
     ✗ "le module est créé"
     ✓ "la commande X retourne Y dans le cas Z"
     ✗ "l'erreur est gérée"
     ✓ "curl localhost:8000/endpoint avec payload invalide retourne HTTP 422 + {error: string}"
-->
```

---

### Prop G — Signaux précoces context rot (section optionnelle Taille L)

Ajouter une nouvelle section `## Signaux de dégradation *(Taille L uniquement)*`
dans `04-sprint-PDR-TEMPLATE.md`, juste avant `## Risques` :

```markdown
## Signaux de dégradation *(Taille L uniquement — supprimer pour XS/S/M)*

Si l'un de ces signaux apparaît pendant l'exécution, checkpoint immédiat dans
`sprint-memory.md` et signaler avant de continuer :

- **Silent partial completion** — Claude rapporte "fait" mais l'implémentation est incomplète
  (ex : "la fonction gère les erreurs" sans que le catch soit présent dans le diff)
- **Increasing vagueness** — apparition de formulations comme "appropriate handling",
  "standard approach", "as needed" au lieu de code ou valeurs spécifiques
- **Skipped steps** — Claude rapporte N critères d'acceptation sur M (N < M) comme couverts
  sans mentionner les manquants
```

---

### Prop I — Seeds dans §Later ROADMAP

Dans `05-ROADMAP-TEMPLATE.md §Later` :

**Étape 1 — Ajouter la colonne `Type` au tableau existant :**
```
| Item | Type | Taille | Débloque | Bloqué par | Déclencheur | Expiration |
```
devient :
```
| Item | Catégorie | Taille | Débloque | Bloqué par | Déclencheur/Condition | Expiration |
```

**Étape 2 — Ajouter une note sous le tableau :**
```
**Catégories §Later :**
- `Standard` — backlog ordinaire, déclencheur optionnel
- `Seed` — idée à déclenchement conditionnel : la colonne Déclencheur/Condition
  doit être une condition mesurable (ex : "si latence DB > 100ms sur 3 runs consécutifs"),
  pas une intention vague ("quand on aura le temps"). Un Seed n'est pas planifié avant
  que sa condition soit atteinte.
```

---

### Prop J — SPIDR dans §Portée PDR

Ajouter à la fin de la section `## Portée` dans `04-sprint-PDR-TEMPLATE.md` :

```
<!-- Si ce sprint semble trop large pour une Taille L raisonnable, découper
     via SPIDR — un seul axe par split, happy path et scope minimum en premier :

| Axe        | Question de découpe                                              |
|------------|------------------------------------------------------------------|
| Spike      | Y a-t-il une inconnue qui nécessite recherche avant de coder ?  |
| Paths      | Y a-t-il un happy path et des edge paths séparables ?           |
| Interfaces | Cette feature doit-elle fonctionner sur plusieurs interfaces ?   |
| Data       | Y a-t-il plusieurs scopes de données (1 item vs beaucoup) ?     |
| Rules      | Y a-t-il des business rules ajoutables progressivement ?        |
-->
```

---

### Prop E2 — Mode /fast dans Claude.md §Démarrage

Ajouter dans `01-Claude-md-TEMPLATE.md §Démarrage`, après la séquence 4a-4d
(ou dans le bloc §Classifier le travail), une note :

```
**Mode /fast (correction < 2 min) :** pour une correction formulable en une seule phrase
et exécutable en moins de 2 minutes (typo, rename, config line), pas de PDR requis.
Commit direct avec message conventionnel. Ne pas utiliser si la correction touche
un module partagé (§Modules partagés de STANDARDS.md) ou nécessite un test non-trivial.
```

---

## Critères d'acceptation

### Prop L
- [ ] `grep -n "STATELESS" 03-wrap-up-SKILL-TEMPLATE.md` → ≥ 1 résultat dans §Étape 5

### Prop F
- [ ] `grep -n "goal-backward\|observable\|vérifiable" 04-sprint-PDR-TEMPLATE.md` → ≥ 1 résultat dans §Critères d'acceptation

### Prop G
- [ ] `grep -n "Signaux de dégradation\|Silent partial\|Increasing vagueness\|Skipped steps" 04-sprint-PDR-TEMPLATE.md` → 4 résultats

### Prop I
- [ ] `grep -n "Seed\|Condition mesurable\|déclenchement conditionnel" 05-ROADMAP-TEMPLATE.md` → ≥ 2 résultats
- [ ] `grep -n "Catégorie\|Standard\|Seed" 05-ROADMAP-TEMPLATE.md` → ≥ 3 résultats

### Prop J
- [ ] `grep -n "SPIDR\|Spike\|Paths\|Interfaces\|Data\|Rules" 04-sprint-PDR-TEMPLATE.md` → ≥ 5 résultats dans §Portée

### Prop E2
- [ ] `grep -n "fast\|< 2 min\|une phrase" 01-Claude-md-TEMPLATE.md` → ≥ 1 résultat dans §Démarrage

### Non-régression (toutes props)
- [ ] `grep -c "\[→ ADAPTER\]" 04-sprint-PDR-TEMPLATE.md` — comparer avant/après : même nombre ou plus (zéro perte de marqueur existant)
- [ ] `grep -c "## Étape" 03-wrap-up-SKILL-TEMPLATE.md` — comparer avant/après : même nombre (zéro étape supprimée)
- [ ] CHANGELOG mis à jour avec entrée `Sprint SDLC-GSD-V1`
- [ ] `07-DECISIONS-SDLC.md` — entrée M-PROC-38 (ou prochain ID libre) documentant les 6 propositions importées

---

## Risques

- **Collision sur `04-sprint-PDR-TEMPLATE.md`** : probabilité faible (3 sections différentes touchées : §CA, §Portée, nouvelle section §Signaux) · mitigation : appliquer dans l'ordre F → J → G, grep de non-régression entre chaque modification
- **Marqueur `[→ ADAPTER]` perdu** : probabilité faible · mitigation : grep avant/après (CA non-régression ci-dessus)

---

## Pre-mortem

> Si ce sprint produit une régression, la cause la plus probable est :
> une modification dans `04-sprint-PDR-TEMPLATE.md` a écrasé une section existante
> au lieu d'être une addition.

Mitigation : chaque modification est un ajout après/avant un ancre textuel précis,
jamais un remplacement de bloc existant. Vérifier `git diff` section par section.

---

## Handoff Claude Code

**Fichiers — chargement immédiat :**
- Ce PDR (specs/Sprints/sprint-SDLC-GSD-V1.md)
- `03-wrap-up-SKILL-TEMPLATE.md` — §Étape 5 uniquement : `grep -n "Étape 5\|SESSION_BRIDGE" 03-wrap-up-SKILL-TEMPLATE.md`
- `04-sprint-PDR-TEMPLATE.md` — §Critères d'acceptation + §Portée : `grep -n "Critères d'acceptation\|## Portée\|## Risques" 04-sprint-PDR-TEMPLATE.md`
- `05-ROADMAP-TEMPLATE.md` — §Later uniquement : `grep -n "Later\|Déclencheur\|Expiration" 05-ROADMAP-TEMPLATE.md`
- `01-Claude-md-TEMPLATE.md` — §Démarrage : `grep -n "Démarrage\|Classifier" 01-Claude-md-TEMPLATE.md`

**Fichiers — chargement différé :**
- Sections complètes des templates — uniquement si l'ancre textuel ne suffit pas à localiser le point d'insertion

**Données à collecter avant de modifier :**
```bash
# Comptes de référence pour non-régression
grep -c "\[→ ADAPTER\]" 04-sprint-PDR-TEMPLATE.md
grep -c "## Étape" 03-wrap-up-SKILL-TEMPLATE.md
# Versions actuelles des 4 fichiers
grep "Template SDLC" 01-Claude-md-TEMPLATE.md | head -1
grep "Template SDLC" 03-wrap-up-SKILL-TEMPLATE.md | head -1
grep "Template SDLC" 04-sprint-PDR-TEMPLATE.md | head -1
grep "Template SDLC" 05-ROADMAP-TEMPLATE.md | head -1
```

**Instructions spécifiques :**
- Ordre d'exécution : L → F → J → G → I → E2 (du moins au plus invasif)
- Chaque modification : addition ciblée via ancre textuel précis — jamais remplacement de bloc
- Grep de CA individuel après chaque prop avant de passer à la suivante
- Version template à incrémenter dans l'en-tête de chaque fichier modifié
- Entrée M-PROC-38 dans `07-DECISIONS-SDLC.md` en une seule entrée groupée (6 props, format compact)
- Un seul commit final après tous les CA passés

**Init mémoire sprint :**
```bash
echo "# Sprint SDLC-GSD-V1 · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-SDLC-GSD-V1.md" >> .claude/sprint-memory.md
```

---

## Plan de développement
*(à compléter par Claude Code après lecture des ancres textuels)*

**Dépendances vérifiées :**
- [ ] `03-wrap-up-SKILL-TEMPLATE.md` — §Étape 5 localisée
- [ ] `04-sprint-PDR-TEMPLATE.md` — §Critères d'acceptation, §Portée, §Risques localisés
- [ ] `05-ROADMAP-TEMPLATE.md` — §Later + colonnes tableau localisées
- [ ] `01-Claude-md-TEMPLATE.md` — §Démarrage localisé

**Plan d'exécution :**
1. Collecter comptes de référence (grep non-régression)
2. Prop L — §Étape 5 wrap-up : ajouter bloc STATELESS après format SESSION_BRIDGE
3. Prop F — §Critères PDR : ajouter commentaire goal-backward sous le bloc `- [ ]`
4. Prop J — §Portée PDR : ajouter commentaire SPIDR en fin de section
5. Prop G — PDR : insérer section `## Signaux de dégradation` avant `## Risques`
6. Prop I — §Later ROADMAP : renommer colonne + ajouter note catégories
7. Prop E2 — §Démarrage Claude.md : ajouter note /fast après séquence 4a-4d
8. Vérifier tous les CA individuels
9. Vérifier CA non-régression
10. Incrémenter versions dans les 4 en-têtes
11. Écrire entrée M-PROC-38 dans `07-DECISIONS-SDLC.md`
12. Mettre à jour CHANGELOG
13. Commit

**Plan de test :**
- A — Ciblé : 6 greps individuels (un par prop) — voir §Critères d'acceptation
- A — Non-régression : `grep -c "\[→ ADAPTER\]"` et `grep -c "## Étape"` — comparer avant/après

---

## Corrections ajustées vs spec
*(complété au wrap-up)*
