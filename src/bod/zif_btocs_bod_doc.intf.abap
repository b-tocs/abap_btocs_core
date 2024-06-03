interface ZIF_BTOCS_BOD_DOC
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

  methods SET_DATA
    importing
      !IS_DATA type ZBTOCS_BOD_S_DOC_DATA .
  methods GET_DATA
    returning
      value(RS_DATA) type ZBTOCS_BOD_S_DOC_DATA .
  methods SET_CONTENT
    importing
      !IV_CONTENT type STRING
      !IV_CONTENT_TYPE type STRING optional
      !IV_CHUNK type STRING optional
      !IV_PAGE type STRING optional
      !IV_OFFSET type STRING optional .
  methods GET_CONTENT
    returning
      value(RV_CONTENT) type STRING .
  methods GET_CONTENT_SIZE
    returning
      value(RV_SIZE) type I .
endinterface.
