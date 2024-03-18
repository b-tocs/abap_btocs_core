interface ZIF_BTOCS_VALUE
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

  constants:
    BEGIN OF c_format,
               json TYPE string VALUE 'json',
             END OF c_format .

  methods SET_MANAGER
    importing
      !IO_MGR type ref to ZIF_BTOCS_VALUE_MGR .
  methods GET_MANAGER
    returning
      value(RO_MGR) type ref to ZIF_BTOCS_VALUE_MGR .
  methods SET_OPTIONS
    importing
      !IS_OPTION type ZBTOCS_TYP_S_VALUE_OPTIONS .
  methods GET_OPTIONS
    returning
      value(RS_OPTION) type ZBTOCS_TYP_S_VALUE_OPTIONS .
  methods IS_OPTIONS
    returning
      value(RV_AVAILABLE) type ABAP_BOOL .
  methods SET_DATA_REF
    importing
      !IR_DATA_REF type ref to DATA .
  methods GET_DATA_REF
    returning
      value(RR_DATA_REF) type ref to DATA .
  methods IS_DATA
    returning
      value(RV_DATA) type ABAP_BOOL .
  methods SET_OBJECT_REF
    importing
      !IO_OBJECT_REF type ref to OBJECT .
  methods GET_OBJECT_REF
    returning
      value(RO_OBJECT_REF) type ref to OBJECT .
  methods IS_OBJECT
    returning
      value(RV_OBJECT) type ABAP_BOOL .
  methods IS_NULL
    returning
      value(RV_NULL) type ABAP_BOOL .
  methods SET_STRING
    importing
      !IV_STRING type STRING .
  methods RENDER
    importing
      !IV_NAME type STRING optional
      !IV_FORMAT type STRING optional
      !IV_LEVEL type I optional
      !IV_ENCLOSED type ABAP_BOOL default ABAP_TRUE
    returning
      value(RV_STRING) type STRING .
  methods GET_ARRAY_VALUE
    returning
      value(RO_ARRAY) type ref to ZIF_BTOCS_VALUE_ARRAY .
  methods GET_STRUCTURE_VALUE
    returning
      value(RO_STRUCTURE) type ref to ZIF_BTOCS_VALUE_STRUCTURE .
  methods GET_STRING
    returning
      value(RV_STRING) type STRING .
  methods SET_RAW_VALUE
    importing
      !IV_RAW_VALUE type STRING .
endinterface.
