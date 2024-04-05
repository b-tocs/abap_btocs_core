interface ZIF_BTOCS_UTIL_DDIC
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

  methods F4_CACHE_EXISTS
    importing
      !IV_TYPE type ZBTOCS_F4_TYPE default 'TABF'
      !IV_OBJECT type ZBTOCS_F4_OBJECT
      !IV_SUBOBJ type ZBTOCS_F4_SUBOBJECT optional
    returning
      value(RV_EXISTS) type ABAP_BOOL .
  methods F4_CACHE_DELETE_ALL
    importing
      !IV_TYPE type ZBTOCS_F4_TYPE optional
      !IV_OBJECT type ZBTOCS_F4_OBJECT optional
      !IV_SUBOBJ type ZBTOCS_F4_SUBOBJECT optional
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods F4_CACHE_DELETE
    importing
      !IV_TYPE type ZBTOCS_F4_TYPE default 'TABF'
      !IV_OBJECT type ZBTOCS_F4_OBJECT
      !IV_SUBOBJ type ZBTOCS_F4_SUBOBJECT optional
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods F4_CACHE_SET
    importing
      !IV_TYPE type ZBTOCS_F4_TYPE default 'TABF'
      !IV_OBJECT type ZBTOCS_F4_OBJECT
      !IV_SUBOBJ type ZBTOCS_F4_SUBOBJECT optional
      !IT_F4 type ZBTOCS_T_F4
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods F4_CACHE_GET
    importing
      !IV_TYPE type ZBTOCS_F4_TYPE default 'TABF'
      !IV_OBJECT type ZBTOCS_F4_OBJECT
      !IV_SUBOBJ type ZBTOCS_F4_SUBOBJECT optional
    returning
      value(RT_F4) type ZBTOCS_T_F4 .
  methods F4_TABLE_FIELD_GET_TAB
    importing
      !IV_TABLE type DATA
      !IV_FIELD type DATA
      !IV_NO_CACHE type ABAP_BOOL default ABAP_FALSE
    returning
      value(RT_F4) type ZBTOCS_T_F4 .
  methods F4_TABLE_FIELD_GET_TEXT
    importing
      !IV_TABLE type DATA
      !IV_FIELD type DATA
      !IV_CODE type DATA
      !IV_LANG type SYLANGU default SY-LANGU
      !IV_LANG2 type SYLANGU optional
      !IV_TRY_OTHERS type ABAP_BOOL default ABAP_TRUE
      !IV_NO_CACHE type ABAP_BOOL default ABAP_FALSE
      !IV_DEFAULT type STRING optional
    exporting
      !EV_LANGUAGE type ZBTOCS_F4_LANG
      !ET_F4 type ZBTOCS_T_F4
    returning
      value(RV_TEXT) type STRING .
  methods F4_GET_BEST_TEXT
    importing
      !IT_F4 type ZBTOCS_T_F4
      !IV_CODE type DATA
      !IV_LANG type SYLANGU default SY-LANGU
      !IV_LANG2 type SYLANGU optional
      !IV_TRY_OTHERS type ABAP_BOOL default ABAP_TRUE
      !IV_DEFAULT type STRING optional
    exporting
      !EV_LANGUAGE type ZBTOCS_F4_LANG
      !ET_F4 type ZBTOCS_T_F4
    returning
      value(RV_TEXT) type STRING .
  methods LANG_GET_DEFAULT
    returning
      value(RV_LANG) type SYLANGU .
  methods LANG_SET_DEFAULT
    importing
      !IV_LANG type SYLANGU .
  methods LANG_SAP_TO_ISO
    importing
      !IV_SAP type SYLANGU
    returning
      value(RV_ISO) type LAISO .
  methods LANG_ISO_TO_SAP
    importing
      !IV_ISO type LAISO
    returning
      value(RV_SAP) type SYLANGU .
  methods GET_UTIL_STRUCTURE
    importing
      !IV_SINGLETON type ABAP_BOOL default ABAP_FALSE
    returning
      value(RO_UTIL) type ref to ZIF_BTOCS_UTIL_STRUCTURE .
  methods GET_UTIL_TABLE
    importing
      !IV_SINGLETON type ABAP_BOOL default ABAP_FALSE
    returning
      value(RO_UTIL) type ref to ZIF_BTOCS_UTIL_TABLE .
endinterface.
