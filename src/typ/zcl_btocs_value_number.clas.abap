class ZCL_BTOCS_VALUE_NUMBER definition
  public
  inheriting from ZCL_BTOCS_VALUE
  create public .

public section.

  interfaces ZIF_BTOCS_VALUE_NUMBER .
protected section.

  methods RENDER_STRING
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_BTOCS_VALUE_NUMBER IMPLEMENTATION.


  method RENDER_STRING.

* ----- render
    IF mr_data IS NOT INITIAL.
      rv_string = CONV string( mr_data->* ).
    ENDIF.
  endmethod.


  METHOD zif_btocs_value_number~set_number.
    CLEAR mo_object.
    CREATE DATA mr_data LIKE iv_number.
    mr_data->* = iv_number.
  ENDMETHOD.
ENDCLASS.
