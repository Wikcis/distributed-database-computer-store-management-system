Use MainComputerStore
Go

-- VIEWS ---------------------------------------

-- SqlServerAvailableComponents View -------------------------------------------------
CREATE OR ALTER VIEW SqlServerAvailableComponents AS
SELECT *
FROM OPENROWSET('MSOLEDBSQL', 
	'LAPTOP-PCASHRLR'; 
	'computerStoreLoginSqlServer'; 
	'12345','SELECT * FROM [SQLServerLS].[ComputerStoreSQLServer].dbo.Stock s WHERE s.quantity > 0')
Go

SELECT * FROM SqlServerAvailableComponents
Go

-- OracleAvailableComponents View -------------------------------------------------
CREATE OR ALTER VIEW OracleAvailableComponents AS
SELECT *
FROM OPENROWSET('OraOLEDB.Oracle', 
	'pd19c'; 
	'computerStoreUserOracle'; 
	'12345',
	'SELECT * FROM COMPUTERSTOREUSERORACLE.STOCK s WHERE s.quantity > 0') AS OracleStock
Go

SELECT * FROM OracleAvailableComponents
Go


-- AllAvailableComponents View -------------------------------------------------
CREATE OR ALTER VIEW AllAvailableComponents AS
SELECT * FROM (
    SELECT *
    FROM OPENROWSET('MSOLEDBSQL', 
		'LAPTOP-PCASHRLR'; 
		'computerStoreLoginSqlServer'; 
		'12345','SELECT * FROM [SQLServerLS].[ComputerStoreSQLServer].dbo.Stock s WHERE s.quantity > 0') AS SQLServerStock
    UNION ALL
    SELECT *
    FROM OPENROWSET('OraOLEDB.Oracle', 
		'pd19c'; 
		'computerStoreUserOracle'; 
		'12345',
		'SELECT * FROM COMPUTERSTOREUSERORACLE.STOCK s WHERE s.quantity > 0') AS OracleStock
) AS CombinedStock;
Go

SELECT * FROM AllAvailableComponents
Go
-- ComponentPrices View -------------------------------------------------
CREATE OR ALTER VIEW ComponentPrices AS
SELECT 
    p.product_id,
    p.product_name,
    p.price
FROM 
    Products p;
GO

SELECT * FROM ComponentPrices
Go

-- ProductSales View -------------------------------------------------
CREATE OR ALTER VIEW ProductSales AS
SELECT 
    p.product_id,
    p.product_name,
    COALESCE(SUM(t.quantity), 0) AS sold_quantity,
    p.quantity AS available_quantity
FROM 
    Products p
LEFT JOIN 
    Transactions t ON p.product_id = t.product_id
GROUP BY 
    p.product_id, p.product_name, p.quantity;
GO

SELECT * FROM ProductSales
Go

-- PopularManufacturers View -------------------------------------------------

CREATE OR ALTER VIEW PopularManufacturers AS
SELECT TOP 3 
    LEFT(p.product_name, CHARINDEX(' ', p.product_name) - 1) AS manufacturer,
    COUNT(t.product_id) AS total_sales
FROM 
    Products p
JOIN 
    Transactions t ON p.product_id = t.product_id
GROUP BY 
    LEFT(p.product_name, CHARINDEX(' ', p.product_name) - 1)
ORDER BY 
    total_sales DESC;
GO

SELECT * FROM PopularManufacturers
Go

-- MostPurchasedProducts View -------------------------------------------------

CREATE OR ALTER VIEW MostPurchasedProducts AS
SELECT TOP 3
    p.product_id,
    p.product_name,
    COUNT(t.transaction_id) AS purchase_count
FROM 
    Products p
JOIN 
    Transactions t ON p.product_id = t.product_id
GROUP BY 
    p.product_id, p.product_name
ORDER BY 
    purchase_count DESC;
GO

SELECT * FROM MostPurchasedProducts
GO

-- TotalSalesValueByComponent View -------------------------------------------------

CREATE OR ALTER VIEW TotalSalesValueByComponent AS
SELECT 
    p.product_id,
    p.product_name,
    SUM(t.price * t.quantity) AS total_sales_value
FROM 
    Products p
JOIN 
    Transactions t ON p.product_id = t.product_id
GROUP BY 
    p.product_id, p.product_name;
GO

SELECT * FROM TotalSalesValueByComponent
Go
-- SimilarAvailableComponents View -------------------------------------------------

CREATE OR ALTER VIEW SimilarAvailableComponents AS
SELECT 
    p1.product_id AS unavailable_product_id,
    p1.product_name AS unavailable_product_name,
    p2.product_id AS similar_product_id,
    p2.product_name AS similar_product_name,
    p2.quantity,
    p2.price
FROM 
    Products p1
JOIN 
    Products p2 ON p1.product_id <> p2.product_id
WHERE 
    p1.quantity = 0 AND p2.quantity > 0 AND 
    LEFT(p1.product_name, CHARINDEX(' ', p1.product_name)) = LEFT(p2.product_name, CHARINDEX(' ', p2.product_name));
GO

SELECT * FROM SimilarAvailableComponents
Go