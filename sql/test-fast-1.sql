\set ON_ERROR_STOP 1

set role postgres;

\timing on

begin;
\echo 'fast,1000'
insert into fast_a
  select from generate_series(1, 1000) b(id);
rollback;

vacuum(truncate) fast_a;

begin;
\echo 'fast,10000'
insert into fast_a
  select from generate_series(1, 10000) b(id);
rollback;

vacuum(full) fast_a;

begin;
\echo 'fast,100000'
insert into fast_a
  select from generate_series(1, 100000) b(id);
rollback;

vacuum(full) fast_a;

begin;
\echo 'fast,1000000'
insert into fast_a
  select from generate_series(1, 1000000) b(id);
rollback;

vacuum(full) fast_a;

begin;
\echo 'fast,10000000'
insert into fast_a
  select from generate_series(1, 10000000) b(id);
rollback;

vacuum(full) fast_a;
