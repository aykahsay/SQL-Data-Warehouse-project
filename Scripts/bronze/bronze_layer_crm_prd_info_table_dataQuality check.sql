-- crm_sales_details Clean and Load
---

SELECT *
FROM bronze.crm_sales_details

--check for un wanted spaces
SELECT *
FROM bronze.crm_sales_details
WHERE sls_ord_num!=TRIM(sls_ord_num)

select * from bronze.crm_prd_info

-- ERD prd_key From bronze.crm_sales_details to crm_prd_info of prd_key

select * from silver.crm_cust_info
select * from bronze.crm_prd_info
select *
from bronze.crm_sales_details
WHERE sls_cust_id  NOT IN (select cst_id from silver.crm_cust_info)


select *
from bronze.crm_sales_details
-- cHeck for InValid Dates
-- sls_oredr_dt is '20240101' format 

SELECT  NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <=0 OR LEN(sls_order_dt) !=8



-- Check for duplication and Null Values of Pk
SELECT prd_id,
       COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;


--check for un wanted spaces
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm!=TRIM(prd_nm)

-- Check for NULL OR Negative Numbers 
SELECT
prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost<0 OR prd_cost IS NULL

--Data Standardization and Consistency.
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

-- SELECT DISTINCT prd_line
SELECT*
FROM bronze.crm_prd_info
WHERE prd_end_dt< prd_start_dt

-- End date formuation
SELECT 
prd_id,
prd_key,
prd_nm,
prd_start_dt,
prd_end_dt,
LEAD (prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt_test
FROM bronze .crm_prd_info
WHERE prd_key IN ('PK-00003','PK-00009')
