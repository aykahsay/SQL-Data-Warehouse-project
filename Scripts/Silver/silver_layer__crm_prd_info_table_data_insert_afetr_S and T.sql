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
  CAST(prd_end_dt AS DATE)  -- LEAD (prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt_test

FROM bronze.crm_prd_info

