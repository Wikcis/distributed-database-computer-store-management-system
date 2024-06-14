USE ComputerStoreSQLServer;
GO

-- CheckCompatibility PROCEDURE ----------------------------------------
CREATE OR ALTER PROCEDURE dbo.CheckCompatibility
    @product_id_1 INT,
    @product_id_2 INT,
    @is_compatible BIT OUTPUT
AS
BEGIN
    DECLARE @category_1 VARCHAR(50);
    DECLARE @category_2 VARCHAR(50);
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

    PRINT @sql;

    IF @sql IS NOT NULL
    BEGIN
        EXEC sp_executesql @sql, @params, @product_id_1 = @product_id_1, @product_id_2 = @product_id_2, @is_compatible = @is_compatible OUTPUT;
    END
    ELSE
    BEGIN
        PRINT 'No compatibility rule found for the given product categories.';
    END
END;
GO

-- TESTING -----------------------------------------
DECLARE @is_compatible BIT;

EXEC dbo.CheckCompatibility
    @product_id_1 = 1,
    @product_id_2 = 1,
    @is_compatible = @is_compatible OUTPUT;

SELECT @is_compatible AS IsCompatible;
