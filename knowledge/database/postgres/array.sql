-- concat
select array_cat('{1,2,4}'::int[], '{1,4}'::int[]);

-- push
select ARRAY(SELECT DISTINCT UNNEST('{1,2,4}'::int[] || '{1,3,4}'::int[]));

-- contains
select 1 = ANY('{1,2,4}'::int[]);
select 3 = ANY('{1,2,4}'::int[]);

-- includes
select '{1,2,4}'::int[] @> '{1,2,4}'::int[];
select '{1,2,4}'::int[] @> '{1,4}'::int[];
select '{1,2,4}'::int[] @> '{1,3}'::int[];
