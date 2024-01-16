class ZCL_BTOCS_VALUE_STRUCTURE definition
  public
  inheriting from ZCL_BTOCS_VALUE
  create public .

public section.

  interfaces ZIF_BTOCS_VALUE_STRUCTURE .

  methods ZIF_BTOCS_VALUE~RENDER
    redefinition .
protected section.

  data MT_DATA type ZBTOCS_TYP_T_VALUE_STRUCTURE .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_VALUE_STRUCTURE IMPLEMENTATION.


  method ZIF_BTOCS_VALUE_STRUCTURE~CLEAR.
    clear mt_data.
  endmethod.


  method ZIF_BTOCS_VALUE_STRUCTURE~COUNT.
    rv_count = lines( mt_data ).
  endmethod.


  method ZIF_BTOCS_VALUE_STRUCTURE~GET.
    READ TABLE mt_data ASSIGNING FIELD-SYMBOL(<ls_data>)
      with key name = iv_name.
    if sy-subrc = 0.
      ro_value = <ls_data>-value.
      ev_mapped = <ls_data>-mapped_name.
    endif.
  endmethod.


  METHOD zif_btocs_value_structure~has_name.
    READ TABLE mt_data ASSIGNING FIELD-SYMBOL(<ls_data>)
      WITH KEY name = iv_name.
    IF sy-subrc = 0.
      rv_exists = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_value_structure~set.
    READ TABLE mt_data ASSIGNING FIELD-SYMBOL(<ls_data>)
      WITH KEY name = iv_name.
    IF sy-subrc = 0.
      IF iv_overwrite EQ abap_false.
        get_logger( )->error( |structure name { iv_name } exists| ).
        RETURN.
      ENDIF.
    ELSE.
      APPEND INITIAL LINE TO mt_data ASSIGNING <ls_data>.
      <ls_data>-name = iv_name.
    ENDIF.
    <ls_data>-value       = io_value.
    <ls_data>-mapped_name = iv_mapped.
  ENDMETHOD.


  METHOD zif_btocs_value~render.

    DATA(lv_enc) = get_key_enclose_char( ).
    DATA(lv_format) = get_format( iv_format ).

    CASE lv_format.
      WHEN zif_btocs_value=>c_format-json.
        rv_string = '{'.

        DATA(lv_data) = ||.
        DATA(lv_level) = iv_level + 1.
        LOOP AT mt_data ASSIGNING FIELD-SYMBOL(<ls_data>).
          DATA(lv_line) = <ls_data>-value->render(
                             iv_name     = <ls_data>-name
                             iv_level    = lv_level
                             iv_enclosed = abap_true
                           ).
          IF lv_data IS INITIAL.
            lv_data = lv_line.
          ELSE.
            lv_data = |{ lv_data }, { lv_line }|.
          ENDIF.
        ENDLOOP.

        rv_string = rv_string && lv_data && '}'.
        IF iv_name IS NOT INITIAL.
          rv_string = |{ lv_enc }{ iv_name }{ lv_enc }: { rv_string }|.
        ENDIF.
      WHEN OTHERS.
        get_logger( )->error( |unknown render format for structure| ).
    ENDCASE.
  ENDMETHOD.


  METHOD zif_btocs_value_structure~get_string.
    IF zif_btocs_value_structure~has_name( iv_name ) EQ abap_false.
      RETURN.
    ELSE.
      DATA(lo_value) = zif_btocs_value_structure~get( iv_name ).
      rv_string = lo_value->get_string( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
