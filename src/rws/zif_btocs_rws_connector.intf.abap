interface ZIF_BTOCS_RWS_CONNECTOR
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

  methods SET_ENDPOINT
    importing
      !IV_RFC type RFCDEST
      !IV_PROFILE type ZBTOCS_RWS_PROFILE optional
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods IS_INITIALIZED
    returning
      value(RV_INITIALIZED) type ABAP_BOOL .
  methods GET_CLIENT
    importing
      !IV_DUPLICATE type ABAP_BOOL default ABAP_FALSE
      !IV_CHECK_INITIALIZED type ABAP_BOOL default ABAP_TRUE
    returning
      value(RO_CLIENT) type ref to ZIF_BTOCS_RWS_CLIENT .
  methods NEW_REQUEST
    returning
      value(RO_REQUEST) type ref to ZIF_BTOCS_RWS_REQUEST .
  methods NEW_RESPONSE
    returning
      value(RO_RESPONSE) type ref to ZIF_BTOCS_RWS_RESPONSE .
  methods EXECUTE
    importing
      !IV_API_PATH type DATA optional
      !IO_CLIENT type ref to ZIF_BTOCS_RWS_CLIENT optional
      !IO_RESPONSE type ref to ZIF_BTOCS_RWS_RESPONSE optional
      !IV_METHOD type DATA default 'POST'
    returning
      value(RO_RESPONSE) type ref to ZIF_BTOCS_RWS_RESPONSE .
endinterface.
