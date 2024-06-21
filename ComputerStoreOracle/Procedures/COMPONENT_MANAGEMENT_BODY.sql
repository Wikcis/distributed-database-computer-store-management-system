create or replace PACKAGE BODY COMPONENT_MANAGEMENT AS

  PROCEDURE ADD_COMPONENT_TO_STORE(
    p_product_name IN VARCHAR2,
    p_category IN VARCHAR2,
    p_quantity IN NUMBER,
    p_price IN NUMBER
  ) AS
      v_count NUMBER; 
      v_id NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM PRODUCTS
        WHERE product_name = p_product_name AND category = p_category;
    
        SELECT NVL(MAX(product_id), 0) + 1 
        INTO v_id 
        FROM PRODUCTS;
    
        IF v_count = 0 THEN
            INSERT INTO Products
            VALUES (v_id, p_product_name, p_category, p_quantity, p_price);
        ELSE
            UPDATE Products
            SET quantity = quantity + p_quantity
            WHERE product_name = p_product_name AND category = p_category;
        END IF;
    END ADD_COMPONENT_TO_STORE;
    
  PROCEDURE TRANSFER_AVAILABILITY(
    p_product_id IN NUMBER,
    p_quantity IN NUMBER,
    p_quantityToTransfer OUT NUMBER
  ) IS
    v_quantity NUMBER;
  BEGIN
    
    SELECT quantity INTO v_quantity FROM PRODUCTS WHERE product_id = p_product_id;
    
    p_quantityToTransfer := ROUND(v_quantity * 0.2);
    
    IF p_quantity <= p_quantityToTransfer THEN
        UPDATE PRODUCTS 
        SET quantity = v_quantity - p_quantityToTransfer
        WHERE product_id = p_product_id;
    ELSE
        p_quantityToTransfer := 0;
    END IF;
    
    
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        v_quantity := 0;
    
    
  END TRANSFER_AVAILABILITY;
  
  
  
  PROCEDURE CHECK_RAM_COMPATIBILITY(
    p_product_id_1 IN NUMBER,
    p_product_id_2 IN NUMBER,
    p_is_compatible OUT NUMBER
  ) IS
    ram_memory_type VARCHAR2(10);
    motherboard_memory_type VARCHAR2(10);
    BEGIN
        SELECT memory_type INTO motherboard_memory_type FROM MOTHERBOARD_DETAILS WHERE PRODUCT_ID = p_product_id_1;
        SELECT memory_type INTO ram_memory_type FROM RAM_DETAILS WHERE PRODUCT_ID = p_product_id_2;
        
        IF motherboard_memory_type = ram_memory_type THEN
            p_is_compatible := 1;
        ELSE 
            p_is_compatible := 0;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_is_compatible := 0;
    END CHECK_RAM_COMPATIBILITY;
    
  PROCEDURE CHECK_PROCESSOR_COMPATIBILITY(
    p_product_id_1 IN NUMBER,
    p_product_id_2 IN NUMBER,
    p_is_compatible OUT NUMBER
  ) IS
    processor_socket VARCHAR2(10);
    motherboard_socket VARCHAR2(10);
    BEGIN
        SELECT socket INTO motherboard_socket FROM MOTHERBOARD_DETAILS WHERE product_id = p_product_id_1;
        SELECT socket INTO processor_socket FROM PROCESSOR_DETAILS WHERE product_id = p_product_id_2;
        
        IF motherboard_socket = processor_socket THEN
            p_is_compatible := 1;
        ELSE 
            p_is_compatible := 0;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           p_is_compatible := 0;
    END CHECK_PROCESSOR_COMPATIBILITY;
    
  PROCEDURE CHECK_GRAPHICS_COMPATIBILITY(
    p_product_id_1 IN NUMBER,
    p_product_id_2 IN NUMBER,
    p_is_compatible OUT NUMBER
  ) IS
    graphics_interface VARCHAR2(10);
    motherboard_interface VARCHAR2(10);
    BEGIN
        SELECT interface INTO motherboard_interface FROM MOTHERBOARD_DETAILS WHERE product_id = p_product_id_1;
        SELECT interface INTO graphics_interface FROM GRAPHICS_DETAILS WHERE product_id = p_product_id_2;
        
        IF motherboard_interface = graphics_interface THEN
            p_is_compatible := 1;
        ELSE 
            p_is_compatible := 0;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           p_is_compatible := 0;
    END CHECK_GRAPHICS_COMPATIBILITY; 
    
  PROCEDURE CHECK_COMPATIBILITY(
    p_product_id_1 IN NUMBER,
    p_product_id_2 IN NUMBER,
    p_is_compatible OUT NUMBER
  ) IS
        v_category_1 VARCHAR2(50);
        v_category_2 VARCHAR2(50);
    BEGIN
    
        SELECT category INTO v_category_1 FROM PRODUCTS WHERE product_id = p_product_id_1;
        SELECT category INTO v_category_2 FROM PRODUCTS WHERE product_id = p_product_id_2;
    
        IF v_category_1 <> v_category_2 AND v_category_1 = 'Motherboard' THEN
            CASE v_category_2
                WHEN 'RAM' THEN
                    CHECK_RAM_COMPATIBILITY(p_product_id_1, p_product_id_2, p_is_compatible);
                WHEN 'Processor' THEN
                    CHECK_PROCESSOR_COMPATIBILITY(p_product_id_1, p_product_id_2, p_is_compatible);
                WHEN 'Graphics' THEN
                    CHECK_GRAPHICS_COMPATIBILITY(p_product_id_1, p_product_id_2, p_is_compatible);
            END CASE;
        ELSE 
            IF v_category_1 <> v_category_2 AND v_category_2 = 'Motherboard' THEN
                CASE v_category_1
                    WHEN 'RAM' THEN
                        CHECK_RAM_COMPATIBILITY(p_product_id_2, p_product_id_1, p_is_compatible);
                    WHEN 'Processor' THEN
                        CHECK_PROCESSOR_COMPATIBILITY(p_product_id_2, p_product_id_1, p_is_compatible);
                    WHEN 'Graphics' THEN
                        CHECK_GRAPHICS_COMPATIBILITY(p_product_id_2, p_product_id_1, p_is_compatible);
                END CASE;
            ELSE 
                p_is_compatible := 1;
            END IF;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_is_compatible := 2;
    END CHECK_COMPATIBILITY;


END COMPONENT_MANAGEMENT;