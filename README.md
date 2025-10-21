# sql-data-warehouse-project
Building a model data ware house with SQL server, including ETL process, data modeling and analytics

The data architecture for this project follows Medallion Architecture Bronze, Silver, and Gold layers:<br>
1.Bronze Layer: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.<br>
2.Silver Layer: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.<br>
3.Gold Layer: Houses business-ready data modeled into a star schema required for reporting and analytics.<br>
该项目的数据架构遵循 Medallion Architecture 铜牌 、 银牌和金牌层：<br>
1.青铜级 ：按原样存储来自源系统的原始数据。数据从 CSV 文件提取到 SQL Server 数据库。<br>
2.银层 ：此层包括数据清理、标准化和规范化过程，以准备分析数据。<br>
3.黄金层 ：将业务就绪数据建模为报告和分析所需的星型模式。<br>

下面为每层的数据<br>
![image](https://github.com/13Liujq13/sql-data-warehouse-project/blob/main/%E6%95%B0%E6%8D%AE%E6%B5%81%E7%A8%8B%E5%9B%BE.drawio.png)

