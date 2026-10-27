-- =====================================================================
--  File 03: 10 business questions
--  Each query: question -> SQL -> what the answer tells the business
--
--  Table nicknames (aliases) used in every query:
--      c = customers    s = services    k = contracts    b = billing
--  Every table has CustomerID, so we JOIN on it. Each query joins
--  only the tables it needs.
--
--  How to read the churn formula (used many times):
--      SUM(CASE WHEN k.Churn = 'Yes' THEN 1 ELSE 0 END)  = customers who left
--      COUNT(*)                                          = all customers
--      ROUND(100.0 * left / all, 1)                      = churn rate in %
-- =====================================================================


-- Q1. How big is the churn problem, in customers and in money?
--     Needs: contracts (Churn) + billing (MonthlyCharges)
SELECT COUNT(*)                                                        AS total_customers,
       SUM(CASE WHEN k.Churn = 'Yes' THEN 1 ELSE 0 END)                AS churned_customers,
       ROUND(100.0 * SUM(CASE WHEN k.Churn = 'Yes' THEN 1 ELSE 0 END)
             / COUNT(*), 1)                                            AS churn_rate_pct,
       ROUND(SUM(b.MonthlyCharges), 0)                                 AS monthly_revenue,
       ROUND(SUM(CASE WHEN k.Churn = 'Yes' THEN b.MonthlyCharges ELSE 0 END), 0)
                                                                       AS monthly_revenue_lost,
       ROUND(12 * SUM(CASE WHEN k.Churn = 'Yes' THEN b.MonthlyCharges ELSE 0 END), 0)
                                                                       AS yearly_revenue_lost
FROM contracts k
JOIN billing b 
ON b.CustomerID = k.CustomerID;
-- Meaning: about 1 in 4 customers left, costing roughly $1 million a year.


-- Q2. Which contract type loses the most customers?
--     Needs: contracts only, so no JOIN
SELECT k.ContractType,
       COUNT(*)                                                        AS customers,
       SUM(CASE WHEN k.Churn = 'Yes' THEN 1 ELSE 0 END)                AS churned,
       ROUND(100.0 * SUM(CASE WHEN k.Churn = 'Yes' THEN 1 ELSE 0 END)
             / COUNT(*), 1)                                            AS churn_rate_pct
FROM contracts k
GROUP BY k.ContractType
ORDER BY churn_rate_pct DESC;
-- Meaning: Month-to-Month customers leave about 2x more than Two-Year customers.


-- Q3. Is Fiber Optic really the problem?
--     Needs: services (InternetService) + contracts (Churn) + billing (bill)
SELECT s.InternetService,
       COUNT(*)                                                        AS customers,
       ROUND(AVG(b.MonthlyCharges), 2)                                 AS avg_monthly_bill,
       ROUND(100.0 * SUM(CASE WHEN k.Churn = 'Yes' THEN 1 ELSE 0 END)
             / COUNT(*), 1)                                            AS churn_rate_pct
FROM services s
JOIN contracts k ON k.CustomerID = s.CustomerID
JOIN billing   b ON b.CustomerID = s.CustomerID
GROUP BY s.InternetService
ORDER BY churn_rate_pct DESC;
-- Meaning: Fiber customers pay the most AND leave the most.


-- Q4. Which payment method has the most churn?
--     Needs: contracts only, so no JOIN
SELECT k.PaymentMethod,
       COUNT(*)                                                        AS customers,
       ROUND(100.0 * SUM(CASE WHEN k.Churn = 'Yes' THEN 1 ELSE 0 END)
             / COUNT(*), 1)                                            AS churn_rate_pct
FROM contracts k
GROUP BY k.PaymentMethod
ORDER BY churn_rate_pct DESC;
-- Meaning: Electronic Check stands out. The other three methods are similar.


-- Q5. When in the customer's life do they leave?
--     Needs: contracts only, so no JOIN
SELECT CASE WHEN k.TenureMonths <= 12 THEN '1) First year (0-12 months)'
            WHEN k.TenureMonths <= 24 THEN '2) Second year (13-24 months)'
            WHEN k.TenureMonths <= 48 THEN '3) Years 3-4 (25-48 months)'
            ELSE                           '4) Over 4 years (49+ months)'
       END                                                             AS tenure_group,
       COUNT(*)                                                        AS customers,
       ROUND(100.0 * SUM(CASE WHEN k.Churn = 'Yes' THEN 1 ELSE 0 END)
             / COUNT(*), 1)                                            AS churn_rate_pct
FROM contracts k
GROUP BY tenure_group
ORDER BY tenure_group;
-- Meaning: new customers are the most fragile. Churn falls steadily with time.


-- Q6. Does Tech Support reduce churn?  (only customers who have internet)
--     Needs: services (TechSupport) + contracts (Churn)
SELECT s.InternetService,
       s.TechSupport,
       COUNT(*)                                                        AS customers,
       ROUND(100.0 * SUM(CASE WHEN k.Churn = 'Yes' THEN 1 ELSE 0 END)
             / COUNT(*), 1)                                            AS churn_rate_pct
FROM services s
JOIN contracts k ON k.CustomerID = s.CustomerID
WHERE s.InternetService <> 'No'
  AND s.TechSupport IN ('Yes', 'No')
GROUP BY s.InternetService, s.TechSupport
ORDER BY s.InternetService, s.TechSupport;
-- Meaning: NO. With or without Tech Support, churn is almost the same.
--          So Tech Support should not be the retention plan.


-- Q7. Do seniors and women/men churn differently?
--     Needs: customers (Gender, SeniorCitizen) + contracts (Churn)
SELECT c.SeniorCitizen,
       c.Gender,
       COUNT(*)                                                        AS customers,
       ROUND(100.0 * SUM(CASE WHEN k.Churn = 'Yes' THEN 1 ELSE 0 END)
             / COUNT(*), 1)                                            AS churn_rate_pct
FROM customers c
JOIN contracts k ON k.CustomerID = c.CustomerID
GROUP BY c.SeniorCitizen, c.Gender
ORDER BY c.SeniorCitizen, c.Gender;
-- Meaning: no real difference. Churn depends on contract, internet and tenure,
--          not on who the customer is.


-- Q8. Which contract + internet combinations lose the most revenue?
--     Needs: contracts + services + billing
SELECT k.ContractType,
       s.InternetService,
       COUNT(*)                                                        AS customers,
       ROUND(100.0 * SUM(CASE WHEN k.Churn = 'Yes' THEN 1 ELSE 0 END)
             / COUNT(*), 1)                                            AS churn_rate_pct,
       ROUND(SUM(CASE WHEN k.Churn = 'Yes' THEN b.MonthlyCharges ELSE 0 END), 0)
                                                                       AS monthly_revenue_lost
FROM contracts k
JOIN services s ON s.CustomerID = k.CustomerID
JOIN billing  b ON b.CustomerID = k.CustomerID
GROUP BY k.ContractType, s.InternetService
ORDER BY monthly_revenue_lost DESC;
-- Meaning: Month-to-Month + Fiber Optic is the biggest leak, by far.


-- Q9. Does SQL find the Part 1 high-risk segment?
--     (Month-to-Month + Fiber Optic + Electronic Check)
--     Needs: contracts + services + billing
SELECT CASE WHEN k.ContractType = 'Month-to-Month'
             AND s.InternetService = 'Fiber Optic'
             AND k.PaymentMethod = 'Electronic Check'
            THEN 'High-risk segment' ELSE 'Everyone else'
       END                                                             AS customer_group,
       COUNT(*)                                                        AS customers,
       ROUND(100.0 * SUM(CASE WHEN k.Churn = 'Yes' THEN 1 ELSE 0 END)
             / COUNT(*), 1)                                            AS churn_rate_pct,
       ROUND(SUM(b.MonthlyCharges), 0)                                 AS monthly_revenue,
       ROUND(SUM(CASE WHEN k.Churn = 'Yes' THEN b.MonthlyCharges ELSE 0 END), 0)
                                                                       AS monthly_revenue_lost,
       ROUND(SUM(CASE WHEN k.Churn = 'No'  THEN b.MonthlyCharges ELSE 0 END), 0)
                                                                       AS monthly_revenue_still_active
FROM contracts k
JOIN services s ON s.CustomerID = k.CustomerID
JOIN billing  b ON b.CustomerID = k.CustomerID
GROUP BY customer_group
ORDER BY customer_group DESC;
-- Meaning: yes. 335 customers churn at 39.1% vs about 21.6% for everyone else.
--          The "still active" revenue is what a retention campaign can protect.


-- Q10. Who should the retention team call first?
--      Active high-risk customers who pay MORE than the average bill.
--      (the part in brackets is a subquery that finds the average bill)
--      Needs: contracts + services + billing
SELECT k.CustomerID,
       k.ContractType,
       s.InternetService,
       k.PaymentMethod,
       k.TenureMonths,
       b.MonthlyCharges
FROM contracts k
JOIN services s ON s.CustomerID = k.CustomerID
JOIN billing  b ON b.CustomerID = k.CustomerID
WHERE k.Churn = 'No'
  AND k.ContractType = 'Month-to-Month'
  AND s.InternetService = 'Fiber Optic'
  AND k.PaymentMethod = 'Electronic Check'
  AND b.MonthlyCharges > (SELECT AVG(MonthlyCharges) FROM billing)
ORDER BY b.MonthlyCharges DESC
LIMIT 20;
-- Meaning: a ready-made call list, biggest bills first.
