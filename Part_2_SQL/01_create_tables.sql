-- =====================================================================
--  PART 2 | SQL ANALYSIS  -  Telecom Customer Churn
--  File 01: Create database, load the cleaned CSV, build 4 grouped tables
--  Engine : MySQL 8.0+
--  Input  : data/telco_churn_cleaned.csv  (output of Part 1: EDA)
-- =====================================================================

-- STEP 1: Create the database
CREATE DATABASE IF NOT EXISTS telecom_churn;
USE telecom_churn;

-- STEP 2: Staging table = exact copy of the CSV file
DROP TABLE IF EXISTS stg_telco;
CREATE TABLE stg_telco (
    CustomerID        VARCHAR(20),
    Gender            VARCHAR(10),
    SeniorCitizen     INT,
    TenureMonths      INT,
    ContractType      VARCHAR(20),
    InternetService   VARCHAR(20),
    TechSupport       VARCHAR(20),
    PaperlessBilling  VARCHAR(5),
    PaymentMethod     VARCHAR(30),
    MonthlyCharges    DECIMAL(12,5),
    TotalCharges      DECIMAL(12,5),
    Churn             VARCHAR(5)
);

-- >>> LOAD DATA HERE
-- Easiest way (MySQL Workbench):
--   Right-click table "stg_telco" > Table Data Import Wizard >
--   choose telco_churn_cleaned.csv > Next > Next > Finish.
--
-- Or by command (change the file path first):
--   SET GLOBAL local_infile = 1;
--   LOAD DATA LOCAL INFILE 'C:/path/to/telco_churn_cleaned.csv'
--   INTO TABLE stg_telco
--   FIELDS TERMINATED BY ',' ENCLOSED BY '"'
--   LINES TERMINATED BY '\r\n'
--   IGNORE 1 ROWS;
--
-- Check:  SELECT COUNT(*) FROM stg_telco;     -- you should see 5463
-- <<< END LOAD DATA

-- STEP 3: Split the data into 4 small tables (grouped by topic)
--   customers -> who the customer is
--   services  -> what they use
--   contracts -> their contract and whether they left (Churn)
--   billing   -> what they pay
DROP TABLE IF EXISTS billing;
DROP TABLE IF EXISTS contracts;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    CustomerID     VARCHAR(20) PRIMARY KEY,
    Gender         VARCHAR(10),
    SeniorCitizen  INT
);

CREATE TABLE services (
    CustomerID       VARCHAR(20) PRIMARY KEY,
    InternetService  VARCHAR(20),
    TechSupport      VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES customers (CustomerID)
);

CREATE TABLE contracts (
    CustomerID        VARCHAR(20) PRIMARY KEY,
    ContractType      VARCHAR(20),
    TenureMonths      INT,
    PaperlessBilling  VARCHAR(5),
    PaymentMethod     VARCHAR(30),
    Churn             VARCHAR(5),
    FOREIGN KEY (CustomerID) REFERENCES customers (CustomerID)
);

CREATE TABLE billing (
    CustomerID      VARCHAR(20) PRIMARY KEY,
    MonthlyCharges  DECIMAL(10,2),
    TotalCharges    DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES customers (CustomerID)
);

-- STEP 4: Fill the 4 tables from the staging table
INSERT INTO customers
SELECT CustomerID, Gender, SeniorCitizen FROM stg_telco;

INSERT INTO services
SELECT CustomerID, InternetService, TechSupport FROM stg_telco;

INSERT INTO contracts
SELECT CustomerID, ContractType, TenureMonths, PaperlessBilling, PaymentMethod, Churn
FROM stg_telco;

INSERT INTO billing
SELECT CustomerID, ROUND(MonthlyCharges, 2), ROUND(TotalCharges, 2) FROM stg_telco;

-- STEP 5: Quick check. Expect 5463 customers and 1238 churned.
SELECT COUNT(*) AS total_customers,
       SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned
FROM contracts;
