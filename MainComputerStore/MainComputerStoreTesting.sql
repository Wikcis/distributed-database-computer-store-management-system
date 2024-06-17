Use MainComputerStore
Go

-- TESTING ----------------------------------
SELECT * FROM Products
Go

EXEC AddComponentToStore 'Procesor INTEL Core i3','Processor', 10, 1000

EXEC AddComponentToStore 'Karta graficzna NVIDIA 4060 Ti','Graphics', 2, 5000

EXEC AddComponentToStore 'Pamiêæ Ram','RAM', 5, 100

SELECT * FROM Products
Go

-------------

EXEC AddLog @log_message = 'Delivery is incomplete!'

SELECT * FROM Logs

-------------
SELECT * FROM SqlServerAvailableComponents

SELECT * FROM OracleAvailableComponents

SELECT * FROM Products

EXEC CheckAndTransferStock 4

-------------

SELECT * FROM Transactions

SELECT * FROM MostPurchasedProducts
GO

SELECT * FROM TotalSalesValueByComponent
Go
-------------