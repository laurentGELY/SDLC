---
name: reprise
description: Reprise des sprints ouverts depuis .claude/reprise.md — traite d'abord les actions « en vol », vérifie les déclencheurs, propose le plan du jour sans rien exécuter avant validation. Utiliser sur /reprise, « /reprise init », « quelle est la suite (des sprints) », « où on en est des sprints », ou à l'ouverture d'une session sans sprint désigné. Pas pour la suite d'une tâche en cours dans la même session.
---
# reprise — SKILL
<!-- Template SDLC v1.0 · Destination : .claude/skills/reprise/SKILL.md dans le repo cible -->
<!-- Adapter uniquement les sections marquées [→ ADAPTER] · M-PROC-55 · source : /reprise v1.2.1 d'un projet du modèle, rendu générique -->

`.claude/reprise.md` porte le **futur de tous les sprints ouverts** : ce qui reste à faire, quand, et
comment le vérifier. Ce skill est la référence du format ; l'en-tête du fichier en est une copie.

---

## Les trois mémoires

| Fichier | Horizon | Contenu | Versionné | Écrit par |
|---|---|---|---|---|
| `.claude/sprint-memory.md` | un sprint | journal de décision du sprint en cours (ANALYSE, DÉCISION, TEST…) — une par copie de travail | non — détruit au commit de wrap-up | Claude, pendant le sprint |
| `docs/SESSION_BRIDGE.md` | inter-session | contexte du dernier sprint clos (fil fonctionnel, bloquants) | oui | `/wrap-up` |
| `.claude/reprise.md` | les jours, plusieurs sprints | actions différées, déclencheurs, actions « en vol » — une seule pour le dépôt | non | `/reprise`, le démarrage d'un sprint (étape 4e), `/wrap-up` (purge) |

`docs/ROADMAP.md §Now` dit **quel** sprint est en exécution ; `.claude/reprise.md` dit **ce qui reste**
pour chaque sprint ouvert, y compris ceux qui attendent un déclencheur.

---

## Emplacement — toujours la copie principale

Le fichier n'est pas versionné : chaque copie de travail aurait le sien. Le fichier unique est **celui de
la copie principale**, même depuis un worktree :

```bash
REPRISE="$(git worktree list --porcelain | sed -n '1s/^worktree //p')/.claude/reprise.md"
echo "$REPRISE"
```

Jamais `.claude/reprise.md` en chemin relatif depuis un worktree. Pas de `awk '{print …}'` à champ
numéroté dans ce skill : Claude Code remplace les `$` suivis d'un chiffre par les arguments du skill.

La mémoire de sprint, elle, reste **une par copie de travail** (`.claude/sprint-memory.md` du worktree
où le sprint s'exécute) : c'est la seule exception au fichier unique.

---

## Format

### En-tête (recopié dans le fichier à sa création)

```markdown
# Reprise — sprints ouverts
<!-- non versionné · format : .claude/skills/reprise/SKILL.md -->

Règles :
- **R1 — Écriture immédiate** : à chaque changement d'état (action différée créée, déclencheur atteint,
  action faite). Pas de réécriture si rien n'a changé. Pas de commit.
- **R2 — Intention avant action** : avant toute action qui modifie des données (écriture de données,
  `--appliquer`, migration, suppression, écrasement), inscrire dans « En vol » la commande exacte,
  l'heure, l'effet attendu et comment vérifier l'aboutissement. Retirer l'entrée une fois
  l'aboutissement confirmé. Un processus ou un état qui survit à la session (job en arrière-plan,
  boucle `until`, minuterie) est inscrit dans « En vol » avec sa commande d'arrêt — sinon il n'est
  pas lancé.
- **R3 — Purge** : action faite → supprimée d'ici, résultat versé dans le fichier du sprint. Sprint clos
  → bloc supprimé (par /wrap-up). Le fichier ne contient que de l'ouvert.
- **R4 — Déclencheur vérifiable** : date absolue **ou** condition observable par une commande (ex.
  « ≥ 30 décisions » + commande de comptage), et endroit où regarder (log, fichier, sortie attendue).
  Sinon → ROADMAP §Later, pas ici.
- **R5 — Test de régénération** : « si la session d'hier n'avait jamais existé, le retrouverait-on en
  lisant le repo ? » Non → verbatim (commandes, fichiers datés, options et leur ordre, listes et
  décisions, résultat attendu). Oui → pointer vers la source sans recopier.
- **R6 — Pas de secrets** : aucun identifiant, token ou donnée personnelle.

## En vol

## Sprints ouverts
```

### Entrée « En vol » (R2)

```
- 2026-10-21 09:42 · S12 · `python3 scripts/migrer_tracker.py data/export_20261019.csv --appliquer`
  · effet attendu : colonnes migrées dans le tracker
  · vérifier : sauvegarde datée du tracker présente + `grep -c ';v2;' data/tracker.csv` > 0
- 2026-10-21 10:05 · S12 · boucle d'attente `until test -f data/fin.flag; do sleep 60; done` (arrière-plan)
  · arrêt : `pkill -f '^until test -f data/fin.flag'` (ou fermer le terminal qui la porte)
  · vérifier : `pgrep -f '^until test -f data/fin.flag'` → vide une fois close
```

« vérifier » est une observation exécutable (fichier présent, `grep`, `jq`, ligne de log), pas une
intention.

### Bloc de sprint

```
### S12 — migration-tracker · statut : débloquable | bloqué | en cours | clôturable
Spec : specs/Sprints/sprint-12-migration-tracker.md · copie : ../<projet>-12 (si worktree)
Reste pour clore : [ ] colonnes migrées · [ ] contrôle post-migration · [ ] wrap-up
Dépend de : —            (ex. « S11 clos », « run du 2026-10-21 »)

- [ ] Relecture et application de la migration · déclencheur : export produit le 2026-10-19
      (data/export_20261019.csv) · créé 2026-10-19 · confirmée
  Étapes :
  1. Relire l'export, en ne corrigeant que la colonne attendue (tolérances : voir le script).
  2. Essai à blanc :
     `cd <racine du projet> && python3 scripts/migrer_tracker.py data/export_20261019.csv`
  3. Écriture : même commande avec `--appliquer` (sauvegarde du tracker faite avant) → passe par R2.
  Attendu : aucun écart restant à l'essai à blanc · si KO : <conduite à tenir>
```

- Statuts : **clôturable** (tout coché sauf wrap-up) · **débloquable** (un déclencheur est atteint) ·
  **en cours** (travail possible sans attendre) · **bloqué** (attend une date ou un tiers — date de
  déblocage prévue écrite).
- Fiabilité de chaque action : *confirmée* (écrite depuis une session vivante) ou *reconstituée*
  (déduite du repo par `/reprise init`).
- Échéance datée sans sprint ouvert (ex. contrôle à J+14 après clôture) : bloc `### Échéances` en fin
  de fichier, même format d'action.
- Alerte d'un contrôle automatique **non expliquée au run suivant** → échéance datée dans
  `### Échéances` (date + fichier à relire), jamais laissée au wrap-up.

### Marqueur de statut des specs (posé à l'ouverture et par /wrap-up)

Ligne 1 de `specs/Sprints/sprint-<N>-<slug>.md`, sans gras : `Statut : ouvert` ou
`Statut : clos — AAAA-MM-JJ`. Motif d'inventaire :

```bash
for f in specs/Sprints/sprint-*.md; do head -1 "$f" | grep -qE '^Statut : ouvert' && echo "$f"; done
```

### Cycle de vie d'un bloc

- **Ouverture** — à la réception d'un PDR (`CLAUDE.md §Démarrage`, étape 4e) : créer le bloc du sprint,
  « Reste pour clore » rempli depuis les critères d'acceptation du PDR ; la spec porte `Statut : ouvert`.
- **Clôture** — par `/wrap-up`, dans le même geste : `Statut : clos — AAAA-MM-JJ` en ligne 1 de la spec
  et suppression du bloc (R3). Ce marqueur est la source de l'inventaire de `/reprise init`.
- **Hygiène** — à chaque `/wrap-up` et au moins toutes les 2 semaines : le fichier ne contient que des
  sprints `Statut : ouvert`, aucune action faite, et `## En vol` est vide hors session. Écart → purge,
  puis vérifier que l'ouverture et la clôture ci-dessus ont été appliquées.

---

## Procédure du matin (`/reprise`)

0. Résoudre `$REPRISE` (§Emplacement). **Absent, vide ou illisible** (en-tête ou sections manquants)
   → le dire et proposer `/reprise init` ; ne rien inventer.
1. Lire le fichier.
2. **`## En vol` d'abord.** Pour chaque entrée, exécuter la vérification inscrite (lecture seule) et
   conclure : **abouti** · **pas eu lieu** · **indéterminé** (dire pourquoi). Rapporter ce résultat
   avant tout le reste. Ne rien relancer sans validation. Abouti confirmé → retirer l'entrée (R2) et
   verser le résultat dans le fichier du sprint (R3), après accord.
3. Pour chaque sprint : vérifier chaque déclencheur (date passée ? log ou fichier présent ? sortie
   conforme à l'attendu ?) par commande en lecture seule ; mettre à jour le statut. Un déclencheur dont
   la date est passée mais dont la preuve manque n'est **pas** atteint : le signaler.
4. **Même objet** : signaler deux sprints ouverts qui touchent le même objet (mêmes fichiers dans
   « Reste pour clore », même section de ROADMAP, même module ou même prompt), même si leur
   `Dépend de` vaut « — » : leur relation (absorption, ordre ou partage) doit être écrite dans
   `Dépend de`. *(Cas réel : trois sprints sur la même section, absorption vue 5 jours après.)*
5. Ordonner : d'abord selon `Dépend de`, puis clôturables, débloquables, en cours, bloqués (avec leur
   date de déblocage).
6. Présenter le plan du jour, sprint par sprint, en étapes numérotées. Commandes reprises **verbatim** ;
   la prose est reformulée. Indiquer pour chaque étape qui agit (Claude Code / l'humain). Signaler les
   écarts vus en vérifiant (déclencheur dépassé sans preuve, sprint clos encore présent, worktree
   orphelin).
7. **Demander validation avant d'exécuter quoi que ce soit.**
8. Pendant l'exécution validée : R1 (écriture immédiate), R2 (En vol avant toute action qui modifie des
   données ou qui survit à la session), R3 (purge).

Écrire les changements de statut de l'étape 3 dans le fichier (R1) une fois le plan présenté.

---

## Mode `/reprise init` — amorçage ou récupération

Le fichier n'est pas versionné : ce mode est sa seule voie de reconstruction. Ne jamais écraser un
bloc existant marqué *confirmée* ; compléter à côté.

1. **Inventaire des sprints ouverts.** Croiser — aucune source seule ne suffit (un sprint peut n'avoir
   aucune spec dans le dépôt) :
   ```bash
   sed -n '/^## ▶ Now/,/^## ⏭ Next/p' docs/ROADMAP.md               # sprint en exécution, sprints ⏸
   awk '/^## §Actif/{f=1;next} /^## §Archive/{f=0} f' docs/SESSION_BRIDGE.md
   for f in specs/Sprints/sprint-*.md; do head -1 "$f" | grep -qE '^Statut : ouvert' && echo "$f"; done
   git worktree list                                                  # un worktree = souvent un sprint vivant
   for d in $(git worktree list --porcelain | sed -n 's/^worktree //p'); do
     [ -s "$d/.claude/sprint-memory.md" ] && { echo "== $d"; head -2 "$d/.claude/sprint-memory.md"; }
   done
   git log --oneline --since="14 days ago"
   ```
   Ignorer les documents de référence de `specs/Sprints/` qui ne suivent pas le motif `sprint-*.md`.
   → **Soumettre la liste des sprints ouverts et attendre la confirmation de l'utilisateur.**
2. **Reste pour clore.** Partir des critères d'acceptation du PDR (spec du sprint, ou ROADMAP §Now à
   défaut), retirer ceux déjà validés (mémoire sprint `TEST … OK ✓`, commits, CHANGELOG).
3. **Actions en attente.** Chercher dans : la mémoire sprint (`EN ATTENTE`, `QUESTION`, `BLOQUANT`), la
   spec (« à vérifier au run du … »), ROADMAP §Now (« clôture après … »), les sorties datées récentes
   du projet.
   <!-- [→ ADAPTER] répertoires de sorties datées et de logs du projet, ex. : ls -t data/ | head ; ls -t logs/ | head -->
4. **Fiabilité.** Marquer chaque entrée *confirmée* ou *reconstituée*. Lister explicitement les trous :
   déclencheur inconnu, résultat attendu inconnu, commande non retrouvée.
5. **Présenter le brouillon** avec ses trous ; l'utilisateur les complète ; puis écrire le fichier
   (en-tête du §Format inclus).

### Amorçage d'un projet existant (une fois)

0. **Marquage rétroactif des specs** : proposer la liste `fichier → statut`, avec pour les clos la date
   du dernier commit qui touche le fichier (`git log -1 --format=%cs -- <f>`) ; cas à arbitrer listés
   à part ; écrire après confirmation, par script (`sed -i '1i Statut : …' <f>`).
1. Sprints encore ouverts dans une session vivante d'abord (blocs *confirmée*).
2. `/reprise init` pour le reste, sans écraser les blocs confirmés.
3. Session neuve, sur aucun sprint : « quelle est la suite ? » → plan complet sans question de contexte.

---

## Mémoire de sprint non vide au démarrage

*(Reçu de `CLAUDE.md §Démarrage` — R-26, M-PROC-10.)* Si `.claude/sprint-memory.md` est non vide en
début de session et que son en-tête ne correspond pas au sprint spec en cours : afficher le contenu et
poser le bloc suivant — **attendre la réponse avant de continuer** :

```
⚠️  MÉMOIRE SPRINT NON VIDE — sprint précédent non clôturé ?

Causes possibles :
  A) Wrap-up oublié à la fin du sprint précédent
  B) Crash ou interruption de session
  C) Sprint interrompu volontairement
  D) Session tronquée — contexte dégradé

Actions :
  1) Lancer /wrap-up maintenant pour clore ce sprint proprement
  2) Reprendre ce sprint là où il s'est arrêté
  3) Abandonner ce sprint — supprimer le fichier et démarrer un nouveau
  4) Reprendre depuis la dernière DÉCISION ou TEST OK valide
     → lire sprint-memory.md, identifier le dernier point stable,
       proposer la prochaine action minimale de continuation
```

En-tête qui correspond au sprint spec en cours → reprise normale, pas d'anomalie, continuer sans
bloquer. Un sprint qui attend un déclencheur garde sa mémoire : son bloc dans `$REPRISE` le dit.

---

## Mémoire de sprint perdue ou contexte compacté

*(Reçu de `CLAUDE.md §Mémoire de sprint` — R-56, R-57, M-PROC-10, M-PROC-43.)*

**Perte accidentelle en cours de sprint** — `.claude/sprint-memory.md` absent alors qu'un sprint est
manifestement en cours (spec `Statut : ouvert`, bloc dans `$REPRISE`, ou `git diff HEAD` non vide sans
commit de wrap-up récent) → ne pas continuer sans trace. Reconstruire un résumé minimal :

```bash
git diff HEAD                    # fichiers et changements en cours
git log --oneline -3             # ancrage temporel
```

Format minimal acceptable : 3-5 entrées DÉCISION/TEST couvrant l'état connu. Signaler la
reconstruction explicitement : `[RECONSTRUIT depuis git diff]`.

**Précédence après compaction ou reprise** — `sprint-memory.md` (ligne d'identité + entrées) et
`git log` font foi sur le souvenir de session : un commit qu'ils nomment existe dans git même si le
contexte courant ne se souvient plus de l'avoir créé. En cas de doute entre une impression de session
et une trace écrite, vérifier par `git log` / `git diff` avant d'agir sur cette impression.
