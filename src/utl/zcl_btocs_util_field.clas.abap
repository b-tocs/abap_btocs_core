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


  method ZIF_BTOCS_UTIL_FIELD~GET_VALUE_TEXT.
    "Todo
  endmethod.


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
ENDCLASS.
