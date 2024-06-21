USE ComputerStoreSQLServer;
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
        INSERT INTO Transactions
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
