interface ZIF_BTOCS_VALUE_ARRAY
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
  aliases IS_DATA
    for ZIF_BTOCS_VALUE~IS_DATA .
  aliases IS_LOGGER_EXTERNAL
    for ZIF_BTOCS_VALUE~IS_LOGGER_EXTERNAL .
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
  aliases SET_STRING
    for ZIF_BTOCS_VALUE~SET_STRING .

  methods CLEAR .
  methods COUNT
    returning
      value(RV_COUNT) type I .
  methods ADD
    importing
      !IO_VALUE type ref to ZIF_BTOCS_VALUE
      !IV_REF_ID type STRING optional
    returning
      value(RV_COUNT) type I .
  methods GET
    importing
      !IV_INDEX type I
    exporting
      !EV_REF_ID type STRING
    returning
      value(RO_VALUE) type ref to ZIF_BTOCS_VALUE .
endinterface.
