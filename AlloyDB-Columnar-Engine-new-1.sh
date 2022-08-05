alloydb.enable_pgaudit = on
pgaudit.log = all
alloydb.enable_pg_hint_plan = on
max_connections = 2000
google_columnar_engine.enabled=on
google_columnar_engine.memory_size_in_mb = 40960

show google_columnar_engine.relations;



default_statistics_target 200
google_columnar_engine.enabled on
google_columnar_engine.memory_size_in_mb 32000
google_columnar_engine.relations shtest.public.audiencedata(Investor_Type_s,Is_Direct_s,Occupation_s,RowKey,Stop_Marked_Flag_s,Folio_Applicant_Type_s,SIP_Status_s)
max_parallel_workers 16
max_parallel_workers_per_gather 8
work_mem 64000

mytpch=> \a
Output format is aligned.
mytpch=> \z
                                                   Access privileges
 Schema |                   Name                    | Type  |     Access privileges     | Column privileges | Policies
--------+-------------------------------------------+-------+---------------------------+-------------------+----------
 public | customer                                  | table |                           |                   |
 public | g_columnar_column_set_stat_statements     | view  | postgres=arwdDxt/postgres+|                   |
        |                                           |       | =r/postgres               |                   |
 public | g_columnar_columns                        | view  | postgres=arwdDxt/postgres+|                   |
        |                                           |       | =r/postgres               |                   |
 public | g_columnar_jobs                           | view  | postgres=arwdDxt/postgres+|                   |
        |                                           |       | =r/postgres               |                   |
 public | g_columnar_memory_usage                   | view  | postgres=arwdDxt/postgres+|                   |
        |                                           |       | =r/postgres               |                   |
 public | g_columnar_native_scan_unsupported_ops    | view  | postgres=arwdDxt/postgres+|                   |
        |                                           |       | =r/postgres               |                   |
 public | g_columnar_policies                       | view  | postgres=arwdDxt/postgres+|                   |
        |                                           |       | =r/postgres               |                   |
 public | g_columnar_recommendation_stat_statements | view  | postgres=arwdDxt/postgres+|                   |
        |                                           |       | =r/postgres               |                   |
 public | g_columnar_recommended_columns            | view  | postgres=arwdDxt/postgres+|                   |
        |                                           |       | =r/postgres               |                   |
 public | g_columnar_relations                      | view  | postgres=arwdDxt/postgres+|                   |
        |                                           |       | =r/postgres               |                   |
 public | g_columnar_schedules                      | view  | postgres=arwdDxt/postgres+|                   |
        |                                           |       | =r/postgres               |                   |
 public | g_columnar_stat_statements                | view  | postgres=arwdDxt/postgres+|                   |
        |                                           |       | =r/postgres               |                   |
 public | g_columnar_stats                          | view  |                           |                   |
 public | g_columnar_units                          | view  | postgres=arwdDxt/postgres+|                   |
        |                                           |       | =r/postgres               |                   |
 public | g_columnar_whatif_columns                 | view  | postgres=arwdDxt/postgres+|                   |
        |                                           |       | =r/postgres               |                   |
 public | g_columnar_whatif_relations               | view  | postgres=arwdDxt/postgres+|                   |
        |                                           |       | =r/postgres               |                   |
 public | lineitem                                  | table |                           |                   |
 public | nation                                    | table |                           |                   |
 public | orders                                    | table |                           |                   |
 public | part                                      | table |                           |                   |
 public | partsupp                                  | table |                           |                   |
 public | region                                    | table |                           |                   |
 public | supplier                                  | table |                           |                   |
(23 rows)

mytpch=>





psql -h 10.45.195.2 -U postgres

CREATE DATABASE mytpch_clone OWNER tpch;
CREATE DATABASE mytpch_clone_2 OWNER tpch;


pg_restore --dbname=mytpch_clone --verbose -j 4 -U postgres -h 10.45.195.2 Backup1GB
pg_restore --dbname=mytpch_clone_2 --verbose -j 4 -U postgres -h 10.45.195.2 Backup1GB

\c mytpch_clone_2

\dt

SELECT count(*) from customer;
SELECT count(*) from orders;
SELECT count(*) from lineitem;



CREATE EXTENSION IF NOT EXISTS google_columnar_engine;
CREATE EXTENSION IF NOT EXISTS pg_hint_plan;
CREATE EXTENSION IF NOT EXISTS pgaudit;

If you want to run the HammerDB benchmarks on this clone database in the future, connect to mytpch_clone as postgres and run the SQL statement  grant all privileges on all tables in schema public to tpch; . You do not need to do this now.



3.1: AlloyDB Columnar Engine and Query Insights


STEP 1:  Introduction to the Columnar Engine

	1.1:  The columnar engine is off by default in AlloyDB. We enabled it by setting the google_columnar_engine.enabled=on flag when we created the primary and read only instances.  We also set the flag google_columnar_engine.memory_size_in_mb = 40960, which set the amount of memory used by the columnar engine to about 40 GB.  We also issued the appropriate CREATE EXTENSION command in SQL when we created the mytpch database.   If you have an AlloyDB instance in the future where you did not set these flags, you can set them with gcloud commands; these will also restart the instance.

	1.2 Log in to your VM via SSH.  Launch the psql command:


export PGPASSWORD=alloydb-pwd
psql mytpch -h PRIMARY_PRIVATE_IP_ADDRESS -U postgres

	1.3: First, we will determine if any columns are cached.  There are none at this time.  Run this command from the mytpch> prompt. Note that the result is zero rows.  No columns are in the columnar engine,.

SELECT * FROM g_columnar_recommended_columns;
SELECT * FROM g_columnar_relations;

	1.4: Go back to the VNC / HammerDB session in the previous section. Verify that the TPC-H benchmark has completed. The Virtual User 1 window will show “geometric mean of query” in the last line of a completed job. Again click the red square.
1.5: Now run the below SQL command to determine how much memory (in MB) you will need to fully populate the columnar store with all columns recommended by the recommendation engine. We choose 64000 as it is one half of the memory allocated to the AlloyDB instances (64 GB of 128 GB reserved for the instance). This may take a moment or two. Note that the first entry in the output is the amount of memory recommended for the columnar engine in MB.  For this small 1 GB database, we only need about 17 MB. Then you see a list of columns that the engine recommends be in the columnar store based on the TPC-H benchmark we just ran..   Press the q key to go back to the prompt.


SELECT google_columnar_engine_run_recommendation(
  64000,'PERFORMANCE_OPTIMAL'
);

SELECT google_columnar_engine_run_recommendation(
  16000,'PERFORMANCE_OPTIMAL'
);

Below shows columnar engine requires 128MB and no recomendation as "" because now workload ran as of now

mytpch=> SELECT google_columnar_engine_run_recommendation(
mytpch(>   16000,'PERFORMANCE_OPTIMAL'
mytpch(> );
 google_columnar_engine_run_recommendation
-------------------------------------------
 (128,"")
(1 row)

Time: 6754.092 ms (00:06.754)
mytpch=>


select * from g_columnar_columns;
select * from g_columnar_memory_usage;
select * from g_columnar_stat_statements;



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


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Limit (actual rows=2 loops=1)
   Buffers: shared hit=245526
   ->  Finalize GroupAggregate (actual rows=2 loops=1)
         Group Key: lineitem.l_shipmode
         Buffers: shared hit=245526
         ->  Gather Merge (actual rows=6 loops=1)
               Workers Planned: 2
               Workers Launched: 2
               Buffers: shared hit=245526
               ->  Partial GroupAggregate (actual rows=2 loops=3)
                     Group Key: lineitem.l_shipmode
                     Buffers: shared hit=245526
                     ->  Nested Loop (actual rows=10339 loops=3)
                           Buffers: shared hit=245526
                           ->  Sort (actual rows=10339 loops=3)
                                 Sort Key: lineitem.l_shipmode
                                 Sort Method: quicksort  Memory: 1052kB
                                 Buffers: shared hit=129404
                                 Worker 0:  Sort Method: quicksort  Memory: 1042kB
                                 Worker 1:  Sort Method: quicksort  Memory: 1480kB
                                 ->  Parallel Seq Scan on lineitem (actual rows=10339 loops=3)
                                       Filter: ((l_shipmode = ANY ('{AIR,"REG AIR"}'::bpchar[])) AND (l_commitdate < l_receiptdate) AND (l_shipdate < l_commitdate) AND (l_receiptdate >= '1995-01-01'::date) AND (l_receiptdate < '1996-01-01 00:00:00'::timestamp without time zone))
                                       Rows Removed by Filter: 1989861
                                       Buffers: shared hit=129390
                           ->  Memoize (actual rows=1 loops=31017)
                                 Cache Key: lineitem.l_orderkey
                                 Cache Mode: logical
                                 Hits: 587  Misses: 7962  Evictions: 0  Overflows: 0  Memory Usage: 980kB
                                 Buffers: shared hit=116122
                                 Worker 0:  Hits: 552  Misses: 7874  Evictions: 0  Overflows: 0  Memory Usage: 969kB
                                 Worker 1:  Hits: 848  Misses: 13194  Evictions: 0  Overflows: 0  Memory Usage: 1624kB
                                 ->  Index Scan using orders_pk on orders (actual rows=1 loops=29030)
                                       Index Cond: (o_orderkey = lineitem.l_orderkey)
                                       Buffers: shared hit=116122
 Planning:
   Buffers: shared hit=328
(36 rows)





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

We will run multiple times same query to show this as workload. System will eventually generate stats about the workload and post to it we will check recomentation and generate these recomendation to columnar store.


mytpch=>
mytpch=> \timing on
Timing is on.
mytpch=> select
mytpch->         l_shipmode,
mytpch->         sum(case
mytpch(>                 when o_orderpriority = '1-URGENT'
mytpch(>                         or o_orderpriority = '2-HIGH'
mytpch(>                         then 1
mytpch(>                 else 0
mytpch(>         end) as high_line_count,
mytpch->         sum(case
mytpch(>                 when o_orderpriority <> '1-URGENT'
mytpch(>                         and o_orderpriority <> '2-HIGH'
mytpch(>                         then 1
mytpch(>                 else 0
mytpch(>         end) as low_line_count
mytpch-> from
mytpch->         orders,
mytpch->         lineitem
mytpch-> where
mytpch->         o_orderkey = l_orderkey
mytpch->         and l_shipmode in ('AIR', 'REG AIR')
mytpch->         and l_commitdate < l_receiptdate
mytpch->         and l_shipdate < l_commitdate
mytpch->         and l_receiptdate >= date '1995-01-01'
mytpch->         and l_receiptdate < date '1995-01-01' + interval '1' year
mytpch-> group by
mytpch->         l_shipmode
mytpch-> order by
mytpch->         l_shipmode
mytpch-> LIMIT 3;
 l_shipmode | high_line_count | low_line_count
------------+-----------------+----------------
 AIR        |            6162 |           9304
 REG AIR    |            6212 |           9339
(2 rows)

Time: 818.002 ms
mytpch=>
mytpch=> \g
 l_shipmode | high_line_count | low_line_count
------------+-----------------+----------------
 AIR        |            6162 |           9304
 REG AIR    |            6212 |           9339
(2 rows)

Time: 806.715 ms
mytpch=> \g
 l_shipmode | high_line_count | low_line_count
------------+-----------------+----------------
 AIR        |            6162 |           9304
 REG AIR    |            6212 |           9339
(2 rows)

Time: 803.679 ms
mytpch=> \g
 l_shipmode | high_line_count | low_line_count
------------+-----------------+----------------
 AIR        |            6162 |           9304
 REG AIR    |            6212 |           9339
(2 rows)

Time: 792.754 ms
mytpch=> \g
 l_shipmode | high_line_count | low_line_count
------------+-----------------+----------------
 AIR        |            6162 |           9304
 REG AIR    |            6212 |           9339
(2 rows)

Time: 809.833 ms
mytpch=> \g
 l_shipmode | high_line_count | low_line_count
------------+-----------------+----------------
 AIR        |            6162 |           9304
 REG AIR    |            6212 |           9339
(2 rows)

Time: 801.198 ms
mytpch=> \g
 l_shipmode | high_line_count | low_line_count
------------+-----------------+----------------
 AIR        |            6162 |           9304
 REG AIR    |            6212 |           9339
(2 rows)

Time: 796.149 ms
mytpch=> \g
 l_shipmode | high_line_count | low_line_count
------------+-----------------+----------------
 AIR        |            6162 |           9304
 REG AIR    |            6212 |           9339
(2 rows)

Time: 800.527 ms
mytpch=> \g
 l_shipmode | high_line_count | low_line_count
------------+-----------------+----------------
 AIR        |            6162 |           9304
 REG AIR    |            6212 |           9339
(2 rows)

Time: 802.000 ms
mytpch=> \g
 l_shipmode | high_line_count | low_line_count
------------+-----------------+----------------
 AIR        |            6162 |           9304
 REG AIR    |            6212 |           9339
(2 rows)

Time: 804.809 ms



Now we will check the recomendation to see of workload relevant columns comes as part recomendation

SELECT google_columnar_engine_run_recommendation(
  16000,'PERFORMANCE_OPTIMAL'
);


mytpch=> SELECT google_columnar_engine_run_recommendation(
mytpch(>   16000,'PERFORMANCE_OPTIMAL'
mytpch(> );
                          google_columnar_engine_run_recommendation
---------------------------------------------------------------------------------------------
 (128,"mytpch.public.lineitem(l_commitdate,l_orderkey,l_receiptdate,l_shipdate,l_shipmode)")
(1 row)

Time: 1448.316 ms (00:01.448)
mytpch=>



Now lets check columnar store content

mytpch=> SELECT * FROM g_columnar_relations;

database_name | schema_name | relation_name | status | size | uncompressed_size | columnar_unit_count | invalid_block_count | block_count_in_cc | total_block_count | auto_refresh_trigger_count | auto_refresh_failure_count | auto_refresh_recent_status
---------------+-------------+---------------+--------+------+-------------------+---------------------+---------------------+-------------------+-------------------+----------------------------+----------------------------+----------------------------
(0 rows)

(END)




2.3: We will now run the command that actually loads the columnar store. It takes a couple of minutes or so. If you see the highlighted word END,  press the q key to go back to the prompt.

SELECT google_columnar_engine_run_recommendation(0, 'FIXED_SIZE', true);

mytpch=> SELECT google_columnar_engine_run_recommendation(0, 'FIXED_SIZE', true);
                           google_columnar_engine_run_recommendation
-----------------------------------------------------------------------------------------------
 (16000,"mytpch.public.lineitem(l_commitdate,l_orderkey,l_receiptdate,l_shipdate,l_shipmode)")
(1 row)

Time: 21765.450 ms (00:21.765)
mytpch=>

Now check if colunmnar store populated with recomended columns or not

select * from g_columnar_columns;
select * from g_columnar_memory_usage;
select * from g_columnar_stat_statements;

mytpch=> SELECT * FROM g_columnar_relations;
database_name | schema_name | relation_name | status |   size   | uncompressed_size | columnar_unit_count | invalid_block_count | block_count_in_cc | total_block_count | auto_refresh_trigger_count | auto_refresh_failure_count | auto_refresh_recent_status
---------------+-------------+---------------+--------+----------+-------------------+---------------------+---------------------+-------------------+-------------------+----------------------------+----------------------------+----------------------------
 mytpch        | public      | lineitem      | Usable | 79113999 |          79113999 |                  32 |                   0 |            129390 |            129390 |                          0 |                          0 | NONE YET
(1 row)

mytpch=> \a
mytpch=> SELECT * FROM g_columnar_relations;
database_name|schema_name|relation_name|status|size|uncompressed_size|columnar_unit_count|invalid_block_count|block_count_in_cc|total_block_count|auto_refresh_trigger_count|auto_refresh_failure_count|auto_refresh_recent_status
mytpch|public|lineitem|Usable|79113999|79113999|32|0|129390|129390|0|0|NONE YET
(1 row)
Time: 147.335 ms
mytpch=>





2.4: Verify that there are now many columns in the columnar store. Run this SQL command.  Hit the q key to go back to the prompt.

SELECT * FROM g_columnar_recommended_columns;
mytpch=> SELECT * FROM g_columnar_recommended_columns;
 database_name | schema_name | relation_name |  column_name  | compression_level | estimated_size_in_bytes
---------------+-------------+---------------+---------------+-------------------+-------------------------
 mytpch        | public      | lineitem      | l_shipdate    |                 1 |                16874055
 mytpch        | public      | lineitem      | l_orderkey    |                 1 |                28014354
 mytpch        | public      | lineitem      | l_commitdate  |                 1 |                16822219
 mytpch        | public      | lineitem      | l_receiptdate |                 1 |                16884615
 mytpch        | public      | lineitem      | l_shipmode    |                 1 |                 7249719
(5 rows)

Time: 147.358 ms
mytpch=>



google_columnar_engine.relations='mytpch_clone.public.lineitem' \

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



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Limit (actual rows=2 loops=1)
   Buffers: shared hit=116096
   ->  Finalize GroupAggregate (actual rows=2 loops=1)
         Group Key: lineitem.l_shipmode
         Buffers: shared hit=116096
         ->  Gather Merge (actual rows=6 loops=1)
               Workers Planned: 2
               Workers Launched: 2
               Buffers: shared hit=116096
               ->  Partial GroupAggregate (actual rows=2 loops=3)
                     Group Key: lineitem.l_shipmode
                     Buffers: shared hit=116096
                     ->  Nested Loop (actual rows=10339 loops=3)
                           Buffers: shared hit=116096
                           ->  Sort (actual rows=10339 loops=3)
                                 Sort Key: lineitem.l_shipmode
                                 Sort Method: quicksort  Memory: 1591kB
                                 Buffers: shared hit=14
                                 Worker 0:  Sort Method: quicksort  Memory: 802kB
                                 Worker 1:  Sort Method: quicksort  Memory: 798kB
                                 ->  Parallel Append (actual rows=0 loops=3)
                                       ->  Parallel Custom Scan (columnar scan) on lineitem (actual rows=10339 loops=3)
                                             Filter: ((l_shipmode = ANY ('{AIR,"REG AIR"}'::bpchar[])) AND (l_commitdate < l_receiptdate) AND (l_shipdate < l_commitdate) AND (l_receiptdate >= '1995-01-01'::date) AND (l_receiptdate < '1996-01-01 00:00:00'::timestamp without time zone))
                                             Rows Removed by Columnar Filter: 1989861
                                             Rows Sorted by Columnar Scan: 5154
                                             Columnar cache search mode: native
                                       ->  Parallel Seq Scan on lineitem (never executed)
                                             Filter: ((l_shipmode = ANY ('{AIR,"REG AIR"}'::bpchar[])) AND (l_commitdate < l_receiptdate) AND (l_shipdate < l_commitdate) AND (l_receiptdate >= '1995-01-01'::date) AND (l_receiptdate < '1996-01-01 00:00:00'::timestamp without time zone))
                           ->  Memoize (actual rows=1 loops=31017)
                                 Cache Key: lineitem.l_orderkey
                                 Cache Mode: logical
                                 Hits: 1042  Misses: 14421  Evictions: 0  Overflows: 0  Memory Usage: 1775kB
                                 Buffers: shared hit=116082
                                 Worker 0:  Hits: 492  Misses: 7312  Evictions: 0  Overflows: 0  Memory Usage: 900kB
                                 Worker 1:  Hits: 463  Misses: 7287  Evictions: 0  Overflows: 0  Memory Usage: 897kB
                                 ->  Index Scan using orders_pk on orders (actual rows=1 loops=29020)
                                       Index Cond: (o_orderkey = lineitem.l_orderkey)
                                       Buffers: shared hit=116082
 Planning:
   Buffers: shared hit=19
(40 rows)




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



