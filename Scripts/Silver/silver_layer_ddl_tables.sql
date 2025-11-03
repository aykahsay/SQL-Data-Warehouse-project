-- Create schema if not exists
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver')
EXEC('CREATE SCHEMA silver');

-- Drop and create crm_cust_info
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL DROP TABLE silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- Drop and create crm_sales_details
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- Drop and create crm_prd_info
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
    prd_id INT,
	cat_id VARCHAR(50),
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- Drop and create erp_loc_a101
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL DROP TABLE silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101 (
    cid VARCHAR(50),
    cntry VARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- Drop and create erp_cust_az12
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL DROP TABLE silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12 (
    cid VARCHAR(50),
    bdate DATE,
    gen VARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- Drop and create erp_px_cat_g1v2
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL DROP TABLE silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2 (
    id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50), -- Corrected from subat
    maintenance VARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- Drop and create etl_audit_log
IF OBJECT_ID('silver.etl_audit_log', 'U') IS NOT NULL DROP TABLE silver.etl_audit_log;
CREATE TABLE silver.etl_audit_log (
    id INT IDENTITY(1,1) PRIMARY KEY,
    layer VARCHAR(20),
    procedure_name VARCHAR(100),
    status VARCHAR(20),  -- 'SUCCESS' or 'FAILED'
    start_time DATETIME,
    end_time DATETIME,
    duration_seconds INT,
    error_code INT,
    error_message TEXT,
    created_at DATETIME DEFAULT GETDATE(),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- Show tables (SQL Server equivalent)
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'silver';
