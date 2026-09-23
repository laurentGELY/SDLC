# Audit externe — Strands Harness vs Modèle SDLC
<!-- Sprint audit-strands-harness · 23/09/2026 · Mode : Revue (analyse only) -->
<!-- Gabarit : 12-audit-externe-TEMPLATE.md v1.0 (M-TMPL-07) — + verdict ADAPTER demandé par le PDR, voir §7 -->
<!-- Sources lues en session le 23/09/2026 (pas de clone local — contenu web uniquement) :
     S1 https://strandsagents.com/blog/introducing-strands-harness/ — publié 21/09/2026
     S2 https://aws.amazon.com/blogs/machine-learning/strands-agents-sdk-a-technical-deep-dive-into-agent-architectures-and-observability/ — publié 31/07/2025
     S3 https://strandsagents.com/docs/api/python/strands.hooks.events/ — API reference
        (la page guide /docs/user-guide/concepts/agents/hooks/ renvoie HTTP 404 au 23/09/2026) -->

---

## 1. Cartographie Strands Harness

**Nature :** runtime d'agent — S1 le décrit comme « a fully assembled state-of-the-art agent
harness you can easily run locally or deploy to your favorite provider ». Il est construit sur
le SDK open source Strands Agents (AWS, Apache 2.0). C'est l'équivalent fonctionnel de Claude
Code lui-même (boucle modèle ↔ outils), pas d'un processus posé par-dessus.

**Attention à la datation des sources :** S2 date du 31/07/2025 et porte sur le **SDK**, plus
d'un an avant l'annonce du Harness (S1, 21/09/2026). Ce que S2 décrit (OpenTelemetry, callback
hooks) est une propriété du SDK sur lequel le Harness repose — S1 ne mentionne ni hooks ni
OpenTelemetry. Cet audit n'attribue au Harness que ce que S1 affirme.

**Mécanismes relevés :**

| Domaine | Mécanisme | Source |
|---|---|---|
| Contexte | Résultats d'outils > ~1500 tokens tronqués | S1 |
| Contexte | Résumé (compaction) déclenché au-delà de 85 % de la fenêtre | S1 |
| Contexte | « context recovery » dans la boucle en cas de dépassement | S1 |
| Session | Reprise d'une conversation antérieure via un session ID | S1 |
| Mémoire | Mémoire long terme conservée entre exécutions | S1 |
| Observabilité | Traces/spans OpenTelemetry (appels modèle, appels outils), métriques (fréquence et taux de succès/échec des outils, durée, itérations de boucle par interaction, latence, tokens prompt/completion), logs à niveaux avec rédaction optionnelle | S2 (SDK) |
| Lifecycle | 16 classes d'événements hook typées (`AgentInitializedEvent`, `BeforeInvocationEvent`, `BeforeToolCallEvent`, `AfterToolCallEvent`, `BeforeModelCallEvent`, `AfterModelCallEvent`, `MessageAddedEvent`, …, plus 5 événements multi-agents) | S3 (SDK) |
| Lifecycle | Chaque événement déclare ses attributs **modifiables** (`cancel`, `cancel_tool`, `selected_tool`, `retry`, `resume`, `end_turn`, `messages`) vs **lecture seule** ; les événements `After*` appellent les callbacks en ordre inverse | S3 (SDK) |

**Chiffres de performance :** S1 annonce :
- coût inférieur de 28 % à modèles égaux sur six benchmarks (chiffre vendeur, non vérifié indépendamment)
- avec Fable 5, coût inférieur de 77 % à Claude Code et score supérieur sur Terminal Bench 2.1 (chiffre vendeur, non vérifié indépendamment)

Méthode déclarée : « distributed benchmarking on EC2 with Harbor ». Ces chiffres
comparent deux runtimes ; ils ne disent rien de la gouvernance et ne sont utilisés nulle part
dans les recommandations ci-dessous.

---

## 2. Cartographie SDLC (rappel bref)

Points de contact avec Strands uniquement :

- `INV-3` Contexte chirurgical (`00-CONTEXT.md:100`) — *quoi* charger : les fichiers du
  `§Handoff`, pas le repo entier
- `SESSION_BRIDGE` (`03-wrap-up-SKILL-TEMPLATE.md:340` §Étape 5) — continuité inter-session par
  un fichier git versionné, ≤ 3 entrées `§Actif`, critère de qualité « test STATELESS »
  (`03-wrap-up-SKILL-TEMPLATE.md:410`)
- `§Observabilité` (`02-STANDARDS-TEMPLATE.md:127`) — règle start/done/erreur + 5 questions Q/R
  `[À REMPLIR]` avec exemples orientés pipeline batch
- Hooks (`08-hooks-TEMPLATE.md`) — `PreToolUse` Bash (garde, `exit 2` bloque), `PostToolUse`
  optionnel (lint/format), `PreCompact` optionnel (trace `CHECKPOINT`, toujours `exit 0`,
  `M-HOOKS-08`)
- Règle absolue « aval explicite » (`Claude.md:14`, `01-Claude-md-TEMPLATE.md`)

---

## 3. Analyse comparative

### 3.0 Harness runtime (Strands) vs harness gouvernance (SDLC)

Les deux mots « harness » ne désignent pas la même couche. **Strands Harness est un harness
runtime** : il exécute la boucle agent (appel modèle, exécution d'outil, gestion de la fenêtre
de contexte, persistance de session). Son concurrent direct est Claude Code, et c'est d'ailleurs
lui que S1 prend pour référence. **SDLC est un harness de gouvernance** : il ne possède aucune
boucle, il s'exécute *dans* un runtime existant (Claude Code) et encadre ce que l'agent fait
d'un sprint à l'autre — quoi lire, quand demander l'aval, comment prouver, comment clore et
transmettre. Conséquence : un mécanisme Strands n'est candidat à l'import que s'il répond à une
question de gouvernance (règle, trace humaine, preuve, rôle d'un contrôle). S'il répond à une
question d'exécution (combien de tokens garder, quand compacter, comment reprendre l'état
interne), il est déjà traité — ou non — par le runtime que SDLC utilise, et l'importer dans les
templates serait dupliquer Claude Code en prose. C'est la même conclusion de couche que pour
GSD-lite (« framework orthogonal », `docs/AUDIT-EXTERNE-gsd-lite-vs-sdlc.md §7`), pour une raison
différente : GSD-lite était orthogonal par la couche *interaction*, Strands l'est par la couche
*exécution*.

### 3.1 Tableau 6 axes

| Axe | Strands Harness | SDLC | Verdict |
|---|---|---|---|
| **Gouvernance de session** | Aucune règle de process : la boucle s'exécute tant que le modèle appelle des outils ; `AfterInvocationEvent.resume` permet même de relancer sans humain (S3) | Aval explicite avant code, HALT-*, verdict gate (`Claude.md:11-39`) | Couches distinctes — SDLC seul couvre ce besoin |
| **Séparation des rôles** | Multi-agents (swarm/graph) hors périmètre de cet audit (exclu par le PDR) ; mono-agent : pas de rôle distinct | Humain (aval, décision) / agent (exécution) / hooks (garde mécanique) | Non comparable dans le périmètre |
| **Traçabilité et documentation** | Traces OTel machine (spans, métriques, logs) — observabilité *du runtime* (S2, SDK) | Traces humaines versionnées : `sprint-memory.md`, `CHANGELOG`, `07-DECISIONS-SDLC.md` | Complémentaires — Strands trace l'exécution, SDLC trace les décisions |
| **Scalabilité** | Conçu pour déploiement (local ou fournisseur cloud) et orchestration multi-agents | Un sprint, un agent, un humain | Hors objet — SDLC ne vise pas le déploiement |
| **Overhead** | Aucun overhead de process ; coût d'exécution revendiqué inférieur (chiffres vendeur §1) | Overhead de process assumé (spec, mémoire, wrap-up) | Non comparable — pas la même ressource mesurée |
| **Récupération de session** | Session ID + mémoire long terme : l'état interne est restauré (S1) | `SESSION_BRIDGE` + `sprint-memory.md` : un humain ou un agent froid relit un texte | Couches distinctes — voir R2 |

---

## 4. Recommandations

**R1 — REJETER** · compaction > 85 % / troncature outils ~1500 tokens / context recovery (S1)
→ `00-CONTEXT.md` `INV-3` (ligne 100)
Mécanisme runtime : il décide *comment* le contexte déjà chargé est réduit, alors qu'`INV-3`
décide *quoi* charger. Côté SDLC, la seule conséquence de gouvernance d'une compaction — perdre
la trace du sprint — est déjà couverte par le hook `PreCompact` (`08-hooks-TEMPLATE.md:235`,
`M-HOOKS-08`). Aucun seuil de compaction n'a sa place dans un template de process.

**R2 — REJETER** · reprise par session ID + mémoire long terme (S1)
→ `03-wrap-up-SKILL-TEMPLATE.md` §Étape 5 (ligne 340)
La session Strands restaure un état interne opaque. `SESSION_BRIDGE` est volontairement un texte
versionné, relu par un humain et soumis au test STATELESS (ligne 410) : sa valeur est d'être
auditable et indépendant du runtime. Remplacer ou doubler ce fichier par un identifiant de
session lierait la continuité du process à un runtime précis.

**R3 — IMPORTER** · jeu d'exemples « projet agent / LLM » pour la checklist Q/R
→ `02-STANDARDS-TEMPLATE.md` §Observabilité (ligne 127), sous-section `### Checklist Q/R`
Les 5 questions Q/R n'ont que des exemples de pipeline batch (`[START] nom_etape run_id=...`).
Pour un projet cible qui *est* un agent, S2 fournit un référentiel externe concret de ce qu'il
faut rendre visible : itérations de boucle par interaction, succès/échec par outil, tokens
prompt/completion, latence modèle. Import sous forme d'**exemples** entre parenthèses, comme les
exemples actuels — pas de nouvelle règle, pas de dépendance OpenTelemetry imposée. Effort : XS
(1 bloc de 5-8 lignes). Entrée de décision proposée ci-dessous.

**R4 — ADAPTER** · attributs modifiables vs lecture seule déclarés par événement (S3)
→ `08-hooks-TEMPLATE.md`, en tête de `## Arborescence attendue` (ligne 12)
Strands déclare pour chaque événement ce qu'un hook peut changer. Côté SDLC, le rôle de chaque
hook existe mais est dispersé : « avertissements (non bloquants) » et codes `exit 1`/`exit 2`
(lignes 36-41), `PostToolUse` « optionnel » (ligne 203), `PreCompact` « pas un gate »
(ligne 255). Adaptation : un tableau de 3 lignes *hook · rôle (garde bloquante / observation /
transformation) · effet sur Claude Code* avant les sections détaillées. On adapte le principe de
déclaration explicite, pas l'API Strands. Effort : XS. À rattacher au sprint d'import éventuel,
sans entrée de décision propre (clarification documentaire).

**R5 — REJETER** · `AfterInvocationEvent.resume` (relance autonome) et `AgentInitializedEvent`
comme point d'injection au démarrage (S3)
→ `Claude.md` §Règles absolues (ligne 14) et `07-DECISIONS-SDLC.md` `M-TMPL-06` (ligne 2132)
La relance autonome contredit « écrire du code avant l'aval explicite ». L'injection au démarrage
est l'équivalent d'un hook `SessionStart`, déjà écarté par vérification factuelle en ECO-5
(`M-TMPL-06` : `Claude.md` recharge nativement au startup/resume/clear/compact). Strands
n'apporte aucun fait nouveau qui rouvrirait cette décision.

### Entrée de décision proposée pour R3 (non commitée — à reporter lors d'un sprint d'import)

```markdown
## M-TMPL-09 · Exemples d'observabilité « projet agent/LLM » dans §Observabilité · v2.0+<sprint> · <JJ/MM/AAAA>

**Contexte :** audit externe Strands Harness (`docs/AUDIT-EXTERNE-strands-harness-vs-sdlc.md`
R3, 23/09/2026). La checklist Q/R de `02-STANDARDS-TEMPLATE.md §Observabilité` ne propose que
des exemples de pipeline batch. Un projet cible qui est lui-même un agent n'a aucun repère pour
qualifier ses `[À REMPLIR]`. Le SDK Strands Agents documente un référentiel de métriques d'agent
(itérations de boucle, succès/échec par outil, tokens, latence — blog AWS du 31/07/2025).

**Retenu :** ajout d'exemples entre parenthèses, marqués « si projet agent/LLM », sous les
questions Q/R existantes — même forme que les exemples actuels, aucune question ni règle nouvelle.

**Écarté :**
- **Imposer OpenTelemetry** — écarté : dépendance technique dans un template de process, hors
  du principe « SDLC zéro code métier » ; le choix du backend reste au projet.
- **Section séparée « Observabilité agent »** — écarté : duplique la règle start/done/erreur
  déjà générale ; des exemples suffisent.

**Raison :** coût XS, comble un vide réel de la checklist sans alourdir la règle, référentiel
externe cité plutôt qu'inventé.

**Impact fichiers :** `02-STANDARDS-TEMPLATE.md` §Observabilité (bump de version mineur).

**Déclencheur de réouverture :** si un projet cible agent rapporte que les exemples ne
couvrent pas ses besoins réels (ex. coûts, garde-fous de sortie) — évaluer une section dédiée.
```

---

## 5. Nouvelles idées

- **Aucun contrôle ne vérifie que la checklist Q/R §Observabilité a un sens pour la nature du
  projet cible** — le grep `[À REMPLIR]` (`02-STANDARDS-TEMPLATE.md`) prouve seulement qu'elle
  est remplie. R3 atténue par des exemples ; pas de mécanisme proposé (même famille que
  `M-PROC-48` : défaut de prose non détectable mécaniquement).
- **La durée d'appel par outil** (`AfterToolCallEvent.duration`, S3) rappelle que
  `HALT-TIMEOUT` (`Claude.md:31`) repose sur une observation manuelle (« sans sortie depuis
  > 60s »). Pas de gap démontré dans ce repo — noté sans verdict.

---

## 6. Verdict synthétique

**Strands Harness et SDLC ne sont pas concurrents : l'un est un runtime d'agent, l'autre une
gouvernance posée sur un runtime** (§3.0). La comparaison est partielle par construction :
3 mécanismes sur 5 relèvent de l'exécution et sont rejetés (R1, R2, R5). Intégration
**partielle et minimale** : un import d'exemples (R3, `M-TMPL-09` rédigé) et une adaptation
documentaire (R4), tous deux XS, à grouper dans un sprint « Import » ultérieur si décidé.
Aucun template n'est modifié par cet audit.

---

## 7. Sur ce template

- **Verdict `ADAPTER` ajouté** aux quatre verdicts de `12-audit-externe-TEMPLATE.md` à la
  demande du PDR. Il couvre un cas que `IMPORTER` (« tel quel ou adapté ») mélange avec l'import
  direct : reprendre un *principe* sans le mécanisme (R4). 1ʳᵉ occurrence — à observer ; si un
  2ᵉ audit en a besoin, l'ajouter au template (seuil ≥ 2 audits, §7 du gabarit).
- **Section 3.0 ajoutée** (distinction de couche) avant le tableau 6 axes : pour un framework
  d'une autre couche, 4 axes sur 6 donnent « non comparable » — la distinction de couche est
  l'information utile et le gabarit ne prévoit pas d'emplacement pour elle.
- **Source web sans clone** : le gabarit suppose implicitement un clone local
  (`exemples/<framework>/`, audits précédents). Ici, 3 pages web datées ; une ligne
  « sources + date de lecture » en en-tête a suffi.
