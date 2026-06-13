0/ transformer SDLC en harness engineering.
Importer le savoir de JobSearch

1/ Modifs sport
1.1 Verfification de la description du projet et des files accessibles au projet (update OU liste si nouveau).

1.2 test: alarme cycle complet mais données insufisantes pour tester toutes les fonctionalités (ex. 0 lettres ou offres d'emplois scannées...)


1.3 02-STANDARDS-TEMPLATE
"## Observabilité

<!-- [→ ADAPTER] Ajuster selon la nature du système -->"
TROP VAGUE??

1.4 comportement si pas d ememoire de sprint
"## 0a. Lire la mémoire sprint
```bash
cat .claude/sprint-memory.md 2>/dev/null || echo "— aucun fichier mémoire"
```
Si le fichier existe → source de vérité prioritaire `[✓ mémoire]` pour reconstruire le bilan."
EXISTE PAS? ... alarme ??

1.5 revue honnette et argumentée de l'objectif
Wrap-up : ajouter une revue honnette et argumentée de l'objectif de sprint (issu du PDR)?

1.6 Question rétrospective: 
+= Proposer des reponses fonction memoire du sprint?

1.7 Vérifier / crtiquer enforcment pour
"
**`specs/Sprints/sprint-N-slug.md`** — obligatoire, auto-exécuté :
Vérifier que le fichier existe (créé en étape 4a du démarrage).
Si absent : signaler l'anomalie explicitement — `⚠️ specs/Sprints/sprint-N-slug.md absent`.
Si présent : compléter la section §Corrections ajustées vs spec si ≥ 1 divergence par rapport à la spec initiale.
Si aucune divergence : confirmer explicitement "✅ spec sprint — aucune correction ajustée"."
-> fonctionne encore???

1.8 ## Étape 5 — Amorce session suivante

"Générer un bloc compact à coller en début de prochaine session :"
-> mettre ailleurs pour perenité ??

1.9 ? comment compacter changelog, etc.?
2.0 un skill/chat verif/audit /ecart
2.1 idem update
2.2 reflexion generique critique plutot que de rendre "vide"


