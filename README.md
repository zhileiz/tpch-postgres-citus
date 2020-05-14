# TPC-H Benchmark on Postgresql

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
sh postgresql/main.sh YOUR_DESIRED_DB_NAME
```

After finishing all queries, you can read logs in directory `./postgresql/results`


## Credit/Reference
[trondra/pg_tpch](https://github.com/tvondra/pg_tpch "https://github.com/tvondra/pg_tpch")
