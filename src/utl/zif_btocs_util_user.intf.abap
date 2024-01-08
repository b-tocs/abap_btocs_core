interface ZIF_BTOCS_UTIL_USER
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

  methods GET_USER_DETAIL
    importing
      !IV_USERNAME type SYUNAME
      !IV_VALID_AT type SYDATUM default SY-DATUM
      !IV_ROLE_PREFIX type STRING optional
      !IV_PARAM_PREFIX type STRING optional
      !IV_CACHE type ABAP_BOOL default ABAP_TRUE
    exporting
      !ET_ROLES type SUID_TT_BAPIAGR
      !ES_ADDRESS type BAPIADDR3
      !ET_PARAMS type SUID_TT_BAPIPARAM
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
endinterface.
