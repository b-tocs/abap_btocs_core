interface ZIF_BTOCS_SEC_A
  public .


  interfaces ZIF_BTOCS_SEC_MET .
  interfaces ZIF_BTOCS_UTIL_BASE .

  aliases DESTROY
    for ZIF_BTOCS_UTIL_BASE~DESTROY .
  aliases GET_LOGGER
    for ZIF_BTOCS_UTIL_BASE~GET_LOGGER .
  aliases GET_MANAGER
    for ZIF_BTOCS_SEC_MET~GET_MANAGER .
  aliases GET_PARENT
    for ZIF_BTOCS_SEC_MET~GET_PARENT .
  aliases IS_LOGGER_EXTERNAL
    for ZIF_BTOCS_UTIL_BASE~IS_LOGGER_EXTERNAL .
  aliases SET_CONTEXT
    for ZIF_BTOCS_SEC_MET~SET_CONTEXT .
  aliases SET_LOGGER
    for ZIF_BTOCS_UTIL_BASE~SET_LOGGER .

  methods PREPARE_AUTH
    importing
      !IR_CLIENT type ref to ZIF_BTOCS_RWS_CLIENT
      !IV_SECRET type STRING
      !IV_SECRET_BIN type XSTRING
    exporting
      !EV_TOKEN type STRING
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
endinterface.
