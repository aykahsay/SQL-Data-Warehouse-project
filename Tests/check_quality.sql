/**************************************************************************************************
  GOLD LAYER – DATA QUALITY AND RELATIONSHIP VALIDATION
  ------------------------------------------------------------------------------------------------
  Purpose:
  This script checks for:
    1. Duplicate surrogate keys in dimension tables.
    2. Uniqueness of dimension keys.
    3. Referential integrity between fact and dimension tables.
**************************************************************************************************/

-- ===============================================================================================
-- CHECK FOR DUPLICATES: gold.dim_customers
-- Surrogate key `customer_key` should be unique.
-- ===============================================================================================
SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ===============================================================================================
-- CHECK FOR DUPLICATES: gold.dim_products
-- Surrogate key `product_key` should also be unique.
-- ===============================================================================================
SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ===============================================================================================
-- REFERENTIAL INTEGRITY: gold.fact_sales -> gold.dim_customers, gold.dim_products
-- This query finds any rows in `fact_sales` that fail to match with dimensions.
-- ===============================================================================================
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL;
