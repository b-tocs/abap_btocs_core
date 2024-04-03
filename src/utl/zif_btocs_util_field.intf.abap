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
  methods GET_VALUE_TEXT
    importing
      !IV_VALUE type DATA optional
    returning
      value(RV_TEXT) type STRING .
  methods IS_EMPTY
    importing
      !IV_FIELDNAME type STRING
    returning
      value(RV_EMPTY) type ABAP_BOOL .
  methods IS_DDIC
    returning
      value(RV_DDIC) type ABAP_BOOL .
endinterface.
