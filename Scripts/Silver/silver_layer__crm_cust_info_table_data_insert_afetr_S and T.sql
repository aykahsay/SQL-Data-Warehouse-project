
CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    SET NOCOUNT ON;

    PRINT('>> TRUNCATE TABLE: silver.crm_cust_info');
    TRUNCATE TABLE silver.crm_cust_info;

    INSERT INTO silver.crm_cust_info (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_marital_status,
        cst_gndr,
        cst_create_date
    )
    SELECT
        cst_id,
        cst_key,
        TRIM(cst_firstname) AS cst_firstname,
        TRIM(cst_lastname) AS cst_lastname,
        CASE 
            WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
            WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
            WHEN UPPER(TRIM(cst_marital_status)) = 'D' THEN 'Divorced'
            WHEN TRIM(cst_marital_status) IS NULL OR TRIM(cst_marital_status) = '' THEN 'n/a'
            ELSE TRIM(cst_marital_status)
        END AS cst_marital_status,
        CASE 
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            WHEN TRIM(cst_gndr) IS NULL OR TRIM(cst_gndr) = '' THEN 'n/a'
            ELSE TRIM(cst_gndr)
        END AS cst_gndr,
        cst_create_date
    FROM (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
        FROM bronze.crm_cust_info
    ) t
    WHERE flag_last = 1;

    PRINT('>> TRUNCATE TABLE: silver.crm_prd_info');
    TRUNCATE TABLE silver.crm_prd_info;

    INSERT INTO silver.crm_prd_info (
        prd_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )
    SELECT
        prd_id,
        'P' + RIGHT('000' + LTRIM(SUBSTRING(prd_key, 4, LEN(prd_key))), 3) AS cat_id,
        'PRD-' + RIGHT('000' + LTRIM(SUBSTRING(prd_key, 4, LEN(prd_key))), 3) AS prd_key,
        prd_nm,
        ISNULL(prd_cost, 0) AS prd_cost,
        CASE 
            WHEN UPPER(TRIM(prd_line)) = 'AC' THEN 'Accessories'
            WHEN UPPER(TRIM(prd_line)) = 'OF' THEN 'Office Furniture'
            WHEN UPPER(TRIM(prd_line)) = 'EL' THEN 'Electronics'
            WHEN UPPER(TRIM(prd_line)) = 'AD' THEN 'Audio'
            WHEN UPPER(TRIM(prd_line)) = 'SG' THEN 'Storage'
            WHEN TRIM(prd_line) IS NULL OR TRIM(prd_line) = '' THEN 'n/a'
            ELSE TRIM(prd_line)
        END AS prd_line,
        CAST(prd_start_dt AS DATE),
        CAST(prd_end_dt AS DATE)
    FROM bronze.crm_prd_info;

    PRINT('>> TRUNCATE TABLE: silver.crm_sales_details');
    TRUNCATE TABLE silver.crm_sales_details;

    INSERT INTO silver.crm_sales_details (
        sls_ord_num,
        sls_prd_key,
        sls_cust_id, 
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price
    )
    SELECT
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        CASE 
            WHEN sls_order_dt = 0 OR LEN(CAST(sls_order_dt AS VARCHAR)) != 8 THEN NULL
            ELSE CONVERT(DATE, CAST(sls_order_dt AS VARCHAR), 112)
        END AS sls_order_dt,
        CASE 
            WHEN sls_ship_dt = 0 OR LEN(CAST(sls_ship_dt AS VARCHAR)) != 8 THEN NULL
            ELSE CONVERT(DATE, CAST(sls_ship_dt AS VARCHAR), 112)
        END AS sls_ship_dt,
        CASE 
            WHEN sls_due_dt = 0 OR LEN(CAST(sls_due_dt AS VARCHAR)) != 8 THEN NULL
            ELSE CONVERT(DATE, CAST(sls_due_dt AS VARCHAR), 112)
        END AS sls_due_dt,
        CASE 
            WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
                THEN sls_quantity * ABS(sls_price)
            ELSE sls_sales
        END AS sls_sales,
        sls_quantity,
        CASE 
            WHEN sls_price IS NULL OR sls_price <= 0 THEN 
                CASE WHEN sls_quantity = 0 THEN NULL ELSE sls_sales / NULLIF(sls_quantity, 0) END
            ELSE sls_price
        END AS sls_price
    FROM bronze.crm_sales_details;

    PRINT('>> TRUNCATE TABLE: silver.erp_cust_az12');
    TRUNCATE TABLE silver.erp_cust_az12;

    INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
    SELECT 
        CASE 
            WHEN cid LIKE 'C%' 
                THEN 'CK-' + RIGHT('00000' + CAST(CAST(SUBSTRING(cid, 2, LEN(cid)) AS INT) AS VARCHAR), 5)
            ELSE cid
        END AS cid,
        CASE 
            WHEN bdate > GETDATE() THEN NULL
            ELSE bdate
        END AS bdate,
        CASE
            WHEN UPPER(TRIM(gen)) IN ('MALE', 'M') THEN 'Male'
            WHEN UPPER(TRIM(gen)) IN ('FEMALE', 'F') THEN 'Female'
            ELSE 'n/a'
        END AS gen
    FROM bronze.erp_cust_az12;

    PRINT('>> TRUNCATE TABLE: silver.erp_px_cat_g1v2');
    TRUNCATE TABLE silver.erp_px_cat_g1v2;

    INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
    SELECT 
        id,
        CASE 
            WHEN TRIM(cat) = '' OR cat IS NULL THEN 'n/a'
            ELSE TRIM(cat)
        END AS cat,
        CASE 
            WHEN TRIM(subcat) = '' OR subcat IS NULL THEN 'n/a'
            ELSE TRIM(subcat)
        END AS subcat,
        CASE 
            WHEN TRIM(maintenance) = '' OR maintenance IS NULL THEN 'n/a'
            ELSE TRIM(maintenance)
        END AS maintenance
    FROM bronze.erp_px_cat_g1v2;

    PRINT('>> TRUNCATE TABLE: silver.erp_loc_a101');
    TRUNCATE TABLE silver.erp_loc_a101;

    INSERT INTO silver.erp_loc_a101 (cid, cntry)
    SELECT 
        'CK-' + RIGHT('00000' + CAST(SUBSTRING(cid, 2, LEN(cid)) AS VARCHAR), 5) AS cid,
        CASE 
            WHEN UPPER(TRIM(cntry)) = 'TG' THEN 'Tigray'
            WHEN UPPER(TRIM(cntry)) IN ('US', 'USA') THEN 'United States'
            WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
            ELSE TRIM(cntry)
        END AS cntry
    FROM bronze.erp_loc_a101;

END;
GO

-- EXEC silver.load_silver;