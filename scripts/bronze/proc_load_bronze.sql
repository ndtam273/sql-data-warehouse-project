-- =============================================================================
-- Stored Procedure : bronze.load_bronze
-- Purpose          : Load raw data from CSV source files into the Bronze layer
-- Bronze contract  : No transformation — data lands exactly as it appears in
--                    the source files. Cleansing happens in the Silver layer.
-- Execution        : EXEC bronze.load_bronze
-- Dependencies     : Requires CSV files to exist at the /tmp/ paths listed below
--                    - /tmp/cust_info.csv
--                    - /tmp/prd_info.csv
--                    - /tmp/sales_details.csv
--                    - /tmp/cust_az12.csv
--                    - /tmp/loc_a101.csv
--                    - /tmp/px_cat_g1v2.csv
-- Notes            : Each table is truncated before loading — full refresh, not
--                    incremental. Any failure rolls back via THROW to the caller.
-- =============================================================================
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME;

    BEGIN TRY
        PRINT '======================================';
        PRINT 'Loading bronze layer';
        PRINT '======================================';
        PRINT '--------------------------------------';
        PRINT 'Loading crm Tables';
        PRINT '--------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
        PRINT '>> Inserting data into: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM '/tmp/cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Successfully loaded: bronze.crm_cust_info (' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR) + ' ms)';

        SET @start_time = GETDATE();
        PRINT '>> Truncating table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;
        PRINT '>> Inserting data into: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM '/tmp/prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Successfully loaded: bronze.crm_prd_info (' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR) + ' ms)';

        SET @start_time = GETDATE();
        PRINT '>> Truncating table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;
        PRINT '>> Inserting data into: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM '/tmp/sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Successfully loaded: bronze.crm_sales_details (' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR) + ' ms)';

        PRINT '--------------------------------------';
        PRINT 'Loading erp Tables';
        PRINT '--------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;
        PRINT '>> Inserting data into: bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM '/tmp/cust_az12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Successfully loaded: bronze.erp_cust_az12 (' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR) + ' ms)';

        SET @start_time = GETDATE();
        PRINT '>> Truncating table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;
        PRINT '>> Inserting data into: bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM '/tmp/loc_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Successfully loaded: bronze.erp_loc_a101 (' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR) + ' ms)';

        SET @start_time = GETDATE();
        PRINT '>> Truncating table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        PRINT '>> Inserting data into: bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM '/tmp/px_cat_g1v2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Successfully loaded: bronze.erp_px_cat_g1v2 (' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR) + ' ms)';

        PRINT '======================================';
        PRINT 'Bronze layer loaded successfully';
        PRINT '======================================';

    END TRY
    BEGIN CATCH
        PRINT '======================================';
        PRINT 'ERROR: Bronze layer load failed';
        PRINT '  Error Number  : ' + CAST(ERROR_NUMBER()   AS NVARCHAR);
        PRINT '  Error Message : ' + ERROR_MESSAGE();
        PRINT '  Error Line    : ' + CAST(ERROR_LINE()     AS NVARCHAR);
        PRINT '  Error State   : ' + CAST(ERROR_STATE()    AS NVARCHAR);
        PRINT '======================================';

        THROW;
    END CATCH
END
