# Sprint SDLC-23 — Hook PreCompact × sprint-memory.md

**Type :** Feature
**Taille :** S
**Surface :** nouveau `.claude/hooks/pre-compact.sh` · `.claude/settings.json` (entrée hook) · `01-Claude-md-TEMPLATE.md` (référence M-PROC-13 étendue) · `08-hooks-TEMPLATE.md` (nouvelle section)
**Risque :** Faible

---

## Contexte

Deux besoins identifiés séparément convergent sur le même mécanisme natif :
1. Réduire la perte de contexte/reprise coûteuse en cas de pause forcée par
   tranche horaire (contrainte produit : pause, jamais de dépassement de budget)
2. `sprint-memory.md` (M-PROC-10/13) gère déjà la reprise après session tronquée
   (crash), mais rien ne le déclenche automatiquement avant une compaction —
   la compaction et la pause-tranche-horaire sont structurellement le même
   moment à risque (contexte qui sature avant la fin d'une étape).

Le hook `PreCompact` est confirmé natif Claude Code (payload : `session_id`,
`transcript_path`, `cwd`, `trigger: manual|auto`) — c'est le point d'ancrage
qui manquait pour automatiser ce qui était jusqu'ici une discipline manuelle
(écriture de `sprint-memory.md` "quand on y pense").

---

## Objectif

Toute compaction (manuelle ou automatique) déclenche l'écriture d'une entrée
`sprint-memory.md` structurée, sans intervention humaine, rendant la reprise
après pause-tranche-horaire aussi peu coûteuse que la reprise après crash
déjà gérée par `M-PROC-13`.

---

## Comportement actuel → cible

- **Actuel :** `sprint-memory.md` mis à jour manuellement par Claude Code au fil
  du sprint, sans déclencheur systématique avant une compaction. Une pause qui
  tombe juste avant compaction risque de perdre le fil sans entrée récente.
- **Cible :** hook `PreCompact` écrit automatiquement une entrée de
  checkpoint dans `sprint-memory.md` (horodatée, type `CHECKPOINT`, trigger
  `manual`/`auto` noté) avant que la compaction n'efface le détail du
  contexte conversationnel.

---

## Portée

**Inclus :**
- Script `.claude/hooks/pre-compact.sh` : lit le JSON stdin (`trigger`,
  `transcript_path`), ajoute une entrée `CHECKPOINT` en tête de
  `sprint-memory.md` (cohérent avec le format accumulatif déjà utilisé pour
  `SESSION_BRIDGE.md`, M-PROC-22)
- Entrée dans `.claude/settings.json` (`async: false` — le checkpoint doit
  être écrit avant que la compaction ne parte, pas en best-effort)
- Extension documentée de `M-PROC-13` : la pause-tranche-horaire est un cas
  d'usage de reprise au même titre que le crash
- `08-hooks-TEMPLATE.md` : nouvelle section, hook optionnel `[ACTIVER si…]`
  comme les autres hooks du template

**Exclu (explicitement) :**
- Injection automatique du checkpoint au `SessionStart` suivant (resterait
  manuel — la lecture de `sprint-memory.md` en `§Démarrage` existe déjà,
  pas besoin de la dupliquer dans ce hook)
- Backup brut du transcript JSONL (pattern vu dans la doc générique) — hors
  scope, `sprint-memory.md` est le format déjà gouverné, pas un nouveau
  fichier de sauvegarde parallèle
- Tout réglage de seuil de compaction (`contextThreshold` ou équivalent) —
  non confirmé comme réglage réel, voir avis Oracle précédent

---

## Option retenue — alternatives écartées

**Retenue :** hook `PreCompact` écrivant directement dans `sprint-memory.md`
existant, réutilisant son format d'entrée déjà horodaté.

**Écartée(s) :**
- Fichier de backup séparé (`/tmp/claude-context-backup.md` ou équivalent,
  pattern vu dans les exemples génériques) — créerait un deuxième réceptacle
  à maintenir alors que `sprint-memory.md` couvre déjà ce rôle
- Hook `SessionStart` matcher `compact` en complément — reporté hors scope,
  l'injection au redémarrage est déjà couverte par la lecture manuelle
  existante en `§Démarrage`

**Sacrifices délibérés :** le hook ne distingue pas le contenu exact perdu
par la compaction (il ne lit pas le détail du transcript) — il pose un
checkpoint au bon moment, il ne reconstruit pas un résumé sémantique. Cohérent
avec le principe "le script fait le mécanique, Claude fait le sens" (M-PROC-24).

---

## Contraintes techniques / produit

- Script bash pur, cohérent avec les hooks déjà actés (`pre-tool-bash.sh`)
- Doit lire le JSON stdin correctement (`trigger` peut être `manual` ou
  `auto` — les deux doivent être gérés, pas seulement `auto`)
- Timeout court — le hook bloque la compaction tant qu'il tourne (PreCompact
  est un événement bloquant), donc écriture simple, zéro opération lente

**Interdit :**
- Modifier le format existant de `sprint-memory.md` — ajouter une entrée du
  type déjà défini, pas une nouvelle convention
- Faire dépendre la compaction elle-même du succès du hook au-delà du
  raisonnable (si écriture échoue, ne pas bloquer indéfiniment — timeout
  explicite à fixer)

---

## Dépendances

**Inputs requis :**
- [x] Schéma payload `PreCompact` — **claim initial du PDR invalidé** : le champ
      annoncé (`trigger`) n'existe pas, le champ réel est `compaction_reason`
      (+ `context_used_tokens`/`context_limit_tokens`/`estimated_tokens_freed`),
      reconfirmé en session par `WebFetch` verbatim avant tout code — voir
      §Corrections ajustées vs spec et `07-DECISIONS-SDLC.md M-HOOKS-08`
- [x] Format d'entrée actuel de `sprint-memory.md` (M-PROC-10/13/14/15) —
      relu (`Claude.md` §Mémoire de sprint) avant d'écrire le hook

**Outputs produits :**
- [x] `.claude/hooks/pre-compact.sh` — réutilisable dans tout projet bootstrappé
- [x] Extension documentée de `M-PROC-13` (reprise pause = reprise crash)
- [x] Entrée `07-DECISIONS-SDLC.md` (exécuté sur le toolkit) — `M-HOOKS-08`

---

## Critères d'acceptation

- [x] `bash -n .claude/hooks/pre-compact.sh` → exit 0
- [x] Smoke test : `echo '{"session_id":"test","transcript_path":"/tmp/t.jsonl","cwd":".","trigger":"manual"}' | bash .claude/hooks/pre-compact.sh` → exit 0, entrée `CHECKPOINT` ajoutée en tête de `sprint-memory.md` — **schéma corrigé avant exécution, voir §Corrections ajustées vs spec : le champ réel est `compaction_reason`, pas `trigger`**
- [x] Même test avec `"trigger":"auto"` → comportement identique, `trigger` consigné dans l'entrée — idem, testé avec `compaction_reason:"auto"`
- [x] Format de l'entrée `CHECKPOINT` cohérent avec les entrées existantes de `sprint-memory.md` (grep de la convention avant écriture)
- [x] `01-Claude-md-TEMPLATE.md` : note ajoutée sous M-PROC-13 (ou équivalent) précisant que la pause-tranche-horaire suit le même chemin de reprise
- [x] `08-hooks-TEMPLATE.md` : section hook ajoutée au même format que les hooks existants (`[ACTIVER si…]`)
- [x] CHANGELOG mis à jour
- [x] Entrée `M-HOOKS-08` dans `07-DECISIONS-SDLC.md`

---

## Risques

- **Hook bloquant ralentit la compaction perçue par l'utilisateur** : probabilité faible · mitigation : script minimal (lecture stdin + append fichier), timeout court explicite
- **Format `sprint-memory.md` mal respecté → entrée illisible au wrap-up** : probabilité faible · mitigation : grep de la convention existante avant d'écrire le hook (cf. Dépendances)

---

## Pre-mortem

*(non obligatoire — Taille S, mais utile vu la dépendance à un comportement plateforme)*
Si ce sprint échoue, la cause la plus probable est : le hook `PreCompact`
ne se déclenche pas comme attendu dans l'environnement réel (différence
entre la doc et le comportement observé) — à vérifier par smoke test réel
avant de considérer le sprint terminé, pas seulement par lecture de doc.

---

## Handoff Claude Code

**Fichiers — chargement immédiat :**
- Ce fichier (PDR du sprint)
- Format actuel des entrées `sprint-memory.md` (relire M-PROC-13/14/15 dans
  `07-DECISIONS-SDLC.md` ou `01-Claude-md-TEMPLATE.md §Mémoire de sprint`)
- `08-hooks-TEMPLATE.md` (structure existante, pour insérer sans casser le format)

**Fichiers — chargement différé :**
- `.claude/hooks/pre-tool-bash.sh` existant — grep d'abord pour réutiliser
  le style (gestion JSON stdin, conventions de log)

**Données à collecter avant de coder :**
- *(résolu en amont — schéma payload confirmé, voir §Dépendances)*

**Instructions spécifiques :**
- Tester les deux valeurs de `trigger` (`manual` et `auto`), pas seulement une
- Ne pas dupliquer le format `sprint-memory.md` — l'étendre avec un type
  `CHECKPOINT` cohérent avec les types déjà existants (`PIVOT`, `BLOQUANT`,
  `DÉCISION`...)

**Grep de vérification préalable :**
```bash
grep -n "sprint-memory.md" 01-Claude-md-TEMPLATE.md | head -20
grep -n "^### \|^## " 08-hooks-TEMPLATE.md
```

**Init mémoire sprint :**
```bash
echo "# Sprint 23 — precompact-sprint-memory · $(date +%Y-%m-%d)" > .claude/sprint-memory.md
echo "# Spec : specs/Sprints/sprint-SDLC-23-precompact-sprint-memory.md" >> .claude/sprint-memory.md
```

---

## Plan de développement

**Dépendances vérifiées :**
- [x] Format exact des entrées `sprint-memory.md` confirmé par lecture réelle
      (`Claude.md` §Mémoire de sprint, lignes 264-272) : 6 types `[HH:MM] TYPE —
      texte`, pas de type `CHECKPOINT` existant — à ajouter comme 7e type, pas
      une refonte du format
- [x] Style des hooks existants confirmé (`pre-tool-bash.sh`) : `set -euo
      pipefail`, parsing JSON stdin via `python3 -c`, exit codes documentés en
      en-tête, commentaire citant le schéma confirmé empiriquement

**Modules touchés :**
- `.claude/hooks/pre-compact.sh` (nouveau)
- `.claude/settings.json` (nouvelle entrée hook `PreCompact`)
- `01-Claude-md-TEMPLATE.md` §Mémoire de sprint (7e type `CHECKPOINT` documenté
  + note sous M-PROC-13)
- `08-hooks-TEMPLATE.md` (nouvelle section hook, format `[ACTIVER si…]`)

**Risques identifiés :**
- `PreCompact` n'est pas un hook gate (pas de sémantique allow/block comme
  `PreToolUse`) — le script doit toujours `exit 0`, y compris en cas
  d'échec de parsing JSON ou d'écriture, pour ne jamais bloquer une
  compaction (cf. §Contraintes "ne pas bloquer indéfiniment")
- Risque non vérifiable en session sans déclencher une vraie compaction —
  le smoke test (JSON simulé en stdin) valide le script lui-même, pas le
  déclenchement réel par la plateforme ; à noter explicitement au wrap-up
  comme limite de validation (cf. §Pre-mortem)

**Plan d'exécution :**
1. Écrire `.claude/hooks/pre-compact.sh` (lecture stdin, append `CHECKPOINT`,
   toujours `exit 0`)
2. Smoke test avec `trigger=manual` et `trigger=auto`, vérifier non-régression
   sur les entrées existantes de `sprint-memory.md`
3. Ajouter l'entrée `PreCompact` dans `.claude/settings.json`
4. Documenter le 7e type `CHECKPOINT` dans `01-Claude-md-TEMPLATE.md` +
   note sous M-PROC-13
5. Ajouter la section hook dans `08-hooks-TEMPLATE.md`
6. CHANGELOG + `07-DECISIONS-SDLC.md` (M-HOOKS-XX)

**Plan de test :**
- A — Ciblé : `bash -n .claude/hooks/pre-compact.sh && echo '{"session_id":"t","transcript_path":"/tmp/t.jsonl","cwd":".","trigger":"manual"}' | bash .claude/hooks/pre-compact.sh`
- **Volumétrie minimum :** 2 valeurs de `trigger` testées (`manual`, `auto`)
- B — Non-régression : `sprint-memory.md` existant non corrompu après écriture
  (entrées précédentes intactes, nouvelle entrée en tête)

---

## Corrections ajustées vs spec
*(complété au wrap-up — §Étape 3)*

**Schéma PreCompact corrigé avant code.** Le PDR affirmait le champ payload
`trigger: "manual"|"auto"` comme "vérifié... zéro Oracle nécessaire en
session". Vérification directe (`WebFetch code.claude.com/docs/en/hooks`,
citation verbatim) a montré que le champ réel est `compaction_reason`, avec
en plus `context_used_tokens`/`context_limit_tokens`/`estimated_tokens_freed`
(absents du PDR). Le script et l'entrée `CHECKPOINT` ont été écrits contre le
schéma réel dès le départ — aucun code n'a été commité contre le schéma
erroné. Détail complet : `07-DECISIONS-SDLC.md M-HOOKS-08`,
`doc/DIAGNOSTIC_CMDS.md` (symptôme WebFetch contradictoire).
Le champ `async: false` proposé par le PDR pour `settings.json` a été omis,
non corroboré par la doc vérifiée.
