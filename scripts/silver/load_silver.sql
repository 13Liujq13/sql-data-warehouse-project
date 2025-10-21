/*
This script is designed to clean and load raw data from the Bronze layer into the Silver layer, covering domains such as customers, products, and sales, ensuring data standardization and anomaly correction.
该脚本用于将原始数据从 Bronze 层 清洗并加载到 Silver 层，包括客户、产品、销售等主题表，实现数据标准化与异常值修复。
*/

-- 删除表数据（每次加入数据前都可以执行这个操作）
TRUNCATE TABLE stableName;

-- silver.crm_cust_info
INSERT INTO silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date)
SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE  
	WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	ELSE 'n/a'
END cst_marital_status,
CASE  
	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	ELSE 'n/a'
END cst_gndr,
cst_create_date
FROM(
	SELECT 
	*,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM bronze.crm_cust_info
)t WHERE flag_last = 1 AND cst_id>0


  -- silver.crm_prd_info
	-- 因为添加了新的列，所以要做修改
	DROP TABLE silver.crm_prd_info
	CREATE Table silver.crm_prd_info (
			prd_id INT,
			cat_id NVARCHAR (50),
			prd_key NVARCHAR (50),
			prd_nm NVARCHAR (50),
			prd_cost NVARCHAR (50),
			prd_line NVARCHAR (50),
			prd_start_dt DATE,
			prd_end_dt DATE,
			dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
	);

-- 添加数据
INSERT INTO silver.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
	)
SELECT 
	prd_id, 
	REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
	SUBSTRING(prd_key,7,LENGTH(prd_key)) AS prd_key,
	prd_nm,
	IFNULL(prd_cost,0) AS prd_cost,
	CASE 
			WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
			WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
			WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
			WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
			ELSE 'n/a'
	END AS prd_line,
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	 DATE_SUB(
        CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) AS DATE),
        INTERVAL 1 DAY
    ) AS prd_end_dt
FROM bronze.crm_prd_info

-- silver.crm_sales_details
TRUNCATE TABLE silver.crm_sales_details;
INSERT INTO silver.crm_sales_details(
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
)
SELECT
  sls_ord_num,
  sls_prd_key,
  sls_cust_id,
	CASE  
	WHEN sls_order_dt = 0 THEN
			NULLIF(sls_order_dt,0)
	ELSE
		sls_order_dt
	END AS sls_order_dt,
	CASE  
	WHEN sls_ship_dt = 0 THEN
			NULLIF(sls_ship_dt,0)
	ELSE
		sls_ship_dt
	END AS sls_ship_dt,
	CASE  
	WHEN sls_due_dt = 0 THEN
			NULLIF(sls_due_dt,0)
	ELSE
		sls_due_dt
	END AS sls_due_dt,
  CASE 
	WHEN sls_sales IS NULL OR sls_sales<=0 OR sls_sales != sls_quantity*ABS(sls_price) THEN sls_quantity*ABS(sls_price)
	ELSE sls_sales
END AS sls_sales,
  sls_quantity,
CASE 
	WHEN sls_price IS NULL OR sls_price <= 0 OR sls_price IS NULL THEN sls_sales/NULLIF(sls_quantity,0)
	ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details;

-- 上面的代码的sls_sales中还是会有0，所以预览将被更新的行，将0消除
SELECT *
FROM silver.crm_sales_details
WHERE (sls_sales IS NULL OR sls_sales = 0)
  AND sls_quantity IS NOT NULL AND sls_quantity <> 0
  AND sls_price IS NOT NULL AND sls_price <> 0
LIMIT 200;

-- 执行更新
UPDATE silver.crm_sales_details
SET sls_sales = sls_quantity * ABS(sls_price)
WHERE (sls_sales IS NULL OR sls_sales = 0)
  AND sls_quantity IS NOT NULL AND sls_quantity <> 0
  AND sls_price IS NOT NULL AND sls_price <> 0;

-- silver.erp_cust_az12
INSERT INTO silver.erp_cust_az12(
CID,
BDATE,
GEN
)
SELECT 
CASE 
	WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID,4,LENGTH(CID))
	ELSE CID
END CID,
CASE WHEN BDATE > CURDATE() THEN NULL
	ELSE BDATE
END AS BDATE,
CASE 
    WHEN LEFT(REPLACE(UPPER(TRIM(CONVERT(GEN USING utf8mb4))), CAST(0xA0 AS CHAR CHARACTER SET latin1), ''), 1) = 'M' THEN 'Male'
    WHEN LEFT(REPLACE(UPPER(TRIM(CONVERT(GEN USING utf8mb4))), CAST(0xA0 AS CHAR CHARACTER SET latin1), ''), 1) = 'F' THEN 'Female'
    ELSE 'n/a'
  END AS GEN
FROM bronze.erp_cust_az12;

-- silver.erp_loc_a101
INSERT INTO silver.erp_loc_a101(
CID,
CNTRY
)
SELECT
REPLACE(CID,'-','') AS CID,
CASE 
	WHEN TRIM(CNTRY) LIKE '%DE%' THEN 'Germany'
	WHEN TRIM(CNTRY) LIKE 'US%' OR TRIM(CNTRY) LIKE 'USA%' OR  TRIM(CNTRY) LIKE '%United States%' THEN 'United States'
	WHEN CNTRY IS NULL OR CNTRY REGEXP '^\\s*$' THEN 'n/a'
	ELSE TRIM(CNTRY)
END CNTRY
FROM bronze.erp_loc_a101;

-- silver.erp_px_cat_g1v2
INSERT INTO silver.erp_px_cat_g1v2(
ID,
CAT,
SUBCAT,
MAINTENANCE
)
SELECT
ID,
CAT,
SUBCAT,
MAINTENANCE
FROM bronze.erp_px_cat_g1v2

