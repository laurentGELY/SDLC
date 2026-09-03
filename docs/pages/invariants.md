# Les quatre invariants

Quatre principes fondent le modèle. Toute évolution du toolkit doit les préserver — une évolution qui en viole un doit être **explicitement justifiée** dans le registre des décisions (`07-DECISIONS-SDLC.md`).

Ce sont les axiomes. Tout le reste — templates, skills, hooks — en découle.

> **Vus comme un harnais.** Chaque invariant est un principe classique d'ingénierie de harnais d'agent (*harness engineering*) : rendre le modèle fiable non pas en espérant qu'il « fasse bien », mais en construisant autour de lui un cadre qui rend l'échec coûteux et la dérive impossible. Les quatre, ensemble, transforment un agent capable en un agent *gouvernable*.

| Invariant | Principe de harnais | Ce que ça neutralise |
|-----------|---------------------|----------------------|
| INV-1 · Vérification exécutable | Boucle de contrôle fermée | L'agent qui déclare « terminé » sur une estimation |
| INV-2 · Circuit fermé | Zéro état implicite | Le comportement non écrit, non reproductible |
| INV-3 · Contexte chirurgical | Budget de contexte | La fenêtre saturée qui dilue l'attention |
| INV-4 · Boucle de rétroaction | Un harnais qui apprend | L'erreur qui se répète faute de trace |

---

## INV-1 · Vérification exécutable

> Tout plan de test contient une **commande exacte**, jamais une description.

Claude itère seul jusqu'à ce que la commande passe. Il ne déclare pas « terminé » sur une estimation. Un test qui dit *« vérifier que X fonctionne »* n'est pas un test — il faut la commande précise qui le prouve.

**Clause anti-complaisance :** ne jamais marquer un test OK sans avoir vu la sortie réelle de la commande dans la session en cours. Un souvenir, une supposition ou une inférence ne sont pas des vérifications.

## INV-2 · Circuit fermé

> Toute règle implicite devient explicite.

Si Claude applique un comportement non documenté, ce comportement doit devenir l'un des trois :

- un **hook** (blocage mécanique avant exécution),
- une entrée dans **`DECISIONS.md`**,
- ou une règle dans **`Claude.md`**.

Rien ne reste implicite. C'est ce qui rend une session reproductible : ce qui n'est pas écrit n'existe pas opérationnellement.

## INV-3 · Contexte chirurgical

> Claude charge uniquement les fichiers listés dans le `§Handoff`, pas le repo entier.

Le `§Handoff` d'un sprint est la liste **exhaustive et suffisante** pour démarrer. Chargement en deux temps — *immédiat* (lu d'emblée) et *différé* (grep d'abord, lecture seulement si pertinent). Voir [Contexte chirurgical & tokens](#contexte).

## INV-4 · Boucle de rétroaction

> Toute observation terrain a un chemin vers une règle permanente.

Le circuit : **incident → `LESSONS_LEARNED` → `/retrospective` → hook ou règle**. Aucune observation ne se perd dans un fichier sans suite. C'est ce qui fait que le modèle s'améliore au lieu de stagner. Voir [La boucle de rétroaction](#boucle).

---

## Pourquoi des invariants plutôt que des règles

Les règles changent à chaque sprint. Les invariants, non. En ancrant le modèle sur quatre principes stables, on obtient un critère simple pour trancher toute évolution : *« ce changement respecte-t-il les quatre invariants ? »*. Si oui, il est cohérent avec l'esprit du modèle. Si non, il faut le justifier — et cette justification devient elle-même une trace (`M-XXXX-NN`) dans le [registre des décisions](#decisions).
