-- Batch 1: Drop the procedure if exists (optional)
IF OBJECT_ID('bronze.load_bronze', 'P') IS NOT NULL
    DROP PROCEDURE bronze.load_bronze;
GO

-- Batch 2: Create or alter the procedure
CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @start_time DATETIME, @end_time DATETIME, @task_start DATETIME, @task_end DATETIME;
    DECLARE @task_duration INT;

    BEGIN TRY
        SET @start_time = GETDATE();
        PRINT '=====================';
        PRINT 'LOADING Bronze Layer';
        PRINT '=====================';

        -- 1. crm_cust_info

        SET @task_start = GETDATE();
        PRINT '🔄 Truncating bronze.crm_cust_info...';

        TRUNCATE TABLE bronze.crm_cust_info;

        BULK INSERT bronze.crm_cust_info
        FROM 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @task_end = GETDATE();
        SET @task_duration = CAST(DATEDIFF(SECOND, @task_start, @task_end) AS nvarchar);
        PRINT CONCAT('✅ crm_cust_info loaded in ', @task_duration, ' seconds.');

        -- 2. crm_prd_info
        SET @task_start = GETDATE();
        PRINT '🔄 Loading bronze.crm_prd_info...';

        TRUNCATE TABLE bronze.crm_prd_info;

        BULK INSERT bronze.crm_prd_info
        FROM 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @task_end = GETDATE();
        SET @task_duration =CAST(DATEDIFF(SECOND, @task_start, @task_end) AS nvarchar)
        PRINT CONCAT('✅ crm_prd_info loaded in ', @task_duration, ' seconds.');

        -- 3. crm_sales_details
        SET @task_start = GETDATE();
        PRINT '🔄 Loading bronze.crm_sales_details...';

        TRUNCATE TABLE bronze.crm_sales_details;

        BULK INSERT bronze.crm_sales_details
        FROM 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @task_end = GETDATE();
        SET @task_duration = CAST(DATEDIFF(SECOND, @task_start, @task_end) AS nvarchar)
        PRINT CONCAT('✅ crm_sales_details loaded in ', @task_duration, ' seconds.');

        -- 4. erp_cust_az12
        SET @task_start = GETDATE();
        PRINT '🔄 Loading bronze.erp_cust_az12...';

        TRUNCATE TABLE bronze.erp_cust_az12;

        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @task_end = GETDATE();
        SET @task_duration = CAST(DATEDIFF(SECOND, @task_start, @task_end) AS nvarchar)
        PRINT CONCAT('✅ erp_cust_az12 loaded in ', @task_duration, ' seconds.');

        -- 5. erp_loc_a101
        SET @task_start = GETDATE();
        PRINT '🔄 Loading bronze.erp_loc_a101...';

        TRUNCATE TABLE bronze.erp_loc_a101;

        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @task_end = GETDATE();
        SET @task_duration = CAST(DATEDIFF(SECOND, @task_start, @task_end) AS nvarchar)
        PRINT CONCAT('✅ erp_loc_a101 loaded in ', @task_duration, ' seconds.');

        -- 6. erp_px_cat_g1v2
        SET @task_start = GETDATE();
        PRINT '🔄 Loading bronze.erp_px_cat_g1v2...';

        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @task_end = GETDATE();
        SET @task_duration = CAST(DATEDIFF(SECOND, @task_start, @task_end) AS nvarchar)
        PRINT CONCAT('✅ erp_px_cat_g1v2 loaded in ', @task_duration, ' seconds.');

        SET @end_time = GETDATE();
        PRINT CONCAT('🏁 All tasks completed in ', CAST(DATEDIFF(SECOND, @task_start, @task_end) AS nvarchar),' seconds.');
    END TRY
    BEGIN CATCH
        PRINT '❌ ERROR occurred during ETL process.';
        PRINT ERROR_MESSAGE();
        THROW;
    END CATCH;
END;
GO

-- Batch 3: Execute the procedure to load data
EXEC bronze.load_bronze;
GO
