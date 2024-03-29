interface ZIF_BTOCS_SEC_MET
  public .


  interfaces ZIF_BTOCS_UTIL_BASE .

  aliases DESTROY
    for ZIF_BTOCS_UTIL_BASE~DESTROY .
  aliases GET_LOGGER
    for ZIF_BTOCS_UTIL_BASE~GET_LOGGER .
  aliases IS_LOGGER_EXTERNAL
    for ZIF_BTOCS_UTIL_BASE~IS_LOGGER_EXTERNAL .
  aliases SET_LOGGER
    for ZIF_BTOCS_UTIL_BASE~SET_LOGGER .

  methods SET_CONTEXT
    importing
      !IV_METHOD type DATA
      !IV_PARAM type DATA
      !IR_PARENT type ref to ZIF_BTOCS_UTIL_BASE
      !IR_MGR type ref to ZIF_BTOCS_SEC_MGR optional
      !IS_CONFIG type ZBTOCS_CFG_S_RFC_REC .
  methods GET_MANAGER
    returning
      value(RO_MGR) type ref to ZIF_BTOCS_SEC_MGR .
  methods GET_PARENT
    returning
      value(RO_PARENT) type ref to ZIF_BTOCS_UTIL_BASE .
endinterface.
