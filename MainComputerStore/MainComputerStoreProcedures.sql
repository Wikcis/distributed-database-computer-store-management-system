Use MainComputerStore
GO

-- AddLog Procedure --------------------------------

CREATE OR ALTER PROCEDURE AddLog
    @log_message VARCHAR(MAX)
AS
BEGIN
	INSERT INTO Logs
	VALUES (@log_message);
END;
GO

-- AddComponentToStore Procedure --------------------------------

CREATE OR ALTER PROCEDURE AddComponentToStore
    @product_name VARCHAR(100),
	@category VARCHAR(100),
    @quantity INT,
    @price MONEY
AS
BEGIN

	IF NOT EXISTS (SELECT * FROM Products WHERE product_name = @product_name AND category = @category)
	BEGIN
		INSERT INTO Products
		VALUES (@product_name, @category, @quantity, @price);
	END
	ELSE
	BEGIN
		UPDATE Products
		SET quantity = quantity + @quantity
	END
    
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

	PRINT('Remaining quantity: ' + CAST(@remaining_quantity AS NVARCHAR(10)) + CHAR(13))

	SET @quantity_to_transfer = round(@remaining_quantity * 0.2, 0, 1)

    IF @sql_server_available_quantity IS NULL OR @sql_server_available_quantity <= @quantity_to_transfer
	BEGIN
		PRINT('Quantity of this product in sql server stock is: ' + CAST(@sql_server_available_quantity AS NVARCHAR(10)) + CHAR(13))
		PRINT('Transfering ' + CAST(@quantity_to_transfer AS NVARCHAR(10)) + ' products' + CHAR(13))
		IF @sql_server_available_quantity = 0
		BEGIN
			INSERT INTO [ComputerStoreSQLServer].dbo.Stock (product_id, product_name, category, quantity, price)
			SELECT product_id, product_name, category, quantity, price FROM Products WHERE product_id = @product_id
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
	ELSE PRINT('There are enough components in sql server stock!' + CHAR(13))

	SET @quantity_to_transfer = round(@remaining_quantity * 0.2, 0, 1)

    IF @oracle_available_quantity IS NULL OR @oracle_available_quantity <= @quantity_to_transfer
	BEGIN
		PRINT('Quantity of this product in oracle stock is: ' + CAST(@oracle_available_quantity AS NVARCHAR(10)) + CHAR(13))
		PRINT('Transfering ' + CAST(@quantity_to_transfer AS NVARCHAR(10)) + ' products' + CHAR(13))

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
	ELSE PRINT('There are enough components in oracle stock!' + CHAR(13))

END;
GO


