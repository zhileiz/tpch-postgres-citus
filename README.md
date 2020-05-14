# TPC-H Benchmark on Postgresql
Adapted from [ictlyh/tpch_benchmark](https://github.com/ictlyh/tpch_benchmark)

## Prerequisite
Make sure you have installed postgres, I recommend the following procedures:
1. `sudo apt-get install postgresql postgresql-contrib`
2. add the current user as postgres superuser: `sudo -u postgres createuser YOUR_USER_NAME -s`

Make sure you have `build-essential` installed
```
sudo apt-get install build-essential
```

## How to generate/prepare the data
There's a script for generating data in directory `./data`
```
./generate_data.sh YOUR_SCALE_FACTOR
```

To remove current generated data:
```
./clear_data.sh
```


## How to run the entire testbench
```
./postgresql/main.sh YOUR_DESIRED_DB_NAME
```
This does the following:
1. drops the exisitng DB_NAME database and create a new empty DB_NAME database
2. creates all necessary tables and index
3. loads the generated data in `/tmp/dss-data` to DB_NAME
4. runs all 22 query scripts
5. log all above operations and running time.

After finishing all queries, you can read logs in directory `./postgresql/results`
