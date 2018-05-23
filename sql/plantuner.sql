LOAD 'plantuner';
SET enable_seqscan=off;

SHOW	plantuner.disable_index;

CREATE TABLE wow (i int, j int);
INSERT INTO wow SELECT a, a+ 1 FROM generate_series(1, 1000) a;
CREATE INDEX i_idx ON wow (i);
CREATE INDEX j_idx ON wow (j);

EXPLAIN (COSTS OFF) SELECT count(*) FROM wow;
SELECT count(*) FROM wow;

SET plantuner.disable_index="i_idx, j_idx";

EXPLAIN (COSTS OFF) SELECT count(*) FROM wow;
SELECT count(*) FROM wow;

SHOW plantuner.disable_index;

SET plantuner.disable_index="i_idx, nonexistent, public.j_idx, wow";

SHOW plantuner.disable_index;

SET plantuner.enable_index="i_idx";

SHOW plantuner.enable_index;

EXPLAIN (COSTS OFF) SELECT count(*) FROM wow;
SELECT count(*) FROM wow;

DROP INDEX j_idx;
SELECT pg_reload_conf();

EXPLAIN (COSTS OFF) SELECT count(*) FROM wow;
SELECT count(*) FROM wow;
