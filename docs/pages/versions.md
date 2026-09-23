# Historique des versions

Le modèle a été construit de façon incrémentale, sprint après sprint — chaque version résolvant un manque observé sur le terrain. Cet historique est lui-même un livrable de `INV-4` : presque chaque ligne vient d'une observation remontée par la [boucle de rétroaction](#boucle).

---

## Les grandes étapes

| Version | Date | Apport principal |
|---------|------|------------------|
| **v1.0** | 29/05/2026 | Bootstrap initial — 7 fichiers |
| **v1.1** | 30/05/2026 | Bilan de session · auto-exécution · `DIAGNOSTIC_CMDS` obligatoire |
| **v1.2** | 30/05/2026 | Hooks · boucle `LESSONS_LEARNED → hook` · Given/When/Then PDR · skill retrospective |
| **v1.3** | 03/06/2026 | Skill `/sdlc-sync` · `MODE-OPERATOIRE.html` · mémoire de sprint intra-session |
| **v1.4** | 04/06/2026 | Restructuration `doc/` — `SPEC.html` + `MODE-OPERATOIRE.html` |
| **v1.5** | 05/06/2026 | Init de sprint : spec + mémoire + plan de développement (séquence 4a→4d) |
| **v1.6** | 11/06/2026 | Annotations sprint-memory · Handoff eager/lazy · index rétrospective structuré |
| **v1.7** | 11/06/2026 | Vérification externe si confiance FAIBLE · PostToolUse (lint + post-commit changelog) |
| **v1.8** | 14/06/2026 | Wrap-up robustesse : revue objectif §0e, signaux rétrospectifs §0a, SESSION_BRIDGE accumulatif |
| **v1.9** | 14/06/2026 | `CLAUDE_PROJECT` versionné · volumétrie minimum du plan de test · observabilité en checklist |

## L'import BMad (SDLC-07 → 13)

Une série de sprints d'audit et d'import a confronté le modèle à d'autres méthodes (BMad, GSD, GStack, Superpowers) pour en absorber les meilleurs patterns :

| Version | Apport |
|---------|--------|
| **+SDLC-07** | Bloc `HALT` (5 conditions) · 3 principes anti-biais · règle « affirmation citable » |
| **+SDLC-08** | Modes Index-guidé + seuil de délégation sous-agent · clause anti-complaisance · Significant Discovery Alert |
| **+SDLC-09** | Adversarial Review 3 couches · verdict gate `PASS/CONCERNS/FAIL` |
| **+SDLC-10** | `ROADMAP.md` créé · pas de modes nommés dans `§Rôle` |
| **+SDLC-11** | Skill `/help` — recap lecture seule |
| **+SDLC-12** | Phase amont — `10-AMONT-TEMPLATE.md`, Project Claude.ai dédié |
| **+SDLC-13** | `specs/SPEC.md` du toolkit lui-même (*dogfooding*) |

## L'instrumentation (SDLC-22 → 23)

| Version | Apport |
|---------|--------|
| **+SDLC-22** | Instrumentation de conso token réelle — `sdlc-token-usage.sh` · métriques `M1`/`M2` en rétrospective |
| **+SDLC-23** | Hook `PreCompact` × sprint-memory — checkpoint automatique avant compaction (7ᵉ type `CHECKPOINT`) |

## Les audits externes et le passage à v2.0 (SDLC-24 → 25)

Une deuxième vague de confrontation à l'extérieur, plus systématique que l'import BMad initial : trois méthodes concurrentes (GSD, GSD-lite, GSTACK) auditées et passées au tri, avant que le modèle ne publie sa propre documentation.

| Version | Apport |
|---------|--------|
| **+SDLC-24** | Fix schéma JSON du hook `PreToolUse` (`data.get('tool_input')` au lieu de `input`) — incident `M-HOOKS-05` / `M-TMPL-04` |
| **Audit-GSD-lite** *(Spike)* | Audits externes GSD-full et GSD-lite vs SDLC — cartographie, propositions A-G, concepts exportables (Journalism Standard, STATELESS HANDOFF) |
| **GSD-V1** | Import GSD Vague 1 — 6 patterns friction nulle : STATELESS HANDOFF, goal-backward, SPIDR, type `Seed`, permission `/fast` |
| **v2.0 / GSD-V2** | Import GSD Vague 2 — graduation automatique des patterns en rétrospective, SESSION_BRIDGE hot/cold (§Actif/§Archive), hypothesis tracking conditionnel |
| **Audit-GSTACK** | Audit externe GSTACK (Garry Tan / YC, 59 skills) vs SDLC — adoption sélective, 4 recommandations XS/S retenues |
| **+SDLC-25** | Migration `doc/` → `docs/`, publication de ce site sur GitHub Pages (`M-ARCH-09`) |

## Se vérifier et se durcir (ECO-1 → SDLC-32)

Une dernière phase, tournée vers la fiabilité du modèle lui-même : un script exécutable qui contrôle sa cohérence, des règles de rédaction et de qualité chiffrées, et des rétrospectives qui graduent les patterns récurrents en règles permanentes.

| Version | Apport |
|---------|--------|
| **v2.0+ECO-1** | `sdlc-validate.sh` — vérification exécutable du modèle : 8 contrôles structurels en registre extensible, lecture seule (`M-PROC-40`) |
| **+ECO-2** | Rédaction des templates — la description d'un skill énonce son déclenchement, jamais la séquence d'étapes ; la forme de la règle dépend du type d'échec visé (`M-TMPL-05`) |
| **+SDLC-26** | `/retrospective` (SDLC-21→ECO-2) — le pattern `LL-T04` (7 occurrences) gradué en règle permanente : vérification factuelle avant analyse (`M-PROC-41`) |
| **+ECO-3** | `STANDARDS §Barre qualité` — seuils chiffrés, plancher anti-affaiblissement, cliquet de contexte (M1, 10 %), exceptions datées (`M-PROC-42`) |
| **+ECO-4** | Durcissement du PDR — `§Pas de placeholders`, auto-revue du plan en 3 passes, champ `[coût si faux]` sur les décisions, précédence ledger/git après compaction (`M-PROC-43`) |
| **+ECO-5** | Pattern `.claude/rules/` documenté pour les projets cibles ; hook `SessionStart` écarté après vérification factuelle (`M-TMPL-06`) |
| **+SDLC-27** | `/retrospective` (ECO-3→ECO-5) — garde-fou de traçabilité : avertissement si `sprint-memory.md` est resté vide malgré un diff conséquent (`M-PROC-44`) |
| **+SDLC-28** | `sprint-memory.md` documenté comme mécanisme de reprise après coupure ; deux citations fautives corrigées |
| **+SDLC-29** | `12-audit-externe-TEMPLATE.md` — gabarit d'audit externe : 7 sections, 6 axes, verdicts `IMPORTER/REJETER/INVESTIGUER/MERGER` (`M-TMPL-07`) |
| **+SDLC-30** | Rattrapage des deux livrables HTML (`SPEC.html`, `MODE-OPERATOIRE.html`), figés à v1.4 — et contrôle **C10** qui les surveille désormais : marqueur de version et carte des templates (`M-PROC-46`) |
| **+SDLC-31** | `/retrospective` — graduation `LL-T14` : tout total écrit dans un livrable est vérifié par commande, pas seulement une précondition d'analyse (`M-PROC-48`) |
| **+SDLC-32** | Rappel 4a-4d dans `04-sprint-PDR-TEMPLATE.md §Handoff` — clôt un `SDLC_CANDIDATE` de 3 mois et `LL-T05` (`M-TMPL-08`) |
| **+SDLC-Audit-Strands-Harness** | Audit externe Strands Harness (AWS, runtime d'agent) — premier audit au gabarit 12 ; la comparaison tranche d'abord *runtime vs gouvernance*, 3 recommandations sur 5 rejetées comme relevant du runtime |
| **C9** *(hors bump)* | `sdlc-validate.sh` contrôle désormais ce site : `docs/meta.json` doit égaler la version du README et `versions.md` mentionner le sprint courant (`M-PROC-45`) |

Le dernier item est né d'un constat : ce site est resté figé à SDLC-25 pendant neuf versions, sans que rien ne le signale. Le modèle applique sa propre règle — *toute règle implicite devient un contrôle exécutable* — à sa propre documentation.

## Ce que raconte cette progression

Cinq mouvements se lisent dans cet historique. D'abord **poser le socle** (v1.0→1.9) : règles, skills, boucle de rétroaction. Ensuite **se confronter à l'extérieur** (SDLC-07→13) : auditer d'autres méthodes et importer ce qui tient. Puis **s'instrumenter** (SDLC-22→23) : mesurer sa propre consommation, automatiser sa propre mémoire. Puis **se rendre public** (SDLC-24→25) : une deuxième vague d'audits externes, et la publication de ce site — le modèle documente maintenant sa propre trajectoire pour un lecteur externe, pas seulement pour lui-même. Enfin **se vérifier** (ECO-1→SDLC-32) : un script exécutable contrôle la cohérence du modèle, les règles de rédaction et de qualité se chiffrent — et le contrôle finit par surveiller jusqu'à la documentation publique qui l'avait laissé dériver.

C'est la trajectoire d'un système qui non seulement fonctionne, mais **s'observe fonctionner** — et se corrige en conséquence. Le meilleur argument pour le modèle, c'est que le modèle s'est construit lui-même selon ses propres règles.
