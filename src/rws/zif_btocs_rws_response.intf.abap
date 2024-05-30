INTERFACE zif_btocs_rws_response
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

  METHODS get_status_code
    RETURNING
      VALUE(rv_status) TYPE i .
  METHODS get_reason
    RETURNING
      VALUE(rv_reason) TYPE string .
  METHODS get_header_fields
    RETURNING
      VALUE(rt_header) TYPE tihttpnvp .
  METHODS get_form_fields
    RETURNING
      VALUE(rt_form_fields) TYPE tihttpnvp .
  METHODS get_content_type
    RETURNING
      VALUE(rv_content_type) TYPE string .
  METHODS get_content
    RETURNING
      VALUE(rv_content) TYPE string .
  METHODS get_binary
    RETURNING
      VALUE(rv_binary) TYPE xstring .
  METHODS set_reason
    IMPORTING
      !iv_reason      TYPE data
      !iv_no_formward TYPE abap_bool DEFAULT abap_false .
  METHODS set_status_code
    IMPORTING
      !iv_status_code TYPE i DEFAULT 500 .
  METHODS set_from_client
    IMPORTING
      !io_http_client   TYPE REF TO if_http_client
    RETURNING
      VALUE(rv_success) TYPE abap_bool .
  METHODS set_from_response
    IMPORTING
      !io_http_response TYPE REF TO if_http_response
    RETURNING
      VALUE(rv_success) TYPE abap_bool .
  METHODS is_http_request_success
    RETURNING
      VALUE(rv_success) TYPE abap_bool .
  METHODS is_binary
    RETURNING
      VALUE(rv_binary) TYPE abap_bool .
  METHODS is_json_response
    IMPORTING
      !iv_prepare    TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(rv_json) TYPE abap_bool .
  METHODS is_json_object
    RETURNING
      VALUE(rv_json_object) TYPE abap_bool .

  METHODS is_json_array
    RETURNING
      VALUE(rv_json_array) TYPE abap_bool .

  METHODS is_form_fields
    RETURNING
      VALUE(rv_form_fields) TYPE abap_bool .
  METHODS is_header_fields
    RETURNING
      VALUE(rv_header_fields) TYPE abap_bool .
  METHODS get_values_from_parsed_json
    RETURNING
      VALUE(ro_value) TYPE REF TO zif_btocs_value .
  METHODS get_binary_as_file
    IMPORTING
      !iv_filename        TYPE string
      !iv_short_filename  TYPE abap_bool DEFAULT abap_true
      !iv_detect_mimetype TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(rs_file)      TYPE zbtocs_s_file_data .
ENDINTERFACE.
