psql -h 10.45.195.2 -U postgres







JSON Document:

  

{"R1_s":"JNSX","T1_s":"T87","B1_s":"I","RowKey":"JNSX_T87I","Index_dt_s":"06212022","type_s":"parent","PAN_number_s":"A1PPB0970M","Name_s":"KEITH BORTHWICK","ACCOUNT":{"R1_s":"JNSX","T1_s":"T87","B1_s":"I","type_s":"child","RowKey":"JNSX_T87I_ACCOUNT_1143969242_DY_DP_R","Folio_Number_s":"1143969242"}}]

 

Table Schema:

  

   CREATE TYPE "ACCOUNT_TYPE" AS (
       "RowKey"     varchar(100),
       "R1_s"     varchar(100),
       "T1_s"     varchar(10),
       "B1_s"     varchar(10),
       "type_s"   varchar(10),
       "Folio_Number_s" integer
   );

  

   create table audiencedatanew
   (
    "RowKey"    varchar(100) primary key,
    "T1_s"      varchar(10) not null,
    "B1_s"      varchar(10) not null,
    "R1_s"      varchar(10) not null,
    "Index_dt_s" varchar(10) null,
    "type_s"     varchar(10) not null,
    "PAN_number_s"   varchar(100) not null,
    "Name_s" varchar(100) not null,
    "ACCOUNT" "ACCOUNT_TYPE"
   );

  

Insert Query:

  

   insert into audiencedata ("RowKey","T1_s","B1_s","R1_s","Index_dt_s","type_s","PAN_number_s","Name_s","ACCOUNT")
   select p.*,p1.*
   from audience_import_child l
     cross join lateral json_populate_recordset(null::audiencedata, doc) as p,
     cross join lateral json_populate_recordset(null::audiencedata, doc."ACCOUNT_TYPE") as p1,
     on conflict ("RowKey") do update
     set "RowKey" = excluded."RowKey",
         "T1_s" = excluded."T1_s",
         "B1_s" = excluded."B1_s",
         "R1_s" = excluded."R1_s",
         "Index_dt_s" = excluded."Index_dt_s",
         "type_s" = excluded."type_s",
         "PAN_number_s" = excluded."PAN_number_s",
         "Name_s" = excluded."Name_s",
         "ACCOUNT"=excluded."ACCOUNT";

  

We are not  sure whether the above insert query is correct or not. While executing, it got failed.

  

   The following insert query works fine for only parent data insertion.

  

   insert into audiencedata ("RowKey","T1_s","B1_s","R1_s","Index_dt_s","type_s","PAN_number_s","Name_s")
   select p.* from customer_import l
     cross join lateral json_populate_recordset(null::audiencedata, doc) as p
     on conflict ("RowKey") do update
     set "RowKey" = excluded."RowKey",
         "T1_s" = excluded."T1_s",
         "B1_s" = excluded."B1_s",
         "R1_s" = excluded."R1_s",
         "Index_dt_s" = excluded."Index_dt_s",
         "type_s" = excluded."type_s",
         "PAN_number_s" = excluded."PAN_number_s",
         "Name_s" = excluded."Name_s";
        

Hope you can help us here.

 
select p.*
from json_populate_recordset
(null::audiencedatanew,
'[{"R1_s":"HD6H","T1_s":"T87","B1_s":"I","RowKey":"HD6H_T87I",
"Index_dt_s":"06212022","type_s":"parent","PAN_number_s":"8QUPP3162M",
"Name_s":"SMT SHIVANI PATNAIK"},
{"R1_s":"JNSX","T1_s":"T87","B1_s":"I","RowKey":"JNSX_T87I",
"Index_dt_s":"06212022","type_s":"parent","PAN_number_s":"A1PPB0970M",
"Name_s":"KEITH BORTHWICK",
"ACCOUNT":[{"R1_s":"JNSX","T1_s":"T87","B1_s":"I","type_s":"child",
"RowKey":"JNSX_T87I_ACCOUNT_1143969242_DY_DP_R","Folio_Number_s":"1143969242"},
            {"R1_s":"JNSX","T1_s":"T87","B1_s":"I","type_s":"child",
"RowKey":"JNSX_T87I_ACCOUNT_1143969999_DY_DP_R","Folio_Number_s":"1143969999"}]
}]')
as p;

 

select p.*
from json_populate_recordset
(null::audiencedatanew,
'[{"R1_s":"JNSX","T1_s":"T87","B1_s":"I","RowKey":"JNSX_T87I",
"Index_dt_s":"06212022","type_s":"parent","PAN_number_s":"A1PPB0970M",
"Name_s":"KEITH BORTHWICK",
"ACCOUNT":{"R1_s":"JNSX","T1_s":"T87","B1_s":"I","type_s":"child",
"RowKey":"JNSX_T87I_ACCOUNT_1143969242_DY_DP_R","Folio_Number_s":"1143969242"}
}]')
as p;



shailesh=> select p.*
from json_populate_recordset
(null::audiencedatanew,
'[{"R1_s":"JNSX","T1_s":"T87","B1_s":"I","RowKey":"JNSX_T87I",
"Index_dt_s":"06212022","type_s":"parent","PAN_number_s":"A1PPB0970M",
"Name_s":"KEITH BORTHWICK",
"ACCOUNT":{"R1_s":"JNSX","T1_s":"T87","B1_s":"I","type_s":"child",
"RowKey":"JNSX_T87I_ACCOUNT_1143969242_DY_DP_R","Folio_Number_s":"1143969242"}
}]')
as p;
  RowKey   | T1_s | B1_s | R1_s | Index_dt_s | type_s | PAN_number_s |     Name_s      |                              ACCOUNT
-----------+------+------+------+------------+--------+--------------+-----------------+--------------------------------------------------------------------
 JNSX_T87I | T87  | I    | JNSX | 06212022   | parent | A1PPB0970M   | KEITH BORTHWICK | (JNSX_T87I_ACCOUNT_1143969242_DY_DP_R,JNSX,T87,I,child,1143969242)
(1 row)

shailesh=>



 

 
 
 
 
