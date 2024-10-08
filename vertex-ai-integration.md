```

CREATE EXTENSION IF NOT EXISTS google_ml_integration;

GRANT EXECUTE ON FUNCTION ml_predict_row TO postgres;




SELECT
 table_name, ddl
FROM
 `bigquery-public-data`.census_bureau_usa.INFORMATION_SCHEMA.TABLES
WHERE
 table_name="population_by_zip_2010"
 
 
SELECT
 table_name, ddl
FROM
 `bigquery-public-data`.ml_dataset.INFORMATION_SCHEMA.TABLES
WHERE
 table_name="ulb_fraud_detection"
 
 
 CREATE TABLE `bigquery-public-data.ml_datasets.ulb_fraud_detection`
(
  Time FLOAT64,
  V1 FLOAT64,
  V2 FLOAT64,
  V3 FLOAT64,
  V4 FLOAT64,
  V5 FLOAT64,
  V6 FLOAT64,
  V7 FLOAT64,
  V8 FLOAT64,
  V9 FLOAT64,
  V10 FLOAT64,
  V11 FLOAT64,
  V12 FLOAT64,
  V13 FLOAT64,
  V14 FLOAT64,
  V15 FLOAT64,
  V16 FLOAT64,
  V17 FLOAT64,
  V18 FLOAT64,
  V19 FLOAT64,
  V20 FLOAT64,
  V21 FLOAT64,
  V22 FLOAT64,
  V23 FLOAT64,
  V24 FLOAT64,
  V25 FLOAT64,
  V26 FLOAT64,
  V27 FLOAT64,
  V28 FLOAT64,
  Amount FLOAT64,
  Class INT64
)
OPTIONS(
  description="This dataset contains anonymized credit card transactions made over 2 days in September 2013 by European cardholders, with 492 frauds out of 284,807 transactions.\n\nThe columns in the table labeled V1-V28 are PCA (Principal Component Analysis) transformed features. Dimensionality reducing techniques, such as PCA, reduce the computational effort required to develop and train models. It ensures the dataset provides appropriate privacy protections in this instance given the sensitive nature of credit card transactions. More detailed information on what variables are used to create these features is not available for this same reason. See the Wikipedia Article on Principal Component Analysis to learn more: https://en.wikipedia.org/wiki/Principal_component_analysis\n\nThe original features remaining that have not been masked are “Time” and “Amount”. “Time” refers to the number of seconds that elapsed between the time of the first transaction in the dataset and the time the transaction occurred. “Amount” is the transaction amount. The final feature in the dataset is “Class”, which is a binary feature that indicates if a transaction is fraudulent. A value of 1 indicates the transaction was fraud, while 0 it was not.\n\nThis dataset is frequently used for education, as well as developing and training ML models. It is well suited for learning to develop and evaluate models for unbalanced classification problems given that only 0.17% of the transactions in this dataset are labeled fraud. You can use BigQuery ML to develop a logistic regression model using this data. The BigQuery Machine Learning introduction guide can help you get started: https://cloud.google.com/bigquery/docs/bigqueryml-intro\n\nUse of this dataset should cite:\n     - Andrea Dal Pozzolo, Olivier Caelen, Reid A. Johnson and Gianluca Bontempi. Calibrating Probability with Undersampling for Unbalanced Classification. In Symposium on Computational Intelligence and Data Mining (CIDM), IEEE, 2015\n\nTERMS OF USE:\nThis data is made available under the Open Database License: http://opendatacommons.org/licenses/odbl/1.0/. Any rights in individual contents of the database are licensed under the Database Contents License: http://opendatacommons.org/licenses/dbcl/1.0/. It is provided through the Google Cloud Public Datasets Program and is provided \"AS IS\" without any warranty, express or implied, from Google. Google disclaims all liability for any damages, direct or indirect, resulting from the use of the dataset."
);





CREATE TABLE credit_card_transactions
(
  Time float8,
  V1 float8,
  V2 float8,
  V3 float8,
  V4 float8,
  V5 float8,
  V6 float8,
  V7 float8,
  V8 float8,
  V9 float8,
  V10 float8,
  V11 float8,
  V12 float8,
  V13 float8,
  V14 float8,
  V15 float8,
  V16 float8,
  V17 float8,
  V18 float8,
  V19 float8,
  V20 float8,
  V21 float8,
  V22 float8,
  V23 float8,
  V24 float8,
  V25 float8,
  V26 float8,
  V27 float8,
  V28 float8,
  Amount float8,
  Class INT
)

select * from credit_card_transactions;


COPY persons(first_name, last_name, dob, email)
FROM 'C:\sampledb\persons.csv'
DELIMITER ','
CSV HEADER;


\COPY credit_card_transactions(Time,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19,V20,V21,V22,V23,V24,V25,V26,V27,V28,Amount,Class)
FROM '/home/admin_shkm_altostrat_com/alloydb/demo-ml-integration/ulb_fruad_detection.csv'
DELIMITER ','
CSV HEADER;



dvdrental=> \COPY credit_card_transactions(Time,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19,V20,V21,V22,V23,V24,V25,V26,V27,V28,Amount,Class)
FROM '/home/admin_shkm_altostrat_com/alloydb/demo-ml-integration/ulb_fruad_detection.csv'
DELIMITER ','
CSV HEADER;

COPY 284807
dvdrental=>
dvdrental=> select count(*) from credit_card_transactions;
 count
--------
 284807
(1 row)

dvdrental=>


CREATE VIEW augmented_orders AS
  SELECT *,
    ML_PREDICT_ROW(
      ‘projects/74627175/locations/us-central1/endpoints/3247352816’,
      json_build_object('instances',
 	    json_build_array(json_object(
              ARRAY['time','amount','class','v1','v2','v3'],
              ARRAY[time,amount,class,v1,v2,v3])))
    ) AS fraud_score,
  FROM
    credit_card_transactions;




CREATE VIEW augmented_orders AS
  SELECT *,
    ML_PREDICT_ROW(
      'projects/664290125703/locations/us-central1/endpoints/2021966699107975168',
      json_build_object('instances',
 	    json_build_array(json_object(
              ARRAY['time','amount','class','v1','v2','v3'],
              ARRAY[time,amount,class,v1,v2,v3])))
    ) AS fraud_score
  FROM
    credit_card_transactions;

CREATE VIEW augmented_orders AS
  SELECT *,
    ML_PREDICT_ROW(
      'projects/664290125703/locations/us-central1/endpoints/2021966699107975168',
      json_build_object('instances',
 	    json_build_array(json_object(
              ARRAY['time','amount','class','v1','v2','v3'],
              ARRAY[time::text,amount::text,class::text,v1::text,v2::text,v3::text])))
    ) AS fraud_score
  FROM
    credit_card_transactions;


dvdrental=> select * from augmented_orders;
ERROR:  Invalid arguments: CrossRegionRequestError: Cross region requests are not supported. Cannot send request from Alloydb VM in europe-west2 to Vertex AI endpoint in us-central1. Please ensure that the Vertex AI endpoint and Alloydb VM are in the same region.
dvdrental=>


SELECT *, ML_PREDICT_ROW( 'projects/664290125703/locations/us-central1/endpoints/2021966699107975168', json_build_object('instances', json_build_array(json_object( ARRAY['time','amount','class','v1','v2','v3'], ARRAY[time::text,amount::text,class::text,v1::text,v2::text,v3::text]))) ) AS fraud_score FROM credit_card_transactions;


dvdrental=> select * from augmented_orders;
ERROR:  Invalid arguments: RestError[400]: {"error": "Column prefix: . Error: Missing struct property: Time."}
dvdrental=> SELECT *, ML_PREDICT_ROW( 'projects/664290125703/locations/us-central1/endpoints/2021966699107975168', json_build_object('instances', json_build_array(json_object( ARRAY['time','amount','class','v1','v2','v3'], ARRAY[time,amount::text,class::text,v1::text,v2::text,v3::text]))) ) AS fraud_score FROM credit_card_transactions;
ERROR:  ARRAY types double precision and text cannot be matched
LINE 1: ...ime','amount','class','v1','v2','v3'], ARRAY[time,amount::te...
                                                             ^
dvdrental=>
dvdrental=>
dvdrental=> SELECT *, ML_PREDICT_ROW( 'projects/664290125703/locations/us-central1/endpoints/2021966699107975168', json_build_object('instances', json_build_array(json_object( ARRAY['time','amount','class','v1','v2','v3'], ARRAY[time::text,amount::text,class::text,v1::text,v2::text,v3::text]))) ) AS fraud_score FROM credit_card_transactions;
ERROR:  Invalid arguments: RestError[400]: {"error": "Column prefix: . Error: Missing struct property: Time."}
dvdrental=>



CREATE TABLE credit_card_transactions2 ( 
"Time" text,
 V1 text,
 V2 text,
 V3 text,
 V4 text,
 V5 text,
 V6 text,
 V7 text,
 V8 text,
 V9 text,
 V10 text,
 V11 text,
 V12 text,
 V13 text,
 V14 text,
 V15 text,
 V16 text,
 V17 text,
 V18 text,
 V19 text,
 V20 text,
 V21 text,
 V22 text,
 V23 text,
 V24 text,
 V25 text,
 V26 text,
 V27 text,
 V28 text,
 Amount text,
 Class text );
 
 
 

SELECT *,
    ML_PREDICT_ROW(
      'projects/664290125703/locations/us-central1/endpoints/2021966699107975168',
      json_build_object('instances',
 	    json_build_array(json_object(
              ARRAY['Time','amount','class','v1','v2','v3'],
              ARRAY[time,amount,class,v1,v2,v3])))
    ) AS fraud_score
  FROM
    credit_card_transactions1;
    
    
SELECT *,
    ML_PREDICT_ROW(
      'projects/664290125703/locations/us-central1/endpoints/2021966699107975168',
      json_build_object('instances',
 	    json_build_array(row_to_json(credit_card_transactions1)))
    ) AS fraud_score
  FROM
    credit_card_transactions1;
    
SELECT *,
    ML_PREDICT_ROW(
      'projects/664290125703/locations/us-central1/endpoints/2021966699107975168',
      json_build_object('instances',
 	    json_build_array(row_to_json(credit_card_transactions2)))
    ) AS fraud_score
  FROM
    credit_card_transactions2;
    
    


CREATE TABLE credit_card_transactions3 ( 
"Time" decimal,
 "V1" decimal,
 "V2" decimal,
 "V3" decimal,
 "V4" decimal,
 "V5" decimal,
 "V6" decimal,
 "V7" decimal,
 "V8" decimal,
 "V9" decimal,
 "V10" decimal,
 "V11" decimal,
 "V12" decimal,
 "V13" decimal,
 "V14" decimal,
 "V15" decimal,
 "V16" decimal,
 "V17" decimal,
 "V18" decimal,
 "V19" decimal,
 "V20" decimal,
 "V21" decimal,
 "V22" decimal,
 "V23" decimal,
 "V24" decimal,
 "V25" decimal,
 "V26" decimal,
 "V27" decimal,
 "V28" decimal,
 "Amount" decimal,
 "Class" decimal );


\COPY credit_card_transactions3("Time","V1","V2","V3","V4","V5","V6","V7","V8","V9","V10","V11","V12","V13","V14","V15","V16","V17","V18","V19","V20","V21","V22","V23","V24","V25","V26","V27","V28","Amount","Class")
FROM '/home/admin_shkm_altostrat_com/alloydb/demo-ml-integration/ulb_fruad_detection.csv'
DELIMITER ','
CSV HEADER;


SELECT *,
    ML_PREDICT_ROW(
      'projects/664290125703/locations/us-central1/endpoints/2021966699107975168',
      json_build_object('instances',
 	    json_build_array(row_to_json(credit_card_transactions3)))
    ) AS fraud_score
  FROM
    credit_card_transactions3 limit 10;

SELECT "Time",
    ML_PREDICT_ROW(
      'projects/664290125703/locations/us-central1/endpoints/2021966699107975168',
      json_build_object('instances',
 	    json_build_array(row_to_json(credit_card_transactions3)))
    ) AS fraud_score
  FROM
    credit_card_transactions3 limit 10;




dvdrental=> drop table credit_card_transactions3;
DROP TABLE
dvdrental=> CREATE TABLE credit_card_transactions3 (
"Time" decimal,
 "V1" decimal,
 "V2" decimal,
 "V3" decimal,
 "V4" decimal,
 "V5" decimal,
 "V6" decimal,
 "V7" decimal,
 "V8" decimal,
 "V9" decimal,
 "V10" decimal,
 "V11" decimal,
 "V12" decimal,
 "V13" decimal,
 "V14" decimal,
 "V15" decimal,
 "V16" decimal,
 "V17" decimal,
 "V18" decimal,
 "V19" decimal,
 "V20" decimal,
 "V21" decimal,
 "V22" decimal,
 "V23" decimal,
 "V24" decimal,
 "V25" decimal,
 "V26" decimal,
 "V27" decimal,
 "V28" decimal,
 "Amount" decimal,
 "Class" decimal );
CREATE TABLE
dvdrental=>
dvdrental=>
dvdrental=> \COPY credit_card_transactions3("Time","V1","V2","V3","V4","V5","V6","V7","V8","V9","V10","V11","V12","V13","V14","V15","V16","V17","V18","V19","V20","V21","V22","V23","V24","V25","V26","V27","V28","Amount","Class")
FROM '/home/admin_shkm_altostrat_com/alloydb/demo-ml-integration/ulb_fruad_detection.csv'
DELIMITER ','
CSV HEADER;

COPY 284807
dvdrental=>
dvdrental=> SELECT *,
    ML_PREDICT_ROW(
      'projects/664290125703/locations/us-central1/endpoints/2021966699107975168',
      json_build_object('instances',
            json_build_array(row_to_json(credit_card_transactions3)))
    ) AS fraud_score
  FROM
    credit_card_transactions3 limit 10;


SELECT "Time",
    ML_PREDICT_ROW(
      'projects/664290125703/locations/us-central1/endpoints/2021966699107975168',
      json_build_object('instances',
 	    json_build_array(row_to_json(credit_card_transactions3)))
    ) AS fraud_score
  FROM
    credit_card_transactions3 limit 10;


  Time |                                                                                                                                         fraud_score
------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  282 | {"predictions": [{"classes": ["0", "1"], "scores": [0.9998194575309753, 0.0001804274070309475]}], "deployedModelId": "1781336380345942016", "model": "projects/664290125703/locations/us-central1/models/2725218734280015872", "modelDisplayName": "fraud_detection", "modelVersionId": "1"}
  380 | {"predictions": [{"scores": [0.9999871850013733, 1.276578132092254e-05], "classes": ["0", "1"]}], "deployedModelId": "1781336380345942016", "model": "projects/664290125703/locations/us-central1/models/2725218734280015872", "modelDisplayName": "fraud_detection", "modelVersionId": "1"}
  403 | {"predictions": [{"classes": ["0", "1"], "scores": [0.9999024271965027, 9.760318062035367e-05]}], "deployedModelId": "1781336380345942016", "model": "projects/664290125703/locations/us-central1/models/2725218734280015872", "modelDisplayName": "fraud_detection", "modelVersionId": "1"}
  430 | {"predictions": [{"scores": [0.999915599822998, 8.445246930932626e-05], "classes": ["0", "1"]}], "deployedModelId": "1781336380345942016", "model": "projects/664290125703/locations/us-central1/models/2725218734280015872", "modelDisplayName": "fraud_detection", "modelVersionId": "1"}
  711 | {"predictions": [{"scores": [0.9998144507408142, 0.0001855119771789759], "classes": ["0", "1"]}], "deployedModelId": "1781336380345942016", "model": "projects/664290125703/locations/us-central1/models/2725218734280015872", "modelDisplayName": "fraud_detection", "modelVersionId": "1"}
  804 | {"predictions": [{"classes": ["0", "1"], "scores": [0.9999476671218872, 5.231059185462072e-05]}], "deployedModelId": "1781336380345942016", "model": "projects/664290125703/locations/us-central1/models/2725218734280015872", "modelDisplayName": "fraud_detection", "modelVersionId": "1"}
  820 | {"predictions": [{"scores": [0.9999381303787231, 6.185776146594435e-05], "classes": ["0", "1"]}], "deployedModelId": "1781336380345942016", "model": "projects/664290125703/locations/us-central1/models/2725218734280015872", "modelDisplayName": "fraud_detection", "modelVersionId": "1"}
  912 | {"predictions": [{"scores": [0.9996384978294373, 0.0003615196037571877], "classes": ["0", "1"]}], "deployedModelId": "1781336380345942016", "model": "projects/664290125703/locations/us-central1/models/2725218734280015872", "modelDisplayName": "fraud_detection", "modelVersionId": "1"}
 1193 | {"predictions": [{"scores": [0.9996464252471924, 0.0003535606665536761], "classes": ["0", "1"]}], "deployedModelId": "1781336380345942016", "model": "projects/664290125703/locations/us-central1/models/2725218734280015872", "modelDisplayName": "fraud_detection", "modelVersionId": "1"}
 1443 | {"predictions": [{"classes": ["0", "1"], "scores": [0.9997483491897583, 0.0002515861415304244]}], "deployedModelId": "1781336380345942016", "model": "projects/664290125703/locations/us-central1/models/2725218734280015872", "modelDisplayName": "fraud_detection", "modelVersionId": "1"}
(10 rows)

(END)
  
```
