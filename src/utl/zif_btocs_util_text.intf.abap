interface ZIF_BTOCS_UTIL_TEXT
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

  methods DETECT_LINE_SEPARATOR
    importing
      !IV_TEXT type STRING
    returning
      value(RV_SEP) type STRING .
  methods REPLACE_TAB_WITH_ESC_T
    changing
      value(CV_TEXT) type STRING .
  methods REPLACE_EOL_WITH_ESC_N
    changing
      value(CV_TEXT) type STRING .
  methods REPLACE_EOL_WITH_HTML_BR
    changing
      value(CV_TEXT) type STRING .
endinterface.
