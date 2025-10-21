# sql-data-warehouse-project
Building a model data ware house with SQL server, including ETL process, data modeling and analytics

The data architecture for this project follows Medallion Architecture Bronze, Silver, and Gold layers:
1.Bronze Layer: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2.Silver Layer: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3.Gold Layer: Houses business-ready data modeled into a star schema required for reporting and analytics.
该项目的数据架构遵循 Medallion Architecture 铜牌 、 银牌和金牌层：
1.青铜级 ：按原样存储来自源系统的原始数据。数据从 CSV 文件提取到 SQL Server 数据库。
2.银层 ：此层包括数据清理、标准化和规范化过程，以准备分析数据。
3.黄金层 ：将业务就绪数据建模为报告和分析所需的星型模式。

