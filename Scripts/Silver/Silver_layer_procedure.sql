

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @procStart DATETIME2 = SYSDATETIME();
    DECLARE @stepStart DATETIME2;
    DECLARE @stepEnd DATETIME2;
    DECLARE @durationSeconds INT;

    BEGIN TRY
        PRINT '>> Starting silver.load_silver procedure...';

        -- crm_cust_info
        PRINT '>> Truncating silver.crm_cust_info...';
        TRUNCATE TABLE silver.crm_cust_info;

        PRINT '>> Inserting data into silver.crm_cust_info...';
        SET @stepStart = SYSDATETIME();

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
            TRIM(cst_firstname),
            TRIM(cst_lastname),
            CASE 
                WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
                WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
                WHEN UPPER(TRIM(cst_marital_status)) = 'D' THEN 'Divorced'
                WHEN TRIM(cst_marital_status) IS NULL OR TRIM(cst_marital_status) = '' THEN 'n/a'
                ELSE TRIM(cst_marital_status)
            END,
            CASE 
                WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                WHEN TRIM(cst_gndr) IS NULL OR TRIM(cst_gndr) = '' THEN 'n/a'
                ELSE TRIM(cst_gndr)
            END,
            cst_create_date
        FROM (
            SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
            FROM bronze.crm_cust_info
        ) t
        WHERE flag_last = 1;

        SET @stepEnd = SYSDATETIME();
        SET @durationSeconds = DATEDIFF(SECOND, @stepStart, @stepEnd);
        PRINT '>> Inserted data into silver.crm_cust_info in ' + CAST(@durationSeconds AS VARCHAR(10)) + ' seconds.';

        -- crm_prd_info
        PRINT '>> Truncating silver.crm_prd_info...';
        TRUNCATE TABLE silver.crm_prd_info;

        PRINT '>> Inserting data into silver.crm_prd_info...';
        SET @stepStart = SYSDATETIME();

        INSERT INTO silver.crm_prd_info(
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
            ISNULL(prd_cost, 0),
            CASE 
                WHEN UPPER(TRIM(prd_line)) = 'AC' THEN 'Accessories'
                WHEN UPPER(TRIM(prd_line)) = 'OF' THEN 'Office Furniture'
                WHEN UPPER(TRIM(prd_line)) = 'EL' THEN 'Electronics'
                WHEN UPPER(TRIM(prd_line)) = 'AD' THEN 'Audio'
                WHEN UPPER(TRIM(prd_line)) = 'SG' THEN 'Storage'
                WHEN TRIM(prd_line) IS NULL OR TRIM(prd_line) = '' THEN 'n/a'
                ELSE TRIM(prd_line)
            END,
            CAST(prd_start_dt AS DATE),
            CAST(prd_end_dt AS DATE)
        FROM bronze.crm_prd_info;

        SET @stepEnd = SYSDATETIME();
        SET @durationSeconds = DATEDIFF(SECOND, @stepStart, @stepEnd);
        PRINT '>> Inserted data into silver.crm_prd_info in ' + CAST(@durationSeconds AS VARCHAR(10)) + ' seconds.';

        -- crm_sales_details
        PRINT '>> Truncating silver.crm_sales_details...';
        TRUNCATE TABLE silver.crm_sales_details;

        PRINT '>> Inserting data into silver.crm_sales_details...';
        SET @stepStart = SYSDATETIME();

        INSERT INTO silver.crm_sales_details(
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
                WHEN sls_order_dt = 0 OR LEN(CAST(sls_order_dt AS varchar)) != 8 THEN NULL
                ELSE CONVERT(date, CAST(sls_order_dt AS varchar), 112)
            END,
            CASE 
                WHEN sls_ship_dt = 0 OR LEN(CAST(sls_ship_dt AS varchar)) != 8 THEN NULL
                ELSE CONVERT(date, CAST(sls_ship_dt AS varchar), 112)
            END,
            CASE 
                WHEN sls_due_dt = 0 OR LEN(CAST(sls_due_dt AS varchar)) != 8 THEN NULL
                ELSE CONVERT(date, CAST(sls_due_dt AS varchar), 112)
            END,
            CASE 
                WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
                    THEN sls_quantity * ABS(sls_price)
                ELSE sls_sales
            END,
            sls_quantity,
            CASE 
                WHEN sls_price IS NULL OR sls_price <= 0 THEN 
                    CASE WHEN sls_quantity = 0 THEN NULL ELSE sls_sales / NULLIF(sls_quantity, 0) END
                ELSE sls_price
            END
        FROM bronze.crm_sales_details;

        SET @stepEnd = SYSDATETIME();
        SET @durationSeconds = DATEDIFF(SECOND, @stepStart, @stepEnd);
        PRINT '>> Inserted data into silver.crm_sales_details in ' + CAST(@durationSeconds AS VARCHAR(10)) + ' seconds.';

        -- erp_cust_az12
        PRINT '>> Truncating silver.erp_cust_az12...';
        TRUNCATE TABLE silver.erp_cust_az12;

        PRINT '>> Inserting data into silver.erp_cust_az12...';
        SET @stepStart = SYSDATETIME();

        INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
        SELECT 
            CASE 
                WHEN cid LIKE 'C%' 
                    THEN 'CK-' + RIGHT('00000' + CAST(CAST(SUBSTRING(cid, 2, LEN(cid)) AS INT) AS VARCHAR), 5)
                ELSE cid
            END,
            CASE 
                WHEN bdate > GETDATE() THEN NULL
                ELSE bdate
            END,
            CASE
                WHEN UPPER(TRIM(gen)) IN ('MALE', 'M') THEN 'Male'
                WHEN UPPER(TRIM(gen)) IN ('FEMALE', 'F') THEN 'Female'
                ELSE 'n/a'
            END
        FROM bronze.erp_cust_az12;

        SET @stepEnd = SYSDATETIME();
        SET @durationSeconds = DATEDIFF(SECOND, @stepStart, @stepEnd);
        PRINT '>> Inserted data into silver.erp_cust_az12 in ' + CAST(@durationSeconds AS VARCHAR(10)) + ' seconds.';

        -- erp_px_cat_g1v2
        PRINT '>> Truncating silver.erp_px_cat_g1v2...';
        TRUNCATE TABLE silver.erp_px_cat_g1v2;

        PRINT '>> Inserting data into silver.erp_px_cat_g1v2...';
        SET @stepStart = SYSDATETIME();

        INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
        SELECT 
            id,
            CASE 
                WHEN TRIM(cat) = '' OR cat IS NULL THEN 'n/a'
                ELSE TRIM(cat)
            END,
            CASE 
                WHEN TRIM(subcat) = '' OR subcat IS NULL THEN 'n/a'
                ELSE TRIM(subcat)
            END,
            CASE 
                WHEN TRIM(maintenance) = '' OR maintenance IS NULL THEN 'n/a'
                ELSE TRIM(maintenance)
            END
        FROM bronze.erp_px_cat_g1v2;

        SET @stepEnd = SYSDATETIME();
        SET @durationSeconds = DATEDIFF(SECOND, @stepStart, @stepEnd);
        PRINT '>> Inserted data into silver.erp_px_cat_g1v2 in ' + CAST(@durationSeconds AS VARCHAR(10)) + ' seconds.';

        -- erp_loc_a101
        PRINT '>> Truncating silver.erp_loc_a101...';
        TRUNCATE TABLE silver.erp_loc_a101;

        PRINT '>> Inserting data into silver.erp_loc_a101...';
        SET @stepStart = SYSDATETIME();

        INSERT INTO silver.erp_loc_a101 (cid, cntry)
        SELECT 
            'CK-' + RIGHT('00000' + CAST(SUBSTRING(cid, 2, LEN(cid)) AS VARCHAR), 5),
            CASE 
                WHEN UPPER(TRIM(cntry)) = 'TG' THEN 'Tigray'
                WHEN UPPER(TRIM(cntry)) IN ('US', 'USA') THEN 'United States'
                WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
                ELSE TRIM(cntry)
            END
        FROM bronze.erp_loc_a101;

        SET @stepEnd = SYSDATETIME();
        SET @durationSeconds = DATEDIFF(SECOND, @stepStart, @stepEnd);
        PRINT '>> Inserted data into silver.erp_loc_a101 in ' + CAST(@durationSeconds AS VARCHAR(10)) + ' seconds.';

        PRINT '>> silver.load_silver procedure completed successfully.';

    END TRY
    BEGIN CATCH
        PRINT '>> ERROR: ' + ERROR_MESSAGE();
        THROW;
    END CATCH;

    DECLARE @procEnd DATETIME2 = SYSDATETIME();
    DECLARE @totalDuration INT = DATEDIFF(SECOND, @procStart, @procEnd);

    PRINT '>> Total procedure duration: ' + CAST(@totalDuration AS VARCHAR(10)) + ' seconds.';
END

