/*
====================================================================================================
Quality Checks
====================================================================================================

Script Purpose:
This script performs various quality checks for data consistency, accuracy,
and standardization across the 'silver' schemas. It includes checks for:
- Null or duplicate primary keys.
- Unwanted spaces in string fields.
- Data standardization and consistency.
- Invalid date ranges and orders.
- Data consistency between related fields.

Usage Notes:
- Run these checks after data loading Silver Layer.
- Investigate and resolve any discrepancies found during the checks.

*/

----------------------------------------------------------------------------------------------------
-- Checking 'silver.crm_cust_info'
----------------------------------------------------------------------------------------------------

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results


-- =============================================================================
-- Data Quality Checks for Silver Layer Tables
-- Based on transformations in silver.load_silver stored procedure
-- =============================================================================

PRINT 'Starting Data Quality Checks for Silver Layer...';

-- -----------------------------------------------------------------------------
-- 1. Checks for silver.crm_cust_info
-- -----------------------------------------------------------------------------
PRINT ' ';
PRINT '>> Running checks for silver.crm_cust_info...';

-- Check 1.1: Duplication and NULL Values of PK (cst_id)
-- Expectation: No rows should be returned if cst_id is unique and not NULL.
SELECT '-- crm_cust_info: PK Duplicates/NULLs --' AS CheckName,
       cst_id, COUNT(*) AS DuplicateCount
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check 1.2: Unwanted Spaces in cst_firstname
-- Expectation: No rows should be returned if TRIM was successful.
SELECT '-- crm_cust_info: Untrimmed Firstname --' AS CheckName,
       cst_id, cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname) OR cst_firstname LIKE '% ' OR cst_firstname LIKE ' %';

-- Check 1.3: Unwanted Spaces in cst_lastname
-- Expectation: No rows should be returned if TRIM was successful.
SELECT '-- crm_cust_info: Untrimmed Lastname --' AS CheckName,
       cst_id, cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname) OR cst_lastname LIKE '% ' OR cst_lastname LIKE ' %';

-- Check 1.4: Data Standardization for cst_marital_status
-- Expectation: Only 'Single', 'Married', 'Divorced', 'n/a' should exist.
SELECT '-- crm_cust_info: Non-standard Marital Status --' AS CheckName,
       DISTINCT cst_marital_status
FROM silver.crm_cust_info
WHERE cst_marital_status NOT IN ('Single', 'Married', 'Divorced', 'n/a');

-- Check 1.5: Data Standardization for cst_gndr
-- Expectation: Only 'Female', 'Male', 'n/a' should exist.
SELECT '-- crm_cust_info: Non-standard Gender --' AS CheckName,
       DISTINCT cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr NOT IN ('Female', 'Male', 'n/a');

-- -----------------------------------------------------------------------------
-- 2. Checks for silver.crm_prd_info
-- -----------------------------------------------------------------------------
PRINT ' ';
PRINT '>> Running checks for silver.crm_prd_info...';

-- Check 2.1: Duplication and NULL Values of PK (prd_id)
-- Expectation: No rows should be returned if prd_id is unique and not NULL.
SELECT '-- crm_prd_info: PK Duplicates/NULLs --' AS CheckName,
       prd_id, COUNT(*) AS DuplicateCount
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check 2.2: NULL or Negative Numbers in prd_cost
-- Expectation: prd_cost should be >= 0 and not NULL.
SELECT '-- crm_prd_info: Invalid Product Cost --' AS CheckName,
       prd_id, prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Check 2.3: Data Standardization for prd_line
-- Expectation: Only predefined categories or 'n/a' should exist.
SELECT '-- crm_prd_info: Non-standard Product Line --' AS CheckName,
       DISTINCT prd_line
FROM silver.crm_prd_info
WHERE prd_line NOT IN ('Accessories', 'Office Furniture', 'Electronics', 'Audio', 'Storage', 'n/a');

-- Check 2.4: Invalid Date Ranges (prd_end_dt < prd_start_dt)
-- Expectation: No rows should be returned.
SELECT '-- crm_prd_info: Invalid Date Range (prd_end_dt < prd_start_dt) --' AS CheckName,
       prd_id, prd_start_dt, prd_end_dt
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- Check 2.5: NULLs in Date Fields (prd_start_dt, prd_end_dt)
-- Expectation: No NULLs if dates are always expected to be valid.
SELECT '-- crm_prd_info: NULL Start/End Dates --' AS CheckName,
       prd_id, prd_start_dt, prd_end_dt
FROM silver.crm_prd_info
WHERE prd_start_dt IS NULL OR prd_end_dt IS NULL;

-- -----------------------------------------------------------------------------
-- 3. Checks for silver.crm_sales_details
-- -----------------------------------------------------------------------------
PRINT ' ';
PRINT '>> Running checks for silver.crm_sales_details...';

-- Check 3.1: Duplication and NULL Values of PK (sls_ord_num, sls_prd_key, sls_cust_id)
-- Expectation: No duplicates and no NULLs in these columns combined.
SELECT '-- crm_sales_details: PK Duplicates/NULLs --' AS CheckName,
       sls_ord_num, sls_prd_key, sls_cust_id, COUNT(*) AS DuplicateCount
FROM silver.crm_sales_details
GROUP BY sls_ord_num, sls_prd_key, sls_cust_id
HAVING COUNT(*) > 1 OR sls_ord_num IS NULL OR sls_prd_key IS NULL OR sls_cust_id IS NULL;

-- Check 3.2: NULLs in Date Fields (sls_order_dt, sls_ship_dt, sls_due_dt)
-- Expectation: NULLs only where source data was invalid (0 or incorrect format).
SELECT '-- crm_sales_details: NULL Sales/Ship/Due Dates --' AS CheckName,
       sls_ord_num, sls_order_dt, sls_ship_dt, sls_due_dt
FROM silver.crm_sales_details
WHERE sls_order_dt IS NULL OR sls_ship_dt IS NULL OR sls_due_dt IS NULL;

-- Check 3.3: Illogical Date Sequences (sls_ship_dt < sls_order_dt)
-- Expectation: No rows returned.
SELECT '-- crm_sales_details: Ship Date Before Order Date --' AS CheckName,
       sls_ord_num, sls_order_dt, sls_ship_dt
FROM silver.crm_sales_details
WHERE sls_ship_dt < sls_order_dt;

-- Check 3.4: Illogical Date Sequences (sls_due_dt < sls_order_dt)
-- Expectation: No rows returned.
SELECT '-- crm_sales_details: Due Date Before Order Date --' AS CheckName,
       sls_ord_num, sls_order_dt, sls_due_dt
FROM silver.crm_sales_details
WHERE sls_due_dt < sls_order_dt;

-- Check 3.5: NULL or Negative Values in sls_sales
-- Expectation: sls_sales should be >= 0 and not NULL.
SELECT '-- crm_sales_details: Invalid Sales Amount --' AS CheckName,
       sls_ord_num, sls_sales
FROM silver.crm_sales_details
WHERE sls_sales IS NULL OR sls_sales < 0;

-- Check 3.6: NULL Values in sls_quantity
-- Expectation: sls_quantity should not be NULL. (Negative is possible for returns)
SELECT '-- crm_sales_details: NULL Quantity --' AS CheckName,
       sls_ord_num, sls_quantity
FROM silver.crm_sales_details
WHERE sls_quantity IS NULL;

-- Check 3.7: NULL or Negative Values in sls_price
-- Expectation: sls_price should be >= 0 and not NULL.
SELECT '-- crm_sales_details: Invalid Price --' AS CheckName,
       sls_ord_num, sls_price
FROM silver.crm_sales_details
WHERE sls_price IS NULL OR sls_price < 0;

-- Check 3.8: Sales Consistency (sls_sales vs. sls_quantity * ABS(sls_price))
-- Expectation: No rows if the calculation/correction worked perfectly.
SELECT '-- crm_sales_details: Sales Inconsistency --' AS CheckName,
       sls_ord_num, sls_sales, sls_quantity, sls_price, (sls_quantity * ABS(sls_price)) AS CalculatedSales
FROM silver.crm_sales_details
WHERE sls_quantity != 0 AND sls_sales != (sls_quantity * ABS(sls_price));

-- -----------------------------------------------------------------------------
-- 4. Checks for silver.erp_cust_az12
-- -----------------------------------------------------------------------------
PRINT ' ';
PRINT '>> Running checks for silver.erp_cust_az12...';

-- Check 4.1: Duplication and NULL Values of PK (cid)
-- Expectation: No rows should be returned if cid is unique and not NULL.
SELECT '-- erp_cust_az12: PK Duplicates/NULLs --' AS CheckName,
       cid, COUNT(*) AS DuplicateCount
FROM silver.erp_cust_az12
GROUP BY cid
HAVING COUNT(*) > 1 OR cid IS NULL;

-- Check 4.2: CID Adherence to Standardized Format ('CK-00000')
-- Expectation: All CIDs should match the pattern.
SELECT '-- erp_cust_az12: Non-standard CID Format --' AS CheckName,
       cid
FROM silver.erp_cust_az12
WHERE cid NOT LIKE 'CK-[0-9][0-9][0-9][0-9][0-9]';

-- Check 4.3: Invalid Dates (bdate in future)
-- Expectation: No birth dates should be in the future.
SELECT '-- erp_cust_az12: Future Birth Date --' AS CheckName,
       cid, bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

-- Check 4.4: Data Standardization for gen
-- Expectation: Only 'Male', 'Female', 'n/a' should exist.
SELECT '-- erp_cust_az12: Non-standard Gender --' AS CheckName,
       DISTINCT gen
FROM silver.erp_cust_az12
WHERE gen NOT IN ('Male', 'Female', 'n/a');

-- -----------------------------------------------------------------------------
-- 5. Checks for silver.erp_px_cat_g1v2
-- -----------------------------------------------------------------------------
PRINT ' ';
PRINT '>> Running checks for silver.erp_px_cat_g1v2...';

-- Check 5.1: Duplication and NULL Values of PK (id)
-- Expectation: No rows should be returned if id is unique and not NULL.
SELECT '-- erp_px_cat_g1v2: PK Duplicates/NULLs --' AS CheckName,
       id, COUNT(*) AS DuplicateCount
FROM silver.erp_px_cat_g1v2
GROUP BY id
HAVING COUNT(*) > 1 OR id IS NULL;

-- Check 5.2: Unwanted Spaces or Non-standardized Values in cat
-- Expectation: All values should be trimmed and not empty strings or NULL.
SELECT '-- erp_px_cat_g1v2: Untrimmed/Invalid Category --' AS CheckName,
       id, cat
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR cat = '' OR cat IS NULL;

-- Check 5.3: Unwanted Spaces or Non-standardized Values in subcat
-- Expectation: All values should be trimmed and not empty strings or NULL.
SELECT '-- erp_px_cat_g1v2: Untrimmed/Invalid Subcategory --' AS CheckName,
       id, subcat
FROM silver.erp_px_cat_g1v2
WHERE subcat != TRIM(subcat) OR subcat = '' OR subcat IS NULL;

-- Check 5.4: Unwanted Spaces or Non-standardized Values in maintenance
-- Expectation: All values should be trimmed and not empty strings or NULL.
SELECT '-- erp_px_cat_g1v2: Untrimmed/Invalid Maintenance --' AS CheckName,
       id, maintenance
FROM silver.erp_px_cat_g1v2
WHERE maintenance != TRIM(maintenance) OR maintenance = '' OR maintenance IS NULL;

-- -----------------------------------------------------------------------------
-- 6. Checks for silver.erp_loc_a101
-- -----------------------------------------------------------------------------
PRINT ' ';
PRINT '>> Running checks for silver.erp_loc_a101...';

-- Check 6.1: Duplication and NULL Values of PK (cid)
-- Expectation: No rows should be returned if cid is unique and not NULL.
SELECT '-- erp_loc_a101: PK Duplicates/NULLs --' AS CheckName,
       cid, COUNT(*) AS DuplicateCount
FROM silver.erp_loc_a101
GROUP BY cid
HAVING COUNT(*) > 1 OR cid IS NULL;

-- Check 6.2: CID Adherence to Standardized Format ('CK-00000')
-- Expectation: All CIDs should match the pattern.
SELECT '-- erp_loc_a101: Non-standard CID Format --' AS CheckName,
       cid
FROM silver.erp_loc_a101
WHERE cid NOT LIKE 'CK-[0-9][0-9][0-9][0-9][0-9]';

-- Check 6.3: Data Standardization for cntry
-- Expectation: Only 'Tigray', 'United States', 'n/a', or other properly trimmed original values should exist.
SELECT '-- erp_loc_a101: Non-standard Country --' AS CheckName,
       DISTINCT cntry
FROM silver.erp_loc_a101
WHERE cntry NOT IN ('Tigray', 'United States', 'n/a') AND cntry != TRIM(cntry);


PRINT ' ';
PRINT 'All Silver Layer Data Quality Checks Completed.';
