class ZCL_BTOCS_VALUE_ARRAY definition
  public
  inheriting from ZCL_BTOCS_VALUE
  create public .

public section.

  interfaces ZIF_BTOCS_VALUE_ARRAY .

  methods ZIF_BTOCS_VALUE~RENDER
    redefinition .
protected section.

  data MT_DATA type ZBTOCS_TYP_T_VALUE_ARRAY .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_VALUE_ARRAY IMPLEMENTATION.


  METHOD zif_btocs_value_array~add.
    APPEND INITIAL LINE TO mt_data ASSIGNING FIELD-SYMBOL(<ls_data>).
    <ls_data>-value   = io_value.
    <ls_data>-ref_id  = iv_ref_id.
    rv_count = lines( mt_data ).
  ENDMETHOD.


  method ZIF_BTOCS_VALUE_ARRAY~CLEAR.
    clear mt_data.
  endmethod.


  METHOD zif_btocs_value_array~count.
    rv_count = lines( mt_data ).
  ENDMETHOD.


  METHOD zif_btocs_value_array~get.
    IF iv_index < 1 OR iv_index > zif_btocs_value_array~count( ).
      get_logger( )->error( |invalid array index { iv_index }| ).
      RETURN.
    ELSE.
      READ TABLE mt_data INDEX iv_index
        ASSIGNING FIELD-SYMBOL(<ls_data>).
      ro_value  = <ls_data>-value.
      ev_ref_id = <ls_data>-ref_id.
    ENDIF.
  ENDMETHOD.


  METHOD zif_btocs_value~render.

* ----- raw rendering
    IF mv_raw_value IS NOT INITIAL.
      rv_string = super->zif_btocs_value~render(
        EXPORTING
          iv_name     = iv_name
          iv_format   = iv_format
          iv_level    = iv_level
          iv_enclosed = abap_true
      ).
      RETURN.
    ENDIF.


* ------ normal rendering
    DATA(lv_enc) = get_key_enclose_char( ).
    DATA(lv_format) = get_format( iv_format ).

    CASE lv_format.
      WHEN zif_btocs_value=>c_format-json.
        rv_string = '['.

        DATA(lv_data) = ||.
        DATA(lv_level) = iv_level + 1.
        LOOP AT mt_data ASSIGNING FIELD-SYMBOL(<ls_data>).
          DATA(lv_line) = <ls_data>-value->render(
                             iv_level    = lv_level
                             iv_enclosed = abap_true
                           ).
          IF lv_data IS INITIAL.
            lv_data = lv_line.
          ELSE.
            lv_data = |{ lv_data }, { lv_line }|.
          ENDIF.
        ENDLOOP.

        rv_string = rv_string && lv_data && ']'.
        IF iv_name IS NOT INITIAL.
          rv_string = |{ lv_enc }{ iv_name }{ lv_enc }: { rv_string }|.
        ENDIF.
      WHEN OTHERS.
        get_logger( )->error( |unknown render format for array| ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
