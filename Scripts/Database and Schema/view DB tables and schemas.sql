USE DataWarehouse;
GO
SELECT name 
FROM sys.schemas;

SELECT TABLE_SCHEMA, TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';



SELECT name FROM sys.databases;


EXEC silver.load_silver;



SELECT *
FROM silver.crm_cust_info