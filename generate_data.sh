#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Usage: $0 scale"
    exit 1
fi

ROOT=$(dirname $(readlink -f $0))
TPCH_HOME=${ROOT}/tpch

cd ${TPCH_HOME}/dbgen

make -f makefile.suite all

rm -rf *.tbl *.csv ${ROOT}/data

# generate data
./dbgen -s $1
mkdir tmp_data
for i in `ls *.tbl`
do
  # remove last delimiter '|'
  sed 's/|$//' $i > tmp_data/$i
done

mkdir -p ${ROOT}/data
mv tmp_data/*.tbl ${ROOT}/data/

cd ${ROOT}/data
for f in *.tbl; do
  mv -- "$f" "${f%.tbl}.csv"
done

unlink /tmp/dss-data
ln -s ${ROOT}/data /tmp/dss-data