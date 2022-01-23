# Postgres Trigger Tests

Set of scripts to compare the timing of row-level insert
[triggers][trigger] and statement-level insert [triggers][trigger] in
[Postgres][].

**Note:** The statement-level triggers use the `REFERENCING NEW TABLE`
clause, which appeared in [Postgres][] 10.

The scripts in this repository do the following:

- `bin/test.sh`: Time row-level and statement-level `INSERT` triggers
  and write the results to `timing-$NOW.log`.
- `bin/parse-log.rb`: Parse the timing log from standard input and write
  the aggregate results (test name, row count, mean time, and standard
  deviation) to standard output in [CSV][] format.
- `bin/plot.py`: Read aggregate results [CSV][] from standard input and
  plot the results, and write the plot to standard output in [SVG][]
  format.

## Requirements

* [Docker][]
* [Ruby][]
* [Python][]
* [Matplotlib][]

## Usage

Example setup:

```bash
# set connection parameters
# (used for psql below and psql in bin/test.sh)
export PGHOST=localhost PGPORT=5435 PGUSER=postgres

# set password
# (note: You'll need to uncomment and populate this)
# export PGPASSWORD=xxx

# create throwaway pg14 db
docker run -d --rm --name pg14-trigger-test -e POSTGRES_PASSWORD=$PGPASSWORD -p 5435:5432 postgres:14

# init database
psql < sql/init.sql

# run tests, save results as out/timing-$STAMP.log
bin/test.sh

# stop and remove temporary pg14 db
docker stop pg14-trigger-test
```

After this you'll have a file named `timing-$STAMP.log` in the `out/`
directory with the raw timing output.

To convert the raw results into an [SVG][], do the following:

```bash
# parse timing log and write SVG to out/results.svg
bin/parse-log.rb < out/timing-20220123-085700.log | \
  bin/plot.py > out/results.svg
```

[docker]: https://docker.com/
  "Docker container orchestrator."
[ruby]: https://ruby-lang.org/
  "Ruby programming language."
[python]: https://python.org/
  "Python programming language."
[matplotlib]: https://matplotlib.org/
  "Matplotlib plotting library."
[trigger]: https://www.postgresql.org/docs/current/sql-createtrigger.html
  "Postgres CREATE TRIGGER statement."
[csv]: https://en.wikipedia.org/wiki/Comma-separated_values
  "Comma-separated values"
[svg]: https://en.wikipedia.org/wiki/Scalable_Vector_Graphics
  "Scalable Vector Graphics"
[postgres]: https://www.postgresql.org/
  "PostgreSQL relational database."
