Use MainComputerStore
GO

-- AddComponentToStore Procedure --------------------------------

CREATE OR ALTER PROCEDURE AddComponentToStore
    @product_name VARCHAR(100),
    @quantity INT,
    @price MONEY
AS
BEGIN
    INSERT INTO Products
    VALUES (@product_name, @quantity, @price);
END;
GO

-- AddClient Procedure --------------------------------

CREATE OR ALTER PROCEDURE AddClient
    @name VARCHAR(30),
    @last_name VARCHAR(50),
    @address VARCHAR(200)
AS
BEGIN
    INSERT INTO Clients
    VALUES (@name, @last_name, @address);
END;
GO

-- BuyComponent Procedure --------------------------------

CREATE OR ALTER PROCEDURE BuyComponent
    @product_id INT,
    @client_id INT,
    @quantity INT
AS
BEGIN
    DECLARE @available_quantity INT;
	DECLARE @price MoNEY;

    SELECT @available_quantity = quantity FROM Products WHERE product_id = @product_id;
	SELECT @price = price * @quantity FROM Products WHERE product_id = @product_id;

    IF @available_quantity >= @quantity
    BEGIN
        INSERT INTO Transactions
        VALUES (@product_id, @client_id, @quantity, @price);

        UPDATE Products
        SET quantity = quantity - @quantity
        WHERE product_id = @product_id;
    END
    ELSE
    BEGIN
        PRINT 'Not enough stock available';
    END
END;
GO

-- CheckAndTransferStock Procedure --------------------------------

CREATE OR ALTER PROCEDURE CheckAndTransferStock
    @product_id INT
AS
BEGIN
    DECLARE @sql_server_available_quantity INT;
	DECLARE @oracle_available_quantity INT;
    DECLARE @remaining_quantity INT;
	DECLARE @quantity_to_transfer INT;

    SET @sql_server_available_quantity = COALESCE((SELECT quantity FROM SqlServerAvailableComponents WHERE product_id = @product_id), 0)
	
	SET @oracle_available_quantity = COALESCE((SELECT quantity FROM OracleAvailableComponents WHERE product_id = @product_id), 0)

	SELECT @remaining_quantity = quantity FROM Products WHERE product_id = @product_id

	PRINT('Remaining quantity: ' + CAST(@remaining_quantity AS NVARCHAR(10)))

	SET @quantity_to_transfer = round(@remaining_quantity * 0.2, 0, 1)

    IF @sql_server_available_quantity <= @quantity_to_transfer
		BEGIN
			PRINT('Quantity of this product in sql server stock is: ' + CAST(@sql_server_available_quantity AS NVARCHAR(10)))
			PRINT('Transfering ' + CAST(@quantity_to_transfer AS NVARCHAR(10)) + ' products')
			IF @sql_server_available_quantity = 0
			BEGIN
				INSERT INTO [ComputerStoreSQLServer].dbo.Stock (product_id, quantity, price)
				SELECT product_id, quantity, price FROM Products WHERE product_id = @product_id
			END
			ELSE
			BEGIN
				UPDATE [ComputerStoreSQLServer].dbo.Stock 
				SET quantity = @quantity_to_transfer
				WHERE product_id = @product_id
			END
			
			UPDATE Products
			SET quantity = quantity - @quantity_to_transfer
			WHERE product_id = @product_id
		END

	SET @quantity_to_transfer = round(@remaining_quantity * 0.2, 0, 1)

    IF @oracle_available_quantity <= @quantity_to_transfer
		BEGIN
			PRINT('Quantity of this product in oracle stock is: ' + CAST(@oracle_available_quantity AS NVARCHAR(10)))
			PRINT('Transfering ' + CAST(@quantity_to_transfer AS NVARCHAR(10)) + ' products')

			IF @oracle_available_quantity = 0
			BEGIN
				INSERT INTO [OracleLS]..[COMPUTERSTOREUSERORACLE].STOCK (product_id, quantity, price)
				SELECT product_id, quantity, price FROM Products WHERE product_id = @product_id
			END
			ELSE
			BEGIN
				UPDATE [OracleLS]..[COMPUTERSTOREUSERORACLE].STOCK
				SET quantity = @quantity_to_transfer
				WHERE product_id = @product_id
			END

			UPDATE Products
			SET quantity = quantity - @quantity_to_transfer
			WHERE product_id = @product_id
		END

END;
GO

-- TESTING -------------------------------

-- AddComponentToStore test --------------
EXEC AddComponentToStore 'Procesor Noname', 10, 1000

SELECT * FROM Products
Go

-- AddClient test ------------------------

EXEC AddClient 'Jan', 'Bednarek', 'Czêstochowa, ul. Kolejowa 55'

SELECT * FROM Clients
Go

-- BuyComponent test --------------------------

EXEC BuyComponent 1, 1, 2

SELECT * FROM Products
Go

SELECT * FROM Transactions
Go
-- CheckAndTransferStock test --------------------------

SELECT * FROM SqlServerAvailableComponents

SELECT * FROM OracleAvailableComponents

SELECT * FROM Products

EXEC CheckAndTransferStock 2


