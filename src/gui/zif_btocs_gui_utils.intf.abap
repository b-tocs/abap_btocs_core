interface ZIF_BTOCS_GUI_UTILS
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

* =========== Files: Up/Download
  methods GUI_UPLOAD_STRING
    importing
      !IV_FILENAME type DATA
      !IV_ENCODING type ABAP_ENCODING optional
    exporting
      !EV_PATH type STRING
      !EV_FILENAME type STRING
      !EV_EXTENSION type STRING
      !EV_NAME type STRING
    returning
      value(RV_FILE) type STRING .
  methods GUI_UPLOAD_BIN
    importing
      !IV_FILENAME type DATA
      !IV_ENCODING type ABAP_ENCODING optional
    exporting
      !EV_PATH type STRING
      !EV_FILENAME type STRING
      !EV_EXTENSION type STRING
      !EV_NAME type STRING
    returning
      value(RV_FILE) type XSTRING .
  methods GUI_DOWNLOAD_BIN
    importing
      !IV_FILENAME type DATA
      !IV_FILE type XSTRING
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods GUI_DOWNLOAD_STRING
    importing
      !IV_FILENAME type DATA
      !IV_ENCODING type ABAP_ENCODING optional
      !IV_FILE type STRING
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
* ============== clipboard
  methods CLIPBOARD_IMPORT_STRING
    importing
      !IV_LINE_SEPARATOR type STRING default /BAB/IF_ATB_C=>C_DEFAULT_SEP_LINE
    returning
      value(RV_STRING) type STRING .
  methods CLIPBOARD_EXPORT_STRING
    importing
      !IV_LINE_SEPARATOR type STRING default /BAB/IF_ATB_C=>C_DEFAULT_SEP_LINE
      !IV_STRING type STRING
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
* ============== F4 Utils
  methods F4_GET_FILENAME_OPEN
    importing
      !IV_TITLE type DATA optional
      !IV_MASK type STRING optional
      !IV_ENCODING type ABAP_BOOL optional
      !IV_INITIAL_DIR type DATA optional
      !IV_DEF_FILENAME type DATA optional
      !IV_DEF_EXT type DATA optional
    changing
      !CV_FILENAME type DATA .
  methods F4_GET_FILENAME_SAVE
    importing
      !IV_TITLE type DATA optional
      !IV_MASK type STRING optional
      !IV_ENCODING type ABAP_BOOL optional
      !IV_INITIAL_DIR type DATA optional
      !IV_DEF_FILENAME type DATA optional
      !IV_DEF_EXT type DATA optional
      !IV_PROMPT_OVERWRITE type ABAP_BOOL default ABAP_TRUE
    changing
      !CV_FILENAME type DATA .
  methods F4_HELP_FROM_TABLE
    importing
      !IT_DATA type TABLE
      !IV_RETFIELD type DATA
      !IV_VALFIELD type DATA optional
      !IV_REPID type SYREPID
      !IV_DYNNR type SYDYNNR
      !IV_DYNFLD type DATA
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods GET_INPUT_WITH_CLIPBOARD
    importing
      !IV_CURRENT type DATA
      !IV_CLIPBOARD type ABAP_BOOL default ABAP_TRUE
      !IV_LONGTEXT type ABAP_BOOL default ABAP_TRUE
    returning
      value(RV_INPUT) type STRING .
  methods GET_UPLOAD
    importing
      !IV_FILENAME type DATA
    exporting
      !EV_FILENAME type STRING
      !EV_CONTENT_TYPE type STRING
      value(EV_BINARY) type XSTRING
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods GUI_EXECUTE_FILE_LOCALLY
    importing
      !IS_FILE_DATA type ZBTOCS_S_FILE_DATA
      !IV_WAIT_AND_DELETE type ABAP_BOOL default ABAP_TRUE
      !IV_WORKDIR type ABAP_BOOL default ABAP_FALSE
      !IV_MAXIMIZED type ABAP_BOOL default ABAP_FALSE
      !IV_WITH_TIMESTAMP type ABAP_BOOL default ABAP_TRUE
    exporting
      !EV_FILENAME type STRING
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
endinterface.
