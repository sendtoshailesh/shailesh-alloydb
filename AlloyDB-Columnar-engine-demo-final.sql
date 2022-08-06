


psql -h 10.45.195.2 -U postgres

alloydb.enable_pgaudit = on
pgaudit.log = all
alloydb.enable_pg_hint_plan = on
max_connections = 2000
google_columnar_engine.enabled=on
google_columnar_engine.memory_size_in_mb = 40960

show google_columnar_engine.enabled;
show default_statistics_target;
show google_columnar_engine.memory_size_in_mb;
show google_columnar_engine.relations; 
show max_parallel_workers;
show max_parallel_workers_per_gather;
show work_mem;



\z


create database db20220802;
CREATE USER tpch WITH PASSWORD 'alloydb-pwd';



cd ~/alloydb/backup-sql



psql -h 10.45.195.2 -U postgres db20220802 < example_tables.sql


\c db20220802

\dt

SELECT count(*) from customer;
SELECT count(*) from orders;
SELECT count(*) from lineitem;



CREATE EXTENSION IF NOT EXISTS google_columnar_engine;
CREATE EXTENSION IF NOT EXISTS pg_hint_plan;
CREATE EXTENSION IF NOT EXISTS pgaudit;


SELECT * FROM g_columnar_recommended_columns;
SELECT * FROM g_columnar_relations;


SELECT google_columnar_engine_run_recommendation(32000,'PERFORMANCE_OPTIMAL');


select * from g_columnar_columns;
select * from g_columnar_memory_usage;
select * from g_columnar_stat_statements;


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


SELECT google_columnar_engine_run_recommendation(
  32000,'PERFORMANCE_OPTIMAL'
);



SELECT * FROM g_columnar_recommended_columns;
SELECT * FROM g_columnar_relations;
select * from g_columnar_columns;

SELECT google_columnar_engine_run_recommendation(0, 'FIXED_SIZE', true);

SELECT * FROM g_columnar_relations;
select * from g_columnar_columns;
select * from g_columnar_memory_usage;
select * from g_columnar_stat_statements;

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






analyze audiencedata;
select google_columnar_engine_drop('audiencedata');
select google_columnar_engine_add('audiencedata', 'RowKey, Occupation_s, Is_Direct_s, Investor_Type_s, Stop_Marked_Flag_s');
SELECT * FROM g_columnar_relations;



