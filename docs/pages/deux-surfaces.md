# Amont / aval : deux surfaces

Le modèle sépare le travail en **deux surfaces distinctes**, parce qu'elles n'ont pas le même rapport à la vérité (décision `M-SCOPE-04`).

---

## La ligne de partage

```
┌─────────────────────────────────────────────────────────┐
│  AMONT — Claude.ai (optionnel)                           │
│  Idéation · PRD · décisions d'architecture               │
│  Instruit par 10-AMONT-TEMPLATE.md                       │
│  ⚠ Ne vérifie RIEN contre du code réel — pas d'accès repo │
└─────────────────────────────────────────────────────────┘
                          │
             alimente specs/SPEC.md + premier PDR
                          ▼
┌─────────────────────────────────────────────────────────┐
│  AVAL — Claude Code (gouverné)                           │
│  À partir du Sprint 0                                     │
│  ✓ Seul endroit où une hypothèse est confrontée au code  │
│    réel (HALT-ARCH, §Dépendances vérifiées)              │
└─────────────────────────────────────────────────────────┘
```

## Amont — Claude.ai

La phase amont est **optionnelle**. Dans un Project Claude.ai dédié, chargé avec `10-AMONT-TEMPLATE.md` en Project Knowledge, on fait l'idéation, le cadrage produit (PRD) et les décisions d'architecture.

Le document produit alimente directement `specs/SPEC.md` et le premier PDR du Sprint 0. Un projet sans phase amont formalisée crée simplement `specs/SPEC.md` from scratch au bootstrap (`M-SCOPE-02`).

**Point clé :** cette surface ne peut rien vérifier. Elle n'a pas accès au repo. Tout ce qu'elle produit est une hypothèse tant que Claude Code ne l'a pas confrontée au code.

## Aval — Claude Code

À partir du Sprint 0, Claude Code prend le relais. C'est **le seul endroit où la vérité du code peut être vérifiée** : une commande s'exécute, un fichier existe ou non, un test passe ou échoue.

C'est pourquoi les garde-fous les plus stricts vivent ici : le point d'arrêt `HALT-ARCH` (convention contredite), la vérification des dépendances, la clause anti-complaisance sur les tests. Voir [Garde-fous : HALT & verdicts](#garde-fous).

## Pourquoi cette séparation compte

Confondre les deux surfaces, c'est traiter une hypothèse d'amont comme un fait acquis. Le modèle impose une règle de traçabilité : **toute affirmation factuelle doit être citable** — chemin:ligne, sortie de commande, entrée git. Les formulations non vérifiables (« probablement », « devrait », « en principe ») sont proscrites côté aval. C'est là que l'amont se fait corriger par le réel.
