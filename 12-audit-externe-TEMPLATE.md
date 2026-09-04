# Audit externe — Template · v1.0
<!-- Template SDLC v1.0 · Destination : guide toolkit — pas copié dans le projet cible -->
<!-- Usage : comparer le modèle SDLC à un framework/outil tiers. Checklist de sections
     obligatoires + format de verdict standardisé — pas une super-structure à enrichir.
     Origine : docs/AUDIT-EXTERNE-gstack-vs-sdlc.md §7 (P-22), après 3 audits externes
     ayant chacun réinventé leur propre format (GSD, GSD-lite, Superpowers). -->

# Audit externe — [FRAMEWORK] vs Modèle SDLC

## 1. Cartographie [FRAMEWORK]
Structure, concepts clés, mécanismes propres au framework audité.

## 2. Cartographie SDLC (rappel bref)
Rappel court des mécanismes SDLC pertinents pour la comparaison — pas une
redite complète de `00-CONTEXT.md`/`specs/SPEC.md`.

## 3. Analyse comparative
Tableau comparatif — 6 axes obligatoires (adapter le contenu, garder les axes) :

| Axe | [FRAMEWORK] | SDLC | Verdict |
|---|---|---|---|
| **Gouvernance de session** | | | |
| **Séparation des rôles** | | | |
| **Traçabilité et documentation** | | | |
| **Scalabilité** | | | |
| **Overhead** | | | |
| **Récupération de session** | | | |

## 4. Recommandations
Format étiqueté obligatoire — un verdict par proposition, parmi
`IMPORTER/REJETER/INVESTIGUER/MERGER` :
- **IMPORTER** — adopter tel quel ou adapté, fichier cible + effort estimé
- **REJETER** — écarté, raison en 1 ligne
- **INVESTIGUER** — valeur potentielle mais non tranchée, condition de déclenchement
- **MERGER** — fusionner avec un mécanisme SDLC existant plutôt qu'ajouter

## 5. Nouvelles idées
Lacunes SDLC que ce framework donne à voir, indépendamment de ses propres mécanismes.

## 6. Verdict synthétique
Intégration partielle vs globale — conclusion en 3-5 lignes maximum.

## 7. Sur ce template (si applicable)
Feedback sur le template lui-même — sections manquantes, axes non pertinents
pour ce framework, etc. Alimente une future révision de
`12-audit-externe-TEMPLATE.md` si le retour est récurrent (≥ 2 audits).
