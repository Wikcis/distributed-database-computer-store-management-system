Use MainComputerStore
Go

-- VIEWS ---------------------------------------

-- OracleAvailableComponents View -------------------------------------------------
CREATE OR ALTER VIEW OracleAvailableComponents AS
SELECT *
FROM OPENROWSET('OraOLEDB.Oracle', 
	'pd19c'; 
	'computerStoreUserOracle'; 
	'12345',
	'SELECT * FROM COMPUTERSTOREUSERORACLE.PRODUCTS s WHERE s.quantity > 0') AS OracleStock
Go

SELECT * FROM OracleAvailableComponents
Go

-- ComponentPrices View -------------------------------------------------
CREATE OR ALTER VIEW ComponentPrices AS
SELECT 
    s.product_id,
    s.product_name,
    s.price
FROM 
    Stock s;
GO

SELECT * FROM ComponentPrices
Go

-- ProductSales View -------------------------------------------------
CREATE OR ALTER VIEW ProductSales AS
SELECT 
    p.product_id,
    p.product_name,
    COUNT(t.transaction_id) AS sold_quantity,
    p.quantity AS available_quantity
FROM 
    Stock p
LEFT JOIN 
    Transactions t ON p.product_id = t.product_id
GROUP BY 
    p.product_id, p.product_name, p.quantity;
GO

SELECT * FROM ProductSales
Go

-- MostPurchasedProducts View -------------------------------------------------

CREATE OR ALTER VIEW MostPurchasedProducts AS
SELECT TOP 3
    p.product_id,
    p.product_name,
    COUNT(t.transaction_id) AS purchase_count
FROM 
    Stock p
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
    SUM(t.quantity) AS total_sales_value
FROM 
    Stock p
JOIN 
    Transactions t ON p.product_id = t.product_id
GROUP BY 
    p.product_id, p.product_name;
GO

SELECT * FROM TotalSalesValueByComponent
Go

-- AvailableComponents View -------------------------------------------------
CREATE OR ALTER VIEW AvailableComponents AS
SELECT 
	product_id,
	category,
	price
FROM Stock
WHERE quantity > 0
Go

SELECT * FROM AvailableComponents
Go

-- AvailableGraphics View -------------------------------------------------
CREATE OR ALTER VIEW AvailableGraphics AS
SELECT 
	product_id,
	product_name,
	quantity,
	price
FROM Stock
WHERE category = 'Graphics'
Go

SELECT * FROM AvailableGraphics
Go

-- AvailableProcessor View -------------------------------------------------
CREATE OR ALTER VIEW AvailableProcessor AS
SELECT 
	product_id,
	product_name,
	quantity,
	price
FROM Stock
WHERE category = 'Processor'
Go

SELECT * FROM AvailableProcessor
Go

-- AvailableRam View -------------------------------------------------
CREATE OR ALTER VIEW AvailableRam AS
SELECT 
	product_id,
	product_name,
	quantity,
	price
FROM Stock
WHERE category = 'Ram'
Go

SELECT * FROM AvailableRam
Go

-- AvailableMotherBoards View -------------------------------------------------
CREATE OR ALTER VIEW AvailableMotherboards AS
SELECT 
	product_id,
	product_name,
	quantity,
	price
FROM Stock
WHERE category = 'Motherboard'
Go

SELECT * FROM AvailableMotherboards
Go