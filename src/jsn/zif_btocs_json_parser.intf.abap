INTERFACE zif_btocs_json_parser
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

  METHODS parse
    IMPORTING
              !iv_json       TYPE string
              !ir_extension  TYPE REF TO zif_btocs_json_extension OPTIONAL
    RETURNING VALUE(ro_json) TYPE REF TO zif_btocs_json.


ENDINTERFACE.
