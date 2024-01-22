class ZCL_BTOCS_VALUE_BOOLEAN definition
  public
  inheriting from ZCL_BTOCS_VALUE
  create public .

public section.

  interfaces ZIF_BTOCS_VALUE_BOOLEAN .

  methods ZIF_BTOCS_VALUE~RENDER
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTOCS_VALUE_BOOLEAN IMPLEMENTATION.


  METHOD zif_btocs_value~render.
* ------ prepare
    DATA(ls_option) = zif_btocs_value~get_options( ).
    DATA lr_object  TYPE REF TO zif_btocs_value.

* ------ default rendering
    DATA(lv_enc) = get_key_enclose_char( ).

    IF zif_btocs_value~is_null( ) EQ abap_true.
      rv_string = ls_option-render_null.
    ELSEIF zif_btocs_value~is_data( ) EQ abap_true.
      ASSIGN mr_data->* TO FIELD-SYMBOL(<lv_bool>).
      DATA(lv_bool) = to_upper( <lv_bool> ).
      IF lv_bool EQ 'X'
        OR lv_bool EQ 'TRUE'
        OR lv_bool EQ '1'.
        rv_string = 'true'.
      ELSE.
        rv_string = 'false'.
      ENDIF.

      IF iv_name IS NOT INITIAL.
        rv_string = |"{ iv_name }": { rv_string }|.
      ENDIF.

    ELSE.
* ---- not possible
      rv_string = ls_option-render_null.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
