interface ZIF_BTOCS_RWS_CLIENT
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

  methods SET_ENDPOINT_BY_RFC_DEST
    importing
      !IV_RFC type RFCDEST
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods SET_ENDPOINT_BY_URL
    importing
      !IV_URL type STRING
      !IV_PROFILE type ZBTOCS_RWS_PROFILE optional
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods SET_ENDPOINT_PATH
    importing
      !IV_PATH type STRING
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods POST
    importing
      !IV_CONTENT_TYPE type STRING optional
      !IV_CONTENT type STRING optional
      !IV_BINARY type XSTRING optional
      !IO_RESPONSE type ref to ZIF_BTOCS_RWS_RESPONSE optional
    returning
      value(RO_RESPONSE) type ref to ZIF_BTOCS_RWS_RESPONSE .
  methods EXECUTE_GET
    importing
      !IO_RESPONSE type ref to ZIF_BTOCS_RWS_RESPONSE optional
    returning
      value(RO_RESPONSE) type ref to ZIF_BTOCS_RWS_RESPONSE .
  methods EXECUTE
    importing
      !IV_METHOD type DATA default 'POST'
      !IO_RESPONSE type ref to ZIF_BTOCS_RWS_RESPONSE optional
    returning
      value(RO_RESPONSE) type ref to ZIF_BTOCS_RWS_RESPONSE .
  methods IS_CLIENT_INITIALIZED
    returning
      value(RV_INITIALIZED) type ABAP_BOOL .
  methods IS_CONFIG
    returning
      value(RV_CONFIG) type ABAP_BOOL .
  methods CLOSE .
  methods CLEAR .
  methods NEW_REQUEST
    returning
      value(RO_REQUEST) type ref to ZIF_BTOCS_RWS_REQUEST .
  methods GET_REQUEST
    returning
      value(RO_REQUEST) type ref to ZIF_BTOCS_RWS_REQUEST .
  methods SET_REQUEST
    importing
      !IO_REQUEST type ref to ZIF_BTOCS_RWS_REQUEST .
  methods SET_CONFIG
    importing
      !IS_CONFIG type ZBTOCS_CFG_S_RFC_REC .
  methods GET_CONFIG
    returning
      value(RS_CONFIG) type ZBTOCS_CFG_S_RFC_REC .
  methods GET_CONFIG_MANAGER
    returning
      value(RO_MGR) type ref to ZIF_BTOCS_UTIL_CFG_MGR .
  methods SET_CONFIG_BY_PROFILE
    importing
      !IV_PROFILE type ZBTOCS_RWS_PROFILE
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods SET_API_KEY
    importing
      !IV_KEY type STRING .
  methods GET_API_KEY
    returning
      value(RV_KEY) type STRING .
  methods GET_SECRET
    importing
      !IV_METHOD type DATA
      !IV_PARAM type DATA optional
      !IS_CONFIG type DATA
    exporting
      !EV_BINARY type XSTRING
      !EV_IS_BINARY type ABAP_BOOL
    returning
      value(RV_SECRET) type STRING .
endinterface.
