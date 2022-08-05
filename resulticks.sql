CREATE TABLE audiencedata
(
  "RowKey"    VARCHAR(100) PRIMARY KEY, 
  "T1_s"      VARCHAR(10) NOT NULL,
  "B1_s"      VARCHAR(10) NOT NULL,
  "R1_s"      VARCHAR(10) NOT NULL,
  "Index_dt" date null,
  "Index_dt_s" VARCHAR(10) NULL,
  "type_s"     VARCHAR(10) NOT NULL,
  "IsEmail_b" boolean NOT NULL,
  "IsMobile_b" boolean NOT NULL,
  "TAN_number_s"   VARCHAR(100) NOT NULL,
  "Name_s" VARCHAR(500) NULL,
  "Channel_s"  varchar(500) NULL,
  "Campaign_name_s"  varchar(500) NULL,
  "OSType_s"  varchar(500) NULL,
  "Marital_Status_s"  varchar(500) NULL,
  "City_s"  varchar(500) NULL,
  "Clean_City_s"  varchar(500) NULL,
  "State_s"  varchar(500) NULL,
  "Country_s"  varchar(500) NULL,
  "PIN_Code_s"  varchar(500) NULL,
  "Date_of_Birth_dt" timestamp NULL,
  "Age_i" integer NULL,
  "Date_of_Birth_day_i" integer NULL,
  "Date_of_Birth_month_i" integer NULL,
  "Date_of_Birth_year_i" integer NULL,
  "CustomerType_s"  varchar(500) NULL,
  "Occupation_s"  varchar(500) NULL,
  "Is_Agent_s"  varchar(500) NULL,
  "Is_Direct_s"  varchar(500) NULL,
  "Is_BuddyAppUser_s"  varchar(500) NULL,
  "Is_B2CAppUser_s"  varchar(500) NULL,
  "Is_EmailUnsubscribe_s"  varchar(500) NULL,
  "InvestorDirectFlag_s"  varchar(500) NULL,
  "Channel_Name_s"  varchar(500) NULL,
  "Classification_s"  varchar(500) NULL,
  "Total_Number_of_Folios_i" integer NULL,
  "Total_Schemes_i" integer NULL,
  "Total_EquityScheme_i" integer NULL,
  "Primary_TAN_Count_i" integer NULL,
  "Total_Offline_TXN_i" integer NULL,
  "Total_Offline_Value_d" NUMERIC(25,10) NULL,
  "Investor_Type_s"  varchar(500) NULL,
  "First_Transaction_Scheme_Name_s"  varchar(500) NULL,
  "First_Transaction_Amount_d" NUMERIC(25,10) NULL,
  "First_Transaction_Type_s"  varchar(500) NULL,
  "First_Transaction_ARN_Number_s"  varchar(500) NULL,
  "First_Transaction_IFA_Name_s"  varchar(500) NULL,
  "First_TXN_Date_dt" timestamp NULL,
  "First_Transaction_Date_PN_s"  varchar(500) NULL,
  "No_Of_Years_Completed_i" integer NULL,
  "First_TXN_Channel_s"  varchar(500) NULL,
  "First_TXN_Channel_Name_s"  varchar(500) NULL,
  "ABM_Channel_s"  varchar(500) NULL,
  "First_Transaction_day_i" integer NULL,
  "First_Transaction_month_i" integer NULL,
  "OTM_Enabled_Flag_s"  varchar(500) NULL,
  "Current_Value_of_Investment_TAN_d" NUMERIC(25,10) NULL,
  "LastTransactionEUIN_s"  varchar(500) NULL,
  "LastTransactiondDate_dt" timestamp NULL,
  "Customer_Buckets_s"  varchar(500) NULL,
  "Stop_Marked_Flag_s" varchar(500) NULL
);

CREATE TYPE "INVESTOR" AS
(
"RowKey"    VARCHAR(100), 
"T1_s"      VARCHAR(10),
"B1_s"      VARCHAR(10),
"R1_s"      VARCHAR(10),
"type_s" VARCHAR(100),
"cattype_s" VARCHAR(100),
"Index_dt_s" VARCHAR(100),
"Index_dt" timestamp,
"SubCategory_s"  VARCHAR(100),
"Gender_s"  VARCHAR(10),
"Title_s"  VARCHAR(500),
"Income_Slab_s"  VARCHAR(100),
"DP_id_for_NSDL_CDSL_s"  VARCHAR(500),
"Profession_s"  VARCHAR(10),
"Qualification_s"  VARCHAR(100),
"KYC_Compliant_s"  VARCHAR(500),
"Prospect_to_Investor_Date_dt"  timestamp,
"Folio_Number_s"  VARCHAR(500),
"Folio_Applicant_Type_s"  VARCHAR(500),
"Folio_Mode_of_Holding_s"  VARCHAR(500),
"Marital_Status_s"  VARCHAR(10),
"Second_Holder_Name_s"  VARCHAR(100),
"Third_Holder_Name_s"  VARCHAR(100),
"Guardian_Name_s"  VARCHAR(100),
"Folio_Investor_Type_s"  VARCHAR(500)
);

CREATE TYPE "SIP" AS
(
"RowKey"    VARCHAR(100), 
"T1_s"      VARCHAR(10),
"B1_s"      VARCHAR(10),
"R1_s"      VARCHAR(10),
"type_s" VARCHAR(100),
"cattype_s" VARCHAR(100),
"Index_dt_s" VARCHAR(100),
"Index_dt" timestamp,
"SubCategory_s"  VARCHAR(100),
"SIP_Start_Date_dt"  timestamp,
"SIP_End_Date_dt"  timestamp,
"SIP_Installment_Amount_d"  NUMERIC(25,10),
"SIP_Installment_Frquency_s"  VARCHAR(500),
"SIP_Status_s"  VARCHAR(500),
"SIP_Termination_Date_dt"  timestamp,
"SIP_Type_s"  VARCHAR(500),
"SIP_Transaction_Type_s"  VARCHAR(500),
"SIP_Scheme_Code_s"  VARCHAR(500),
"SIP_Plan_Code_s"  VARCHAR(500),
"SIP_Branch_Code_s"  VARCHAR(500),
"SIP_ARN_Number_s"  VARCHAR(500),
"SIP_Payment_Mode_s"  VARCHAR(500),
"SIP_Scheme_Name_s"  VARCHAR(500),
"SIP_Pending_Installments_i"  integer,
"SIP_Registeration_Date_dt"  timestamp
);

CREATE TYPE "ACCOUNT" AS 
(
"RowKey"    VARCHAR(100), 
"T1_s"      VARCHAR(10),
"B1_s"      VARCHAR(10),
"R1_s"      VARCHAR(10),
"type_s" VARCHAR(100),
"cattype_s" VARCHAR(100),
"Index_dt_s" VARCHAR(100),
"Index_dt" timestamp,
"SubCategory_s"  VARCHAR(100),
"Folio_Number_s" VARCHAR(500),
"Scheme_Name_s"  VARCHAR(500),
"Scheme_Plan_Description_s"  VARCHAR(500),
"Scheme_Option_Description_s"  VARCHAR(500),
"Scheme_Nature_s"  VARCHAR(500),
"Scheme_Open_Date_dt"  timestamp,
"Scheme_Close_Date_dt"  timestamp,
"Scheme_Fund_Category_s"  VARCHAR(500),
"Scheme_STP_In_Allow_s"  VARCHAR(500),
"Scheme_STP_Out_Allow_s"  VARCHAR(500),
"Scheme_SIP_Allow_s"  VARCHAR(500),
"Scheme_SWP_Allow_s"  VARCHAR(500),
"Option_Code_s"  VARCHAR(500),
"Current_Value_of_Investment_d"  NUMERIC(25,10),
"Last_NAV_d"  NUMERIC(25,10),
"Balance_Units_i"  integer,
"Scheme_Code_s"  VARCHAR(500),
"Age_of_Fund_i"  integer
);

CREATE TYPE "ND" AS
(
"RowKey"    VARCHAR(100), 
"T1_s"      VARCHAR(10),
"B1_s"      VARCHAR(10),
"R1_s"      VARCHAR(10),
"type_s" VARCHAR(100),
"cattype_s" VARCHAR(100),
"Index_dt_s" VARCHAR(100),
"Index_dt" timestamp,
"SubCategory_s"  VARCHAR(100),
"ND_SCHEME_s"  VARCHAR(500),
"ND_PLAN_s"  VARCHAR(500),
"ND_ACNO_s"  VARCHAR(500),
"ND_TYPE_s"  VARCHAR(500),
"ND_NAME_s"  VARCHAR(100),
"ND_dob_dt"  timestamp,
"ND_RELATION_s"  VARCHAR(500),
"ND_ECS_s"  VARCHAR(500),
"ND_COUNTRY_s"  VARCHAR(100)
);


CREATE TYPE "TXNChannelSummary" AS
(
"RowKey"    VARCHAR(100), 
"T1_s"      VARCHAR(10),
"B1_s"      VARCHAR(10),
"R1_s"      VARCHAR(10),
"type_s" VARCHAR(100),
"cattype_s" VARCHAR(100),
"Index_dt_s" VARCHAR(100),
"Index_dt" timestamp,
"SubCategory_s"  VARCHAR(100),
"Channel_Mode_s"  VARCHAR(500),
"Channel_Count_i"  integer,
"Channel_Sales_Value_d"  NUMERIC(25,10)
);

alter table audiencedata add "INVESTOR" "INVESTOR"[];
alter table audiencedata add "SIP" "SIP"[];
alter table audiencedata add "ACCOUNT" "ACCOUNT"[];
alter table audiencedata add "ND" "ND"[];
alter table audiencedata add "TXNChannelSummary" "TXNChannelSummary"[];

create unlogged table audience_json_load (doc jsonb);
\copy audience_json_load from '/home/admin_shkm_altostrat_com/alloydb/resulticks/data.json';
\copy audience_json_load from '/home/admin_shkm_altostrat_com/alloydb/resulticks/JSONData.json';
\copy audience_json_load from '/home/admin_shkm_altostrat_com/alloydb/resulticks/SOLR_T87_I_FULL_36_6_20220621064254.json';
\copy audience_json_load from '/home/admin_shkm_altostrat_com/alloydb/resulticks/SOLR_T87_I_FULL_36_5_20220621064253.json';


insert into audiencedata("RowKey","T1_s","B1_s","R1_s","Index_dt","Index_dt_s","type_s","IsEmail_b","IsMobile_b","TAN_number_s","Channel_s","Age_i","State_s","Country_s","Occupation_s","Campaign_name_s","OSType_s","Date_of_Birth_dt","Marital_Status_s","City_s","PIN_Code_s","Channel_Name_s","Classification_s","Is_Agent_s","Is_Direct_s","Is_EmailUnsubscribe_s","CustomerType_s","Clean_City_s","Is_BuddyAppUser_s","Is_B2CAppUser_s","InvestorDirectFlag_s","Name_s","First_TXN_Channel_s","First_TXN_Channel_Name_s","ABM_Channel_s","First_TXN_Date_dt","Total_Number_of_Folios_i","Total_Schemes_i","Primary_TAN_Count_i","Total_Offline_Value_d","Date_of_Birth_day_i","Date_of_Birth_month_i","Investor_Type_s","First_Transaction_Scheme_Name_s","First_Transaction_Amount_d","First_Transaction_Type_s","First_Transaction_ARN_Number_s","First_Transaction_IFA_Name_s","OTM_Enabled_Flag_s","No_Of_Years_Completed_i","First_Transaction_Date_PN_s","Stop_Marked_Flag_s","Current_Value_of_Investment_TAN_d","LastTransactionEUIN_s","Customer_Buckets_s","INVESTOR","SIP","ACCOUNT","ND","TXNChannelSummary")                         select p."RowKey",p."T1_s",p."B1_s",p."R1_s",p."Index_dt",p."Index_dt_s",p."type_s",p."IsEmail_b",p."IsMobile_b",p."TAN_number_s",p."Channel_s",p."Age_i",p."State_s",p."Country_s",p."Occupation_s",p."Campaign_name_s",p."OSType_s",p."Date_of_Birth_dt",p."Marital_Status_s",p."City_s",p."PIN_Code_s",p."Channel_Name_s",p."Classification_s",p."Is_Agent_s",p."Is_Direct_s",p."Is_EmailUnsubscribe_s",p."CustomerType_s",p."Clean_City_s",p."Is_BuddyAppUser_s",p."Is_B2CAppUser_s",p."InvestorDirectFlag_s",p."Name_s",p."First_TXN_Channel_s",p."First_TXN_Channel_Name_s",p."ABM_Channel_s",p."First_TXN_Date_dt",p."Total_Number_of_Folios_i",p."Total_Schemes_i",p."Primary_TAN_Count_i",p."Total_Offline_Value_d",p."Date_of_Birth_day_i",p."Date_of_Birth_month_i",p."Investor_Type_s",p."First_Transaction_Scheme_Name_s", p."First_Transaction_Amount_d",p."First_Transaction_Type_s",p."First_Transaction_ARN_Number_s",p."First_Transaction_IFA_Name_s",p."OTM_Enabled_Flag_s",p."No_Of_Years_Completed_i",p."First_Transaction_Date_PN_s",p."Stop_Marked_Flag_s",p."Current_Value_of_Investment_TAN_d",p."LastTransactionEUIN_s",p."Customer_Buckets_s",p."INVESTOR",p."SIP",p."ACCOUNT",p."ND",p."TXNChannelSummary" from json_populate_recordset(null::audiencedata, (select doc from audience_json_load)::json) as p where p."RowKey" is not null ;

select count(distinct M."RowKey") from audiencedata AS M 
where M."Is_Direct_s"='Yes' AND M."Investor_Type_s"='RIA'
AND M."Occupation_s" IN ('OTHERS')  
AND M."RowKey" IN (select distinct M1."RowKey" from audiencedata AS M1 
                       cross join unnest("INVESTOR") as TC
                      where TC."Folio_Applicant_Type_s"='HUF')
AND M."RowKey" NOT IN (select distinct M1."RowKey" from audiencedata AS M1 
                      where M1."Stop_Marked_Flag_s"='No')
AND M."RowKey" NOT IN (select TC1."RowKey" from audiencedata AS M1 
                       cross join unnest("SIP") as TC1
                      where TC1."SIP_Status_s" IN ('LIVE SIP','ACTIVE'));


explain (analyze, buffers, timing, verbose) select count(distinct M."RowKey") from audiencedata AS M 
where M."Is_Direct_s"='Yes' AND M."Investor_Type_s"='RIA'
AND M."Occupation_s" IN ('OTHERS')  
AND M."RowKey" IN (select distinct M1."RowKey" from audiencedata AS M1 
                       cross join unnest("INVESTOR") as TC
                      where TC."Folio_Applicant_Type_s"='HUF')
AND M."RowKey" NOT IN (select distinct M1."RowKey" from audiencedata AS M1 
                      where M1."Stop_Marked_Flag_s"='No')
AND M."RowKey" NOT IN (select TC1."RowKey" from audiencedata AS M1 
                       cross join unnest("SIP") as TC1
                      where TC1."SIP_Status_s" IN ('LIVE SIP','ACTIVE'));
                      
                      
                      
select count(distinct M."RowKey") from audiencedata AS M 
where M."Is_Direct_s"='Yes' AND M."Investor_Type_s"='RIA'
AND M."Occupation_s" IN ('OTHERS')  
AND M."RowKey" IN (select distinct M1."RowKey" from audiencedata AS M1 
                       cross join unnest("INVESTOR") as TC
                      where TC."Folio_Applicant_Type_s"='HUF')
AND M."RowKey" NOT IN (select distinct M1."RowKey" from audiencedata AS M1 
                      where M1."Stop_Marked_Flag_s"='No')
AND NOT EXISTS (select 1 from audiencedata AS M1 
                       cross join unnest("SIP") as TC1
                      where TC1."SIP_Status_s" IN ('LIVE SIP','ACTIVE') and M."RowKey"=TC1."RowKey");
                      
                      
explain select count(distinct M."RowKey") from audiencedata AS M 
where M."Is_Direct_s"='Yes' AND M."Investor_Type_s"='RIA'
AND M."Occupation_s" IN ('OTHERS')  
AND M."RowKey" IN (select distinct M1."RowKey" from audiencedata AS M1 
                       cross join unnest("INVESTOR") as TC
                      where TC."Folio_Applicant_Type_s"='HUF')
AND M."RowKey" NOT IN (select distinct M1."RowKey" from audiencedata AS M1 
                      where M1."Stop_Marked_Flag_s"='No')
AND NOT EXISTS (select 1 from audiencedata AS M1 
                       cross join unnest("SIP") as TC1
                      where TC1."SIP_Status_s" IN ('LIVE SIP','ACTIVE') and M."RowKey"=TC1."RowKey");


explain (analyze, buffers, timing, verbose) select count(distinct M."RowKey") from audiencedata AS M 
where M."Is_Direct_s"='Yes' AND M."Investor_Type_s"='RIA'
AND M."Occupation_s" IN ('OTHERS')  
AND M."RowKey" IN (select distinct M1."RowKey" from audiencedata AS M1 
                       cross join unnest("INVESTOR") as TC
                      where TC."Folio_Applicant_Type_s"='HUF')
AND M."RowKey" NOT IN (select distinct M1."RowKey" from audiencedata AS M1 
                      where M1."Stop_Marked_Flag_s"='No')
AND NOT EXISTS (select 1 from audiencedata AS M1 
                       cross join unnest("SIP") as TC1
                      where TC1."SIP_Status_s" IN ('LIVE SIP','ACTIVE') and M."RowKey"=TC1."RowKey");


 
                      



\copy audience_json_load from '/home/admin_shkm_altostrat_com/alloydb/resulticks/SOLR_T87_I_FULL_36_6_20220621064254.json


