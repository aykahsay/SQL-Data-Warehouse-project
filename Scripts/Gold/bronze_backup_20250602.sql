-- Backup crm_cust_info
SELECT * INTO bronze.crm_cust_info_backup_20250602 FROM bronze.crm_cust_info;

-- Backup crm_sales_details
SELECT * INTO bronze.crm_sales_details_backup_20250602 FROM bronze.crm_sales_details;

-- Backup crm_prd_info
SELECT * INTO bronze.crm_prd_info_backup_20250602 FROM bronze.crm_prd_info;

-- Backup erp_loc_a101
SELECT * INTO bronze.erp_loc_a101_backup_20250602 FROM bronze.erp_loc_a101;

-- Backup erp_cust_az12
SELECT * INTO bronze.erp_cust_az12_backup_20250602 FROM bronze.erp_cust_az12;

-- Backup erp_px_cat_g1v2
SELECT * INTO bronze.erp_px_cat_g1v2_backup_20250602 FROM bronze.erp_px_cat_g1v2;

-- Backup etl_audit_log
SELECT * INTO bronze.etl_audit_log_backup_20250602 FROM bronze.etl_audit_log;
