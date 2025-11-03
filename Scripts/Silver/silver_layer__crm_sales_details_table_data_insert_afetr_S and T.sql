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
        ELSE CONVERT(date, CAST(sls_order_dt AS varchar), 112)  -- SQL Server YYYYMMDD to DATE
    END AS sls_order_dt,

    CASE 
        WHEN sls_ship_dt = 0 OR LEN(CAST(sls_ship_dt AS varchar)) != 8 THEN NULL
        ELSE CONVERT(date, CAST(sls_ship_dt AS varchar), 112)
    END AS sls_ship_dt,

    CASE 
        WHEN sls_due_dt = 0 OR LEN(CAST(sls_due_dt AS varchar)) != 8 THEN NULL
        ELSE CONVERT(date, CAST(sls_due_dt AS varchar), 112)
    END AS sls_due_dt,

    -- Recalculate sls_sales if missing or inconsistent
    CASE 
        WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
            THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,

    sls_quantity,

    -- Use sls_price if valid, else calculate from sls_sales / sls_quantity safely
    CASE 
        WHEN sls_price IS NULL OR sls_price <= 0 THEN 
            CASE WHEN sls_quantity = 0 THEN NULL ELSE sls_sales / NULLIF(sls_quantity, 0) END
        ELSE sls_price
    END AS sls_price

FROM bronze.crm_sales_details;
