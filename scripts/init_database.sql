/*
===============================================================================
Database Initialization Script: DataWarehouse
===============================================================================
Scope: 
    - Resets the Data Warehouse environment.
    - Implements the Medallion Architecture (Bronze, Silver, Gold).
    
Strategy: Full Re-initialization (Full Load Approach).
Warning: This script drops the entire database; all existing data will be lost.
===============================================================================
*/

USE master;


-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END


CREATE DATABASE DataWarehouse;


USE DataWarehouse;


CREATE SCHEMA bronze;


CREATE SCHEMA silver;


CREATE SCHEMA gold;

