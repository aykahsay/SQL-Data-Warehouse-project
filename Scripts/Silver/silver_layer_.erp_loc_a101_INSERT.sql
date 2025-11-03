-- CLEAN and Build silver.erp_loc_a101 

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

Select * from silver.erp_loc_a101 