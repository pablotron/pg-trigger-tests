#!/bin/bash

#
# Run 5 rounds of tests and write results to "timing-$NOW.log", where
# $NOW is the test start time in YYMMDD-HHMMSS format.
#
# Note: The host, port, username, password, and database name should be
# set with the with the PG* environment variables prior to running this
# script.
#
# Example:
#
#   # Run timing tests and log results to ./timing-$NOW.log.
#   PGHOST=hive.wg PGPORT=5435 PGUSER=postgres PGDATABASE=postgres ./test.sh
#

set -eu

# get current timestamp
STAMP=$(date +%Y%m%d-%H%M%S)

# build log name from current timestamp
log=out/timing-$STAMP.log

# write log name, remove existing log
echo "Writing to $log"
rm -vf "$log"

# run tests
for i in fast slow; do
  for j in {1..5}; do
    # run ascending row count test
    echo "$i,$j,0"
    psql < sql/test-$i-0.sql >> $log

    # run descending row count test
    echo "$i,$j,1"
    psql < sql/test-$i-1.sql >> $log
  done
done
