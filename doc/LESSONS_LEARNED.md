# LESSONS_LEARNED — Modèle de gouvernance SDLC (projet toolkit)
<!-- Créé Sprint SDLC-14 (self-bootstrap + rattrapage) — 8 entrées rétroactives SDLC-07→14 -->

## §Index des patterns

| ID | Pattern | Occurrences | Sprints | Statut | Décision |
|----|---------|-------------|---------|--------|----------|
| LL-T01 | Sprint méta sans entrée DECISIONS/CHANGELOG dédiée au commit | 3 | SDLC-07, 08, 09 | Partiellement résolu | Discipline systématique restaurée depuis SDLC-10 (vérifié : CHANGELOG reprend une entrée dédiée par sprint dès SDLC-10). Backfill historique des entrées manquantes pour SDLC-07/08/09 **non effectué** — reste une action ouverte (voir `doc/DIAGNOSTIC_CMDS.md`) |
| LL-T02 | Vérifier qu'un mécanisme ou une précondition n'est pas déjà couvert/vrai avant de l'ajouter/le présumer | 2 | SDLC-12, SDLC-14 | Actif — principe à appliquer systématiquement | Aucune action — vigilance continue |
| LL-T03 | Poser les sous-décisions d'architecture explicitement avant d'écrire un PDR à enjeu | 2 | SDLC-04 (HALT), SDLC-09 (Adversarial Review) | Confirmé | Pattern à reproduire pour tout sprint Taille M/L touchant l'architecture |
| LL-T04 | Vérifier par commande exécutable toute précondition factuelle énoncée par un PDR avant de l'exécuter — y compris du contenu "rétroactif" fourni comme acquis | 1 | SDLC-14 | Nouveau | Appliqué nativement ce sprint (citabilité `Claude.md §Rôle` étendue au contenu du PDR lui-même, pas seulement au code/repo) — à reproduire systématiquement |

## §Entrées par sprint

### Sprint SDLC-07 — 18/06/2026 — HALT + Stronghold first + citabilité
**Code :** N/A — gouvernance uniquement
**Processus :** Bon réflexe de proposer deux options (A/B) pour HALT plutôt
que trancher seul. Entrée `07-DECISIONS-SDLC.md`/`CHANGELOG.md` manquante
au moment du commit — gap découvert et caractérisé en SDLC-14.
**Lien pattern :** nouveau LL-T01
**Action proposée :** discipline systématique (entrée registre + changelog
dans chaque PDR) → décision : ✅ appliquée depuis SDLC-10

### Sprint SDLC-08 — 18/06/2026 — Qualité & continuité (5 patterns groupés)
**Code :** N/A
**Processus :** Regroupement de 5 patterns par destination commune
(`Claude.md §Tokens/§Test/§Mémoire`, `retrospective §Étape 2b`) en un
seul sprint M a réduit la fragmentation vs 5 sprints XS séparés. Décision
P-10 (absorption dans SD-1/SD-5) documentée dans le PDR lui-même plutôt
que dans le registre central — même gap traçabilité que SDLC-07.
**Lien pattern :** confirme LL-T01
**Action proposée :** aucune nouvelle — déjà couverte par la correction
SDLC-10+ → décision : ✅

### Sprint SDLC-09 — 18/06/2026 — Adversarial Review (3 couches)
**Code :** N/A
**Processus :** 3 sous-décisions d'architecture (où ça vit / profondeur /
cécité du Blind Hunter) posées explicitement en discussion avant
d'écrire le PDR — a évité un PDR à réécrire après coup.
**Lien pattern :** nouveau LL-T03 (confirme un pattern déjà observé en
amont sur HALT)
**Action proposée :** reproduire ce pattern pour tout sprint M/L à enjeu
architectural → décision : ✅ (appliqué nativement depuis, voir SDLC-12)

### Sprint SDLC-10 — 18/06/2026 — Rangement catalogue BMad + fermeture Q4
**Code :** N/A
**Processus :** Création de `doc/ROADMAP.md` pour le projet toolkit
lui-même (dogfooding) a révélé que le projet n'appliquait pas sa propre
structure à lui-même — point de départ de SDLC-13 et SDLC-14. Une
manipulation `str_replace` a fait disparaître un en-tête de section par
erreur de chevauchement de blocs — corrigé immédiatement après détection.
**Lien pattern :** aucun nouveau
**Action proposée :** toujours re-vérifier (`view`) un fichier après
`str_replace` avant d'enchaîner une autre édition sur la même zone →
décision : ✅ bonne pratique, pas de mécanisme formel nécessaire

### Sprint SDLC-11 — 18/06/2026 — Skill /help
**Code :** N/A
**Processus :** Taille initialement qualifiée "XS" s'est révélée "S" une
fois la gouvernance comptée (5 fichiers à mettre à jour en plus du
skill). Déclaré honnêtement dans le PDR plutôt que sous-estimé, avec une
option de scope réduit documentée.
**Lien pattern :** aucun nouveau
**Action proposée :** continuer à distinguer taille du "cœur du
changement" vs taille "gouvernance associée" dans les PDR futurs →
décision : ⏳

### Sprint SDLC-12 — 18/06/2026 — 10-AMONT-TEMPLATE.md
**Code :** N/A
**Processus :** Conception initiale prévoyait un marqueur de provenance
+ modifications de `Claude.md`/`wrap-up`. Remise en question a révélé que
`HALT-ARCH` et `§Dépendances vérifiées` couvraient déjà le besoin sans
rien ajouter — le marqueur aurait dupliqué un comportement déjà
universel.
**Lien pattern :** nouveau LL-T02
**Action proposée :** vérifier systématiquement qu'un mécanisme proposé
n'est pas déjà couvert avant de l'ajouter, y compris en conception de
gouvernance (pas seulement en diagnostic de code) → décision : ⏳ —
vigilance continue, pas de mécanisme formel possible

### Sprint SDLC-13 — 18/06/2026 — specs/SPEC.md (dogfooding)
**Code :** N/A
**Processus :** Instruction explicite de vérifier `§Modules` contre l'état
réel des fichiers (`ls *.md`) plutôt que recopier le squelette fourni
dans le PDR — applique "Stronghold first" à la documentation du système
par lui-même, pas seulement au diagnostic de code applicatif.
**Lien pattern :** confirme la valeur de P-13 (Stronghold first, importé
SDLC-07) au-delà de son usage prévu initial
**Action proposée :** aucune — confirmation d'un pattern déjà acquis →
décision : ✅

### Sprint SDLC-14 — 19/06/2026 — Audit du gap SDLC-14 + self-bootstrap (fusionnés)
**Code :** N/A — gouvernance uniquement
**Processus :** Le PDR reçu en conversation (nommé "SDLC-15") présupposait
qu'un sprint SDLC-14 ("Audit et rattrapage gouvernance") avait déjà eu
lieu, et fournissait son contenu rétroactif comme un fait acquis. La
vérification de précondition explicitement demandée par le PDR lui-même
(`grep "M-PROC-26\|Rattrapage" 07-DECISIONS-SDLC.md`) a été exécutée
avant de démarrer plutôt que présumée vraie — elle a révélé que SDLC-14
n'existe ni en commit git, ni en CHANGELOG, ni en DECISIONS. Décision
utilisateur (option choisie) : renuméroter ce sprint en SDLC-14 réel,
fusionnant audit/rattrapage et bootstrap, plutôt que d'écrire une entrée
fictive dans ce fichier.
**Lien pattern :** nouveau LL-T04 (citabilité étendue au contenu du PDR
lui-même, pas seulement au code/repo) · confirme LL-T02 (vérifier avant
de présumer) · caractérise LL-T01 comme partiellement résolu (discipline
oui, backfill historique non — voir `doc/DIAGNOSTIC_CMDS.md`)
**Action proposée :** vérifier toute précondition factuelle explicite
d'un PDR par commande exécutable avant de l'exécuter, y compris le
contenu "rétroactif" fourni comme acquis → décision : ✅ appliqué
nativement ce sprint, à reproduire systématiquement

---

## §Métriques (au bootstrap rétroactif, Sprint SDLC-14)
- Sprints couverts : SDLC-07 à SDLC-14 (8 sprints)
- Dernière `/retrospective` : aucune — **seuil dépassé**, à déclencher
  immédiatement après ce sprint (SDLC-15)
- HOOK_CANDIDATE en attente : 0
- SDLC_CANDIDATE en attente : 0
- Patterns actifs : LL-T02 (vigilance continue), LL-T03 (à reproduire),
  LL-T04 (nouveau, à reproduire)
- Patterns partiellement résolus : LL-T01 (backfill historique
  SDLC-07/08/09 reste une action ouverte, non traitée dans ce sprint)
