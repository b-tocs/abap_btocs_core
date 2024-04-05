interface ZIF_BTOCS_UTIL_MARKDOWN
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

  methods SET_DDIC_UTIL
    importing
      !IO_UTIL type ref to ZIF_BTOCS_UTIL_DDIC .
  methods GET_DDIC_UTIL
    returning
      value(RO_UTIL) type ref to ZIF_BTOCS_UTIL_DDIC .

  methods RESET .
  methods GET_LINES_COUNT
    returning
      value(RV_COUNT) type I .
  methods GET_LINES
    returning
      value(RT_LINES) type STRING_TABLE .
  methods GET_LINE
    returning
      value(RV_LINE) type STRING .
  methods GET_LINE_COUNT
    returning
      value(RV_COUNT) type I .
  methods GET_ROW_SEPARATOR
    importing
      !IV_TEXT type STRING
      !IV_COUNT type I
    returning
      value(RV_SEPARATOR) type STRING .
  methods GET_MARKDOWN
    importing
      !IV_LINE_SEPARATOR type STRING optional
    returning
      value(RV_MARKDOWN) type STRING .
  methods GET_END_OF_LINE
    returning
      value(RV_EOL) type STRING .
  methods GET_PARAMETERS
    returning
      value(RO_PARAMS) type ref to ZIF_BTOCS_VALUE_STRUCTURE .
  methods GET_LAST_HEADER_LEVEL
    returning
      value(RV_LEVEL) type I .
  methods GET_LAST_CHAR
    importing
      !IV_IN type STRING
    returning
      value(RV_LAST) type STRING .
  methods SET_MARKDOWN
    importing
      !IV_MARKDOWN type STRING
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods SET
    importing
      !IV_TEXT type STRING
      !IV_CHECK_SPACE_BEFORE type ABAP_BOOL default ABAP_TRUE
      !IV_ADD_SPACE_AFTER type ABAP_BOOL default ABAP_TRUE
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods SET_LINE
    importing
      !IV_LINE type STRING
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods SET_END_OF_LINE
    importing
      !IV_EOL type STRING default '\n'
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods SET_STYLE_TABLE
    importing
      !IV_STYLE type STRING
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods SET_STYLE_STRUCTURE
    importing
      !IV_STYLE type STRING
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods SET_LAST_HEADER_LEVEL
    importing
      !IV_LEVEL type I
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods TEXT
    importing
      !IV_TEXT type STRING
      !IV_CHECK_SPACE_BEFORE type ABAP_BOOL default ABAP_TRUE
      !IV_ADD_SPACE_AFTER type ABAP_BOOL default ABAP_TRUE
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods BOLD
    importing
      !IV_TEXT type STRING
      !IV_CHECK_SPACE_BEFORE type ABAP_BOOL default ABAP_TRUE
      !IV_ADD_SPACE_AFTER type ABAP_BOOL default ABAP_TRUE
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods BOLD_ITALIC
    importing
      !IV_TEXT type STRING
      !IV_CHECK_SPACE_BEFORE type ABAP_BOOL default ABAP_TRUE
      !IV_ADD_SPACE_AFTER type ABAP_BOOL default ABAP_TRUE
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods ITALIC
    importing
      !IV_TEXT type STRING
      !IV_CHECK_SPACE_BEFORE type ABAP_BOOL default ABAP_TRUE
      !IV_ADD_SPACE_AFTER type ABAP_BOOL default ABAP_TRUE
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods CODE
    importing
      !IV_TEXT type STRING
      !IV_CHECK_SPACE_BEFORE type ABAP_BOOL default ABAP_TRUE
      !IV_ADD_SPACE_AFTER type ABAP_BOOL default ABAP_TRUE
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods IMAGE
    importing
      !IV_URL type STRING
      !IV_TEXT type STRING optional
      !IV_CHECK_SPACE_BEFORE type ABAP_BOOL default ABAP_TRUE
      !IV_ADD_SPACE_AFTER type ABAP_BOOL default ABAP_TRUE
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods LINK
    importing
      !IV_URL type STRING
      !IV_TEXT type STRING optional
      !IV_DESC type STRING optional
      !IV_CHECK_SPACE_BEFORE type ABAP_BOOL default ABAP_TRUE
      !IV_ADD_SPACE_AFTER type ABAP_BOOL default ABAP_TRUE
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods CLOSE
    importing
      !IV_CHAR type STRING default '.'
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods ADD
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods ADD_TEXT
    importing
      !IV_TEXT type STRING
      !IV_LINE_SEPARATOR type STRING optional
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods ADD_IMAGE
    importing
      !IV_URL type STRING
      !IV_TEXT type STRING optional
      !IV_PREFIX type STRING optional
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods ADD_CODE_LINES
    importing
      !IT_CODE type STRING_TABLE
      !IV_CODE_TYPE type STRING optional
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods ADD_STRUCTURE
    importing
      !IS_DATA type DATA
      !IV_STYLE type STRING optional
      !IV_NO_EMPTY type ABAP_BOOL default ABAP_TRUE
      !IV_PREFIX type STRING default '-'
      !IV_SEPARATOR type STRING default ':'
      !IV_PATH type STRING optional
      !IV_CURRENT_LEVEL type I optional
      !IV_MAX_LEVEL type I optional
      !IT_HEADERS type ZBTOCS_T_KEY_VALUE optional
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods ADD_TABLE
    importing
      !IT_DATA type TABLE
      !IV_STYLE type STRING optional
      !IV_NO_EMPTY type ABAP_BOOL default ABAP_TRUE
      !IV_PATH type STRING optional
      !IV_CURRENT_LEVEL type I optional
      !IV_MAX_LEVEL type I optional
      !IT_HEADERS type ZBTOCS_T_KEY_VALUE optional
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods ADD_LINES
    importing
      !IT_LINES type STRING_TABLE
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods ADD_EMPTY_LINE
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods ADD_ROW_SEPARATOR
    importing
      !IV_TEXT type STRING
      !IV_COUNT type I default 1
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods ADD_HEADER
    importing
      !IV_TEXT type STRING
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods ADD_SUBHEADER
    importing
      !IV_TEXT type STRING
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods ADD_HEADER_RELATIVE
    importing
      !IV_DELTA type I default 0
      !IV_TEXT type STRING
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods ADD_H1
    importing
      !IV_TEXT type STRING
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods ADD_H2
    importing
      !IV_TEXT type STRING
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods ADD_H3
    importing
      !IV_TEXT type STRING
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods ADD_H4
    importing
      !IV_TEXT type STRING
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods ADD_HX
    importing
      !IV_TEXT type STRING
      !IV_LEVEL type I
      !IV_SAVE_LEVEL type ABAP_BOOL default ABAP_TRUE
    returning
      value(RO_SELF) type ref to ZIF_BTOCS_UTIL_MARKDOWN .
  methods TO_STRING
    importing
      !IV_LINE_SEPARATOR type STRING default '\n'
    returning
      value(RV_STRING) type STRING .
  methods TO_HTML
    importing
      !IO_EXIT type ref to ZIF_BTOCS_EXIT_RENDER_HTML optional
      !IV_EXIT_NAME type STRING optional
      !IV_COMPLETE type ABAP_BOOL default ABAP_TRUE
    returning
      value(RV_HTML) type STRING .
endinterface.
