SELECT *
FROM silver.crm_prd_info


-- Check for duplication and Null Values of Pk
SELECT prd_id,
       COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;


--check for un wanted spaces
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm!=TRIM(prd_nm)

-- Check for NULL OR Negative Numbers 
SELECT
prd_cost
FROM silver.crm_prd_info
WHERE prd_cost<0 OR prd_cost IS NULL

--Data Standardization and Consistency. Cheking Naming 
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- SELECT DISTINCT prd_line
SELECT*
FROM silver.crm_prd_info
WHERE prd_end_dt< prd_start_dt

