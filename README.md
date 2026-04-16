Modern Data Warehouse: Medallion Architecture (Full Load Approach)
📌 Project Overview
This project implements a structured Data Warehouse using the Medallion Architecture (Bronze, Silver, Gold) on SQL Server. The ingestion and transformation logic utilize a Full Load (Truncate & Load) strategy, ensuring that each layer reflects the most current state of the CRM and ERP source systems.

🏗 Data Architecture & Flow
The pipeline is designed to be idempotent; running the scripts multiple times will yield the same consistent result without duplicating data.

🥉 Bronze Layer (Raw/Staging)
Strategy: Full Truncate & Load.

Process: Existing data in Bronze tables is wiped, and raw data is ingested directly from CRM/ERP sources.

Purpose: Captures a "point-in-time" snapshot of the operational systems for immediate processing.

🥈 Silver Layer (Cleansed & Integrated)
Strategy: Full Refresh.

Process: Cleanses, casts data types, and handles nulls. It merges CRM and ERP entities (e.g., matching a Customer ID across both systems).

Focus: Removing "noise" from the raw data and creating a clean, validated middle layer.

🥇 Gold Layer (Business Ready)
Strategy: Dimensional Modeling (Truncate & Load).

Process: Transforms Silver data into a Star Schema (Fact and Dimension tables).

Purpose: High-performance tables prepared for Business Objects, Power BI, or complex analytical queries.

🛠 Project Requirements
1. Data Flow Processing (CRM & ERP)
Truncate & Load Logic: T-SQL scripts use TRUNCATE TABLE followed by INSERT INTO statements to ensure zero data residuals from previous runs.

Integration: Joins CRM opportunity data with ERP financial records to provide a 360-degree business view.

Data Consistency: Since the entire warehouse is refreshed, data integrity is maintained across all layers without the complexity of delta tracking (CDC).

2. Preparation for Business Objects
Star Schema Design: Fact tables for transactions (Sales, Orders) and Dimension tables for context (Customer, Product, Store).

Analytical Views: SQL Views are built on top of the Gold Layer to provide a "Semantic Layer" for business users.

Performance: Tables are indexed post-load to ensure fast retrieval for BI dashboards.

📂 Repository Structure
Bash
├── 01_Bronze/           # Scripts to truncate and load raw CRM/ERP data
├── 02_Silver/           # Data cleansing and cross-system mapping scripts
├── 03_Gold/             # Fact and Dimension table definitions
├── 04_ETL_Scripts/      # Master T-SQL procedures for the Full Load pipeline
└── 05_Reporting_Views/  # Prepared views for Business Objects/BI Tools
