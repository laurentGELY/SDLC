# Démarrage rapide

Deux points d'entrée selon la situation : un **nouveau projet** à bootstrapper, ou un **projet existant** à aligner.

---

## Nouveau projet

```bash
# 1. Cloner le toolkit
git clone <ce-repo> sdlc-toolkit

# 2. Depuis la racine du nouveau projet (git init déjà fait)
bash /chemin/vers/sdlc-toolkit/sdlc-init.sh "Nom du projet"

# 3. Ouvrir Claude Code et compléter la gouvernance
#    (§Rôle, §Limites bash, SPEC.md, skill diagnostic)
```

Le script `sdlc-init.sh` copie les templates aux bons emplacements et crée les fichiers de gouvernance depuis zéro (`CHANGELOG.md`, `LESSONS_LEARNED.md`, `DIAGNOSTIC_CMDS.md`…). La procédure complète est décrite dans `docs/MODE-OPERATOIRE.html §Initialiser`.

## Projet existant à aligner

D'abord, détecter la situation :

```bash
grep "SDLC version" Claude.md STANDARDS.md 2>/dev/null || echo "ABSENT"
```

| Résultat | Action |
|----------|--------|
| Aucun fichier | → `sdlc-init.sh` (nouveau projet) |
| `ABSENT` | → `/sdlc-sync` dans Claude Code (delta complet) |
| `SDLC version : vX.Y` | → `/sdlc-sync` (delta vX.Y → courant) |
| Version courante | Rien à faire ✓ |

Puis, dans Claude Code du projet cible :

```bash
/sdlc-sync
```

---

## Ce qui est créé dans le projet cible

| Source (toolkit) | Destination (projet) |
|------------------|----------------------|
| `01-Claude-md-TEMPLATE.md` | `Claude.md` |
| `02-STANDARDS-TEMPLATE.md` | `STANDARDS.md` |
| `03-wrap-up-SKILL-TEMPLATE.md` | `.claude/skills/wrap-up/SKILL.md` |
| `04-sprint-PDR-TEMPLATE.md` | `specs/sprint-template.md` |
| `04b-sdlc-sync-SKILL-TEMPLATE.md` | `.claude/skills/sdlc-sync/SKILL.md` |
| `05-ROADMAP-TEMPLATE.md` | `docs/ROADMAP.md` |
| `08-hooks-TEMPLATE.md` | `.claude/hooks/` + `settings.json` |
| `09-retrospective-SKILL-TEMPLATE.md` | `.claude/skills/retrospective/SKILL.md` |
| *(from scratch)* | `CHANGELOG.md`, `LESSONS_LEARNED.md`, `DIAGNOSTIC_CMDS.md`, `specs/SPEC.md` |

Le [catalogue complet des templates](#templates) détaille chacun de ces fichiers et l'adaptation attendue au bootstrap.

## Les skills disponibles ensuite

| Commande | Quand | Fréquence |
|----------|-------|-----------|
| `sdlc-init.sh` *(script bash, pas un skill)* | Repo vide — bootstrap complet | Une fois par projet |
| `/sdlc-sync` | Aligner sur une version plus récente | À chaque évolution du modèle |
| `/wrap-up` | Clôture de sprint | Fin de chaque sprint |
| `/retrospective` | Analyse de patterns sur N sprints | ~5 sprints ou incident |
| `/diagnostic` | Bug ou comportement inattendu | Sur incident |
| `/help` | Recap où on en est / outils disponibles | En reprise de session |
