interface ZIF_BTOCS_VALUE_MGR
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

  methods SET_OPTIONS
    importing
      !IS_OPTION type ZBTOCS_TYP_S_VALUE_OPTIONS .
  methods GET_OPTIONS
    returning
      value(RS_OPTION) type ZBTOCS_TYP_S_VALUE_OPTIONS .
  methods NEW_JSON_OBJECT
    importing
      !IS_OPTIONS type ZBTOCS_TYP_S_VALUE_OPTIONS optional
    returning
      value(RO_VALUE) type ref to ZIF_BTOCS_VALUE_STRUCTURE .
  methods NEW_JSON_ARRAY
    importing
      !IS_OPTIONS type ZBTOCS_TYP_S_VALUE_OPTIONS optional
      !IV_RAW_VALUE type STRING optional
    returning
      value(RO_VALUE) type ref to ZIF_BTOCS_VALUE_ARRAY .
  methods NEW_STRING
    importing
      !IV_STRING type STRING optional
    returning
      value(RO_VALUE) type ref to ZIF_BTOCS_VALUE_STRING .
  methods NEW_NUMBER
    importing
      !IV_NUMBER type DATA optional
    returning
      value(RO_VALUE) type ref to ZIF_BTOCS_VALUE_NUMBER .
  methods NEW_BOOLEAN
    importing
      !IV_BOOLEAN type DATA optional
    returning
      value(RO_VALUE) type ref to ZIF_BTOCS_VALUE_BOOLEAN .
  methods NEW_NULL
    returning
      value(RO_VALUE) type ref to ZIF_BTOCS_VALUE .
  methods GET_DEFAULT_JSON_OPTIONS
    returning
      value(RS_OPTION) type ZBTOCS_TYP_S_VALUE_OPTIONS .
endinterface.
