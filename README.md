# Bank Customer Churn Analysis

## Executive Summary

This project analyzes 10,000 bank customer records to identify customer segments associated with higher churn. Using SQL, I cleaned and segmented the data by geography, gender, age, credit score, tenure, account balance, product usage, credit card ownership, and activity status.

The analysis found that churn behavior varies meaningfully across customer groups, especially by activity status, age group, balance level, and number of products. The final Tableau dashboard summarizes key churn metrics and allows users to explore churn patterns across customer segments.

This project demonstrates how SQL and Tableau can support customer retention analysis by identifying which customer groups may require targeted outreach.

## Business Questions

- What is the overall customer churn rate?
- Which customer segments have the highest churn rates?
- How does churn vary by geography, gender, age, credit score, and tenure?
- Are inactive customers more likely to churn than active customers?
- How do balance level and number of products relate to churn behavior?
- Which high-value churned customers could be useful for win-back analysis?

## Tools Used

- SQL: data cleaning, segmentation, exploratory analysis, and churn rate calculations
- Tableau: dashboard development and interactive visualization
- CSV/Excel: source dataset review

## Dataset

- Source: [Bank Customer Churn Dataset](https://www.kaggle.com/datasets/shrutimechlearn/churn-modelling)
- Rows: 10,000
- Columns: 14

## Project Structure

```text
/data
- churn.csv

/sql
- churn_analysis.sql

/tableau
- churn rate dashboard.twbx
- churn_dashboard_screenshot.png
```

## Data Preparation

The dataset was duplicated into a staging table to preserve the raw source data before analysis.

Data quality checks included:

- Checking for duplicate customer IDs
- Checking for null values
- Checking for blank text fields
- Validating churn indicator values
- Reviewing customer segmentation fields for consistency

## Key Metrics Created

- Total customers
- Churned customers
- Overall churn rate
- Churn rate by geography
- Churn rate by gender
- Churn rate by age group
- Churn rate by credit score group
- Churn rate by tenure group
- Churn rate by balance level
- Churn rate by number of products
- Churn rate by credit card ownership
- Churn rate by activity status
- Average balance by churn status
- High-value churned customers

## SQL Techniques Used

- `COUNT`, `SUM`, and `AVG` for aggregations
- `CASE WHEN` for customer segmentation
- Subqueries for average balance and salary comparisons
- CTEs for reusable calculations
- Grouped churn-rate analysis across multiple customer attributes
- Segment filtering to reduce misleading results from very small groups

## Tableau Dashboard

View the interactive dashboard on Tableau Public: [Bank Customer Churn Dashboard](https://public.tableau.com/app/profile/kevin.lim7109/viz/churnratedashboard_17772975938480/ChurnRateDashboard)

The dashboard includes:

- KPI cards for total customers, churn rate, and average balance
- Churn breakdown by geography, age group, gender, and activity status
- Customer segmentation by credit score, tenure, balance, and product usage
- Interactive filters for exploring churn behavior across customer groups

![Dashboard](tableau/churn_dashboard_screenshot.png)

## Key Insights

- Inactive customers showed higher churn behavior than active customers, making activity status an important retention signal.
- Older customer segments showed higher churn rates compared with younger customers.
- Churn varied across geographies, suggesting that regional factors may influence customer retention.
- Customers with certain product counts showed elevated churn, which may indicate dissatisfaction, product mismatch, or account complexity.
- Customers with above-average balances who churned represent a valuable group for potential win-back analysis.

## Recommendations

- Prioritize retention campaigns for inactive customers, especially those with above-average balances.
- Create a high-value churn watchlist using balance, activity status, age group, product count, and geography.
- Investigate why customers with certain product counts show higher churn, as this may point to product experience or bundling issues.
- Develop targeted outreach for older customer segments if they continue to show elevated churn.
- Compare churn by geography to determine whether regional service quality, customer needs, or product fit may be contributing to attrition.

## Limitations

- This analysis is descriptive and identifies customer segments associated with churn, but it does not prove causation.
- The dataset does not include customer service history, transaction behavior, satisfaction scores, marketing exposure, competitor activity, or product-level usage details.
- The high-risk segment analysis uses grouped SQL logic, not a predictive machine learning model.
- A predictive churn model would require additional feature engineering, model training, validation, and performance evaluation.

## What I Learned

- How to calculate churn rates across multiple customer segments using SQL
- How to use `CASE WHEN` logic to create business-friendly customer groups
- Why sample size matters when comparing churn rates across segments
- How to translate SQL analysis into dashboard-ready metrics
- How to frame churn analysis around customer retention and business decision-making
