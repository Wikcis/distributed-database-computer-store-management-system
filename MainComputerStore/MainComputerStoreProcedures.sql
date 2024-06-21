Use MainComputerStore
GO

-- BuyComponent Procedure --------------------------------
CREATE OR ALTER PROCEDURE BuyComponent
    @product_id INT,
    @client_id INT,
    @quantity INT
AS
BEGIN
    DECLARE @available_quantity INT;
	DECLARE @price MONEY;
	DECLARE @product_name VARCHAR(50);
	DECLARE @category VARCHAR(30);
	DECLARE @product_id_1 INT;

    SELECT @available_quantity = quantity, @category = category FROM Stock WHERE product_id = @product_id;
	SELECT @price = price * @quantity FROM Stock WHERE product_id = @product_id;
    IF @available_quantity >= @quantity
    BEGIN
        INSERT INTO LocalTransactions
        VALUES (@product_id, @client_id, @price, @quantity, GETDATE());

		SELECT @product_name = product_name FROM Stock WHERE product_id = @product_id

        UPDATE Stock
        SET quantity = quantity - @quantity
        WHERE product_id = @product_id;
		PRINT('You just bought product: ' + CAST(@product_name AS VARCHAR(50)))
    END
    ELSE
    BEGIN
        PRINT 'Not enough stock available';

		DECLARE stock_cursor CURSOR FOR
		SELECT product_id, product_name, category, quantity, price
		FROM Stock
		WHERE category = @category AND product_id <> @product_id AND quantity > 0

		OPEN stock_cursor;
        FETCH NEXT FROM stock_cursor INTO @product_id, @product_name, @category, @available_quantity, @price;

        PRINT 'Alternative products available:';
        PRINT 'Product ID | Product Name			   	    | Category		  | Quantity | Price';

        WHILE @@FETCH_STATUS = 0
        BEGIN
            PRINT (CAST(@product_id AS VARCHAR(10)) + '		   | ' +
                   LEFT(@product_name + REPLICATE(' ', 30), 30) + ' | ' +
                   LEFT(@category + REPLICATE(' ', 15), 15) + ' | ' +
                   CAST(@available_quantity AS VARCHAR(10)) + '	     | ' +
                   CAST(@price AS VARCHAR(10)));

            FETCH NEXT FROM stock_cursor INTO @product_id, @product_name, @category, @available_quantity, @price;
        END;


		CLOSE stock_cursor;
		DEALLOCATE stock_cursor;
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

-- CheckCompatibility Procedure ---------------------
CREATE OR ALTER PROCEDURE CheckCompatibility
    @product_id_1 INT,
	@product_id_2 INT
AS
BEGIN
	DECLARE @output INT;

    EXEC (N'BEGIN COMPONENT_MANAGEMENT.CHECK_COMPATIBILITY(?,?,?); END;', @product_id_1, @product_id_2, @output OUTPUT) AT OracleLS

	IF @output = 1
	BEGIN
		PRINT('Components with ID: ' + CAST(@product_id_1 AS VARCHAR(10)) + ' and ID: ' + CAST(@product_id_2 AS VARCHAR(10)) + ' are compatible!')
	END
	ELSE IF @output = 0
	BEGIN
		PRINT('Components with ID: ' + CAST(@product_id_1 AS VARCHAR(10)) + ' and ID: ' + CAST(@product_id_2 AS VARCHAR(10)) + ' are not compatible!')
	END
	ELSE 
	BEGIN
		PRINT('No data was found!')
	END

END;
GO

-- RequestAddingProducts Procedure --------------------------------
CREATE OR ALTER PROCEDURE RequestAddingProducts
	@product_id INT
AS
BEGIN
	DECLARE @transferredQuantity INT;
	DECLARE @quantity INT;

	SELECT @quantity = quantity FROM Stock WHERE product_id = @product_id

    EXEC (N'BEGIN COMPONENT_MANAGEMENT.TRANSFER_AVAILABILITY(?,?,?); END;', @product_id, @quantity, @transferredQuantity OUTPUT) AT OracleLS

	IF @transferredQuantity > 0
	BEGIN
		UPDATE Stock
		SET quantity += @transferredQuantity
		WHERE product_id = @product_id;

		PRINT('Data was successfully transferred!')
	END
	ELSE IF @transferredQuantity = 0
	BEGIN
		PRINT('Nothing to transfer!')
	END
END;
GO

-- DisplayCompatibleComponents Procedure -------------------------------------------------

CREATE OR ALTER PROCEDURE DisplayCompatibleComponents
	@product_id INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @output INT;
    DECLARE @product_id_2 INT;
    DECLARE @product_name VARCHAR(50);
    DECLARE @category VARCHAR(50);

    DECLARE stock_cursor CURSOR FOR
    SELECT product_id, product_name, category
    FROM Stock;

    OPEN stock_cursor;
    FETCH NEXT FROM stock_cursor INTO @product_id_2, @product_name, @category;

    PRINT ('Components compatible with product ID: ' + CAST(@product_id AS VARCHAR(10)))

    PRINT ('Product ID | Product Name                        | Category             | Is Compatible')
    PRINT ('-------------------------------------------------------------------------------------------')

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC (N'BEGIN COMPONENT_MANAGEMENT.CHECK_COMPATIBILITY(?,?,?); END;', @product_id, @product_id_2, @output OUTPUT) AT OracleLS;

        PRINT (LEFT(CAST(@product_id_2 AS VARCHAR(10)) + REPLICATE(' ', 10), 10) + ' | ' +
               LEFT(@product_name + REPLICATE(' ', 35), 35) + ' | ' +
               LEFT(@category + REPLICATE(' ', 20), 20) + ' | ' +
               CASE WHEN @output = 1 THEN 'is compatible' ELSE 'is not compatible' END)

        FETCH NEXT FROM stock_cursor INTO @product_id_2, @product_name, @category;
    END;

    CLOSE stock_cursor;
    DEALLOCATE stock_cursor;
END;
GO

-- CombineTransaction Procedure -------------------------------------------------

CREATE OR ALTER PROCEDURE CombineTransaction AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Transactions
    SELECT product_id, client_id, quantity, price, transaction_date
    FROM LocalTransactions;
END;
GO
