create or replace PACKAGE COMPONENT_MANAGEMENT AS 

  PROCEDURE ADD_COMPONENT_TO_STORE(
    p_product_name IN VARCHAR2,
    p_category IN VARCHAR2,
    p_quantity IN NUMBER,
    p_price IN NUMBER
  );
    
  PROCEDURE TRANSFER_AVAILABILITY(
    p_product_id IN NUMBER,
    p_quantity IN NUMBER,
    p_quantityToTransfer OUT NUMBER
  );
    
  PROCEDURE CHECK_COMPATIBILITY(
    p_product_id_1 IN NUMBER,
    p_product_id_2 IN NUMBER,
    p_is_compatible OUT NUMBER
  );

  PROCEDURE CHECK_RAM_COMPATIBILITY(
    p_product_id_1 IN NUMBER,
    p_product_id_2 IN NUMBER,
    p_is_compatible OUT NUMBER
  );
  
  PROCEDURE CHECK_PROCESSOR_COMPATIBILITY(
    p_product_id_1 IN NUMBER,
    p_product_id_2 IN NUMBER,
    p_is_compatible OUT NUMBER
  );
  
  PROCEDURE CHECK_GRAPHICS_COMPATIBILITY(
    p_product_id_1 IN NUMBER,
    p_product_id_2 IN NUMBER,
    p_is_compatible OUT NUMBER
  );

END COMPONENT_MANAGEMENT;