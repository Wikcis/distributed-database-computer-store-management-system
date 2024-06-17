USE ComputerStoreSQLServer;
GO

-- CheckCompatibility PROCEDURE ----------------------------------------
CREATE OR ALTER PROCEDURE dbo.CheckCompatibility
    @product_id_1 INT,
    @product_id_2 INT
AS
BEGIN
    DECLARE @category_1 VARCHAR(50);
    DECLARE @category_2 VARCHAR(50);
	DECLARE @is_compatible BIT;
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @params NVARCHAR(MAX) = N'@product_id_1 INT, @product_id_2 INT, @is_compatible BIT OUTPUT';

    SELECT @category_1 = category FROM dbo.Stock WHERE product_id = @product_id_1;
    SELECT @category_2 = category FROM dbo.Stock WHERE product_id = @product_id_2;

    SET @is_compatible = 0;

	IF @category_1 != 'Motherboard' AND @category_2 != 'Motherboard'
	BEGIN
		SET @is_compatible = 1
	END
	IF @product_id_1 = @product_id_2
	BEGIN
		SET @is_compatible = 1
		PRINT 'This is the same component.'
		RETURN
	END

    SELECT TOP 1 @sql = N'SELECT @is_compatible = CASE WHEN ' + compatibility_criteria + ' THEN 1 ELSE 0 END
                          FROM dbo.' + product_category_1 + 'Details d1
                          JOIN dbo.' + product_category_2 + 'Details d2
                          ON d1.product_id = @product_id_1 AND d2.product_id = @product_id_2'
    FROM dbo.CompatibilityRules
    WHERE product_category_1 = @category_1 AND product_category_2 = @category_2;

    IF @sql IS NOT NULL
    BEGIN
        EXEC sp_executesql @sql, @params, @product_id_1 = @product_id_1, @product_id_2 = @product_id_2, @is_compatible = @is_compatible OUTPUT;
		IF @is_compatible = 1
		BEGIN
			PRINT 'Components are compatible!'
		END
		ELSE
		BEGIN
			PRINT 'Components are not compatible!'
		END
	END
    ELSE
    BEGIN
        PRINT 'No compatibility rule found for the given product categories.';
		PRINT 'Components are compatible!'
    END
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

    SELECT @available_quantity = quantity FROM Stock WHERE product_id = @product_id;
	SELECT @price = price * @quantity FROM Stock WHERE product_id = @product_id;

    IF @available_quantity >= @quantity
    BEGIN
        INSERT INTO Transactions
        VALUES (@product_id, @price, @quantity, @client_id, GETDATE());

        UPDATE Stock
        SET quantity = quantity - @quantity
        WHERE product_id = @product_id;
    END
    ELSE
    BEGIN
        PRINT 'Not enough stock available';
		SELECT * FROM SimilarAvailableComponents
    END
END;
GO

-- TESTING -----------------------------------------

EXEC dbo.CheckCompatibility
    @product_id_1 = 1,
    @product_id_2 = 4

EXEC dbo.BuyComponent
    @product_id = 1,
	@client_id = 1,
	@quantity = 1

