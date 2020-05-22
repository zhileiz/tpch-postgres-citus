#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 dbname mode(cold/hot)"
    exit 1
fi

DBNAME=$1
MODE=$2

# log
LOGFILE=bench.log
ROOT=$(dirname $(readlink -f $0))
TPCH_HOME=${ROOT}/../tpch
RESULTS=${ROOT}/results

benchmark_dss() {
  mkdir $RESULTS/explain $RESULTS/results $RESULTS/errors
  echo "Called?"
  # get bgwriter stats
  psql $DBNAME -c "SELECT * FROM pg_stat_bgwriter" > $RESULTS/stats-before.log 2>> $RESULTS/stats-before.err
  psql $DBNAME -c "SELECT * FROM pg_stat_database WHERE datname = '$DBNAME'" >> $RESULTS/stats-before.log 2>> $RESULTS/stats-before.err

  print_log "running queries defined in TPC-H benchmark"

  for n in `seq 1 22`
  do
    q="${ROOT}/queries/$n.sql"
    qe="${ROOT}/queries/$n.explain.sql"

    if [ -f "$q" ]; then
      print_log "  running query $n"
      echo "RUNNING QUERY $n"
      # run explain
      psql $DBNAME -f $qe > $RESULTS/explain/$n 2>> $RESULTS/explain.err
      psql $DBNAME -f $q > $RESULTS/results/$n 2> $RESULTS/errors/$n
    fi;

  done;

  # collect stats again
  psql $DBNAME -c "SELECT * FROM pg_stat_bgwriter" > $RESULTS/stats-after.log 2>> $RESULTS/stats-after.err
  psql $DBNAME -c "SELECT * FROM pg_stat_database WHERE datname = '$DBNAME'" >> $RESULTS/stats-after.log 2>> $RESULTS/stats-after.err
}

print_log() {
  message=$1
  echo `date +"%Y-%m-%d %H:%M:%S"` "["`date +%s`"] : $message" >> $RESULTS/$LOGFILE;
}

rm -rf $RESULTS
mkdir -p $RESULTS

if [ "$2" == "cold" ]; then
  # DROP and CREATE Database
  dropdb $DBNAME
  createdb $DBNAME

  psql $DBNAME -c "select name,setting from pg_settings" > $RESULTS/settings.log 2> $RESULTS/settings.err

  print_log "preparing TPC-H database"
  print_log "  creating tables"
  psql $DBNAME -f ${ROOT}/create_table.sql > $RESULTS/create_table.log 2> $RESULTS/create_table.err
  echo "CREATED TABLE"
  print_log "  loading data"
  psql $DBNAME -f ${ROOT}/load_data.sql > $RESULTS/load_data.log 2> $RESULTS/load_data.err
  echo "LOADED DATA"
  print_log "  creating primary keys"
  psql $DBNAME -f ${ROOT}/primary_key.sql> $RESULTS/primary_key.log 2> $RESULTS/primary_key.err
  echo "CREATED PRIMARY KEY"
  print_log "  creating foreign keys"
  psql $DBNAME -f ${ROOT}/foreign_key.sql > $RESULTS/foreign_key.log 2> $RESULTS/foreign_key.err
  echo "CREATED FOREIGN KEY"
  print_log "  creating indexes"
  psql $DBNAME -f ${ROOT}/create_index.sql > $RESULTS/create_index.log 2> $RESULTS/create_index.err
  echo "CREATED INDEXES"
  print_log "  analyzing"
  psql $DBNAME -c "analyze" > $RESULTS/analyze.log 2> $RESULTS/analyze.err
fi

print_log "running TPC-H benchmark"
benchmark_dss

print_log "finished TPC-H benchmark"
