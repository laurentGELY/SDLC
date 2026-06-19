# diagnostic — SKILL
<!-- Projet toolkit SDLC · adapté, pas un template générique · créé Sprint SDLC-14 -->

Sur incident : un critère d'acceptation grep échoue de façon inattendue,
une convention (numérotation, structure) semble incohérente entre
fichiers, ou un PDR exécuté produit un résultat différent de l'attendu.

## Commandes de diagnostic

```bash
# Cohérence numérotation des fichiers
ls *.md | grep -E "^[0-9]" | sort

# Incohérence entre 00-CONTEXT.md §Carte des fichiers et fichiers réels
diff <(ls *.md | sort) <(grep -oE '`[0-9]+[a-z]?-[a-zA-Z-]*\.md`' 00-CONTEXT.md | tr -d '`' | sort -u)

# Dernières décisions enregistrées
tail -50 07-DECISIONS-SDLC.md

# État du dernier sprint (si interrompu)
cat .claude/sprint-memory.md 2>/dev/null || echo "vide"

# Historique récent
git log --oneline -10
```

Si l'incident révèle un gap de process (comme SDLC-14) → consigner dans
`doc/LESSONS_LEARNED.md`, pas seulement corriger silencieusement.
