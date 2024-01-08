interface ZIF_BTOCS_SEC_MGR
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

  constants C_CUSTOM_CLASS type STRING value 'CUST_CLASS' ##NO_TEXT.
  constants:
    BEGIN OF c_jwt,
               issuer  TYPE string VALUE 'iss',
               subject TYPE string VALUE 'sub',
               name    TYPE string VALUE 'name',
             END OF c_jwt .

  methods CREATE_AUTH_METHOD
    importing
      !IV_METHOD type ZBTOCS_OPTION_AUTH_METHOD
      !IV_PARAM type ZBTOCS_PARAMETER_AUTH_METHOD
      !IR_PARENT type ref to ZIF_BTOCS_UTIL_BASE optional
      !IS_CONFIG type ZBTOCS_CFG_S_RFC_REC optional
    returning
      value(RO_INSTANCE) type ref to ZIF_BTOCS_SEC_A .
  methods CREATE_TOKEN_METHOD
    importing
      !IV_METHOD type ZBTOCS_OPTION_AUTH_METHOD
      !IV_PARAM type ZBTOCS_PARAMETER_AUTH_METHOD
      !IR_PARENT type ref to ZIF_BTOCS_UTIL_BASE optional
      !IS_CONFIG type ZBTOCS_CFG_S_RFC_REC optional
    returning
      value(RO_INSTANCE) type ref to ZIF_BTOCS_SEC_T .
  methods CREATE_SECRET_METHOD
    importing
      !IV_METHOD type ZBTOCS_OPTION_AUTH_METHOD
      !IV_PARAM type ZBTOCS_PARAMETER_AUTH_METHOD
      !IR_PARENT type ref to ZIF_BTOCS_UTIL_BASE optional
      !IS_CONFIG type ZBTOCS_CFG_S_RFC_REC optional
    returning
      value(RO_INSTANCE) type ref to ZIF_BTOCS_SEC_S .
  methods GENERATE_JWT_TOKEN_TRUSTED
    importing
      !IV_USER type UNAME default SY-UNAME
      !IV_SECRET type STRING
      !IV_ROLES_PREFIX type ZBTOCS_ROLES_PREFIX optional
    returning
      value(RV_JWT) type STRING .
  methods GENERATE_JWT_TOKEN
    importing
      !IV_PAYLOAD type STRING optional
      !IV_SECRET type STRING
    returning
      value(RV_JWT) type STRING .
  methods GENERATE_JWT_TOKEN_HEADER
    returning
      value(RV_HEADER) type STRING .
  methods TO_BASE64
    importing
      !IV_IN type STRING
      !IV_ENCODING type ABAP_ENCODING default '4110'
    returning
      value(RV_B64) type STRING .
  methods TO_UTF8
    importing
      !IV_STRING type STRING
    returning
      value(RV_UTF8) type STRING .
  methods BASE64_CHECK_STRING
    importing
      !IV_IN type STRING
    returning
      value(RV_OUT) type STRING .
  methods SIGN_HMAC
    importing
      !IV_ALG type STRING default 'SHA256'
      !IV_SECRET type STRING
      !IV_DATA type STRING
    returning
      value(RV_SIGNATURE) type STRING .
endinterface.
