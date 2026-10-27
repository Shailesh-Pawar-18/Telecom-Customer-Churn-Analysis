-- =====================================================================
--  File 02: Data quality checks  (run these BEFORE the analysis)
-- =====================================================================

-- 1) Do all tables have the same number of rows? (expect 5463 each)
SELECT (SELECT COUNT(*) FROM stg_telco) AS staging_rows,
       (SELECT COUNT(*) FROM customers) AS customers_rows,
       (SELECT COUNT(*) FROM services)  AS services_rows,
       (SELECT COUNT(*) FROM contracts) AS contracts_rows,
       (SELECT COUNT(*) FROM billing)   AS billing_rows;

-- 2) Any duplicate CustomerID?  (expect no rows)
SELECT CustomerID, COUNT(*) AS times_seen
FROM stg_telco
GROUP BY CustomerID
HAVING COUNT(*) > 1;

-- 3) Any missing values?  (expect all zeros)
SELECT SUM(CASE WHEN ContractType   IS NULL THEN 1 ELSE 0 END) AS missing_contract,
       SUM(CASE WHEN MonthlyCharges IS NULL THEN 1 ELSE 0 END) AS missing_monthly,
       SUM(CASE WHEN TotalCharges   IS NULL THEN 1 ELSE 0 END) AS missing_total,
       SUM(CASE WHEN Churn          IS NULL THEN 1 ELSE 0 END) AS missing_churn
FROM stg_telco;

-- 4) Is Churn only Yes or No?
SELECT Churn, COUNT(*) AS customers
FROM stg_telco
GROUP BY Churn;

-- 5) FINDING: TechSupport does not match InternetService.
--    Customers with no internet should say "No Internet", but many do not,
--    and many customers WITH internet say "No Internet".
SELECT InternetService, TechSupport, COUNT(*) AS customers
FROM stg_telco
GROUP BY InternetService, TechSupport
ORDER BY InternetService, TechSupport;
-- What we do: in Q6 we only use customers with internet and TechSupport = Yes or No.
