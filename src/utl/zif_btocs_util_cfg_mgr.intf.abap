interface ZIF_BTOCS_UTIL_CFG_MGR
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

  methods READ_RWS_CONFIG_PROFILE
    importing
      !IV_PROFILE type ZBTOCS_RWS_PROFILE
    returning
      value(RS_CONFIG) type ZBTOCS_CFG_S_PRF_REC .
  methods READ_RWS_CONFIG_RFCDEST
    importing
      !IV_RFCDEST type RFCDEST
      !IV_READ_PROFILE type ABAP_BOOL default ABAP_TRUE
    returning
      value(RS_CONFIG) type ZBTOCS_CFG_S_RFC_REC .
endinterface.
