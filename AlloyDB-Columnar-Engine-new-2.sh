mytpch=> \c postgres
psql (14.4 (Debian 14.4-1.pgdg100+1), server 14.2)
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
You are now connected to database "postgres" as user "postgres".
postgres=>
postgres=>
postgres=>
postgres=>
postgres=> create database shtest;
CREATE DATABASE
Time: 548.792 ms
postgres=> \c shtest
psql (14.4 (Debian 14.4-1.pgdg100+1), server 14.2)
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
You are now connected to database "shtest" as user "postgres".
shtest=>
shtest=> CREATE TABLE phonebook(phone VARCHAR(32), firstname VARCHAR(32), lastname VARCHAR(32), address VARCHAR(64));
CREATE TABLE
Time: 184.617 ms
shtest=> INSERT INTO phonebook(phone, firstname, lastname, address) VALUES('+1 123 456 7890', 'John', 'Doe', 'North America');
INSERT 0 1
Time: 151.178 ms
shtest=> insert into phonebook select * from phonebook;
INSERT 0 1
Time: 143.074 ms
shtest=> insert into phonebook select * from phonebook;
INSERT 0 2
Time: 149.834 ms
shtest=> insert into phonebook select * from phonebook;
INSERT 0 4
Time: 149.860 ms
shtest=> insert into phonebook select * from phonebook;
INSERT 0 8
Time: 149.882 ms
shtest=> insert into phonebook select * from phonebook;
INSERT 0 16
Time: 149.849 ms
shtest=> insert into phonebook select * from phonebook;
INSERT 0 32
Time: 150.231 ms
shtest=> insert into phonebook select * from phonebook;
INSERT 0 64
Time: 150.210 ms
shtest=> insert into phonebook select * from phonebook;
INSERT 0 128
Time: 150.403 ms
shtest=> insert into phonebook select * from phonebook;
INSERT 0 256
Time: 152.047 ms
shtest=> insert into phonebook select * from phonebook;
INSERT 0 512
Time: 154.367 ms
shtest=> insert into phonebook select * from phonebook;
INSERT 0 1024
Time: 152.542 ms
shtest=> insert into phonebook select * from phonebook;
INSERT 0 2048
Time: 154.339 ms
shtest=> insert into phonebook select * from phonebook;
INSERT 0 4096
Time: 155.510 ms
shtest=> insert into phonebook select * from phonebook;
INSERT 0 8192
Time: 161.432 ms
shtest=> insert into phonebook select * from phonebook;
INSERT 0 16384
Time: 171.234 ms
shtest=> insert into phonebook select * from phonebook;
INSERT 0 32768
Time: 204.080 ms
shtest=> insert into phonebook select * from phonebook;
INSERT 0 65536
Time: 243.530 ms
shtest=> insert into phonebook select * from phonebook;
INSERT 0 131072
Time: 330.767 ms
shtest=> insert into phonebook select * from phonebook;
INSERT 0 262144
Time: 530.651 ms
shtest=> insert into phonebook select * from phonebook;
^[[A
INSERT 0 524288
Time: 1055.437 ms (00:01.055)
shtest=> insert into phonebook select * from phonebook;
INSERT 0 1048576
Time: 1735.138 ms (00:01.735)
shtest=> insert into phonebook select * from phonebook;
INSERT 0 2097152
Time: 3235.003 ms (00:03.235)
shtest=> SELECT count(*) from phonebook;
  count
---------
 4194304
(1 row)

Time: 421.390 ms
shtest=> CREATE EXTENSION IF NOT EXISTS google_columnar_engine;
CREATE EXTENSION
Time: 211.099 ms
shtest=> CREATE EXTENSION IF NOT EXISTS pg_hint_plan;
CREATE EXTENSION
Time: 179.900 ms
shtest=> CREATE EXTENSION IF NOT EXISTS pgaudit;
ERROR:  the pgaudit extension is not enabled
HINT:  Please refer to AlloyDB documentation for supported extensions.
Time: 143.641 ms
shtest=> SELECT * FROM g_columnar_recommended_columns;
 database_name | schema_name | relation_name | column_name | compression_level | estimated_size_in_bytes
---------------+-------------+---------------+-------------+-------------------+-------------------------
(0 rows)

Time: 141.126 ms
shtest=> SELECT * FROM g_columnar_relations;
Time: 140.901 ms
shtest=> \a
Output format is unaligned.
shtest=> SELECT * FROM g_columnar_relations;
database_name|schema_name|relation_name|status|size|uncompressed_size|columnar_unit_count|invalid_block_count|block_count_in_cc|total_block_count|auto_refresh_trigger_count|auto_refresh_failure_count|auto_refresh_recent_status
(0 rows)
Time: 141.064 ms
shtest=> \a
Output format is aligned.
shtest=> SELECT google_columnar_engine_run_recommendation(
shtest(>   16000,'PERFORMANCE_OPTIMAL'
shtest(> );
                          google_columnar_engine_run_recommendation
---------------------------------------------------------------------------------------------
 (128,"mytpch.public.lineitem(l_commitdate,l_orderkey,l_receiptdate,l_shipdate,l_shipmode)")
(1 row)

Time: 3744.430 ms (00:03.744)
shtest=> \dt phonebook
           List of relations
 Schema |   Name    | Type  |  Owner
--------+-----------+-------+----------
 public | phonebook | table | postgres
(1 row)

shtest=> \d phonebook
                      Table "public.phonebook"
  Column   |         Type          | Collation | Nullable | Default
-----------+-----------------------+-----------+----------+---------
 phone     | character varying(32) |           |          |
 firstname | character varying(32) |           |          |
 lastname  | character varying(32) |           |          |
 address   | character varying(64) |           |          |

shtest=> select count(*) from phonebook where lastname='Doe';
  count
---------
 4194304
(1 row)

Time: 504.857 ms
shtest=> select count(*) from phonebook where lastname='Doe';
  count
---------
 4194304
(1 row)

Time: 492.092 ms
shtest=> select count(*) from phonebook where lastname='Doe';
  count
---------
 4194304
(1 row)

Time: 492.059 ms
shtest=> select count(*) from phonebook where lastname='Doe';
  count
---------
 4194304
(1 row)

Time: 507.761 ms
shtest=> explain select count(*) from phonebook where lastname='Doe';
                                          QUERY PLAN
----------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=62167.56..62167.57 rows=1 width=8)
   ->  Gather  (cost=62167.34..62167.55 rows=2 width=8)
         Workers Planned: 2
         ->  Partial Aggregate  (cost=61167.34..61167.35 rows=1 width=8)
               ->  Parallel Seq Scan on phonebook  (cost=0.00..56798.29 rows=1747623 width=0)
                     Filter: ((lastname)::text = 'Doe'::text)
(6 rows)

Time: 140.875 ms
shtest=> SELECT google_columnar_engine_run_recommendation(
shtest(>   16000,'PERFORMANCE_OPTIMAL'
shtest(> );
                                           google_columnar_engine_run_recommendation
-------------------------------------------------------------------------------------------------------------------------------
 (128,"mytpch.public.lineitem(l_commitdate,l_orderkey,l_receiptdate,l_shipdate,l_shipmode),shtest.public.phonebook(lastname)")
(1 row)

Time: 8148.817 ms (00:08.149)
shtest=>
shtest=>
shtest=>
shtest=> SELECT * FROM g_columnar_relations;
Time: 140.890 ms
shtest=> \a
Output format is unaligned.
shtest=> SELECT * FROM g_columnar_relations;
database_name|schema_name|relation_name|status|size|uncompressed_size|columnar_unit_count|invalid_block_count|block_count_in_cc|total_block_count|auto_refresh_trigger_count|auto_refresh_failure_count|auto_refresh_recent_status
(0 rows)
Time: 141.325 ms
shtest=> \a
Output format is aligned.
shtest=>
shtest=>
shtest=> SELECT google_columnar_engine_run_recommendation(0, 'FIXED_SIZE', true);
                                            google_columnar_engine_run_recommendation
---------------------------------------------------------------------------------------------------------------------------------
 (16000,"mytpch.public.lineitem(l_commitdate,l_orderkey,l_receiptdate,l_shipdate,l_shipmode),shtest.public.phonebook(lastname)")
(1 row)

Time: 9649.732 ms (00:09.650)
shtest=>
shtest=>
shtest=> SELECT * FROM g_columnar_relations;
Time: 141.034 ms
shtest=> \a
Output format is unaligned.
shtest=> SELECT * FROM g_columnar_relations;
database_name|schema_name|relation_name|status|size|uncompressed_size|columnar_unit_count|invalid_block_count|block_count_in_cc|total_block_count|auto_refresh_trigger_count|auto_refresh_failure_count|auto_refresh_recent_status
shtest|public|phonebook|Usable|12737901|12737901|9|0|34953|34953|0|0|NONE YET
(1 row)
Time: 141.054 ms
shtest=>
shtest=>
shtest=>
shtest=> SELECT * FROM g_columnar_recommended_columns;
database_name|schema_name|relation_name|column_name|compression_level|estimated_size_in_bytes
shtest|public|phonebook|lastname|1|5073737
(1 row)
Time: 141.223 ms
shtest=> EXPLAIN (ANALYZE,COSTS OFF,BUFFERS,TIMING OFF,SUMMARY OFF)
shtest-> select count(*) from phonebook where lastname='Doe';
QUERY PLAN
Finalize Aggregate (actual rows=1 loops=1)
  ->  Gather (actual rows=3 loops=1)
        Workers Planned: 2
        Workers Launched: 2
        ->  Partial Aggregate (actual rows=1 loops=3)
              ->  Parallel Append (actual rows=1 loops=3)
                    ->  Parallel Custom Scan (columnar scan) on phonebook (actual rows=1398101 loops=3)
                          Filter: ((lastname)::text = 'Doe'::text)
                          Rows Removed by Columnar Filter: 0
                          Rows Aggregated by Columnar Scan: 819200
                          Columnar cache search mode: native
                    ->  Parallel Seq Scan on phonebook (never executed)
                          Filter: ((lastname)::text = 'Doe'::text)
(13 rows)
Time: 164.410 ms
shtest=>
shtest=>
shtest=>

