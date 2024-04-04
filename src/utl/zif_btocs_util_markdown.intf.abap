INTERFACE zif_btocs_util_markdown
  PUBLIC .


  INTERFACES zif_btocs_util_base .

  ALIASES destroy
    FOR zif_btocs_util_base~destroy .
  ALIASES get_logger
    FOR zif_btocs_util_base~get_logger .
  ALIASES is_logger_external
    FOR zif_btocs_util_base~is_logger_external .
  ALIASES set_logger
    FOR zif_btocs_util_base~set_logger .

  METHODS reset .
  METHODS get_lines_count
    RETURNING
      VALUE(rv_count) TYPE i .
  METHODS get_lines
    RETURNING
      VALUE(rt_lines) TYPE string_table .
  METHODS get_line
    RETURNING
      VALUE(rv_line) TYPE string .
  METHODS get_line_count
    RETURNING
      VALUE(rv_count) TYPE i .
  METHODS get_row_separator
    IMPORTING
      !iv_text            TYPE string
      !iv_count           TYPE i
    RETURNING
      VALUE(rv_separator) TYPE string .
  METHODS get_markdown
    IMPORTING
      !iv_line_separator TYPE string OPTIONAL
    RETURNING
      VALUE(rv_markdown) TYPE string .
  METHODS get_end_of_line
    RETURNING
      VALUE(rv_eol) TYPE string .
  METHODS get_parameters
    RETURNING
      VALUE(ro_params) TYPE REF TO zif_btocs_value_structure .
  METHODS get_last_header_level
    RETURNING
      VALUE(rv_level) TYPE i .
  METHODS get_last_char
    IMPORTING
      !iv_in         TYPE string
    RETURNING
      VALUE(rv_last) TYPE string .
  METHODS set_markdown
    IMPORTING
      !iv_markdown   TYPE string
    RETURNING
      VALUE(ro_self) TYPE REF TO zif_btocs_util_markdown .
  METHODS set
    IMPORTING
      !iv_text               TYPE string
      !iv_check_space_before TYPE abap_bool DEFAULT abap_true
      !iv_add_space_after    TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(ro_self)         TYPE REF TO zif_btocs_util_markdown .
  METHODS set_line
    IMPORTING
      !iv_line       TYPE string
    RETURNING
      VALUE(ro_self) TYPE REF TO zif_btocs_util_markdown .
  METHODS set_end_of_line
    IMPORTING
      !iv_eol        TYPE string DEFAULT '\n'
    RETURNING
      VALUE(ro_self) TYPE REF TO zif_btocs_util_markdown .
  METHODS text
    IMPORTING
      !iv_text               TYPE string
      !iv_check_space_before TYPE abap_bool DEFAULT abap_true
      !iv_add_space_after    TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(ro_self)         TYPE REF TO zif_btocs_util_markdown .
  METHODS bold
    IMPORTING
      !iv_text               TYPE string
      !iv_check_space_before TYPE abap_bool DEFAULT abap_true
      !iv_add_space_after    TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(ro_self)         TYPE REF TO zif_btocs_util_markdown .
  METHODS bold_italic
    IMPORTING
      !iv_text               TYPE string
      !iv_check_space_before TYPE abap_bool DEFAULT abap_true
      !iv_add_space_after    TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(ro_self)         TYPE REF TO zif_btocs_util_markdown .
  METHODS italic
    IMPORTING
      !iv_text               TYPE string
      !iv_check_space_before TYPE abap_bool DEFAULT abap_true
      !iv_add_space_after    TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(ro_self)         TYPE REF TO zif_btocs_util_markdown .
  METHODS code
    IMPORTING
      !iv_text               TYPE string
      !iv_check_space_before TYPE abap_bool DEFAULT abap_true
      !iv_add_space_after    TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(ro_self)         TYPE REF TO zif_btocs_util_markdown .
  METHODS image
    IMPORTING
      !iv_url                TYPE string
      !iv_text               TYPE string OPTIONAL
      !iv_check_space_before TYPE abap_bool DEFAULT abap_true
      !iv_add_space_after    TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(ro_self)         TYPE REF TO zif_btocs_util_markdown .
  METHODS link
    IMPORTING
      !iv_url                TYPE string
      !iv_text               TYPE string OPTIONAL
      !iv_desc               TYPE string OPTIONAL
      !iv_check_space_before TYPE abap_bool DEFAULT abap_true
      !iv_add_space_after    TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(ro_self)         TYPE REF TO zif_btocs_util_markdown .
  METHODS close
    IMPORTING
      !iv_char       TYPE string DEFAULT '.'
    RETURNING
      VALUE(ro_self) TYPE REF TO zif_btocs_util_markdown .
  METHODS add
    RETURNING
      VALUE(ro_self) TYPE REF TO zif_btocs_util_markdown .
  METHODS add_text
    IMPORTING
      !iv_text           TYPE string
      !iv_line_separator TYPE string OPTIONAL
    RETURNING
      VALUE(ro_self)     TYPE REF TO zif_btocs_util_markdown .
  METHODS add_image
    IMPORTING
      !iv_url        TYPE string
      !iv_text       TYPE string OPTIONAL
      !iv_prefix     TYPE string OPTIONAL
    RETURNING
      VALUE(ro_self) TYPE REF TO zif_btocs_util_markdown .
  METHODS add_code_lines
    IMPORTING
      !it_code       TYPE string_table
      !iv_code_type  TYPE string OPTIONAL
    RETURNING
      VALUE(ro_self) TYPE REF TO zif_btocs_util_markdown .
  METHODS add_structure
    IMPORTING
      !is_data          TYPE data
      !iv_style         TYPE string OPTIONAL
      !iv_no_empty      TYPE abap_bool DEFAULT abap_true
      !iv_prefix        TYPE string DEFAULT '-'
      !iv_separator     TYPE string DEFAULT ':'
      !iv_path          TYPE string OPTIONAL
      !iv_current_level TYPE i OPTIONAL
      !iv_max_level     TYPE i OPTIONAL
      !it_headers       TYPE zbtocs_t_key_value OPTIONAL
    RETURNING
      VALUE(ro_self)    TYPE REF TO zif_btocs_util_markdown .
  METHODS add_lines
    IMPORTING
      !it_lines      TYPE string_table
    RETURNING
      VALUE(ro_self) TYPE REF TO zif_btocs_util_markdown .
  METHODS add_empty_line
    RETURNING
      VALUE(ro_self) TYPE REF TO zif_btocs_util_markdown .
  METHODS add_row_separator
    IMPORTING
      !iv_text       TYPE string
      !iv_count      TYPE i DEFAULT 1
    RETURNING
      VALUE(ro_self) TYPE REF TO zif_btocs_util_markdown .
  METHODS add_header
    IMPORTING
      !iv_text       TYPE string
    RETURNING
      VALUE(ro_self) TYPE REF TO zif_btocs_util_markdown .
  METHODS add_subheader
    IMPORTING
      !iv_text       TYPE string
    RETURNING
      VALUE(ro_self) TYPE REF TO zif_btocs_util_markdown .
  METHODS add_header_relative
    IMPORTING
      !iv_delta      TYPE i DEFAULT 0
      !iv_text       TYPE string
    RETURNING
      VALUE(ro_self) TYPE REF TO zif_btocs_util_markdown .
  METHODS add_h1
    IMPORTING
      !iv_text       TYPE string
    RETURNING
      VALUE(ro_self) TYPE REF TO zif_btocs_util_markdown .
  METHODS add_h2
    IMPORTING
      !iv_text       TYPE string
    RETURNING
      VALUE(ro_self) TYPE REF TO zif_btocs_util_markdown .
  METHODS add_h3
    IMPORTING
      !iv_text       TYPE string
    RETURNING
      VALUE(ro_self) TYPE REF TO zif_btocs_util_markdown .
  METHODS add_h4
    IMPORTING
      !iv_text       TYPE string
    RETURNING
      VALUE(ro_self) TYPE REF TO zif_btocs_util_markdown .
  METHODS add_hx
    IMPORTING
      !iv_text       TYPE string
      !iv_level      TYPE i
      !iv_save_level TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(ro_self) TYPE REF TO zif_btocs_util_markdown .
  METHODS to_string
    IMPORTING
      !iv_line_separator TYPE string DEFAULT '\n'
    RETURNING
      VALUE(rv_string)   TYPE string .
  METHODS to_html
    IMPORTING
      !io_exit       TYPE REF TO zif_btocs_exit_render_html OPTIONAL
      !iv_exit_name  TYPE string OPTIONAL
      !iv_complete   TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(rv_html) TYPE string .
ENDINTERFACE.
