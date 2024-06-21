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