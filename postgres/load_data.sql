\timing on

TRUNCATE TABLE part;
TRUNCATE TABLE region;
TRUNCATE TABLE nation;
TRUNCATE TABLE supplier;
TRUNCATE TABLE customer;
TRUNCATE TABLE partsupp;
TRUNCATE TABLE orders;
TRUNCATE TABLE lineitem;

COPY part FROM '/bigdisk/tmp/dss-data/part.csv' WITH (FORMAT csv, DELIMITER '|');
COPY region FROM '/bigdisk/tmp/dss-data/region.csv' WITH (FORMAT csv, DELIMITER '|');
COPY nation FROM '/bigdisk/tmp/dss-data/nation.csv' WITH (FORMAT csv, DELIMITER '|');
COPY supplier FROM '/bigdisk/tmp/dss-data/supplier.csv' WITH (FORMAT csv, DELIMITER '|');
COPY customer FROM '/bigdisk/tmp/dss-data/customer.csv' WITH (FORMAT csv, DELIMITER '|');
COPY partsupp FROM '/bigdisk/tmp/dss-data/partsupp.csv' WITH (FORMAT csv, DELIMITER '|');
COPY orders FROM '/bigdisk/tmp/dss-data/orders.csv' WITH (FORMAT csv, DELIMITER '|');
COPY lineitem FROM '/bigdisk/tmp/dss-data/lineitem.csv' WITH (FORMAT csv, DELIMITER '|');
