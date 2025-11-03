
-- CLEAN and Build silver.erp_loc_a101 
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
