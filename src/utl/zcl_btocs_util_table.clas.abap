class ZCL_BTOCS_UTIL_TABLE definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_UTIL_TABLE .
protected section.

  data MO_STRUC_UTIL type ref to ZIF_BTOCS_UTIL_STRUCTURE .
  data MO_TYPE_DESCR type ref to CL_ABAP_TABLEDESCR .
  data MR_DATA type ref to DATA .
  data MR_TABLE type ref to DATA .
  data MT_CONTENT type ZBTOCS_T_TABLE_CONTENT .
  data MT_METAINFO type ZBTOCS_T_TABLE_METAINFO .
  data MO_DDIC_UTIL type ref to ZIF_BTOCS_UTIL_DDIC .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_UTIL_TABLE IMPLEMENTATION.


  method ZIF_BTOCS_UTIL_TABLE~GET_DATA_REF.
    rr_data = mr_table.
  endmethod.


  method ZIF_BTOCS_UTIL_TABLE~GET_FIELDNAMES.
    if mo_struc_util is NOT INITIAL.
      rt_names = mo_struc_util->get_fieldnames( ).
    ENDIF.
  endmethod.


  METHOD zif_btocs_util_table~get_fieldnames_not_empty.
    IF mt_metainfo[] IS NOT INITIAL.
      LOOP AT mt_metainfo ASSIGNING FIELD-SYMBOL(<ls_meta>)
        WHERE count_filled > 0.
        APPEND <ls_meta>-fieldname TO rt_names.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  method ZIF_BTOCS_UTIL_TABLE~GET_PARSED_CONTENT.
    rt_content = mt_content.
  endmethod.


  METHOD zif_btocs_util_table~get_parsed_content_row.
    LOOP AT mt_content ASSIGNING FIELD-SYMBOL(<ls_content>)
        WHERE table_row = iv_row.
      APPEND <ls_content> TO rt_content.
    ENDLOOP.
  ENDMETHOD.


  method ZIF_BTOCS_UTIL_TABLE~GET_PARSED_METAINFO.
    rt_metainfo = mt_metainfo.
  endmethod.


  METHOD zif_btocs_util_table~get_structure_util.
    ro_util = mo_struc_util.
  ENDMETHOD.


  method ZIF_BTOCS_UTIL_TABLE~GET_TABLEDESCR.
    ro_type_descr = mo_type_descr.
  endmethod.


  METHOD zif_btocs_util_table~parse.

* ------ init
    CLEAR: mt_content,
           mt_metainfo.


* ------ check
    IF mr_table IS INITIAL
      OR mr_data IS INITIAL
      OR mo_struc_util IS INITIAL.
      get_logger( )->error( |table not initialized| ).
      RETURN.
    ENDIF.

* ------ bind
    FIELD-SYMBOLS: <lt_data> TYPE table.
    ASSIGN mr_table->* TO <lt_data>.
    ASSIGN mr_data->* TO FIELD-SYMBOL(<ls_data>).


* ------ init meta
    DATA(lt_ddic) = mo_struc_util->get_ddic( ).
    IF lt_ddic[] IS INITIAL.
      get_logger( )->error( |ddic info not available| ).
      RETURN.
    ENDIF.

    LOOP AT lt_ddic ASSIGNING FIELD-SYMBOL(<ls_ddic>).
      APPEND INITIAL LINE TO mt_metainfo ASSIGNING FIELD-SYMBOL(<ls_meta>).
      MOVE-CORRESPONDING <ls_ddic> TO <ls_meta>.
      DATA(lo_field) = mo_struc_util->get_field( CONV string( <ls_meta>-fieldname ) ).
      <ls_meta>-is_not_printable = lo_field->is_not_printable( ).
    ENDLOOP.

* ----- parse table
    DATA ls_content LIKE LINE OF mt_content.
    LOOP AT <lt_data> ASSIGNING <ls_data>.
      DATA(lv_tabix) = sy-tabix.

      mo_struc_util->set_structure_data( <ls_data> ).

* ----- check row of table
      LOOP AT mt_metainfo ASSIGNING <ls_meta>.

*       check field
        ADD 1 TO <ls_meta>-count_all.
        lo_field = mo_struc_util->get_field(
          iv_fieldname = CONV string( <ls_meta>-fieldname )
          iv_no_cache  = abap_true
        ).
        IF lo_field IS INITIAL
          OR lo_field->is_not_printable( ) EQ abap_true.
          ADD 1 TO <ls_meta>-count_empty.
          CONTINUE.
        ENDIF.

        IF lo_field->is_empty( ) EQ abap_true.
          ADD 1 TO <ls_meta>-count_empty.
        ELSE.
          ADD 1 TO <ls_meta>-count_filled.
        ENDIF.

        ls_content-value     = lo_field->get_value( ).
        ls_content-text_all  = lo_field->get_user_text( <ls_data> ).

        DATA(lv_len_val) = strlen( ls_content-value ).
        IF lv_len_val > <ls_meta>-max_text_len_val.
          <ls_meta>-max_text_len_val = lv_len_val.
        ENDIF.

        DATA(lv_len_all) = strlen( ls_content-text_all ).
        IF lv_len_all > <ls_meta>-max_text_len_all.
          <ls_meta>-max_text_len_all = lv_len_all.
        ENDIF.

        IF iv_no_content EQ abap_false.

          IF ls_content-value IS NOT INITIAL
            OR ls_content-text_all IS NOT INITIAL.
            ls_content-table_row    = lv_tabix.
            ls_content-fieldname    = <ls_meta>-fieldname.
            ls_content-unit         = lo_field->get_unit( <ls_data> ).
            ls_content-description  = lo_field->get_value_text( ).

            APPEND ls_content TO mt_content.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    rv_success = abap_true.
  ENDMETHOD.


  METHOD zif_btocs_util_table~reset.
    CLEAR: mo_type_descr,
           mo_struc_util,
           mr_table,
           mr_data,
           mt_content,
           mt_metainfo.
  ENDMETHOD.


  METHOD zif_btocs_util_table~set_data.

* ---- init
    zif_btocs_util_table~reset( ).

    TRY.
        mo_type_descr ?= cl_abap_tabledescr=>describe_by_data( it_data ).

        CREATE DATA mr_table LIKE it_data.
        FIELD-SYMBOLS: <lt_data> TYPE table.
        ASSIGN mr_table->* TO <lt_data>.

        IF iv_store_data EQ abap_true.
          <lt_data> = it_data.
        ENDIF.

        CREATE DATA mr_data LIKE LINE OF <lt_data>.
        ASSIGN mr_data->* TO FIELD-SYMBOL(<ls_data>).

        mo_struc_util = zcl_btocs_factory=>create_ddic_structure_util( ).
        rv_success = mo_struc_util->set_data(
            is_data         = <ls_data>
        ).

      CATCH cx_root INTO DATA(lx_exc).
        DATA(lv_error) = lx_exc->get_text( ).
        get_logger( )->error( lv_error ).
    ENDTRY.

  ENDMETHOD.


  METHOD zif_btocs_util_table~set_data_ref.
    mr_table = ir_table.
  ENDMETHOD.


  METHOD zif_btocs_util_table~set_name.
    zif_btocs_util_table~reset( ).
    TRY.
        mo_type_descr ?= cl_abap_tabledescr=>describe_by_name( iv_name ).

        CREATE DATA mr_table TYPE TABLE OF (iv_name).
        FIELD-SYMBOLS: <lt_data> TYPE table.
        ASSIGN mr_table->* TO <lt_data>.

        CREATE DATA mr_data LIKE LINE OF <lt_data>.
        ASSIGN mr_data->* TO FIELD-SYMBOL(<ls_data>).

        mo_struc_util = zcl_btocs_factory=>create_ddic_structure_util( ).
        rv_success = mo_struc_util->set_data(
            is_data         = <ls_data>
        ).

      CATCH cx_root INTO DATA(lx_exc).
        DATA(lv_error) = lx_exc->get_text( ).
        get_logger( )->error( lv_error ).
    ENDTRY.
  ENDMETHOD.


  METHOD zif_btocs_util_table~get_ddic_util.
    IF mo_ddic_util IS INITIAL.
      mo_ddic_util = zcl_btocs_factory=>create_ddic_util( ).
      mo_ddic_util->set_logger( get_logger( ) ).
    ENDIF.
    ro_util = mo_ddic_util.
  ENDMETHOD.


  method ZIF_BTOCS_UTIL_TABLE~SET_DDIC_UTIL.
    mo_ddic_util = io_util.
  endmethod.
ENDCLASS.
