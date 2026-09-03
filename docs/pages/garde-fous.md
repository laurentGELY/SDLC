# Garde-fous : HALT & verdicts

Le modèle ne fait pas que recommander — il **arrête**. Deux mécanismes complémentaires : les conditions `HALT` (blocages logiques pendant le raisonnement) et le *verdict gate* (porte de qualité avant l'aval).

---

## Les règles absolues

Le socle non négociable de `Claude.md`. **Ne jamais :**

- écrire du code avant l'aval explicite de l'utilisateur ;
- sauter l'analyse, même pour un petit fix ;
- conclure sans preuves observables (logs, sorties, commandes) ;
- modifier un fichier de config sans noter la valeur précédente ;
- lancer un refactor hors périmètre sans validation explicite.

## Les conditions HALT

Un `HALT`, c'est un arrêt immédiat : l'agent s'arrête et attend l'humain. Ce sont des **conditions logiques détectées pendant le raisonnement** — à distinguer des hooks bash, qui bloquent des commandes dangereuses avant exécution. Les deux sont complémentaires.

| Condition | Déclencheur |
|-----------|-------------|
| **HALT-DEP** | Dépendance requise absente du PDR, détectée avant d'installer ou d'adapter le code |
| **HALT-3X** | Même test échoue 3 fois consécutives sans diagnostic clair → lancer `/diagnostic` |
| **HALT-ARCH** | Convention du modèle (numérotation, structure) contredite par le changement proposé |
| **HALT-SCOPE** | Périmètre des fichiers dépasse significativement le `§Portée` du PDR |
| **HALT-TIMEOUT** | Commande sans sortie depuis > 60s → préfixer avec `timeout 60`. Exit code 124 → HALT |

## Le verdict gate

Toute analyse se termine par un verdict explicite qui conditionne la suite :

- **PASS** — analyse complète, prêt à coder sans réserve.
- **CONCERNS** — prêt à coder, mais ≥ 1 point de vigilance signalé explicitement (risque accepté, pas un bloquant).
- **FAIL** — analyse incomplète ou bloquant non résolu. Interdiction de demander l'aval : compléter l'analyse d'abord.

C'est une porte à sens unique : on ne franchit pas l'étape « code » sans un PASS ou un CONCERNS assumé.

## L'Adversarial Review

Pour les sprints de **Taille M ou L**, `/wrap-up §0f` déclenche une relecture adverse en 2-3 couches, avant le commit :

- **Couche 1 — Blind Hunter** : relire uniquement le `git diff`, sans rouvrir le fil de conversation. Chercher incohérences, doublons, contenu fictif présenté comme un fait.
- **Couche 2 — Edge Case Hunter** : relire le même diff avec accès complet au projet. Chercher divergences avec les conventions, références cassées.
- **Couche 3 — Acceptance Auditor** *(si fichier registre touché)* : vérifier que chaque critère d'acceptation est *réellement* satisfait, pas seulement vraisemblable.

Chaque *finding* est trié : 🔴 décision requise · 🟡 patch immédiat · 🔵 différé · ⚪ écarté. Un seul 🔴 bloque le commit jusqu'à résolution ou aval explicite.

## L'esprit commun

Tous ces garde-fous partagent une logique : **rendre coûteux le fait de sauter une étape**. Un agent laissé libre optimise pour « avoir l'air fini ». Ces mécanismes déplacent l'optimisation vers « être réellement fini et vérifié » — c'est `INV-1` et `INV-2` transformés en points d'arrêt concrets.
