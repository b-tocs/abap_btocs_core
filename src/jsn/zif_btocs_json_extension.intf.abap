interface ZIF_BTOCS_JSON_EXTENSION
  public .

  methods MAP_EXTERNAL_TIMEZONE
    importing
      !IV_TIMEZONE_EXT type STRING
    changing
      !CV_TIMEZONE_INT type TIMEZONE .
  methods UNESCAPE_EXTERNAL_STRING
    changing
      !CV_STRING type STRING .

endinterface.
