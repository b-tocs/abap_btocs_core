class ZCL_BTOCS_VALUE definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_VALUE .
  interfaces ZIF_BTOCS_JSON .
protected section.

  data MO_MGR type ref to ZIF_BTOCS_VALUE_MGR .
  data MS_OPTIONS type ZBTOCS_TYP_S_VALUE_OPTIONS .
  data MR_DATA type ref to DATA .
  data MO_OBJECT type ref to OBJECT .

  methods GET_FORMAT
    importing
      !IV_FORMAT type STRING optional
    returning
      value(RV_FORMAT) type STRING .
  methods GET_KEY_ENCLOSE_CHAR
    returning
      value(RV_CHAR) type STRING .
  methods RENDER_STRING
    importing
      !IV_ENCLOSED type ABAP_BOOL default ABAP_FALSE
    returning
      value(RV_STRING) type STRING .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_VALUE IMPLEMENTATION.


  METHOD get_format.
    IF iv_format IS NOT INITIAL.
      rv_format = iv_format.
    ELSE.
      DATA(ls_options) = zif_btocs_value~get_options( ).
      IF ls_options-render_format IS INITIAL.
        rv_format = zif_btocs_value=>c_format-json.
      ELSE.
        rv_format = ls_options-render_format.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  method GET_KEY_ENCLOSE_CHAR.
    rv_char = '"'.
  endmethod.


  METHOD render_string.

* ---- prepare options
    DATA(ls_options) = zif_btocs_value~get_options( ).
    DATA(lv_prefix)  = ls_options-render_prefix.
    DATA(lv_postfix) = ls_options-render_postfix.

    IF get_format( ) = zif_btocs_value=>c_format-json.
      IF lv_prefix IS INITIAL.
        lv_prefix = '"'.
      ENDIF.
      IF lv_postfix IS INITIAL.
        lv_postfix = '"'.
      ENDIF.
    ENDIF.


* ----- render
    ASSIGN mr_data->* to FIELD-SYMBOL(<lv_data>).
    IF mr_data IS NOT INITIAL.
      rv_string = CONV string( <lv_data> ).
    ENDIF.
    IF iv_enclosed = abap_true.
      rv_string = |{ lv_prefix }{ rv_string }{ lv_postfix }|.
    ENDIF.

  ENDMETHOD.


  method ZIF_BTOCS_VALUE~GET_DATA_REF.
    rr_data_ref = mr_data.
  endmethod.


  METHOD zif_btocs_value~get_manager.
    ro_mgr = mo_mgr.
  ENDMETHOD.


  method ZIF_BTOCS_VALUE~GET_OBJECT_REF.
    ro_object_ref = mo_object.
  endmethod.


  METHOD zif_btocs_value~get_options.
    IF ms_options IS NOT INITIAL.
      rs_option = ms_options.
    ELSE.
      IF mo_mgr IS NOT INITIAL.
        rs_option = mo_mgr->get_options( ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


  method ZIF_BTOCS_VALUE~IS_DATA.
    if mr_data is NOT INITIAL.
      rv_data = abap_true.
    ENDIF.
  endmethod.


  METHOD zif_btocs_value~is_null.
    IF mo_object IS INITIAL
      AND mr_data IS INITIAL.
      rv_null = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_value~is_object.
    IF mo_object IS NOT INITIAL.
      rv_object = abap_true.
    ENDIF.
  ENDMETHOD.


  method ZIF_BTOCS_VALUE~IS_OPTIONS.
    if ms_options is not INITIAL.
      rv_available = abap_true.
    ENDIF.
  endmethod.


  METHOD zif_btocs_value~render.

* ------ prepare
    DATA(ls_option) = zif_btocs_value~get_options( ).
    DATA lr_object  TYPE REF TO zif_btocs_value.

* ------ default rendering
    data(lv_enc) = GET_KEY_ENCLOSE_CHAR( ).

    IF zif_btocs_value~is_null( ) EQ abap_true.
      rv_string = ls_option-render_null.
    ELSEIF zif_btocs_value~is_data( ) EQ abap_true.
      rv_string = render_string( iv_enclosed = iv_enclosed ).
      IF iv_name IS NOT INITIAL.
        rv_string = |{ lv_enc }{ iv_name }{ lv_enc }: { rv_string }|.
      ENDIF.
    ELSE.
      lr_object ?= mo_object.
      rv_string = lr_object->render(
                    iv_name   = iv_name
                    iv_format = iv_format
                    iv_level  = iv_level
                  ).
    ENDIF.
  ENDMETHOD.


  method ZIF_BTOCS_VALUE~SET_DATA_REF.
    mr_data = ir_data_ref.
    clear mo_object.
  endmethod.


  method ZIF_BTOCS_VALUE~SET_MANAGER.
    mo_mgr = io_mgr.
  endmethod.


  METHOD zif_btocs_value~set_object_ref.
    mo_object = io_object_ref.
  ENDMETHOD.


  METHOD zif_btocs_value~set_options.
    ms_options = is_option.
  ENDMETHOD.


  METHOD zif_btocs_value~set_string.
    CLEAR mo_object.
    CREATE DATA mr_data TYPE string.
    ASSIGN mr_data->* TO FIELD-SYMBOL(<lv_data>).
    <lv_data> = iv_string.
  ENDMETHOD.


  method ZIF_BTOCS_JSON~GET_DATA.
    lr_data = mr_data.
  endmethod.


  METHOD zif_btocs_json~get_data_type.
    rv_type = zif_btocs_json~data_type.
  ENDMETHOD.


  METHOD zif_btocs_json~is_null.
    IF mr_data IS INITIAL
      AND mo_object IS INITIAL.
      rv_null = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_json~to_string.
    rv_string = zif_btocs_value~render(
*                  iv_name     =
*                  iv_format   =
*                  iv_level    =
                  iv_enclosed = abap_true
                ).
  ENDMETHOD.


  METHOD zif_btocs_value~get_array_value.
    TRY.
        ro_array ?= me.
      CATCH cx_root INTO DATA(lxc_exc).
        DATA(lv_error) = lxc_exc->get_text( ).
        get_logger( )->error( |error while determine array value: { lv_error }| ).
    ENDTRY.
  ENDMETHOD.


  METHOD zif_btocs_value~get_string.
    IF mr_data IS NOT INITIAL.
      ASSIGN mr_data->* to FIELD-SYMBOL(<lv_data>).
      rv_string = CONV string( <lv_data> ).
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_value~get_structure_value.
    TRY.
        ro_structure ?= me.
      CATCH cx_root INTO DATA(lxc_exc).
        DATA(lv_error) = lxc_exc->get_text( ).
        get_logger( )->error( |error while determine structure value: { lv_error }| ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
