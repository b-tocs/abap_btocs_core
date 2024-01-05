interface ZIF_BTOCS_UTIL_BASE
  public .


  methods GET_LOGGER
    returning
      value(RO_LOGGER) type ref to ZIF_BTOCS_UTIL_LOGGER .
  methods SET_LOGGER
    importing
      !IO_LOGGER type ref to ZIF_BTOCS_UTIL_LOGGER .
  methods IS_LOGGER_EXTERNAL
    returning
      value(RV_EXTERNAL) type ABAP_BOOL .
  methods DESTROY .
endinterface.
