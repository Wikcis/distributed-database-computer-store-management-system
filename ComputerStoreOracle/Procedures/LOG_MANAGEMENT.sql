create or replace PACKAGE LOG_MANAGEMENT AS 

  PROCEDURE ADD_LOG(
    p_log_message IN VARCHAR2
  );

END LOG_MANAGEMENT;