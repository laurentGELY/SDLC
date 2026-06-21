# Hooks Claude Code — Template Python · v1.0
<!-- Template SDLC v1.3 · Destination : .claude/hooks/ dans le repo cible -->
<!-- Généré au bootstrap · Complété au fil des sprints via boucle LESSONS_LEARNED -->

> Les hooks rendent certaines règles non-négociables — indépendamment de la mémoire du modèle.
> Ce template est Python-first. Les sections marquées `# [ACTIVER si…]` sont désactivées par défaut.
> Règle d'or : n'activer une section que si elle correspond à une contrainte réelle du projet,
> pas par précaution théorique.

---

## Arborescence attendue

```
.claude/
├── hooks/
│   └── pre-tool-bash.sh      # Hook PreToolUse Bash — copier et adapter
├── settings.json             # Déclare le hook — copier tel quel
└── settings.local.json       # Permissions allow locales — créer vide, compléter au fil de l'eau
```

---

## 1. `.claude/hooks/pre-tool-bash.sh`

Copier dans le projet cible, puis activer les sections pertinentes.
Grep de validation post-adaptation : `grep "\[ACTIVER" .claude/hooks/pre-tool-bash.sh`
→ zéro résultat attendu si toutes les décisions sont prises.

```bash
#!/bin/bash
# Hook pre-tool-bash — [Nom du projet]
# Version : 1.0.0 | [AAAA-MM-JJ] | [Nom du projet]
# Déclenché avant toute commande Bash par Claude Code.
# Bloque les commandes incompatibles avec les contraintes du projet.
# Émet des avertissements (non bloquants) sur les commandes à risque.
#
# Protocole Claude Code :
#   exit 0  = autoriser
#   exit 1  = bloquer (silencieux)
#   exit 2  = bloquer avec message d'erreur affiché dans Claude Code
#
# Le JSON d'entrée arrive sur stdin : {"tool":"bash","input":{"command":"..."}}
# Historique des règles : doc/DECISIONS.md §D-HOOK-XX

set -euo pipefail

# Lire la commande depuis stdin (JSON Claude Code)
INPUT=$(cat)
CMD=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('input', {}).get('command', ''))
" 2>/dev/null || echo "")

# ─── BLOCAGES STRICTS ────────────────────────────────────────────────────────
# Chaque blocage doit avoir une entrée dans doc/DECISIONS.md (préfixe D-HOOK-XX)

# [UNIVERSEL] git push --force — destructif sur l'historique partagé
if echo "$CMD" | grep -qE 'git\s+push.*(--force|-f)\s'; then
  echo "BLOQUÉ : git push --force interdit." >&2
  echo "Utiliser git revert pour annuler un commit déjà poussé." >&2
  exit 2
fi

# [UNIVERSEL] rm -rf sur racine projet ou dossiers critiques
if echo "$CMD" | grep -qE 'rm\s+-rf\s+(/|\./)?(\.git|src|data|db|scripts)\b'; then
  echo "BLOQUÉ : rm -rf sur dossier critique détecté." >&2
  echo "Supprimer les fichiers individuellement ou demander confirmation." >&2
  exit 2
fi

# [ACTIVER si politique apt-first] pip install --break-system-packages
# Décommenter si le projet interdit pip système au profit de apt/venv.
# → Documenter dans DECISIONS.md §D-HOOK-01
#
# if echo "$CMD" | grep -qE 'pip(3)?\s+install.*--break-system-packages'; then
#   echo "BLOQUÉ : pip install --break-system-packages interdit dans ce projet." >&2
#   echo "Ordre d'installation : apt → snap → venv (documenter si venv nécessaire)." >&2
#   exit 2
# fi

# [ACTIVER si politique venv obligatoire] pip install hors venv
# Décommenter si tout pip install doit se faire dans un venv activé.
# → Documenter dans DECISIONS.md §D-HOOK-02
#
# if echo "$CMD" | grep -qE 'pip(3)?\s+install\s+[^-]'; then
#   if [ -z "${VIRTUAL_ENV:-}" ]; then
#     echo "BLOQUÉ : pip install hors venv détecté." >&2
#     echo "Activer le venv du projet avant d'installer des dépendances." >&2
#     exit 2
#   fi
# fi

# [ACTIVER si projet Python pur] npm/yarn — non utilisés
# Décommenter si le projet est Python uniquement et npm/yarn ne doivent jamais être appelés.
# → Documenter dans DECISIONS.md §D-HOOK-03
#
# if echo "$CMD" | grep -qE '(npm|yarn)\s+(install|add|ci)'; then
#   echo "BLOQUÉ : npm/yarn ne sont pas utilisés dans ce projet Python." >&2
#   exit 2
# fi

# [ACTIVER si fichiers de données critiques] écriture directe hors pipeline
# Décommenter et adapter le pattern si certains fichiers ne doivent être écrits
# que par le script principal (ex : jsonl de production, bases sqlite).
# → Documenter dans DECISIONS.md §D-HOOK-04
#
# FICHIERS_PROTEGES="(nom_fichier_1|nom_fichier_2)\.(jsonl|sqlite)"
# if echo "$CMD" | grep -qE "$FICHIERS_PROTEGES" && \
#    ! echo "$CMD" | grep -q 'dry.run'; then
#   echo "BLOQUÉ : écriture directe dans fichier de données protégé détectée." >&2
#   echo "Ces fichiers ne sont écrits que par le pipeline principal." >&2
#   exit 2
# fi

# ─── AVERTISSEMENTS NON BLOQUANTS ────────────────────────────────────────────
# Ces règles émettent un rappel sans interrompre l'exécution.

# [UNIVERSEL] sudo hors apt/snap/systemctl — risque système
if echo "$CMD" | grep -qE '^sudo\s+' && \
   ! echo "$CMD" | grep -qE 'sudo\s+(apt|snap|systemctl)'; then
  echo "AVERTISSEMENT : commande sudo hors apt/snap détectée." >&2
  echo "Vérifier que cette commande est nécessaire et documentée." >&2
fi

# [ACTIVER si fichier .env présent] accès direct aux secrets
# Décommenter si le projet a un .env contenant des secrets (API keys, tokens).
# → Documenter dans DECISIONS.md §D-HOOK-05
#
# if echo "$CMD" | grep -qE '(cat|echo|tee|nano|vim|sed)\s+\.env([^.]|$)'; then
#   echo "AVERTISSEMENT : accès direct à .env détecté." >&2
#   echo "Ne jamais afficher le contenu de .env dans les logs ou sorties partagées." >&2
# fi

# [ACTIVER si fichier config critique] modification directe de config sans sauvegarde
# Adapter le nom du fichier de config principal du projet.
# → Documenter dans DECISIONS.md §D-HOOK-06
#
# FICHIER_CONFIG="config.yaml"  # [→ ADAPTER] nom du fichier de config principal
# if echo "$CMD" | grep -qE "(sed|echo|tee).*${FICHIER_CONFIG}"; then
#   echo "AVERTISSEMENT : modification directe de ${FICHIER_CONFIG} détectée." >&2
#   echo "Règle Claude.md : noter la valeur précédente avant modification." >&2
# fi

exit 0
```

---

## 2. `.claude/settings.json`

Copier tel quel — déclare le hook PreToolUse sur Bash.
Ne pas modifier sauf ajout d'un PostToolUse (voir §PostToolUse ci-dessous).

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/pre-tool-bash.sh"
          }
        ]
      }
    ]
  }
}
```

---

## 3. `.claude/settings.local.json`

Créer vide au bootstrap. Les entrées `allow` s'accumulent au fil des sessions
quand Claude Code demande confirmation pour une commande récurrente légitime.
Ne pas versionner si les chemins contiennent des chemins absolus personnels.

```json
{
  "permissions": {
    "allow": [
      // Compléter au fil des sessions — ex :
      // "Bash(python3 *)",
      // "Bash(git status)",
      // "Bash(pytest tests/ -q)"
    ]
  }
}
```

---

## §PostToolUse — optionnel, à activer consciemment

Un hook PostToolUse (lint/format automatique après écriture) est rentable
si le projet a un formatter configuré et des tests rapides (< 5s).

À ne pas activer par défaut — un test lent déclenché à chaque Edit ralentit
significativement le workflow. Décider au sprint 1 ou 2 une fois la stack stabilisée.

Si activé → ajouter dans `settings.json` :

```json
"PostToolUse": [
  {
    "matcher": "Edit|Write",
    "hooks": [
      {
        "type": "command",
        "command": "ruff format \"${tool_input_file}\" 2>/dev/null || true"
      },
      {
        "type": "command",
        "command": "ruff check \"${tool_input_file}\" --fix 2>/dev/null || true"
      }
    ]
  }
]
```

→ Documenter la décision dans `doc/DECISIONS.md` §D-HOOK-07.

---

## §PreCompact — optionnel, à activer consciemment

Un hook `PreCompact` est rentable si le projet utilise `sprint-memory.md`
(`M-PROC-10/13`) et veut que la reprise après une pause forcée (tranche
horaire) ou une compaction automatique suive le même chemin que la reprise
après crash, sans discipline manuelle pour amorcer la trace.

**Schéma JSON reçu sur stdin** (confirmé verbatim `code.claude.com/docs/en/hooks`,
Sprint SDLC-23 — **PAS** un champ `trigger` comme une première lecture rapide
de la doc le suggère) :
```json
{"session_id":"...","transcript_path":"...","cwd":"...","hook_event_name":"PreCompact",
 "permission_mode":"...","compaction_reason":"manual"|"auto","context_used_tokens":N,
 "context_limit_tokens":N,"estimated_tokens_freed":N}
```
`matcher` filtre sur `compaction_reason` (`manual`/`auto`) — pas de valeur par
défaut documentée pour un hook sans matcher : enregistrer explicitement les
deux plutôt que de supposer qu'omettre `matcher` couvre les deux cas.

Copier `.claude/hooks/pre-compact.sh` — toujours `exit 0`, ce hook n'est pas un
gate (pas de sémantique allow/block utilisée ici, même si `PreCompact`
supporte techniquement `{"decision":"block"}`). Référence : projet toolkit
SDLC, `07-DECISIONS-SDLC.md M-HOOKS-08`.

```bash
#!/bin/bash
# Hook pre-compact — adapter le nom de projet en commentaire si besoin
# Déclenché par Claude Code avant toute compaction (manuelle ou automatique).
# Écrit un checkpoint dans .claude/sprint-memory.md pour que la reprise après
# une pause forcée par tranche horaire suive le même chemin que la reprise
# après crash (M-PROC-13).
#
# Schéma JSON réel reçu sur stdin (PreCompact) — confirmé verbatim
# code.claude.com/docs/en/hooks (PAS un champ "trigger" comme une lecture
# rapide de la doc le suggère) :
#   {"session_id":"...","transcript_path":"...","cwd":"...","hook_event_name":"PreCompact",
#    "permission_mode":"...","compaction_reason":"manual"|"auto","context_used_tokens":N,
#    "context_limit_tokens":N,"estimated_tokens_freed":N}
#
# PreCompact peut bloquer via {"decision":"block"} mais ce script ne l'utilise jamais —
# toujours exit 0, y compris en cas d'échec de parsing JSON ou d'écriture fichier.

set -uo pipefail  # pas -e : un échec partiel ne doit jamais empêcher le exit 0 final

INPUT=$(cat)
read -r REASON USED LIMIT FREED TRANSCRIPT <<< "$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('compaction_reason', 'unknown'),
      data.get('context_used_tokens', '?'),
      data.get('context_limit_tokens', '?'),
      data.get('estimated_tokens_freed', '?'),
      data.get('transcript_path', '-'))
" 2>/dev/null || echo "unknown ? ? ? -")"

MEMORY_FILE=".claude/sprint-memory.md"

# Rien à checkpointer si aucun sprint actif (fichier absent) — ne pas en créer un.
if [ -f "$MEMORY_FILE" ]; then
  TIMESTAMP=$(date +%H:%M)
  ENTRY="[$TIMESTAMP] CHECKPOINT — compaction reason=$REASON — tokens ${USED}/${LIMIT} (≈${FREED} libérés) — transcript : \`$TRANSCRIPT\`"
  # Entrée la plus récente en tête, juste sous le header 2 lignes (cohérent
  # avec le format accumulatif déjà utilisé pour SESSION_BRIDGE.md, M-PROC-22).
  HEADER=$(head -2 "$MEMORY_FILE" 2>/dev/null)
  REST=$(tail -n +3 "$MEMORY_FILE" 2>/dev/null)
  { printf '%s\n' "$HEADER" "$ENTRY" "$REST"; } > "${MEMORY_FILE}.tmp" 2>/dev/null \
    && mv "${MEMORY_FILE}.tmp" "$MEMORY_FILE" 2>/dev/null
fi

exit 0
```

Si activé → ajouter dans `settings.json` :

```json
"PreCompact": [
  {
    "matcher": "manual",
    "hooks": [{ "type": "command", "command": ".claude/hooks/pre-compact.sh" }]
  },
  {
    "matcher": "auto",
    "hooks": [{ "type": "command", "command": ".claude/hooks/pre-compact.sh" }]
  }
]
```

→ Documenter la décision dans `doc/DECISIONS.md` §D-HOOK-XX.

---

## §Boucle de rétroaction — comment les règles évoluent

Les hooks ne sont pas figés au bootstrap. Le modèle de rétroaction est :

```
Incident ou hésitation en session
         ↓
Entrée LESSONS_LEARNED avec tag [HOOK_CANDIDATE] + ligne bash proposée
         ↓
/retrospective détecte ≥ 2 occurrences ou 1 incident grave
         ↓
Décision humaine explicite → décommenter/ajouter section dans pre-tool-bash.sh
         ↓
Entrée doc/DECISIONS.md §D-HOOK-XX + commit
```

**Règle** : ne jamais ajouter une règle dans le hook sans entrée DECISIONS.md correspondante.
Le hook est la conséquence d'une décision documentée, pas une précaution implicite.

---

## §Test d'un hook bloquant — isolation obligatoire

**Règle :** tout test d'un comportement *bloquant* d'un hook `PreToolUse` (un cas qui doit
produire `exit 2`) s'exécute dans un environnement isolé — jamais en manipulant l'état réel
de la session courante (le fichier que le hook lit pour décider de bloquer ou non).

**Pourquoi :** un hook `PreToolUse` actif gate aussi bien les commandes de test délibérées que
les vrais appels d'outil de la session. Si le mécanisme testé contient un bug, manipuler l'état
réel pour déclencher le cas "doit bloquer" peut bloquer la session elle-même, sans aucune
garantie qu'un outil reste disponible pour corriger le bug (cf. incident documenté,
`07-DECISIONS-SDLC.md M-HOOKS-04`, Sprint SDLC-18 — auto-verrouillage réel de ~40 minutes,
débloqué uniquement par intervention humaine hors session).

**Méthode :**
```bash
mkdir -p /tmp/hook-test-isolated/.claude/hooks
cp .claude/hooks/pre-tool-bash.sh /tmp/hook-test-isolated/.claude/hooks/
# Construire les fixtures (sprint-memory.md, fichiers spec, etc.) dans /tmp/hook-test-isolated/
# Invoquer le hook via un SOUS-SHELL — pas un `cd` nu, qui persiste entre appels d'outil et
# peut faire lire au hook réel (gating la session courante) les fixtures de test au lieu de
# l'état réel du projet :
( cd /tmp/hook-test-isolated && cat fixture.json | bash .claude/hooks/pre-tool-bash.sh )
# Nettoyage après usage :
rm -rf /tmp/hook-test-isolated
```

**Piège connu :** un `cd` exécuté sans sous-shell persiste pour les appels d'outil suivants de
la session — le hook réel (qui gate ces appels suivants) peut alors résoudre ses propres
chemins relatifs contre ce mauvais répertoire et déclencher un faux blocage. Toujours utiliser
`( cd ... && ... )` pour les tests d'isolation, jamais `cd ...` suivi d'une commande séparée.

---

## §Critères d'acceptation bootstrap hooks

- [ ] `pre-tool-bash.sh` : chmod +x, zéro section `[ACTIVER` non décidée
- [ ] `settings.json` : hook PreToolUse Bash déclaré
- [ ] `settings.local.json` : fichier créé (vide ou avec premières permissions)
- [ ] Grep de validation : `grep "\[ACTIVER" .claude/hooks/pre-tool-bash.sh` → zéro résultat
- [ ] Test smoke : `echo '{"tool":"bash","input":{"command":"echo ok"}}' | bash .claude/hooks/pre-tool-bash.sh` → exit 0

---

## 4. Confinement natif — sandbox OS (bubblewrap/Seatbelt)

À activer quand le besoin dépasse la portée de `pre-tool-bash.sh` : confiner
*toutes* les opérations (Bash **et** outils natifs `Read`/`Edit`/`Write`) à un
périmètre filesystem précis, avec garantie au niveau OS plutôt qu'un
pattern-matching contournable. Référence : `07-DECISIONS-SDLC.md §M-HOOKS-07`.

**Ne remplace pas `pre-tool-bash.sh`** — complémentaire. Le hook reste la
couche sémantique (règles métier sur le *contenu* d'une commande, ex :
`git push --force`), le sandbox devient la couche de confinement (règles sur
les *chemins/domaines* atteignables). Le sandbox ne comprend pas la
sémantique d'une commande ; le hook ne garantit rien au niveau OS.

### Prérequis machine — à vérifier avant d'activer

```bash
which bwrap socat
sysctl kernel.apparmor_restrict_unprivileged_userns 2>/dev/null
```

Si le `sysctl` renvoie `1` (Ubuntu 24.04+/25.10), bubblewrap échoue au
démarrage avec `bwrap: loopback: Failed RTM_NEWADDR: Operation not permitted`
— bug connu, pas une erreur de config. Fix, **dans un terminal hors session
Claude Code** (le préfixe `!` du CLI repasse par le sandbox, ne sert pas de
voie de diagnostic) :

```bash
sudo tee /etc/apparmor.d/bwrap > /dev/null <<'EOF'
abi <abi/4.0>,
include <tunables/global>

profile bwrap /usr/bin/bwrap flags=(unconfined) {
  userns,
  include if exists <local/bwrap>
}
EOF
sudo systemctl reload apparmor
```

### Config — `.claude/settings.json` (ou `settings.local.json` si chemin machine-personnel)

```json
{
  "sandbox": {
    "enabled": true,
    "failIfUnavailable": true,
    "allowUnsandboxedCommands": false,
    "autoAllowBashIfSandboxed": true,
    "filesystem": {
      "allowWrite": ["[→ ADAPTER] chemin absolu du périmètre"],
      "denyRead": ["~/.ssh", "~/.aws"]
    },
    "network": {
      "allowedDomains": ["[→ ADAPTER] domaines requis"]
    }
  },
  "permissions": {
    "defaultMode": "dontAsk",
    "allow": [
      "Bash",
      "Read(//[→ ADAPTER] chemin absolu/**)",
      "Edit(//[→ ADAPTER] chemin absolu/**)",
      "Write(//[→ ADAPTER] chemin absolu/**)"
    ]
  }
}
```

**Piège de syntaxe** : `//chemin` = absolu, `/chemin` seul = relatif à la
racine du *projet* pour les règles `Read`/`Edit`/`Write` (différent des règles
`sandbox.filesystem.*`, où `/chemin` seul est bien absolu). Un slash unique
sur un chemin censé être absolu ne lève aucune erreur — la règle ne matche
juste jamais rien, silencieusement.

**Portée de la config** : `~/.claude/settings.json` si le confinement doit
s'appliquer à toute session sur la machine · `.claude/settings.json` ou
`settings.local.json` si limité à un projet. Ne jamais committer un chemin
absolu personnel dans `settings.json` versionné (cf. `M-ENV-01`).

### Protocole de test — obligatoire avant de faire confiance à la config

Ne jamais committer sur la base de la doc seule. Avant de figer :

1. Écriture Bash hors périmètre → doit échouer (`Read-only file system`)
2. Écriture *dans* le périmètre → doit réussir (élimine un faux positif si
   bubblewrap échoue à l'initialisation — message `RTM_NEWADDR` différent
   d'un refus de sandbox, à ne pas confondre)
3. `Write`/`Read` natifs (pas Bash) hors périmètre → doivent échouer
   silencieusement sous `dontAsk`, sans prompt contournable
4. Domaine réseau non listé → comportement à vérifier (`dontAsk` bloque net,
   `default` prompte)
5. Écriture dans `.claude/settings.json` *à l'intérieur* du périmètre →
   doit échouer (auto-protection de la politique)

Détail complet du protocole et des résultats de référence :
`07-DECISIONS-SDLC.md §M-HOOKS-07`.

---
