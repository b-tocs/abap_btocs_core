interface ZIF_BTOCS_UTIL_STRUCTURE
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
  methods SET_NAME
    importing
      !IV_NAME type STRING
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods SET_DATA
    importing
      !IS_DATA type DATA
      !IV_COMPLEX_MODE type ABAP_BOOL default ABAP_FALSE
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods GET_STRUCTDESCR
    returning
      value(RO_TYPE_DESCR) type ref to CL_ABAP_STRUCTDESCR .
  methods GET_DDIC
    returning
      value(RT_DDIC) type DDFIELDS .
  methods GET_FIELDNAMES
    returning
      value(RT_NAMES) type STRING_TABLE .
  methods GET_FIELDNAMES_NOT_EMPTY
    returning
      value(RT_NAMES) type STRING_TABLE .
  methods GET_DDIC_FIELDNAME
    importing
      !IV_FIELDNAME type STRING
    returning
      value(RS_DDIC) type DFIES .
  methods GET_FIELD
    importing
      !IV_FIELDNAME type STRING
      !IV_NO_CACHE type ABAP_BOOL default ABAP_FALSE
    returning
      value(RO_UTIL) type ref to ZIF_BTOCS_UTIL_FIELD .
  methods GET_LABEL
    importing
      !IV_FIELDNAME type STRING
    returning
      value(RV_LABEL) type STRING .
  methods GET_VALUE
    importing
      !IV_FIELDNAME type STRING
    returning
      value(RV_VALUE) type STRING .
  methods SET_VALUE
    importing
      !IV_FIELDNAME type STRING
      !IV_VALUE type DATA
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods IS_FIELDNAME
    importing
      !IV_FIELDNAME type STRING
    returning
      value(RV_EXISTS) type ABAP_BOOL .
  methods IS_EMPTY
    importing
      !IV_FIELDNAME type STRING
    returning
      value(RV_EMPTY) type ABAP_BOOL .
  methods SET_STRUCTURE_DATA
    importing
      !IS_DATA type DATA
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods SET_DDIC_UTIL
    importing
      !IO_UTIL type ref to ZIF_BTOCS_UTIL_DDIC .
  methods GET_DDIC_UTIL
    returning
      value(RO_UTIL) type ref to ZIF_BTOCS_UTIL_DDIC .
endinterface.
