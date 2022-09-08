


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


