interface ZIF_BTOCS_UTIL_TABLE
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
      !IT_DATA type TABLE
      !IV_STORE_DATA type ABAP_BOOL default ABAP_TRUE
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods SET_DATA_REF
    importing
      !IR_TABLE type ref to DATA
      !RV_SUCCESS type ABAP_BOOL .
  methods GET_DATA_REF
    returning
      value(RR_DATA) type ref to DATA .
  methods GET_TABLEDESCR
    returning
      value(RO_TYPE_DESCR) type ref to CL_ABAP_TABLEDESCR .
  methods GET_STRUCTURE_UTIL
    returning
      value(RO_UTIL) type ref to ZIF_BTOCS_UTIL_STRUCTURE .
  methods GET_PARSED_CONTENT
    returning
      value(RT_CONTENT) type ZBTOCS_T_TABLE_CONTENT .
  methods GET_PARSED_CONTENT_ROW
    importing
      !IV_ROW type I
    returning
      value(RT_CONTENT) type ZBTOCS_T_TABLE_CONTENT .
  methods GET_PARSED_METAINFO
    returning
      value(RT_METAINFO) type ZBTOCS_T_TABLE_METAINFO .
  methods GET_FIELDNAMES
    returning
      value(RT_NAMES) type STRING_TABLE .
  methods GET_FIELDNAMES_NOT_EMPTY
    returning
      value(RT_NAMES) type STRING_TABLE .
  methods PARSE
    importing
      !IV_NO_CONTENT type ABAP_BOOL default ABAP_FALSE
    returning
      value(RV_SUCCESS) type ABAP_BOOL .

  methods SET_DDIC_UTIL
    importing
      !IO_UTIL type ref to ZIF_BTOCS_UTIL_DDIC .
  methods GET_DDIC_UTIL
    returning
      value(RO_UTIL) type ref to ZIF_BTOCS_UTIL_DDIC .
endinterface.
