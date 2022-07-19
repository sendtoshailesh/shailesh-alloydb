alloydb.enable_pgaudit = on
pgaudit.log = all
alloydb.enable_pg_hint_plan = on
max_connections = 2000
google_columnar_engine.enabled=on
google_columnar_engine.memory_size_in_mb = 40960


sudo apt -y update && sudo apt -y upgrade

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release\
 -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc\
 | sudo apt-key add -

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release\
 -cs)-pgdg main" > /etc/apt/sources.list.d/postgresql-pgdg.list' 

sudo apt -y update

sudo apt -y install postgresql-14


sudo apt install xfce4 xfce4-goodies

sudo apt install tightvncserver

sudo apt-get install autocutsel

vncserver

vncserver -kill :1

mv ~/.vnc/xstartup ~/.vnc/xstartup.bak


echo  " 
#!/bin/bash 
xrdb $HOME/.Xresources 
autocutsel -fork
startxfce4 & 
" > ~/.vnc/xstartup

sudo chmod +x ~/.vnc/xstartup

vncserver -geometry 1400x1080



wget \
https://github.com/TPC-Council/HammerDB/releases/download/v4.3/HammerDB-4.3-Linux-x64-installer.run

chmod +x *run

./Hammer*run





Determine the external IP address for your VM. You can enter the following command at the Linux prompt, or In the Console, go to Compute Engine -> VM Instances and look at the entry for my-alloydb-vm. You will see the external IP address listed. 


curl -4 icanhazip.com













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


\c mytpch;

\dt

SELECT count(*) from customer;
SELECT count(*) from orders;
SELECT count(*) from lineitem;

\q


pg_dump -Fd -j4 -v -h 10.45.195.2 -U postgres -f Backup1GB mytpch


10.45.195.2

psql -h 10.45.195.2 -U postgres

pg_restore --dbname=mytpch_clone --verbose -j 4 -U postgres -h 10.45.195.2 Backup1GB

If you want to run the HammerDB benchmarks on this clone database in the future, connect to mytpch_clone as postgres and run the SQL statement  grant all privileges on all tables in schema public to tpch; . You do not need to do this now.



3.1: AlloyDB Columnar Engine and Query Insights


STEP 1:  Introduction to the Columnar Engine

	1.1:  The columnar engine is off by default in AlloyDB. We enabled it by setting the google_columnar_engine.enabled=on flag when we created the primary and read only instances.  We also set the flag google_columnar_engine.memory_size_in_mb = 40960, which set the amount of memory used by the columnar engine to about 40 GB.  We also issued the appropriate CREATE EXTENSION command in SQL when we created the mytpch database.   If you have an AlloyDB instance in the future where you did not set these flags, you can set them with gcloud commands; these will also restart the instance.

	1.2 Log in to your VM via SSH.  Launch the psql command:


export PGPASSWORD=alloydb-pwd
psql mytpch -h PRIMARY_PRIVATE_IP_ADDRESS -U postgres

	1.3: First, we will determine if any columns are cached.  There are none at this time.  Run this command from the mytpch> prompt. Note that the result is zero rows.  No columns are in the columnar engine,.

SELECT * FROM g_columnar_recommended_columns;

	1.4: Go back to the VNC / HammerDB session in the previous section. Verify that the TPC-H benchmark has completed. The Virtual User 1 window will show “geometric mean of query” in the last line of a completed job. Again click the red square.
1.5: Now run the below SQL command to determine how much memory (in MB) you will need to fully populate the columnar store with all columns recommended by the recommendation engine. We choose 64000 as it is one half of the memory allocated to the AlloyDB instances (64 GB of 128 GB reserved for the instance). This may take a moment or two. Note that the first entry in the output is the amount of memory recommended for the columnar engine in MB.  For this small 1 GB database, we only need about 17 MB. Then you see a list of columns that the engine recommends be in the columnar store based on the TPC-H benchmark we just ran..   Press the q key to go back to the prompt.


SELECT google_columnar_engine_run_recommendation(
  64000,'PERFORMANCE_OPTIMAL'
);



STEP 2: See an Optimizer Plan in psql without the Columnar Engine and Load the Columnar Store
2.1:  Run the following query in psql.  Note that the optimizer plan is displayed. Press RETURN repeatedly to see each line of the plan. This is query 12 from the TPC-H benchmark.  We want to find out if any orders in a certain year were marked as high priority but not shipped by air.  Note that the plan has several steps, including a parallel seq scan of the lineitem table.   If the table had indexes on l_shipdate, l_commitdate, and l_receiptdate, the optimizer may be able to choose an indexed scan; however, more indexes would be difficult to manage and would slow down DML like INSERT, UPDATE, and DELETE.  Press q when you see the END prompt.

EXPLAIN (ANALYZE,COSTS OFF,BUFFERS,TIMING OFF,SUMMARY OFF)
select
        l_shipmode,
        sum(case
                when o_orderpriority = '1-URGENT'
                        or o_orderpriority = '2-HIGH'
                        then 1
                else 0
        end) as high_line_count,
        sum(case
                when o_orderpriority <> '1-URGENT'
                        and o_orderpriority <> '2-HIGH'
                        then 1
                else 0
        end) as low_line_count
from
        orders,
        lineitem
where
        o_orderkey = l_orderkey
        and l_shipmode in ('AIR', 'REG AIR')
        and l_commitdate < l_receiptdate
        and l_shipdate < l_commitdate
        and l_receiptdate >= date '1995-01-01'
        and l_receiptdate < date '1995-01-01' + interval '1' year
group by
        l_shipmode
order by
        l_shipmode
LIMIT 3;


2.2: Now let’s run this query.  It looks like all of the orders marked urgent or high priority were shipped by air. Note the execution time. 

\timing on
select
        l_shipmode,
        sum(case
                when o_orderpriority = '1-URGENT'
                        or o_orderpriority = '2-HIGH'
                        then 1
                else 0
        end) as high_line_count,
        sum(case
                when o_orderpriority <> '1-URGENT'
                        and o_orderpriority <> '2-HIGH'
                        then 1
                else 0
        end) as low_line_count
from
        orders,
        lineitem
where
        o_orderkey = l_orderkey
        and l_shipmode in ('AIR', 'REG AIR')
        and l_commitdate < l_receiptdate
        and l_shipdate < l_commitdate
        and l_receiptdate >= date '1995-01-01'
        and l_receiptdate < date '1995-01-01' + interval '1' year
group by
        l_shipmode
order by
        l_shipmode
LIMIT 3;



2.3: We will now run the command that actually loads the columnar store. It takes a couple of minutes or so. If you see the highlighted word END,  press the q key to go back to the prompt.

SELECT google_columnar_engine_run_recommendation(0, 'FIXED_SIZE', true);

2.4: Verify that there are now many columns in the columnar store. Run this SQL command.  Hit the q key to go back to the prompt.

SELECT * FROM g_columnar_recommended_columns;

2.5: We will now re-run the explain from query 12. 

EXPLAIN (ANALYZE,COSTS OFF,BUFFERS,TIMING OFF,SUMMARY OFF)
select
        l_shipmode,
        sum(case
                when o_orderpriority = '1-URGENT'
                        or o_orderpriority = '2-HIGH'
                        then 1
                else 0
        end) as high_line_count,
        sum(case
                when o_orderpriority <> '1-URGENT'
                        and o_orderpriority <> '2-HIGH'
                        then 1
                else 0
        end) as low_line_count
from
        orders,
        lineitem
where
        o_orderkey = l_orderkey
        and l_shipmode in ('AIR', 'REG AIR')
        and l_commitdate < l_receiptdate
        and l_shipdate < l_commitdate
        and l_receiptdate >= date '1995-01-01'
        and l_receiptdate < date '1995-01-01' + interval '1' year
group by
        l_shipmode
order by
        l_shipmode
LIMIT 3;

2.6: Note that the bottom of the explain plan has a different plan from the one run in step 2.1 above. See below. Note that nearly 2 million row scans were removed (not needed) by the columnar filter.  In a larger database, this could be billions of rows. If a 100 GB TPC-C database is built with the HammerDB tool, almost 200,000,000 rows are removed in this same query, and the query time goes from 4.5 minutes to 19 seconds.  This is because using the columnar engine significantly reduces the amount of data that needs to be scanned, reduces the number of CPU instructions required to perform the query, and therefore makes for a faster query. See this doc for an explanation of the plan.

Parallel Custom Scan (columnar scan) on lineitem (actual rows=10313  loops=3)
                                             Filter: ((l_shipmode = ANY ('{AIR,"REG AIR"}'::bpchar[])) AND (l_commitdate < l_receiptdate) AND (l_shipdate < l_commitdate) AND (l_receiptdate >= '1995-01-01'::date) AND (l_receiptdate < '1996-01-01 00:00:00'::timestamp without time zone))
                                             Rows Removed by Columnar Filter: 1990285
                                             Rows Sorted by Columnar Scan: 3924
2.7: Now let’s re-run this query with the new plan that uses the columnar store.  It looks like all of the orders marked urgent or high priority were shipped by air. Note the execution time.


\timing on
select
        l_shipmode,
        sum(case
                when o_orderpriority = '1-URGENT'
                        or o_orderpriority = '2-HIGH'
                        then 1
                else 0
        end) as high_line_count,
        sum(case
                when o_orderpriority <> '1-URGENT'
                        and o_orderpriority <> '2-HIGH'
                        then 1
                else 0
        end) as low_line_count
from
        orders,
        lineitem
where
        o_orderkey = l_orderkey
        and l_shipmode in ('AIR', 'REG AIR')
        and l_commitdate < l_receiptdate
        and l_shipdate < l_commitdate
        and l_receiptdate >= date '1995-01-01'
        and l_receiptdate < date '1995-01-01' + interval '1' year
group by
        l_shipmode
order by
        l_shipmode
LIMIT 3;


2.8:  The execution time for this query is typically faster with the column store, about 450 ms for the normal scan and about 110 ms for the columnar scan.  That’s a nice performance boost, but it isn’t 100x faster.  Why is this not faster?  We only have a 1 GB database. The entire database fits into buffer cache. Although scanning the buffer cache is more expensive than scanning the columnar store, the number of CPU instructions to scan the regular cache is not that much more than using the columnar scan in a 1 GB database. In a larger database, we would see a much bigger difference. We would also see a bigger difference if there were more simultaneous users.






sudo apt-get -y install postgresql-contrib

pgbench -i --host=10.45.195.2 --username=postgres postgres

pgbench --host=10.45.195.2 --username=postgres postgres

performance test against 10 clients that are accessing your AlloyDB for PostgreSQL database and 100 transactions for each client.
pgbench --host=10.45.195.2 --username=postgres -c 10 --transactions=100
