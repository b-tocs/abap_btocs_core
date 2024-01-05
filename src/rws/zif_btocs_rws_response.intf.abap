interface ZIF_BTOCS_RWS_RESPONSE
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

  methods GET_STATUS_CODE
    returning
      value(RV_STATUS) type I .
  methods GET_REASON
    returning
      value(RV_REASON) type STRING .
  methods GET_HEADER_FIELDS
    returning
      value(RT_HEADER) type TIHTTPNVP .
  methods GET_FORM_FIELDS
    returning
      value(RT_FORM_FIELDS) type TIHTTPNVP .
  methods GET_CONTENT_TYPE
    returning
      value(RV_CONTENT_TYPE) type STRING .
  methods GET_CONTENT
    returning
      value(RV_CONTENT) type STRING .
  methods GET_BINARY
    returning
      value(RV_BINARY) type XSTRING .
  methods SET_REASON
    importing
      !IV_REASON type DATA .
  methods SET_FROM_CLIENT
    importing
      !IO_HTTP_CLIENT type ref to IF_HTTP_CLIENT
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods SET_FROM_RESPONSE
    importing
      !IO_HTTP_RESPONSE type ref to IF_HTTP_RESPONSE
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods IS_HTTP_REQUEST_SUCCESS
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods IS_BINARY
    returning
      value(RV_BINARY) type ABAP_BOOL .
  methods IS_JSON_RESPONSE
    returning
      value(RV_JSON) type ABAP_BOOL .
  methods IS_JSON_OBJECT
    returning
      value(RV_JSON_OBJECT) type ABAP_BOOL .
  methods IS_FORM_FIELDS
    returning
      value(RV_FORM_FIELDS) type ABAP_BOOL .
  methods IS_HEADER_FIELDS
    returning
      value(RV_HEADER_FIELDS) type ABAP_BOOL .
endinterface.
