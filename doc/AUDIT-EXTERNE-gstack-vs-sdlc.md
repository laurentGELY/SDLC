# Audit externe — GSTACK vs Modèle SDLC
<!-- Sprint SDLC-Audit-GSTACK · 25/06/2026 · Mode : Revue (analyse only) -->
<!-- Source auditée : exemples/gstack/ (clone local, v1.58.4.0) -->
<!-- Cohérence de format : doc/AUDIT-EXTERNE-gsd-vs-sdlc.md · doc/AUDIT-EXTERNE-gsd-lite-vs-sdlc.md -->

---

## 1. Cartographie GSTACK

**Nature :** framework d'orchestration de workflow Claude Code — boîte à outils de
spécialistes IA pour toutes les phases du cycle de développement produit.

**Auteur :** Garry Tan (President & CEO, Y Combinator)
**Version locale :** 1.58.4.0
**Taille :** 1 191 fichiers, 59 SKILL.md actifs
**Licence :** MIT, open source

**Architecture principale :**

| Composant | Rôle |
|---|---|
| `SKILL.md` (×59) | Skills spécialisées — prompts Markdown générés depuis `.tmpl` |
| `browse/` | Daemon Chromium persistant (~100ms/commande, ~3s cold-start) |
| `bin/` | CLIs autonomes (gstack-config, gstack-decision-log, gstack-learnings-log, etc.) |
| `~/.gstack/projects/<slug>/` | État persistant par projet (decisions.jsonl, learnings.jsonl, timeline.jsonl, retros/) |
| `GBrain` | Mémoire sémantique cross-session (PGLite local ou Supabase cloud) |
| `conductor.json` | Intégration Conductor (10-15 sessions parallèles) |
| `ETHOS.md` | Philosophie builder (Boil the Ocean / Search Before Building / User Sovereignty) |

**Pipeline de sprint GSTACK :**

```
Think → Plan → Build → Review → Test → Ship → Reflect
  ↓        ↓       ↓       ↓       ↓      ↓       ↓
/office-hours  /plan-* /review  /qa  /ship /retro
/spec    /autoplan  /investigate /cso /land
```

**Skills clés :**

| Catégorie | Skills |
|---|---|
| Idéation/Spec | `/office-hours`, `/spec`, `/plan-ceo-review` |
| Architecture | `/plan-eng-review`, `/plan-devex-review`, `/autoplan` |
| Design | `/plan-design-review`, `/design-consultation`, `/design-shotgun`, `/design-html` |
| Revue | `/review`, `/codex` (cross-model), `/investigate` |
| QA | `/qa`, `/qa-only`, `/devex-review` |
| Sécurité | `/cso` (OWASP Top 10 + STRIDE) |
| Ship | `/ship`, `/land-and-deploy`, `/canary` |
| Mémoire | `/context-save`, `/context-restore`, `/learn`, `/retro` |
| Browser | `/browse`, `/open-gstack-browser`, `/pair-agent` |
| Sécurité ops | `/careful`, `/freeze`, `/guard` |
| Doc | `/document-release`, `/document-generate` (Diataxis) |

**Concepts clés :**

- **Role-based specialization** — chaque skill simule un spécialiste distinct (CEO,
  Eng Manager, Designer, QA Lead, Security Officer, etc.) avec un prompt calibré pour
  ce rôle. Pas de sous-agents séparés — même modèle avec prompt spécialisé.
- **AutoPlan** — pipeline automatisé CEO → Design → Eng → DX review en une commande.
- **Decision log** — `gstack-decision-log` : JSONL append-only, supersedure, redaction.
  Résurgence avant re-décision via `gstack-decision-search`.
- **Learn system** — `learnings.jsonl` par projet : patterns, pitfalls, préférences.
  Managed via `/learn` (review, prune, export). Gestion saisonnière : "didn't we fix this?"
- **Continuous checkpoint** — WIP commits préfixés `WIP:` + corps `[gstack-context]`
  structuré (décisions, travail restant, tentatives échouées). Filter-squash avant PR.
- **Context-save/restore** — `/context-save` capture l'état (git, décisions, remaining
  work) lisible par un agent frais sans relire l'historique conversationnel.
- **Proactive skill routing** — GSTACK détecte la phase de travail (brainstorming, review,
  debug) et suggère le skill adapté. Configurable via `gstack-config set proactive false`.
- **Taste memory** — préférences design apprises de `/design-shotgun`, decay 5%/semaine,
  réinjectées dans les générations futures.
- **Timeline events** — `timeline.jsonl` : journal d'événements structurés utilisé par `/retro`.
- **Diataxis docs** — framework tutorial/how-to/reference/explanation pour `/document-generate`.
- **GBrain** — mémoire sémantique : PGLite (local), Supabase (cloud), split-engine.
  Fourni via MCP; intégré dans le preamble des skills via `gbrain:context_queries`.
- **Multi-provider** — fonctionne sur 10+ agents (Claude Code, Codex, Cursor, Factory,
  OpenCode, Kiro, etc.). Setup auto-detect `./setup --host <name>`.
- **ETHOS.md** — philosophie builder formalisée (3 principes injectés dans chaque skill).
- **Slop-scan** — qualité du code IA (catches empty catches, redundant return-await, etc.).
- **Telemetry opt-in** — skill name, durée, succès/échec, version, OS. Jamais de code/paths.

**Exigences d'installation :**
- Git, Bun v1.0+, Node.js (Windows)
- Optionnel : Supabase (GBrain cloud), Conductor (sessions parallèles), Tailscale (iOS QA)
- Binaires compilés ~58MB par plateforme (Mach-O arm64, Linux x64, Windows)

---

## 2. Cartographie SDLC (rappel)

**Nature :** gouvernance de sprint IA — processus de développement structuré pour projets
Claude.ai / Claude Code, conçu pour usage solo/petit projet.

**Architecture principale :**

| Composant | Rôle |
|---|---|
| Invariants INV-1 à INV-4 | Principes fondamentaux (Vérification / Circuit fermé / Contexte chirurgical / Rétroaction) |
| SESSION_BRIDGE.md (hot/cold) | Continuité cross-session (§Actif ≤ 3 entrées / §Archive) |
| PreToolUse / PreCompact hooks | Guard-rails process (enforcement technique) |
| PDR (sprint-PDR-TEMPLATE) | Spec exécutable avec Portée / Plan / Critères d'acceptation |
| DECISIONS.md (M-XX/D-XX) | Registre de décisions interrogeable |
| LESSONS_LEARNED → /retrospective | Boucle de feedback INV-4 |
| Sprint sizing XS/S/M/L | Gouvernance du scope |
| §0f Adversarial Review | Blind Hunter / Edge Case Hunter / Acceptance Auditor |
| Deux surfaces | Claude.ai (amont/idéation) + Claude Code (aval/exécution) |
| sdlc-init.sh + templates Markdown | Zéro dépendance npm |

---

## 3. Analyse comparative

### 3.1 Tableau comparatif — 6 axes

| Axe | GSTACK | SDLC | Verdict |
|---|---|---|---|
| **Gouvernance de session** | Pipeline `Think→Plan→Build→Review→Test→Ship→Reflect` avec skills spécialisées. AutoPlan orchestre automatiquement 4 étapes. Context-save/restore machine-readable. | Sprint lifecycle structuré (PDR → exécution → wrap-up). SESSION_BRIDGE hot/cold. Graduation automatique en retrospective. | GSTACK plus fluide sur les transitions ; SDLC plus contraignant (hooks guard-rails) |
| **Séparation des rôles** | 23 spécialistes distincts (CEO, Eng Manager, Designer, QA Lead, Security Officer, etc.). Même modèle, prompts spécialisés. `/autoplan` coordonne en chaîne. | Rôle unique : Claude Code + humain. §0f simule 3 perspectives adversariales (même instance). | GSTACK SUPÉRIEUR — vraie différenciation de prompt par spécialité ; SDLC adversarial = même modèle |
| **Traçabilité et documentation** | `decisions.jsonl` (append-only, supersedure, redact) + `learnings.jsonl` + `timeline.jsonl`. Decision-search CLI. `/retro` avec tendances historiques. | DECISIONS.md (M-XX/D-XX), LESSONS_LEARNED, /retrospective avec graduation automatique. SESSION_BRIDGE structuré. | GSTACK SUPÉRIEUR opérationnellement (CLI, machine-readable) ; SDLC supérieur sur intégration process (INV-4) |
| **Scalabilité** | Conçu pour 10-15 sessions Conductor parallèles. Multi-provider (10+ agents). Team mode (auto-update). Community contributions. | Conçu explicitement pour solo/petit projet. Un sprint actif à la fois. | Contextes incomparables — GSTACK vise équipes ; SDLC vise solo |
| **Overhead** | Installation : ~30s + Bun + ~58MB binaires. 59 skills. GBrain optionnel mais recommandé. Preamble de ~80 lignes shell par skill. | Installation : sdlc-init.sh, zéro npm. ~10 templates Markdown. Hooks optionnels. | SDLC SUPÉRIEUR — overhead minimal ; GSTACK assume infrastructure non-nulle |
| **Récupération de session** | `/context-save` : WIP commit structuré avec `[gstack-context]` (décisions, remaining work, tentatives échouées). `/context-restore` relit ces commits. GBrain optionnel. | SESSION_BRIDGE hot (§Actif ≤ 3 entrées) / cold (§Archive). Graduation automatique. Lecture limitée à §Actif via `awk` au démarrage. | Mécanismes comparables ; GSTACK plus machine-readable ; SDLC plus léger |

### 3.2 GSTACK fait mieux que SDLC

| Domaine | GSTACK | SDLC | Écart |
|---|---|---|---|
| Spécialisation par rôle | 23 spécialistes calibrés (CEO review, design, QA, security, devex) | Rôle unique, §0f simulé | SDLC n'a pas de vrais spécialistes distincts |
| Adversarial review réel | `/codex` = OpenAI Codex, modèle différent, vraie indépendance | §0f = même instance Claude simulant 3 rôles | Gap fondamental — simulation ≠ indépendance |
| Decision log opérationnel | CLI `gstack-decision-log` (JSONL, supersedure, search) | DECISIONS.md éditorial (statique entre sprints) | GSTACK permet résurgence avant re-décision, dans un sprint comme entre sprints |
| Learn system actif | `learnings.jsonl` + `/learn` (review, prune, export, auto-suggestion) | LESSONS_LEARNED narratif → graduation trimestrielle | GSTACK apprend activement dans le sprint, pas seulement au retro |
| Spec formalisée (5 phases) | `/spec` : Why → Scope → Technical (code-reading obligatoire) → Draft → File (qualité gate) | PDR : contexte + plan + CA, moins guidé sur la spec elle-même | La phase "Technical" avec code-reading obligatoire est une avancée réelle |
| Continuité cross-session | WIP commits machine-readable + `[gstack-context]` structuré | SESSION_BRIDGE textuel (hot/cold), suffisant mais narratif | Le format WIP commit est récupérable sans conversation précédente |
| Philosophie formalisée | ETHOS.md injecté dans chaque skill (Boil the Ocean / Search First / User Sovereignty) | STANDARDS.md procédural — pas de document philosophique | SDLC manque d'une charte d'éthique/philosophie distincte |
| Timeline structurée | `timeline.jsonl` : journal d'événements pour trending dans `/retro` | Retro basé sur CHANGELOG + git log | GSTACK peut détecter des tendances longitudinales (test health, shipping streak) |

### 3.3 SDLC fait mieux que GSTACK

| Domaine | SDLC | GSTACK | Écart |
|---|---|---|---|
| Enforcement technique | PreToolUse / PreCompact hooks (guard-rails hard) | Aucun enforcement technique — advisory seulement | GSTACK assume la discipline sans la forcer |
| Taxonomie de sprint | XS/S/M/L + types (Doc/Feature/Refactor/Spike/Revue) | Aucune taxonomie de sprint formelle | SDLC gouverne le scope ; GSTACK laisse le scope non contraint |
| Invariants nommés | INV-1 à INV-4 référencés dans tous les templates | Aucun invariant système | SDLC permet de vérifier la conformité des décisions |
| Deux surfaces explicites | Claude.ai (idéation) + Claude Code (exécution) clairement séparées | Claude Code uniquement | SDLC couvre la transition humain/outil amont |
| Zero-dependency | sdlc-init.sh + Markdown natif | Bun + Node.js + binaires compilés + optionnel Supabase | SDLC fonctionne sur n'importe quel poste sans setup spécial |
| Scope discipline formelle | §Portée avec Inclus/Exclu, §Sacrifices délibérés, SPIDR | Aucun mécanisme de scope control formel | GSTACK peut diverger silencieusement sans contrainte de périmètre |
| Adversarial Review structuré | §0f : 3 rôles, liste d'anomalies, gate avant clôture | `/review` : excellent mais mono-rôle | SDLC plus rigoureux sur la vérification finale — même si simulé |

### 3.4 Convergences

- Continuité cross-session (SESSION_BRIDGE ≈ context-save/restore)
- Boucle de feedback (LESSONS_LEARNED + graduation ≈ learnings.jsonl + /learn)
- Vérification scope (PDR §Portée ≈ absente en GSTACK mais ETHOS "User Sovereignty" y contribue)
- Spec avant code (PDR SDLC ≈ `/spec` GSTACK)
- Retro (retrospective SDLC ≈ `/retro` GSTACK)
- Décisions persistantes (DECISIONS.md ≈ decisions.jsonl — implémentations différentes)

---

## 4. Recommandations étiquetées

---

**CONCEPT : ETHOS.md — Philosophie builder (3 principes)**
**SOURCE  :** `ETHOS.md`
**VERDICT : IMPORTER**
**RAISON  :** "Boil the Ocean" (completeness is cheap), "Search Before Building" (trois couches de
connaissance), "User Sovereignty" (génération + vérification, jamais d'action sans aval) — ces
trois principes sont directement compatibles avec les invariants SDLC et les enrichiraient.
SDLC a STANDARDS.md (procédural) mais aucun document de philosophie de développement distinct.
Un "ETHOS.md SDLC" ou une section §Philosophie dans STANDARDS.md serait de valeur nulle-overhead.
**IMPACT  :** `STANDARDS.md` ou nouveau `doc/ETHOS.md` — section §Principes d'éthique builder

---

**CONCEPT : Decision log opérationnel (gstack-decision-log CLI)**
**SOURCE  :** `bin/gstack-decision-log`, `bin/gstack-decision-search`, `CLAUDE.md §Cross-session decision memory`
**VERDICT : IMPORTER**
**RAISON  :** Le pattern append-only JSONL + supersedure + `search --query KW` adresse une
faiblesse réelle de DECISIONS.md : entre deux sprints, une décision peut être re-prise sans
avoir relu le registre. `gstack-decision-log` est interrogé en début de session pour résurgir
les décisions actives. L'implémentation GSTACK est en Bash/TypeScript mais le concept est
portable : un simple `decisions.jsonl` avec un grepper suffît, sans CLI.
**IMPACT  :** `07-DECISIONS-SDLC.md` (format) + `01-Claude-md-TEMPLATE.md` (protocole résurgence)

---

**CONCEPT : /spec — Spec en cinq phases (Why/Scope/Technical/Draft/File)**
**SOURCE  :** `spec/SKILL.md`, `README.md §spec`
**VERDICT : IMPORTER**
**RAISON  :** La phase "Technical" (code-reading obligatoire avant de rédiger la spec) et
la phase "File" (qualité gate ≥ 7/10 avant finalisation) sont deux mécanismes absents du
PDR SDLC. Le PDR actuel part des besoins → plan, sans forcer la lecture du code existant
avant de spécifier. Cela crée des specs déconnectées du réel. L'adaptation SDLC serait
légère : ajouter un §Lecture code existant comme pré-condition au §Plan d'exécution pour
les sprints Feature et Refactor.
**IMPACT  :** `04-sprint-PDR-TEMPLATE.md` — ajout §Lecture code obligatoire (types Feature/Refactor)

---

**CONCEPT : SKILL.md généré depuis template .tmpl (pipeline de génération)**
**SOURCE  :** `CLAUDE.md §SKILL.md workflow`, `scripts/gen-skill-docs.ts`
**VERDICT : IMPORTER**
**RAISON  :** Le pattern "éditer le .tmpl, générer le .md, committer les deux" résout un
problème futur probable du SDLC : la dérive entre templates maîtres et documents dérivés.
Aujourd'hui les templates SDLC sont les masters eux-mêmes — pas de couche de génération.
Quand les templates deviendront plus complexes (résolveurs, variantes par contexte), ce
pattern sera nécessaire. L'implémenter maintenant aurait trop d'overhead ; le signaler comme
évolution architecturale est la bonne posture.
**IMPACT  :** §Signaux faibles ROADMAP — "pipeline de génération templates SDLC (si dérive détectée)"

---

**CONCEPT : Rôles spécialisés distincts (CEO/Eng/Design/QA/Security)**
**SOURCE  :** `README.md §The sprint`, `AGENTS.md §Available skills`
**VERDICT : INVESTIGUER**
**RAISON  :** La spécialisation par rôle crée un biais de prompt significatif — un CEO reviewer
pose des questions différentes d'un Eng Manager, qui diffère d'un QA Lead. SDLC §0f simule
3 perspectives adversariales mais avec la même instance, le même contexte, le même biais
implicite. La question à investiguer : est-ce que des SKILL.md SDLC spécialisés par rôle
(ex : `wrap-up-adversarial-auditor.md`) apporteraient suffisamment de valeur différentielle
pour justifier la complexité ? À tester sur un sprint M avant décision.
**IMPACT  :** `03-wrap-up-SKILL-TEMPLATE.md §0f` — potentiellement split en skills séparés

---

**CONCEPT : AutoPlan (pipeline automatisé CEO→Design→Eng→DX)**
**SOURCE  :** `autoplan/SKILL.md`, `README.md §autoplan`
**VERDICT : INVESTIGUER**
**RAISON  :** AutoPlan orchestre 4 reviews en séquence avec des critères de filtre intelligents
(CEO review non déclenchée sur bug-fix, design review non déclenchée sur backend-only). Pour
SDLC, la question est : les PDR de type Feature M/L bénéficieraient-ils d'un §4d automatisé
(Plan review enchainé plutôt que manuel) ? Coût d'investigation : un sprint S.
**IMPACT  :** `04-sprint-PDR-TEMPLATE.md §4d` — mode automatisé conditionnel pour Feature M/L

---

**CONCEPT : Revue cross-modèle (/codex — OpenAI Codex)**
**SOURCE  :** `codex/SKILL.md`, `README.md §codex`
**VERDICT : INVESTIGUER**
**RAISON  :** `/codex` fournit une vraie revue indépendante d'un modèle différent (OpenAI),
ce qui adresse une lacune structurelle du §0f SDLC : même modèle simulant l'adversarial ≠
véritable perspective externe. L'intégration dans notre contexte dépend de la disponibilité
d'un second agent (Codex CLI). Si disponible, c'est la seule façon d'avoir une vraie
indépendance dans le §0f. À investiguer dès que Codex CLI est accessible.
**IMPACT  :** `03-wrap-up-SKILL-TEMPLATE.md §0f` — couche optionnelle "cross-modèle" si Codex disponible

---

**CONCEPT : Learn system (learnings.jsonl par projet)**
**SOURCE  :** `learn/SKILL.md`, `bin/gstack-learnings-log`, `README.md §learn`
**VERDICT : MERGER**
**RAISON  :** SDLC a LESSONS_LEARNED (narratif, relu au retro) et un mécanisme de graduation
vers CLAUDE.md/STANDARDS.md. GSTACK a learnings.jsonl (structuré, interrogeable "didn't we fix
this?", géré activement via /learn). Les deux adressent le même problème avec des forces
complémentaires : SDLC meilleur sur la graduation institutionnelle, GSTACK meilleur sur
la récupération dans le sprint. Le MERGER : ajouter une mini-interrogation LESSONS_LEARNED
en début de sprint (style "anything in LESSONS_LEARNED relevant to this sprint?") sans
restructurer le format existant.
**IMPACT  :** `01-Claude-md-TEMPLATE.md §Démarrage` — lecture conditionnelle LESSONS_LEARNED

---

**CONCEPT : Context-save/restore (WIP commits structurés)**
**SOURCE  :** `context-save/SKILL.md`, `context-restore/SKILL.md`, `README.md §Continuous checkpoint`
**VERDICT : MERGER**
**RAISON  :** Le format `[gstack-context]` dans le corps des commits WIP est une innovation
réelle : machine-readable sans conversation, récupérable depuis git log dans n'importe quel
contexte. SESSION_BRIDGE SDLC (hot/cold) est plus léger mais textuel. Le MERGER possible :
ajouter un format structuré optionnel au SESSION_BRIDGE (bloc `§État technique` : fichiers
modifiés, décisions lockées, next action) sans supplanter la prose existante.
**IMPACT  :** `03-wrap-up-SKILL-TEMPLATE.md §SESSION_BRIDGE §Actif` — bloc structuré optionnel

---

**CONCEPT : Timeline events (timeline.jsonl)**
**SOURCE  :** `bin/gstack-timeline-log`, `retro/SKILL.md §gbrain context_queries`
**VERDICT : INVESTIGUER**
**RAISON  :** Un journal d'événements structurés (skill lancée, durée, succès/échec) permet
des tendances longitudinales dans le retro (shipping streak, test health). SDLC actuel n'a pas
d'équivalent — le retro repose sur CHANGELOG + git log + LESSONS_LEARNED narratifs. La valeur
réelle dépend du volume d'utilisation : pour < 1 sprint/semaine, le signal est trop rare.
À investiguer si la cadence augmente.
**IMPACT  :** `09-retrospective-SKILL-TEMPLATE.md` — section §Tendances si timeline disponible

---

**CONCEPT : Safety guardrails (/careful, /freeze, /guard)**
**SOURCE  :** `careful/SKILL.md`, `freeze/SKILL.md`
**VERDICT : INVESTIGUER**
**RAISON  :** `/freeze` (lock edits to one directory) est un mécanisme de scope-control
opérationnel absent du SDLC. Les hooks PreToolUse SDLC contrôlent le comportement global ;
/freeze contrôle le périmètre fichier dans un debug session. Les deux sont complémentaires.
À investiguer : est-ce que nos hooks PreToolUse actuels peuvent implémenter un équivalent
"freeze" conditionnel déclenché par un marqueur dans SESSION_BRIDGE ?
**IMPACT  :** `08-hooks-TEMPLATE.md` — potentiel pattern "freeze directory scope" via hook

---

**CONCEPT : Diataxis documentation (tutorial/how-to/reference/explanation)**
**SOURCE  :** `README.md §document-generate`, `document-generate/SKILL.md`
**VERDICT : INVESTIGUER**
**RAISON  :** Le framework Diataxis est une taxonomie documentaire reconnue et bien adaptée
aux projets techniques. SDLC documente actuellement sans taxonomie explicite (STANDARDS.md,
CHANGELOG, doc/). Si le SDLC Toolkit est un jour documenté pour d'autres équipes, Diataxis
serait le bon cadre. À investiguer dans le contexte P-32 (doc/MODE-OPERATOIRE.html).
**IMPACT  :** `doc/MODE-OPERATOIRE.html` (P-32) + tout futur effort de documentation externe

---

**CONCEPT : Retro global (cross-projects)**
**SOURCE  :** `retro/SKILL.md`, `README.md §retro global`
**VERDICT : INVESTIGUER**
**RAISON  :** `/retro global` agrège les métriques sur tous les repos + tous les outils IA.
Pour un usage solo multi-projet, c'est de la valeur réelle (visibility sur allocation d'effort
totale, non sur un seul repo). À investiguer si > 1 projet SDLC actif. Overhead minimal :
c'est le même skill, option `--global`.
**IMPACT  :** `09-retrospective-SKILL-TEMPLATE.md` — mention option cross-projet si > 1 projet actif

---

**CONCEPT : Conductor (10-15 sessions parallèles)**
**SOURCE  :** `README.md §10-15 parallel sprints`, `conductor.json`
**VERDICT : REJETER**
**RAISON  :** Conductor adresse un contexte fondamentalement différent : un développeur gérant
10-15 sprints simultanément via un orchestrateur externe. SDLC est conçu pour la discipline
d'un sprint séquentiel solo. Adopter Conductor dans notre contexte inverse la priorité : la
valeur SDLC est dans la rigueur du processus unique, pas dans la parallélisation. L'ajout
serait du bruit.
**IMPACT  :** Aucun

---

**CONCEPT : Browser automation (/browse, /qa, /open-gstack-browser)**
**SOURCE  :** `browse/`, `qa/SKILL.md`, `BROWSER.md`
**VERDICT : REJETER**
**RAISON  :** Catégorie entière hors périmètre SDLC. Le SDLC gouverne le processus de
développement, pas les outils d'exécution. Les skills browser de GSTACK sont excellentes
pour les projets web — elles sont simplement orthogonales à notre sujet. Même logique que
le rejet du gsd-sdk dans l'audit GSD-full.
**IMPACT  :** Aucun

---

**CONCEPT : Proactive skill suggestions (stage detection + trigger phrases)**
**SOURCE  :** `README.md §Proactive skill suggestions`, preamble `PROACTIVE=true` dans tous les skills
**VERDICT : REJETER**
**RAISON  :** Pour un développeur solo avec un workflow structuré (SDLC), les suggestions
proactives créent du bruit plutôt que de la valeur — le développeur connaît son workflow.
GSTACK cible aussi des "first-time Claude Code users" pour qui la guidance est précieuse ;
SDLC assume un utilisateur qui a déjà internalisé le processus. De plus, le mécanisme de
suggestion ("stop suggesting: remembered across sessions") introduit une couche de
personnalisation supplémentaire à maintenir.
**IMPACT  :** Aucun

---

**CONCEPT : Taste memory (design preferences decay 5%/week)**
**SOURCE  :** `README.md §design-shotgun`, `bin/gstack-taste-update`
**VERDICT : REJETER**
**RAISON  :** Hors scope SDLC (gouvernance de processus). La mémoire de préférences design
est une fonctionnalité produit-builder — pertinente pour quelqu'un qui génère 40+ features
design en parallèle, pas pour la gouvernance de sprint.
**IMPACT  :** Aucun

---

**CONCEPT : iOS QA (/ios-qa, gstack-ios-qa-daemon)**
**SOURCE  :** `README.md §ios-qa`
**VERDICT : REJETER**
**RAISON  :** Plateforme-spécifique et hors périmètre. Excellent outil pour les projets iOS ;
sans pertinence pour un framework de gouvernance de processus généraliste.
**IMPACT  :** Aucun

---

**CONCEPT : Redaction guard (PII/secrets before external sinks)**
**SOURCE  :** `CLAUDE.md §Redaction guard`, `bin/gstack-redact`, `lib/redact-patterns.ts`
**VERDICT : REJETER**
**RAISON  :** Infrastructure sécurité pour prévenir les leaks PII/secrets avant push/issue.
Pertinent pour des projets avec contenu sensible. SDLC toolkit n'a pas de surface d'exposition
externe sur ce vecteur (pas de push vers GitHub public, pas de création d'issues automatique).
**IMPACT  :** Aucun (mais noter dans §Signaux faibles si SDLC s'étend vers workflows de publication)

---

**CONCEPT : Multi-provider (Codex, Cursor, Factory, Kiro, etc.)**
**SOURCE  :** `README.md §Other AI Agents`, `hosts/`
**VERDICT : REJETER**
**RAISON  :** SDLC est conçu explicitement pour Claude Code. Le multi-provider est une
décision d'architecture GSTACK qui ajoute ~20% de complexité de maintenance (host adapters,
templates conditionnels par host) pour une valeur absente de notre contexte.
**IMPACT  :** Aucun

---

## 5. Nouvelles idées pour le SDLC

Ces concepts GSTACK n'ont pas d'équivalent dans notre modèle mais adressent des lacunes réelles.
L'implémentation GSTACK n'est pas nécessairement la bonne, mais l'idée l'est.

### Idée 1 — Résurgence active des décisions en début de session

**Problème adressé :** une décision prise en sprint S-3 peut être re-prise en sprint S sans
qu'on s'en aperçoive — DECISIONS.md n'est pas automatiquement relu.

**Signal GSTACK :** `gstack-decision-search --recent 30 --scope repo` au démarrage de chaque
session, avant toute action.

**Adaptation SDLC :** ajouter dans `01-Claude-md-TEMPLATE.md §Démarrage` une instruction
"lire le §récent DECISIONS-SDLC.md (5 dernières entrées)" avant de démarrer un sprint.
Sans CLI, sans script — juste une instruction de lecture conditionnelle.

**Signal de déclenchement :** P-37 (00-CONTEXT.md comme Index-guidé) — si DECISIONS.md
y est indexé, la résurgence devient naturelle.

---

### Idée 2 — Spec en cinq phases avec "Technical gate" obligatoire

**Problème adressé :** les PDR SDLC peuvent spécifier sans avoir lu le code existant,
créant des specs déconnectées du réel (ex : proposer un mécanisme qui existe déjà).

**Signal GSTACK :** `/spec` phase 3 (Technical) = "MANDATORY code-reading before
drafting — must read at least 3 relevant files and quote specific line ranges".

**Adaptation SDLC :** ajouter dans `04-sprint-PDR-TEMPLATE.md` un bloc §Lecture code
existant obligatoire pour Feature et Refactor (liste de fichiers lus + ligne clé avant
§Plan d'exécution). Zéro overhead d'installation.

**Signal de déclenchement :** immédiatement — faible effort, fort impact sur la qualité des PDR.

---

### Idée 3 — §État technique structuré dans SESSION_BRIDGE

**Problème adressé :** SESSION_BRIDGE actuel est textuel — un agent frais (sans conversation
précédente) doit en inférer l'état. Un bloc structuré machine-readable serait récupérable
sans ambiguïté.

**Signal GSTACK :** `[gstack-context]` dans le corps des WIP commits :
`decisions: [...]`, `remaining_work: [...]`, `failed_approaches: [...]`.

**Adaptation SDLC :** ajouter un bloc optionnel `§État technique` en fin de §Actif
SESSION_BRIDGE avec 3 champs : `Fichiers modifiés:`, `Décisions lockées:`, `Prochaine action:`.
Reste compatible avec le format actuel (prose avant, structuré après).

**Signal de déclenchement :** sprint suivant avec rupture de session mid-sprint.

---

### Idée 4 — Gate qualité avant finalisation d'un PDR

**Problème adressé :** les PDR peuvent être validés sans avoir vérifié la cohérence interne
(critères d'acceptation vérifiables ? scope compatible avec la taille ?)

**Signal GSTACK :** `/spec` "Codex quality gate before file (blocks below 7/10)" —
auto-évaluation qualité du document avant finalisation.

**Adaptation SDLC :** ajouter un mini-checklist de cohérence en fin de PDR (avant
validation humaine) : "CA vérifiables ? Portée compatible avec la taille ? Dépendances
vérifiées ?" Sans LLM-judge externe — auto-évaluation Claude Code.

**Signal de déclenchement :** sprint suivant de taille M ou L.

---

### Idée 5 — Document philosophique SDLC (Ethos builder)

**Problème adressé :** SDLC a des invariants (INV-1 à INV-4) mais pas de document de
philosophie qui explique *pourquoi* ces invariants existent — ce qui les rend difficilement
transmissibles.

**Signal GSTACK :** ETHOS.md (injecté dans chaque skill) = "Boil the Ocean", "Search
Before Building", "User Sovereignty" en prose limpide.

**Adaptation SDLC :** une section §Philosophie dans STANDARDS.md (pas un fichier séparé)
expliquant les principes fondateurs : "Pourquoi INV-1 ?", "Pourquoi INV-3 ?", "La
gouvernance de processus, pas la gouvernance d'outils".

**Signal de déclenchement :** si/quand SDLC est partagé avec un tiers ou une autre équipe.

---

## 6. Verdict synthétique

### Fit général GSTACK dans notre contexte

**GSTACK est un excellent framework pour son contexte — qui est différent du nôtre.**

GSTACK est optimisé pour : un founder/tech lead gérant 10-15 sprints simultanément, avec
des projets web/produit nécessitant QA navigateur, design system, sécurité OWASP, et
coordinations multi-agent. C'est un outil d'orchestre, pas une partition.

SDLC est optimisé pour : la gouvernance rigoureuse d'un sprint solo, avec enforcement
technique (hooks), traçabilité formelle (DECISIONS.md, INV-1 à INV-4), et zéro dépendance.
C'est une partition, pas un orchestre.

Ces deux positions ne sont pas en compétition — elles adressent des niveaux différents :
GSTACK opère à l'échelle des outils et de l'orchestration ; SDLC opère à l'échelle du
processus et de la gouvernance.

### Résumé des propositions retenues en ordre de priorité

| Rang | Proposition | Effort | Impact | Type |
|---|---|---|---|---|
| 1 | IMPORTER — §Lecture code obligatoire dans PDR (Idée 2) | XS | PDR qualité réelle | Immédiat |
| 2 | IMPORTER — §État technique structuré SESSION_BRIDGE (Idée 3 + MERGER context-save) | XS | Récupération session | Immédiat |
| 3 | IMPORTER — Résurgence DECISIONS.md début session (Idée 1 + IMPORTER decision log concept) | XS | Cohérence décisions | Immédiat |
| 4 | IMPORTER — Gate qualité cohérence PDR (Idée 4) | XS | PDR discipline | Prochain sprint M/L |
| 5 | IMPORTER — §Philosophie dans STANDARDS.md (Idée 5 + IMPORTER ETHOS) | S | Transmissibilité | Si partage externe |
| 6 | INVESTIGUER — Rôles spécialisés distincts (§0f split) | S | Adversarial review | Après test sprint M |
| 7 | INVESTIGUER — Revue cross-modèle /codex | S | Vraie indépendance §0f | Si Codex CLI disponible |
| 8 | MERGER — Learn system + lecture LESSONS_LEARNED début sprint | XS | Continuité apprentissage | Prochain sprint |
| 9 | INVESTIGUER — AutoPlan (pipeline §4d automatisé) | M | PDR Feature M/L | Après test rôles |
| 10 | INVESTIGUER — Timeline events pour retro tendances | S | Retro longitudinal | Si cadence > 1/semaine |

### Réponse explicite : concepts isolés vs intégration plus large

**Concepts isolés — verdict clair.**

Une intégration large de GSTACK (installation, GBrain, Conductor, binaires) dans le contexte
SDLC serait une erreur d'architecture : l'overhead d'infrastructure (Bun, binaires ~58MB,
Supabase optionnel, auto-update) est incompatible avec la philosophie zero-npm SDLC.

Les concepts les plus précieux de GSTACK (decision log structuré, spec cinq phases, philosophie
builder, état technique machine-readable) sont tous exportables *sans leur implémentation* —
en pure prose ou Markdown. C'est le bon niveau d'adoption.

**Une exception potentielle :** si le projet cible du SDLC Toolkit est un projet web avec
QA navigateur, les skills GSTACK (/qa, /review, /ship) peuvent coexister *à côté* du modèle
SDLC sans s'y intégrer — GSTACK pour l'exécution tool, SDLC pour la gouvernance process.

---

## 7. Sur P-22 — `10-audit-externe-TEMPLATE.md`

### Ce sprint comme test du besoin de template

P-22 demande : "un gabarit générique de revue aurait-il accéléré ou simplifié ce sprint ?"

**Réponse :** **Partiellement, mais le bénéfice est marginal.**

Ce sprint a bénéficié de la structure des audits précédents (GSD-full, GSD-lite) comme
référence implicite. Un template formel aurait simplifié :
- La définition des 6 axes de comparaison (auraient été pré-définis)
- Le format des verdicts étiquetés (auraient été pré-structurés)
- La question "intégration partielle vs globale" (aurait été pré-incluse)

Mais la valeur ajoutée réelle est faible : le format s'est naturellement standardisé sur
les 3 premiers audits (GSD-full, GSD-lite, Superpowers + celui-ci). Un template XS est
justifié — pas pour accélérer le sprint (qui est intellectuellement irréductible), mais
pour **garantir la cohérence entre audits** quand ils sont réalisés à plusieurs mois
d'intervalle.

### Recommandation P-22

**Statut P-22 : passer de §Later → §Next** avec un scope réduit.

Le template ne doit pas être une super-structure — c'est une checklist de sections
obligatoires et un bloc de verdicts étiquetés standardisé :

```markdown
# Audit externe — [FRAMEWORK] vs Modèle SDLC
## 1. Cartographie [FRAMEWORK] (structure, concepts clés)
## 2. Cartographie SDLC (rappel bref)
## 3. Analyse comparative (tableau 6 axes obligatoires)
## 4. Recommandations (format étiqueté IMPORTER/REJETER/INVESTIGUER/MERGER)
## 5. Nouvelles idées (lacunes SDLC adressées)
## 6. Verdict synthétique (intégration partielle vs globale)
## 7. Sur P-22 (si applicable — feedback sur le template lui-même)
```

Ce template XS (< 30 lignes) aurait réduit la mise en place de ce sprint de ~20 min.
Sa valeur cumulée est réelle si ≥ 2 audits futurs l'utilisent.

---

## Tableau récapitulatif des propositions

| Concept GSTACK | Verdict | Effort | Impact SDLC | Sprint cible |
|---|---|---|---|---|
| ETHOS.md (philosophie builder) | IMPORTER | S | STANDARDS.md §Philosophie | Si partage externe |
| Decision log structuré (CLI concept) | IMPORTER | XS | 01-Claude-md-TEMPLATE + 07-DECISIONS | Immédiat |
| Spec cinq phases (Technical gate) | IMPORTER | XS | 04-sprint-PDR-TEMPLATE | Immédiat |
| Template generation (.tmpl→.md) | IMPORTER | — | §Signaux faibles ROADMAP | Futur |
| Rôles spécialisés distincts | INVESTIGUER | S | 03-wrap-up §0f | Après test M |
| AutoPlan (pipeline automatisé) | INVESTIGUER | M | 04-sprint-PDR §4d | Après rôles |
| Revue cross-modèle (/codex) | INVESTIGUER | S | 03-wrap-up §0f | Si Codex disponible |
| Learn system | MERGER | XS | 01-Claude-md §Démarrage | Prochain sprint |
| Context-save (WIP commits structurés) | MERGER | XS | 03-wrap-up §SESSION_BRIDGE | Prochain sprint |
| Timeline events (retro tendances) | INVESTIGUER | S | 09-retrospective | Si cadence > 1/sem |
| Safety freeze (/freeze concept) | INVESTIGUER | S | 08-hooks-TEMPLATE | Si besoin identifié |
| Diataxis documentation | INVESTIGUER | S | doc/ + P-32 | Si documentation externe |
| Retro global | INVESTIGUER | XS | 09-retrospective | Si > 1 projet actif |
| Conductor (sessions parallèles) | REJETER | — | — | Jamais |
| Browser automation | REJETER | — | — | Jamais |
| Proactive skill suggestions | REJETER | — | — | Jamais |
| Taste memory (design) | REJETER | — | — | Jamais |
| iOS QA | REJETER | — | — | Jamais |
| Redaction guard | REJETER | — | — | Hors scope |
| Multi-provider (Codex/Cursor/etc.) | REJETER | — | — | Jamais |
