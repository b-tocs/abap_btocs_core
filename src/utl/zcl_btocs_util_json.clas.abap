class ZCL_BTOCS_UTIL_JSON definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_UTIL_JSON .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTOCS_UTIL_JSON IMPLEMENTATION.


  METHOD zif_btocs_util_json~new_parser.
    ro_parser ?= zcl_btocs_factory=>create_instance( 'ZIF_BTOCS_JSON_PARSER' ).
    ro_parser->set_logger( get_logger( ) ).
  ENDMETHOD.
ENDCLASS.
