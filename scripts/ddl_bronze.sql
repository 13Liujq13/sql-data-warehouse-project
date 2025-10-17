/*
===================================================================================================
DDL Script: Create Bronze Tables
====================================================================================================
Script Purpose:
This script creates tables in the 'bronze' schema, dropping existing tables if they already exist.
Run this script to re-define the DDL structure of 'bronze' Tables
脚本用途：
此脚本在“bronze”架构中创建表，并删除已存在的表。
运行此脚本可重新定义“bronze”表的 DDL 结构
====================================================================================================
*/
-- 插入其他的文件代码以此类推
	TRUNCATE TABLE bronze.erp_px_cat_g1v2 -- 删除表的数据
	LOAD DATA LOCAL INFILE '/Users/eason/Documents/DATA/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
	INTO TABLE bronze.erp_px_cat_g1v2
	CHARACTER SET utf8mb4
	FIELDS TERMINATED BY ',' -- 分割符
	OPTIONALLY ENCLOSED BY '"'   
	LINES TERMINATED BY '\n'  
		-- 指定每一行记录的结束符；
		-- 对应 Unix/macOS 系统的换行符；
		-- 若文件来自 Windows，则应改为 '\r\n'。  
	IGNORE 1 LINES
		-- 跳过文件的第一行
	(ID,CAT,SUBCAT,MAINTENANCE);

	SELECT COUNT(*) FROM bronze.crm_cust_info
