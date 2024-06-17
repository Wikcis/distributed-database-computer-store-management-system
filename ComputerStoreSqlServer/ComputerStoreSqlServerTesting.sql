Use ComputerStoreSQLServer
Go

-- TESTING ------------------

SELECT * FROM AvailableMotherboards
Go

SELECT * FROM AvailableGraphics
Go

EXEC dbo.CheckCompatibility
    @product_id_1 = 1,
    @product_id_2 = 4

EXEC dbo.BuyComponent
    @product_id = 1,
	@client_id = 1,
	@quantity = 1

EXEC dbo.BuyComponent
    @product_id = 4,
	@client_id = 1,
	@quantity = 1

-----------

SELECT * FROM AvailableMotherboards

EXEC dbo.BuyComponent
    @product_id = 9,
	@client_id = 1,
	@quantity = 1

EXEC dbo.BuyComponent
    @product_id = 4,
	@client_id = 1,
	@quantity = 1

SELECT * FROM Transactions
