interface ZIF_BTOCS_VALUE_NUMBER
  public .


  interfaces ZIF_BTOCS_UTIL_BASE .
  interfaces ZIF_BTOCS_VALUE .

  aliases DESTROY
    for ZIF_BTOCS_VALUE~DESTROY .
  aliases GET_DATA_REF
    for ZIF_BTOCS_VALUE~GET_DATA_REF .
  aliases GET_LOGGER
    for ZIF_BTOCS_VALUE~GET_LOGGER .
  aliases GET_MANAGER
    for ZIF_BTOCS_VALUE~GET_MANAGER .
  aliases GET_OBJECT_REF
    for ZIF_BTOCS_VALUE~GET_OBJECT_REF .
  aliases GET_OPTIONS
    for ZIF_BTOCS_VALUE~GET_OPTIONS .
  aliases GET_STRING
    for ZIF_BTOCS_VALUE~GET_STRING .
  aliases IS_DATA
    for ZIF_BTOCS_VALUE~IS_DATA .
  aliases IS_LOGGER_EXTERNAL
    for ZIF_BTOCS_VALUE~IS_LOGGER_EXTERNAL .
  aliases IS_NULL
    for ZIF_BTOCS_VALUE~IS_NULL .
  aliases IS_OBJECT
    for ZIF_BTOCS_VALUE~IS_OBJECT .
  aliases IS_OPTIONS
    for ZIF_BTOCS_VALUE~IS_OPTIONS .
  aliases RENDER
    for ZIF_BTOCS_VALUE~RENDER .
  aliases SET_DATA_REF
    for ZIF_BTOCS_VALUE~SET_DATA_REF .
  aliases SET_LOGGER
    for ZIF_BTOCS_VALUE~SET_LOGGER .
  aliases SET_MANAGER
    for ZIF_BTOCS_VALUE~SET_MANAGER .
  aliases SET_OBJECT_REF
    for ZIF_BTOCS_VALUE~SET_OBJECT_REF .
  aliases SET_OPTIONS
    for ZIF_BTOCS_VALUE~SET_OPTIONS .
  aliases SET_RAW_VALUE
    for ZIF_BTOCS_VALUE~SET_RAW_VALUE .
  aliases SET_STRING
    for ZIF_BTOCS_VALUE~SET_STRING .

  methods SET_NUMBER
    importing
      !IV_NUMBER type DATA .
  methods GET_INTEGER
    returning
      value(RV_VALUE) type I .
  methods GET_FLOAT
    returning
      value(RV_VALUE) type F .
  methods GET_AS
    changing
      !CV_VALUE type DATA
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
endinterface.
