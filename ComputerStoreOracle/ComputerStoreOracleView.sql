-- SimilarAvailableComponents -----------------

CREATE OR REPLACE VIEW SimilarAvailableComponents AS
SELECT 
    p1.product_id AS unavailable_product_id,
    p1.product_name AS unavailable_product_name,
    p2.product_id AS similar_product_id,
    p2.product_name AS similar_product_name,
    p2.quantity,
    p2.price
FROM 
    PRODUCTS p1
JOIN 
    PRODUCTS p2 ON p1.product_id <> p2.product_id
WHERE 
    p1.category = p2.category;
/

SELECT * FROM SimilarAvailableComponents;
/




