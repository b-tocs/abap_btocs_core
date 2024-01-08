interface ZIF_BTOCS_SEC_T
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

  methods SET_TOKEN_TO_REQUEST
    importing
      !IV_TOKEN type STRING
      !IR_REQUEST type ref to ZIF_BTOCS_RWS_REQUEST
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
endinterface.
