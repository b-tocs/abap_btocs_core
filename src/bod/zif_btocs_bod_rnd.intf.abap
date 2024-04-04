INTERFACE zif_btocs_bod_rnd
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

  TYPES: ty_detail_level TYPE i.
  CONSTANTS:
    BEGIN OF c_detail_level,
      default     TYPE ty_detail_level VALUE 0,
      abstract    TYPE ty_detail_level VALUE 1,
      small       TYPE ty_detail_level VALUE 2,
      medium      TYPE ty_detail_level VALUE 3,
      large       TYPE ty_detail_level VALUE 4,
      extra_large TYPE ty_detail_level VALUE 5,
    END OF c_detail_level.


  METHODS set_context
    IMPORTING
      !iv_type          TYPE data
      !iv_id            TYPE data
      !it_context       TYPE zbtocs_t_key_value
    RETURNING
      VALUE(rv_success) TYPE abap_bool .

  METHODS render
    IMPORTING
      !io_doc          TYPE REF TO zif_btocs_bod_doc OPTIONAL
      !iv_detail_level TYPE ty_detail_level DEFAULT c_detail_level-default
    RETURNING
      VALUE(ro_doc)    TYPE REF TO zif_btocs_bod_doc .


  METHODS get_id
    RETURNING
      VALUE(rv_id) TYPE string .

  METHODS get_title
    RETURNING
      VALUE(rv_id) TYPE string .

  METHODS get_type
    RETURNING
      VALUE(rv_type) TYPE string .
  METHODS get_context
    RETURNING
      VALUE(rt_context) TYPE zbtocs_t_key_value .
ENDINTERFACE.
