interface ZIF_BTOCS_UTIL_CONVERT
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

* convert string types
  methods CONVERT_XSTRING_TO_STRING
    importing
      !IV_XSTRING type XSTRING
      !IV_ENCODING type ABAP_ENCODING optional
    returning
      value(RV_STRING) type STRING .
  methods CONVERT_XSTRING_TO_BASE64
    importing
      !IV_BINARY type XSTRING
      !IV_FILENAME type STRING optional
      !IV_MIMETYPE type STRING optional
    returning
      value(RV_BASE64) type STRING .
  methods CONVERT_STRING_TO_XSTRING
    importing
      !IV_STRING type STRING
      !IV_ENCODING type ABAP_ENCODING optional
    returning
      value(RV_XSTRING) type XSTRING .
  methods CONVERT_BINTAB_TO_XSTRING
    importing
      !IT_BIN type TABLE
      !IV_LEN type I
    returning
      value(RV_XSTRING) type XSTRING .
  methods CONVERT_XSTRING_TO_BINTAB
    importing
      !IV_XSTRING type XSTRING
    exporting
      !EV_LEN type I
    changing
      !CT_BINTAB type TABLE optional
    returning
      value(RT_BINTAB) type SOLIX_TAB .
  methods CONVERT_STRING_TO_TXTTAB
    importing
      !IV_STRING type STRING
    exporting
      !EV_LEN type I
    returning
      value(RT_TXTTAB) type SOLI_TAB .
  methods CONVERT_TXTTAB_TO_STRING
    importing
      !IT_TXTTAB type TABLE
      !IV_LEN type I
    returning
      value(RV_STRING) type STRING .
* ============ BASE64
  methods DECODE_BASE64_TO_XSTRING
    importing
      !IV_BASE64 type STRING
    returning
      value(RV_XSTRING) type XSTRING .
  methods DECODE_BASE64_TO_STRING
    importing
      !IV_BASE64 type STRING
      !IV_ENCODING type ABAP_ENCODING default 'UTF-8'
    returning
      value(RV_STRING) type STRING .
  methods ENCODE_STRING_TO_BASE64
    importing
      !IV_ENCODING type ABAP_ENCODING default 'UTF-8'
      !IV_STRING type STRING
    returning
      value(RV_BASE64) type STRING .
  methods ENCODE_XSTRING_TO_BASE64
    importing
      !IV_XSTRING type XSTRING
    returning
      value(RV_BASE64) type STRING .
endinterface.
