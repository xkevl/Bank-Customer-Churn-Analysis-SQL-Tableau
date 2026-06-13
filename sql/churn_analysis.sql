-- Churn Analysis

-- Creating a duplicate table so we don't mess with the raw data
CREATE TABLE churn_staging
LIKE churn;

INSERT INTO churn_staging
SELECT *
FROM churn;

-- Checking for duplicates
SELECT 
	COUNT(*), 
	COUNT(DISTINCT CustomerId)
FROM churn_staging;

-- Checking for nulls
SELECT *
FROM churn_staging
WHERE Gender IS NULL;

-- Checking for blank values
SELECT *
FROM churn_staging
WHERE TRIM(Surname) = '';

-- Making sure results are only 1 (Yes) and 0 (No)
SELECT DISTINCT(Exited)
FROM churn_staging;

-- Dataset looks good, let's start!
SELECT *
FROM churn_staging;

-- Churn rate amongst all customers
SELECT 
	COUNT(*) AS total_customers,
	SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM churn_staging;

-- Average balance by churn
SELECT
	Exited,
    ROUND(AVG(Balance), 2) AS avg_balance
FROM churn_staging
GROUP BY Exited;

-- Churn rate by credit score
SELECT
	CASE 
		WHEN CreditScore < 500 THEN 'Low'
		WHEN CreditScore < 700 THEN 'Medium'
        ELSE 'High'
	END AS credit_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM churn_staging
GROUP BY credit_group
ORDER BY churn_rate DESC;

-- Churn rate by geography
SELECT 
	Geography,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM churn_staging
GROUP BY Geography
ORDER BY churn_rate DESC;

-- Churn rate by gender
SELECT 
	Gender,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM churn_staging
GROUP BY Gender
ORDER BY churn_rate DESC;

-- Churn rate by age
SELECT 
	CASE 
		WHEN Age < 30 THEN 'Under 30'
        WHEN Age < 50 THEN 'Under 50'
        ELSE '50+'
	END AS age_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM churn_staging
GROUP BY age_group
ORDER BY churn_rate DESC;

-- Churn rate by tenure
SELECT 
	CASE 
		WHEN Tenure < 3 THEN 'Short'
        WHEN Tenure < 7 THEN 'Medium'
        ELSE 'High'
	END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM churn_staging
GROUP BY tenure_group
ORDER BY churn_rate DESC;

-- Churn rate by balance
WITH avg_bal AS (
	SELECT AVG(Balance) AS avg_balance 
    FROM churn_staging
)
SELECT
	CASE
		WHEN Balance < avg_balance THEN 'Below Average'
		ELSE 'Above Average'
	END AS balance_group,
	COUNT(*) AS total_customers,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM churn_staging, avg_bal
GROUP BY balance_group
ORDER BY churn_rate DESC;

-- Churn rate by number of products
SELECT
	NumOfProducts,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM churn_staging
GROUP BY NumOfProducts
ORDER BY churn_rate DESC;

-- Churn rate by if they have a credit card or not
SELECT
	HasCrCard,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM churn_staging
GROUP BY HasCrCard
ORDER BY churn_rate DESC;

-- Churn rate by Active vs Inactive Member
SELECT 
	IsActiveMember,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM churn_staging
GROUP BY IsActiveMember
ORDER BY churn_rate DESC;

-- Churn rate by salary
WITH avg_sal AS
(
SELECT AVG(EstimatedSalary) AS avg_salary
FROM churn_staging
)

SELECT
	CASE
		WHEN EstimatedSalary < avg_salary THEN 'Below Average'
        ELSE 'Above Average'
	END AS salary,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM churn_staging, avg_sal
GROUP BY salary;

-- High-value churned customers for potential win-back analysis
SELECT
    CustomerId,
    Surname,
    Geography,
    Gender,
    Age,
    CreditScore,
    Tenure,
    Balance,
    NumOfProducts,
    IsActiveMember,
    EstimatedSalary
FROM churn_staging
WHERE Exited = 1
  AND Balance > (SELECT AVG(Balance) FROM churn_staging)
ORDER BY Balance DESC;

-- Identify high-risk customer segments based on multiple churn-related factors
SELECT
    Geography,
    Gender,
    CASE
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age < 50 THEN '30-49'
        ELSE '50+'
    END AS age_group,
    CASE
        WHEN Balance = 0 THEN 'No Balance'
        WHEN Balance < (SELECT AVG(Balance) FROM churn_staging) THEN 'Below Average Balance'
        ELSE 'Above Average Balance'
    END AS balance_group,
    NumOfProducts,
    IsActiveMember,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM churn_staging
GROUP BY
    Geography,
    Gender,
    age_group,
    balance_group,
    NumOfProducts,
    IsActiveMember
HAVING COUNT(*) >= 25
ORDER BY churn_rate DESC;
