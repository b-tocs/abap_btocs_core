interface ZIF_BTOCS_BOD_RND
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
      !IV_TYPE type DATA
      !IV_ID type DATA
      !IT_CONTEXT type ZBTOCS_T_KEY_VALUE
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods RENDER
    importing
      !IO_DOC type ref to ZIF_BTOCS_BOD_DOC optional
    returning
      value(RO_DOC) type ref to ZIF_BTOCS_BOD_DOC .
  methods GET_ID
    returning
      value(RV_ID) type STRING .
  methods GET_TYPE
    returning
      value(RV_TYPE) type STRING .
  methods GET_CONTEXT
    returning
      value(RT_CONTEXT) type ZBTOCS_T_KEY_VALUE .
endinterface.
