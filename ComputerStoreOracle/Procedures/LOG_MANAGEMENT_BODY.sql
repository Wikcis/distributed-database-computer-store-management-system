create or replace PACKAGE BODY LOG_MANAGEMENT AS

  PROCEDURE ADD_LOG(
    p_log_message IN VARCHAR2
  ) IS
    v_id NUMBER;
  BEGIN
    SELECT NVL(MAX(log_id), 0) + 1 
    INTO v_id 
    FROM LOGS;

    INSERT INTO LOGS
    VALUES (v_id, p_log_message);
  END ADD_LOG;

END LOG_MANAGEMENT;