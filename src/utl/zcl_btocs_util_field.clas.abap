class ZCL_BTOCS_UTIL_FIELD definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_UTIL_FIELD .

  constants GC_TYPES_NOT_PRINTABLE type STRING value 'uvhrljkz' ##NO_TEXT.
protected section.

  data MO_TYPE_DESCR type ref to CL_ABAP_DATADESCR .
  data MR_DATA type ref to DATA .
  data MS_DDIC type DFIES .
  data MV_FIELDNAME type STRING .
  data MV_INT_TYPE type INTTYPE .
  data MO_DDIC_UTIL type ref to ZIF_BTOCS_UTIL_DDIC .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_UTIL_FIELD IMPLEMENTATION.


  method ZIF_BTOCS_UTIL_FIELD~GET_DATADESCR.
    ro_type_descr = mo_type_descr.
  endmethod.


  METHOD zif_btocs_util_field~get_ddic.
    rs_ddic = ms_ddic.
  ENDMETHOD.


  METHOD zif_btocs_util_field~get_label.
    DATA(ls_ddic) = zif_btocs_util_field~get_ddic( ).
    IF ls_ddic IS INITIAL.
      rv_label = mv_fieldname.
    ELSE.
      IF ls_ddic-scrtext_l IS NOT INITIAL.
        rv_label = ls_ddic-scrtext_l.
      ELSEIF ls_ddic-scrtext_m IS NOT INITIAL.
        rv_label = ls_ddic-scrtext_m.
      ELSEIF ls_ddic-reptext IS NOT INITIAL.
        rv_label = ls_ddic-reptext.
      ELSEIF ls_ddic-scrtext_s IS NOT INITIAL.
        rv_label = ls_ddic-scrtext_s.
      ELSE.
        rv_label = mv_fieldname.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_util_field~get_value.
    TRY.
        IF zif_btocs_util_field~is_not_printable( ) EQ abap_true.
          RETURN.
        ENDIF.

        IF mr_data IS NOT INITIAL.
          ASSIGN mr_data->* TO FIELD-SYMBOL(<lv_data>).
          IF <lv_data> IS ASSIGNED.
            rv_value = |{ <lv_data> }|.
          ENDIF.
        ENDIF.
      CATCH cx_root INTO DATA(lx_exc).
        DATA(lv_error) = lx_exc->get_text( ).
        get_logger( )->error( |error while get field value as string| ).
    ENDTRY.
  ENDMETHOD.


  METHOD zif_btocs_util_field~get_value_text.
* ------ check ms
    IF ms_ddic IS INITIAL
      OR ms_ddic-f4availabl NE abap_true.
      RETURN.
    ENDIF.

* ------ prepare
    DATA(lv_lang) = zif_btocs_util_field~get_ddic_util( )->lang_get_default( ).


* ------ f4
    IF ms_ddic-tabname IS NOT INITIAL
      AND ms_ddic-fieldname IS NOT INITIAL
      AND ms_ddic-f4availabl EQ abap_true.
      rv_text = zif_btocs_util_field~get_ddic_util( )->f4_table_field_get_text(
          iv_table      = ms_ddic-tabname
          iv_field      = ms_ddic-fieldname
          iv_code       = iv_value
          iv_lang       = lv_lang
*        iv_lang2      =
          iv_try_others = abap_true
*        iv_no_cache   = abap_false
*        iv_default    =
*      IMPORTING
*        ev_language   =                  " F4 Language (ISO)
*        et_f4         =                  " Table of F4 translations for codes
      ).
    ENDIF.


  ENDMETHOD.


  METHOD zif_btocs_util_field~is_ddic.
    IF ms_ddic IS NOT INITIAL.
      rv_ddic = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_util_field~is_empty.
    IF mr_data IS NOT INITIAL.
      ASSIGN mr_data->* TO FIELD-SYMBOL(<lv_data>).
      IF <lv_data> IS NOT ASSIGNED
        OR <lv_data> IS INITIAL.
        rv_empty = abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_util_field~reset.
    CLEAR: mr_data,
           ms_ddic,
           mv_int_type.
  ENDMETHOD.


  METHOD zif_btocs_util_field~set_data.
    TRY.
*       set context
        ms_ddic = is_ddic.
        mv_fieldname = iv_fieldname.
        IF mv_fieldname IS INITIAL
          AND ms_ddic-fieldname IS NOT INITIAL.
          mv_fieldname = ms_ddic-fieldname.
        ENDIF.

*       create value holder
        CREATE DATA mr_data LIKE iv_data.
        ASSIGN mr_data->* TO FIELD-SYMBOL(<lv_data>).
        <lv_data> = iv_data.


*       create type desc
        mo_type_descr ?= cl_abap_datadescr=>describe_by_data( iv_data ).
        DESCRIBE FIELD iv_data TYPE mv_int_type.

        rv_success = abap_true.
      CATCH cx_root INTO DATA(lx_exc).
        DATA(lv_error) = lx_exc->get_text( ).
        get_logger( )->error( |error in field util init: { lv_error }| ).
    ENDTRY.

  ENDMETHOD.


  method ZIF_BTOCS_UTIL_FIELD~GET_INT_TYPE.
    rv_type = mv_int_type.
  endmethod.


  METHOD zif_btocs_util_field~is_not_printable.
    IF mv_int_type CA gc_types_not_printable.
      rv_no_print = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_util_field~is_structure.
    IF mv_int_type CA 'uv'.
      rv_structure = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_util_field~is_table.
    IF mv_int_type EQ 'h'.
      rv_table = abap_true.
    ENDIF.
  ENDMETHOD.


  method ZIF_BTOCS_UTIL_FIELD~GET_UNIT.
* ---- check
    if is_data is INITIAL
      or ms_ddic is INITIAL.
      return.
    endif.
  endmethod.


  METHOD zif_btocs_util_field~get_user_text.

    rv_text = zif_btocs_util_field~get_value( ).

    DATA(lv_unit) = zif_btocs_util_field~get_unit( is_data ).
    IF lv_unit IS NOT INITIAL.
      rv_text = |{ rv_text } { lv_unit }|.
    ENDIF.

    DATA(lv_desc) = zif_btocs_util_field~get_value_text( ).
    IF lv_desc IS NOT INITIAL.
      rv_text = |{ rv_text } - { lv_desc }|.
    ENDIF.

    IF iv_label EQ abap_true.
      DATA(lv_label) = zif_btocs_util_field~get_label( ).
      IF lv_label IS NOT INITIAL.
        rv_text = |{ lv_label }{ iv_label_separator }{ rv_text }|.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  method ZIF_BTOCS_UTIL_FIELD~GET_DDIC_UTIL.
    IF mo_ddic_util IS INITIAL.
      mo_ddic_util = zcl_btocs_factory=>create_ddic_util( ).
      mo_ddic_util->set_logger( get_logger( ) ).
    ENDIF.
    ro_util = mo_ddic_util.
  endmethod.


  METHOD zif_btocs_util_field~set_ddic_util.
    mo_ddic_util = io_util.
  ENDMETHOD.
ENDCLASS.
