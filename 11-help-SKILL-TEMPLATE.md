# help — SKILL
<!-- Template SDLC v1.9 · Destination : .claude/skills/help/SKILL.md dans le repo cible -->
<!-- Générique — copier tel quel, zéro adaptation -->

Recap de contexte à la demande. Lecture seule — zéro écriture, zéro effet
de bord, zéro suggestion. Rapporte l'état existant, ne décide rien.

**Principe d'exécution** : agréger 3 sources déjà existantes, ne rien
inventer. Si une source est absente, le signaler — ne pas la remplacer
par une inférence.

---

## Étape unique — Lecture et synthèse

```bash
# 1. Où on en est
cat .claude/sprint-memory.md 2>/dev/null || echo "— sprint-memory vide ou absent"

# 2. Où on s'en va (si sprint-memory vide, §Now sert aussi de "où on en est")
grep -A 5 "## ▶ Now" doc/ROADMAP.md 2>/dev/null
grep -A 8 "## ⏭ Next" doc/ROADMAP.md 2>/dev/null

# 3. Outils disponibles — lire la table de classification
grep -A 8 "Classifier le travail" Claude.md 2>/dev/null
```

Produire le recap :

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 OÙ ON EN EST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Si sprint-memory.md non vide :]
Sprint actif : [titre extrait de la 1ère ligne]
Dernière entrée : [HH:MM TYPE — résumé]

[Si sprint-memory.md vide ou absent :]
Aucun sprint actif. Dernier état connu — doc/ROADMAP.md §Now :
[contenu §Now]

➡️  OÙ ON S'EN VA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
doc/ROADMAP.md §Next :
[contenu §Next — ou "— vide, rien de planifié"]

🛠  OUTILS DISPONIBLES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/wrap-up        → clôture de sprint, en fin de sprint
/retrospective  → analyse de patterns, toutes les ~5 sprints ou sur incident
/sdlc-sync      → alignement gouvernance, quand le modèle SDLC évolue
/diagnostic     → bug ou comportement inattendu, sur incident

Type de travail en cours → flux correspondant :
[copier la ligne pertinente du tableau Claude.md §Démarrage si un sprint
 est actif, sinon omettre ce bloc]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Si une source est absente** (ex : `doc/ROADMAP.md` n'existe pas encore) :
le signaler explicitement dans le bloc correspondant — ne jamais inventer
un état plausible à sa place.

---

## Ce que /help ne fait pas

- Ne suggère pas de prochaine action ("tu devrais...") — affiche les faits,
  laisse l'humain décider
- Ne lit pas l'état git — seulement les artefacts de gouvernance
- N'écrit dans aucun fichier
- Ne remplace pas `/diagnostic` (réactif, sur incident) ni `/retrospective`
  (analyse de patterns) — `/help` est un point d'entrée, pas une analyse
