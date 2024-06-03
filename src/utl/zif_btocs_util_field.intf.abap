interface ZIF_BTOCS_UTIL_FIELD
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

  methods SET_DDIC_UTIL
    importing
      !IO_UTIL type ref to ZIF_BTOCS_UTIL_DDIC .
  methods GET_DDIC_UTIL
    returning
      value(RO_UTIL) type ref to ZIF_BTOCS_UTIL_DDIC .

  methods RESET .
  methods SET_DATA
    importing
      !IV_DATA type DATA
      !IS_DDIC type DFIES optional
      !IV_FIELDNAME type STRING optional
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods GET_DATADESCR
    returning
      value(RO_TYPE_DESCR) type ref to CL_ABAP_DATADESCR .
  methods GET_DDIC
    returning
      value(RS_DDIC) type DFIES .
  methods GET_LABEL
    returning
      value(RV_LABEL) type STRING .
  methods GET_VALUE
    returning
      value(RV_VALUE) type STRING .
  methods GET_UNIT
    importing
      !IS_DATA type DATA
    returning
      value(RV_UNIT) type STRING .
  methods GET_VALUE_TEXT
    importing
      !IV_VALUE type DATA optional
    returning
      value(RV_TEXT) type STRING .
  methods GET_USER_TEXT
    importing
      !IS_DATA type DATA
      !IV_LABEL type ABAP_BOOL default ABAP_FALSE
      !IV_LABEL_SEPARATOR type STRING default ':'
    returning
      value(RV_TEXT) type STRING .
  methods GET_INT_TYPE
    returning
      value(RV_TYPE) type INTTYPE .
  methods IS_EMPTY
    returning
      value(RV_EMPTY) type ABAP_BOOL .
  methods IS_DDIC
    returning
      value(RV_DDIC) type ABAP_BOOL .
  methods IS_TABLE
    returning
      value(RV_TABLE) type ABAP_BOOL .
  methods IS_STRUCTURE
    returning
      value(RV_STRUCTURE) type ABAP_BOOL .
  methods IS_NOT_PRINTABLE
    returning
      value(RV_NO_PRINT) type ABAP_BOOL .
endinterface.
