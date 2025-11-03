-- Expectation: No result Checking for Primary Key
SELECT 
cst_id, count(*)
from bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*)>1 OR cst_id IS NULL
