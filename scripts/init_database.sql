/*
==========================
Create Database and Schemas
==========================
Script Purpose:
This script creates a new database named 'DataWarehouse' after checking if it already exists.
If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas within the database: 'bronze' , 'silver', and 'gold'.
WARNING:
Running this script will drop the entire 'DataWarehouse' database if it exists.
All data in the database will be permanently deleted. Proceed with caution and ensure you have proper backups before running this script.

脚本用途：
此脚本会在检查数据库“DataWarehouse”是否已存在后，创建一个名为“DataWarehouse”的新数据库。
如果该数据库已存在，则删除并重新创建。此外，该脚本还会在数据库中设置三个模式：“bronze”、“silver”和“gold”。
警告：
运行此脚本将删除整个“DataWarehouse”数据库（如果存在）。
数据库中的所有数据都将被永久删除。请谨慎操作，并确保在运行此脚本之前已进行妥善备份。
*/
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
  ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE DataWarehouse;

CREATE DATABASE DataWarehouse;

USE DataWarehouse;

CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;
