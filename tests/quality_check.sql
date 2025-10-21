/*
=====================================================================
Quality Checks
=====================================================================
Script Purpose:
This script performs various quality checks for data consistency, accuracy,
and standardization across the 'silver' schema. It includes checks for:
- Null or duplicate primary keys.
- Unwanted spaces in string fields.
- Data standardization and consistency.
- Invalid date ranges and orders.
- Data consistency between related fields.

Usage Notes:
- Run these checks after data loading Silver Layer.
- Investigate and resolve any discrepancies found during the checks.
=====================================================================
*/
-- There are examples.You should change the tableName to yours.
-- Null
SELECT *
FROM silver.customer
WHERE customer_id IS NULL;

-- duplicate primary keys.
-- 是否有重复
SELECT customer_id, COUNT(*) AS cnt
FROM silver.customer
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Unwanted spaces in string fields.
-- 是否有空格
SELECT *
FROM silver.product
WHERE product_name LIKE ' %' OR product_name LIKE '% ';

-- Data standardization and consistency.
ELECT DISTINCT country
FROM silver.customer
WHERE country NOT IN ('Germany', 'United States', 'China', 'n/a');

-- Data consistency between related fields.
-- 检查订单表中的客户ID在客户表中是否存在
SELECT o.order_id, o.customer_id
FROM silver.orders o
LEFT JOIN silver.customer c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
