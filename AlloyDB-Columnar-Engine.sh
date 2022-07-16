CREATE DATABASE myalloydbbench;
\c myalloydbbench;

CREATE USER tpch WITH PASSWORD 'alloydb-pwd' CREATEDB;

GRANT tpch TO postgres;
CREATE DATABASE mytpch OWNER tpch;
\c mytpch

CREATE EXTENSION IF NOT EXISTS google_columnar_engine;
CREATE EXTENSION IF NOT EXISTS pg_hint_plan;
CREATE EXTENSION IF NOT EXISTS pgaudit;

\c myalloydbbench;

CREATE TABLE tab1 ( id BIGINT NOT NULL PRIMARY KEY, name VARCHAR(40), ts TIMESTAMP);
CREATE SEQUENCE seq1;
INSERT INTO tab1 VALUES(nextval('seq1'), 'My Name', CURRENT_TIMESTAMP);
INSERT INTO tab1 VALUES(nextval('seq1'), 
   CONCAT('My Name',CURRVAL('seq1')), CURRENT_TIMESTAMP);
SELECT * FROM tab1;

\set AUTOCOMMIT OFF

INSERT INTO tab1 VALUES(nextval('seq1'), 'My Name', CURRENT_TIMESTAMP);
INSERT INTO tab1 VALUES(nextval('seq1'), 'My Name', CURRENT_TIMESTAMP);
SELECT * FROM tab1;
ROLLBACK;
SELECT * FROM tab1;
INSERT INTO tab1 VALUES(nextval('seq1'), 'My Name', CURRENT_TIMESTAMP);
COMMIT;
SELECT * FROM tab1;
\q



\c mytpch

SELECT * FROM g_columnar_recommended_columns;

SELECT google_columnar_engine_run_recommendation(
  64000,'PERFORMANCE_OPTIMAL'
);



SELECT google_columnar_engine_run_recommendation(
  1000,'PERFORMANCE_OPTIMAL'
);


sudo apt-get -y install postgresql-contrib

pgbench -i --host=10.45.195.2 --username=postgres postgres

pgbench --host=10.45.195.2 --username=postgres postgres

performance test against 10 clients that are accessing your AlloyDB for PostgreSQL database and 100 transactions for each client.
pgbench --host=10.45.195.2 --username=postgres -c 10 --transactions=100
