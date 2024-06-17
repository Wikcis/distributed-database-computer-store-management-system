Use ComputerStoreSQLServer
Go

-- VIEWS ---------------------------------------

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
CREATE OR ALTER VIEW AvailableMotherBoards AS
SELECT 
	product_id,
	product_name,
	quantity,
	price
FROM Stock
WHERE category = 'Motherboard'
Go

SELECT * FROM AvailableMotherBoards
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
    Stock p1
JOIN 
    Stock p2 ON p1.product_id <> p2.product_id
WHERE 
    p1.quantity = 0 AND p2.quantity > 0 AND 
    p1.category = p2.category
GO

SELECT * FROM SimilarAvailableComponents
Go