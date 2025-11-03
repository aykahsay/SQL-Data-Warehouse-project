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
