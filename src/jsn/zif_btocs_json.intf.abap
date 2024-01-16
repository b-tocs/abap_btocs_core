interface ZIF_BTOCS_JSON
  public .


  data DATA_TYPE type ZBTOCS_JSON_TYPE .

  methods GET_DATA_TYPE
    returning
      value(RV_TYPE) type /CEX/JMP_JSON_DATA_TYPE .
  methods TO_STRING
    importing
      !IV_ENCLOSING type ABAP_BOOL default ABAP_TRUE
    returning
      value(RV_STRING) type STRING .
  methods IS_NULL
    returning
      value(RV_NULL) type ABAP_BOOL .
  methods GET_DATA
    returning
      value(LR_DATA) type ref to DATA .
endinterface.
