interface ZIF_BTOCS_EXIT_RENDER_HTML
  public .


  methods RENDER
    importing
      !IV_INPUT type STRING
      !IO_PARAMS type ref to ZIF_BTOCS_VALUE_STRUCTURE
      !IV_COMPLETE type ABAP_BOOL default ABAP_FALSE
    returning
      value(RV_HTML) type STRING .
endinterface.
