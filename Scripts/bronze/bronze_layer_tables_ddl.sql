-- Create schema if not exists (manual check)
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze');
END;
GO

-- Drop and create crm_cust_info table in bronze schema
DROP TABLE IF EXISTS bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_material_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE
);
GO

-- Drop and create crm_sales_details table
DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);
GO

-- Drop and create crm_prd_info table
DROP TABLE IF EXISTS bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt DATETIME
);
GO

-- Drop and create erp_loc_a101 table
DROP TABLE IF EXISTS bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101 (
    cid VARCHAR(50),
    cntry VARCHAR(50)
);
GO

-- Drop and create erp_cust_az12 table
DROP TABLE IF EXISTS bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
    cid VARCHAR(50),
    bdate DATE,
    gen VARCHAR(50)
);
GO

-- Drop and create erp_px_cat_g1v2 table
DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50)
);
GO

-- Drop and create etl_audit_log table
DROP TABLE IF EXISTS bronze.etl_audit_log;
CREATE TABLE bronze.etl_audit_log (
    id INT IDENTITY(1,1) PRIMARY KEY,
    layer VARCHAR(20),
    procedure_name VARCHAR(100),
    status VARCHAR(20),
    start_time DATETIME,
    end_time DATETIME,
    duration_seconds INT,
    error_code INT,
    error_message NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE()
);
GO
EXEC sp_rename 
    'bronze.crm_cust_info.cst_material_status', 
    'cst_marital_status', 
    'COLUMN';

-- Show tables (SQL Server equivalent)
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'bronze';

