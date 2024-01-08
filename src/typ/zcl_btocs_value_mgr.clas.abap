class ZCL_BTOCS_VALUE_MGR definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_VALUE_MGR .
protected section.

  data MS_OPTION type ZBTOCS_TYP_S_VALUE_OPTIONS .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_VALUE_MGR IMPLEMENTATION.


  METHOD zif_btocs_value_mgr~get_default_json_options.
    rs_option-render_format   = zif_btocs_value=>c_format-json.
    rs_option-render_prefix   = '"'.
    rs_option-render_postfix  = '"'.
    rs_option-render_null     = 'null'.
  ENDMETHOD.


  method ZIF_BTOCS_VALUE_MGR~GET_OPTIONS.
    rs_option = ms_option.
  endmethod.


  METHOD zif_btocs_value_mgr~new_json_object.

* ------ prepare options
    DATA(ls_options) = COND #( WHEN is_options IS NOT INITIAL
                               THEN is_options
                               ELSE ms_option ).
    IF ls_options IS INITIAL
      OR ls_options-render_format <> zif_btocs_value=>c_format-json.
      ls_options = zif_btocs_value_mgr~get_default_json_options( ).
    ENDIF.

* ------ create object
    ro_value ?= zcl_btocs_factory=>create_instance( 'ZIF_BTOCS_VALUE_STRUCTURE' ).
    ro_value->set_logger( get_logger( ) ).
    ro_value->set_manager( me ).
    ro_value->set_options( ls_options ).

  ENDMETHOD.


  METHOD zif_btocs_value_mgr~new_string.
* ------ create object
    ro_value ?= zcl_btocs_factory=>create_instance( 'ZIF_BTOCS_VALUE_STRING' ).
    ro_value->set_logger( get_logger( ) ).
    ro_value->set_manager( me ).
    ro_value->set_string( iv_string ).
  ENDMETHOD.


  method ZIF_BTOCS_VALUE_MGR~SET_OPTIONS.
    ms_option = is_option.
  endmethod.


  method ZIF_BTOCS_VALUE_MGR~NEW_BOOLEAN.
* ------ create object
    ro_value ?= zcl_btocs_factory=>create_instance( 'ZIF_BTOCS_VALUE_BOOLEAN' ).
    ro_value->set_logger( get_logger( ) ).
    ro_value->set_manager( me ).
    ro_value->set_string( iv_boolean ).
  endmethod.


  METHOD zif_btocs_value_mgr~new_json_array.
* ------ prepare options
    DATA(ls_options) = COND #( WHEN is_options IS NOT INITIAL
                               THEN is_options
                               ELSE ms_option ).
    IF ls_options IS INITIAL
      OR ls_options-render_format <> zif_btocs_value=>c_format-json.
      ls_options = zif_btocs_value_mgr~get_default_json_options( ).
    ENDIF.

* ------ create object
    ro_value ?= zcl_btocs_factory=>create_instance( 'ZIF_BTOCS_VALUE_ARRAY' ).
    ro_value->set_logger( get_logger( ) ).
    ro_value->set_manager( me ).
    ro_value->set_options( ls_options ).
  ENDMETHOD.


  method ZIF_BTOCS_VALUE_MGR~NEW_NUMBER.
* ------ create object
    ro_value ?= zcl_btocs_factory=>create_instance( 'ZIF_BTOCS_VALUE_NUMBER' ).
    ro_value->set_logger( get_logger( ) ).
    ro_value->set_manager( me ).
    ro_value->set_string( iv_number ).
  endmethod.
ENDCLASS.
