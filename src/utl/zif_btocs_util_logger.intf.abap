interface ZIF_BTOCS_UTIL_LOGGER
  public .


  methods DESTROY .
  methods ADD
    importing
      !IV_TYPE type SYMSGTY
      !IV_ID type SYMSGID
      !IV_NO type SYMSGNO
      !IV_MSG type DATA
    returning
      value(RS_BAPIRET2) type BAPIRET2 .
  methods INFO
    importing
      !IV_MSG type DATA
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_LOGGER .
  methods WARNING
    importing
      !IV_MSG type DATA
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_LOGGER .
  methods DEBUG
    importing
      !IV_MSG type DATA
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_LOGGER .
  methods ABORT
    importing
      !IV_MSG type DATA
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_LOGGER .
  methods ERROR
    importing
      !IV_MSG type DATA
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_LOGGER .
  methods EXCEPTION
    importing
      !IV_MSG type DATA
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_LOGGER .
  methods ADD_MSG
    importing
      !IS_MSG type BAPIRET2 .
  methods GET_MESSAGES
    importing
      !IV_SNAPSHOT_ID type I optional
      !IV_NO_TRACE type ABAP_BOOL default ABAP_FALSE
      !IV_NO_FRAMEWORK type ABAP_BOOL default ABAP_FALSE
      !IV_ONLY_SNAPSHOT type ABAP_BOOL default ABAP_FALSE
    returning
      value(RT_MESSAGES) type BAPIRET2_TAB .
  methods HAS_ERRORS
    importing
      !IT_MSG type BAPIRET2_TAB optional
    returning
      value(RV_ERROR) type ABAP_BOOL .
  methods GET_SNAPSHOT
    returning
      value(RV_SNAPSHOT) type I .
  methods SET_SNAPSHOT
    returning
      value(RV_SNAPSHOT) type I .
  methods ADD_MSGS
    importing
      !IT_MSG type BAPIRET2_TAB .
endinterface.
