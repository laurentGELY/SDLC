# DIAGNOSTIC_CMDS — Projet toolkit SDLC
<!-- Créé Sprint SDLC-14 (self-bootstrap) — voir STANDARDS.md §Règles d'archivage -->

## Symptôme : un livrable HTML réécrit passe tous les greps de critère d'acceptation mais casse le rendu (balise non fermée, grille déséquilibrée)
Date : 21/09/2026 (Sprint SDLC-30, rattrapage `SPEC.html`/`MODE-OPERATOIRE.html`)
Commande : équilibre des balises — `python3 -c "from html.parser import HTMLParser; ..."` (voir `sdlc-validate.sh` pour le motif d'un contrôle similaire) sur les deux fichiers, puis capture `chromium --headless=new --no-sandbox --disable-gpu --window-size=W,H --virtual-time-budget=10000 --screenshot=out.png file://<chemin>`.
Résultat observé : les balises étaient équilibrées (aucun grep ne l'aurait détecté autrement), mais la capture a montré une grille de 9 cartes avec une case vide (nombre impair ajouté à une grille à 2 colonnes) — invisible dans le HTML brut, visible seulement au rendu.
Conclusion : pour un livrable HTML, le grep de contenu (§critères d'acceptation) ne suffit pas — une vérification structurelle (balises) et une capture de rendu sont deux niveaux distincts, complémentaires, avant tout commit touchant un fichier `.html`.

## Symptôme : précondition du PDR présuppose un sprint qui n'existe pas dans le repo
Date : 19/06/2026
Commande : `grep -n "SDLC-14\|Rattrapage" 07-DECISIONS-SDLC.md ; grep -n "SDLC-14" CHANGELOG.md ; git log --oneline --all | head -20`
Résultat observé : zéro occurrence de "SDLC-14" dans `07-DECISIONS-SDLC.md`,
`CHANGELOG.md` ou `git log` — le dernier sprint réel est SDLC-13
(`specs/SPEC.md`, commit `2f303d3`). Le PDR reçu sous le nom "SDLC-15"
présupposait un "Sprint SDLC-14 — Audit et rattrapage gouvernance" déjà
exécuté et fournissait son contenu rétroactif comme un fait acquis.
Conclusion : précondition explicitement demandée par le PDR (§Handoff) a
été vérifiée avant de démarrer plutôt que présumée — gap confirmé.
Décision utilisateur : renumeroter ce sprint en SDLC-14 réel (audit +
rattrapage + bootstrap fusionnés) plutôt que d'écrire une entrée fictive
dans `docs/LESSONS_LEARNED.md`.

## Symptôme : gap de traçabilité (entrées CHANGELOG/DECISIONS manquantes pour des sprints passés)
Date : 19/06/2026
Commande : `grep -n "^## \[" CHANGELOG.md` puis `grep -n "SDLC-0[789]" 07-DECISIONS-SDLC.md`
Résultat observé : `CHANGELOG.md` passe directement de
`[v1.9] — Sprint SDLC-05b` à `[v1.9+SDLC-10]` — aucune entrée dédiée pour
SDLC-07, 08, 09 (SDLC-06 est un Spike, correctement absent de CHANGELOG
par convention §Types de sprint, mais mentionné en bullet dans l'entrée
SDLC-10). `07-DECISIONS-SDLC.md` ne contient aucune entrée dédiée pour
SDLC-07/08/09 (seulement des mentions en passant dans d'autres entrées,
ex. "P-01, SDLC-07").
Conclusion : confirme le pattern `LL-T01` (`docs/LESSONS_LEARNED.md`) — 3
sprints méta sans entrée CHANGELOG/DECISIONS dédiée. Backfill historique
non effectué dans ce sprint (réécrire une séquence de versions déjà
publiée est risqué et hors portée d'un sprint Doc) — reste une action
ouverte, voir `LL-T01`.

## Symptôme : cohérence numérotation des fichiers du modèle
Date : 19/06/2026
Commande : `ls *.md | grep -E "^[0-9]" | sort`
Résultat observé : 12 fichiers `0X-*`/`1X-*` numérotés sans trou ni
doublon (`00-CONTEXT.md` à `11-help-SKILL-TEMPLATE.md`).
Conclusion : aucune incohérence de numérotation au moment du bootstrap
self SDLC-14 — `.claude/skills/diagnostic/SKILL.md` réutilise cette même
commande pour les audits futurs.

## Symptôme : `git log --follow` signale une création de fichier à une date manifestement fausse
Date : 19/06/2026
Commande : `git log --follow --diff-filter=A --format="%ad %s" -- <fichier>`
puis vérifier avec `git show --stat <commit-suspect> -- <fichier>` (chercher
`new file mode` dans le diff)
Résultat observé : `git log --follow` sur `docs/ROADMAP.md` indiquait une
création à l'"Initial commit" (30/05/2026), alors que le fichier a
réellement été créé en `new file` dans le commit `6fe4f4f` (Sprint
SDLC-10, 19/06/2026) — faux positif de détection de renommage sur un
fichier sans rapport.
Conclusion : ne jamais conclure une date de création depuis `--follow`
seul sur ce repo — toujours confirmer par `git show --stat` (présence de
`new file mode` dans le diff du commit concerné).

## Symptôme : un grep hérité d'un script d'audit ne matche rien sur un chemin attendu
Date : 19/06/2026
Commande : `find . -name "<nom-fichier>"` avant de conclure à une absence
Résultat observé : `grep ... docs/ANALYSE-BMAD.md` ne matchait rien — le
fichier avait été déplacé vers `specs/Sprints/ANALYSE-BMAD.md` dès le
commit `28b2415` (Sprint SDLC-07), bien avant l'écriture du script
d'audit SDLC-16 qui référençait encore l'ancien chemin.
Conclusion : un script d'audit hérité d'un PDR antérieur peut référencer
des chemins obsolètes après un renommage/déplacement de fichier — vérifier
le chemin réel (`find`/`ls`) avant de conclure à une absence de contenu.

## Symptôme : besoin de connaître le schéma JSON réel d'un hook PreToolUse sans pouvoir redémarrer la session
Date : 19/06/2026
Commande : instrumenter temporairement un hook déjà actif (ajouter une ligne
`echo "$INPUT" >> /tmp/capture.jsonl` après la lecture de stdin), déclencher
l'action réelle correspondante, lire le fichier, puis retirer la ligne.
Pour Edit/Write sans hook actif sur ces outils : `grep -o '"name":"Edit"[^}]*"input":{[^}]*}'
<transcript_path>` (chemin fourni dans le payload `PreToolUse` lui-même).
Résultat observé : modifier `.claude/settings.local.json` pour ajouter un
nouveau hook `PreToolUse` en cours de session ne prend jamais effet (testé
sur claude 2.1.183) — les hooks sont lus une seule fois au démarrage de
session, pas relus à chaud.
Conclusion : ne jamais supposer qu'un hook nouvellement déclaré s'applique
sans redémarrage. Pour capturer un schéma sans redémarrer, exploiter un hook
déjà actif (instrumentation temporaire) ou le transcript de session
lui-même (`tool_use` réels, déjà au format API exact).

## Symptôme : un hook PreToolUse Bash bloque sa propre commande de test
Date : 19/06/2026
Commande : écrire le payload JSON de test dans un fichier via `Write`, puis
`cat fichier.json | bash .claude/hooks/pre-tool-bash.sh` — jamais le JSON de
test ni le motif recherché en texte littéral dans la commande Bash elle-même
(ni même dans un commentaire/label `echo` de la même commande composée).
Résultat observé : une commande comme
`echo "test git push --force" && cat test.json | bash hook.sh` est bloquée
par le hook qu'on cherche à tester, car `$CMD` extrait correctement
l'intégralité de la commande composée envoyée par l'outil Bash — y compris
le texte du label, pas seulement le payload JSON visé.
Conclusion : isoler tout texte de test contenant un motif `[UNIVERSEL]`
(`git push --force`, `rm -rf ...`) dans un fichier séparé, jamais dans la
commande Bash qui l'invoque.

## Symptôme : garde-fou M-HOOKS-04 bloque l'édition légitime de `.claude/sprint-memory.md` (ex: renommage du spec référencé)
Date : 20/06/2026
Constat : le carve-out anti-auto-verrouillage de `pre-tool-bash.sh` (M-HOOKS-04) n'autorise
l'écriture Write/Edit que sur des chemins sous `specs/Sprints/*` — pas sur
`.claude/sprint-memory.md` lui-même, même quand c'est exactement ce fichier qu'il faut
corriger (ex: la référence `# Spec : ...` pointe vers un nom de fichier renommé/supprimé).
Commande de contournement (en attendant l'élargissement du carve-out — `[HOOK_CANDIDATE]`,
`docs/LESSONS_LEARNED.md` `LL-T07`) :
```bash
# 1. Recréer un placeholder sous specs/Sprints/* avec l'ancien nom référencé (carve-out OK)
#    → débloque le hook car SPEC_PATH existe à nouveau sur disque
# 2. Corriger la ligne "# Spec : ..." dans sprint-memory.md (Edit, maintenant autorisé)
# 3. Supprimer le placeholder
rm specs/Sprints/<ancien-nom-placeholder>.md
```
Conclusion : ne pas contourner via `rm -f .claude/sprint-memory.md` (recours en dernier
ressort documenté par le hook) si le fichier contient des entrées de mémoire utiles — la
recréation du fichier référencé est non destructive et préserve le contenu.

## Symptôme : `jq fromdateiso8601` échoue sur tous les timestamps des transcripts JSONL Claude Code
Date : 21/06/2026
Commande : `jq -r '.timestamp | fromdateiso8601' <transcript>.jsonl`
Résultat observé : `jq: error ... date "2026-06-21T13:49:42.450Z" does not match
format "%Y-%m-%dT%H:%M:%SZ"` sur 100% des entrées — `fromdateiso8601` ne gère pas
les fractions de seconde, alors que tous les timestamps de transcript en portent.
Structure confirmée par ailleurs : chaque entrée `type=="assistant"` porte `.timestamp`
(ISO 8601 UTC, millisecondes) et `.message.usage.{input_tokens,output_tokens,
cache_read_input_tokens,cache_creation_input_tokens}` (scalaires top-level, à ne pas
confondre avec l'objet imbriqué `.message.usage.cache_creation.*`).
Conclusion : toujours retirer la fraction de seconde avant parsing —
`sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601` — utilisé par `sdlc-token-usage.sh`
(Sprint SDLC-22, M-PROC-36).

## Symptôme : PDR affirme un schéma JSON de hook "déjà vérifié" — faux, contredit par lecture directe de la doc
Date : 21/06/2026
Commande : `WebFetch https://code.claude.com/docs/en/hooks` avec un prompt demandant
une citation **verbatim** de la section concernée (pas un résumé) — répété 2-3 fois
avec des prompts de plus en plus ciblés ("quote verbatim", "everything from heading X
to next heading") jusqu'à obtenir une réponse stable et complète.
Résultat observé : le PDR du Sprint SDLC-23 affirmait le payload `PreCompact` "vérifié
... zéro Oracle nécessaire" avec un champ `trigger: "manual"|"auto"`. Un premier
`WebFetch` (prompt généraliste) a répondu que `PreCompact` ne supporte pas de `matcher`
— **faux**. Un second `WebFetch` (prompt "quote verbatim") a cité une table confirmant
que `matcher` existe bien. Un troisième `WebFetch` (prompt "tout depuis le heading X
jusqu'au heading suivant, verbatim") a enfin donné le schéma exact : le champ réel est
`compaction_reason`, pas `trigger` ; le payload porte aussi `context_used_tokens`,
`context_limit_tokens`, `estimated_tokens_freed`.
Conclusion : un `WebFetch` avec un prompt de résumé/synthèse sur une page technique peut
halluciner ou contredire un autre `WebFetch` sur la **même URL** — ne jamais accepter un
premier résultat de synthèse comme confirmation d'un schéma technique précis (champ,
type, exemple JSON). Toujours redemander une citation verbatim, et répéter avec un
périmètre plus étroit si la première citation verbatim semble incomplète ou tronquée.
Ne jamais traiter une affirmation "vérifié" dans un PDR reçu comme acquise sans
revérification — même règle que `LL-T04`, étendue ici à un schéma de plateforme externe
documenté publiquement (pas seulement au contenu du repo).

## Symptôme : un `sed` de substitution en masse (renommage de convention) corrompt un bloc de récit historique daté
Date : 02/07/2026 (Sprint SDLC-25, détecté au wrap-up)
Commande : `grep -n "docs\?/" README.md | sed -n '/Historique des versions/,/^---/p'` puis comparaison manuelle des dates de chaque ligne avec la date du renommage effectif (`git log -1 --format=%ad -- <fichier renommé>` ou l'entrée `M-ARCH-NN` correspondante)
Résultat observé : la substitution `\bdoc/` → `docs/` avait explicitement exclu `CHANGELOG.md` et `specs/Sprints/*.md` (fidélité historique actée dans `M-ARCH-09`), mais pas le bloc `README.md §Historique des versions` — de même nature (un fait daté). 3 lignes rendues fausses (le nom `docs/` substitué à un moment où le dossier s'appelait encore `doc/`).
Conclusion : avant toute substitution `sed` de masse sur un renommage de convention, chercher explicitement tout bloc `§Historique`/`§Changelog`/journal daté dans les fichiers de la surface touchée — pas seulement les fichiers nommément connus pour ce rôle (`CHANGELOG.md`). Un `grep -rln "Historique des versions\|^## \["` sur la surface avant d'appliquer le `sed` aurait trouvé le bloc concerné.

## Symptôme : compteur affirmé dans une décision (`07-DECISIONS-SDLC.md`) non recompté après rédaction
Date : 02/07/2026 (Sprint SDLC-25, détecté au wrap-up)
Commande : `git status --porcelain | grep -c '^R '` (nombre réel de renommages détectés par git) comparé au chiffre écrit en toutes lettres dans l'entrée de décision correspondante
Résultat observé : l'entrée `M-ARCH-09` affirmait "9 fichiers" renommés, le diff réel en contenait 12.
Conclusion : tout chiffre écrit dans une entrée `07-DECISIONS-SDLC.md` doit être recompté par une commande au moment de la rédaction (`git status --porcelain | grep -c`, `wc -l`, etc.), jamais estimé de mémoire — même principe que la clause anti-complaisance `Claude.md §Test`, appliqué ici au contenu d'une décision plutôt qu'à un test.

## Symptôme : `sed -e "s/.../.../"` échoue avec `unknown option to 's'` quand le texte de remplacement contient le même caractère que le délimiteur
Date : 02/07/2026 (Sprint SDLC-25, test niveau B `sdlc-init.sh`)
Commande de repro isolée : `DATE_TODAY=$(date +%d/%m/%Y) ; echo test | sed -e "s/JJ\/MM\/AAAA/${DATE_TODAY}/g"`
Résultat observé : `sed: -e expression #1, char 21: unknown option to 's'` — le texte de remplacement (`02/09/2026`, format `%d/%m/%Y`) contient des `/`, qui collisionnent avec le délimiteur `/` de la commande `s///`. `git log -p` a confirmé que cette ligne existait ainsi depuis le tout premier commit de `sdlc-init.sh` — **le bootstrap n'avait jamais fonctionné**, une variable de date au format `JJ/MM/AAAA` déclenchant systématiquement l'échec.
Conclusion : dès qu'un `sed -e "s/…/${VAR}/g"` utilise une variable de contenu non contrôlé (date formatée, chemin, nom libre) comme texte de remplacement, choisir un délimiteur qui ne peut pas apparaître dans cette variable (`s#…#${VAR}#g` pour une date `JJ/MM/AAAA`, par exemple) — ne jamais supposer que `/` est un délimiteur sûr par défaut. Un script de bootstrap doit être testé par exécution réelle dans un répertoire isolé (`Claude.md §Modifications spot`), pas seulement par `bash -n` (qui ne détecte que les erreurs de syntaxe bash, pas les échecs `sed` runtime).

## Symptôme : un contrôle structurel écrit à partir d'une spec dérivée de mémoire ne matche rien sur la vraie forme d'un tableau markdown
Date : 02/09/2026 (Sprint ECO-1, contrôle C6 de `sdlc-validate.sh`)
Commande : `grep -oE '^\| *\`?[0-9]{2}-[a-zA-Z-]+\.md' 00-CONTEXT.md` (motif proposé par le PDR) → sortie vide, alors que le fichier contient bien 12 lignes de la forme `| 01 | \`01-Claude-md-TEMPLATE.md\` | ... |`
Résultat observé : le motif suppose que l'ID et le nom de fichier partagent la même cellule (`| 01-Claude-md-TEMPLATE.md | ... |`), alors que la table réelle a une colonne ID (`01`) séparée de la colonne nom de fichier (`` `01-Claude-md-TEMPLATE.md` ``) juste après. Motif corrigé, indépendant de la position de colonne : `grep -oE '\`[0-9]{2}[a-zA-Z0-9-]*\.md\`' 00-CONTEXT.md | tr -d '\`'`.
Conclusion : quand une spec de contrôle donne une commande "de forme" sur un tableau markdown sans avoir été testée sur le fichier réel (le PDR l'annonçait explicitement pour C6 comme seul point d'ajustement admis), vérifier par un test à blanc (`grep` isolé, sortie affichée) avant d'intégrer la commande dans le script — jamais supposer que la forme proposée matche la réalité du fichier.

## Symptôme : élargir un motif de contrôle pour couvrir un cas légitime le rend aveugle à un vrai défaut ailleurs
Date : 02/09/2026 (Sprint ECO-1, contrôle C2 de `sdlc-validate.sh`, trouvé par fixture)
Commande de repro : retirer la ligne `<!-- Template SDLC vX.Y -->` d'un template dans une fixture isolée, relancer le contrôle → toujours `✅` au lieu de `❌` attendu
Résultat observé : le motif avait été élargi à `^#.*v[0-9]+\.[0-9]+` (en plus de `<!--.*v[0-9]+\.[0-9]+`) pour couvrir le cas légitime de `00-CONTEXT.md` (version en titre H1, pas en commentaire). Mais le titre H1 de **tous** les templates contient un `v1.0` générique (`# Claude.md — [Nom du projet] · v1.0` — version du futur projet cible, pas du template SDLC), qui matchait le motif élargi même quand le vrai commentaire de version était absent.
Conclusion : ne jamais élargir un motif de contrôle globalement pour absorber une exception légitime d'un seul fichier — restreindre l'élargissement à ce fichier précisément (`if [ "$base" = "00-CONTEXT.md" ]; then …`). Toujours re-tester par fixture le cas d'échec qui a justifié le contrôle, après tout élargissement de son motif — c'est exactement ce qui a révélé la régression ici.

## Symptôme : un déclencheur de réouverture nommé dans `docs/LESSONS_LEARNED.md` pour un sprint précis n'est pas détecté si la vérification factuelle pré-PDR ne lit que l'ANALYSE source et le ROADMAP
Date : 03/09/2026 (Sprint ECO-4, préparation Étape 2 du wrap-up)
Commande : `grep -n "ECO-4" docs/LESSONS_LEARNED.md`
Résultat observé : `LL-T07` (index) portait « à défaut lors d'ECO-4 ... trancher dans ce sprint plutôt que d'ouvrir un item séparé », écrit à la `/retrospective` du 03/09/2026 — non lu avant la rédaction du PDR ECO-4, dont la vérification factuelle avait couvert `specs/Sprints/ANALYSE-SKILLS-ECOSYSTEM.md` et `docs/ROADMAP.md §Next` mais pas `docs/LESSONS_LEARNED.md`. Repéré seulement en préparant l'entrée Lessons Learned du wrap-up lui-même.
Conclusion : `docs/LESSONS_LEARNED.md` peut porter des engagements datés pour un sprint futur nommé — un `grep` du nom du sprint sur ce fichier avant la rédaction du PDR (pas seulement sur l'ANALYSE et le ROADMAP) aurait détecté ce cas. Nouveau `LL-T11`, surveillé — pas encore de garde-fou proposé à 1 occurrence.

## Symptôme : le grep d'enforcement `§Pas de placeholders` (Étape 3 wrap-up) se déclenche sur la spec qui instaure lui-même la convention
Date : 03/09/2026 (Sprint ECO-4, Étape 3 du wrap-up, vérification `specs/Sprints/sprint-ECO-4-durcissement-pdr.md`)
Commande : `grep -En "\[À REMPLIR\]|\[ \]|\[→ ADAPTER\]|TBD|à implémenter plus tard|gestion d'erreur appropriée|cas limites appropriés|similaire à la tâche" specs/Sprints/sprint-ECO-4-durcissement-pdr.md`
Résultat observé : 5 lignes remontées (`⚠️`), alors qu'aucune n'est un vrai placeholder de plan — ce sont des citations méta de la convention que ce PDR instaure lui-même (description du mécanisme, un critère d'acceptation dont la commande contient littéralement `TBD`, une ligne de §Risques citant l'expression bannie comme exemple).
Conclusion : un PDR qui documente la convention `§Pas de placeholders` se cite forcément lui-même et déclenchera toujours ce grep — cas attendu, pas un défaut du mécanisme sur les specs ordinaires qu'il vise. Pas de garde-fou ajouté (mécanisme d'exception jugé disproportionné pour un cas probablement unique) — vérification manuelle ligne par ligne suffisante, documentée dans la spec elle-même (`§Corrections ajustées vs spec`).

## Symptôme : un template affirme qu'un code de sortie de hook bloque alors qu'il ne bloque pas
Date : 23/09/2026 (Sprint SDLC-Import-Strands-Harness, construction du tableau R4 de `08-hooks-TEMPLATE.md`)
Commandes : `grep -n "exit 1" 08-hooks-TEMPLATE.md .claude/hooks/*.sh` (commentaire vs usage réel) · `grep -n "^[^#]*exit 1" .claude/hooks/pre-tool-bash.sh` (usage actif seul) · smoke test sans effet de bord : `echo '{"hook_event_name":"PreToolUse","tool_name":"Bash","tool_input":{"command":"ls"}}' | bash .claude/hooks/pre-tool-bash.sh; echo "exit=$?"`
Résultat observé : « `exit 1` = bloquer (silencieux) » en commentaire dans le template et le hook actif, aucun `exit 1` actif. La doc `code.claude.com/docs/en/hooks` : sans JSON valide sur stdout, `exit 1` est une erreur **non bloquante**, la commande s'exécute — seul `exit 2` bloque.
Conclusion : tout comportement de plateforme écrit dans un template (code de sortie, schéma JSON) se vérifie contre la doc courante avec une date — une erreur de commentaire se propage aux projets cibles, qui peuvent écrire un `exit 1` en croyant bloquer.

## Symptôme : un contrôle à exemption par fichier entier ne voit plus rien dans ce fichier
Date : 23/09/2026 (Sprint ECO-7, analyse du grain de `C3_EXCEPTIONS`)
Commande (ventilation prose / code inline / bloc fencé d'un motif, par fichier) :
`awk -v P='\[→ ADAPTER\]|\[À REMPLIR\]|\[Nom du projet\]' '/^[[:space:]]*```/{fence=!fence; next} { if ($0 ~ P) { if (fence) fc++; else { l=$0; gsub(/`[^`]*`/,"",l); if (l ~ P) {pr++; print FILENAME":"NR} else ic++ } } } END{printf "%s fenced=%d inline=%d prose=%d\n", FILENAME, fc, ic, pr}' <fichier>`
Résultat observé : 0 fencé · 21 inline · 2 prose (`07-DECISIONS-SDLC.md:62`, `:509`, titre et index de `M-TMPL-01`) sur les 8 fichiers de C3. Les blocs fencés citaient la forme échappée `\[→ ADAPTER\]`, que le motif ne matche pas.
Conclusion : mesurer la ventilation avant de choisir un correctif — « retirer les blocs fencés » aurait été testé sur rien. Seule une exception de ligne par motif de contenu est nécessaire.

## Symptôme : vérifier qu'un contrôle de `sdlc-validate.sh` sait échouer, sans toucher au dépôt
Date : 23/09/2026 (Sprint ECO-7)
Commande : `F=$(mktemp -d); ( tar --exclude=./.git --exclude=./exemples -cf - . ) | ( cd "$F" && tar -xf - ); <injection du défaut dans $F>; SDLC_VALIDATE_ROOT="$F" bash sdlc-validate.sh; rm -rf "$F"` — ou la suite complète : `bash tests/sdlc-validate-test.sh`
Résultat observé : exit 1 et `❌ C<n> ·` sur le contrôle visé ; `git status --porcelain` inchangé.
Conclusion : asserter sur `❌ C<n> ·` complet, pas sur `C<n>` (`C1` matche `C10`) ni sur l'exit code seul (dix contrôles, pas d'arrêt au premier échec).

## Symptôme : un grep de vérification ne trouve rien alors que le motif est dans le fichier
Date : 24/09/2026 (Sprint ECO-8, grep préalable du §Handoff)
Commande : `grep -n 'for f in "$ROOT"' sdlc-validate.sh` → vide · `grep -nF 'for f in "$ROOT"/*.sh' sdlc-validate.sh` → `320:`
Résultat observé : dans un motif regex, `$` est une ancre de fin de ligne — le motif ne peut jamais matcher au milieu d'une ligne.
Conclusion : motif contenant `$`, `*`, `[`, `.` à prendre littéralement → `grep -F`. Toute commande de vérification écrite dans un PDR se lance une fois avant d'être écrite (`LL-T12`).
