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


sudo apt-get -y install postgresql-contrib

pgbench -i --host=10.45.195.2 --username=postgres postgres

pgbench --host=10.45.195.2 --username=postgres postgres

performance test against 10 clients that are accessing your AlloyDB for PostgreSQL database and 100 transactions for each client.
pgbench --host=10.45.195.2 --username=postgres -c 10 --transactions=100
