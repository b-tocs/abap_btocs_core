interface ZIF_BTOCS_RWS_REQUEST
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
    BEGIN OF c_form_encoding,
      none               TYPE i VALUE 0,                 " not set
      raw                TYPE i VALUE 1,                 " SAP form_encoding_raw
      urlencoded         TYPE i VALUE 2,           " SAP form_encoding_encoded
      multipart_formdata TYPE i VALUE 100, " added for multipart/form-data
    END OF c_form_encoding .

  methods SET_CLIENT
    importing
      !IO_HTTP_CLIENT type ref to IF_HTTP_CLIENT
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods SET_DATA
    importing
      !IV_CONTENT_TYPE type STRING optional
      !IV_CONTENT type STRING optional
      !IV_BINARY type XSTRING optional
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods SET_DATA_ENCODED
    importing
      !IV_CONTENT_TYPE type STRING default 'application/json'
      !IV_CONTENT type STRING
      !IV_CODEPAGE type ABAP_ENCODING default '4110'
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods CLEAR .
  methods SET_HEADER_FIELDS
    importing
      !IT_HEADER type TIHTTPNVP .
  methods ADD_HEADER_FIELD
    importing
      !IV_NAME type DATA
      !IV_VALUE type DATA
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods SET_HEADER_FIELD
    importing
      !IV_NAME type DATA
      !IV_VALUE type DATA
      !IV_OVERWRITE type ABAP_BOOL default ABAP_FALSE
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods GET_HEADER_FIELDS
    returning
      value(RT_HEADER) type TIHTTPNVP .
  methods ADD_QUERY_PARAM
    importing
      !IV_NAME type DATA
      value(IV_VALUE) type DATA
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods GET_QUERY_PARAMS
    returning
      value(RT_PARAMS) type TIHTTPNVP .
  methods ADD_FORM_FIELD
    importing
      !IV_NAME type DATA
      !IV_VALUE type DATA
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods ADD_FORM_FIELD_FILE
    importing
      !IV_NAME type DATA
      !IV_BINARY type XSTRING
      !IV_FILENAME type STRING optional
      !IV_CONTENT_TYPE type STRING optional
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods SET_FORM_FIELD
    importing
      !IV_NAME type DATA
      !IV_VALUE type DATA optional
      !IV_OVERWRITE type ABAP_BOOL default ABAP_FALSE
      !IV_BINARY type XSTRING optional
      !IV_CONTENT_TYPE type STRING optional
      !IV_FILENAME type STRING optional
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods ADD_FORM_FIELDS
    importing
      !IT_FIELDS type TIHTTPNVP
      !IV_CONTENT_TYPE type STRING default 'application/x-www-form-urlencoded'
      !IV_FORM_FIELD_ENCODING type I default IF_HTTP_ENTITY=>CO_FORMFIELD_ENCODING_ENCODED
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods GET_FORM_FIELDS
    returning
      value(RT_FIELDS) type TIHTTPNVP .
  methods GET_FORM_FIELDS_WITH_BIN
    returning
      value(RT_FIELDS) type ZBTOCS_T_FORM_DATA .
  methods SET_FORM_TYPE
    importing
      !IV_CONTENT_TYPE type STRING default 'application/x-www-form-urlencoded'
      !IV_FORM_FIELD_ENCODING type I default IF_HTTP_ENTITY=>CO_FORMFIELD_ENCODING_ENCODED .
  methods SET_FORM_TYPE_URLENCODED .
  methods SET_FORM_TYPE_MULTIPART .
endinterface.
