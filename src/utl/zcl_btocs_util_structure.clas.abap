class ZCL_BTOCS_UTIL_STRUCTURE definition
  public
  inheriting from ZCL_BTOCS_UTIL_BASE
  create public .

public section.

  interfaces ZIF_BTOCS_UTIL_STRUCTURE .
protected section.

  data MO_TYPE_DESCR type ref to CL_ABAP_STRUCTDESCR .
  data MR_DATA type ref to DATA .
  data MT_DDIC type DDFIELDS .
  data MT_FIELD_UTILS type ZBTOCS_T_FIELD_UTIL_CACHE .
  data MV_LANGUAGE type SYLANGU .
  data MV_INCL_SUB type FLAG value ABAP_FALSE ##NO_TEXT.

  methods INIT_FIELD_UTILS
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_UTIL_STRUCTURE IMPLEMENTATION.


  METHOD zif_btocs_util_structure~get_ddic.
* ----- check cache
    IF mt_ddic[] IS NOT INITIAL.
      rt_ddic = mt_ddic.
      RETURN.
    ENDIF.

* ------ get from decr
    IF mo_type_descr IS NOT INITIAL.
      mo_type_descr->get_ddic_field_list(
        EXPORTING
          p_langu                  = mv_language         " Current language
          p_including_substructres = mv_incl_sub       " List Also for Substructures
        RECEIVING
          p_field_list             = mt_ddic                 " List of Dictionary Descriptions for the Components
        EXCEPTIONS
          not_found                = 1                " Type could not be found
          no_ddic_type             = 2                " Typ is not a dictionary type
          OTHERS                   = 3
      ).
      IF sy-subrc EQ 0.
* ------- init internal cache
        rt_ddic = mt_ddic.
        IF init_field_utils( ) EQ abap_false.
          get_logger( )->error( |building field util cache failed| ).
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  method ZIF_BTOCS_UTIL_STRUCTURE~GET_DDIC_FIELDNAME.
    data(lt_ddic) = ZIF_BTOCS_UTIL_STRUCTURE~get_ddic( ).
    READ table lt_ddic into rs_ddic with key fieldname = iv_fieldname.
  endmethod.


  METHOD zif_btocs_util_structure~get_fieldnames.
    DATA(lt_ddic) = zif_btocs_util_structure~get_ddic( ).
    LOOP AT lt_ddic ASSIGNING FIELD-SYMBOL(<ls_ddic>).
      IF <ls_ddic>-fieldname IS NOT INITIAL
        AND NOT <ls_ddic>-fieldname CP '.*'.
        APPEND <ls_ddic>-fieldname TO rt_names.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD zif_btocs_util_structure~get_fieldnames_not_empty.
    DATA(lt_fnames) = zif_btocs_util_structure~get_fieldnames( ).
    LOOP AT lt_fnames ASSIGNING FIELD-SYMBOL(<lv_fname>).
      IF zif_btocs_util_structure~is_empty( <lv_fname> ) NE abap_true.
        APPEND <lv_fname> TO rt_names.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD zif_btocs_util_structure~get_label.
    DATA(ls_ddic) = zif_btocs_util_structure~get_ddic_fieldname( iv_fieldname ).
    IF ls_ddic IS INITIAL.
      rv_label = iv_fieldname.
    ELSE.
      IF ls_ddic-reptext IS NOT INITIAL.
        rv_label = ls_ddic-reptext.
      ELSEIF ls_ddic-scrtext_l IS NOT INITIAL.
        rv_label = ls_ddic-scrtext_l.
      ELSEIF ls_ddic-scrtext_m IS NOT INITIAL.
        rv_label = ls_ddic-scrtext_m.
      ELSEIF ls_ddic-scrtext_l IS NOT INITIAL.
        rv_label = ls_ddic-scrtext_m.
      ELSE.
        rv_label = iv_fieldname.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  method ZIF_BTOCS_UTIL_STRUCTURE~GET_STRUCTDESCR.
    ro_type_descr = mo_type_descr.
  endmethod.


  METHOD zif_btocs_util_structure~is_empty.
    IF mr_data IS NOT INITIAL.
      ASSIGN mr_data->* TO FIELD-SYMBOL(<ls_data>).
      ASSIGN COMPONENT iv_fieldname OF STRUCTURE <ls_data> TO FIELD-SYMBOL(<lv_field>).
      IF <lv_field> IS ASSIGNED
        AND <lv_field> IS INITIAL.
        rv_empty = abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_util_structure~is_fieldname.
    IF mr_data IS NOT INITIAL.
      ASSIGN mr_data->* TO FIELD-SYMBOL(<ls_data>).
      ASSIGN COMPONENT iv_fieldname OF STRUCTURE <ls_data> TO FIELD-SYMBOL(<lv_field>).
      IF <lv_field> IS ASSIGNED.
        rv_exists = abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_util_structure~reset.
    CLEAR: mo_type_descr,
           mr_data,
           mt_ddic,
           mt_field_utils.
  ENDMETHOD.


  METHOD zif_btocs_util_structure~set_data.
    zif_btocs_util_structure~reset( ).
    TRY.
        mo_type_descr ?= cl_abap_structdescr=>describe_by_data( is_data ).
        rv_success = abap_true.

        CREATE DATA mr_data LIKE is_data.
        ASSIGN mr_data->* TO FIELD-SYMBOL(<ls_data>).
        MOVE-CORRESPONDING is_data TO <ls_data>.

      CATCH cx_root INTO DATA(lx_exc).
        DATA(lv_error) = lx_exc->get_text( ).
        get_logger( )->error( lv_error ).
    ENDTRY.
  ENDMETHOD.


  METHOD zif_btocs_util_structure~set_name.
    zif_btocs_util_structure~reset( ).
    TRY.
        mo_type_descr ?= cl_abap_structdescr=>describe_by_name( iv_name ).
        rv_success = abap_true.

        CREATE DATA mr_data TYPE (iv_name).
        ASSIGN mr_data->* TO FIELD-SYMBOL(<ls_data>).

      CATCH cx_root INTO DATA(lx_exc).
        DATA(lv_error) = lx_exc->get_text( ).
        get_logger( )->error( lv_error ).
    ENDTRY.

  ENDMETHOD.


  METHOD init_field_utils.

* ------- init and check
    CLEAR: mt_field_utils.
    IF mt_ddic[] IS INITIAL
      OR mr_data IS INITIAL.
      get_logger( )->error( |structure not initialized for building field util cache| ).
      RETURN.
    ENDIF.


* ------- loop and build cache
    ASSIGN mr_data->* TO FIELD-SYMBOL(<ls_data>).
    DATA ls_cache LIKE LINE OF mt_field_utils.

    LOOP AT mt_ddic ASSIGNING FIELD-SYMBOL(<ls_ddic>).

      ASSIGN COMPONENT <ls_ddic>-fieldname OF STRUCTURE <ls_data> TO FIELD-SYMBOL(<lv_field>).
      IF <lv_field> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

      DATA(lo_fld_util) = zcl_btocs_factory=>create_ddic_field_util( ).
      lo_fld_util->set_logger( get_logger( ) ).

      IF lo_fld_util->set_data(
        EXPORTING
          iv_data    = <lv_field>
          is_ddic    = <ls_ddic>                 " DD Interface: Table Fields for DDIF_FIELDINFO_GET
      ) EQ abap_false.
        get_logger( )->warning( |init field util for { <ls_ddic>-fieldname } failed| ).
      ELSE.
        ls_cache-field_util = lo_fld_util.
        ls_cache-fieldname  = <ls_ddic>-fieldname.
        APPEND ls_cache TO mt_field_utils.
      ENDIF.


    ENDLOOP.

* ------- set success
    rv_success = COND #( WHEN mt_field_utils[] IS NOT INITIAL
                         THEN abap_true
                         ELSE abap_false ).

  ENDMETHOD.


  METHOD zif_btocs_util_structure~get_field.
    DATA(lt_ddic) = zif_btocs_util_structure~get_ddic( ).
    IF mt_field_utils[] IS NOT INITIAL.
      READ TABLE mt_field_utils ASSIGNING FIELD-SYMBOL(<ls_cache>)
        WITH KEY fieldname = iv_fieldname.
      IF sy-subrc EQ 0.
        ro_util = <ls_cache>-field_util.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_util_structure~get_value.
    IF mr_data IS NOT INITIAL.
      ASSIGN mr_data->* TO FIELD-SYMBOL(<ls_data>).
      ASSIGN COMPONENT iv_fieldname OF STRUCTURE <ls_data> TO FIELD-SYMBOL(<lv_field>).
      IF <lv_field> IS ASSIGNED.
        rv_value = |{ <lv_field> }|.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_util_structure~set_value.
    IF mr_data IS NOT INITIAL.
      ASSIGN mr_data->* TO FIELD-SYMBOL(<ls_data>).
      ASSIGN COMPONENT iv_fieldname OF STRUCTURE <ls_data> TO FIELD-SYMBOL(<lv_field>).
      IF <lv_field> IS ASSIGNED.
        <lv_field> = iv_value.
        rv_success = abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
