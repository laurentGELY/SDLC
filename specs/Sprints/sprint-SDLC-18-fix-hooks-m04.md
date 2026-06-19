# Sprint SDLC-18 — Fix : garde-fou M-HOOKS-04 + vérification schéma JSON PreToolUse
<!-- Numéro assigné en §Démarrage (4a) : PDR reçu avec XX non assigné volontairement.
     Dernier sprint constaté : SDLC-17 → assigné SDLC-18.
     M-HOOKS-04 confirmé absent de 07-DECISIONS-SDLC.md (seules M-HOOKS-01→03 existent)
     et absent de .claude/hooks/pre-tool-bash.sh (le fichier réel, distinct du template
     08-hooks-TEMPLATE.md) → branche prévue par le PDR : "ce PDR s'applique comme
     correction avant premier commit". -->

**Type :** Fix
**Taille :** S *(peut basculer en M si l'étape 0 confirme un schéma JSON erroné sur l'ensemble du
script — signaler via HALT-SCOPE avant d'étendre, ne pas trancher seul)*
**Surface :** `.claude/hooks/pre-tool-bash.sh` (fichier réel du projet, copie adaptée de
`08-hooks-TEMPLATE.md`) — lecture seule sur `07-DECISIONS-SDLC.md` (nouvelle entrée M-HOOKS-04 à
créer, ce sprint l'introduit — elle n'existe pas encore)
**Risque :** Moyen-Élevé *(pas Faible : si l'étape 0 confirme le schéma erroné, ça touche la
totalité du mécanisme de sécurité existant — `git push --force`, `rm -rf` — pas seulement le
nouveau bloc M-HOOKS-04)*

---

## Contexte

Deux problèmes distincts, découverts pendant une revue critique de M-HOOKS-04 (garde-fou
mécanique sur l'omission de l'étape 4a, conçu en session Claude.ai dédiée — pas encore implémenté
dans ce repo), touchant le même fichier :

1. **Bug de conception M-HOOKS-04** : le matcher `Bash|Edit|Write` bloque toute commande dès que
   `sprint-memory.md` référence un spec absent — y compris le `Write` qui créerait ce spec, seule
   action de récupération proposée par le message d'erreur lui-même. Auto-verrouillage : aucun
   outil couvert par le matcher ne peut sortir de l'état bloqué.

2. **Doute sur le schéma JSON d'entrée** (antérieur à M-HOOKS-04, potentiellement plus grave) :
   le script extrait la commande via `data.get('input', {}).get('command', '')`, avec un
   commentaire `{"tool":"bash","input":{"command":"..."}}`. La documentation actuelle des hooks
   Claude Code décrit un schéma `tool_name` + `tool_input.command`. Le smoke test existant ne
   teste qu'une commande inoffensive (`echo ok`) — il ne peut pas détecter si l'extraction d'une
   commande réellement dangereuse échoue silencieusement. Non vérifié empiriquement à ce jour.

Le point 2 doit être tranché avant d'écrire quoi que ce soit sur le point 1 : le carve-out
Write/Edit dépend du même mécanisme d'extraction (`tool_input.file_path` ou `input.file_path`,
selon ce que confirme la vérification).

---

## Objectif

Le script `pre-tool-bash.sh` extrait les champs réels envoyés par l'installation Claude Code du
projet (vérifié empiriquement, pas supposé depuis un commentaire de 2026-05-30) ; la règle
M-HOOKS-04 ne peut plus se bloquer elle-même ; son parsing résiste à un `sprint-memory.md` au
format légèrement dégradé ; son cas nominal (spec existant) est couvert par un test exécutable.

---

## Comportement actuel → cible

- **Actuel :** schéma d'extraction non vérifié contre le format réel ; smoke test existant
  incapable de détecter une extraction cassée (teste uniquement le cas "rien à bloquer") ;
  M-HOOKS-04 (conçu, pas implémenté) bloquerait irrémédiablement toute commande Bash/Edit/Write
  dès que sa condition se déclenche, y compris la commande de récupération qu'il recommande
  lui-même.
- **Cible :** le nom exact des champs JSON (Bash : commande ; Edit/Write : chemin de fichier) est
  confirmé par capture réelle, pas par documentation tierce. L'extraction du script (existante et
  nouvelle) utilise ce schéma confirmé. Un `Write`/`Edit` ciblant `specs/Sprints/*.md` n'est
  jamais bloqué par M-HOOKS-04, quel que soit l'état de `sprint-memory.md`.

---

## Portée

**Inclus :**
- Étape 0 (Handoff) : capture empirique du JSON réel reçu par un hook `PreToolUse` sur cette
  installation, pour `Bash` et pour `Edit`/`Write`
- Correction de l'extraction dans `pre-tool-bash.sh` si l'étape 0 révèle un écart vs schéma actuel
- Carve-out M-HOOKS-04 : `Write`/`Edit` ciblant `SPEC_PATH` ou tout chemin sous `specs/Sprints/`
  exempté du blocage
- Parsing `SPEC_PATH` tolérant au format (chercher la ligne `# Spec : ` n'importe où dans le
  fichier plutôt que de figer sur la ligne 2)
- Nouveau smoke test positif (spec existant → ne bloque pas) et test du carve-out (Write sur le
  spec manquant lui-même → ne bloque pas)
- Smoke test de non-régression sur les blocages `[UNIVERSEL]` préexistants (`git push --force`,
  `rm -rf`), avec une commande qui *devrait* être bloquée — pas seulement une commande inoffensive
- Amendement de l'entrée `M-HOOKS-04` dans `07-DECISIONS-SDLC.md` ; nouvelle entrée séparée si
  l'étape 0 confirme le bug d'extraction (root cause distincte de M-HOOKS-04, à documenter à part)

**Exclu (explicitement) :**
- SDLC_CANDIDATE #1/#2/#3 (hook SessionStart, tables HALT, anti-complaisance) — sprint Doc séparé,
  déjà en file d'attente
- Allowlist Bash en lecture seule pendant un blocage M-HOOKS-04 (git status/diff/ls/cat) —
  amélioration de confort, pas un correctif ; `[HOOK_CANDIDATE]` séparé si jamais observé gênant
- Toute modification du texte de `01-Claude-md-TEMPLATE.md` (séquence 4a→4d) — ce sprint touche
  l'enforcement, pas la règle elle-même
- Fail-closed sur parsing totalement absent — comportement actuel (fail-open) conservé ; noter
  l'option en `DECISIONS.md` sans l'implémenter, faute d'incident réel l'ayant justifié

---

## Option retenue — alternatives écartées

**Retenue :** vérification empirique du schéma JSON en premier (capture réelle), puis correction
de l'extraction si nécessaire, puis carve-out ciblé dans le script existant (un seul point de
vérité), puis durcissement du parsing par recherche de motif plutôt que position de ligne fixe.

**Écartée(s) :**
- *Faire confiance à la documentation tierce sans vérification* — écarté : c'est exactement le
  mode d'échec qui a produit le bug initial (un commentaire de script jamais vérifié contre le
  comportement réel). Re-suivre l'incident plutôt que le corriger.
- *Restreindre le matcher M-HOOKS-04 à `Bash` seul pour éviter le problème* — écarté : annulerait
  la couverture Edit/Write que l'élargissement visait précisément à apporter.
- *Script de carve-out séparé* — écarté : un seul `pre-tool-bash.sh` reste plus simple à auditer ;
  le carve-out est une condition supplémentaire dans le bloc existant.

**Sacrifices délibérés :** si l'étape 0 révèle que `git push --force`/`rm -rf` ont toujours été
silencieusement inopérants, ce sprint corrige l'extraction mais ne refait pas l'inventaire complet
de toutes les règles `[ACTIVER si…]` commentées qui pourraient avoir le même défaut latent —
seules les règles actives (`[UNIVERSEL]`) sont revalidées ici. Un audit complet des sections
commentées serait un sprint Doc séparé si le besoin se confirme.

---

## Contraintes techniques / produit

- Bash + `python3` uniquement, zéro nouvelle dépendance (`jq` n'est pas confirmé disponible —
  rester sur le pattern python3 déjà en place dans le script si l'extraction doit changer)
- Le carve-out doit couvrir `Write`, `Edit`, et `MultiEdit` si ce dernier est confirmé comme outil
  distinct à l'étape 0
- Modification par script `sed`/patch exécutable avec grep de validation finale, conforme à la
  règle `Claude.md` "Modifications spot sur fichiers existants"
- Toute correction de schéma JSON doit être accompagnée d'un smoke test qui aurait échoué sous
  l'ancien comportement — pas seulement d'un test qui passe sous le nouveau

**Interdit :**
- Modifier le texte des Règles absolues / HALT dans `01-Claude-md-TEMPLATE.md`
- Introduire `jq` ou toute dépendance non confirmée présente sans le documenter comme tel
- Déclarer le sprint terminé sans le smoke test de non-régression sur `git push --force`/`rm -rf`
  exécuté avec succès (pas seulement écrit)

---

## Dépendances

**Inputs requis :**
- [x] État réel de `.claude/hooks/pre-tool-bash.sh` chez vous — résultat : fichier existant,
      M-HOOKS-04 absent (seuls les blocages `[UNIVERSEL]` git push --force / rm -rf sont présents,
      hérités de SDLC-14 self-bootstrap). `08-hooks-TEMPLATE.md` (le template générique) ne contient
      pas non plus M-HOOKS-04. Ce PDR s'applique donc comme conception + implémentation directe,
      pas comme correction d'un bloc existant.
- [x] Version Claude Code installée — résultat : `2.1.183 (Claude Code)`

**Outputs produits :**
- [x] `.claude/hooks/pre-tool-bash.sh` — extraction corrigée + bloc M-HOOKS-04
      (carve-out inclus dès la conception, corrigé en cours de sprint — chemin absolu) + parsing
      tolérant + 4 smoke tests
- [x] `07-DECISIONS-SDLC.md` — entrées M-HOOKS-04 (carve-out) et M-HOOKS-05 (extraction JSON)
- [x] `CHANGELOG.md`

---

## Critères d'acceptation

- [x] Capture empirique du JSON réel (Bash et Edit/Write) produite et consignée dans
      `sprint-memory.md` avant toute modification de fichier
- [x] Écart confirmé vs schéma actuel : extraction corrigée dans tout le script (une seule
      extraction CMD partagée par les deux blocs `[UNIVERSEL]`)
- [x] Smoke test non-régression : `git push --force` effectivement bloqué avec le schéma confirmé
      — exit 2 (confirmé deux fois : test A1 dédié + blocage accidentel d'une vraie commande)
- [x] Smoke test négatif M-HOOKS-04 : spec absent → exit 2
- [x] Nouveau smoke test positif M-HOOKS-04 : spec référencé existe → exit 0
- [x] Nouveau smoke test carve-out : spec absent, `Write` sur ce chemin (absolu) → exit 0
- [x] Parsing résiste à un `sprint-memory.md` où la ligne `# Spec : ` n'est pas en ligne 2 exacte
      (`grep -m1` sans contrainte de position)
- [x] `grep "\[ACTIVER" .claude/hooks/pre-tool-bash.sh` → zéro résultat
- [x] `07-DECISIONS-SDLC.md` : entrées M-HOOKS-04 + M-HOOKS-05 créées, cross-référence
      SDLC_CANDIDATE #1 ajoutée (origine commune incident, `doc/AUDIT-EXTERNE-superpowers-vs-sdlc.md §8`)
- [x] CHANGELOG mis à jour

```bash
# Test A — non-régression sur règle universelle préexistante (à adapter au schéma confirmé)
echo '<JSON réel confirmé à l'étape 0, command: "git push --force origin main">' \
  | bash .claude/hooks/pre-tool-bash.sh
echo "exit attendu : 2"

# Test A — carve-out M-HOOKS-04
mkdir -p .claude specs/Sprints && \
  printf '# Sprint test\n# Spec : specs/Sprints/sprint-test.md\n' > .claude/sprint-memory.md
echo '<JSON réel confirmé, tool=Write/Edit, file_path: "specs/Sprints/sprint-test.md">' \
  | bash .claude/hooks/pre-tool-bash.sh
echo "exit attendu : 0"
rm -f .claude/sprint-memory.md
```

---

## Risques

- **Schéma JSON différent de ce que documentent les sources externes consultées** : probabilité
  moyenne (sources cohérentes entre elles mais aucune n'est l'installation réelle du projet) ·
  mitigation : étape 0 empirique avant toute écriture de code
- **Le bug d'extraction, s'il est confirmé, dépasse le périmètre de ce Fix** (toutes les règles
  `[ACTIVER si…]` commentées pourraient être affectées) : probabilité faible-moyenne · mitigation :
  HALT-SCOPE explicite, signaler avant d'étendre, ne pas auditer les sections commentées dans ce
  sprint
- **Carve-out trop permissif** (tout `Write` sous `specs/Sprints/*` passe sans autre vérification) :
  probabilité faible, impact faible — accepté sans mitigation supplémentaire, ce répertoire n'est
  pas sensible

---

## Pre-mortem *(volontaire — taille S, mais fichier partagé critique : tout sprint futur en dépend)*

> Si ce sprint échoue, la cause la plus probable est d'écrire le carve-out sur la base du schéma
> JSON documenté par des sources externes sans l'avoir vérifié empiriquement contre l'installation
> réelle — répétant exactement l'erreur qui a (probablement) rendu `$CMD` vide depuis le début.
> Mitigation : l'étape 0 du Handoff est une capture réelle, pas une lecture de doc — aucune ligne
> de carve-out n'est écrite avant que cette capture soit produite et collée dans `sprint-memory.md`.

---

## Handoff Claude Code

**Étape 0 — avant tout chargement de fichier, capture empirique obligatoire :** exécutée en
§Démarrage, résultat consigné dans `.claude/sprint-memory.md`.

**Fichiers — chargement immédiat (après étape 0) :**
- `.claude/hooks/pre-tool-bash.sh` (fichier réel, lu en entier — `08-hooks-TEMPLATE.md` également
  lu pour référence du template générique)
- `07-DECISIONS-SDLC.md` — section M-HOOKS (M-HOOKS-01→03 existantes, M-HOOKS-04 absente)

**Fichiers — chargement différé :** aucun — périmètre limité à un seul fichier technique.

**Instructions spécifiques :**
- Ne rien patcher avant que l'étape 0 soit terminée et consignée
- Si le schéma confirmé diverge de `data.get('input', {})` : corriger l'extraction existante
  (commande Bash) en même temps que d'écrire l'extraction du carve-out (chemin Edit/Write) — même
  cause racine, même commit
- Si le schéma confirmé correspond à `input`/`command` tel quel (hypothèse du script d'origine
  validée) : ignorer la branche correctif d'extraction, ne traiter que le carve-out M-HOOKS-04 et
  le parsing tolérant — ne pas introduire de changement sur du code qui s'avère déjà correct

---

## Plan de développement
*(produit par Claude Code après analyse — étape 4d, avant toute écriture du livrable)*

**Dépendances vérifiées :**
- [x] Schéma JSON réel confirmé (étape 0) — résultat : enveloppe `PreToolUse` réelle =
      `tool_name` + `tool_input.{command|file_path}` (PAS `tool`/`input` supposé par le script).
      Capturé empiriquement sans restart : (1) instrumentation temporaire du hook Bash déjà actif
      → `tool_name:"Bash"`, `tool_input.command` ; (2) grep du transcript de session réel →
      blocs `tool_use` `"name":"Edit"`/`"name":"Write"` avec paramètre `file_path`. 2 sources
      convergentes, [CONF: HAUTE]. `MultiEdit` non observé cette session — limite connue, non
      bloquante (carve-out couvre Bash|Edit|Write, périmètre du PDR).
- [x] État M-HOOKS-04 — résultat : absent, ce PDR l'introduit directement avec le carve-out inclus
- [x] Bug d'extraction — CONFIRMÉ : `data.get('input', {})` sur un payload sans clé `input`
      retourne toujours `{}` → `$CMD` a toujours été vide depuis l'origine (SDLC-14). Les blocages
      `[UNIVERSEL]` (`git push --force`, `rm -rf`) n'ont jamais pu matcher quoi que ce soit.

**Modules touchés :** `.claude/hooks/pre-tool-bash.sh` — module partagé par tout sprint futur,
niveau B obligatoire (non-régression sur les règles `[UNIVERSEL]` préexistantes). Une seule
extraction `CMD` corrigée répare les deux blocs `[UNIVERSEL]` à la fois (pas de dispersion du bug
sur plusieurs points d'extraction) → Taille reste **S**, pas de bascule M.

**Risques identifiés :** cf. §Risques ci-dessus — aucun nouveau depuis l'Analyse.

**Plan d'exécution :**
1. Corriger l'extraction : `data.get('input', {})` → `data.get('tool_input', {})` pour Bash
   (`command`). Variable `TOOL` ajoutée : `data.get('tool_name', '')`.
2. Extraire `FILE_PATH` pour Edit/Write : `data.get('tool_input', {}).get('file_path', '')`.
3. Ajouter bloc M-HOOKS-04 : si `.claude/sprint-memory.md` existe, extraire `SPEC_PATH` (grep
   tolérant — ligne contenant `# Spec : ` n'importe où dans le fichier, pas figé ligne 2) ; si
   `SPEC_PATH` non vide et fichier absent sur disque :
   - carve-out : si `TOOL` est `Write`/`Edit` ET `FILE_PATH` == `SPEC_PATH` OU sous
     `specs/Sprints/` → exit 0 (laisser passer, c'est l'action de récupération)
   - sinon → exit 2 avec message demandant de créer le spec avant de continuer
4. Mettre à jour le commentaire d'en-tête du script (schéma JSON réel documenté, plus le faux
   schéma de 2026-05-30).
5. Écrire les 4 smoke tests (non-régression, positif, négatif, carve-out) + les exécuter.
6. `07-DECISIONS-SDLC.md` : nouvelle entrée M-HOOKS-04 (carve-out dès l'origine) + entrée séparée
   pour le bug d'extraction (root cause distincte, antérieure, SDLC-14).
7. `CHANGELOG.md`.

**Plan de test :**
- A — Ciblé : voir §Critères d'acceptation (4 smoke tests)
- B — Non-régression : `git push --force`/`rm -rf` toujours bloqués avec le schéma confirmé
  (c'est le test qui aurait échoué silencieusement sous l'ancien comportement — exigé par le PDR)

---

## Corrections ajustées vs spec
*(complété au wrap-up — §Étape 3)*

1. **`settings.json` pas "déjà élargi"** — le PDR original mentionnait en §Surface
   "`settings.json` déjà élargi" ; vérifié faux (matcher encore `Bash` seul). Élargi à
   `Bash|Edit|Write` ce sprint, valeur précédente notée avant modification.
2. **Méthode Étape 0 du Handoff (hook temporaire via `settings.local.json`) non
   fonctionnelle** — confirmé empiriquement que les hooks ne sont pas relus à chaud en
   cours de session (claude 2.1.183). Contournement : instrumentation temporaire du hook
   `Bash` déjà actif + grep du transcript de session pour Edit/Write — schéma confirmé
   sans restart, avec le même niveau de preuve empirique que prévu par le PDR.
3. **Bug non anticipé par le PDR, découvert en cours d'implémentation** : le carve-out
   M-HOOKS-04 comparait un `file_path` absolu à un `SPEC_PATH` relatif (jamais de match)
   — combiné à l'absence totale de carve-out pour `Bash` (exclu du PDR), la session s'est
   auto-verrouillée sur Bash/Edit/Write pendant ~40 minutes. Débloquée par suppression
   manuelle de `.claude/sprint-memory.md` par l'utilisateur hors session Claude Code (seul
   recours disponible), puis corrigée (comparaison en suffixe absolu) et revalidée par les
   4 smoke tests avant tout commit. Détail complet : `07-DECISIONS-SDLC.md §M-HOOKS-04`.
4. **Perte accidentelle de `.claude/sprint-memory.md`** pendant les tests A3/A4 (écrasé
   par le contenu de test avant que sa propre sauvegarde n'ait pu s'exécuter, elle-même
   bloquée par le même incident) — reconstruit fidèlement depuis le contenu déjà écrit
   dans la conversation, signalé `[RECONSTRUIT]`, conforme à `Claude.md §Mémoire de sprint`.
5. **Entrée séparée créée** : `07-DECISIONS-SDLC.md` contient deux entrées distinctes
   (M-HOOKS-04 carve-out, M-HOOKS-05 extraction JSON) plutôt qu'une seule — conforme à la
   branche prévue par le PDR ("root cause distincte, antérieure").
6. **Scope explicitement élargi par l'utilisateur après l'incident** (HALT-SCOPE levé par
   validation explicite, pas une décision prise seul) — 3 ajouts hors §Portée/§Exclu d'origine,
   tous documentés en `07-DECISIONS-SDLC.md` :
   - Allowlist Bash lecture seule pendant blocage M-HOOKS-04 (§Exclu d'origine du PDR,
     "amélioration de confort, pas un correctif" — réintégrée après que l'incident a confirmé
     le besoin comme réel, pas hypothétique) → `M-HOOKS-06`
   - Message d'erreur M-HOOKS-04 enrichi avec procédure de secours hors session
   - Règle d'isolation pour tester un hook bloquant, documentée dans
     `08-hooks-TEMPLATE.md` (nouveau §, pas seulement ce projet — pertinent pour tout
     projet cible du modèle SDLC) → `M-PROC-30`
   - Découverte additionnelle pendant ce travail : piège `cd` persistant entre appels d'outil
     (cwd non scopé), documenté dans `M-PROC-30`, non corrigé (résolution de chemin absolu
     dans le hook — hors des 3 solutions validées, `[HOOK_CANDIDATE]` différé)

Aucune autre divergence — portée, gabarit du livrable et critères d'acceptation exécutés
tels que reçus après ces corrections, y compris le scope élargi.
