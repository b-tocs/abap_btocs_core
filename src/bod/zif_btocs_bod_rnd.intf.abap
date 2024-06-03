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

  types TY_DETAIL_LEVEL type I .

  constants:
    BEGIN OF c_detail_level,
      default     TYPE ty_detail_level VALUE 0,
      abstract    TYPE ty_detail_level VALUE 1,
      small       TYPE ty_detail_level VALUE 2,
      medium      TYPE ty_detail_level VALUE 3,
      large       TYPE ty_detail_level VALUE 4,
      extra_large TYPE ty_detail_level VALUE 5,
    END OF c_detail_level .

  methods SET_CONTEXT
    importing
      !IV_TYPE type DATA
      !IV_ID type DATA
      !IT_CONTEXT type ZBTOCS_T_KEY_VALUE
      !IV_LOAD_DATA type ABAP_BOOL default ABAP_TRUE
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods RENDER
    importing
      !IO_DOC type ref to ZIF_BTOCS_BOD_DOC optional
      !IV_NO_TITLE type ABAP_BOOL default ABAP_FALSE
      !IV_DETAIL_LEVEL type ZBTOCS_BOD_DETAIL_LEVEL default C_DETAIL_LEVEL-DEFAULT
      !IV_HEADER_LEVEL type I default 0
      !IV_TABLE_STYLE type STRING optional
      !IV_STRUCTURE_STYLE type STRING optional
    returning
      value(RO_DOC) type ref to ZIF_BTOCS_BOD_DOC .
  methods GET_DDIC_UTIL
    returning
      value(RO_UTIL) type ref to ZIF_BTOCS_UTIL_DDIC .
  methods GET_MARKDOWN_UTIL
    returning
      value(RO_UTIL) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods GET_ID
    returning
      value(RV_ID) type STRING .
  methods GET_TITLE
    importing
      !IV_WITH_MEANING type ABAP_BOOL default ABAP_TRUE
    returning
      value(RV_TITLE) type STRING .
  methods GET_MEANING
    returning
      value(RV_MEANING) type STRING .
  methods GET_ABSTRACT
    returning
      value(RT_TEXT) type STRING_TABLE .
  methods GET_TYPE
    returning
      value(RV_TYPE) type STRING .
  methods GET_CONTEXT
    returning
      value(RT_CONTEXT) type ZBTOCS_T_KEY_VALUE .
  methods LOAD_DATA
    importing
      !IV_DETAIL_LEVEL type ZBTOCS_BOD_DETAIL_LEVEL optional
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods IS_DATA_LOADED
    returning
      value(RV_LOADED) type ABAP_BOOL .
endinterface.
