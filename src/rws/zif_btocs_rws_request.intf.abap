INTERFACE zif_btocs_rws_request
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

  CONSTANTS:
    BEGIN OF c_form_encoding,
      none               TYPE i VALUE 0,                 " not set
      raw                TYPE i VALUE 1,                 " SAP form_encoding_raw
      urlencoded         TYPE i VALUE 2,           " SAP form_encoding_encoded
      multipart_formdata TYPE i VALUE 100, " added for multipart/form-data
    END OF c_form_encoding .

  METHODS set_client
    IMPORTING
      !io_http_client   TYPE REF TO if_http_client
    RETURNING
      VALUE(rv_success) TYPE abap_bool .
  METHODS set_data
    IMPORTING
      !iv_content_type  TYPE string OPTIONAL
      !iv_content       TYPE string OPTIONAL
      !iv_binary        TYPE xstring OPTIONAL
    RETURNING
      VALUE(rv_success) TYPE abap_bool .
  METHODS set_data_encoded
    IMPORTING
      !iv_content_type  TYPE string DEFAULT 'application/json'
      !iv_content       TYPE string
      !iv_codepage      TYPE abap_encoding DEFAULT '4110'
    RETURNING
      VALUE(rv_success) TYPE abap_bool .
  METHODS clear .
  METHODS set_header_fields
    IMPORTING
      !it_header TYPE tihttpnvp .
  METHODS add_header_field
    IMPORTING
      !iv_name          TYPE data
      !iv_value         TYPE data
    RETURNING
      VALUE(rv_success) TYPE abap_bool .
  METHODS set_header_field
    IMPORTING
      !iv_name          TYPE data
      !iv_value         TYPE data
      !iv_overwrite     TYPE abap_bool DEFAULT abap_false
    RETURNING
      VALUE(rv_success) TYPE abap_bool .
  METHODS get_header_fields
    RETURNING
      VALUE(rt_header) TYPE tihttpnvp .
  METHODS add_query_param
    IMPORTING
      !iv_name          TYPE data
      VALUE(iv_value)   TYPE data
    RETURNING
      VALUE(rv_success) TYPE abap_bool .
  METHODS get_query_params
    RETURNING
      VALUE(rt_params) TYPE tihttpnvp .
  METHODS add_form_field
    IMPORTING
      !iv_name          TYPE data
      !iv_value         TYPE data
    RETURNING
      VALUE(rv_success) TYPE abap_bool .
  METHODS add_form_field_file
    IMPORTING
      !iv_name          TYPE data
      !iv_binary        TYPE xstring
      !iv_filename      TYPE string OPTIONAL
      !iv_content_type  TYPE string OPTIONAL
    RETURNING
      VALUE(rv_success) TYPE abap_bool .
  METHODS set_form_field
    IMPORTING
      !iv_name          TYPE data
      !iv_value         TYPE data OPTIONAL
      !iv_overwrite     TYPE abap_bool DEFAULT abap_false
      !iv_binary        TYPE xstring OPTIONAL
      !iv_content_type  TYPE string OPTIONAL
      !iv_filename      TYPE string OPTIONAL
    RETURNING
      VALUE(rv_success) TYPE abap_bool .
  METHODS add_form_fields
    IMPORTING
      !it_fields              TYPE tihttpnvp
      !iv_content_type        TYPE string DEFAULT 'application/x-www-form-urlencoded'
      !iv_form_field_encoding TYPE i DEFAULT if_http_entity=>co_formfield_encoding_encoded
    RETURNING
      VALUE(rv_success)       TYPE abap_bool .
  METHODS get_form_fields
    RETURNING
      VALUE(rt_fields) TYPE tihttpnvp .
  METHODS get_form_fields_with_bin
    RETURNING
      VALUE(rt_fields) TYPE zbtocs_t_form_data .
  METHODS set_form_type
    IMPORTING
      !iv_content_type        TYPE string DEFAULT 'application/x-www-form-urlencoded'
      !iv_form_field_encoding TYPE i DEFAULT if_http_entity=>co_formfield_encoding_encoded .
  METHODS set_form_type_urlencoded .
  METHODS set_form_type_multipart .
  METHODS get_value_manager
    RETURNING
      VALUE(ro_mgr) TYPE REF TO zif_btocs_value_mgr .

  METHODS new_json_object
    IMPORTING
      !is_options     TYPE zbtocs_typ_s_value_options OPTIONAL
    RETURNING
      VALUE(ro_value) TYPE REF TO zif_btocs_value_structure .
  METHODS new_json_array
    IMPORTING
      !is_options     TYPE zbtocs_typ_s_value_options OPTIONAL
    RETURNING
      VALUE(ro_value) TYPE REF TO zif_btocs_value_array .

ENDINTERFACE.
