# Contexte chirurgical & tokens

L'invariant `INV-3` posé simplement : **charger uniquement ce qui est nécessaire, jamais le repo entier**. C'est à la fois une discipline de qualité (un contexte propre raisonne mieux) et une discipline économique (les tokens coûtent).

---

## Le §Handoff : la liste suffisante

Chaque sprint déclare un `§Handoff` — la liste exhaustive et suffisante des fichiers pour démarrer. Elle distingue deux régimes :

- **Chargement immédiat** — les fichiers lus d'emblée en début de session.
- **Chargement différé** — les fichiers qu'on **grep d'abord**, et qu'on ne lit entièrement que si le grep confirme leur pertinence.

Jamais de lecture préventive « au cas où ». Un fichier différé qu'aucun grep ne rend pertinent n'est jamais chargé.

## Les règles de frugalité

| Règle | Principe |
|-------|----------|
| **Grep avant lecture** | Tout fichier différé → grep ciblé avant de charger |
| **Index-guidé** | Fichier > ~200 lignes avec table des matières → grep dans l'index, charger seulement les sections pertinentes |
| **Délégation sous-agent** | Étape nécessitant > 5 fichiers simultanés, ou fichier > ~10K tokens → déléguer à un sous-agent qui retourne un résumé structuré (le brut n'entre jamais dans le contexte parent) |
| **Analyse en une passe** | Formuler toutes les questions avant de modifier |
| **Oracle en amont** | Toute question anticipable résolue avant le handoff — zéro recherche externe en session sauf blocage imprévu |
| **Batching XS/S** | Signaler les opportunités de fusionner des items indépendants de même taille touchant les mêmes fichiers |

## Mesurer, pas deviner

Cohérent avec `INV-1`, le modèle ne se contente pas de recommander la frugalité — il la **mesure**. Le script `sdlc-token-usage.sh` produit les totaux réels de consommation et une bucketisation par sprint (à partir de la mémoire de sprint). Ces métriques `M1`/`M2` remontent dans `/retrospective` (`M-PROC-36`), fermant la boucle : la frugalité devient un chiffre suivi dans le temps, pas une intention.

## Pourquoi ça compte pour la qualité

Un contexte saturé n'est pas seulement cher — il est **moins bon**. Plus le contexte contient de bruit, plus l'agent dilue son attention et perd le fil des contraintes réelles. Le chargement chirurgical est donc autant une décision d'ingénierie qualité qu'une optimisation de coût. C'est le pendant frugal de la [boucle de rétroaction](#boucle) : l'une capitalise l'expérience, l'autre préserve l'attention.
