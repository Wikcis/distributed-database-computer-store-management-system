Use ComputerStoreSQLServer
Go

-- CheckCompatibility PROCEDURE ----------------------------------------

CREATE PROCEDURE dbo.CheckCompatibility
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

    SELECT TOP 1 @sql = N'SELECT @is_compatible = CASE WHEN ' + compatibility_criteria + ' THEN 1 ELSE 0 END
                          FROM dbo.' + product_category_1 + 'Details d1
                          JOIN dbo.' + product_category_2 + 'Details d2
                          ON d1.product_id = @product_id_1 AND d2.product_id = @product_id_2'
    FROM dbo.CompatibilityRules
    WHERE product_category_1 = @category_1 AND product_category_2 = @category_2;

    IF @sql IS NOT NULL
    BEGIN
        EXEC sp_executesql @sql, @params, @product_id_1, @product_id_2, @is_compatible OUTPUT;
    END
END;
GO
