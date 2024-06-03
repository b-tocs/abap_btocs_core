interface ZIF_BTOCS_BOD_MGR
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

  methods NEW_DOCUMENT
    importing
      !IV_IMPL type DATA optional
    returning
      value(RO_DOC) type ref to ZIF_BTOCS_BOD_DOC .
  methods GET_RENDERER
    importing
      !IV_TYPE type DATA
      !IV_ID type DATA
      !IT_CONTEXT type ZBTOCS_T_KEY_VALUE optional
    returning
      value(RO_RENDERER) type ref to ZIF_BTOCS_BOD_RND .
endinterface.
