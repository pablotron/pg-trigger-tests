\set ON_ERROR_STOP 1

set role postgres;

\timing on

begin;
\echo 'slow,10000000'
insert into slow_a
  select from generate_series(1, 10000000) b(id);
rollback;

vacuum(full) slow_a;

begin;
\echo 'slow,1000000'
insert into slow_a
  select from generate_series(1, 1000000) b(id);
rollback;

vacuum(full) slow_a;

begin;
\echo 'slow,100000'
insert into slow_a
  select from generate_series(1, 100000) b(id);
rollback;

vacuum(full) slow_a;

begin;
\echo 'slow,10000'
insert into slow_a
  select from generate_series(1, 10000) b(id);
rollback;

vacuum(full) slow_a;

begin;
\echo 'slow,1000'
insert into slow_a
  select from generate_series(1, 1000) b(id);
rollback;

vacuum(full) slow_a;
