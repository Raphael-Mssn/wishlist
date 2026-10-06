# Migrations Supabase

On développe les features directement sur la base Supabase de dev. Ce document fixe les règles pour que ce qui tourne sur dev et prod reste décrit par les fichiers de `supabase/migrations/`, et que la mise en prod se fasse en rejouant ces fichiers, sans rien refaire à la main.

Tant que les deux dossiers `supabase-dev/` et `supabase-prod/` coexistent, chaque migration est copiée à l'identique dans les deux.

## Les règles

1. **Toute modif de schéma passe par un fichier de migration**, même en cours de dev. Pas de table, colonne, policy ou fonction créée depuis le dashboard ou collée dans le SQL editor sans fichier correspondant dans le repo.
2. **Chaque migration est idempotente** : elle peut être rejouée sur une base où tout ou partie de ses objets existent déjà, sans erreur et sans effet de bord.
3. **On ne modifie jamais une migration déjà mergée.** Une correction est une nouvelle migration.
4. **Après un déploiement, le diff doit être vide** (voir [Vérifier la dérive](#vérifier-la-dérive)).

La règle 1 est la plus importante. L'idempotence n'est qu'un filet : sans la règle 1, elle masque les objets créés à la main au lieu de les révéler.

## Workflow d'une feature

```bash
cd supabase-dev
supabase migration new add_something      # crée supabase/migrations/<timestamp>_add_something.sql
# écrire la migration (idempotente)
supabase db push                          # applique sur dev les migrations pas encore enregistrées
cp supabase/migrations/<timestamp>_add_something.sql ../supabase-prod/supabase/migrations/
```

Si on a appliqué la migration autrement (SQL editor pendant qu'on itère dessus), on l'enregistre comme faite pour que `db push` ne la rejoue pas :

```bash
supabase migration repair --status applied <timestamp>
```

Grâce à la règle 2, l'oubli de cette étape n'est pas grave : le `db push` suivant rejouera la migration sans rien casser.

La mise en prod se fait depuis `supabase-prod/` avec `supabase db push`, après le merge de la PR.

`db push` refuse une migration dont le timestamp est plus ancien que la dernière déjà appliquée (cas d'une branche longue mergée après une autre). Dans ce cas, `supabase db push --include-all`, après avoir vérifié la liste avec `supabase migration list`.

## Écrire une migration idempotente

| Objet | Écriture |
|---|---|
| Table | `CREATE TABLE IF NOT EXISTS` |
| Colonne | `ALTER TABLE ... ADD COLUMN IF NOT EXISTS` |
| Index | `CREATE INDEX IF NOT EXISTS` |
| Fonction, vue | `CREATE OR REPLACE` |
| Trigger | `CREATE OR REPLACE TRIGGER`, ou `DROP TRIGGER IF EXISTS` puis `CREATE TRIGGER` |
| Policy | `DROP POLICY IF EXISTS` puis `CREATE POLICY` (pas de `IF NOT EXISTS` en Postgres) |
| Contrainte, type enum, ajout à une publication | bloc `DO` qui teste le catalogue |
| Suppression | `DROP ... IF EXISTS` |

Contrainte :

```sql
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'wishs_name_max_length'
      AND conrelid = 'public.wishs'::regclass
  ) THEN
    ALTER TABLE public.wishs
      ADD CONSTRAINT wishs_name_max_length CHECK (char_length(name) <= 50);
  END IF;
END $$;
```

Table ajoutée au realtime :

```sql
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime' AND schemaname = 'public' AND tablename = 'ma_table'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.ma_table;
  END IF;
END $$;
```

### La limite de `IF NOT EXISTS`

`IF NOT EXISTS` vérifie qu'un objet porte ce nom, pas qu'il a le bon contenu. Si une table existe déjà sur dev avec une colonne de moins, la migration la saute et l'écart reste. Les objets réécrits à chaque passage (`CREATE OR REPLACE`, `DROP` puis `CREATE`) n'ont pas ce problème. Les tables, colonnes et contraintes l'ont : c'est la vérification de dérive qui le rattrape.

### Fonctions `SECURITY DEFINER`

Toujours fixer le `search_path` et qualifier les objets :

```sql
CREATE OR REPLACE FUNCTION public.ma_fonction()
  RETURNS void
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path = ''
AS $$
BEGIN
  DELETE FROM public.ma_table WHERE user_id = auth.uid();
END;
$$;

REVOKE EXECUTE ON FUNCTION public.ma_fonction() FROM PUBLIC, anon;
```

## Tester en local

Docker doit tourner.

```bash
cd supabase-dev
supabase db reset     # recrée la base locale et rejoue toutes les migrations
```

Pour tester l'idempotence, rejouer ensuite la nouvelle migration une deuxième fois sur la base locale :

```bash
psql "postgresql://postgres:postgres@localhost:54322/postgres" -f supabase/migrations/<fichier>.sql
```

## Vérifier la dérive

```bash
cd supabase-dev    # puis supabase-prod
supabase db diff --linked --schema public
```

La commande rejoue les migrations du repo dans une base temporaire, la compare au projet distant et affiche le SQL qui manque au repo pour décrire le distant. Elle ne modifie rien sur le projet distant.

- Sortie vide : le repo décrit bien le projet.
- Sortie non vide : quelque chose a été fait sans migration. On l'ajoute au repo dans une nouvelle migration idempotente, qu'on applique (ou qu'on marque `applied`) partout.

Le diff ne compare pas les grants. Après une migration qui en change, vérifier à la main dans `information_schema.routine_privileges` ou `information_schema.role_table_grants`.
