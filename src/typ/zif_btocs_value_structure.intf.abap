INTERFACE zif_btocs_value_structure
  PUBLIC .


  INTERFACES zif_btocs_util_base .
  INTERFACES zif_btocs_value .

  ALIASES destroy
    FOR zif_btocs_value~destroy .
  ALIASES get_array_value
    FOR zif_btocs_value~get_array_value .
  ALIASES get_data_ref
    FOR zif_btocs_value~get_data_ref .
  ALIASES get_logger
    FOR zif_btocs_value~get_logger .
  ALIASES get_manager
    FOR zif_btocs_value~get_manager .
  ALIASES get_object_ref
    FOR zif_btocs_value~get_object_ref .
  ALIASES get_options
    FOR zif_btocs_value~get_options .
  ALIASES get_structure_value
    FOR zif_btocs_value~get_structure_value .
  ALIASES is_data
    FOR zif_btocs_value~is_data .
  ALIASES is_logger_external
    FOR zif_btocs_value~is_logger_external .
  ALIASES is_object
    FOR zif_btocs_value~is_object .
  ALIASES is_options
    FOR zif_btocs_value~is_options .
  ALIASES render
    FOR zif_btocs_value~render .
  ALIASES set_data_ref
    FOR zif_btocs_value~set_data_ref .
  ALIASES set_logger
    FOR zif_btocs_value~set_logger .
  ALIASES set_manager
    FOR zif_btocs_value~set_manager .
  ALIASES set_object_ref
    FOR zif_btocs_value~set_object_ref .
  ALIASES set_options
    FOR zif_btocs_value~set_options .
  ALIASES set_string
    FOR zif_btocs_value~set_string .

  METHODS set
    IMPORTING
      !iv_name          TYPE string
      !io_value         TYPE REF TO zif_btocs_value
      !iv_mapped        TYPE string OPTIONAL
      !iv_overwrite     TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(rv_success) TYPE abap_bool .
  METHODS get
    IMPORTING
      !iv_name         TYPE string
    EXPORTING
      VALUE(ev_mapped) TYPE string
    RETURNING
      VALUE(ro_value)  TYPE REF TO zif_btocs_value .
  METHODS count
    RETURNING
      VALUE(rv_count) TYPE i .
  METHODS has_name
    IMPORTING
      !iv_name         TYPE string
    RETURNING
      VALUE(rv_exists) TYPE abap_bool .
  METHODS clear .
  METHODS get_string
    IMPORTING
      !iv_name         TYPE data
    RETURNING
      VALUE(rv_string) TYPE string .

  METHODS get_string_value
    IMPORTING
      !iv_name        TYPE data
    RETURNING
      VALUE(ro_value) TYPE REF TO zif_btocs_value_string .

  METHODS get_number_value
    IMPORTING
      !iv_name        TYPE data
    RETURNING
      VALUE(ro_value) TYPE REF TO zif_btocs_value_number .


  METHODS get_boolean_value
    IMPORTING
      !iv_name        TYPE data
    RETURNING
      VALUE(ro_value) TYPE REF TO zif_btocs_value_boolean .



ENDINTERFACE.
