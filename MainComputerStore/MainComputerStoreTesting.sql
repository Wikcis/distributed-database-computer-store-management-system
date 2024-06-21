Use MainComputerStore
Go

-- TESTING ---------------------------------

SELECT * FROM Stock;
Go

SELECT * FROM Clients;
Go

SELECT * FROM Transactions;
Go

SELECT * FROM AvailableMotherboards
Go

SELECT * FROM AvailableGraphics
Go

SELECT * FROM AvailableProcessor
Go

SELECT * FROM AvailableRam
Go

EXEC BuyComponent 
	@product_id = 9,
    @client_id = 1,
    @quantity = 1
Go

EXEC RequestAddingProducts
	@product_id = 9
Go

-------------------

SELECT * FROM Stock;
Go

EXEC CheckCompatibility 
	@product_id_1 = 1,
    @product_id_2 = 8
Go

EXEC DisplayCompatibleComponents
	@product_id = 4
Go

------------
EXEC CombineTransaction

SELECT * FROM OracleAvailableComponents
Go

SELECT * FROM LocalTransactions;
Go

SELECT * FROM Transactions;
Go

SELECT * FROM ProductSales
Go

SELECT * FROM MostPurchasedProducts
GO

SELECT * FROM TotalSalesValueByComponent
Go

SELECT * FROM ComponentPrices
Go
